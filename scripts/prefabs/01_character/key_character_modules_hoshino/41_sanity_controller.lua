--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    黄昏、黑夜 掉San 倍增器 参数：night_drain_mult

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("master_postinit_hoshino",function()
        if inst.components.sanity == nil then
            return
        end

        inst.components.sanity.night_drain_mult = 0


    end)

end