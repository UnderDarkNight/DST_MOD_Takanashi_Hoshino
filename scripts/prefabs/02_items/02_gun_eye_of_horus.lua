------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------
    local assets =
    {
        Asset("ANIM", "anim/hoshino_atk.zip"),
        Asset("ANIM", "anim/hoshino_weapon_gun_eye_of_horus.zip"),
    }
------------------------------------------------------------------------------------------------------------------------------------------------------
--- 催眠屏蔽器
    -- local function knockout_sg_event_block_for_player(player,_table)
    --     local statename = _table and _table.statename
    --     print("++++",statename)
    --     if statename == "knockout" or statename == "yawn" and player.sg then
    --         player.sg:GoToState("idle")
    --     end
    -- end
    local function Add_kockout_blocker_2_player(owner,inst)
        if owner.components.grogginess then
            owner.components.grogginess:AddResistanceSource(inst,1000)
        end
        -- inst:ListenForEvent("newstate",knockout_sg_event_block_for_player,owner)
    end
    local function Remove_kockout_blocker_from_player(owner,inst)
        if owner.components.grogginess then
            owner.components.grogginess:RemoveResistanceSource(inst)
        end
        -- inst:RemoveEventCallback("newstate",knockout_sg_event_block_for_player,owner)
    end
------------------------------------------------------------------------------------------------------------------------------------------------------

    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "hoshino_atk", "swap_object")

        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

        owner:PushEvent("hoshino_weapon_gun_eye_of_horus_equipped",inst)
        owner:PushEvent("hoshino_weapon_gun_eye_of_horus_attack_range_update",inst)
        inst.owner = owner

        Add_kockout_blocker_2_player(owner,inst)
    end

    local function onunequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_object")
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
        inst.owner = nil
        Remove_kockout_blocker_from_player(owner,inst)
    end
------------------------------------------------------------------------------------------------------------------------------------------------------
--- 特殊攻击动作
    local spell_display_name = "战术镇压"
    local com_str_index = "eye_of_horus"
    local spell_name = "gun_eye_of_horus_ex"
    local function special_attack_module_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_point_and_target_spell_caster",function(inst,replica_com)
            replica_com:SetAllowCanCastOnImpassable(true) --- 允许朝海中射击
            replica_com:SetDistance(9)
            replica_com:SetText(com_str_index,spell_display_name)
            replica_com:SetSGAction("hoshino_gun_ex_skill_pre")
            replica_com:SetTestFn(function(inst,doer,target,pt,right_click)
                if not right_click or target == doer and doer.prefab ~= "hoshino" then
                    return false
                end
                if not doer:HasTag("hoshino_spell_type_normal") then
                    return false
                end
                -- if doer.replica.hoshino_com_spell_cd_timer and doer.replica.hoshino_com_spell_cd_timer:IsReady(spell_name) then
                --     return true
                -- end
                return true
            end)
            replica_com:SetTextUpdateFn(function(inst,doer,target,pt)
                if ThePlayer and ThePlayer.prefab == "hoshino" and ThePlayer.replica.hoshino_com_spell_cd_timer and doer:HasTag("hoshino_spell_type_normal") then
                    local time = ThePlayer.replica.hoshino_com_spell_cd_timer:GetTime(spell_name) or 0
                    --- 取小数点后一位
                    -- time = math.floor(time*10)/10
                    local cost_value = ThePlayer.replica.hoshino_com_power_cost:GetCurrent()
                    local ret_str = spell_display_name
                    -- if time > 0 then
                    --     replica_com:SetText(com_str_index,spell_display_name.." 【 "..time.." 】")
                    -- else                
                    --     replica_com:SetText(com_str_index,spell_display_name)
                    -- end

                    if time > 0 then
                        ret_str = "【 "..string.format("%.1f", time).." 】 " .. ret_str
                    end
                    local spell_cost = TUNING.HOSHINO_PARAMS.SPELLS.GUN_EYE_OF_HORUS_EX_COST or 4
                    if cost_value < spell_cost then
                        ret_str = ret_str.." 【 COST "..spell_cost.." 】"
                    end
                    replica_com:SetText(com_str_index,ret_str)
                else
                    replica_com:SetText(com_str_index,"")
                end
            end)

        end)
        if not TheWorld.ismastersim then
            return
        end


        inst:AddComponent("hoshino_com_point_and_target_spell_caster")
        inst.components.hoshino_com_point_and_target_spell_caster:SetSpellFn(function(inst,doer,target,pt)
            -- doer.components.hoshino_com_spell_cd_timer:StartCDTimer("gun_eye_of_horus_ex",20)
            return true
        end)

    end
------------------------------------------------------------------------------------------------------------------------------------------------------
--- acceptable
    local function acceptable_com_inst(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_acceptable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,item,doer,right_click)
                if item and item.prefab == "hoshino_item_12mm_shotgun_shells" then
                    return true
                end
                return false
            end)
            replica_com:SetText("hoshino_weapon_gun_eye_of_horus","填装")
            replica_com:SetSGAction("dolongaction")
        end)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("hoshino_com_acceptable")
        inst.components.hoshino_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
            if inst.components.finiteuses:GetPercent() > 1 then
                return false
            end
            item.components.stackable:Get():Remove()
            inst.components.finiteuses:Use_Hoshino(-1*80)
            if inst.components.finiteuses:GetPercent() > 1 then
                inst.components.finiteuses:SetPercent(1)
            end
            return true
        end)

    end
------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_weapon_gun_eye_of_horus")
    inst.AnimState:SetBuild("hoshino_weapon_gun_eye_of_horus")
    inst.AnimState:PlayAnimation("idle")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("hoshino_weapon_gun_eye_of_horus")
    inst:AddTag("nosteal")

    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85})


    inst.entity:SetPristine()
    special_attack_module_install(inst)
    acceptable_com_inst(inst)
    if not TheWorld.ismastersim then
        return inst
    end


    ---------------------------------------------------------------------------------------------------
    --- 
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(0)
        inst:AddComponent("inspectable")
    ---------------------------------------------------------------------------------------------------
    ---
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("tillweedsalve")
        inst.components.inventoryitem.imagename = "hoshino_weapon_gun_eye_of_horus"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_weapon_gun_eye_of_horus.xml"
    ---------------------------------------------------------------------------------------------------
    ---
        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.restrictedtag = "hoshino"
    ---------------------------------------------------------------------------------------------------
    ---
        MakeHauntableLaunch(inst)
    ---------------------------------------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                -- inst.AnimState:Hide("SHADOW")
                inst.AnimState:PlayAnimation("water")
            else                                
                -- inst.AnimState:Show("SHADOW")
                inst.AnimState:PlayAnimation("idle")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    ---------------------------------------------------------------------------------------------------
    --- 耐久度
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(200)
        inst.components.finiteuses:SetPercent(1)
        inst.components.finiteuses:SetOnFinished(function()
            inst:PushEvent("attack_range_update")
        end)
        inst:ListenForEvent("percentusedchange",function()
            inst:PushEvent("attack_range_update")
        end)
        --- 避免AOE的时候造成 多次 耐久度消耗
        inst.components.finiteuses.Use_Hoshino = inst.components.finiteuses.Use
        inst.components.finiteuses.Use = function(self,...)
        end
    ---------------------------------------------------------------------------------------------------
    --- 等级和攻击距离
        inst:ListenForEvent("attack_range_update",function(inst)
            if inst.components.finiteuses and inst.components.finiteuses:GetPercent() <= 0 then
                inst.components.weapon:SetRange(nil)
                return
            end
            if inst.owner then
                inst.owner:PushEvent("hoshino_weapon_gun_eye_of_horus_attack_range_update",inst)
            end
        end)
    ---------------------------------------------------------------------------------------------------

    return inst
end

return Prefab("hoshino_weapon_gun_eye_of_horus", fn, assets)
