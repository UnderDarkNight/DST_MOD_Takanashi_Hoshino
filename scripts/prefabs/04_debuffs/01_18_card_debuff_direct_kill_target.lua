------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    buff在玩家身上：上 event 监听

    buff 在怪物身上： 上持续性伤害 操作

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function debuff_active_in_player(player)
        player:ListenForEvent("onhitother",function(_,_table)
            local target = _table and _table.target
            -- print("debuff_direct_kill_target",target)
            if target and target:IsValid() and not target:HasTag("player") 
                and target.components.health and not target.components.health:IsDead() and (target.components.health:GetPercent()<=0.7 or TUNING.HOSHINO_DEBUGGING_MODE)
                and target.components.combat then
                    
                    if math.random(10000)/10000 < player.components.hoshino_com_debuff:Add("hoshino_card_debuff_direct_kill_target",0) or TUNING.HOSHINO_DEBUGGING_MODE then
                        target.____hoshino_card_debuff_direct_kill_target_doer = player
                        --- 给目标上造成伤害的debuff
                        local debuff_prefab = "hoshino_card_debuff_direct_kill_target"
                        while true do
                            local debuff_inst = target:GetDebuff(debuff_prefab)
                            if debuff_inst and debuff_inst:IsValid() then
                                break
                            end
                            target:AddDebuff(debuff_prefab,debuff_prefab)
                        end
                        -- print("成功给目标上debuff")

                    end

            end
        end)
        -- print("fake error 玩家成功安装 event")
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function debuff_active_in_monster(target,debuff_inst)
        local function do_damage_by_player()
            if target and target:IsValid() and target.components.health and not target.components.health:IsDead() 
            and target.components.combat then
                local attacker = target.____hoshino_card_debuff_direct_kill_target_doer
                if attacker and attacker:IsValid() 
                    and target.components.combat:CanBeAttacked(attacker) 
                    and attacker.components.combat:ShouldAggro(target) --- 鲨鱼、梦魇疯猪 这类击杀不死亡的目标，靠这个判断是否可以继续被攻击。
                then 
                    target.components.combat:GetAttacked(attacker,9999999999)
                end
            end
        end
        do_damage_by_player()
        debuff_inst.time = 120  -- debuff 持续时间
        debuff_inst:DoPeriodicTask(0.5,function()
            do_damage_by_player()
            debuff_inst.time = debuff_inst.time - 1
            if debuff_inst.time <= 0 then
                debuff_inst:Remove()
            end
        end)
    end
------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    -- inst.Network:SetClassifiedTarget(target)
    inst.Transform:SetPosition(0,0,0)
    inst.target = target
    -----------------------------------------------------
    --- 
        if target:HasTag("player") then
            debuff_active_in_player(target)
        else
            debuff_active_in_monster(target,inst)
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

return Prefab("hoshino_card_debuff_direct_kill_target", fn)
