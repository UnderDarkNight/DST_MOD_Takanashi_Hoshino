--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    【重要】
        all_spell_names 的参数 需要和  hoshino_com_spell_cd_timer.lua  hoshino_com_spell_cd_timer_replica.lua 中的参数一致

        UI 参数是静态的，如果要修改，则需要 前往 32_spell_ring_hud_install.lua 修改
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 技能名和CD时间
    local all_spell_names = {
        ["gun_eye_of_horus_ex"] = 20,                                                               --- 【普通模式】枪，EX技能
        ["normal_heal"] = 30,                                                                       --- 【普通模式】疗愈
        ["normal_covert_operation"] = TUNING.HOSHINO_DEBUGGING_MODE and 10 or 8*60,                 --- 【普通模式】隐秘行动
        ["normal_breakthrough"] = 0,                                                                --- 【普通模式】突破
        ["swimming_ex_support"] = TUNING.HOSHINO_DEBUGGING_MODE and 10 or  60,                      --- 【游泳模式】EX支援
        ["swimming_efficient_work"] = TUNING.HOSHINO_DEBUGGING_MODE and 10 or 24*60,                --- 【游泳模式】高效作业
        ["swimming_emergency_assistance"] = 0,                                                      --- 【游泳模式】紧急支援
        ["swimming_dawn_of_horus"] = TUNING.HOSHINO_DEBUGGING_MODE and 10 or 100*60,                --- 【游泳模式】晓之荷鲁斯
        -- ["gun_eye_of_horus_ex_test"] = 30,
    }
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 【普通模式】疗愈
    local function normal_heal_fn(inst,spell_name)
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
                --- 反馈
                    inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")
                ----------------------------------------------------------------------------

        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 【普通模式】隐秘行动
    local function normal_covert_operation_fn(inst,spell_name)
        local cost_value = 4
        if inst.components.hoshino_com_spell_cd_timer:IsReady(spell_name) 
            and inst.components.hoshino_com_power_cost:GetCurrent() >= cost_value then
                inst.components.hoshino_com_spell_cd_timer:StartCDTimer(spell_name, all_spell_names[spell_name])
                inst.components.hoshino_com_power_cost:DoDelta(-cost_value)
                ----------------------------------------------------------------------------
                --- 上debuff
                    local debuff_prefab = "hoshino_spell_normal_covert_operation_buff"
                    local test_num = 100
                    while test_num > 0 do
                        local debuff_inst = inst:GetDebuff(debuff_prefab)
                        if debuff_inst and debuff_inst:IsValid() then
                            debuff_inst:PushEvent("SetTime",8*60)
                            break
                        end
                        inst:AddDebuff(debuff_prefab,debuff_prefab)
                        test_num = test_num - 1
                    end
                ----------------------------------------------------------------------------
                --- 反馈
                    inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")
                ----------------------------------------------------------------------------
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 【普通模式】突破
    local musthavetags = {"_combat"}
    local canthavetags = {"companion","player", "playerghost", "INLIMBO","chester","hutch","DECOR", "FX",}
    local musthaveoneoftags = nil
    local function do_aoe_dmage(inst,pt)
        local x,y,z = pt.x,0,pt.z
        local damage = 30
        local mult_from_combat = inst.components.combat.externaldamagemultipliers:Get()
        local player_level = inst.components.hoshino_com_level_sys:GetLevel()
        damage = damage + mult_from_combat*player_level*3
        local ents = TheSim:FindEntities(x,0, z,10,musthavetags, canthavetags, musthaveoneoftags)
        for k, temp_monster in pairs(ents) do
            if temp_monster.components.health and not temp_monster.components.health:IsDead() then
                temp_monster.components.combat:GetAttacked(inst,damage)
                SpawnPrefab("crab_king_shine").Transform:SetPosition(temp_monster.Transform:GetWorldPosition())
            end
        end
        SpawnPrefab("bomb_lunarplant_explode_fx").Transform:SetPosition(x,y,z)
    end
    local function normal_breakthrough_test(inst,spell_name,cost_value)
        if not inst.components.hoshino_com_spell_cd_timer:IsReady(spell_name) then
            return false
        end
        if inst.components.hoshino_com_power_cost:GetCurrent() < cost_value then
            return false
        end
        return true
    end
    local function normal_breakthrough_fn(inst,spell_name,RemoveSpellInst,AddSpellInstByPrefab)
        local cost_value = 2
        if not normal_breakthrough_test(inst,spell_name,cost_value) then
            return
        end
        local spell_inst = AddSpellInstByPrefab("hoshino_spell_normal_breakthrough")
        -- print("fake error normal_breakthrough_fn",spell_inst)
        spell_inst.components.hoshino_com_item_spell:SetOwner(inst)
        spell_inst:ListenForEvent("right_clicked",RemoveSpellInst)
        spell_inst:ListenForEvent("left_clicked",function(_,_table)
            local pt = _table and _table.pt
            if pt and normal_breakthrough_test(inst,spell_name,cost_value) then
                inst.components.hoshino_com_spell_cd_timer:StartCDTimer(spell_name, all_spell_names[spell_name])
                inst.components.hoshino_com_power_cost:DoDelta(-cost_value)

                inst.components.playercontroller:DoAction(BufferedAction(inst, nil, ACTIONS.HOSHINO_SG_JUMP_OUT,nil,Vector3(pt.x,0,pt.z)))
                spell_inst:ListenForEvent("hoshino_portal_jump_out_end",function()                    
                    -- SpawnPrefab("log").Transform:SetPosition(pt.x,0,pt.z)
                    do_aoe_dmage(inst,pt)
                    RemoveSpellInst()
                end,inst)
            else
                RemoveSpellInst()
            end
        end)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 【游泳模式】EX支援    
    local function swimming_ex_support_test(inst,spell_name,cost_value)
        if not inst.components.hoshino_com_spell_cd_timer:IsReady(spell_name) then
            return false
        end
        if inst.components.hoshino_com_power_cost:GetCurrent() < cost_value then
            return false
        end
        return true
    end
    local function swimming_ex_support_fn(inst,spell_name,RemoveSpellInst,AddSpellInstByPrefab)
        local cost_value = 5
        if not swimming_ex_support_test(inst,spell_name,cost_value) then
            return
        end
        inst.components.hoshino_com_spell_cd_timer:StartCDTimer(spell_name, all_spell_names[spell_name])
        inst.components.hoshino_com_power_cost:DoDelta(-cost_value)


        local player_level = inst.components.hoshino_com_level_sys:GetLevel()
        -- local heal_num = 5 +player_level * 0.05
        -- local speed_mult = 1.5
        -- local damage_mult = (50+player_level)/100 + 1
        -- local cost_value_num = 0.04 + player_level*0.005
        local time = 30 + player_level*0.3

        local debuff_prefab = "hoshino_spell_swimming_ex_support_buff"
        local test_num = 100
        while test_num > 0 do
            local debuff_inst = inst:GetDebuff(debuff_prefab)
            if debuff_inst and debuff_inst:IsValid() then
                debuff_inst:PushEvent("SetTime",time)
                break
            end
            inst:AddDebuff(debuff_prefab,debuff_prefab)
            test_num = test_num - 1
        end

    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 【游泳模式】高效作业
    local function swimming_efficient_work_fn(inst,spell_name)
        local cost_value = 4
        if inst.components.hoshino_com_spell_cd_timer:IsReady(spell_name) 
            and inst.components.hoshino_com_power_cost:GetCurrent() >= cost_value then
                inst.components.hoshino_com_spell_cd_timer:StartCDTimer(spell_name, all_spell_names[spell_name])
                inst.components.hoshino_com_power_cost:DoDelta(-cost_value)
                ----------------------------------------------------------------------------
                --- 上debuff
                    local debuff_prefab = "hoshino_spell_swimming_fast_pciker_buff"
                    local test_num = 100
                    while test_num > 0 do
                        local debuff_inst = inst:GetDebuff(debuff_prefab)
                        if debuff_inst and debuff_inst:IsValid() then
                            debuff_inst:PushEvent("SetTime",16*60)
                            break
                        end
                        inst:AddDebuff(debuff_prefab,debuff_prefab)
                        test_num = test_num - 1
                    end
                ----------------------------------------------------------------------------
                --- 反馈
                    inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")
                ----------------------------------------------------------------------------

        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 【游泳模式】紧急支援
    local function swimming_emergency_assistance_fn(inst,spell_name,_table)
        local cost_value = 4
        if not inst.components.hoshino_com_spell_cd_timer:IsReady(spell_name) then
            return
        end
        if inst.components.hoshino_com_power_cost:GetCurrent() < cost_value then
            return
        end
        local pt = _table.pt
        if not (type(pt) == "table" and pt.x) then
            return
        end
        inst.components.hoshino_com_spell_cd_timer:StartCDTimer(spell_name, all_spell_names[spell_name])
        inst.components.hoshino_com_power_cost:DoDelta(-cost_value)
        inst.components.playercontroller:DoAction(BufferedAction(inst, nil, ACTIONS.HOSHINO_SG_JUMP_OUT,nil,Vector3(pt.x,0,pt.z)))

    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 【游泳模式】晓之荷鲁斯
    local musthavetags = {"_combat"}
    local canthavetags = nil
    local musthaveoneoftags = nil
    local can_not_be_freands = {
        ["abigail"] = true,
    }
    local function make_aoe_frends(inst,pt)
        local x,y,z = pt.x,0,pt.z
        local ents = TheSim:FindEntities(x,0,z,7,musthavetags, canthavetags, musthaveoneoftags)
        for k, temp_monster in pairs(ents) do
            if not can_not_be_freands[temp_monster.prefab] and temp_monster.components.health and not temp_monster.components.health:IsDead() then
                pcall(function() -- 做免崩溃处理
                    inst:PushEvent("makefriend")
                    inst.components.leader:AddFollower(temp_monster)
                    SpawnPrefab("crab_king_shine").Transform:SetPosition(temp_monster.Transform:GetWorldPosition())
                end)                
            end
        end
        SpawnPrefab("crab_king_shine").Transform:SetPosition(x,y,z)
        -- print("make_aoe_frends")
    end
    local function swimming_dawn_of_horus_test(inst,spell_name,cost_value)
        if not inst.components.hoshino_com_spell_cd_timer:IsReady(spell_name) then
            return false
        end
        if inst.components.hoshino_com_power_cost:GetCurrent() < cost_value then
            return false
        end
        return true
    end
    local function swimming_dawn_of_horus_fn(inst,spell_name,RemoveSpellInst,AddSpellInstByPrefab)
        local cost_value = 10
        if not swimming_dawn_of_horus_test(inst,spell_name,cost_value) then
            return
        end
        local spell_inst = AddSpellInstByPrefab("hoshino_spell_swimming_dawn_of_horus")
        -- print("fake error normal_breakthrough_fn",spell_inst)
        spell_inst.components.hoshino_com_item_spell:SetOwner(inst)
        spell_inst:ListenForEvent("right_clicked",RemoveSpellInst)
        spell_inst:ListenForEvent("left_clicked",function(_,_table)
            local pt = _table and _table.pt
            if pt and swimming_dawn_of_horus_test(inst,spell_name,cost_value) then
                inst.components.hoshino_com_spell_cd_timer:StartCDTimer(spell_name, all_spell_names[spell_name])
                inst.components.hoshino_com_power_cost:DoDelta(-cost_value)
                make_aoe_frends(inst,pt)
                RemoveSpellInst()
            else
                RemoveSpellInst()
            end
        end)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    -------------------------------------------------------------------------
    --- 技能指示器 的临时 inst
        inst.___hoshino_spell_ring_spell_inst = nil
        local function RemoveSpellInst()
            if inst.___hoshino_spell_ring_spell_inst then
                inst.___hoshino_spell_ring_spell_inst:Remove()
            end
            inst.___hoshino_spell_ring_spell_inst = nil
        end
        local function AddSpellInstByPrefab(prefab)
            RemoveSpellInst()
            if not PrefabExists(prefab) then
                return
            end
            inst.___hoshino_spell_ring_spell_inst = SpawnPrefab(prefab)
            return inst.___hoshino_spell_ring_spell_inst
        end
    -------------------------------------------------------------------------
    --- 技能环 出现期间，再按一次技能环。
        inst:ListenForEvent("hoshino_event.spell_ring_active",RemoveSpellInst)
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
                normal_heal_fn(inst,spell_name)
                return
            end
        ---------------------------------------------------------------------------------------------------
        --- 【普通模式】隐秘行动
            if spell_name == "normal_covert_operation" then
                normal_covert_operation_fn(inst,spell_name)
                return
            end
        ---------------------------------------------------------------------------------------------------
        --- 【普通模式】突破
            if spell_name == "normal_breakthrough" then
                normal_breakthrough_fn(inst,spell_name,RemoveSpellInst,AddSpellInstByPrefab)
                return
            end
        ---------------------------------------------------------------------------------------------------
        --- 【游泳模式】EX支援
            if spell_name == "swimming_ex_support" then
                swimming_ex_support_fn(inst,spell_name,RemoveSpellInst,AddSpellInstByPrefab)
                return
            end
        ---------------------------------------------------------------------------------------------------
        --- 【游泳模式】高效作业
            if spell_name == "swimming_efficient_work" then
                swimming_efficient_work_fn(inst,spell_name)
                return
            end
        ---------------------------------------------------------------------------------------------------
        --- 【游泳模式】紧急支援
            if spell_name == "swimming_emergency_assistance" then
                swimming_emergency_assistance_fn(inst,spell_name,data)
                return
            end
        ---------------------------------------------------------------------------------------------------
        --- 【游泳模式】晓之荷鲁斯
            if spell_name == "swimming_dawn_of_horus" then
                swimming_dawn_of_horus_fn(inst,spell_name,RemoveSpellInst,AddSpellInstByPrefab)
                return
            end
        ---------------------------------------------------------------------------------------------------
    end)

end