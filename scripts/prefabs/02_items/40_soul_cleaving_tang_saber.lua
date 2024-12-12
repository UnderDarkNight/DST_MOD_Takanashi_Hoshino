----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local assets =
    {
        Asset("ANIM", "anim/hoshino_weapon_soul_cleaving_tang_saber.zip"),
        Asset("ANIM", "anim/hoshino_weapon_soul_cleaving_tang_saber_swap.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local BASE_DAMAGE = 17
    local PLANARDAMAGE = 51
    local SPELL_CD_TIME = TUNING.HOSHINO_DEBUGGING_MODE and 200 or 16*60
    local MONSTER_BLACK_LIST = {
        ["ghost"] = true , --- 幽灵
    }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function create_fx(inst,owner)
        inst.sfx = inst.sfx or {}
        for i = 1, 3, 1 do
            local fx = SpawnPrefab("cane_victorian_fx")
            fx.entity:SetParent(owner.entity)
            fx.entity:AddFollower()
            fx.Follower:FollowSymbol(owner.GUID, "swap_object",0,-130 - (i-1)*100, 0)
            table.insert(inst.sfx,fx)
        end

    end
    local function remove_fx(inst)
        inst.sfx = inst.sfx or {}
        for k, v in pairs(inst.sfx) do
            v:Remove()
        end
        inst.sfx = {}
    end
    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "hoshino_weapon_soul_cleaving_tang_saber_swap", "swap_object")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

        -- attacker:PushEvent("killed", { victim = self.inst, attacker = attacker })
        inst.___kill_other_event = inst.___kill_other_event or function(_,_table)
            local target = _table and _table.victim
            if target and target.prefab then
                inst:PushEvent("killed_monster",target)
            end
        end
        inst:ListenForEvent("killed",inst.___kill_other_event,owner)

        if inst.light_fx == nil then
            inst.light_fx = owner:SpawnChild("minerhatlight")
        end

        create_fx(inst,owner)
        
    end

    local function onunequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
        if inst.___kill_other_event then
            inst:RemoveEventCallback("killed",inst.___kill_other_event,owner)
        end
        if inst.light_fx ~= nil then
            inst.light_fx:Remove()
            inst.light_fx = nil
        end
        remove_fx(inst)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 切换攻击动作。
    local hit_fx = {
        "shadowstrike_slash_fx",
        "shadowstrike_slash2_fx",
    }
    local function OnAttackFn(inst, attacker, target)
        if not inst._multithrust_lock then
            inst.components.hoshino_com_polymorphic_attack_action:SetRandomType()
        end
        local x,y,z = target.Transform:GetWorldPosition()
        SpawnPrefab(hit_fx[math.random(#hit_fx)]).Transform:SetPosition(x,2,z)
    end
    local function swtich_event_locker_install(inst)
        inst:ListenForEvent("enter_multithrust",function()
            inst._multithrust_lock = true
        end)
        inst:ListenForEvent("exit_multithrust",function()
            inst._multithrust_lock = false
            inst.components.hoshino_com_polymorphic_attack_action:SetRandomType()
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 伤害更新
    local function damage_update(inst)
        local level = inst.components.hoshino_data:Add("level",0)
        local damage = BASE_DAMAGE + level * 5
        local planar_damage = PLANARDAMAGE + level * 5
        inst.components.weapon:SetDamage(damage)
        inst.components.planardamage:SetBaseDamage(planar_damage)
    end
    local function kill_monster_event(inst, target)
        -- print("击杀目标",target)
        if target and target:HasTag("spawned_by_soul_cleaving_tang_saber") then
            local max_health = target.components.health and target.components.health.maxhealth or 0
            local flag_table = inst.components.hoshino_data:Get("flag_table") or {}
            if (max_health >= 4000 ) and not flag_table[tostring(max_health)] or TUNING.HOSHINO_DEBUGGING_MODE then
                flag_table[tostring(max_health)] = true
                inst.components.hoshino_data:Add("level",1)
                -- print("升级")
            end
            damage_update(inst)
            inst.components.hoshino_data:Set("flag_table",flag_table)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 技能
    local function Spawn_Ghost_Test_Fn(target)
        if target.prefab == "ghost" or MONSTER_BLACK_LIST[target.prefab] then
            return false
        end
        if target.components.health == nil or target.sg == nil or target.brainfn == nil then
            return false
        end
        if target:HasTag("linked_by_soul_cleaving_tang_saber") then
            return false
        end
        return true
    end
    local function Create_Ghost_For_Target(target)
        if not Spawn_Ghost_Test_Fn(target) then
            return false
        end
        local x,y,z = target.Transform:GetWorldPosition()
        local maxhealth = target.components.health.maxhealth
        local currenthealth = target.components.health.currenthealth
        ---- 创建幽灵
        local ghost = SpawnPrefab("ghost")
        ghost.Transform:SetPosition(x,y,z)
        ghost.linked_monster = target
        ghost:AddDebuff("hoshino_debuff_soul_cleaving_tang_saber_monster_debuff","hoshino_debuff_soul_cleaving_tang_saber_monster_debuff")
        ghost:AddDebuff("hoshino_debuff_soul_cleaving_tang_saber_monster_debuff","hoshino_debuff_soul_cleaving_tang_saber_monster_debuff")
        ---- 笨怪
        local test_num = 100
        while test_num > 0 do
            local debuff_inst = target:GetDebuff("hoshino_debuff_gun_eye_of_horus_spell_monster_brain_stop")
            if debuff_inst and debuff_inst:IsValid() then
                debuff_inst:PushEvent("SetTime",math.huge)
                break
            end
            target:AddDebuff("hoshino_debuff_gun_eye_of_horus_spell_monster_brain_stop","hoshino_debuff_gun_eye_of_horus_spell_monster_brain_stop")
            test_num = test_num - 1
        end
        target:AddTag("linked_by_soul_cleaving_tang_saber")
        ghost.components.health.maxhealth = maxhealth
        ghost.components.health.currenthealth = currenthealth
        return true
    end
    local function spell_caster_com_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_point_and_target_spell_caster",function(inst,replica_com)
            replica_com:SetDistance(2)
            replica_com:SetTestFn(function(inst,doer,target,pt,right_click)
                if right_click and target and doer ~= target and target.prefab ~= "ghost" and not MONSTER_BLACK_LIST[target.prefab] then
                    return true
                end
                return false
            end)
            replica_com:SetText("hoshino_weapon_soul_cleaving_tang_saber","砍魂")
            replica_com:SetSGAction("hoshino_com_polymorphic_attack_action_lunge")
        end)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_point_and_target_spell_caster")
        inst.components.hoshino_com_point_and_target_spell_caster:SetSpellFn(function(inst,doer,target,pt)
            if not Spawn_Ghost_Test_Fn(target) then
                return
            end
            if not inst.components.rechargeable:IsCharged() then
                return
            end
            inst.components.rechargeable:Discharge(SPELL_CD_TIME)
            if Create_Ghost_For_Target(target) then
                return true
            end
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_weapon_soul_cleaving_tang_saber")
    inst.AnimState:SetBuild("hoshino_weapon_soul_cleaving_tang_saber")
    inst.AnimState:PlayAnimation("idle")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    -- local swap_data = {sym_build = "swap_cane"}
    -- MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85}, true, 1, swap_data)
    MakeInventoryFloatable(inst)


    inst.entity:SetPristine()
    spell_caster_com_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    -------------------------------------------------------------
    --- 更新伤害
        inst:ListenForEvent("update_damage", damage_update)
        inst:DoTaskInTime(0,damage_update)
        inst:ListenForEvent("killed_monster",kill_monster_event)
    -------------------------------------------------------------
    --- 冷却
        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetMaxCharge(SPELL_CD_TIME)
    -------------------------------------------------------------
    --- 数据库
        inst:AddComponent("hoshino_data")
    -------------------------------------------------------------
    --- 动作切换
        swtich_event_locker_install(inst)
        inst:AddComponent("hoshino_com_polymorphic_attack_action")
    -------------------------------------------------------------
    --- 武器
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(BASE_DAMAGE)
        inst.components.weapon:SetRange(1.5)
        inst.components.weapon:SetOnAttack(OnAttackFn)

        inst:AddComponent("planardamage")
        inst.components.planardamage:SetBaseDamage(PLANARDAMAGE)
    -------------------------------------------------------------
    --- 其他
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "hoshino_weapon_soul_cleaving_tang_saber"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_weapon_soul_cleaving_tang_saber.xml"

        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)

        MakeHauntableLaunch(inst)
    -------------------------------------------------------------
    return inst
end

return Prefab("hoshino_weapon_soul_cleaving_tang_saber", fn, assets)
