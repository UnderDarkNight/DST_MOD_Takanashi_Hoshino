------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.player = target
    -----------------------------------------------------
    --- 获取诅咒个数
        local function GetCurseNum()
            local active_curse_cards_data = target.components.hoshino_cards_sys:GetActivatedCards("card_black") or {}
            local active_cards_num = 0
            for temp_card_name_index, actived_times in pairs(active_curse_cards_data) do
                actived_times = actived_times or 0
                if actived_times > 0 then
                    active_cards_num = active_cards_num + 1
                end
            end
            return active_cards_num
        end
    -----------------------------------------------------
    --- 每次攻击怪物，怪物额外掉血
        inst:ListenForEvent("onhitother",function(player,_table)
            local monster = _table and _table.target
            if not (monster and monster.brainfn and monster.components.health) then
                return
            end
            local max_health = monster.components.health.maxhealth
            local delta_value = max_health*0.004 + GetCurseNum() *max_health*0.003
            monster.components.health:DoDelta(-delta_value)
        end,target)
    -----------------------------------------------------
    --- 诅咒增伤
        local function fix_dmage_mult()
            target.components.combat.externaldamagemultipliers:SetModifier(inst, 1 + GetCurseNum()*0.3 )            
        end
        fix_dmage_mult()
        inst:DoPeriodicTask(5,fix_dmage_mult)
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

return Prefab("hoshino_buff_special_equipment_amulet_t6", fn)
