------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    被攻击到的生物获得debuff：受到的最终伤害增加100%，持续10s。

]]--
------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.player = target
    -----------------------------------------------------
    --- 
        inst.time = 10
        inst:ListenForEvent("reset",function()
            inst.time = 10
        end)
    -----------------------------------------------------
    --- 计时器
        inst:DoPeriodicTask(1,function()
            inst.time = inst.time - 1
            if inst.time <= 0 then
                inst:Remove()
            end
        end)
    -----------------------------------------------------
    --- 受到的伤害 +100%
        if target.components.combat then
            target.components.combat.externaldamagetakenmultipliers:SetModifier(inst,2)
        end
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
    inst.components.debuff.keepondespawn = false -- 是否保持debuff 到下次登陆
    -- inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetDetachedFn(OnDetached)
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)

    inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务


    return inst
end

return Prefab("hoshino_debuff_special_equipment_amulet_t9", fn)
