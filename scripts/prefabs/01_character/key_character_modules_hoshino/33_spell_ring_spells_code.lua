--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    【重要】
        all_spell_names 的参数 需要和  hoshino_com_spell_cd_timer.lua  hoshino_com_spell_cd_timer_replica.lua 中的参数一致

        UI 参数是静态的，如果要修改，则需要 前往 32_spell_ring_hud_install.lua 修改
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 技能名和CD时间
    local all_spell_names = {
        ["gun_eye_of_horus_ex"] = 20,       --- 【普通模式】枪，EX技能
        ["normal_heal"] = 30,               --- 【普通模式】疗愈
        ["gun_eye_of_horus_ex_test"] = 30,
    }
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    -------------------------------------------------------------------------
    --- 技能指示器 的临时 inst
        local spell_inst = nil
        local function RemoveSpellInst()
            if spell_inst then
                spell_inst:Remove()
            end
            spell_inst = nil
        end
    -------------------------------------------------------------------------
    inst:ListenForEvent("hoshino_spell_ring_spells_selected", function(inst, data)
        ---------------------------------------------------------------------------------------------------
        --[[        
            参数表。客户端通过RPC回传给服务器

            data = {
                spell_name = "gun_eye_of_horus_ex",
                pt = Vector3(0, 0, 0),
                userid = "userid",
            }

        ]]--
        ---------------------------------------------------------------------------------------------------
        --- 
            local spell_name = data.spell_name
            print("【技能施放】", spell_name)
            if all_spell_names[spell_name] == nil then
                return
            end
        ---------------------------------------------------------------------------------------------------
        --- 【普通模式】疗愈
            if spell_name == "normal_heal" then
                local cost_value = 3
                if inst.components.hoshino_com_spell_cd_timer:IsReady(spell_name) 
                    and inst.components.hoshino_com_power_cost:GetCurrent() >= cost_value then
                        inst.components.hoshino_com_spell_cd_timer:StartCDTimer(spell_name, all_spell_names[spell_name])
                        inst.components.hoshino_com_power_cost:DoDelta(-cost_value)
                        ----------------------------------------------------------------------------
                        --- 上debuff
                            local debuff_prefab = "hoshino_spell_normal_heal_buff"
                            local test_num = 100
                            while test_num > 0 do
                                local debuff_inst = inst:GetDebuff(debuff_prefab)
                                if debuff_inst and debuff_inst:IsValid() then
                                    debuff_inst:PushEvent("SetTime",30)
                                    break
                                end
                                inst:AddDebuff(debuff_prefab,debuff_prefab)
                                test_num = test_num - 1
                            end
                        ----------------------------------------------------------------------------

                end
                return
            end
        ---------------------------------------------------------------------------------------------------
        --- 
        ---------------------------------------------------------------------------------------------------
    end)

end