------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    -- inst.Network:SetClassifiedTarget(target)
    inst.Transform:SetPosition(0, 0, 0)
    inst.player = target
    -----------------------------------------------------
    ---
        inst.time = 30
        inst:DoPeriodicTask(1,function()
            -------------------------------------------
            --- 计时器
                inst.time = inst.time - 1
                if inst.time <= 0 then
                    inst:Remove()
                end
            -------------------------------------------
            --- 治疗。每秒4%
                if target:HasTag("playerghost") then
                    return
                end
                local max_health  = target.components.health.maxhealth
                local heal_num = max_health*(TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_HEAL_BUFF_HEAL_PERCENT_PRE_SECOND or 4/100)
                target.components.health:DoDelta(heal_num,true)
            -------------------------------------------
            --- 特效
                if inst.time %2 == 0 then
                    -- target:SpawnChild("itemmimic_puff")
                    -- target:SpawnChild("wormwood_lunar_transformation_finish")
                    local fx = SpawnPrefab("wormwood_lunar_transformation_finish")
                    fx.Transform:SetPosition(target.Transform:GetWorldPosition())
                    fx.Transform:SetScale(0.5,0.5,0.5)
                end
            -------------------------------------------
        end)
        inst:ListenForEvent("SetTime",function(inst,time)
            inst.time = time
        end)
    -----------------------------------------------------
end

local function OnDetached(inst) -- 被外部命令  inst:RemoveDebuff 移除debuff 的时候 执行
    local player = inst.player
end

local function OnUpdate(inst)
    local player = inst.player

end

local function ExtendDebuff(inst)
    -- inst.countdown = 3 + (inst._level:value() < CONTROL_LEVEL and EXTEND_TICKS or math.floor(TUNING.STALKER_MINDCONTROL_DURATION / FRAMES + .5))
end

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
    -- inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetDetachedFn(OnDetached)
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)

    -- inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务


    return inst
end

return Prefab("hoshino_spell_normal_heal_buff", fn)
