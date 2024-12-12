----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

废旧机械板材
护符 无耐久 
不可拆解
烂电线*15 融化的弹珠*15 齿轮*15
为自身附加绝缘效果 ，你的攻击具有“带电”效果

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_equipment_used_mechanical_sheets.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function onequip(inst, owner)
        owner:AddDebuff("hoshino_equipment_used_mechanical_sheets", "buff_electricattack")
    end

    local function onunequip(inst, owner)
        owner:RemoveDebuff("hoshino_equipment_used_mechanical_sheets")
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("hoshino_equipment_used_mechanical_sheets")
    inst.AnimState:SetBuild("hoshino_equipment_used_mechanical_sheets")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_equipment_sandstorm_core"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_sandstorm_core.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.insulated = true


    MakeHauntableLaunch(inst)
    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_used_mechanical_sheets", fn, assets)
