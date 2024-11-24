----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

暗影核心
饰品 无耐久
暗影术基座合成 不记忆配方
噩梦燃料*50 纯粹恐惧*15 暗影香炉*1 骨头盔甲*1 骨头头盔*1
免疫精神控制 获得骨头盔甲效果 影怪不会主动攻击你

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/armor_bramble.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function onequip(inst, owner)
        if owner.components.hoshino_com_offical_debuff_blocker then
            owner.components.hoshino_com_offical_debuff_blocker:Add_Modify_Blocker(inst,"mindcontroller","mindcontroller")
        end
        if owner.components.sanity ~= nil then
            owner.components.sanity:SetInducedInsanity(inst, true)
        end
    end

    local function onunequip(inst, owner)
        if owner.components.hoshino_com_offical_debuff_blocker then
            owner.components.hoshino_com_offical_debuff_blocker:Remove_Modify_Blocker(inst)
        end
        if owner.components.sanity ~= nil then
            owner.components.sanity:SetInducedInsanity(inst, false)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("armor_bramble")
    inst.AnimState:SetBuild("armor_bramble")
    inst.AnimState:PlayAnimation("anim")


    inst:AddTag("waterproofer")
    --shadowlevel (from shadowlevel component) added to pristine state for optimization
    inst:AddTag("shadowlevel")
    --shadowdominance (from shadowdominance component) added to pristine state for optimization
    inst:AddTag("shadowdominance")

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
    inst.components.equippable.dapperness = TUNING.CRAZINESS_MED
    inst.components.equippable.is_magic_dapperness = true

    inst:AddComponent("shadowlevel")
    inst.components.shadowlevel:SetDefaultLevel(TUNING.SKELETONHAT_SHADOW_LEVEL)

    inst:AddComponent("shadowdominance")

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMOR_SKELETONHAT, TUNING.ARMOR_SKELETONHAT_ABSORPTION)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)


    MakeHauntableLaunch(inst)
    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_shadow_core", fn, assets)
