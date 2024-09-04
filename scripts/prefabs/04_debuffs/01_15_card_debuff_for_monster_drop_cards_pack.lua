------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.target = target
    -----------------------------------------------------
    --- 
        -- print("fake error hoshino_card_debuff_for_monster_drop_cards_pack",target)
    -----------------------------------------------------
    --- 死亡掉落 金色 3选 1
        inst:ListenForEvent("entity_droploot",function(_,_table)
            local monster = _table and _table.inst
            if monster == target and target.components.lootdropper then
                local item = target.components.lootdropper:SpawnLootPrefab("hoshino_item_cards_pack")
                if item then
                    item:PushEvent("Set",{
                        cards = {
                            "card_golden",
                            "card_golden",
                            "card_golden",
                        }
                    })
                    item:PushEvent("SetName","Golden 3-1")
                end
            end
            inst:Remove()
        end,TheWorld)
    -----------------------------------------------------
    --- 血量，攻击力是普通的3倍
        if target.components.health then
            local old_max = target.components.health.maxhealth
            target.components.health.maxhealth = old_max * 3
        end
        if target.components.combat then
            local origin_dmg = target.components.combat.defaultdamage or 0
            target.components.combat.defaultdamage = origin_dmg * 3
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

return Prefab("hoshino_card_debuff_for_monster_drop_cards_pack", fn)
