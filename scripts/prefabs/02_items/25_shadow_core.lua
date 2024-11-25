----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

暗影核心
饰品 无耐久
暗影术基座合成 不记忆配方
噩梦燃料*50 纯粹恐惧*15 暗影香炉*1 骨头盔甲*1 骨头头盔*1
免疫精神控制 获得骨头盔甲效果 影怪不会主动攻击你

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_equipment_shadow_core.zip"),
        Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_shadow_core.tex" ),
        Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_shadow_core.xml" ),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 骷髅盔甲
    local SHIELD_DURATION = 10 * FRAMES
    local SHIELD_VARIATIONS = 3
    local MAIN_SHIELD_CD = 1.2
    local RESISTANCES =
    {
        "_combat",
        "explosive",
        "quakedebris",
        "lunarhaildebris",
        "caveindebris",
        "trapdamage",
    }

    local function PickShield(inst)
        local t = GetTime()
        local flipoffset = math.random() < .5 and SHIELD_VARIATIONS or 0

        --variation 3 is the main shield
        local dt = t - inst.lastmainshield
        if dt >= MAIN_SHIELD_CD then
            inst.lastmainshield = t
            return flipoffset + 3
        end

        local rnd = math.random()
        if rnd < dt / MAIN_SHIELD_CD then
            inst.lastmainshield = t
            return flipoffset + 3
        end

        return flipoffset + (rnd < dt / (MAIN_SHIELD_CD * 2) + .5 and 2 or 1)
    end

    local function OnShieldOver(inst, OnResistDamage)
        inst.task = nil
        for i, v in ipairs(RESISTANCES) do
            inst.components.resistance:RemoveResistance(v)
        end
        inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
    end

    local function OnResistDamage(inst)--, damage)
        local owner = inst.components.inventoryitem:GetGrandOwner() or inst
        local fx = SpawnPrefab("shadow_shield"..tostring(PickShield(inst)))
        fx.entity:SetParent(owner.entity)

        if inst.task ~= nil then
            inst.task:Cancel()
        end
        inst.task = inst:DoTaskInTime(SHIELD_DURATION, OnShieldOver, OnResistDamage)
        inst.components.resistance:SetOnResistDamageFn(nil)

        -- inst.components.fueled:DoDelta(-TUNING.MED_FUEL)
        if inst.components.cooldown.onchargedfn ~= nil then
            inst.components.cooldown:StartCharging()
        end
    end

    local function ShouldResistFn(inst)
        if not inst.components.equippable:IsEquipped() then
            return false
        end
        local owner = inst.components.inventoryitem.owner
        return owner ~= nil
            and not (owner.components.inventory ~= nil and
                    owner.components.inventory:EquipHasTag("forcefield"))
    end

    local function OnChargedFn(inst)
        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
            inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
        end
        for i, v in ipairs(RESISTANCES) do
            inst.components.resistance:AddResistance(v)
        end
    end

    local function nofuel(inst)
        inst.components.cooldown.onchargedfn = nil
        inst.components.cooldown:FinishCharging()
    end

    local function CLIENT_PlayFuelSound(inst)
        local parent = inst.entity:GetParent()
        local container = parent ~= nil and (parent.replica.inventory or parent.replica.container) or nil
        if container ~= nil and container:IsOpenedBy(ThePlayer) then
            TheFocalPoint.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        end
    end

    local function SERVER_PlayFuelSound(inst)
        local owner = inst.components.inventoryitem.owner
        if owner == nil then
            inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        elseif inst.components.equippable:IsEquipped() and owner.SoundEmitter ~= nil then
            owner.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        else
            inst.playfuelsound:push()
            --Dedicated server does not need to trigger sfx
            if not TheNet:IsDedicated() then
                CLIENT_PlayFuelSound(inst)
            end
        end
    end

    local function ontakefuel(inst)
        if inst.components.equippable:IsEquipped() and
            -- not inst.components.fueled:IsEmpty() and
            inst.components.cooldown.onchargedfn == nil then
            inst.components.cooldown.onchargedfn = OnChargedFn
            inst.components.cooldown:StartCharging(TUNING.ARMOR_SKELETON_FIRST_COOLDOWN)
        end
        SERVER_PlayFuelSound(inst)
    end

    local function armorskeleton_onequip(inst, owner)


        inst.lastmainshield = 0
        -- if not inst.components.fueled:IsEmpty() then
            inst.components.cooldown.onchargedfn = OnChargedFn
            inst.components.cooldown:StartCharging(math.max(TUNING.ARMOR_SKELETON_FIRST_COOLDOWN, inst.components.cooldown:GetTimeToCharged()))
        -- end
    end

    local function armorskeleton_onunequip(inst, owner)
        -- owner.AnimState:ClearOverrideSymbol("swap_body")
        inst.components.cooldown.onchargedfn = nil
        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
            inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
        end
        for i, v in ipairs(RESISTANCES) do
            inst.components.resistance:RemoveResistance(v)
        end
    end

    local function onequiptomodel(inst, owner, from_ground)
        inst.components.cooldown.onchargedfn = nil

        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
            inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
        end

        for i, v in ipairs(RESISTANCES) do
            inst.components.resistance:RemoveResistance(v)
        end
    end
    local function GetShadowLevel(inst)
        return TUNING.ARMOR_SKELETON_SHADOW_LEVEL
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function onequip(inst, owner)
        if owner.components.hoshino_com_offical_debuff_blocker then
            owner.components.hoshino_com_offical_debuff_blocker:Add_Modify_Blocker(inst,"mindcontroller","mindcontroller")
        end
        if owner.components.sanity ~= nil then
            owner.components.sanity:SetInducedInsanity(inst, true)
        end
        armorskeleton_onequip(inst, owner)
    end

    local function onunequip(inst, owner)
        if owner.components.hoshino_com_offical_debuff_blocker then
            owner.components.hoshino_com_offical_debuff_blocker:Remove_Modify_Blocker(inst)
        end
        if owner.components.sanity ~= nil then
            owner.components.sanity:SetInducedInsanity(inst, false)
        end
        armorskeleton_onunequip(inst, owner)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 动画控制器
    local function Player_Near(inst)
        if inst:IsOnOcean(false) then
            inst.AnimState:HideSymbol("shadow")
        else
            inst.AnimState:ShowSymbol("shadow")
        end
        inst.AnimState:PlayAnimation("proximity_pre")
        inst.AnimState:PushAnimation("proximity_loop",true)
    end
    local function Player_Far(inst)
        if inst:IsOnOcean(false) then
            inst.AnimState:HideSymbol("shadow")
        else
            inst.AnimState:ShowSymbol("shadow")
        end
        -- inst.AnimState:PlayAnimation("proximity_loop")
        inst.AnimState:PushAnimation("proximity_pst")
        inst.AnimState:PushAnimation("idle",true)
    end
    local function DropInWater(inst)
        inst.AnimState:HideSymbol("shadow")
    end
    local function DropLanded(inst)
        inst.AnimState:ShowSymbol("shadow")
    end
    local function core_anim_controller_install(inst)
        inst:AddComponent("playerprox")
        inst.components.playerprox:SetDist(2, 3)
        inst.components.playerprox:SetOnPlayerNear(Player_Near)
        inst.components.playerprox:SetOnPlayerFar(Player_Far)
        --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                DropInWater(inst)
            else                                
                DropLanded(inst)
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("moonrock_seed")
    inst.AnimState:SetBuild("hoshino_equipment_shadow_core")
    inst.AnimState:PlayAnimation("idle",true)


    inst:AddTag("waterproofer")
    --shadowlevel (from shadowlevel component) added to pristine state for optimization
    inst:AddTag("shadowlevel")
    --shadowdominance (from shadowdominance component) added to pristine state for optimization
    inst:AddTag("shadowdominance")

    MakeInventoryFloatable(inst)

    inst:AddTag("fossil")
    inst.foleysound = "dontstarve/movement/foley/bone"
	inst.playfuelsound = net_event(inst.GUID, "armorskeleton.playfuelsound")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:DoTaskInTime(0, inst.ListenForEvent, "armorskeleton.playfuelsound", CLIENT_PlayFuelSound)
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_equipment_shadow_core"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_shadow_core.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)
    inst.components.equippable.dapperness = TUNING.CRAZINESS_MED
    inst.components.equippable.is_magic_dapperness = true

    inst:AddComponent("shadowlevel")
    inst.components.shadowlevel:SetDefaultLevel(TUNING.SKELETONHAT_SHADOW_LEVEL)
	inst.components.shadowlevel:SetLevelFn(GetShadowLevel)

    inst:AddComponent("shadowdominance")

    inst:AddComponent("armor")
    -- inst.components.armor:InitCondition(TUNING.ARMOR_SKELETONHAT, TUNING.ARMOR_SKELETONHAT_ABSORPTION)
    inst.components.armor:InitIndestructible(TUNING.ARMOR_SKELETONHAT_ABSORPTION)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

    inst:AddComponent("cooldown")
    inst.components.cooldown.cooldown_duration = TUNING.ARMOR_SKELETON_COOLDOWN

    inst:AddComponent("resistance")
    inst.components.resistance:SetShouldResistFn(ShouldResistFn)
    inst.components.resistance:SetOnResistDamageFn(OnResistDamage)

    MakeHauntableLaunch(inst)
    core_anim_controller_install(inst)

    inst.task = nil
    inst.lastmainshield = 0

    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_shadow_core", fn, assets)
