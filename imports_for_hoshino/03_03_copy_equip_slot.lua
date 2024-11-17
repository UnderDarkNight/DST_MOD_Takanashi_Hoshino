--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    复制装备槽


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TUNING.HOSHINO_FNS = TUNING.HOSHINO_FNS or {}

local remembered_slots = {}
function TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom(prefab)
    if remembered_slots[prefab] then
        return remembered_slots[prefab]
    end
    local test_item = SpawnPrefab(prefab)
    if test_item then
        local ret_slot = nil
        if TheWorld.ismastersim and test_item.components.equippable then
            ret_slot = test_item.components.equippable.equipslot
        elseif test_item.replica.equippable then
            ret_slot = test_item.replica.equippable:EquipSlot()
        end
        ret_slot = ret_slot or EQUIPSLOTS.HANDS
        test_item:Remove()
        remembered_slots[prefab] = ret_slot
        return ret_slot
    end
    return EQUIPSLOTS.HANDS
end
