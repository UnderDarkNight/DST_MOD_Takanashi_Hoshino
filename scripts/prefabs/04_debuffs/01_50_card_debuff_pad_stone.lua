------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【垫脚石】你的攻击倍率和移速倍率不低于1.0

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local locomotor_speed_mult_override_fn = function(player,mult,debuff_inst)
        if mult < 1 then
            return 1
        end
        return mult
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player
        -----------------------------------------------------
        --- 
        -----------------------------------------------------
        --- 
            if player.components.combat and player.components.combat.externaldamagemultipliers
                and player.components.combat.externaldamagemultipliers.Hoshino_AddGotOverrideFn then
                player.components.combat.externaldamagemultipliers:Hoshino_AddGotOverrideFn(inst,function(inst,mult)
                    if mult < 1 then
                        return 1
                    end
                    return mult
                end)
            end
        -----------------------------------------------------
        --- 
            if player.components.locomotor then
                player.components.locomotor:Hoshino_AddSpeedMultOverrideFn(inst,locomotor_speed_mult_override_fn)
                inst.__net_target:set(player)
                inst:DoPeriodicTask(1,function()
                    if inst.__net_target:value() == player then
                        inst.__net_target:set(inst)
                    else
                        inst.__net_target:set(player)
                    end
                end)
            end
        -----------------------------------------------------
        -----------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function ExtendDebuff(inst)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function net_target_update_event(inst)
        local target = inst.__net_target:value()
        if target and target:HasTag("player") and not inst.__client_side_inited then
            inst.__client_side_inited = true
            if target.components.locomotor and target.components.locomotor.Hoshino_AddSpeedMultOverrideFn then
                target.components.locomotor:Hoshino_AddSpeedMultOverrideFn(inst,locomotor_speed_mult_override_fn)
            end
        end
    end
------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst:AddTag("CLASSIFIED")
    inst.entity:SetPristine()
    inst.__net_target = net_entity(inst.GUID,"net_target","net_target_update")
    if not TheNet:IsDedicated() then
        inst:ListenForEvent("net_target_update",net_target_update_event)
    end
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    return inst
end

return Prefab("hoshino_card_debuff_pad_stone", fn)
