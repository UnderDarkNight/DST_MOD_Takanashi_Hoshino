--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    额外装备槽

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    -- inst:ListenForEvent("pad_equip_slot_right_click",function(_,eslot)
    --     inst.components.inventory:TakeActiveItemFromEquipSlot(eslot)
    --     inst.components.inventory:ReturnActiveItem()
    -- end)

    inst:ListenForEvent("master_postinit_hoshino",function()
        local old_DropItem = inst.components.inventory.DropItem
        inst.components.inventory.DropItem = function(self,item,...)
            if item and item:HasOneOfTags({"hoshino_special_equipment","hoshino_spell_item"}) then
                return
            end
            return old_DropItem(self,item,...)
        end
    end)

end