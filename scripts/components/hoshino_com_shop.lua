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

                is_permanent = true, --- 常驻标记位

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
            self:ShopData_Set("credit_coins",self.credit_coins)
        end)
        self:AddOnSaveFn(function()
            self:Set("credit_coins", self.credit_coins)
        end)
    --------------------------------------------------------------
    --- 青辉石  有两个翻译 ：部分字段可能有不同 "laplite" "blue_schist" 
        self.blue_schist = 0
        self:AddOnLoadFn(function()
            self.blue_schist = self:Get("blue_schist") or 0
            self:ShopData_Set("blue_schist",self.blue_schist)
        end)
        self:AddOnSaveFn(function()
            self:Set("blue_schist", self.blue_schist)
        end)
        inst:ListenForEvent("hoshino_event.shop_blue_schist_clicked",function(inst,_table)
            if _table and _table.right_click then
                self:Blue_Schist_Trans_2_Item(10)
            else
                self:Blue_Schist_Trans_2_Item(1)
            end
        end)
    --------------------------------------------------------------
    -- 刷新次数 ： 当前剩余次数，每天更新次数
        self.refresh_count_daily = 1
        self.refresh_count = 1

        self.refresh_cost = 50  --- 消耗货币刷新 （每天第一次）
        self.refresh_cost_default = 50  --- 消耗货币刷新 （每天第一次）
        self.refresh_cost_max = 500
        self.refresh_cost_delta = 50
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

            self.refresh_cost = self.refresh_cost_default
            self:ShopData_Set("refresh_cost",self.refresh_cost)
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
    --- 物品出售
        inst:ListenForEvent("hoshino_event.shop_item_sell_button_clicked",function()
            self:RecycleButtonClicked()
            print("+++++++++++++++shop_item_sell_button_clicked")
        end)
    --------------------------------------------------------------
    --- 玩家回环任务。用来打开商店
        self.shop_building = nil    --- 商店建筑
        self.shop_opening_flag = false  --- 正在打开标记位，用来避免多次event添加。
        self.___player_open_shop_widget_event = function(player)
            self.shop_building.components.container.canbeopened = true
            self.shop_building.components.container:Open(player)
            self.shop_building = nil
            self.inst:RemoveEventCallback("hoshino_com_shop_client_side_data_updated",self.___player_open_shop_widget_event)
            self.shop_opening_flag = false
        end
    --------------------------------------------------------------
end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
--- 商店打开关键API
    function hoshino_com_shop:EnterShop(shop_building)
        if self.shop_opening_flag then
            self.inst:RemoveEventCallback("hoshino_com_shop_client_side_data_updated",self.___player_open_shop_widget_event)
        end
        shop_building.components.container:Close()
        self.shop_opening_flag = true
        self.shop_building = shop_building
        self:Spawn_Items_List_And_Send_2_Client()
        self.inst:ListenForEvent("hoshino_com_shop_client_side_data_updated",self.___player_open_shop_widget_event)
    end
    function hoshino_com_shop:SetRecycleBuilding(shop_building)
        self.recycle_building = shop_building
    end
    function hoshino_com_shop:IsShopOpening()
        return self.shop_opening_flag or false
    end
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
    function hoshino_com_shop:CreditCoinDelta(num,skip_delta_fn)
        if self.__credit_coin_delta_fn and not skip_delta_fn then
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
--- 青辉石变更，注意unit32上限。
    function hoshino_com_shop:BlueSchistDelta(num)
        self.blue_schist = math.clamp(self.blue_schist + num,0,self.u32_max)
        self:ShopData_Set("blue_schist",self.blue_schist)
    end
    function hoshino_com_shop:GetBlueSchist()
        return self.blue_schist
    end
    function hoshino_com_shop:IsBlueSchist(price_type)
        if price_type == "laplite" or price_type == "blue_schist" then
            return true
        end
        return false
    end
    function hoshino_com_shop:Blue_Schist_Trans_2_Item(num) -- 青辉石转换成物品。
        if num > self.blue_schist then
            num = self.blue_schist
        end
        self:BlueSchistDelta(-num)
        TUNING.HOSHINO_FNS:GiveItemByPrefab(self.inst,"hoshino_item_blue_schist",num)
    end
------------------------------------------------------------------------------------------------------------------------------
--- 刷新次数。每日刷新次数
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
    function hoshino_com_shop:Has_Enough_Coins_For_Refresh()
        if self.credit_coins >= self.refresh_cost then
            return true
        end
        return false
    end
    function hoshino_com_shop:Cost_Coins_For_Refresh()
        self:CreditCoinDelta(-self.refresh_cost)
        self.refresh_cost = math.clamp(self.refresh_cost + self.refresh_cost_delta,0,self.refresh_cost_max)
        self:ShopData_Set("refresh_cost",self.refresh_cost)
    end
------------------------------------------------------------------------------------------------------------------------------
--- 刷新按键点击后执行。
    function hoshino_com_shop:Refresh_Clicked()
        local refresh_cost_type = nil
        if self:GetRefreshCount() > 0 then
            self:Refresh_Delta(-1)
            self:Spawn_Items_List_And_Send_2_Client(true)
            refresh_cost_type = "free_times"
        elseif self:Has_Enough_Coins_For_Refresh() then
            self:Cost_Coins_For_Refresh()
            self:Spawn_Items_List_And_Send_2_Client(true)
            refresh_cost_type = "cost_credit_coins"
        else
            return
        end

        --- 广播事件。
        self.inst:PushEvent("hoshino_com_shop.refresh",{
            refresh_cost_type = refresh_cost_type
        })

        -- -----------------------------------------------
        -- --- 执行刷新内容逻辑。
        --     self:Spawn_Items_List_And_Send_2_Client(true)
        -- -----------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------
--- 商店等级
    function hoshino_com_shop:GetLevel()
        local level = TheWorld.components.hoshino_com_shop_items_pool:GetLevel() or 0
        return level
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
    --- 按稀有度排序。
    function hoshino_com_shop:SortItemsList(items_list)
        --[[
            根据bg 参数，按照稀有度排序进来的列表。
            按照顺序：item_slot_colourful.tex item_slot_golden.tex item_slot_blue.tex item_slot_gray.tex
        ]]--
        -- 定义稀有度优先级表
        local rarity_priority = {
            ["item_slot_gray.tex"] = 4,
            ["item_slot_blue.tex"] = 3,
            ["item_slot_golden.tex"] = 2,
            ["item_slot_colourful.tex"] = 1,
        }
    
        -- 使用table.sort函数对列表进行排序
        table.sort(items_list, function(a, b)
            return rarity_priority[a.bg] < rarity_priority[b.bg]
        end)
    
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

        normal_items = self:SortItemsList(normal_items)
        special_items = self:SortItemsList(special_items)

        self:ShopData_Set("level",self:GetLevel())
        self:ShopData_Set("normal_items",normal_items)
        self:ShopData_Set("special_items",special_items)
        self:ShopData_Set("new_spawn_list_flags",{normal_items = true, special_items = true}) -- 标记新列表
        self:Refresh_Delta(0)
        self:CreditCoinDelta(0)
        self:BlueSchistDelta(0)
        self:ShopData_Set("refresh_cost",self.refresh_cost)
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
            price = price * 10
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
            if price_type == "credit_coins" then --- 信用币
                print("current credit coins : ",self:GetCreditCoins(),price)
                if self:GetCreditCoins() < price then
                    print("error : hoshino_com_shop item price not enough")
                    return
                else
                    --- 扣除钱数
                    -- print("扣除钱数",price)
                    self:CreditCoinDelta(-price)
                end
            elseif self:IsBlueSchist(price_type) then -- 青辉石
                if self:GetBlueSchist(price_type) < price then
                    print("error : hoshino_com_shop item price not enough")
                    return
                else
                    --- 扣除钱数
                    -- print("扣除钱数",price)
                    self:BlueSchistDelta(-price)
                end
            else
                print("error : hoshino_com_shop item price type not found")
            end
        -----------------------------------------------------------------
        --- 生成物品给玩家
            self:GiveItemByPrefab(prefab,num_to_give)
        -----------------------------------------------------------------
        -- 事件广播
            self.inst:PushEvent("hoshino_com_shop.buy",{
                price_type = price_type,
                price = price,
                prefab = prefab,
                num_to_give = num_to_give,
                right_click = right_click,
            })
        -----------------------------------------------------------------

    end
------------------------------------------------------------------------------------------------------------------------------
--- item spawn
    function hoshino_com_shop:GiveItemByPrefab(prefab,num)
        TUNING.HOSHINO_FNS:GiveItemByPrefab(self.inst,prefab,num)
    end
------------------------------------------------------------------------------------------------------------------------------
--- 回收价下发函数
    function hoshino_com_shop:RecycleCoinsRefresh(num)
        self:ShopData_Set("recycle_coins",num or 0)
    end
    function hoshino_com_shop:RecycleButtonClicked()
        if self.recycle_building then
            self.recycle_building:PushEvent("recycle_button_clicked",{doer = self.inst})
        end
        print("API : hoshino_com_shop:RecycleButtonClicked",self.recycle_building)
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







