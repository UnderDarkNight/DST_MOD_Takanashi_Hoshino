--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local NORMAL_TYPE = "hoshino_spell_type_normal"
local SWIMMING_TYPE = "hoshino_spell_type_swimming"

local data_index = "player_spell_type"

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local init_fn = function()
        local spell_type = inst.components.hoshino_data:Get(data_index) or NORMAL_TYPE
        if spell_type == NORMAL_TYPE then
            inst.components.hoshino_com_tag_sys:AddTag(NORMAL_TYPE)
            inst.components.hoshino_com_tag_sys:RemoveTag(SWIMMING_TYPE)
        elseif spell_type == SWIMMING_TYPE then
            inst.components.hoshino_com_tag_sys:AddTag(SWIMMING_TYPE)
            inst.components.hoshino_com_tag_sys:RemoveTag(NORMAL_TYPE)
        else
            inst.components.hoshino_com_tag_sys:RemoveTag(NORMAL_TYPE)
            inst.components.hoshino_com_tag_sys:RemoveTag(SWIMMING_TYPE)
        end
        --- 通过RPC下发到 ThePlayer.PAD_DATA
        inst.components.hoshino_com_rpc_event:PushEvent("hoshino_event.pad_data_update",{
            character_spell_type = spell_type
        })
    end

    inst:DoTaskInTime(0,init_fn)

    inst:ListenForEvent("hoshino_spell_type_change",function(inst)
        local spell_type = inst.components.hoshino_data:Get(data_index) or NORMAL_TYPE
        if spell_type == NORMAL_TYPE then
            spell_type = SWIMMING_TYPE
        elseif spell_type == SWIMMING_TYPE then
            spell_type = NORMAL_TYPE
        end
        if spell_type == NORMAL_TYPE then
            inst.components.hoshino_data:Set(data_index,NORMAL_TYPE)
        elseif spell_type == SWIMMING_TYPE then
            inst.components.hoshino_data:Set(data_index,SWIMMING_TYPE)
        else
            inst.components.hoshino_data:Set(data_index,nil)
        end
        init_fn()
    end)

end