------------------------------------------------------------------------------------------------------------------------------------------------
--[[

55、【彩】【照我以火】【击杀任意生物会产生半径6伤害200的爆炸，被爆炸炸死的也一样触发】【从卡池移除】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local musthavetags = {"_combat"}
    local canthavetags = {"companion","player", "brightmare", "playerghost", "INLIMBO","flight","chester","hutch","DECOR", "FX","structure","wall","engineering","eyeturret"}
    local musthaveoneoftags = nil
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function CanBeAttack(monster,player)
        if monster.components.health and not monster.components.health:IsDead() 
        and monster.components.combat and monster.components.combat:CanBeAttacked(player) 
        and player.components.combat:ShouldAggro(monster) --- 鲨鱼、梦魇疯猪 这类击杀不死亡的目标，靠这个判断是否可以继续被攻击。
        then
            return true
        end
        return false
    end
------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.target = target
    -----------------------------------------------------
    --- 
        
    -----------------------------------------------------
    --- 
        target:ListenForEvent("killed",function(_,_table)
            local killed_monster = _table and _table.victim
            -- print("fake error :killed",killed_monster)
            if killed_monster == nil then
                return
            end
            local pt = Vector3(killed_monster.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pt.x,0,pt.z,TUNING.HOSHINO_DEBUGGING_MODE and 12 or 6,musthavetags,canthavetags,musthaveoneoftags)
            for k, temp_monster in pairs(ents) do
                -- print("fake error searching",temp_monster,CanBeAttack(temp_monster,target))
                if temp_monster and temp_monster ~= target and CanBeAttack(temp_monster,target) then
                    target.components.combat:DoAttack(temp_monster,inst)
                end
            end
            SpawnPrefab("hoshino_sfx_explode"):PushEvent("Set",{
                -- target = temp_monster,
                pt = pt,
                scale = 2,
            })
        end)
    -----------------------------------------------------
    -- 
        -- print("fake error debuff 成功安装到",target)
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

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(200)

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

return Prefab("hoshino_card_debuff_kill_and_explode", fn)
