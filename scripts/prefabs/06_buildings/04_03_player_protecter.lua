----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local ATTACK_SEARCHING_RADIUS = 20
    local ATTACK_SEARCHING_RADIUS_SQ = ATTACK_SEARCHING_RADIUS*ATTACK_SEARCHING_RADIUS
    local MISSILE_SPEED = 17
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function SetTarget(inst,target,force)
        if force then
            inst.target = target
            return
        end
        if inst.target and inst.target:IsValid() then
            return
        end
        inst.target = target
    end
    local function GetTarget(inst)
        if inst.target and inst.target:IsValid() and inst:GetDistanceSqToInst(inst.target) < ATTACK_SEARCHING_RADIUS_SQ then
            return inst.target
        end
        inst.target = nil
        return nil
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local BOUNCE_MUST_TAGS = { "_combat" }
    local BOUNCE_NO_TAGS = { "INLIMBO", "wall", "notarget", "player", "companion", "flight", "invisible", "noattack", "hiding" }
    local function Search_New_Target(inst)
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,0, z, ATTACK_SEARCHING_RADIUS, BOUNCE_MUST_TAGS, BOUNCE_NO_TAGS, nil)
        if #ents > 0 then
            for k, tempMonster in pairs(ents) do
                if tempMonster and tempMonster:IsValid() then
                    local monster_attacking_target = tempMonster.components.combat.target
                    if monster_attacking_target and monster_attacking_target:HasOneOfTags({"player","companion"}) then
                        return tempMonster
                    end
                end
            end
        end
        return nil
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function attacking_event(inst)
        if inst:IsBusy() or not inst:IsWorking() or not inst:HasEquipment("eyeturret_item") then
            -- print("无人机无法进行攻击：忙碌",inst:IsBusy()," 工作状态",inst:IsWorking()," 标签",inst:HasTag("eyeturret_item"))
            inst:SetTarget(nil,true)
            return
        end
        local target = inst:GetTarget() or Search_New_Target(inst)
        local player = inst:GetPlayer()
        if target == nil or player == nil then
            -- print("无人机没有目标")
            return
        end
        if target and target.components.health and target.components.health:IsDead() then
            -- print("无人机的目标死亡")
            return
        end
        if not player.components.combat:CanTarget(target) then
            -- print("can be attack check fail",target)
            -- print("无人机攻击目标检查 失败",target)
            return
        end
        inst:SetTarget(target,true)
        inst:StopMoving()
        inst:SetBusy("attack_monster")
        inst:FaceTo(target)
        inst:PushEvent("spawn_missile",{
            target = target,
            onhit = function()
                if target then
                    if target:IsValid() and target.components.combat then
                        local damage,spdamage = inst.components.weapon:GetDamage(player,target)
                        target.components.combat:GetAttacked(player,damage,inst,nil,spdamage)
                    end
                    SpawnPrefab("halloween_firepuff_3").Transform:SetPosition(target.Transform:GetWorldPosition())
                    -- SpawnPrefab("balloon_pop_head").Transform:SetPosition(target.Transform:GetWorldPosition())
                    -- SpawnPrefab("statue_transition_2").Transform:SetPosition(target.Transform:GetWorldPosition())
                    -- SpawnPrefab("chester_transform_fx").Transform:SetPosition(target.Transform:GetWorldPosition())
                end
            end,
        })
        inst:DoTaskInTime(0.3,function()
            inst:RemoveBusy("attack_monster")
        end)

    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function spawn_missile_event(inst,_table)
        -- _table = _table or {
        --     target = target,
        --     onhit = function() end,
        -- }
        local missile = SpawnPrefab("hoshino_projectile_missile")
        missile:PushEvent("Set",{
            pt = Vector3(inst.Transform:GetWorldPosition()),
            target = _table.target,
            speed = MISSILE_SPEED or 10,
            doer = inst:GetPlayer(),
            onhit = _table.onhit,
        })
        missile:DoTaskInTime(5,missile.Remove)
        if _table.custom_fn then
            _table.custom_fn(missile)
        end
        missile:ListenForEvent("onremove",function()
            missile:Remove()
        end,inst)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    inst:ListenForEvent("link",function(inst,player)
        ---- 玩家被设置成目标的时候
        inst:ListenForEvent("hoshino_event.combat_set_target",function(_,target)
            -- print(" 无人机检测到 玩家被怪物仇恨",target)
            inst:SetTarget(target)
        end,player)
        ---- 玩家主动攻击目标的时候.强制主动攻击玩家的目标
        inst:ListenForEvent("onhitother",function(_,_table)
            local target = _table and _table.target
            local weapon = _table and _table.weapon
            if target and target:IsValid() and weapon ~= inst and target.components.combat then
                -- print(" 无人机检测到 玩家主动攻击怪物",target,weapon,inst)
                inst:SetTarget(target,true)
            end
        end,player)
        --- 玩家被攻击的时候
        inst:ListenForEvent("attacked",function(_,_table)
            local target = _table and _table.attacker
            if target and target:IsValid() and target.components.combat then
                -- print(" 无人机检测到 玩家被怪物攻击",target)
                inst:SetTarget(target,true)
            end
        end,player)

    end)
    inst.SetTarget = SetTarget
    inst.GetTarget = GetTarget

    inst:DoPeriodicTask(1,attacking_event)

    inst:ListenForEvent("spawn_missile",spawn_missile_event)
end
