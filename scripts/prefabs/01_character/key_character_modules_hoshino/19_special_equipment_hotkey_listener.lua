--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function key_event_fn(inst,key)
        if TUNING.HOSHINO_FNS:IsKeyPressed(TUNING["hoshino.Config"].SPECIAL_EQUIPMENT_SHOES_HOTKEY,key) then
            inst.replica.hoshino_com_rpc_event:PushEvent("hoshino_event.special_equipment.shoes",{
                pt = TheInput:GetWorldPosition(),
            })
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function hotkey_listener_install(inst)
    ---------- 添加键盘监控
        local __key_handler = TheInput:AddKeyHandler(function(key,down)  ------ 30FPS 轮询，不要过于复杂
            if down == false then
                -- print("key_up",key)
                key_event_fn(ThePlayer,key)
            end
        end)
    ---------- 角色删除的时候顺便移除监听。避免切角色的时候出问题
        inst:ListenForEvent("onremove",function()
            __key_handler:Remove()
        end)

    ---------- 施放技能失败，数据来自服务端
        inst:ListenForEvent("hoshino_event.hotkey.fail",function()
            TheFocalPoint.SoundEmitter:PlaySound("dontstarve/HUD/click_negative", nil, .4)
        end)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0,function()
        if inst == ThePlayer and inst.HUD and TheInput and TheFocalPoint then
            hotkey_listener_install(inst)
        end
    end)
end