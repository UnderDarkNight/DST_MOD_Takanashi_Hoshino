----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local ATTACK_SEARCHING_RADIUS_SQ = 20*20
    local MISSILE_SPEED = 10
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
    local function attacking_event(inst)
        if inst:IsBusy() or not inst:IsWorking() then
            return
        end
        local target = inst:GetTarget()
        local player = inst:GetPlayer()
        if target == nil or player == nil then
            return
        end
        if target and target.components.health and target.components.health:IsDead() then
            return
        end
        if not player.components.combat:CanTarget(target) then
            print("can be attack check fail",target)
            return
        end

        inst:StopMoving()
        inst:SetBusy("attack_monster",true)
        inst:FaceTo(target)
        inst:PushEvent("spawn_missile",{
            target = target,
            onhit = function()
                if target and target.components.combat then
                    local damage,spdamage = inst.components.weapon:GetDamage(player,target)
                    target.components.combat:GetAttacked(player,damage,nil,spdamage)
                    SpawnPrefab("balloon_pop_head").Transform:SetPosition(target.Transform:GetWorldPosition())
                    -- SpawnPrefab("statue_transition_2").Transform:SetPosition(target.Transform:GetWorldPosition())
                    SpawnPrefab("chester_transform_fx").Transform:SetPosition(target.Transform:GetWorldPosition())
                end
            end,
            custom_fn = function(self)
                self:ListenForEvent("onremove",function()
                    SpawnPrefab("balloon_pop_head").Transform:SetPosition(self.Transform:GetWorldPosition())
                    -- SpawnPrefab("statue_transition_2").Transform:SetPosition(target.Transform:GetWorldPosition())
                    SpawnPrefab("chester_transform_fx").Transform:SetPosition(self.Transform:GetWorldPosition())
                    self:Remove()
                end,target)
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
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    inst:ListenForEvent("link",function(inst,player)
        ---- 玩家被设置成目标的时候
        inst:ListenForEvent("hoshino_event.combat_set_target",function(_,target)
            inst:SetTarget(target)
        end,player)
        ---- 玩家主动攻击目标的时候.强制主动攻击玩家的目标
        inst:ListenForEvent("onhitother",function(_,_table)
            local target = _table and _table.target
            if target and target:IsValid() and target.components.combat then
                inst:SetTarget(target,true)
            end
        end,player)
        --- 玩家被攻击的时候
        inst:ListenForEvent("attacked",function(_,_table)
            local target = _table and _table.attacker
            if target and target:IsValid() and target.components.combat then
                inst:SetTarget(target,true)
            end
        end,player)

    end)
    inst.SetTarget = SetTarget
    inst.GetTarget = GetTarget

    inst:DoPeriodicTask(1,attacking_event)

    inst:ListenForEvent("spawn_missile",spawn_missile_event)
end
