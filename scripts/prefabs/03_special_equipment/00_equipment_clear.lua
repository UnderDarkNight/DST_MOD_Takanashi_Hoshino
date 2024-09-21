--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{

    Asset( "IMAGE", "images/inventoryimages/hoshino_special_equipment_backpack_clear.tex" ),
    Asset( "ATLAS", "images/inventoryimages/hoshino_special_equipment_backpack_clear.xml" ),
    Asset( "IMAGE", "images/inventoryimages/hoshino_special_equipment_shoes_clear.tex" ),
    Asset( "ATLAS", "images/inventoryimages/hoshino_special_equipment_shoes_clear.xml" ),
    Asset( "IMAGE", "images/inventoryimages/hoshino_special_equipment_amulet_clear.tex" ),
    Asset( "ATLAS", "images/inventoryimages/hoshino_special_equipment_amulet_clear.xml" ),


}
------------------------------------------------------------------------------------------------------------------------------------------------
local function shoes_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    if not TheWorld.ismastersim then
        return inst
    end
    -----------------------------------------------------------------------------------
    --- 制作栏制作的瞬间
        inst.OnBuilt = function(inst,doer)
            local old_item = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_SHOES)
            if old_item then
                old_item:Remove()
            end
            -- doer.components.hoshino_cards_sys:SendInspectWarning()  -- 通知平板电脑
            inst:Remove()
        end
    -----------------------------------------------------------------------------------
    --- 
        inst:DoTaskInTime(0,inst.Remove)
    -----------------------------------------------------------------------------------
    return inst
end
local function backpack_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    if not TheWorld.ismastersim then
        return inst
    end
    -----------------------------------------------------------------------------------
    --- 制作栏制作的瞬间
        inst.OnBuilt = function(inst,doer)
            local old_item = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_BACKPACK)
            if old_item then
                old_item:Remove()
            end
            -- doer.components.hoshino_cards_sys:SendInspectWarning()  -- 通知平板电脑
            inst:Remove()

        end
    -----------------------------------------------------------------------------------
    --- 
        inst:DoTaskInTime(0,inst.Remove)
    -----------------------------------------------------------------------------------
    return inst
end
local function amulet_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    if not TheWorld.ismastersim then
        return inst
    end
    -----------------------------------------------------------------------------------
    --- 制作栏制作的瞬间
        inst.OnBuilt = function(inst,doer)
            local old_item = doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_AMULET)
            if old_item then
                old_item:Remove()
            end
            -- doer.components.hoshino_cards_sys:SendInspectWarning()  -- 通知平板电脑
            inst:Remove()

        end
    -----------------------------------------------------------------------------------
    --- 
        inst:DoTaskInTime(0,inst.Remove)
    -----------------------------------------------------------------------------------
    return inst
end

return Prefab("hoshino_special_equipment_shoes_clear", shoes_fn, assets)
,Prefab("hoshino_special_equipment_backpack_clear", backpack_fn, assets)
,Prefab("hoshino_special_equipment_amulet_clear", amulet_fn, assets)