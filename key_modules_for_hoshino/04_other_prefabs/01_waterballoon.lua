-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    水球

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "waterballoon",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.complexprojectile == nil then
            return
        end
        local old_OnHitWater = inst.components.complexprojectile.onhitfn
        inst.components.complexprojectile.onhitfn = function(inst, attacker, target)
            -- print("++ waterballoon onhitfn",attacker,target)
            -- SpawnPrefab("log").Transform:SetPosition(x,y,z)
            inst:ListenForEvent("onremove",function()
                local x,y,z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x,y,z,4)
                attacker:PushEvent("hoshino_event.waterballoon_explode",{
                    pt = Vector3(x,0,z),
                    ents = ents,
                })
            end)

            if type(old_OnHitWater) == "function" then
                return old_OnHitWater(inst, attacker, target)
            end
        end

    end
)


