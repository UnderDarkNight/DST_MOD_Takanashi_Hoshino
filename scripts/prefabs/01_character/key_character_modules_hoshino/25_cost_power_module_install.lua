--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

Cost:满值为10，每秒钟自然恢复0.01，吃料理可以恢复0.5。

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end



    inst:AddComponent("hoshino_com_power_cost")

    inst.components.hoshino_com_power_cost:SetMax(10)

    -- inst:DoPeriodicTask(0.5,function()
    --     inst.components.hoshino_com_power_cost:DoDelta(0.1)
    --     if inst.components.hoshino_com_power_cost:GetCurrent() == inst.components.hoshino_com_power_cost:GetMax() then
    --         inst.components.hoshino_com_power_cost:SetCurrent(0)
    --     end
    -- end)

    ---- 每秒自然恢复
    inst:DoPeriodicTask(1,function()
        inst.components.hoshino_com_power_cost:DoDelta(0.01)
    end)
    ---- 吃任何东西都会回复
    inst:ListenForEvent("oneat",function()
        inst.components.hoshino_com_power_cost:DoDelta(0.5)        
    end)

end