--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    盔甲物品（用于卡牌的一些护甲参数赋予）

    组件挂载在玩家身上会无法生效，只能创建个装备常驻并动态修改参数

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function GetArmorItem(inst)
        local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_ARMOR_ITEM)
        if item and item:IsValid() and item:HasTag("INLIMBO") then
            return item
        else
            item = SpawnPrefab("hoshino_other_armor_item")
            inst.components.inventory:Equip(item)
            return item
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:DoTaskInTime(0,function()
        inst:PushEvent("hoshino_other_armor_item_param_refresh")
    end)
    inst:ListenForEvent("hoshino_other_armor_item.onequip",function()
        inst:PushEvent("hoshino_other_armor_item_param_refresh")
    end)
    inst:ListenForEvent("hoshino_other_armor_item_param_refresh",function(inst)
        ----------------------------------------------------------------------------------------
        --- 
            local item = GetArmorItem(inst)
        ----------------------------------------------------------------------------------------
        --- 位面防御
            if item.components.planardefense == nil then
                item:AddComponent("planardefense")
            end
            item.components.planardefense:SetBaseDefense(inst.components.hoshino_com_debuff:Get_Planar_Defense())
        ----------------------------------------------------------------------------------------
    end)
end