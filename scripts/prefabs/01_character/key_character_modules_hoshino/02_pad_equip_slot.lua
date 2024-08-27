--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("pad_equip_slot_right_click",function(_,eslot)
        inst.components.inventory:TakeActiveItemFromEquipSlot(eslot)
        inst.components.inventory:ReturnActiveItem()
    end)
end