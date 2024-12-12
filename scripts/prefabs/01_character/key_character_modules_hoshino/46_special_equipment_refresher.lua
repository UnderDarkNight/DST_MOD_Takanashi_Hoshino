--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local slots = {
        [1] = EQUIPSLOTS.HOSHINO_AMULET,
        [2] = EQUIPSLOTS.HOSHINO_BACKPACK,
        [3] = EQUIPSLOTS.HOSHINO_SHOES,
    }
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end



    inst:ListenForEvent("hoshino_event.pad_special_equipment_clicked",function(_,slot_index)
        local slot = slots[slot_index]
        local item = inst.components.inventory:GetEquippedItem(slot)
        if item then
            local prefab = item.prefab
            item:Remove()
            local new_item = SpawnPrefab(prefab)
            inst.components.inventory:Equip(new_item)
            print("refreshed special equipment",item,new_item)
        end
    end)
end