--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

武器攻击范围
    1级：30度，5距离范围
    2级：45度，7距离范围
    3级：60度，9距离范围

    【重要笔记】    
            SG那边 也进行了 hoshino_com_power_cost 的参数检查，如果要修改 cost 消耗量，注意一起改。
            武器prefab 那边也有对应的参数需要一起修改 : 02_gun_eye_of_horus.lua
            07_sg_gun_shoot_with_walking.lua
            

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    ----------------------------------------------------------------------------------------
    ---
        local temp_inst = CreateEntity()
        inst:ListenForEvent("onremove",function()
            temp_inst:Remove()
        end)
    ----------------------------------------------------------------------------------------
    ---
        local blocking_flag = false
        local blocking_task = nil
        inst:ListenForEvent("hoshino_sg_action_gun_shoot_with_walking_dmg_blocker_start",function(inst)
            blocking_flag = true
            inst:AddTag("stronggrip")   --- 不被打掉武器的tag
            if blocking_task then
                blocking_task:Cancel()
                blocking_task = nil
            end
            inst.components.hoshino_com_spell_cd_timer:StartCDTimer("gun_eye_of_horus_ex",20)   -- 启动20秒CD
            inst.components.hoshino_com_power_cost:DoDelta(-4) -- 消耗4点能量
        end)
        inst:ListenForEvent("hoshino_sg_action_gun_shoot_with_walking_dmg_blocker_end",function(inst)
            -- blocking_flag = false
            inst:RemoveTag("stronggrip")   --- 不被打掉武器的tag
            --- 2秒后解除,避免AOE
            if blocking_task then
                blocking_task:Cancel()
            end
            blocking_task = inst:DoTaskInTime(2,function()
                blocking_flag = false
                blocking_task = nil                
            end)
        end)
    ----------------------------------------------------------------------------------------
    ---
        inst:DoTaskInTime(0,function()
            inst.components.hoshino_com_combat_hooker:Add_Modifier(temp_inst,function(inst,attacker, damage, weapon, stimuli, spdamage)
                if blocking_flag then
                    return 0,nil
                else
                    return damage,spdamage
                end
            end)
        end)
    ----------------------------------------------------------------------------------------
   
end