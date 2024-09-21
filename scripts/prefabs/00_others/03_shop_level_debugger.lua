--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{


}
------------------------------------------------------------------------------------------------------------------------------------------------
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
    -- inst:AddTag("hoshino_special_equipment")

    -- MakeInventoryFloatable(inst)

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
        inst.components.inventoryitem:ChangeImageName("tillweedsalve")
        -- inst.components.inventoryitem.imagename = "hoshino_equipment_excample_shoes"
        -- inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_excample_shoes.xml"
    ---------------------------------------------------------------------

    return inst
end

local function level_up_fn()
    local inst = common_fn()
    inst:AddTag("shop_level_setting_item")
    inst:AddTag("shop_level_up_item")
    return inst
end
local function level_reset_fn()
    local inst = common_fn()
    inst:AddTag("shop_level_setting_item")
    inst:AddTag("shop_level_reset_item")
    return inst
end


return Prefab("hoshino_other_shop_debugger_level_up", level_up_fn, assets)
    ,Prefab("hoshino_other_shop_debugger_reset_level", level_reset_fn, assets)
