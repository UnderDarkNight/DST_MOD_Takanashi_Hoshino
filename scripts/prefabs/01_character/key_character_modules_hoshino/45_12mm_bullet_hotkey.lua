--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
    local item_prefab = "hoshino_item_12mm_shotgun_shells"
    local function GetItem(inst)
        local item = nil
        inst.components.inventory:ForEachItem(function(temp)
            if item == nil and temp and temp.prefab == item_prefab then
                item = temp
            end
        end)
        return item
    end
    local function GetWeapon(inst)
        local item = inst.components.combat:GetWeapon()
        if item and item.prefab == "hoshino_weapon_gun_eye_of_horus" then
            return item
        end
        return nil
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    local cd_task = nil
    inst:ListenForEvent("hoshino_event.12mm_bullet_hotkey_press",function()
        ------------------------------------------------------------------------
        --- cd 
            if cd_task ~= nil then
                return
            end
            cd_task = inst:DoTaskInTime(2,function() cd_task = nil end)
        ------------------------------------------------------------------------
        local weapon = GetWeapon(inst)
        if weapon == nil then
            return
        end
        local item = GetItem(inst)
        if item == nil then
            return
        end
        if weapon.replica.hoshino_com_acceptable:Test(item,inst) then
            weapon.components.hoshino_com_acceptable:OnAccept(item,inst)
        end
    end)
end