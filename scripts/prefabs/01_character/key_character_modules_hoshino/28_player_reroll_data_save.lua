--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

ms_playerreroll

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local need_2_save_components = {"hoshino_data","hoshino_com_shop","hoshino_com_debuff","hoshino_cards_sys"}

    local function GetIndex(inst)
        return "hoshino_datas_for_player_reroll_"..inst.userid
    end

    local function SaveData(inst)
        local data = {}
        for i,component_name in pairs(need_2_save_components) do
            data[component_name] = inst.components[component_name]:OnSave()
        end
        -- local hoshino_com_shop = inst.components.hoshino_com_shop:OnSave()
        -- local hoshino_com_debuff = inst.components.hoshino_com_debuff:OnSave()
        -- local hoshino_cards_sys = inst.components.hoshino_cards_sys:OnSave()
        TheWorld.components.hoshino_data:Set(GetIndex(inst),data)
    end
    local function LoadData(inst)
        local data = TheWorld.components.hoshino_data:Get(GetIndex(inst))
        if data == nil then
            return
        end
        for i,component_name in pairs(need_2_save_components) do
            inst.components[component_name]:OnLoad(data[component_name])
        end
        TheWorld.components.hoshino_data:Set(GetIndex(inst),nil)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("ms_playerreroll",SaveData)
    inst:DoTaskInTime(0,LoadData)

end