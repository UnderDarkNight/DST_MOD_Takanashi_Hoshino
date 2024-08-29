--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    等级系统

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("hoshino_com_level_sys")

    inst:ListenForEvent("hoshino_com_level_sys.exp_full",function()
        local current_level = inst.components.hoshino_com_level_sys:GetLevel()
    end)

end