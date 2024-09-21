----------------------------------------------------------------------------------------------------------------------------------
--[[

    商品生产池。挂载全TheWorld。用于生产商品.

    数据池 主节点 ： TUNING.HOSHINO_SHOP_ITEMS_POOL

    4色物品区 ： gray  blue   golden   colorful
        TUNING.HOSHINO_SHOP_ITEMS_POOL["gray"] = {}
        TUNING.HOSHINO_SHOP_ITEMS_POOL["blue"] = {}
        TUNING.HOSHINO_SHOP_ITEMS_POOL["golden"] = {}
        TUNING.HOSHINO_SHOP_ITEMS_POOL["colourful"] = {}

    【注意】随机获取的时候，不要重复获取物品。

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_shop_items_pool = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}
    -------------------------------------------
    -- level
        self.level = 0
        self:AddOnSaveFn(function(self)
            self:Set("level",self.level)
        end)
        self:AddOnLoadFn(function(self)
            self.level = self:Get("level") or 0
        end)
    -------------------------------------------
    -- pool 物品池。
        self.pool = {}
        self:AddOnSaveFn(function(self)
            self:Set("pool",self.pool)
        end)
        self:AddOnLoadFn(function(self)
            self.pool = self:Get("pool") or {}
        end)
        inst:WatchWorldState("cycles",function()
            --- 每天重置列表。
        end)
    -------------------------------------------
    --- item_probability_pool 物品概率权重池：
        self.item_probability_pool  = {
            ["gray"] = 20,
            ["blue"] = 10,
            ["golden"] = 5,
            ["colourful"] = 1,
            -- ["gray"] = 1,
            -- ["blue"] = 1,
            -- ["golden"] = 1,
            -- ["colourful"] = 1,
        }
    -------------------------------------------
    --- 获取个数。
        self.items_default_num = 20 -- 默认获取个数。
        self.items_num_per_level = 5 -- 每级增加个数。

    -------------------------------------------
    --- 天数
        self.day = -1
        self:AddOnSaveFn(function(self)
            self:Set("day",self.day)
        end)
        self:AddOnLoadFn(function(self)
            self.day = self:Get("day") or 0
        end)
    -------------------------------------------
end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function hoshino_com_shop_items_pool:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function hoshino_com_shop_items_pool:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function hoshino_com_shop_items_pool:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function hoshino_com_shop_items_pool:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function hoshino_com_shop_items_pool:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function hoshino_com_shop_items_pool:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function hoshino_com_shop_items_pool:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------
---- level
    function hoshino_com_shop_items_pool:LevelDoDelta(num)
        self.level = math.clamp(self.level + ( num or 0 ),0,10000000)
        self.day = -1
    end
    function hoshino_com_shop_items_pool:GetLevel()
        return self.level
    end
    function hoshino_com_shop_items_pool:LevelSet(num)
        self.level = math.clamp(num or 0,0,10000000)
        self.day = -1
    end
------------------------------------------------------------------------------------------------------------------------------
--- 数据池获取
    function hoshino_com_shop_items_pool:GetRandomItem(item_type)
        item_type = item_type or "gray"
        local items_pool = TUNING.HOSHINO_SHOP_ITEMS_POOL[item_type]
        local temp_pool = {}
        for _,item_data in pairs(items_pool) do
            local index = item_data.index
            local is_permanent = item_data.is_permanent -- 常驻标记位
            local level = item_data.level or 0
            if self.pool[index] == nil and self.level >= level and not is_permanent then
                table.insert(temp_pool,item_data)
            end
        end
        if #temp_pool == 0 then
            return nil
        end
        return temp_pool[math.random(#temp_pool)]
    end
    function hoshino_com_shop_items_pool:GetRandomTypeFromPool()    -- 从 self.item_probability_pool 中随机获取一个物品类型
        local total_probability = 0
        for item_type, probability in pairs(self.item_probability_pool) do
            total_probability = total_probability + probability
        end
        local random_value = math.random(10, total_probability*10)/10
        for item_type, probability in pairs(self.item_probability_pool) do
            if random_value <= probability then
                return item_type
            end
            random_value = random_value - probability
        end
        return nil
    end
    function hoshino_com_shop_items_pool:GetItemsNum() --- 获取商品数量
        return self.items_default_num + self.level * self.items_num_per_level
    end
    function hoshino_com_shop_items_pool:SpawnNewList() --- 创建新的物品池
        local items_num = self:GetItemsNum()
        for i = 1, items_num, 1 do
            local item_type = self:GetRandomTypeFromPool() or "gray"
            local ret_item_data = self:GetRandomItem(item_type)
            if ret_item_data then
                self.pool[ret_item_data.index] = ret_item_data                    
            end
        end
    end
    function hoshino_com_shop_items_pool:GetPermanentList() --- 获取常驻物品列表
        local ret = {}
        for colour_type, v in pairs(self.item_probability_pool) do
            local current_items_pool = TUNING.HOSHINO_SHOP_ITEMS_POOL[colour_type] or {} -- 防止物品池为空
            for k, single_item_data in pairs(current_items_pool) do
                if single_item_data then
                    local is_permanent = single_item_data.is_permanent -- 常驻标记位
                    local level = single_item_data.level or 0
                    if is_permanent and self.level >= level then
                        table.insert(ret, single_item_data)
                    end
                end
            end
        end
        return ret
    end
    function hoshino_com_shop_items_pool:GetItemsList(new_force)    --- 外部获取物品池的入口API
        local today = TheWorld.state.cycles
        if today ~= self.day or new_force then
            self.pool = {}
            self:SpawnNewList(self.level)
            self.day = today
            print("刷新商店物品池")
        end
        --- 洗掉index
        local ret = {}
        for index, item_data in pairs(self.pool) do
            table.insert(ret, item_data)
        end
        --- 添加常驻物品
        local permanent_list = self:GetPermanentList()
        for k, v in pairs(permanent_list) do
            table.insert(ret, v)
        end
        return ret
    end
------------------------------------------------------------------------------------------------------------------------------
--- 官方的数据储存API
    function hoshino_com_shop_items_pool:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_com_shop_items_pool:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_shop_items_pool







