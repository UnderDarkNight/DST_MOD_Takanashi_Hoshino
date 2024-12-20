------------------------------------------------------------------------------------------------------------------------------------------------
local function player_health_down_task(inst)
    if inst.components.health and not inst.components.health:IsDead() and not inst:HasTag("playerghost") then
        inst.components.health:DoDelta(-1,nil,"hoshino_card_debuff_bloodshed")
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    -- inst.Network:SetClassifiedTarget(target)
    inst.Transform:SetPosition(0,0,0)
    inst.target = target
    -----------------------------------------------------
    --- 上event
        inst:ListenForEvent("healthdelta",function(_,_table)
            local oldpercent = _table.oldpercent
            local newpercent = _table.newpercent
            local cause = _table.cause
            if newpercent >= oldpercent then -- 新血量大于等于旧血量,则不执行
                return
            end
            if cause == "hoshino_card_debuff_bloodshed" then -- 是这个Debuff造成的,则不执行
                return
            end
            local delta_percent = oldpercent - newpercent
            local delta_health = math.ceil(target.components.health.maxhealth * delta_percent) -- 损失的血量(向上取整)
            if delta_health > 0 then
                for i = 1, delta_health, 1 do
                    target:DoTaskInTime(i,player_health_down_task)
                end
            end
        end,target)
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

return Prefab("hoshino_card_debuff_bloodshed", fn)
