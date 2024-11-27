----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

仙人掌核心
饰品 amulet 24min	
合成材料：仙人掌*20 烤仙人掌*20 树枝*20
你被攻击时会爆出尖刺，对周围造成12点aoe伤害.夏天伤害为40

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_equipment_cacti_core.zip"),
        Asset("ANIM", "anim/hoshino_equipment_cacti_core_summer.zip"),
        Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_cacti_core.tex" ),
        Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_cacti_core.xml" ),
        Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_cacti_core_summer.tex" ),
        Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_cacti_core_summer.xml" ),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- finiteuses
    local FINITEUSES_MAX = TUNING.HOSHINO_DEBUGGING_MODE and 60 or 24*60
    local DAMAGE_PER_HIT = 12   -- 直接反伤
    local DAMAGE_PER_HIT_SUMMER = 40 -- 直接反伤
    local DAMAGE_SP_PER_HIT = nil -- 位面伤害
    local function Get_Damage_Per_Hit()
        if TheWorld.state.issummer then
            return DAMAGE_PER_HIT_SUMMER
        else
            return DAMAGE_PER_HIT
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 外观切换
    local function Summer_Active(inst)
        inst.components.inventoryitem.imagename = "hoshino_equipment_cacti_core_summer"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_cacti_core_summer.xml"
        inst:PushEvent("imagechange")
        inst.AnimState:SetBuild("hoshino_equipment_cacti_core_summer")
    end
    local function Summer_Deactive(inst)
        inst.components.inventoryitem.imagename = "hoshino_equipment_cacti_core"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_cacti_core.xml"
        inst:PushEvent("imagechange")
        inst.AnimState:SetBuild("hoshino_equipment_cacti_core")
    end
    local function Switcher_Active(inst)
        if TheWorld.state.issummer then
            Summer_Active(inst)
        else
            Summer_Deactive(inst)
        end
    end
    local function Anim_Summer_Switcher_Install(inst)
        inst:WatchWorldState("season",function()
            inst:DoTaskInTime(0,Switcher_Active)            
        end)
        inst:DoTaskInTime(0,Switcher_Active)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------



local function onequip(inst, owner)
    inst:DoTaskInTime(1,function()


        inst.__player_get_attaked_event = inst.__player_get_attaked_event or function(player,_table)
            local damage = _table and _table.damage
            if type(damage) == "number" and damage > 0 then
                    local fx = SpawnPrefab("bramblefx_armor")
                    fx.damage = Get_Damage_Per_Hit() or DAMAGE_PER_HIT -- 直接伤害
                    if DAMAGE_SP_PER_HIT then -- 位面伤害
                        fx.spdmg = { planar = DAMAGE_SP_PER_HIT }
                        fx.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
                    end
                    fx:SetFXOwner(player)
                    if player.SoundEmitter ~= nil then
                        player.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
                    end
            end
        end
        inst:ListenForEvent("attacked",inst.__player_get_attaked_event,owner)


        if inst._time_Task == nil then
            inst._time_Task = inst:DoPeriodicTask(1,function()
                inst.components.finiteuses:Use(1)
            end)
        end

    end)

end

local function onunequip(inst, owner)
    if inst.__player_get_attaked_event then
        inst:RemoveEventCallback("attacked",inst.__player_get_attaked_event,owner)
    end
    if inst._time_Task then
        inst._time_Task:Cancel()
        inst._time_Task = nil
    end
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

    MakeInventoryPhysics(inst)

    inst:AddTag("bramble_resistant") -- 避免被自己装备伤害

    inst.AnimState:SetBank("moonrock_seed")
    inst.AnimState:SetBuild("hoshino_equipment_cacti_core")
    inst.AnimState:PlayAnimation("idle",true)

    inst.foleysound = "dontstarve/movement/foley/cactus_armor"

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_equipment_cacti_core"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_cacti_core.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(FINITEUSES_MAX)
    inst.components.finiteuses:SetPercent(1)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    core_anim_controller_install(inst)
    Anim_Summer_Switcher_Install(inst)
    MakeHauntableLaunch(inst)
    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_cacti_core", fn, assets)
