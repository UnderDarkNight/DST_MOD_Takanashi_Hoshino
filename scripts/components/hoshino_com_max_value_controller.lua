----------------------------------------------------------------------------------------------------------------------------------
--[[

    三维数值控制器
    用于控制最大值和处理初始化问题。

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_max_value_controller = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}
    --------------------------------------------------------------------------------------------
    --- 永久额外数值
        self.extra_hunger = 0
        self.extra_sanity = 0
        self.extra_health = 0

        self:AddOnSaveFn(function(self)
            self:Set("extra_hunger",self.extra_hunger)
            self:Set("extra_sanity",self.extra_sanity)
            self:Set("extra_health",self.extra_health)
        end)
        self:AddOnLoadFn(function(self)
            self.extra_hunger = self:Get("extra_hunger",0)
            self.extra_sanity = self:Get("extra_sanity",0)
            self.extra_health = self:Get("extra_health",0)
            self:Init()
            self:InitCurrentValues()
        end)
    --------------------------------------------------------------------------------------------
    --- 原始数值
        self.origin_max_hunger = 100
        self.origin_max_sanity = 100
        self.origin_max_health = 100
        -- self.inst:ListenForEvent("player_despawn",function() -- 玩家离开当前世界的时候，储存current值            
        -- end)
        self:AddOnSaveFn(function(self)
            self:SaveCurrentForInit()
        end)
    --------------------------------------------------------------------------------------------
    --- 临时数值
        self.__temp_hunger_modifiers = {}
        self.__temp_hunger_modifier_removers = {}
        self.__temp_hunger_modifier_remove_event = function(temp_inst)
            self:RemoveTempExtraHunger(temp_inst)
        end

        self.__temp_sanity_modifiers = {}
        self.__temp_sanity_modifier_removers = {}
        self.__temp_sanity_modifier_remove_event = function(temp_inst)
            self:RemoveTempExtraSanity(temp_inst)
        end

        self.__temp_health_modifiers = {}
        self.__temp_health_modifier_removers = {}
        self.__temp_health_modifier_remove_event = function(temp_inst)
            self:RemoveTempExtraHealth(temp_inst)
        end
    --------------------------------------------------------------------------------------------
    --- init 标记位。 OnSave 会在加载的时候调用一次，必须隔离开
        self.ready = false
        self.inst:DoTaskInTime(0.1,function() self.ready = true end)
    --------------------------------------------------------------------------------------------

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
--- debug
    function hoshino_com_max_value_controller:Debug()
        print("hunger max ",self.origin_max_hunger + self.extra_hunger + self:GetTempExtraHunger())
        print("sanity max ",self.origin_max_sanity + self.extra_sanity + self:GetTempExtraSanity())
        print("health max ",self.origin_max_health + self.extra_health + self:GetTempExtraHealth())
    end
------------------------------------------------------------------------------------------------------------------------------
-- 初始化
    local refresh_delta_value = 0.1
    function hoshino_com_max_value_controller:Init(flag)
        --- flag 为nil的时候全部初始化，不然就只初始化单个
        if self.inst.components.hunger and (flag == nil or flag == "hunger") then
            self.inst.components.hunger.max = math.max(self.origin_max_hunger + self.extra_hunger + self:GetTempExtraHunger(),1)
            -- 刷一下给HUD
            self.inst.components.hunger.current = self.inst.components.hunger.current + refresh_delta_value
            self.inst.components.hunger:DoDelta(-refresh_delta_value,true)
        end
        if self.inst.components.sanity and (flag == nil or flag == "sanity") then            
            self.inst.components.sanity.max = math.max(self.origin_max_sanity + self.extra_sanity + self:GetTempExtraSanity(),1)
            -- 刷一下给HUD
            self.inst.components.sanity.current = self.inst.components.sanity.current + refresh_delta_value
            self.inst.components.sanity:DoDelta(-refresh_delta_value,true)
        end
        if self.inst.components.health and (flag == nil or flag == "health") then
            self.inst.components.health.maxhealth = math.max(self.origin_max_health + self.extra_health + self:GetTempExtraHealth(),1)
            -- 刷一下给HUD
            -- self.inst.components.health.currenthealth = self.inst.components.health.currenthealth + refresh_delta_value
            -- self.inst.components.health:DoDelta(-refresh_delta_value,true)
            self.inst.components.health:ForceUpdateHUD(true)
        end
    end
    function hoshino_com_max_value_controller:InitCurrentValues()
        self.inst:DoTaskInTime(1,function(inst) -- 延迟一下,等临时控制器准备好。
            local saved_hunger = self:Get("saved_current_hunger")
            -- print("info saved_hunger",saved_hunger)
            if saved_hunger and self.inst.components.hunger then
                self.inst.components.hunger.current = math.clamp(saved_hunger,0,self.inst.components.hunger.max) - refresh_delta_value
                self.inst.components.hunger:DoDelta(refresh_delta_value,true)
                self:Set("saved_current_hunger",nil)
                -- print("info +++ set hunger",saved_hunger,self.inst.components.hunger.current,self.inst.components.hunger.max)
            end
            local saved_sanity = self:Get("saved_current_sanity")
            -- print("info saved_sanity",saved_sanity)
            if saved_sanity and self.inst.components.sanity then
                self.inst.components.sanity.current = math.clamp(saved_sanity,0,self.inst.components.sanity.max) - refresh_delta_value
                self.inst.components.sanity:DoDelta(refresh_delta_value,true)
                self:Set("saved_current_sanity",nil)
                -- print("info +++ set sanity",saved_sanity,self.inst.components.sanity.current,self.inst.components.sanity.max)
            end
            local saved_health = self:Get("saved_current_health")
            -- print("info saved_health",saved_health)
            if saved_health and self.inst.components.health then
                self.inst.components.health.currenthealth = math.clamp(saved_health,0,self.inst.components.health.maxhealth)
                self.inst.components.health:ForceUpdateHUD(true)
                -- self.inst.components.health:DoDelta(refresh_delta_value,true)
                self:Set("saved_current_health",nil)
                -- print("info +++ set health",saved_health,self.inst.components.health.currenthealth,self.inst.components.health.maxhealth)
            end
        end)
    end
    function hoshino_com_max_value_controller:SaveCurrentForInit()
        if not self.ready then
            return
        end
        if self.inst.components.hunger then
            local current_hunger = self.inst.components.hunger.current
            self:Set("saved_current_hunger",current_hunger)
            -- print("info save : current_hunger",current_hunger)
        end
        if self.inst.components.sanity then
            local current_sanity = self.inst.components.sanity.current
            self:Set("saved_current_sanity",current_sanity)
            -- print("info save : current_sanity",current_sanity)
        end
        if self.inst.components.health then
            local current_health = self.inst.components.health.currenthealth
            self:Set("saved_current_health",current_health)
            -- print("info save : current_health",current_health)
        end
    end
    function hoshino_com_max_value_controller:RefreshCurrent(flag)
        --- flag 为nil的时候全部刷新，不然就只刷新单个
        if self.inst.components.hunger and (flag == nil or flag == "hunger") then
            self.inst.components.hunger.current = math.clamp(self.inst.components.hunger.current,0,self.inst.components.hunger.max)
        end
        if self.inst.components.sanity and (flag == nil or flag == "sanity") then
            self.inst.components.sanity.current = math.clamp(self.inst.components.sanity.current,0,self.inst.components.sanity.max)
        end
        if self.inst.components.health and (flag == nil or flag == "health") then
            self.inst.components.health.currenthealth = math.clamp(self.inst.components.health.currenthealth,0,self.inst.components.health.maxhealth)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
-- 原始数值
    function hoshino_com_max_value_controller:SetOriginMaxHunger(value)
        self.origin_max_hunger = value
    end
    function hoshino_com_max_value_controller:SetOriginMaxSanity(value)
        self.origin_max_sanity = value
    end
    function hoshino_com_max_value_controller:SetOriginMaxHealth(value)
        self.origin_max_health = value
    end
------------------------------------------------------------------------------------------------------------------------------
-- 永久修改值
    function hoshino_com_max_value_controller:AddEverExtraHunger(value)
        self.extra_hunger = self.extra_hunger + value
        self:Init("hunger")
    end
    function hoshino_com_max_value_controller:AddEverExtraSanity(value)
        self.extra_sanity = self.extra_sanity + value
        self:Init("sanity")
    end
    function hoshino_com_max_value_controller:AddEverExtraHealth(value)
        self.extra_health = self.extra_health + value
        self:Init("health")
    end
------------------------------------------------------------------------------------------------------------------------------
-- 临时修改值
    function hoshino_com_max_value_controller:AddTempExtraHunger(temp_inst,value)
        -- print("AddTempExtraHunger",temp_inst,value)
        self.__temp_hunger_modifiers[temp_inst] = value
        if not self.__temp_hunger_modifier_removers[temp_inst] then
            self.__temp_hunger_modifier_removers[temp_inst] = true
            temp_inst:ListenForEvent("onremove",self.__temp_hunger_modifier_remove_event)
        end
        self:Init("hunger")
    end
    function hoshino_com_max_value_controller:RemoveTempExtraHunger(temp_inst)
        if not self.__temp_hunger_modifiers[temp_inst] then
            return
        end
        local new_table = {}
        for k,v in pairs(self.__temp_hunger_modifiers) do
            if k ~= temp_inst then
                new_table[k] = v
            end
        end
        self.__temp_hunger_modifiers = new_table
        self.__temp_hunger_modifier_removers[temp_inst] = false
        temp_inst:RemoveEventCallback("onremove",self.__temp_hunger_modifier_remove_event)
        self:Init("hunger")
        self:RefreshCurrent("hunger")
    end
    function hoshino_com_max_value_controller:GetTempExtraHunger()
        local ret = 0
        for temp_inst,value in pairs(self.__temp_hunger_modifiers) do
            ret = ret + value
        end
        return ret
    end
    function hoshino_com_max_value_controller:AddTempExtraSanity(temp_inst,value)
        -- print("AddTempExtraSanity",temp_inst,value)
        self.__temp_sanity_modifiers[temp_inst] = value
        if not self.__temp_sanity_modifier_removers[temp_inst] then
            self.__temp_sanity_modifier_removers[temp_inst] = true
            temp_inst:ListenForEvent("onremove",self.__temp_sanity_modifier_remove_event)
        end
        self:Init("sanity")
    end
    function hoshino_com_max_value_controller:RemoveTempExtraSanity(temp_inst)
        if not self.__temp_sanity_modifiers[temp_inst] then
            return
        end
        local new_table = {}
        for k,v in pairs(self.__temp_sanity_modifiers) do
            if k ~= temp_inst then
                new_table[k] = v
            end
        end
        self.__temp_sanity_modifiers = new_table
        self.__temp_sanity_modifier_removers[temp_inst] = false
        temp_inst:RemoveEventCallback("onremove",self.__temp_sanity_modifier_remove_event)
        self:Init("sanity")
        self:RefreshCurrent("sanity")
    end
    function hoshino_com_max_value_controller:GetTempExtraSanity()
        local ret = 0
        for temp_inst,value in pairs(self.__temp_sanity_modifiers) do
            ret = ret + value
        end
        return ret
    end
    function hoshino_com_max_value_controller:AddTempExtraHealth(temp_inst,value)
        -- print("AddTempExtraHealth",temp_inst,value)
        self.__temp_health_modifiers[temp_inst] = value
        if not self.__temp_health_modifier_removers[temp_inst] then
            self.__temp_health_modifier_removers[temp_inst] = true
            temp_inst:ListenForEvent("onremove",self.__temp_health_modifier_remove_event)
        end
        self:Init("health")
    end
    function hoshino_com_max_value_controller:RemoveTempExtraHealth(temp_inst)
        if not self.__temp_health_modifiers[temp_inst] then
            return
        end
        local new_table = {}
        for k,v in pairs(self.__temp_health_modifiers) do
            if k ~= temp_inst then
                new_table[k] = v
            end
        end
        self.__temp_health_modifiers = new_table
        self.__temp_health_modifier_removers[temp_inst] = false
        temp_inst:RemoveEventCallback("onremove",self.__temp_health_modifier_remove_event)
        self:Init("health")
        self:RefreshCurrent("health")
    end
    function hoshino_com_max_value_controller:GetTempExtraHealth()
        local ret = 0
        for temp_inst,value in pairs(self.__temp_health_modifiers) do
            ret = ret + value
        end
        return ret
    end
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function hoshino_com_max_value_controller:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function hoshino_com_max_value_controller:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function hoshino_com_max_value_controller:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function hoshino_com_max_value_controller:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function hoshino_com_max_value_controller:Get(index,default)
        if index then
            return self.DataTable[index] or default
        end
        return nil or default
    end
    function hoshino_com_max_value_controller:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function hoshino_com_max_value_controller:Add(index,num,min,max)
        if index then
            if min and max then
                local ret = (self.DataTable[index] or 0) + ( num or 0 )
                ret = math.clamp(ret,min,max)
                self.DataTable[index] = ret
                return ret
            else
                self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
                return self.DataTable[index]
            end
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
    function hoshino_com_max_value_controller:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_com_max_value_controller:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_max_value_controller







