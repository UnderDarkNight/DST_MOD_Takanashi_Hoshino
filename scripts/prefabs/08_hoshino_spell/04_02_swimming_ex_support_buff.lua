------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.player = target
    -----------------------------------------------------
    ---
        inst.time = 30
        inst:DoPeriodicTask(0.2,function()
            inst.time = inst.time - 0.2
            if inst.time <= 0 then
                inst:Remove()
            end
        end)
    -----------------------------------------------------
    ---
        inst:ListenForEvent("Set",function(_,_table)
            print("swimming ex support buff",target)
            -- heal_num = heal_num,
            -- speed_mult = speed_mult,
            -- damage_mult = damage_mult,
            -- cost_value_num = cost_value_num,
            -- time = time,

            ---- 更新时间
            if _table.time and inst.time < _table.time then
                inst.time = _table.time
            end
            ---- 更新移动速度
            if target.components.locomotor and _table.speed_mult then
                target.components.locomotor:SetExternalSpeedMultiplier(inst, "hoshino_spell_swimming_ex_support_buff",_table.speed_mult)
            end
            ---- 更新伤害
            if target.components.combat and _table.damage_mult then
                target.components.combat.externaldamagemultipliers:SetModifier(inst,_table.damage_mult)
            end
            ---- 更新治疗量
            if _table.heal_num and inst.heal_num < _table.heal_num then
                inst.heal_num = _table.heal_num
            end
            ---- cost value
            if _table.cost_value_num then
                inst.cost_value_num = _table.cost_value_num
            end

        end)
    -----------------------------------------------------
    --- cost value
        inst.cost_value_num = 0
        inst:DoPeriodicTask(1,function()
            if target.components.hoshino_com_power_cost and inst.cost_value_num > 0 then
                target.components.hoshino_com_power_cost:DoDelta(inst.cost_value_num)
            end
        end)
    -----------------------------------------------------
    --- health value
        inst.heal_num = 0
        inst:DoPeriodicTask(1,function()
            if target.components.health and inst.heal_num > 0 then
                target.components.health:DoDelta(inst.heal_num,true)
            end
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

    inst:AddTag("CLASSIFIED")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    -- inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    -- inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetDetachedFn(OnDetached)
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)

    -- inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务


    return inst
end

return Prefab("hoshino_spell_swimming_ex_support_buff", fn)
