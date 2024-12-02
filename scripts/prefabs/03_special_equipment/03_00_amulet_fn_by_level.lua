--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    鞋子 T1 - T9 

    每一级都有上一级的功能。




    相关API:


    1：免疫钢羊的控制效果，血上限+20

    2：免疫冰冻，半径30码内所有玩家获得15%减伤

    3：金卡权重+5，彩卡权重+0.5，移动速度+10%

    4：免疫精神控制（织影者那种），免疫催眠

    5：半径30码内所有玩家基础攻击伤害+20%，且每次攻击恢复5点san值（启蒙状态改为降低5启蒙值）

    6：每次造成伤害都会 额外 直接扣除敌人最大生命值1%的。每有一个诅咒效果，基础攻击伤害增加50%。

    7：半径30码内的枯萎植物会恢复，半径30码内的玩家会每10s恢复3点生命值

    8：每次睡觉时获得一包升级卡包，此效果每一天仅可触发1次。其余时候，睡觉每秒+0.2cost

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
    --- 免疫钢羊鼻涕的控制效果。+血20
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
                if not inst.components.hoshino_data:Get("max_health_active.t1_amulet") then
                    inst.components.hoshino_data:Set("max_health_active.t1_amulet",true)
                    owner.components.hoshino_com_debuff:Add_Max_Helth(20)
                end
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                inst:RemoveEventCallback("newstate",player_pinned_block_state_event_fn,owner)
                if inst.components.hoshino_data:Get("max_health_active.t1_amulet") then
                    inst.components.hoshino_data:Set("max_health_active.t1_amulet",false)
                    owner.components.hoshino_com_debuff:Add_Max_Helth(-20)
                end
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
        -- if inst.level >= 4 then
        --     inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
        --         if owner.components.grogginess then
        --             owner.components.grogginess:AddResistanceSource(inst,0)
        --         end
        --     end)
        --     inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
        --         if owner.components.grogginess then
        --             owner.components.grogginess:RemoveResistanceSource(inst)
        --         end
        --     end)
        -- end
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
    --- t7 回复血量 半径30码内的玩家会每10s恢复3点生命值
        if inst.level >= 7 then
            local area_health_heal_task = nil
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                if area_health_heal_task == nil then
                    area_health_heal_task = inst:DoPeriodicTask(10,function()
                        local x,y,z = owner.Transform:GetWorldPosition()
                        local ents = TheSim:FindEntities(x,y,z,30,{"player"},{"playerghost"})
                        for k,temp_player in pairs(ents) do
                            if temp_player and temp_player:IsValid() and temp_player.components.health and not temp_player.components.health:IsDead() then
                                temp_player.components.health:DoDelta(3,true)
                            end
                        end
                    end)
                end
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                if area_health_heal_task ~= nil then
                    area_health_heal_task:Cancel()
                    area_health_heal_task = nil
                end
            end)
        end
    ----------------------------------------------------------------------------------
    --- t7 施肥?  半径30码内的枯萎植物会恢复
        if inst.level >= 7 then
            --------------------------------------------------------------------------
            --- 水花爆炸
                inst:AddComponent("wateryprotection")
                inst.components.wateryprotection.extinguishheatpercent = TUNING.FIRESUPPRESSOR_EXTINGUISH_HEAT_PERCENT
                inst.components.wateryprotection.temperaturereduction = TUNING.FIRESUPPRESSOR_TEMP_REDUCTION
                inst.components.wateryprotection.witherprotectiontime = TUNING.FIRESUPPRESSOR_PROTECTION_TIME
                inst.components.wateryprotection.addcoldness = 0
                inst.components.wateryprotection:AddIgnoreTag("player")
                inst.components.wateryprotection:AddIgnoreTag("companion")
            --------------------------------------------------------------------------
            local area_fertilize_task = nil
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                if area_fertilize_task == nil then
                    area_fertilize_task = inst:DoPeriodicTask(5,function()
                                local x,y,z = owner.Transform:GetWorldPosition()
                                local ents = TheSim:FindEntities(x,y,z,30,nil,{"burnt"})
                                for i, temp_plant in pairs(ents) do
                                    if temp_plant and temp_plant:IsValid() and temp_plant.components.pickable and temp_plant.components.pickable:IsBarren() and temp_plant.__hoshino_t7_barren_task == nil then
                                        temp_plant.__hoshino_t7_barren_task = true
                                        inst:DoTaskInTime(math.random(0,50)/10,function()
                                            inst.components.wateryprotection:SpreadProtection(temp_plant)
                                            temp_plant.__hoshino_t7_barren_task = nil
                                            SpawnPrefab("glass_fx").Transform:SetPosition(temp_plant.Transform:GetWorldPosition())
                                        end)
                                    end
                                end
                    end)
                end
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                if area_fertilize_task ~= nil then
                    area_fertilize_task:Cancel()
                    area_fertilize_task = nil
                end
            end)
        end
    ----------------------------------------------------------------------------------
    --- t8 每次睡觉时获得一包升级卡包，此效果每一天仅可触发1次。检查周期 30s
        if inst.level >= 8 then
            local function player_is_sleeping(player)
                if player and player.sg then
                    if player.sg:HasStateTag("sleeping") or player.sg:HasStateTag("yawn") then
                        return true
                    end
                    if player.sg.currentstate and player.sg.currentstate.name == "knockout" then
                        return true
                    end
                end
                return false
            end

            local t8_sleep_task = nil
            local t8_sleep_task_cost = nil
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                if t8_sleep_task == nil then
                    t8_sleep_task = inst:DoPeriodicTask(30,function()
                        local last_day_flag = owner.components.hoshino_data:Get("special_equipment_amulet_t8_daily_flag")
                        if last_day_flag ~= TheWorld.state.cycles and player_is_sleeping(owner) then
                            owner.components.hoshino_data:Set("special_equipment_amulet_t8_daily_flag",TheWorld.state.cycles)
                            ------------------------------------------------------------------------
                            --- 创建卡牌包
                                owner.components.inventory:GiveItem(SpawnPrefab("hoshino_item_cards_pack"))
                            ------------------------------------------------------------------------
                        end
                    end)
                end
                if t8_sleep_task_cost == nil then
                    t8_sleep_task_cost = inst:DoPeriodicTask(1,function()
                        if player_is_sleeping(owner) then
                            owner.components.hoshino_com_power_cost:DoDelta(0.2)
                        end
                    end)
                end
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                if t8_sleep_task ~= nil then
                    t8_sleep_task:Cancel()
                    t8_sleep_task = nil
                end
                if t8_sleep_task_cost ~= nil then
                    t8_sleep_task_cost:Cancel()
                    t8_sleep_task_cost = nil
                end
            end)

        end
    ----------------------------------------------------------------------------------
    --- t9 onhitother event
        if inst.level >= 9 then
            local function onhitother_event_fn_for_player(player,_table)
                local target = _table and _table.target
                local damage = _table and _table.damage or 0
                local spdamage = _table and _table.spdamage
                if target and target:IsValid() then
                    --------------------------------------------------------
                    --- 上debuff
                        local debuff_prefab = "hoshino_debuff_special_equipment_amulet_t9"
                        local debuff_inst = nil
                        local temp_i = 10
                        while true and temp_i > 0 do
                            debuff_inst = target:GetDebuff(debuff_prefab)
                            if debuff_inst and debuff_inst:IsValid() then
                                debuff_inst:PushEvent("reset")
                                break
                            end
                            target:AddDebuff(debuff_prefab,debuff_prefab)
                            temp_i = temp_i - 1
                        end
                    --------------------------------------------------------
                    --- 计算伤害 . 每次攻击会恢复造成伤害1%的生命值
                        local ret_dmg = 0
                        ret_dmg = ret_dmg + damage
                        if type(spdamage) == "table" then
                            for i,v in pairs(spdamage) do   --- 无法确定 index 和 value 哪个是伤害值，所以一起检测和添加。
                                if type(v) == "number" then
                                    ret_dmg = ret_dmg + v
                                elseif type(i) == "number" then
                                    ret_dmg = ret_dmg + i
                                end                                        
                            end
                        end
                        if ret_dmg > 0 then
                            player.components.health:DoDelta(ret_dmg/100,true)
                        end
                    --------------------------------------------------------
                end
            end
            inst:ListenForEvent("Special_Fn_Active",function(inst,owner)
                inst:ListenForEvent("onhitother",onhitother_event_fn_for_player,owner)
            end)
            inst:ListenForEvent("Special_Fn_Deactive",function(inst,owner)
                inst:RemoveEventCallback("onhitother",onhitother_event_fn_for_player,owner)
            end)
        end
    ----------------------------------------------------------------------------------
end