------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
--
    local function pause_timer_com(inst)
        if inst.components.timer then
            local names = {}
            for timer_name_index, v in pairs(inst.components.timer.timers) do
                names[timer_name_index] = true
            end
            for timer_name_index, v in pairs(names) do
                inst.components.timer:PauseTimer(timer_name_index)
            end
        end
    end
    local function resume_timer_com(inst)
        if inst.components.timer then
            local names = {}
            for timer_name_index, v in pairs(inst.components.timer.timers) do
                names[timer_name_index] = true
            end
            for timer_name_index, v in pairs(names) do
                inst.components.timer:ResumeTimer(timer_name_index)
            end
        end
    end
    local function stop_sg(inst)
        if inst.sg then
            inst.sg:Stop()
        end
    end
    local function start_sg(inst)
        if inst.sg then
            inst.sg:Start()
        end
    end

    local function Stop_AI(target)
        -- target:StopBrain()
        if target.brain then
            target.brain:Stop()
        end
        stop_sg(target)
        pause_timer_com(target)
    end
    local function Start_AI(target)
        -- target:RestartBrain()
        if target.brain then
            target.brain:Start()
        end
        start_sg(target)
        resume_timer_com(target)
    end
------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    -- inst.player = target
    -----------------------------------------------------
    ---
        inst.time = inst.time or 3
        inst:DoPeriodicTask(1,function()
            inst.time = inst.time - 1
            if inst.time <= 0 then
                inst:Remove()
                Start_AI(target)
            end
        end)
    -----------------------------------------------------
    ---
        Stop_AI(target)
    -----------------------------------------------------
    --- 
        inst:ListenForEvent("minhealth",function()
            Start_AI(target)
            inst:Remove()
        end,target)
    -----------------------------------------------------
    ---
        inst:ListenForEvent("force_remove",function()
            Start_AI(target)
            inst:Remove()
        end)
    -----------------------------------------------------
    ---
        inst:ListenForEvent("SetTime",function(_,_time)
            if _time > inst.time then
                inst.time = _time
            end
        end)
    -----------------------------------------------------
end

local function OnDetached(inst) -- 被外部命令  inst:RemoveDebuff 移除debuff 的时候 执行
-- local player = inst.player
end

local function OnUpdate(inst)
-- local player = inst.player

end

local function ExtendDebuff(inst)
    inst.time = (inst.time or 0 ) + 3
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
    -- inst.components.debuff:SetDetachedFn(OnDetached)
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)

    -- inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务


    return inst
end

return Prefab("hoshino_debuff_gun_eye_of_horus_spell_monster_brain_stop", fn)
