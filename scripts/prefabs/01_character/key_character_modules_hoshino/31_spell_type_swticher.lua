--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    普通形态基本特性：受到的伤害减少10%（对普通和位面伤害有效）
    泳装形态基本特性：移动速度+10%，潮湿不会过冷和掉san

    特效预选：
    weregoose_splash_less1
    glass_fx
    sleepbomb_burst
    halloween_firepuff_1   -3
    halloween_firepuff_cold_1   -3

    crab_king_waterspout
    waterstreak_burst
    archive_lockbox_player_fx
    carnival_sparkle_fx
    moonpulse_fx
    spider_heal_target_fx
    wolfgang_mighty_fx
    monkey_morphin_power_players_fx
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local NORMAL_TYPE = "hoshino_spell_type_normal"
local SWIMMING_TYPE = "hoshino_spell_type_swimming"

local data_index = "player_spell_type"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
        
        if spell_type == SWIMMING_TYPE  then
            inst.components.skinner:SetSkinName("hoshino_swimsuit")
            SpawnPrefab("halloween_firepuff_cold_"..math.random(1,3)).Transform:SetPosition(inst.Transform:GetWorldPosition())
        elseif spell_type == NORMAL_TYPE then
            inst.components.skinner:SetSkinName("hoshino_none")
            SpawnPrefab("halloween_firepuff_"..math.random(1,3)).Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
        inst:PushEvent("hoshino_event.spell_type_changed",spell_type)
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
    --- 来自快捷键
    local cd_task = nil
    inst:ListenForEvent("hoshino_event.spell_type_switch_hotkey_press",function()
        if cd_task then
            return
        end
        cd_task = inst:DoTaskInTime(3,function()
            cd_task = nil
        end)
        inst:PushEvent("hoshino_spell_type_change")
    end)
    --- 外部调取
    function inst:Hoshino_Get_Spell_Type()
        return inst.components.hoshino_data:Get(data_index) or NORMAL_TYPE
    end

    ---------------------------------------------------------------------------------------------
    ---     
        local temp_inst = CreateEntity()
        inst:ListenForEvent("onremove",function()
            temp_inst:Remove()
        end)
    ---------------------------------------------------------------------------------------------
    --- 受伤
        inst:DoTaskInTime(0,function()
            inst.components.hoshino_com_health_hooker:Add_Modifier(temp_inst,function(num)
                if num < 0 and inst:Hoshino_Get_Spell_Type() == NORMAL_TYPE then
                    return num*0.9
                end
                return num
            end)
        end)
    ---------------------------------------------------------------------------------------------
    --- 速度控制
        inst:ListenForEvent("hoshino_event.spell_type_changed",function()
            if inst:Hoshino_Get_Spell_Type() == SWIMMING_TYPE then
                inst.components.locomotor:SetExternalSpeedMultiplier(temp_inst, "hoshino_spell_type_speed", 1.1)
            else
                inst.components.locomotor:SetExternalSpeedMultiplier(temp_inst, "hoshino_spell_type_speed", 1.0)
            end
        end)
    ---------------------------------------------------------------------------------------------

end