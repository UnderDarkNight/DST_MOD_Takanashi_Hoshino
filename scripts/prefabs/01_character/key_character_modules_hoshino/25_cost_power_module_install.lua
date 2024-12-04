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
    inst:DoTaskInTime(0.1, function() -- 不知道为什么，出现了bug，所以延迟一下
        inst.components.hoshino_com_power_cost:SetMax(10)
    end)

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
    ---- 吃料理恢复0.2cost。
    inst:ListenForEvent("oneat",function(_,_table)
        local food = _table and _table.food 
        if food and food:HasOneOfTags({"preparedfood","pre-preparedfood"}) then
            inst.components.hoshino_com_power_cost:DoDelta(0.2)
        end
    end)

end