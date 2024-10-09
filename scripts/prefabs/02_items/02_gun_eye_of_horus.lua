------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------
    local assets =
    {
        Asset("ANIM", "anim/hoshino_atk.zip"),
        Asset("ANIM", "anim/hoshino_weapon_gun_eye_of_horus.zip"),
    }

    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "hoshino_atk", "swap_object")

        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

        owner:PushEvent("hoshino_weapon_gun_eye_of_horus_equipped",inst)
        owner:PushEvent("hoshino_weapon_gun_eye_of_horus_attack_range_update",inst)
        inst.owner = owner
    end

    local function onunequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_object")
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
        inst.owner = nil
    end
------------------------------------------------------------------------------------------------------------------------------------------------------
--- 特殊攻击动作
    local function special_attack_module_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_point_and_target_spell_caster",function(inst,replica_com)
            replica_com:SetAllowCanCastOnImpassable(true) --- 允许朝海中射击
            replica_com:SetDistance(9)
            replica_com:SetText("eye_of_horus","战术镇压")
            replica_com:SetSGAction("hoshino_gun_ex_skill_pre")
            replica_com:SetTestFn(function(inst,doer,target,pt,right_click)
                if not right_click or target == doer then
                    return false
                end
                return true
            end)

        end)
        if not TheWorld.ismastersim then
            return
        end


        inst:AddComponent("hoshino_com_point_and_target_spell_caster")
        inst.components.hoshino_com_point_and_target_spell_caster:SetSpellFn(function(inst,doer,target,pt)                
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

    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85})


    inst.entity:SetPristine()
    special_attack_module_install(inst)
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
        if TUNING.HOSHINO_DEBUGGING_MODE then
            inst.components.finiteuses:SetMaxUses(200)
            inst.components.finiteuses:SetPercent(1)
        else            
            inst.components.finiteuses:SetMaxUses(200)
            inst.components.finiteuses:SetPercent(1)
        end
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