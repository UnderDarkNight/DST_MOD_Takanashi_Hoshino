-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    火药 gunpowder

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "gunpowder",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.explosive == nil then
            return
        end

        local old_onexplodefn = inst.components.explosive.onexplodefn

        inst.components.explosive.onexplodefn = function(inst,...)
            local x,y,z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, 0, z, 15 ,{"player"})
            for k, player in pairs(ents) do
                player:PushEvent("hoshino_event.gunpowder_explode",inst)
            end
            return old_onexplodefn(inst,...)
        end

    end
)


