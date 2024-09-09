------------------------------------------------------------------------------------------------------------------------------------------------
--[[

60、【彩】【壁垒】【受到攻击后，获得一个10s的铥矿冒效果，效果持续期间，攻击伤害的1%转换为玩家血量】【吸血叠加】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.target = target
    -----------------------------------------------------
    --- 
        local working_task = nil
        local sheild_inst = nil
        target.components.hoshino_com_combat_hooker:Add_Modifier(inst,function(player,attacker, damage, weapon, stimuli, spdamage)
            if working_task then
                --- 处理吸血
                local vengeance_percent = player.components.hoshino_com_debuff:Add("hoshino_card_debuff_ruins_sheild_and_vengeance",0)
                if vengeance_percent > 0 then
                    local health_delta_value = damage * vengeance_percent
                    player.components.health:DoDelta(health_delta_value,true)
                end

                damage = 0
                spdamage = nil
                player.SoundEmitter:PlaySound("dontstarve/impacts/impact_forcefield_armour_dull")
            elseif damage > 0 and working_task == nil and sheild_inst == nil then
                working_task = player:DoTaskInTime(10, function()
                    working_task = nil
                    if sheild_inst then
                        sheild_inst:PushEvent("close")
                        sheild_inst = nil
                    end
                end)
                sheild_inst = player:SpawnChild("hoshino_sfx_ruiins_sheild")                
            end
            return damage,spdamage
        end)
    -----------------------------------------------------
end

local function OnDetached(inst) -- 被外部命令  inst:RemoveDebuff 移除debuff 的时候 执行
    local player = inst.target
end

local function OnUpdate(inst)
    local player = inst.target

end

local function ExtendDebuff(inst)
    -- inst.countdown = 3 + (inst._level:value() < CONTROL_LEVEL and EXTEND_TICKS or math.floor(TUNING.STALKER_MINDCONTROL_DURATION / FRAMES + .5))
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(200)

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    -- inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetDetachedFn(OnDetached)
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)

    -- inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务


    return inst
end

return Prefab("hoshino_card_debuff_ruins_sheild_and_vengeance", fn)
