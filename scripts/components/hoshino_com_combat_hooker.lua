----------------------------------------------------------------------------------------------------------------------------------
--[[

    
            damage,spdamage = fn(self.inst,attacker, damage, weapon, stimuli, spdamage)

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_combat_hooker = Class(function(self, inst)
    self.inst = inst

    self.mult_modifiers = {}


    self.mult_inst_remove_event_fn = function(mult_inst)
        self:Remove_Modifier(mult_inst)
    end

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_combat_hooker:Add_Modifier(mult_inst,fn)
        self.mult_modifiers[mult_inst] = fn
        mult_inst:ListenForEvent("onremove",self.mult_inst_remove_event_fn)
    end
    function hoshino_com_combat_hooker:Remove_Modifier(mult_inst)
        local new_table = {}
        for k,v in pairs(self.mult_modifiers) do
            if k ~= mult_inst then
                new_table[k] = v
            end
        end
        self.mult_modifiers = new_table
        mult_inst:RemoveEventCallback("onremove",self.mult_inst_remove_event_fn)
    end
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_combat_hooker:Active(attacker, damage, weapon, stimuli, spdamage)
        for k,fn in pairs(self.mult_modifiers) do
            damage,spdamage = fn(self.inst,attacker, damage, weapon, stimuli, spdamage)
        end
        return damage,spdamage
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_combat_hooker







