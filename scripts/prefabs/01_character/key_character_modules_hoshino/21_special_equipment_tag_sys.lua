--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    本模块用来刷新 特殊装备的 升级 tag 。

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end


    local function tag_sys_refresh()
        inst:DoTaskInTime(0,function()
            --------------------------------------------------------------------
            --- 鞋子
                local max_shoes_level = 9 --- 最多只有9个鞋子等级
                local shoes_name_base = "hoshino_special_equipment_shoes_t"
                local shoes_item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_SHOES)
                local shoes_level = 0
                if shoes_item then
                    shoes_level = shoes_item.level or 1
                else
                    shoes_level = 0
                end
                for i = 0, max_shoes_level, 1 do  -- 移除tag
                    if i ~= shoes_level then
                        inst.components.hoshino_com_tag_sys:RemoveTag(shoes_name_base..i)
                    else
                        inst.components.hoshino_com_tag_sys:AddTag(shoes_name_base..i)
                    end
                end
            --------------------------------------------------------------------
            --- 背包
                local max_backpack_level = 9 --- 最多只有9个背包等级
                local backpack_name_base = "hoshino_special_equipment_backpack_t"
                local backpack_item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_BACKPACK)
                local backpack_level = 0
                if backpack_item then
                    backpack_level = backpack_item.level or 1
                else
                    backpack_level = 0
                end
                for i = 0, max_backpack_level, 1 do  -- 移除tag
                    if i ~= backpack_level then
                        inst.components.hoshino_com_tag_sys:RemoveTag(backpack_name_base..i)
                    else
                        inst.components.hoshino_com_tag_sys:AddTag(backpack_name_base..i)
                    end
                end
            --------------------------------------------------------------------
            --- 项链
                local max_amulet_level = 9 --- 最多只有9个项链等级
                local amulet_name_base = "hoshino_special_equipment_amulet_t"
                local amulet_item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_AMULET)
                local amulet_level = 0
                if amulet_item then
                    amulet_level = amulet_item.level or 1
                else
                    amulet_level = 0
                end
                for i = 0, max_amulet_level, 1 do  -- 移除tag
                    if i ~= amulet_level then
                        inst.components.hoshino_com_tag_sys:RemoveTag(amulet_name_base..i)
                    else
                        inst.components.hoshino_com_tag_sys:AddTag(amulet_name_base..i)
                    end
                end
            --------------------------------------------------------------------
            --- 刷新制作栏
                for i = 1, 10, 1 do
                    inst:DoTaskInTime(i*0.2,function()
                        inst:PushEvent("refreshcrafting")
                    end)
                end
            --------------------------------------------------------------------
        end)
    end

    inst:ListenForEvent("unequip", tag_sys_refresh)
    inst:ListenForEvent("equip", tag_sys_refresh)
    inst:DoTaskInTime(0,tag_sys_refresh)
    inst:ListenForEvent("hoshino_event.special_equipment_tags_force_refresh",tag_sys_refresh)

    inst:DoPeriodicTask(5,function()
        inst.components.hoshino_com_rpc_event:PushEvent("refreshcrafting")
    end)
end