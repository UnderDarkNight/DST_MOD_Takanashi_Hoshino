-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    白色无人机指挥官

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("hoshino_com_drone_leader")
    inst.components.hoshino_com_drone_leader:AddOnSaveFn(function()
        inst.components.hoshino_com_drone_leader:SaveDrones()
    end)
    inst:DoTaskInTime(1,function()
        inst.components.hoshino_com_drone_leader:LoadDrones()
    end)
end)
