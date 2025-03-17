------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【白】【净化之光】每0.2s扣除半径6码范围内所有敌人1点生命【重复选择扣血量叠加】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local DELTA_TIME = 0.2
    local RADIUS = TUNING.HOSHINO_DEBUGGING_MODE and 15 or 6
    local BOUNCE_MUST_TAGS = { "_combat" }
    local BOUNCE_NO_TAGS = { "INLIMBO", "wall", "notarget", "player", "companion", "flight", "invisible", "noattack", "hiding" }
------------------------------------------------------------------------------------------------------------------------------------------------
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player
        -----------------------------------------------------
        --
            inst.event_cd_timers = {}
            inst.remember_targets = {}
        -----------------------------------------------------
        --
            inst:DoPeriodicTask(DELTA_TIME,function()
                local dmg = player.components.hoshino_com_debuff:Add("purifying_light",0)
                local x,y,z = player.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x,0,z,RADIUS, BOUNCE_MUST_TAGS,BOUNCE_NO_TAGS)
                -- print("purifying_light",#ents)
                for k, temp_target in pairs(ents) do                    
                    if temp_target and temp_target:IsValid()
                        and temp_target.components.health and not temp_target.components.health:IsDead()
                        and temp_target.sg and temp_target.brainfn
                        and (temp_target.components.combat and temp_target.components.combat.target and temp_target.components.combat.target:HasOneOfTags({"player","companion","wall"}) or inst.remember_targets[temp_target] ) -- 防止惹到中立怪
                        then
                                temp_target.components.health:DoDelta(-dmg)
                                inst.remember_targets[temp_target] = true
                                if inst.event_cd_timers[temp_target] == nil then
                                    inst.event_cd_timers[temp_target] = inst:DoTaskInTime(10,function()
                                        inst.event_cd_timers[temp_target] = nil
                                    end)
                                    temp_target:PushEvent("attacked", {attacker = player, damage = dmg})
                                end
                    end
                end
            end)
        -----------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function ExtendDebuff(inst)
    end
------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst:AddTag("CLASSIFIED")
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    return inst
end

return Prefab("hoshino_card_debuff_purifying_light", fn)
