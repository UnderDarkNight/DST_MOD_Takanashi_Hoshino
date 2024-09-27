------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.player = target
    -----------------------------------------------------
    --- 伤害格挡池
        inst.damage_block_pool = 50
        inst:ListenForEvent("reset_pool", function(inst)
            inst.damage_block_pool = 50
        end)
    -----------------------------------------------------
    --- 
        local sheild_inst = target:SpawnChild("hoshino_sfx_ruiins_sheild")
    -----------------------------------------------------
    --- 
        if target.components.hoshino_com_combat_hooker then
            target.components.hoshino_com_combat_hooker:Add_Modifier(inst,function(player,attacker, damage, weapon, stimuli, spdamage)
                -- print("特殊装备背包T9 BUFF 函数 开始")
                --------------------------------------------
                -- 
                    -- player:SpawnChild("wanda_attack_shadowweapon_old_fx")
                --------------------------------------------
                -- 
                    if damage <= inst.damage_block_pool then --- 池子充足，伤害格挡
                        inst.damage_block_pool = inst.damage_block_pool - damage
                        damage = 0
                        spdamage = nil
                        player.SoundEmitter:PlaySound("dontstarve/impacts/impact_forcefield_armour_dull")
                    else    -- 池子不足，伤害减少
                        damage = damage - inst.damage_block_pool
                        inst.damage_block_pool = 0
                        spdamage = nil
                        player.SoundEmitter:PlaySound("dontstarve/impacts/impact_forcefield_armour_dull")
                    end
                --------------------------------------------
                -- 池子枯竭，移除控制器
                    if inst.damage_block_pool <= 0 then
                        inst:Remove()
                        if sheild_inst then
                            sheild_inst:Remove()
                        end
                        -- print("池子枯竭，移除控制器")
                    else
                        -- print("池子剩余"..inst.damage_block_pool)
                    end
                --------------------------------------------
                return damage,spdamage
            end)            
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

return Prefab("hoshino_buff_special_equipment_backpack_t9", fn)
