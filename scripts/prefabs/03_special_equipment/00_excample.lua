--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/cane.zip"),
    Asset("ANIM", "anim/swap_cane.zip"),

    Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_excample_shoes.tex" ),
    Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_excample_shoes.xml" ),
    Asset( "IMAGE", "images/inspect_pad/hoshino_pad_excample_shoes.tex" ),
    Asset( "ATLAS", "images/inspect_pad/hoshino_pad_excample_shoes.xml" ),

    Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_excample_backpack.tex" ),
    Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_excample_backpack.xml" ),
    Asset( "IMAGE", "images/inspect_pad/hoshino_pad_excample_backpack.tex" ),
    Asset( "ATLAS", "images/inspect_pad/hoshino_pad_excample_backpack.xml" ),

    Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_excample_amulet.tex" ),
    Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_excample_amulet.xml" ),
    Asset( "IMAGE", "images/inspect_pad/hoshino_pad_excample_amulet.tex" ),
    Asset( "ATLAS", "images/inspect_pad/hoshino_pad_excample_amulet.xml" ),

}

local function onequip(inst, owner)

end

local function onunequip(inst, owner)

end

local function common_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cane")
    inst.AnimState:SetBuild("swap_cane")
    inst.AnimState:PlayAnimation("idle")

    -- inst:AddTag("weapon")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
    -- inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
    MakeHauntableLaunch(inst)
    return inst
end

local function test_shoes()
    local inst = common_fn()
    -----------------------------------------------------------------------------------
    --- 给平板电脑的数据
        inst.pad_data = {
            atlas = "images/inspect_pad/hoshino_pad_excample_shoes.xml",
            image = "hoshino_pad_excample_shoes.tex",
            inspect_txt = "测试鞋子",
        }
    -----------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.equippable.equipslot = EQUIPSLOTS.HOSHINO_SHOES
    -- inst.components.inventoryitem:ChangeImageName("tillweedsalve")
    inst.components.inventoryitem.imagename = "hoshino_equipment_excample_shoes"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_excample_shoes.xml"

    return inst
end
local function test_backpack()
    local inst = common_fn()
    -----------------------------------------------------------------------------------
    --- 给平板电脑的数据
        inst.pad_data = {
            atlas = "images/inspect_pad/hoshino_pad_excample_backpack.xml",
            image = "hoshino_pad_excample_backpack.tex",
            inspect_txt = "测试背包",
        }
    -----------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.equippable.equipslot = EQUIPSLOTS.HOSHINO_BACKPACK
    -- inst.components.inventoryitem:ChangeImageName("piggyback")
    inst.components.inventoryitem.imagename = "hoshino_equipment_excample_backpack"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_excample_backpack.xml"
    return inst
end
local function test_amulet()
    local inst = common_fn()
    -----------------------------------------------------------------------------------
    --- 给平板电脑的数据
        inst.pad_data = {
            atlas = "images/inspect_pad/hoshino_pad_excample_amulet.xml",
            image = "hoshino_pad_excample_amulet.tex",
            inspect_txt = "测试项链",
        }
    -----------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.equippable.equipslot = EQUIPSLOTS.HOSHINO_AMULET
    -- inst.components.inventoryitem:ChangeImageName("greenamulet")
    inst.components.inventoryitem.imagename = "hoshino_equipment_excample_amulet"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_excample_amulet.xml"
    return inst
end


return Prefab("hoshino_equipment_excample_shoes", test_shoes, assets)
,Prefab("hoshino_equipment_excample_backpack", test_backpack, assets)
    ,Prefab("hoshino_equipment_excample_amulet", test_amulet, assets)