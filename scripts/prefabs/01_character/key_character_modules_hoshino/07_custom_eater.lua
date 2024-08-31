--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    食物组件

    20、【完成】【白】【汲取】【从食物获取的「正向」三维x2的同时，增加厨子的挑食机制】【从卡池移除】

    2、【诅咒】【消化不良】【从食物中获取的三维增加量减半，扣除的不减】【从诅咒池移除】  indigestion

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function Player_Unlocked_Warly_Eater_Modules(inst)
        return inst.components.hoshino_data:Get("Player_Unlocked_Warly_Eater_Modules") == true
    end
    local function Player_Indigestion(inst)
        return inst.components.hoshino_data:Get("Player_Indigestion") == true
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("master_postinit_hoshino",function()
        ------------------------------------------------------------------------
        --- 			health_delta, hunger_delta, sanity_delta = self.custom_stats_mod_fn(self.inst, health_delta, hunger_delta, sanity_delta, food, feeder)
            inst.components.eater.custom_stats_mod_fn = function(inst, health_delta, hunger_delta, sanity_delta, food, feeder)
                --- 【汲取】
                if Player_Unlocked_Warly_Eater_Modules(inst) then
                    if health_delta > 0 then
                        health_delta = health_delta * 2
                    end
                    if hunger_delta > 0 then
                        hunger_delta = hunger_delta * 2
                    end
                    if sanity_delta > 0 then
                        sanity_delta = sanity_delta * 2
                    end
                end
                --- 【消化不良】
                if Player_Indigestion(inst) then
                    if health_delta > 0 then
                        health_delta = health_delta / 2
                    end
                    if hunger_delta > 0 then
                        hunger_delta = hunger_delta / 2
                    end
                    if sanity_delta > 0 then
                        sanity_delta = sanity_delta / 2
                    end
                end
                return health_delta, hunger_delta, sanity_delta
            end
        ------------------------------------------------------------------------
        --- 食物记忆器
            inst:AddComponent("foodmemory")
            inst.components.foodmemory:SetDuration(TUNING.WARLY_SAME_OLD_COOLDOWN)
            inst.components.foodmemory:SetMultipliers(TUNING.WARLY_SAME_OLD_MULTIPLIERS)
            local old_GetFoodMultiplier = inst.components.foodmemory.GetFoodMultiplier
            inst.components.foodmemory.GetFoodMultiplier = function(self,food_prefab,...)
                if Player_Unlocked_Warly_Eater_Modules(inst) then
                    return old_GetFoodMultiplier(self,food_prefab,...)
                end
                return 1
            end
        ------------------------------------------------------------------------
        --- onload
            inst.components.hoshino_data:AddOnLoadFn(function()
                if Player_Unlocked_Warly_Eater_Modules(inst) then
                    inst.components.eater:SetPrefersEatingTag("preparedfood")
                    inst.components.eater:SetPrefersEatingTag("pre-preparedfood")
                end
            end)
        ------------------------------------------------------------------------
    end)

    inst:ListenForEvent("player_unlocked_warly_eater_modules", function(inst)  --- 靠触发这个事件激活模块【汲取】
        inst.components.eater:SetPrefersEatingTag("preparedfood")
        inst.components.eater:SetPrefersEatingTag("pre-preparedfood")
        inst.components.hoshino_data:Set("Player_Unlocked_Warly_Eater_Modules",true)
    end)

    inst:ListenForEvent("player_unlock_eater_indigestion", function(inst)  --- 靠触发这个事件激活模块【消化不良】
        inst.components.hoshino_data:Set("Player_Indigestion",true)
    end)

end