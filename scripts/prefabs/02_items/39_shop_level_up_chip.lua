--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{

    Asset("ANIM", "anim/hoshino_item_shop_level_up_chip.zip"), 
    Asset( "IMAGE", "images/inventoryimages/hoshino_item_shop_level_up_chip_1.tex" ),
    Asset( "ATLAS", "images/inventoryimages/hoshino_item_shop_level_up_chip_1.xml" ),
    Asset( "IMAGE", "images/inventoryimages/hoshino_item_shop_level_up_chip_2.tex" ),
    Asset( "ATLAS", "images/inventoryimages/hoshino_item_shop_level_up_chip_2.xml" ),
    Asset( "IMAGE", "images/inventoryimages/hoshino_item_shop_level_up_chip_3.tex" ),
    Asset( "ATLAS", "images/inventoryimages/hoshino_item_shop_level_up_chip_3.xml" ),
}
------------------------------------------------------------------------------------------------------------------------------------------------
local function common_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_item_shop_level_up_chip")
    inst.AnimState:SetBuild("hoshino_item_shop_level_up_chip")
    -- inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    ---------------------------------------------------------------------
    --- 
        inst:AddComponent("inspectable")
    ---------------------------------------------------------------------
    ---
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("tillweedsalve")
        -- inst.components.inventoryitem.imagename = "hoshino_equipment_excample_shoes"
        -- inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_excample_shoes.xml"
    ---------------------------------------------------------------------

    return inst
end

local function level_up_1_fn()
    local inst = common_fn()
    inst:AddTag("shop_level_setting_item")
    inst:AddTag("shop_level_up_item")
    inst:AddTag("level_1")
    inst.AnimState:PlayAnimation("level_1")
    if not TheWorld.ismastersim then
        return inst
    end    
    inst.components.inventoryitem.imagename = "hoshino_item_shop_level_up_chip_1"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_shop_level_up_chip_1.xml"
    return inst
end
local function level_up_2_fn()
    local inst = common_fn()
    inst:AddTag("shop_level_setting_item")
    inst:AddTag("shop_level_up_item")
    inst:AddTag("level_2")
    inst.AnimState:PlayAnimation("level_2")
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.inventoryitem.imagename = "hoshino_item_shop_level_up_chip_2"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_shop_level_up_chip_2.xml"
    return inst
end
local function level_up_3_fn()
    local inst = common_fn()
    inst:AddTag("shop_level_setting_item")
    inst:AddTag("shop_level_up_item")
    inst:AddTag("level_3")
    inst.AnimState:PlayAnimation("level_3")
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.inventoryitem.imagename = "hoshino_item_shop_level_up_chip_3"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_shop_level_up_chip_3.xml"
    return inst
end



return Prefab("hoshino_item_shop_level_up_chip_1", level_up_1_fn, assets),
        Prefab("hoshino_item_shop_level_up_chip_2", level_up_2_fn, assets),
        Prefab("hoshino_item_shop_level_up_chip_3", level_up_3_fn, assets)
