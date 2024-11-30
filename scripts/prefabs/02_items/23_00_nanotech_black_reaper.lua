----------------------------------------------------------------------------------------------------------------------------------------------------
---

----------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_weapon_nanotech_black_reaper.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local ATTACK_RANGE = 16
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 穿脱
    local function add_fx(inst,owner)
        if inst.fx then
            inst.fx:Remove()
        end
        local fx = SpawnPrefab("hoshino_weapon_nanotech_black_reaper_fx")
        fx.entity:SetParent(owner.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, 0, 0,true)
        inst.fx = fx
    end
    local function onequip(inst, owner)
        -- owner.AnimState:OverrideSymbol("swap_object", "hoshino_weapon_nanotech_black_reaper", "swap_in_hand")
        owner.AnimState:ClearOverrideSymbol("swap_object")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
        add_fx(inst,owner)
    end

    local function onunequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
        if inst.fx then
            inst.fx:Remove()
            inst.fx = nil
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 模块安装
    local function point_target_spell_caster_com_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_point_and_target_spell_caster",function(inst,replica_com)
            replica_com:SetAllowCanCastOnImpassable(true)
            replica_com:SetDistance(ATTACK_RANGE)
            replica_com:SetAllowCastWhenRiding(true)
            replica_com:SetTestFn(function(inst,doer,target,pt,right_click)
                if doer ~= target and right_click then
                    return true
                end
            end)
            replica_com:SetText("hoshino_weapon_nanotech_black_reaper","攻击")
            replica_com:SetSGAction("attack")
        end)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_point_and_target_spell_caster")
        inst.components.hoshino_com_point_and_target_spell_caster:SetSpellFn(function(inst,doer,target,pt)
            -- print("cast spell ",target,pt)
            inst:PushEvent("reaper_attack",{target = target,pt = pt,doer = doer})
            return true
        end)
    end
    local function weapon_on_hit_fn(inst, attacker, target)
        -- print("weapon_on_hit_fn",attacker,target)
        inst:PushEvent("reaper_attack",{target = target,doer = attacker})
    end

    local main_atk_fn = require("prefabs/02_items/23_01_nanotech_black_reaper_main")
    local function main_module_install(inst)
        inst:ListenForEvent("reaper_attack",function(_,_table)
            local target = _table.target
            local pt = _table.pt
            local doer = _table.doer
            main_atk_fn(inst,doer,target,pt)
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_weapon_nanotech_black_reaper")
    inst.AnimState:SetBuild("hoshino_weapon_nanotech_black_reaper")
    inst.AnimState:PlayAnimation("idle")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85})

    inst.entity:SetPristine()

    point_target_spell_caster_com_install(inst)

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("hoshino_data")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(ATTACK_RANGE)
    inst.components.weapon:SetOnAttack(weapon_on_hit_fn)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)
    -------------------------------------------------------------------
    ---
        function inst:GetDamage()
            local damage = 6
            local list = self.components.hoshino_data:Get("list") or {}
            for k,v in pairs(list) do
                damage = damage + 1
            end
            return damage
        end
        function inst:RememberAttackedMonster(prefab)
            local list = self.components.hoshino_data:Get("list") or {}
            list[prefab] = true
            self.components.hoshino_data:Set("list",list)
        end
    -------------------------------------------------------------------
    ---     
        main_module_install(inst)
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                inst.AnimState:PlayAnimation("water")
            else                                
                inst.AnimState:PlayAnimation("idle")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    return inst
end
local function fx()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.AnimState:SetBank("hoshino_weapon_nanotech_black_reaper")
    inst.AnimState:SetBuild("hoshino_weapon_nanotech_black_reaper")
    inst.AnimState:PlayAnimation("in_hand_fx")
    inst.entity:SetPristine()
    inst:AddTag("FX")
    inst:AddTag("fx")
    return inst
end
local function mark_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()
    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")      --- 不可点击
    inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
    inst:AddTag("NOBLOCK")      -- 不会影响种植和放置
    if not TheWorld.ismastersim then
        return inst
    end
    inst:DoTaskInTime(0,function()
        if not inst.Ready then
            inst:Remove()
        end
    end)
    return inst
end

return Prefab("hoshino_weapon_nanotech_black_reaper", fn, assets),
    Prefab("hoshino_weapon_nanotech_black_reaper_fx", fx, assets),
    Prefab("hoshino_weapon_nanotech_black_reaper_mark", mark_fn, assets)
