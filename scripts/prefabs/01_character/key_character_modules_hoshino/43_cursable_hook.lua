--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    屏蔽所有诅咒

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("master_postinit_hoshino",function()
        if inst.components.cursable == nil then
            return
        end
        inst.components.cursable.IsCursable = function()
            -- print("屏蔽所有诅咒",math.random())
            return false
        end
    end)
end