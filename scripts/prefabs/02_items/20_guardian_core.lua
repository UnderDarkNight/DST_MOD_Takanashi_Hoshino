----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

守护者核心
饰品 amulet 无耐久
由远古守护者掉落
攻击时会召唤暗影触手（类似铥矿棒）。暗影触手造成34点伤害

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/armor_bramble.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function NoHoles(pt)
        return not TheWorld.Map:IsPointNearHole(pt)
    end

    local function onattack(inst, owner, target)
        if math.random() < 0.2 or TUNING.HOSHINO_DEBUGGING_MODE then
            local pt
            if target ~= nil and target:IsValid() then
                pt = target:GetPosition()
            else
                pt = owner:GetPosition()
                target = nil
            end
            local offset = FindWalkableOffset(pt, math.random() * TWOPI, 2, 3, false, true, NoHoles, false, true)
            if offset ~= nil then
                local tentacle = SpawnPrefab("shadowtentacle")
                if tentacle ~= nil then
                    tentacle.components.combat:SetDefaultDamage(34)
                    tentacle.owner = owner
                    tentacle.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
                    tentacle.components.combat:SetTarget(target)
                    tentacle.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_1")
                    tentacle.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")
                end
            end
        end
    end
    local function on_attack_event_for_player(player,_table)
        local target = _table and _table.target
        if target and target:IsValid() then
            onattack(player,player,target)
        end
    end
    local function onequip(inst, owner)
        inst:ListenForEvent("onhitother",on_attack_event_for_player,owner)
    end

    local function onunequip(inst, owner)
        inst:RemoveEventCallback("onhitother",on_attack_event_for_player,owner)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    -- inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("armor_bramble")
    inst.AnimState:SetBuild("armor_bramble")
    inst.AnimState:PlayAnimation("anim")


    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("leafymeatburger")
            -- inst.components.inventoryitem.imagename = "hoshino_equipment_sandstorm_core"
            -- inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_sandstorm_core.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)


    MakeHauntableLaunch(inst)
    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_guardian_core", fn, assets)
