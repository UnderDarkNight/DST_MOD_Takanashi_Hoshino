--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function com_setup(inst)
        inst:AddComponent("hoshino_com_max_value_controller")
        inst.components.hoshino_com_max_value_controller:SetOriginMaxHunger(TUNING[string.upper("hoshino").."_HUNGER"])
        inst.components.hoshino_com_max_value_controller:SetOriginMaxSanity(TUNING[string.upper("hoshino").."_SANITY"])
        inst.components.hoshino_com_max_value_controller:SetOriginMaxHealth(TUNING[string.upper("hoshino").."_HEALTH"])
        inst:AddComponent("hoshino_com_debuff")
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("master_postinit_hoshino",com_setup)

end