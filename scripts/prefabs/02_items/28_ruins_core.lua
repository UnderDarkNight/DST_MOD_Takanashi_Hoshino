----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

至纯铥矿
远古科学站合成，不记忆配方
护符 无耐久
铥矿甲*1 铥矿皇冠*1 铥矿棒*1 铥矿徽章*3
受攻击时33%产生4s铥矿皇冠效果，皇冠护盾期间你的伤害倍增器为0（免疫物理和位面伤害）。

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/armor_bramble.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local ARMOR_RUINSHAT_COOLDOWN = 4   --- 冷却时间
    local ARMOR_RUINSHAT_DURATION = 4   --- 持续时间
    local ARMOR_RUINSHAT_PROC_CHANCE = TUNING.HOSHINO_DEBUGGING_MODE and 0.9 or 0.33 --- 产生概率
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 

    local function ruinshat_fxanim(inst)
        inst._fx.AnimState:PlayAnimation("hit")
        inst._fx.AnimState:PushAnimation("idle_loop")
    end

    local function ruinshat_oncooldown(inst)
        inst._task = nil
    end

    local function ruinshat_unproc(inst)
        if inst:HasTag("forcefield") then
            inst:RemoveTag("forcefield")
            if inst._fx ~= nil then
                inst._fx:kill_fx()
                inst._fx = nil
            end
            inst:RemoveEventCallback("armordamaged", ruinshat_fxanim)

            -- inst.components.armor:SetAbsorption(TUNING.ARMOR_RUINSHAT_ABSORPTION)
            inst.components.armor:SetAbsorption(0)
            inst.components.armor.ontakedamage = nil

            if inst._task ~= nil then
                inst._task:Cancel()
            end
            inst._task = inst:DoTaskInTime(ARMOR_RUINSHAT_COOLDOWN, ruinshat_oncooldown)
        end
    end

    local function ruinshat_proc(inst, owner)
        inst:AddTag("forcefield")
        if inst._fx ~= nil then
            inst._fx:kill_fx()
        end
        inst._fx = SpawnPrefab("forcefieldfx")
        inst._fx.entity:SetParent(owner.entity)
        inst._fx.Transform:SetPosition(0, 0.2, 0)
        inst:ListenForEvent("armordamaged", ruinshat_fxanim)

        inst.components.armor:SetAbsorption(TUNING.FULL_ABSORPTION)
        inst.components.armor.ontakedamage = function(inst, damage_amount)
            if owner ~= nil and owner.components.sanity ~= nil then
                owner.components.sanity:DoDelta(-damage_amount * TUNING.ARMOR_RUINSHAT_DMG_AS_SANITY, false)
            end
        end

        if inst._task ~= nil then
            inst._task:Cancel()
        end
        inst._task = inst:DoTaskInTime(ARMOR_RUINSHAT_DURATION, ruinshat_unproc)
    end

    local function tryproc(inst, owner, data)
        if inst._task == nil and
            not data.redirected and
            math.random() < ARMOR_RUINSHAT_PROC_CHANCE then
            ruinshat_proc(inst, owner)
        end
    end



    local function ruins_custom_init(inst)
        inst:AddTag("open_top_hat")
        inst:AddTag("metal")

        --shadowlevel (from shadowlevel component) added to pristine state for optimization
        inst:AddTag("shadowlevel")
    end

    local function ruins_onremove(inst)
        if inst._fx ~= nil then
            inst._fx:kill_fx()
            inst._fx = nil
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function onequip(inst, owner)
        if not owner:HasTag("player") then
            return
        end
        inst.onattach(owner)

        
    end

    local function onunequip(inst, owner)
        if not owner:HasTag("player") then
            return
        end
        inst.ondetach()

    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    -- inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("armor_bramble")
    inst.AnimState:SetBuild("armor_bramble")
    inst.AnimState:PlayAnimation("anim")


    MakeInventoryFloatable(inst)
    ruins_custom_init(inst)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("leafymeatburger")
            -- inst.components.inventoryitem.imagename = "hoshino_equipment_sandstorm_core"
            -- inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_sandstorm_core.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL*6
    -- inst.components.equippable.is_magic_dapperness = true

    inst:AddComponent("armor")
    -- inst.components.armor:InitCondition(TUNING.ARMOR_RUINSHAT, TUNING.ARMOR_RUINSHAT_ABSORPTION)
    inst.components.armor:InitIndestructible(0)

    inst:AddComponent("shadowlevel")
    inst.components.shadowlevel:SetDefaultLevel(TUNING.RUINSHAT_SHADOW_LEVEL)

    MakeHauntableLaunch(inst)

    inst.OnRemoveEntity = ruins_onremove

    inst._fx = nil
    inst._task = nil
    inst._owner = nil
    inst.procfn = function(owner, data) tryproc(inst, owner, data) end
    inst.onattach = function(owner)
        if inst._owner ~= nil then
            inst:RemoveEventCallback("attacked", inst.procfn, inst._owner)
            inst:RemoveEventCallback("onremove", inst.ondetach, inst._owner)
        end
        inst:ListenForEvent("attacked", inst.procfn, owner)
        inst:ListenForEvent("onremove", inst.ondetach, owner)
        inst._owner = owner
        inst._fx = nil
    end
    inst.ondetach = function()
        ruinshat_unproc(inst)
        if inst._owner ~= nil then
            inst:RemoveEventCallback("attacked", inst.procfn, inst._owner)
            inst:RemoveEventCallback("onremove", inst.ondetach, inst._owner)
            inst._owner = nil
            inst._fx = nil
        end
    end

    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_ruins_core", fn, assets)
