--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    -- inst:AddComponent("hoshino_com_combat_hooker")

    -- inst:DoTaskInTime(0,function()

    --     local old_GetAttacked = inst.components.combat.GetAttacked
    --     inst.components.combat.GetAttacked = function(self, attacker, damage, weapon, stimuli, spdamage,...)
    --         damage,spdamage = self.inst.components.hoshino_com_combat_hooker:Active(attacker,damage,weapon,stimuli,spdamage,...)
    --         return old_GetAttacked(self, attacker, damage, weapon, stimuli, spdamage,...)
    --     end

    -- end)
end