--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    local temp_inst = CreateEntity()
    inst:ListenForEvent("onremove",function()
        temp_inst:Remove()
    end)
    inst:ListenForEvent("master_postinit_hoshino",function(inst)
        ----------------------------------------------------------------------------------------
        ---
            inst.components.hoshino_com_inventory_custom_apply_damage:AddBeforeApplyDamageFn(temp_inst,function(inst,damage, attacker, weapon, spdamage)
                -------------------------------------------------------------------------------
                --- 位面防御
                    if type(spdamage) == "table" and spdamage["planar"] then
                        local current_planar_defense = inst.components.hoshino_com_debuff:Get_Planar_Defense()
                        spdamage["planar"] = math.max(spdamage["planar"] - current_planar_defense,0)
                    end
                -------------------------------------------------------------------------------
                --- 阵营防御
                    if type(spdamage) == "table" then
                        local aligned_defense_ret_precent = inst.components.hoshino_com_debuff:Get_Damage_Type_Resist()
                        if type(spdamage["shadow_aligned"]) == "number" then
                            spdamage["shadow_aligned"] = aligned_defense_ret_precent * spdamage["shadow_aligned"]
                        end
                        if type(spdamage["lunar_aligned"]) == "number" then
                            spdamage["lunar_aligned"] = aligned_defense_ret_precent * spdamage["lunar_aligned"]
                        end
                    end
                -------------------------------------------------------------------------------            
                return damage,spdamage
            end)
        ----------------------------------------------------------------------------------------
    end)
end