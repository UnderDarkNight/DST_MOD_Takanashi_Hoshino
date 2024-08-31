--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local assets =
{
    Asset("ANIM", "anim/cane.zip"),
    Asset("ANIM", "anim/swap_cane.zip"),
}

local function onequip(inst, owner)
    inst:DoTaskInTime(0.5,function()
        owner:PushEvent("hoshino_other_armor_item.onequip",inst)        
    end)
end

local function onunequip(inst, owner)

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    -- inst.AnimState:SetBank("cane")
    -- inst.AnimState:SetBuild("swap_cane")
    -- inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hoshino_other_armor_item")
    inst:AddTag("hoshino_special_equipment")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")

    -----------------------------------------------------------------------
    ----
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem:SetOnDroppedFn(function()
            inst:Remove()
        end)
        inst.components.inventoryitem.keepondeath = true
        inst.components.inventoryitem:ChangeImageName("tillweedsalve")
        -- inst.components.inventoryitem.imagename = "hoshino_equipment_excample_shoes"
        -- inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_excample_shoes.xml"
    -----------------------------------------------------------------------
    ----
        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.restrictedtag = "hoshino"
        inst.components.equippable.equipslot = EQUIPSLOTS.HOSHINO_ARMOR_ITEM
    -----------------------------------------------------------------------
    ----
        local temp_deactive_fn = function(inst)
            inst:Remove()          
        end
        inst:ListenForEvent("onremove",temp_deactive_fn)
        inst:ListenForEvent("on_landed",temp_deactive_fn)
        inst:ListenForEvent("ondropped",temp_deactive_fn)
    -----------------------------------------------------------------------

    return inst
end

return Prefab("hoshino_other_armor_item", fn, assets)
