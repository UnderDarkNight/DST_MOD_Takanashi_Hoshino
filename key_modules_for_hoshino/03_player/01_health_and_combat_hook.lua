-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return
    end

    ------------------------------------------------------------------------------------
    --- health
        if inst.components.hoshino_com_health_hooker == nil then
            inst:AddComponent("hoshino_com_health_hooker")
            if inst.components.health then
                local old_DoDelta = inst.components.health.DoDelta
                inst.components.health.DoDelta = function(self, num,...)
                    if num < 0 and self.inst.components.hoshino_com_debuff then
                        -- num 是负数
                        local reduce_num = self.inst.components.hoshino_com_debuff:Get_Health_Down_Reduce()  -- 这个是正数
                        if num + reduce_num > 0 then
                            num = 0
                        else
                            num = num + reduce_num
                        end
                    end
                    num = inst.components.hoshino_com_health_hooker:Active(num) or num
                    return old_DoDelta(self,num,...)
                end
                print("info : health hooker added")
                inst.components.health.hoshino_test_fn = function()
                    print("info : health hooker test fn")
                end
            else
                print("error: no health component")    
                print("error: no health component")    
                print("error: no health component")    
                print("error: no health component")    
            end
        end
    ------------------------------------------------------------------------------------
    --- combat
        if inst.components.hoshino_com_combat_hooker == nil then
            inst:AddComponent("hoshino_com_combat_hooker")

            if inst.components.combat then
                local old_GetAttacked = inst.components.combat.GetAttacked
                inst.components.combat.GetAttacked = function(self, attacker, damage, weapon, stimuli, spdamage,...)
                    damage,spdamage = self.inst.components.hoshino_com_combat_hooker:Active(attacker,damage,weapon,stimuli,spdamage,...)
                    return old_GetAttacked(self, attacker, damage, weapon, stimuli, spdamage,...)
                end
                print("info : combat hooker added")
                inst.components.combat.hoshino_test_fn = function()
                    print("info : combat hooker test fn")
                end
            else            
                print("error: no combat component")
                print("error: no combat component")
                print("error: no combat component")
                print("error: no combat component")
            end
        end
    ------------------------------------------------------------------------------------



end)
