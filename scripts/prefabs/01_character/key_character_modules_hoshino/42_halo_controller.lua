--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    头顶光环控制器

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    local light_fx = nil
    local function CreateLight()
        if light_fx ~= nil then
            return
        end
        light_fx = inst:SpawnChild("minerhatlight")

        light_fx.Light:SetFalloff(0.4)
        light_fx.Light:SetIntensity(.7)
        light_fx.Light:SetRadius(2.5)
        light_fx.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
    end
    local function DestroyLight()
        if light_fx then
            light_fx:Remove()
        end
        light_fx = nil
    end
    inst:ListenForEvent("hoshino_event.halo",function(inst,show_flag)
        if show_flag then
            inst.AnimState:ClearOverrideSymbol("headbase")
            inst.AnimState:ClearOverrideSymbol("headbase_hat")
            CreateLight()
        else
            DestroyLight()
        end
    end)

end