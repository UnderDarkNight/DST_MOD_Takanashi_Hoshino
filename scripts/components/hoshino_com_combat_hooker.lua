----------------------------------------------------------------------------------------------------------------------------------
--[[

    受伤屏蔽器
    combat:GetAttacked 
        damage,spdamage = fn(self.inst,attacker, damage, weapon, stimuli, spdamage)

    伤害结算器


]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_combat_hooker = Class(function(self, inst)
    self.inst = inst

    self.custom_get_attacked_modifiers = {}
    self.custom_get_attacked_inst_remove_event_fn = function(mult_inst)
        self:Remove_GetAttacked_Modifier(mult_inst)
    end


    self._custom_CalcDamage_fns = {}
    self._custom_CalcDamage_inst_remove_event_fn = function(mult_inst)
        self:Remove_CalcDamage_Modifier(mult_inst)
    end
end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
--- hook GetAttacked
    function hoshino_com_combat_hooker:Add_GetAttacked_Modifier(mult_inst,fn)
        self:Remove_GetAttacked_Modifier(mult_inst)
        self.custom_get_attacked_modifiers[mult_inst] = fn
        mult_inst:ListenForEvent("onremove",self.custom_get_attacked_inst_remove_event_fn)
    end
    function hoshino_com_combat_hooker:Remove_GetAttacked_Modifier(mult_inst)
        if self.custom_get_attacked_modifiers[mult_inst] then
            local new_table = {}
            for k,v in pairs(self.custom_get_attacked_modifiers) do
                if k ~= mult_inst then
                    new_table[k] = v
                end
            end
            self.custom_get_attacked_modifiers = new_table
            mult_inst:RemoveEventCallback("onremove",self.custom_get_attacked_inst_remove_event_fn)
        end
    end
    function hoshino_com_combat_hooker:GetAttackedActive(attacker, damage, weapon, stimuli, spdamage)
        local ret_damage = damage
        local ret_spdamage = spdamage
        for k,fn in pairs(self.custom_get_attacked_modifiers) do
            ret_damage,ret_spdamage = fn(self.inst,attacker, damage, weapon, stimuli, spdamage)
            ret_damage = ret_damage or damage
            ret_spdamage = ret_spdamage or spdamage
        end
        return ret_damage,ret_spdamage
    end
------------------------------------------------------------------------------------------------------------------------------
--- hook CalcDamage
    function hoshino_com_combat_hooker:ActiveCalcDamage(target,damage,spdamage,weapon,multiplier)
        local ret_damge = damage
        local ret_spdamage = spdamage
        for tempInst, fn in pairs(self._custom_CalcDamage_fns) do
            ret_damge,ret_spdamage = fn(self.inst,target,damage,spdamage,weapon,multiplier)
            ret_damge = ret_damge or damage
            ret_spdamage = ret_spdamage or spdamage
        end
        return ret_damge,ret_spdamage
    end
    function hoshino_com_combat_hooker:Add_CalcDamage_Modifier(tempInst,fn)
        self:Remove_CalcDamage_Modifier(tempInst)
        self._custom_CalcDamage_fns[tempInst] = fn
        tempInst:ListenForEvent("onremove",self._custom_CalcDamage_inst_remove_event_fn)
    end
    function hoshino_com_combat_hooker:Remove_CalcDamage_Modifier(tempInst)
        if self._custom_CalcDamage_fns[tempInst] then
            local new_table = {}
            for k,v in pairs(self._custom_CalcDamage_fns) do
                if k ~= tempInst then
                    new_table[k] = v
                end
            end
            self._custom_CalcDamage_fns = new_table
            tempInst:RemoveEventCallback("onremove",self._custom_CalcDamage_inst_remove_event_fn)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_combat_hooker







