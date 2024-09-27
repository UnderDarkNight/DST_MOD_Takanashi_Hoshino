--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    鞋子 T1 - T9 

    每一级都有上一级的功能。




    相关API:


    1：免疫钢羊的控制效果

    2：免疫冰冻，半径30码内所有玩家获得15%减伤

    3：金卡权重+5，彩卡权重+0.5，移动速度+10%

    4：免疫精神控制（织影者那种），免疫催眠

    5：半径30码内所有玩家基础攻击伤害+20%，且每次攻击恢复5点san值（启蒙状态改为降低5启蒙值）

    6：每次造成伤害都会 额外 直接扣除敌人最大生命值1%的。每有一个诅咒效果，基础攻击伤害增加50%。

    7：半径30码内的枯萎植物会恢复，半径30码内的玩家会每10s恢复3点生命值

    8：每次睡觉时获得一包升级卡包，此效果每一天仅可触发1次。

    9：每次攻击会恢复造成伤害1%的生命值，被攻击到的生物获得debuff：受到的最终伤害增加100%，持续10s。

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    inst.level = math.clamp(inst.level or 1,1,9)

    ----------------------------------------------------------------------------------
    --- AddTag 和储存器
        inst:AddTag("hoshino_special_equipment_amulet_t"..tostring(inst.level))
        inst:AddComponent("hoshino_data")
    ----------------------------------------------------------------------------------
    --- 免疫钢羊鼻涕的控制效果
        if inst.level >= 1 then
            local sg_state = {
                ["pinned_hit"] = true,
                ["pinned"] = true,
                ["pinned_pre"] = true,
            }
            local player_pinned_block_state_event_fn = function(player,_table)
                local statename = _table and _table.statename
                if sg_state[statename] then
                    player.sg:GoToState("idle")
                end
            end
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                inst:ListenForEvent("newstate",player_pinned_block_state_event_fn,owner)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                inst:RemoveEventCallback("newstate",player_pinned_block_state_event_fn,owner)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 免疫冰冻(逐级冰冻参数)
        if inst.level >= 2 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                owner.components.hoshino_com_freezable_hooker:Add_Modifier(inst,function(player,coldness, freezetime, nofreeze)
                    coldness = 0
                    return coldness, freezetime, nofreeze
                end)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                owner.components.hoshino_com_freezable_hooker:Remove_Modifier(inst)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 免疫直接冰冻
        if inst.level >= 2 then
            local sg_state = {
                ["frozen"] = true,
            }
            local player_pinned_block_state_event_fn = function(player,_table)
                local statename = _table and _table.statename
                if sg_state[statename] then
                    player.sg:GoToState("idle")
                    -- print("fake error skip frozen")
                end
            end
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                inst:ListenForEvent("newstate",player_pinned_block_state_event_fn,owner)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                inst:RemoveEventCallback("newstate",player_pinned_block_state_event_fn,owner)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 上范围减伤BUFF
        if inst.level >= 2 then
            inst:AddTag("hoshino_special_equipment_amulet_t2_damage_mult")
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                inst:DoPeriodicTask(2,function()
                    local x,y,z = owner.Transform:GetWorldPosition()
                    local ents = TheSim:FindEntities(x,y,z,30,{"player"},{"playerghost"})
                    local debuff_prefab = "hoshino_buff_special_equipment_amulet_t2"
                    for k,temp_player in pairs(ents) do
                        if temp_player and temp_player:IsValid() then
                            -------------------------------------------------------------------
                            --- 上BUFF
                                while true do                                    
                                    local debuff_inst = temp_player:GetDebuff(debuff_prefab)
                                    if debuff_inst and debuff_inst:IsValid() then
                                        break
                                    end
                                    temp_player:AddDebuff(debuff_prefab,debuff_prefab)
                                end
                            -------------------------------------------------------------------
                        end
                    end
                end)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)

            end)
        end
    ----------------------------------------------------------------------------------
    --- 移动速度
        if inst.level >= 3 then
            inst.components.equippable.walkspeedmult = 1.1
        end
    ----------------------------------------------------------------------------------
    --- 卡牌权重
        if inst.level >= 3 then
            local card_colourful_delta = 0.5
            local card_golden_delta = 5
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                if not inst.components.hoshino_data:Get("cards_weight_flag") then
                    inst.components.hoshino_data:Set("cards_weight_flag",true)
                    owner.components.hoshino_cards_sys:Card_Pool_Delata("card_golden",card_golden_delta)
                    owner.components.hoshino_cards_sys:Card_Pool_Delata("card_colourful",card_colourful_delta)
                end
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                if inst.components.hoshino_data:Get("cards_weight_flag") then
                    inst.components.hoshino_data:Set("cards_weight_flag",false)
                    owner.components.hoshino_cards_sys:Card_Pool_Delata("card_golden",-card_golden_delta)
                    owner.components.hoshino_cards_sys:Card_Pool_Delata("card_colourful",-card_colourful_delta)
                end
            end)
        end
    ----------------------------------------------------------------------------------
    --- 昏睡屏蔽
        if inst.level >= 4 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                if owner.components.grogginess then
                    owner.components.grogginess:AddResistanceSource(inst,0)
                end
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                if owner.components.grogginess then
                    owner.components.grogginess:RemoveResistanceSource(inst)
                end
            end)
        end
    ----------------------------------------------------------------------------------
    --- 免疫精神控制（织影者那种）
        if inst.level >= 4 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                owner.components.hoshino_com_offical_debuff_blocker:Add_Blocker("mindcontroller","mindcontroller")
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)                
                owner.components.hoshino_com_offical_debuff_blocker:Remove_Blocker("mindcontroller","mindcontroller")
            end)
        end        
    ----------------------------------------------------------------------------------
    --- 伤害倍增器
        if inst.level >= 5 then
            inst:AddTag("hoshino_special_equipment_amulet_t5_damage_mult")
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                inst:DoPeriodicTask(2,function()
                    local x,y,z = owner.Transform:GetWorldPosition()
                    local ents = TheSim:FindEntities(x,y,z,30,{"player"},{"playerghost"})
                    local debuff_prefab = "hoshino_buff_special_equipment_amulet_t5"
                    for k,temp_player in pairs(ents) do
                        if temp_player and temp_player:IsValid() then
                            -------------------------------------------------------------------
                            --- 上BUFF
                                while true do                                    
                                    local debuff_inst = temp_player:GetDebuff(debuff_prefab)
                                    if debuff_inst and debuff_inst:IsValid() then
                                        break
                                    end
                                    temp_player:AddDebuff(debuff_prefab,debuff_prefab)
                                end
                            -------------------------------------------------------------------
                        end
                    end
                end)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)

            end)
        end
    ----------------------------------------------------------------------------------
    --- t6 诅咒buff
        if inst.level >= 6 then
            local debuff_prefab = "hoshino_buff_special_equipment_amulet_t6"
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                while true do
                    local debuff_inst = owner:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    owner:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                for i = 1, 3, 1 do
                    owner:RemoveDebuff(debuff_prefab)
                end
            end)
        end
    ----------------------------------------------------------------------------------
end