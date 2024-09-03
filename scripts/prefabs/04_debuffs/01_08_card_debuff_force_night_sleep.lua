------------------------------------------------------------------------------------------------------------------------------------------------
--- 来自 曼德拉草(mandrake) 的代码。
    local SLEEPTARGETS_CANT_TAGS = { "playerghost", "FX", "DECOR", "INLIMBO" }
    local SLEEPTARGETS_ONEOF_TAGS = { "sleeper", "player" }

    local function doareasleep(inst, range, time)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, range, nil, SLEEPTARGETS_CANT_TAGS, SLEEPTARGETS_ONEOF_TAGS)
        local canpvp = not inst:HasTag("player") or TheNet:GetPVPEnabled() or true
        for i, v in ipairs(ents) do
            if (v == inst or canpvp or not v:HasTag("player")) and
                not (v.components.freezable ~= nil and v.components.freezable:IsFrozen()) and
                not (v.components.pinnable ~= nil and v.components.pinnable:IsStuck()) and
                not (v.components.fossilizable ~= nil and v.components.fossilizable:IsFossilized()) then
                local mount = v.components.rider ~= nil and v.components.rider:GetMount() or nil
                if mount ~= nil then
                    mount:PushEvent("ridersleep", { sleepiness = 7, sleeptime = time + math.random() })
                end
                if v:HasTag("player") then
                    v:PushEvent("yawn", { grogginess = 4, knockoutduration = time + math.random() })
                elseif v.components.sleeper ~= nil then
                    v.components.sleeper:AddSleepiness(7, time + math.random())
                elseif v.components.grogginess ~= nil then
                    v.components.grogginess:AddGrogginess(4, time + math.random())
                else
                    v:PushEvent("knockedout")
                end
            end
        end
    end

------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.target = target
    -----------------------------------------------------
    --- 上event
        inst:WatchWorldState("isnight",function()
            if TheWorld.state.isnight then
                doareasleep(target,1,20)
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

return Prefab("hoshino_card_debuff_force_night_sleep", fn)
