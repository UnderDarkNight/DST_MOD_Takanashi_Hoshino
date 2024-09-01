----------------------------------------------------------------------------------------------------------------------------------
--[[

    商店系统

    数据挂载去 ThePlayer.HOSHINO_SHOP 。方便HUD调用。

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
    -- 数据初始化
        inst.HOSHINO_SHOP = inst.HOSHINO_SHOP or {}
    --------------------------------------------------------------
    -- 金币
        self.coins = 0
        self:AddOnLoadFn(function()
            self:Set("coins", self.coins)
        end)
        self:AddOnSaveFn(function()
            self.coins = self:Get("coins") or 0
        end)
    --------------------------------------------------------------
    -- 刷新次数 ： 当前剩余次数，每天更新次数
        self.refresh_count_daily = 1
        self.refresh_count = 1
        self:AddOnLoadFn(function()
            self:Set("refresh_count_daily", self.refresh_count_daily)
            self:Set("refresh_count", self.refresh_count)
        end)
        self:AddOnSaveFn(function()
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
end,
nil,
{
    --------------------------------------------------------------
    --- 同步
        coins = function(self,value)
            local replica_com = GetReplicaCom(self)
            if replica_com then
                replica_com:SetCoins(value)
            end
        end,
    --------------------------------------------------------------
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
--- 金币变更，注意unit32上限。
    function hoshino_com_shop:CoinDelta(num)
        self.coins = math.clamp(self.coins + num,0,4000000000)
        self:ShopData_Set("coins",self.coins)
    end
    function hoshino_com_shop:GetCoins()
        return self.coins
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
--- 
    function hoshino_com_shop:Refresh_Clicked()
        if self:GetRefreshCount() <= 0 then
            return
        end
        self:Refresh_Delta(-1)
        -----------------------------------------------
        --- 执行刷新内容逻辑。
        -----------------------------------------------
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







