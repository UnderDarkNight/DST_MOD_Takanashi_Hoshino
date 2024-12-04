--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

ms_playerreroll

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    -- local need_2_save_components = {"hoshino_data","hoshino_com_shop","hoshino_com_debuff","hoshino_cards_sys"}
    local need_2_save_components = {"hoshino_com_debuff","hoshino_cards_sys","hoshino_com_level_sys"}

    local function GetIndex(inst)
        return "hoshino_datas_for_player_reroll_"..inst.userid
    end

    local function SaveData(inst)
        -------------------------------------------------------------------------
        --- 普通数据
            local data = {}
            for i,component_name in pairs(need_2_save_components) do
                data[component_name] = inst.components[component_name]:OnSave()
            end
            -- local hoshino_com_shop = inst.components.hoshino_com_shop:OnSave()
            -- local hoshino_com_debuff = inst.components.hoshino_com_debuff:OnSave()
            -- local hoshino_cards_sys = inst.components.hoshino_cards_sys:OnSave()
            TheWorld.components.hoshino_data:Set(GetIndex(inst),data)
        -------------------------------------------------------------------------
        --- 特殊装备
            local sp_equip_index = GetIndex(inst).."_sp_equip"
            local sp_data = {}
            local shoes_item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_SHOES)
            if shoes_item then
                sp_data.shoes = shoes_item:GetSaveRecord()
            end
            local backpack_item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_BACKPACK)
            if backpack_item then
                sp_data.backpack = backpack_item:GetSaveRecord()
            end
            local amulet_item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_AMULET)
            if amulet_item then
                sp_data.amulet = amulet_item:GetSaveRecord()
            end
            TheWorld.components.hoshino_data:Set(sp_equip_index,sp_data)
        -------------------------------------------------------------------------
    end
    local function LoadData(inst)
        -------------------------------------------------------------------------
        --- 普通数据
            local data = TheWorld.components.hoshino_data:Get(GetIndex(inst))
            if data then
                for i,component_name in pairs(need_2_save_components) do
                    inst.components[component_name]:OnLoad(data[component_name])
                end
                TheWorld.components.hoshino_data:Set(GetIndex(inst),nil)
            end
        -------------------------------------------------------------------------
        --- 特殊装备
            local sp_equip_index = GetIndex(inst).."_sp_equip"
            local sp_data = TheWorld.components.hoshino_data:Get(sp_equip_index)
            if sp_data then
                if sp_data.shoes then
                    local shoes_item = SpawnSaveRecord(sp_data.shoes)
                    if shoes_item then
                        inst.components.inventory:Equip(shoes_item)
                    end
                end
                if sp_data.backpack then
                    local backpack_item = SpawnSaveRecord(sp_data.backpack)
                    if backpack_item then
                        inst.components.inventory:Equip(backpack_item)
                    end
                end
                if sp_data.amulet then
                    local amulet_item = SpawnSaveRecord(sp_data.amulet)
                    if amulet_item then
                        inst.components.inventory:Equip(amulet_item)
                    end
                end
                TheWorld.components.hoshino_data:Set(sp_equip_index,nil)
            end
        -------------------------------------------------------------------------
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("ms_playerreroll",SaveData)
    inst:DoTaskInTime(0,LoadData)

end