------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    -- inst.Network:SetClassifiedTarget(target)
    inst.Transform:SetPosition(0,0,0)
    inst.target = target
    -----------------------------------------------------
    ---         
    -----------------------------------------------------
    ---
        local action_list = {   
                [ACTIONS.CHOP] = true,
                [ACTIONS.MINE] = true,
                [ACTIONS.HAMMER] = true,
                [ACTIONS.DIG] = true,
           }
        -- target.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,0.5,inst)
        for TEMP_ACTION,flag in ipairs(action_list) do
            target.components.workmultiplier:AddMultiplier(TEMP_ACTION,0.5,inst)
        end
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

return Prefab("hoshino_card_debuff_reduced_work_efficiency", fn)
