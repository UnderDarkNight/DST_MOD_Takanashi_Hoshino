----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

守护者核心
饰品 amulet 无耐久
由远古守护者掉落
攻击时会召唤暗影触手（类似铥矿棒）。暗影触手造成34点伤害

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_equipment_tree_core.zip"),
        Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_tree_core.tex" ),
        Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_tree_core.xml" ),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    
    local function on_attacked_event_for_player(player,_table)
        local damage = _table and _table.damage or 0
        if damage > 0 and player.components.health then
            local heal_delta = damage*0.15
            if TUNING.HOSHINO_DEBUGGING_MODE then
                heal_delta = damage*2
            end
            player.components.health:DoDelta(heal_delta)
        end
    end
    local heal_delta = {
        ["day"] = 1,
        ["dusk"] = 0.5,
        ["night"] = 0,
        ["nil"] = 0,
    }
    local function onequip(inst, owner)
        inst:ListenForEvent("attacked",on_attacked_event_for_player,owner)
        if inst.task == nil then
            inst.task = inst:DoPeriodicTask(10,function()
                if owner.components.health then
                    owner.components.health:DoDelta(heal_delta[TheWorld.state.phase] or 0,true)
                end
            end)
        end
    end

    local function onunequip(inst, owner)
        inst:RemoveEventCallback("attacked",on_attacked_event_for_player,owner)
        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
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
    -- inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("moonrock_seed")
    inst.AnimState:SetBuild("hoshino_equipment_tree_core")
    inst.AnimState:PlayAnimation("idle",true)


    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_equipment_tree_core"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_tree_core.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL*6
    inst.components.equippable.is_magic_dapperness = true

    MakeHauntableLaunch(inst)
    core_anim_controller_install(inst)

    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_tree_core", fn, assets)
