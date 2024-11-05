--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/swap_cane.zip"),

    Asset( "IMAGE", "images/inventoryimages/hoshino_special_equipment_shoes_t1.tex" ),
    Asset( "ATLAS", "images/inventoryimages/hoshino_special_equipment_shoes_t1.xml" ),
    Asset( "IMAGE", "images/inspect_pad/hoshino_pad_equipment_shoes_t1.tex" ),
    Asset( "ATLAS", "images/inspect_pad/hoshino_pad_equipment_shoes_t1.xml" ),


}
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
--- 特殊函数激活、反激活
    local function Special_Fn_Active(inst,owner)
        -- print("激活",inst,owner)
        inst:PushEvent("Special_Fn_Active",owner)
    end
    local function Special_Fn_Deactive(inst,owner)
        -- print("反激活",inst,owner)
        if owner then
            inst:PushEvent("Special_Fn_Deactive",owner)
        end
    end
    local function onequip(inst, owner)
        inst.owner = owner
        inst:DoTaskInTime(0,function()   --- 使用延时激活，避免加载时候造成不可控崩溃
            Special_Fn_Active(inst,owner)
        end)
    end
    local function onunequip(inst, owner)
        inst.owner = owner
        -- owner:DoTaskInTime(0,function() --- 使用延时激活，避免加载时候造成不可控崩溃
        --     Special_Fn_Deactive(inst,owner)
        -- end)
        Special_Fn_Deactive(inst,owner)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
local function common_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    -- inst.AnimState:SetBank("cane")
    -- inst.AnimState:SetBuild("swap_cane")
    -- inst.AnimState:PlayAnimation("idle")

    -- inst:AddTag("weapon")
    inst:AddTag("hoshino_special_equipment")
    inst:AddTag("nosteal")

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
        inst.components.inventoryitem:SetOnDroppedFn(function()
            inst:Remove()
        end)
        inst.components.inventoryitem.keepondeath = true
    ---------------------------------------------------------------------
    --- 
        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.restrictedtag = "hoshino"
    ---------------------------------------------------------------------
    --- 
        local temp_deactive_fn = function(inst)
            Special_Fn_Deactive(inst,inst.owner)            
        end
        -- inst:ListenForEvent("onremove",temp_deactive_fn)
        inst:ListenForEvent("on_landed",temp_deactive_fn)
        inst:ListenForEvent("ondropped",temp_deactive_fn)
        inst:ListenForEvent("unequipped",inst.Remove)
    ---------------------------------------------------------------------


    return inst
end

local function fn()
    local inst = common_fn()
    -----------------------------------------------------------------------------------
    --- 给平板电脑的数据
        inst.pad_data = {
            atlas = "images/inspect_pad/hoshino_pad_equipment_shoes_t1.xml",
            image = "hoshino_pad_equipment_shoes_t1.tex",
            -- inspect_txt = TUNING.HOSHINO_FNS:GetString("hoshino_special_equipment_shoes_t1","name") .. "\n"..TUNING.HOSHINO_FNS:GetString("hoshino_special_equipment_shoes_t1","recipe_desc"),
        }
    -----------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.equippable.equipslot = EQUIPSLOTS.HOSHINO_SHOES
    inst.components.equippable.restrictedtag = "hoshino"
    -- inst.components.inventoryitem:ChangeImageName("tillweedsalve")
    inst.components.inventoryitem.imagename = "hoshino_special_equipment_shoes_t1"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_special_equipment_shoes_t1.xml"


    -----------------------------------------------------------------------------------
    --- 制作栏制作的瞬间
        inst.onPreBuilt = function(inst,doer)
            local old_item = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_SHOES)
            if old_item then
                old_item:Remove()
            end
            doer.components.hoshino_cards_sys:SendInspectWarning()  -- 通知平板电脑
        end
    -----------------------------------------------------------------------------------
    --- 激活/反激活 相关的 事件安装
        inst.level = 1
        local active_event_install_fn = require("prefabs/03_special_equipment/01_00_shoes_fn_by_level")
        if active_event_install_fn then
            active_event_install_fn(inst)
        end
    -----------------------------------------------------------------------------------
    return inst
end

return Prefab("hoshino_special_equipment_shoes_t1", fn, assets)