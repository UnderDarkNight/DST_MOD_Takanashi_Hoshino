----------------------------------------------------------------------------------------------------------------------------------
--[[

    商店系统

    数据挂载去 ThePlayer.HOSHINO_SHOP 。方便HUD调用。

    数据流转流程：
        · 从TheWorld组件获取原始的商品数据。数据来源 ：hoshino_com_shop_items_pool
        · 根据商店等级，获取等级合适的商品列表。 等级来源 ：hoshino_com_shop_items_pool
        · 根据玩家身上的buff加成，修正商品价格、数量。 本组件
        · 服务端RPC下发数据更新玩家客户端的数据。
        · 客户端RPC上传数据成功传输event
        · 服务端RPC下发界面打开命令。


    客户端需要得到的数据池：


        inst.HOSHINO_SHOP["normal_items"] = {
            [1] = {
                prefab = "log",
                name = STRINGS.NAMES[string.upper(prefab_name)], --- 自动补全。也可强制下发。
                bg = "item_slot_blue.tex", --- 背景颜色  item_slot_blue.tex  item_slot_colourful.tex  item_slot_golden.tex  item_slot_gray.tex
                icon = {atlas = "XXX.xml" , image = "XXX.tex" }, --- 图标
                right_click = false,    --- 客户端上传回来标记位。


                price = 100, --- 价格
                num_to_give = 1, --- 单次购买的数量。【注意】nil 自动处理为1。
                price_type = "credit_coins",  -- 货币需求。

                level = 0, --- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
                type = "normal", --- 类型。normal  special  。这个可以不下发。

                index = "log_credit_coins_100_1_blue",  --- 自动合并下发，用于相应购买事件，并索引到本参数表。

            },
        },
        inst.HOSHINO_SHOP["special_items"] = {
            [1] = {
                .....
            }
        },

]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local function GetReplicaCom(self)
        return self.inst.replica.hoshino_com_shop or self.inst.replica._.hoshino_com_shop
    end
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_shop = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}

    --------------------------------------------------------------
    -- 32位整数最大值
        self.u32_max = 4000000000
    --------------------------------------------------------------
    -- 数据初始化
        inst.HOSHINO_SHOP = inst.HOSHINO_SHOP or {}
    --------------------------------------------------------------
    -- 信用金币
        self.credit_coins = 0
        self:AddOnLoadFn(function()
            self.credit_coins = self:Get("credit_coins") or 0
        end)
        self:AddOnSaveFn(function()
            self:Set("credit_coins", self.credit_coins)
        end)
    --------------------------------------------------------------
    -- 刷新次数 ： 当前剩余次数，每天更新次数
        self.refresh_count_daily = 1
        self.refresh_count = 1
        self:AddOnSaveFn(function()
            self:Set("refresh_count_daily", self.refresh_count_daily)
            self:Set("refresh_count", self.refresh_count)
        end)
        self:AddOnLoadFn(function()
            self.refresh_count_daily = self:Get("refresh_count_daily") or 0
            self.refresh_count = self:Get("refresh_count") or 0
        end)
        inst:WatchWorldState("cycles",function()
            self.refresh_count = self.refresh_count_daily
            self:ShopData_Set("refresh_count",self.refresh_count)
        end)
        local refresh_cmd_lock_flag = true
        inst:ListenForEvent("hoshino_com_shop_refresh_button_clicked",function()
            if refresh_cmd_lock_flag then
                refresh_cmd_lock_flag = false
                self:Refresh_Clicked()
                inst:DoTaskInTime(1,function()
                    refresh_cmd_lock_flag = true
                end)
            end
        end)
    --------------------------------------------------------------
    -- 价格倍增器
        self.price_multiplier = SourceModifierList(self.inst)
    --------------------------------------------------------------
    --- 物品购买
        self.items_list = {}
        inst:ListenForEvent("hoshino_event.shop_item_buy",function(_,_table)
            local index = _table and _table.index
            local right_click = _table and _table.right_click
            local prefab = _table and _table.prefab
            print("shop_item_buy",index,right_click)
            if type(index) == "string" then
                self:ItemBuy(index,right_click)
            end
        end)
    --------------------------------------------------------------
end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function hoshino_com_shop:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function hoshino_com_shop:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function hoshino_com_shop:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function hoshino_com_shop:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function hoshino_com_shop:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function hoshino_com_shop:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function hoshino_com_shop:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------
---- RPC
    function hoshino_com_shop:GetRPC()
        return self.inst.components.hoshino_com_rpc_event
    end
    function hoshino_com_shop:ShopData_Set(index,data)  --- 为了避免RPC信道阻塞，做延时统一下发更新。
        if self.ShopData_Set_Task then
            
        else
            self.ShopData_Set_Task = self.inst:DoTaskInTime(0,function()
                self.ShopData_Set_Task = nil
                self:GetRPC():PushEvent("hoshino_com_shop_rpc_update",self.inst.HOSHINO_SHOP)
            end)    
        end
        self.inst.HOSHINO_SHOP[index] = data
    end
------------------------------------------------------------------------------------------------------------------------------
--- 价格倍增器计算(向上取整)
    function hoshino_com_shop:FixPriceWithMultiplier(origin_price)
        local multiplier = self.price_multiplier:Get()
        return math.ceil(origin_price * multiplier)
    end
------------------------------------------------------------------------------------------------------------------------------
--- 信用金币变更，注意unit32上限。
    function hoshino_com_shop:CreditCoinDelta(num)
        if self.__credit_coin_delta_fn then
            num = self.__credit_coin_delta_fn(self,num)
        end
        self.credit_coins = math.clamp(self.credit_coins + num,0,self.u32_max)
        self:ShopData_Set("credit_coins",self.credit_coins)
    end
    function hoshino_com_shop:GetCreditCoins()
        return self.credit_coins
    end
    function hoshino_com_shop:SetCreditCoinDeltaFn(fn)
        self.__credit_coin_delta_fn = fn
    end
------------------------------------------------------------------------------------------------------------------------------
--- 每日刷新次数
    function hoshino_com_shop:RefreshDaily_Delta(value)
        self.refresh_count_daily = math.clamp(self.refresh_count_daily + value,0,1000000)
        self.refresh_count = math.clamp(self.refresh_count + value,0,self.refresh_count_daily)
        self:ShopData_Set("refresh_count",self.refresh_count)
    end
    function hoshino_com_shop:Refresh_Delta(value)
        self.refresh_count = math.clamp(self.refresh_count + value,0,self.refresh_count_daily)
        self:ShopData_Set("refresh_count",self.refresh_count)
    end
    function hoshino_com_shop:GetRefreshCount()
        return self.refresh_count
    end
------------------------------------------------------------------------------------------------------------------------------
--- 刷新按键点击后执行。
    function hoshino_com_shop:Refresh_Clicked()
        if self:GetRefreshCount() <= 0 then
            return
        end
        self:Refresh_Delta(-1)
        -----------------------------------------------
        --- 执行刷新内容逻辑。
            self:Spawn_Items_List_And_Send_2_Client(true)
        -----------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------
--- 获取物品列表并修正价格。
    function hoshino_com_shop:GetItemsList(new_force)
        local items_list = TheWorld.components.hoshino_com_shop_items_pool:GetItemsList(new_force)
        for k, single_data in pairs(items_list) do
            single_data.price = self:FixPriceWithMultiplier(single_data.price)
        end
        return items_list
    end
    function hoshino_com_shop:Spawn_Items_List_And_Send_2_Client(new_force)
        local items_list = self:GetItemsList(new_force)
        self.items_list = items_list
        print("items_list num : ",#items_list)
        local normal_items = {}
        local special_items = {}
        for k, single_data in pairs(items_list) do
            if single_data.type == "normal" or single_data.type == nil then
                table.insert(normal_items,single_data)
            elseif single_data.type == "special" then
                table.insert(special_items,single_data)
            end                    
        end
        self:ShopData_Set("normal_items",normal_items)
        self:ShopData_Set("special_items",special_items)
    end
------------------------------------------------------------------------------------------------------------------------------
--- 物品购买 event
    function hoshino_com_shop:ItemBuy(index,right_click)
        local ret_item_data = nil
        for k, temp in pairs(self.items_list) do
            if temp.index == index then
                ret_item_data = temp
                break
            end
        end
        if ret_item_data == nil then
            print("error : hoshino_com_shop item index not found")
            return
        end

        local prefab = ret_item_data.prefab             --- 物品的prefab
        local price = ret_item_data.price               --- 物品价格
        local num_to_give = ret_item_data.num_to_give   --- 单次购买数量
        local price_type = ret_item_data.price_type     --- 货币类型
        -- print("buy item : ",prefab," price : ",price," num : ",num_to_give," price_type : ",price_type)
        if right_click then
            num_to_give = num_to_give * 10
        end

        -----------------------------------------------------------------
        -- 检查prefab 合法性
            if not PrefabExists(prefab) then
                print("error : hoshino_com_shop item prefab not found")
                TheNet:Announce("警告:物品prefab缺失")
                return
            end
        -----------------------------------------------------------------
        -- 货币消耗
            if price_type == "credit_coins" then
                print("current credit coins : ",self:GetCreditCoins(),price)
                if self:GetCreditCoins() < price then
                    print("error : hoshino_com_shop item price not enough")
                    return
                else
                    --- 扣除钱数
                    -- print("扣除钱数",price)
                    self:CreditCoinDelta(-price)
                end
            else
                print("error : hoshino_com_shop item price type not found")
            end
        -----------------------------------------------------------------
        --- 生成物品给玩家
            self:GiveItemByPrefab(prefab,num_to_give)
        -----------------------------------------------------------------

    end
------------------------------------------------------------------------------------------------------------------------------
--- item spawn
    function hoshino_com_shop:GiveItemByPrefab(prefab,num)
        TUNING.HOSHINO_FNS:GiveItemByPrefab(self.inst,prefab,num)
    end
------------------------------------------------------------------------------------------------------------------------------
--- 底层官方API
    function hoshino_com_shop:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_com_shop:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_shop







