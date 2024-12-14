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
            ["gray"] = 200,
            ["blue"] = 100,
            ["golden"] = 10,
            ["colourful"] = 1,
            -- ["gray"] = 1,
            -- ["blue"] = 1,
            -- ["golden"] = 1,
            -- ["colourful"] = 1,
        }
    -------------------------------------------
    --- 获取个数。
        self.items_default_num = 8 -- 默认获取个数。
        self.items_num_per_level = 8 -- 每级增加个数。

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
    --- 特价物品
        self.special_price_item_index = nil
        inst:WatchWorldState("cycles",function()
            self.special_price_item_index = nil
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
--- 特价商品的记忆
    local function s_deepcopy(orig)
        local orig_type = type(orig)
        local copy
        if orig_type == 'table' then
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                copy[s_deepcopy(orig_key)] = s_deepcopy(orig_value)
            end
            setmetatable(copy, s_deepcopy(getmetatable(orig)))
        else -- number, string, boolean, etc.
            copy = orig
        end
        return copy
    end
    function hoshino_com_shop_items_pool:Set_Special_Price(_items_data)
        -------------------------------------------------------
        --- 需要深度复制，避免污染原始数据池
            local items_data = s_deepcopy(_items_data)
        -------------------------------------------------------
        --- 如果记忆有 特价物品，则寻找数据里
            if self.special_price_item_index then
                for k, item_data in pairs(items_data) do
                    local index = item_data.index
                    if index == self.special_price_item_index then
                        item_data.price = math.ceil(item_data.price * 0.5)
                        item_data.special_price = true
                        break
                    end
                end
            elseif math.random(1000)/1000 <= 0.3 or TUNING.HOSHINO_DEBUGGING_MODE then
                --- 没有特价商品，则随机一个
                for i = 1, 50, 1 do  -- 最多尝试50次
                    local temp_item_data = items_data[math.random(#items_data)]
                    if temp_item_data.price >= 2 then
                        temp_item_data.price = math.ceil(temp_item_data.price * 0.5)
                        temp_item_data.special_price = true
                        self.special_price_item_index = temp_item_data.index
                        break
                    end
                end
            end
        -------------------------------------------------------
        return s_deepcopy(items_data)
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
            local prefab = item_data.prefab
            if self.pool[index] == nil and self.level >= level and not is_permanent and PrefabExists(prefab) then
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
        local random_value = math.random(1, total_probability)
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
        local temp_num = 0 --- 当前已经生成的物品数量
        local temp_test_num = 5000  --- 最多尝试生成5000次
        while true do
            local item_type = self:GetRandomTypeFromPool() or "gray"
            local ret_item_data = self:GetRandomItem(item_type)
            if ret_item_data then
                self.pool[ret_item_data.index] = ret_item_data
                temp_num = temp_num + 1                    
            end
            temp_test_num = temp_test_num - 1
            if temp_num >= items_num or temp_test_num <= 0 then
                break
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
            -- print("刷新商店物品池")
        end
        --- 洗掉index
        local ret = {}
        for index, item_data in pairs(self.pool) do
            table.insert(ret, item_data)
        end
        ----------------------------------------------------------
        -- 特价商品处理
            -- if math.random(1000)/1000 <= 0.3 or TUNING.HOSHINO_DEBUGGING_MODE then
            --     --- 需要深度复制，避免污染原始数据池
            --     ret = deepcopy(ret)
            --     --- 随机一个商品(价格大于2) 打折
            --     for i = 1, 50, 1 do
            --         local temp_item_data = ret[math.random(#ret)]
            --         if temp_item_data.price >= 2 then
            --             temp_item_data.price = math.ceil(temp_item_data.price * 0.5)
            --             temp_item_data.special_price = true
            --             break
            --         end
            --     end
            -- end
            ret = self:Set_Special_Price(ret)
        ----------------------------------------------------------
        -- print("随机物品数量", #ret)
        --- 添加常驻物品
        local permanent_list = self:GetPermanentList()
        for k, v in pairs(permanent_list) do
            table.insert(ret, v)
        end
        -- print("常驻物品数量", #permanent_list)
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







