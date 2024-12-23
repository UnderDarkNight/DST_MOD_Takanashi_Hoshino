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
        if light_fx and light_fx:IsValid() then
            return        
        end
        light_fx = inst:SpawnChild("minerhatlight")

        light_fx.Light:SetFalloff(0.6)
        light_fx.Light:SetIntensity(.35)
        light_fx.Light:SetRadius(1)
        light_fx.Light:SetColour(180 / 255, 195 / 255, 150 / 255)

        -- if inst.__light_test then
        --     inst.__light_test(light_fx)
        -- end
    end
    local function DestroyLight()
        if light_fx then
            light_fx:Remove()
        end
        light_fx = nil
    end
    local show_flag = true
    inst:ListenForEvent("hoshino_event.halo",function(inst,_show_flag)
        -- show_flag = show_flag or _show_flag
        if _show_flag == nil then

        else
            show_flag = _show_flag
        end
        if show_flag then
            inst.AnimState:ClearOverrideSymbol("headbase")
            inst.AnimState:ClearOverrideSymbol("headbase_hat")
            CreateLight()
        else
            DestroyLight()
            if inst:Hoshino_Get_Spell_Type() == "hoshino_spell_type_normal" then
                inst.AnimState:OverrideSymbol("headbase", "hoshino_empty_halo","headbase")
                inst.AnimState:OverrideSymbol("headbase_hat", "hoshino_empty_halo","headbase")
            else
                inst.AnimState:OverrideSymbol("headbase", "hoshino_empty_halo","headbase_swimming")
                inst.AnimState:OverrideSymbol("headbase_hat", "hoshino_empty_halo","headbase_swimming")
            end
        end
    end)
    inst:ListenForEvent("hoshino_event.spell_type_changed",function()
        inst:PushEvent("hoshino_event.halo")
    end)

    inst:ListenForEvent("hoshino_event.hoshino_item_pillow.enter",function()
        inst:PushEvent("hoshino_event.halo",false)        
    end)
    inst:ListenForEvent("hoshino_event.hoshino_item_pillow.leave",function()
        inst:PushEvent("hoshino_event.halo",true)
    end)
    

    -------------------------------------------------------------------
    --- 睡觉消失光环
        local function player_is_sleeping(player)
            if player and player.sg then
                if player.sg:HasStateTag("sleeping") or player.sg:HasStateTag("yawn") then
                    return true
                end
                if player.sg.currentstate and player.sg.currentstate.name == "knockout" then
                    return true
                end
            end
            return false
        end
        local checker_fn = function()
            -- print("ffffffffffff",player_is_sleeping(inst))
            if player_is_sleeping(inst) then
                inst:PushEvent("hoshino_event.halo",false)
            else
                inst:PushEvent("hoshino_event.halo",true)
            end
        end
        -- local event = function(_,_table)
        --     -- print("statename",_table and _table.statename,inst.sg:HasStateTag("sleeping"))
        --     inst:DoTaskInTime(1,checker_fn)
        -- end
        -- inst:ListenForEvent("newstate",event)
        inst:DoPeriodicTask(0.5,checker_fn)
    -------------------------------------------------------------------

end