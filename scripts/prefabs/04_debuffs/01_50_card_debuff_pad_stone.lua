------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【垫脚石】你的攻击倍率和移速倍率不低于1.0

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local TASK_REFRESH_TIME = 1
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player
        -----------------------------------------------------
        --- 周期性检查。先把自己的参数设为1，再重算倍增参数        
            inst:DoPeriodicTask(TASK_REFRESH_TIME,function()
                ---------------------------------------------
                --- combat
                    if player.components.combat then
                        player.components.combat.externaldamagemultipliers:SetModifier(inst,1)
                        --- 得到当前的总参数
                        local dmg_mult = player.components.combat.externaldamagemultipliers:Get()
                        if dmg_mult < 1 and dmg_mult > 0 then -- 0 ~ 1.0   强制倍乘为1
                            local ret_dmg_mult = 1/dmg_mult
                            player.components.combat.externaldamagemultipliers:SetModifier(inst,ret_dmg_mult)
                        end
                    end
                ---------------------------------------------
                --- locomotor
                    if player.components.locomotor then
                        player.components.locomotor:SetExternalSpeedMultiplier(inst,inst.prefab, 1.0)
                        local speed_mult = player.components.locomotor:GetSpeedMultiplier()
                        if not player.components.rider:IsRiding() and speed_mult < 1 and speed_mult > 0 then
                            local ret_speed = 1/speed_mult
                            player.components.locomotor:SetExternalSpeedMultiplier(inst,inst.prefab, ret_speed)
                            -- print("跑路速度 被重置为1.0")
                        end
                    end
                ---------------------------------------------
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

return Prefab("hoshino_card_debuff_pad_stone", fn)
