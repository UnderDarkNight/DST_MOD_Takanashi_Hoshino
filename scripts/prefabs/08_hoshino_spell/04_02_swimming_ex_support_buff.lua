------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.player = target
    -----------------------------------------------------
    --- 关键参数
        local RADIUS = 8
        local RADIUS_SQ = RADIUS * RADIUS
        inst.player_list = {}
    -----------------------------------------------------
    --- 特效
        local fx = target:SpawnChild("hoshino_sfx_icelance_ping")
        fx:PushEvent("Set",{
            pt = Vector3(0,0,0),
            radius = RADIUS,
        })
        local fx2 = target:SpawnChild("hoshino_sfx_wave")
        fx2:PushEvent("Set",{
            pt = Vector3(0,0,0),
            radius = RADIUS,
        })
        
    -----------------------------------------------------
    ---
        inst.time = 30
        inst:DoPeriodicTask(0.2,function()
            inst.time = inst.time - 0.2
            if inst.time <= 0 then
                inst:Remove()
                fx:Remove()
                fx2:Remove()
            end
        end)
    -----------------------------------------------------
    ---
        inst:ListenForEvent("SetTime",function(inst,time)
            inst.time = time
        end)
    -----------------------------------------------------
    --- 遍历合适玩家
        inst:DoPeriodicTask(0.5,function()
            local x,y,z = target.Transform:GetWorldPosition()
            local players = TheSim:FindEntities(x, 0, z, RADIUS, {"player"},{"playerghost"})
            for _,player in ipairs(players) do
                inst.player_list[player] = player:GetDistanceSqToInst(target)
            end
        end)
    -----------------------------------------------------
    --- 给玩家上buff
        inst:DoPeriodicTask(1,function()
            local player_level = target.components.hoshino_com_level_sys:GetLevel()
            local heal_num = 5 +player_level * 0.05
            local speed_mult = 1.3
            local damage_mult = (30+player_level)/100 + 1
            local cost_value_num = 0.02 + player_level*0.002

            --- 刷新距离参数
            for player, _ in pairs(inst.player_list) do
                inst.player_list[player] = player:GetDistanceSqToInst(target)
            end
            --- 遍历玩家
            local need_to_remove_list = {}
            for player, distance_sq in pairs(inst.player_list) do
                if player and player:IsValid() and distance_sq <= RADIUS_SQ then
                    ---- 治疗量
                    if player.components.health and not player.components.health:IsDead() then
                        player.components.health:DoDelta(heal_num,true)
                    end
                    ---- cost
                    if player.components.hoshino_com_power_cost then
                        player.components.hoshino_com_power_cost:DoDelta(cost_value_num)
                    end
                    ---- 设置加速器
                    if player.components.locomotor then
                        player.components.locomotor:SetExternalSpeedMultiplier(inst, "hoshino_spell_swimming_ex_support_buff",speed_mult)
                    end
                    ---- 设置伤害倍增
                    if player.components.combat then
                        player.components.combat.externaldamagemultipliers:SetModifier(inst,damage_mult)
                    end
                else
                    need_to_remove_list[player] = true
                end
            end
            ---- 移除不在范围内的玩家
            for player, _ in pairs(need_to_remove_list) do
                if player and player:IsValid() then
                    --- 移除加速器
                    if player.components.locomotor then
                        player.components.locomotor:RemoveExternalSpeedMultiplier(inst, "hoshino_spell_swimming_ex_support_buff")
                    end
                    --- 移除伤害倍增
                    if player.components.combat then
                        player.components.combat.externaldamagemultipliers:RemoveModifier(inst)
                    end
                end
            end
            ---- 更新列表
            local new_list = {}
            for player, _ in pairs(inst.player_list) do
                if not need_to_remove_list[player] then
                    new_list[player] = player:GetDistanceSqToInst(target)
                end
            end
            inst.player_list = new_list

        end)
    -----------------------------------------------------    
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
    -- inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    -- inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetDetachedFn(OnDetached)
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)

    -- inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务


    return inst
end

return Prefab("hoshino_spell_swimming_ex_support_buff", fn)
