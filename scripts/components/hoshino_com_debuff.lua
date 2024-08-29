----------------------------------------------------------------------------------------------------------------------------------
--[[

    卡牌系统的debuff组件。需要hook 各种组件。

]]--
----------------------------------------------------------------------------------------------------------------------------------
--- 辅助参数
    local function GetSpeedMultInst(self)
        if self.__speed_mult_inst then
            return self.__speed_mult_inst
        end
        self.__speed_mult_inst = CreateEntity()
        self.inst:ListenForEvent("onremove",function()
            self.__speed_mult_inst:Remove()
        end)
        return self.__speed_mult_inst
    end
    local function GetHungerMultInst2X(self)
        if self.__hunger_mult_inst_2x then
            return self.__hunger_mult_inst_2x
        end
        self.__hunger_mult_inst_2x = CreateEntity()
        self.inst:ListenForEvent("onremove",function()
            self.__hunger_mult_inst_2x:Remove()
        end)
        return self.__hunger_mult_inst_2x
    end
----------------------------------------------------------------------------------------------------------------------------------
---
    local function hook_components(self,inst)
        --------------------------------------------------------------------------------
        --- 血量上限
            function self:Add_Max_Helth(value)
                local current_max_health = inst.components.health.maxhealth
                inst.components.health.maxhealth = current_max_health + value
                inst.components.health:DoDelta(value)
            end
            self:AddOnSaveFn(function()
                self:Set("max_health",inst.components.health.maxhealth)
                self:Set("current_health",inst.components.health.currenthealth)
            end)
            self:AddOnLoadFn(function()
                local max_health = self:Get("max_health")
                local current_health = self:Get("current_health")
                if max_health and current_health then
                    inst.components.health.maxhealth = max_health
                    inst.components.health.currenthealth = current_health
                end
                self:Set("max_health",nil)
                self:Set("current_health",nil)
            end)
        --------------------------------------------------------------------------------
        --- San上限
            function self:Add_Max_Sanity(value)
                local current_max_sanity = inst.components.sanity.max
                inst.components.sanity.max = current_max_sanity + value
                inst.components.sanity:DoDelta(value)
            end
            self:AddOnSaveFn(function()
                self:Set("max_sanity",inst.components.sanity.max)
                self:Set("current_sanity",inst.components.sanity.current)
            end)
            self:AddOnLoadFn(function()
                local max_sanity = self:Get("max_sanity")
                local current_sanity = self:Get("current_sanity")
                if max_sanity and current_sanity then
                    inst.components.sanity.max = max_sanity
                    inst.components.sanity.current = current_sanity
                end
                self:Set("max_sanity",nil)
                self:Set("current_sanity",nil)
            end)
        --------------------------------------------------------------------------------
        --- hunger 上限
            function self:Add_Max_Hunger(value)
                local current_max_hunger = inst.components.hunger.max
                inst.components.hunger.max = current_max_hunger + value
                inst.components.hunger:DoDelta(1)
            end
            self:AddOnSaveFn(function()
                self:Set("max_hunger",inst.components.hunger.max)
                self:Set("current_hunger",inst.components.hunger.current)
            end)
            self:AddOnLoadFn(function()
                local max_hunger = self:Get("max_hunger")
                local current_hunger = self:Get("current_hunger")
                if max_hunger and current_hunger then
                    inst.components.hunger.max = max_hunger
                    inst.components.hunger.current = current_hunger
                end
                self:Set("max_hunger",nil)
                self:Set("current_hunger",nil)
            end)
        --------------------------------------------------------------------------------
        --- 移动速度加成
            function self:Add_Speed_Mult(value)
                local speed_mult = self:Add("speed_mult",value) + 1
                inst.components.locomotor:SetExternalSpeedMultiplier(GetSpeedMultInst(self), "hoshino_com_debuff_speed_mult",speed_mult)
            end
            self:AddOnLoadFn(function()
                self:Add_Speed_Mult(0)
            end)
        --------------------------------------------------------------------------------
        --- 饥饿速度. 饥饿降低速率降低3%（上限30%，满了之后不再出现）
            local max_hunger_mult = 0.7     --- 倍率：0.7 
            function self:Add_Hunger_Down_Mult(value)
                value = math.clamp(value,0,1)
                local old_mult = self:Add("hunger_down_mult",0)  -- 储存正数
                local new_mult = old_mult + value
                self:Set("hunger_down_mult",new_mult)
                local ret_mult = math.clamp(1-new_mult,max_hunger_mult,1)
                inst.components.hunger.burnratemodifiers:SetModifier(GetSpeedMultInst(self),ret_mult)
                -- print("info 当前饥饿倍率",ret_mult)
            end
            self:AddOnLoadFn(function()
                self:Add_Hunger_Down_Mult(0)
            end)
            function self:Is_Hunger_Down_Mult_Max()
                local current_mult = 1- (self:Get("hunger_down_mult") or 0)
                return current_mult <= max_hunger_mult
            end
        --------------------------------------------------------------------------------
        --- 饥饿速度 翻倍。（按次数指数级,2的x次方）
            function self:Add_Hunger_Down_Mult_2x_Times(value)
                local current_times = self:Add("hunger_down_mult_2x_times",0)
                local new_times = current_times + value
                self:Set("hunger_down_mult_2x_times",new_times)
                local ret_mult = math.pow(2,new_times)
                inst.components.hunger.burnratemodifiers:SetModifier(GetHungerMultInst2X(self),ret_mult)
            end
            self:AddOnLoadFn(function()
                self:Add_Hunger_Down_Mult_2x_Times(0)
            end)
        --------------------------------------------------------------------------------
        --- 经验值加成
            function self:Add_Exp_Mult(value)
                local exp_mult = self:Add("exp_up_mult",value)
            end
            function self:GetExpMult()
                return self:Add("exp_up_mult",0)
            end
        --------------------------------------------------------------------------------
        --- 攻击伤害倍率
            function self:Add_Damage_Mult(value)
                local damage_mult = self:Add("damage_mult",value) + 1
                inst.components.combat.externaldamagemultipliers:SetModifier(GetSpeedMultInst(self),damage_mult)
                if value > 0 then
                    -- 添加debuff、时间、触发event
                    inst:PushEvent("hoshino_com_debuff.Add_Damage_Mult")
                end
            end
            self:AddOnLoadFn(function()
                self:Add_Damage_Mult(0)
            end)
        --------------------------------------------------------------------------------
        --- 反伤
            function self:Add_Counter_Damage(value)
                self:Add("counter_damage",value)
            end
            inst:ListenForEvent("attacked",function(inst,_table)
                local attacker = _table and _table.attacker
                local damage = _table and _table.damage or 0
                local counter_damage = self:Add("counter_damage",0)
                if counter_damage > 0 and damage > 0  
                    and attacker and attacker:IsValid() and not attacker:HasTag("player")
                    and attacker.components.health and not attacker.components.health:IsDead()
                    then                        
                        attacker.components.health:DoDelta(-counter_damage)
                end
            end)
        --------------------------------------------------------------------------------
        --- The Eye of Horus  荷鲁斯之眼(专属武器散弹枪)
            function self:TheEyeOfHorus_Finiteuses_Down_Block(value)
                self:Add("the_eye_of_horus_finiteuses_down_block",value)
            end
            function self:TheEyeOfHorus_Finiteuses_Down_Check()
                if math.random(10000)/10000 < self:Add("the_eye_of_horus_finiteuses_down_block",0) then
                    return true
                end
                return false
            end
        --------------------------------------------------------------------------------
    end
----------------------------------------------------------------------------------------------------------------------------------
--- 模块组
    local hoshino_com_debuff = Class(function(self, inst)
        self.inst = inst

        self.DataTable = {}
        self.TempTable = {}
        self._onload_fns = {}
        self._onsave_fns = {}

        hook_components(self,inst)
    end,
    nil,
    {

    })
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function hoshino_com_debuff:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function hoshino_com_debuff:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function hoshino_com_debuff:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function hoshino_com_debuff:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function hoshino_com_debuff:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function hoshino_com_debuff:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function hoshino_com_debuff:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
    function hoshino_com_debuff:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_com_debuff:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_debuff







