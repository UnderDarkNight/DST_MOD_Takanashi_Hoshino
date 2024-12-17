--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    鞋子 T1 - T9 

    每一级都有上一级的功能。




    相关API:


    1：获得50%防水 +20 max_health

    2：生命上限+30，cost恢复速度+0.01/s

    3：使人物身上的所有带有新鲜度的物品获得75%的保鲜效果（腐烂速度为1/4），cost恢复速度+0.01/s

    4：基础伤害减免+20%，免疫击飞

    5：位面防御+10，经验值获取速率增加100%，总共2倍经验

    6：基础攻击伤害+50%，cost恢复+0.02/s

    7：商店所有物品打折20%，每次击杀单位可以获得3信用点，传奇单位则获得300信用点

    8：30码内的所有其他玩家受到伤害的60%会由自己承担，cost恢复+0.05/s

    9：每15s检索30码内的所有其他玩家，若其没有护盾，则为其提供一个能抵挡50点伤害的护盾

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    inst.level = math.clamp(inst.level or 1,1,9)

    ----------------------------------------------------------------------------------
    --- tag
        inst:AddTag("hoshino_special_equipment_backpack_t"..tostring(inst.level))

    ----------------------------------------------------------------------------------
    --- 储存器
        inst:AddComponent("hoshino_data")
    ----------------------------------------------------------------------------------
    --- 50%防水
        if inst.level >= 1 then
            inst:AddTag("waterproofer")
            inst:AddComponent("waterproofer")
            inst.components.waterproofer:SetEffectiveness(0.5)
        end
    ----------------------------------------------------------------------------------
    --- 生命上限+20
        if inst.level >= 1 then            
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                if not owner.components.hoshino_data:Get("max_health_active.backpack_t1") then
                    owner.components.hoshino_data:Set("max_health_active.backpack_t1",true)
                    owner.components.hoshino_com_debuff:Add_Max_Helth(20)
                end
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                if owner.components.hoshino_data:Get("max_health_active.backpack_t1") then
                    owner.components.hoshino_data:Set("max_health_active.backpack_t1",false)
                    owner.components.hoshino_com_debuff:Add_Max_Helth(-20)
                end
            end)
        end
    ----------------------------------------------------------------------------------
    --- 生命上限+30
        if inst.level >= 2 then            
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                if not owner.components.hoshino_data:Get("max_health_active.backpack_t2") then
                    owner.components.hoshino_data:Set("max_health_active.backpack_t2",true)
                    owner.components.hoshino_com_debuff:Add_Max_Helth(30)
                end
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                if owner.components.hoshino_data:Get("max_health_active.backpack_t2") then
                    owner.components.hoshino_data:Set("max_health_active.backpack_t2",false)
                    owner.components.hoshino_com_debuff:Add_Max_Helth(-30)
                end
            end)
        end
    ----------------------------------------------------------------------------------
    --- 使人物身上的所有带有新鲜度的物品获得75%的保鲜效果（腐烂速度为1/4）
        if inst.level >= 3 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                owner.components.preserver:SetPerishRateMultiplier(0.25)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                owner.components.preserver:SetPerishRateMultiplier(1)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 基础伤害减免+20%
        if inst.level >= 4 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                -- owner.components.combat.externaldamagetakenmultipliers:SetModifier(inst,0.8)
                owner.components.health.externalabsorbmodifiers:SetModifier(inst, 0.20)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                -- owner.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst)
                owner.components.health.externalabsorbmodifiers:RemoveModifier(inst)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 免疫击飞
        if inst.level >= 4 then
            local sg_state = {
                ["knockback"] = true,
            }
            local player_knockback_block_state_event_fn = function(player,_table)
                local statename = _table and _table.statename
                if sg_state[statename] then
                    player.sg:GoToState("idle")
                end
            end
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                inst:ListenForEvent("newstate",player_knockback_block_state_event_fn,owner)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                inst:RemoveEventCallback("newstate",player_knockback_block_state_event_fn,owner)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 位面防御
        if inst.level >= 5 then
            inst:AddComponent("planardefense")
            inst.components.planardefense:SetBaseDefense(10)
        end
    ----------------------------------------------------------------------------------
    --- 经验倍率：
        if inst.level >= 5 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                owner.components.hoshino_com_level_sys:EXP_SetModifier(inst,2)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                owner.components.hoshino_com_level_sys:EXP_RemoveModifier(inst)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 攻击伤害倍增器
        if inst.level >= 6 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                owner.components.combat.externaldamagemultipliers:SetModifier(inst,1.5)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 商店价格倍增器
        if inst.level >= 7 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                owner.components.hoshino_com_shop.price_multiplier:SetModifier(inst,0.8)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                owner.components.hoshino_com_shop.price_multiplier:RemoveModifier(inst)
            end)
        end
    ----------------------------------------------------------------------------------
    --- 击杀事件
        if inst.level >= 7 then
            local function player_kill_target_event(player,_table)
                local target = _table and _table.victim
                if target and target.brainfn then  --- 带脑子的才算数
                    local reward_coins = 3
                    if target:HasTag("epic") then
                        reward_coins = 300
                    end
                    player.components.hoshino_com_shop:CreditCoinDelta(reward_coins)
                end
            end
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                inst:ListenForEvent("killed",player_kill_target_event,owner)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                inst:RemoveEventCallback("killed",player_kill_target_event,owner)
            end)

        end
    ----------------------------------------------------------------------------------
    --- 承担其他玩家伤害
        if inst.level >= 8 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                inst:DoPeriodicTask(2,function()
                    ------------------------------------------------------------------
                        if owner:HasTag("playerghost") then
                            return
                        end
                    ------------------------------------------------------------------
                    --- 获取周围玩家
                        local x,y,z = owner.Transform:GetWorldPosition()
                        local ents = TheSim:FindEntities(x,y,z,30,{"player"})
                        for k, temp_player in pairs(ents) do
                            if temp_player ~= owner then                            
                                local debuff_prefab = "hoshino_buff_special_equipment_backpack_t8"
                                while true do
                                    local debuff_inst = temp_player:GetDebuff(debuff_prefab)
                                    if debuff_inst and debuff_inst:IsValid() then
                                        debuff_inst:PushEvent("link",owner)
                                        break
                                    end
                                    temp_player:AddDebuff(debuff_prefab,debuff_prefab)
                                end
                            end
                        end
                    ------------------------------------------------------------------
                end)
            end)
        end  
    ----------------------------------------------------------------------------------
    --- 套护盾buff
        if inst.level >= 9 then
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                inst:DoPeriodicTask(15,function()
                    local x,y,z = owner.Transform:GetWorldPosition()
                    local ents = TheSim:FindEntities(x,y,z,30,{"player"},{"playerghost"})
                    for k, temp_player in pairs(ents) do
                        if temp_player ~= owner or TUNING.HOSHINO_DEBUGGING_MODE then                            
                            local debuff_prefab = "hoshino_buff_special_equipment_backpack_t9"
                            while true do
                                local debuff_inst = temp_player:GetDebuff(debuff_prefab)
                                if debuff_inst and debuff_inst:IsValid() then
                                    debuff_inst:PushEvent("reset_pool")
                                    break
                                end
                                temp_player:AddDebuff(debuff_prefab,debuff_prefab)
                            end
                        end
                    end
                end)
            end)
        end        
    ----------------------------------------------------------------------------------
    --- cost 回复器 lv2 +0.01/s  ，lv3 +0.01/s ， lv8 +0.05/s
        if inst.level >= 2 then
            --------------------------------------------------------------------------
            --- cost 值计算，根据等级
                local cost_value_delta_per_second = 0.01 -- lv2 +0.01/s            
                if inst.level >= 3 then
                    cost_value_delta_per_second = cost_value_delta_per_second + 0.01
                end
                if inst.level >= 6 then
                    cost_value_delta_per_second = cost_value_delta_per_second + 0.02
                end
                if inst.level >= 8 then
                    cost_value_delta_per_second = cost_value_delta_per_second + 0.05
                end
            --------------------------------------------------------------------------
            local cost_value_delta_task = nil
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                if cost_value_delta_task == nil then
                    cost_value_delta_task = inst:DoPeriodicTask(1,function()
                        -- TheNet:Announce("特殊装备+Cost"..cost_value_delta_per_second)
                        owner.components.hoshino_com_power_cost:DoDelta(cost_value_delta_per_second)
                    end)
                end
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                if cost_value_delta_task ~= nil then
                    cost_value_delta_task:Cancel()
                    cost_value_delta_task = nil
                end
            end)
        end
    ----------------------------------------------------------------------------------
end