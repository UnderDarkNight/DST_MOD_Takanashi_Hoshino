------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.target = target
    -----------------------------------------------------
    --- 根据掉San的量来掉血
        inst:ListenForEvent("sanitydelta",function(_,_table)
            if target:HasTag("playerghost") then
                return
            end
            local oldpercent = _table.oldpercent
            local newpercent = _table.newpercent
            if newpercent < oldpercent then
                local delta_percent =  oldpercent - newpercent
                local delta_sanity = delta_percent*target.components.sanity.max
                target.components.health:DoDelta(-delta_sanity,true)
            end
        end,target)
    -----------------------------------------------------
    --- 计时器
        inst:DoPeriodicTask(1,function()
            if target.components.hoshino_data:Add("hoshino_card_debuff_damage_mult_and_sanity",-1) <= 0 then
                inst:Remove()
            end
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

return Prefab("hoshino_card_debuff_damage_mult_and_sanity", fn)
