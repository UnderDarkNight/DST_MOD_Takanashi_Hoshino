--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    鞋子 T1 - T9 

    每一级都有上一级的功能。




    相关API:

        owner.components.locomotor:SetExternalSpeedMultiplier(inst,"hoshino_special_equipment_shoes_t1",1.05)
        owner.components.locomotor:RemoveExternalSpeedMultiplier(inst,"hoshino_special_equipment_shoes_t1")

    1：移动速度+5%

    2：保暖+120，san+6，移动速度+10%

    3：免疫雷电，免疫麻痹，基础攻击伤害+15%

    4：免疫火焰伤害，移动速度+10%

    5：受到攻击时令攻击来源减少70%的移动速度，持续10s。

    6：无视地形，并且可以在水面和虚空行走，移动速度+10%

    7：这个无视碰撞体积意思为无视各种建筑的碰撞体积（比如可以穿过石墙），也无视织影者骨牢这种

    8：100%防水，移动速度+10%，免疫滑倒

    9：移动速度+20%，免疫地洞减速，免疫虚弱（吃月亮蘑菇引起那个）。

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    inst.level = inst.level or 1
    ----------------------------------------------------------------------------------
    --- AddTag
        inst:AddTag("hoshino_special_equipment_shoes_t"..tostring(inst.level))
        inst:DoTaskInTime(0,function() -- 某些特殊情况下 必须使用的成功加载标记位
            inst.Ready = true
        end)
    ----------------------------------------------------------------------------------
    --- 速度控制器
        inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
            local speed_delta = {
                [1] = 0.05,
                [2] = 0.1,
                [3] = 0,
                [4] = 0.1,
                [5] = 0,
                [6] = 0.1,
                [7] = 0,
                [8] = 0.1,
                [9] = 0.2,
            }
            local ret_speed_mult = 1
            for i = 1, inst.level , 1 do
                ret_speed_mult = ret_speed_mult + (speed_delta[i] or 0)
            end
            owner.components.locomotor:SetExternalSpeedMultiplier(inst,"hoshino_special_equipment_shoes_t"..tostring(inst.level),ret_speed_mult)

        end)
        inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
            owner.components.locomotor:RemoveExternalSpeedMultiplier(inst,"hoshino_special_equipment_shoes_t"..tostring(inst.level))
        end)
    ----------------------------------------------------------------------------------
    --- 保暖
        if inst.level >= 2 then
            inst:AddComponent("insulator")
            inst.components.insulator:SetInsulation(120)
        end
    ----------------------------------------------------------------------------------
    --- San
        if inst.level >= 2 then
            inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL*3
        end
    ----------------------------------------------------------------------------------
    --- 免疫雷电
        if inst.level >= 3 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                if owner.components.playerlightningtarget then
                    owner.components.playerlightningtarget:Hoshino_Add_Blocker(inst)
                end
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                if owner.components.playerlightningtarget then
                    owner.components.playerlightningtarget:Hoshino_Remove_Blocker(inst)
                end
            end)
            
        end
    ----------------------------------------------------------------------------------
    --- 免疫电击动作
        if inst.level >= 3 then
            local player_electrocute_block_state_event_fn = function(player,_table)
                local statename = _table and _table.statename
                if TUNING.HOSHINO_DEBUGGING_MODE then
                    print("++++++++ state name = "..statename)
                end
                if statename == "electrocute" then
                    player.sg:GoToState("idle")
                end
            end
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                inst:ListenForEvent("newstate",player_electrocute_block_state_event_fn,owner)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                inst:RemoveEventCallback("newstate",player_electrocute_block_state_event_fn,owner)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 基础伤害倍增
        if inst.level >= 3 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                local mult_delta = {
                    [1] = 0,
                    [2] = 0,
                    [3] = 0.15,
                    [4] = 0,
                    [5] = 0,
                    [6] = 0,
                    [7] = 0,
                    [8] = 0,
                    [9] = 0,
                }
                local ret_mult = 1
                for i = 1, inst.level , 1 do
                    ret_mult = ret_mult + (mult_delta[i] or 0)
                end
                owner.components.combat.externaldamagemultipliers:SetModifier(inst, ret_mult)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 免疫火焰伤害
        if inst.level >= 4 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 0)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 5：受到攻击时令攻击来源减少70%的移动速度，持续10s。
        if inst.level >= 5 then
            local function player_get_attacked_event(player,_table)
                local attacker = _table and _table.attacker
                if attacker and attacker.components.combat and attacker.components.locomotor then
                    
                    local debuff_prefab = "hoshino_debuff_monster_damage_down"
                    local debuff_inst = nil
                    while true do
                        debuff_inst = attacker:GetDebuff(debuff_prefab)
                        if debuff_inst and debuff_inst:IsValid() then
                            debuff_inst.time = 10
                            break
                        end
                        attacker:AddDebuff(debuff_prefab,debuff_prefab)
                    end
                end
            end
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                owner:ListenForEvent("attacked",player_get_attacked_event,owner)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                owner:RemoveEventCallback("attacked",player_get_attacked_event,owner)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 6、7 水上行走 和 碰撞体积
        if inst.level >= 6 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                if owner.components.drownable and owner.components.drownable.enabled ~= false then
                    owner.components.drownable.enabled = false
                end
                if inst.level >= 7 then
                    MakeGhostPhysics(owner, 1, .5)
                    owner.Physics:Teleport(owner.Transform:GetWorldPosition())
                else
                    owner.Physics:ClearCollisionMask()
                    owner.Physics:CollidesWith(COLLISION.GROUND)
                    owner.Physics:CollidesWith(COLLISION.OBSTACLES)
                    owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                    owner.Physics:CollidesWith(COLLISION.CHARACTERS)
                    owner.Physics:CollidesWith(COLLISION.GIANTS)
                    owner.Physics:Teleport(owner.Transform:GetWorldPosition())
                end
            end)

            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                if not inst.Ready then
                    return
                end
                MakeCharacterPhysics(owner, 75, .5)
                if owner.components.drownable then
                    owner.components.drownable.enabled = true
                end
                owner.Physics:Teleport(owner.Transform:GetWorldPosition())
            end)

        end
    ----------------------------------------------------------------------------------
    --- 防水
        if inst.level >= 8 then
            inst:AddTag("waterproofer") -- 防水
            inst:AddTag("umbrella") -- 防雨
            inst:AddComponent("waterproofer")
        end
    ----------------------------------------------------------------------------------
    --- 免疫滑倒
        if inst.level >= 8 then
            local player_slip_block_state_event_fn = function(player,_table)
                local statename = _table and _table.statename
                if player.sg and player.sg.AddStateTag then
                    player.sg:AddStateTag("noslip")
                end
            end
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                inst:ListenForEvent("newstate",player_slip_block_state_event_fn,owner)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                inst:RemoveEventCallback("newstate",player_slip_block_state_event_fn,owner)
            end)
        end
    ----------------------------------------------------------------------------------

    ----------------------------------------------------------------------------------
end

