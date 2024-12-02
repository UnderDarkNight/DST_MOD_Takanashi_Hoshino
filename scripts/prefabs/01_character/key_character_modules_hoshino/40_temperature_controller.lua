--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    过热温度

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("master_postinit_hoshino",function()
        if inst.components.temperature == nil then
            return
        end

        inst.components.temperature.overheattemp = 60


    end)

end