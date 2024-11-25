----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

符章核心
饰品 amulet 耐久 10
合成材料：魔光护符*1，懒人护符*1，建造护符*1
在远古伪科学站合成，不记忆配方
每使用一次建造护符效果消耗1耐久，不可拆解
拥有三种护符的效果（魔光护符*1，懒人护符*1，建造护符*1）

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_equipment_rune_core.zip"),
        Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_rune_core.tex" ),
        Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_rune_core.xml" ),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 魔光
    local function on_equip_yellow(inst,owner)
        if inst._light == nil or not inst._light:IsValid() then
            inst._light = SpawnPrefab("yellowamuletlight")
        end
        inst._light.entity:SetParent(owner.entity)    
        if owner.components.bloomer ~= nil then
            owner.components.bloomer:PushBloom(inst, "shaders/anim.ksh", 1)
        else
            owner.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end
    end
    local function turnoff_yellow(inst)
        if inst._light ~= nil then
            if inst._light:IsValid() then
                inst._light:Remove()
            end
            inst._light = nil
        end
    end
    local function on_unequip_yellow(inst,owner)
        if owner.components.bloomer ~= nil then
            owner.components.bloomer:PopBloom(inst)
        else
            owner.AnimState:ClearBloomEffectHandle()
        end
        turnoff_yellow(inst)
    end
    local function onequiptomodel_yellow(inst, owner, from_ground)
        if owner.components.bloomer ~= nil then
            owner.components.bloomer:PopBloom(inst)
        else
            owner.AnimState:ClearBloomEffectHandle()
        end    
        turnoff_yellow(inst)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 懒人
    local function pickup(inst, owner)
        local item = FindPickupableItem(owner, TUNING.ORANGEAMULET_RANGE, false)
        if item == nil then
            return
        end

        local didpickup = false
        if item.components.trap ~= nil then
            item.components.trap:Harvest(owner)
            didpickup = true
        end

        if owner.components.minigame_participator ~= nil then
            local minigame = owner.components.minigame_participator:GetMinigame()
            if minigame ~= nil then
                minigame:PushEvent("pickupcheat", { cheater = owner, item = item })
            end
        end

        --Amulet will only ever pick up items one at a time. Even from stacks.
        SpawnPrefab("sand_puff").Transform:SetPosition(item.Transform:GetWorldPosition())

        -- inst.components.finiteuses:Use(1)

        if not didpickup then
            local item_pos = item:GetPosition()
            if item.components.stackable ~= nil then
                item = item.components.stackable:Get()
            end

            owner.components.inventory:GiveItem(item, nil, item_pos)
        end
    end
    local function on_equip_orange(inst,owner)
        inst.task = inst:DoPeriodicTask(TUNING.ORANGEAMULET_ICD, pickup, nil, owner)
    end
    local function on_unequip_orange(inst,owner)
        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
        end
    end
    local function onequiptomodel_orange(inst, owner, from_ground)
        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 建造
    local function on_equip_green(inst,owner)
        if owner.components.builder ~= nil then
            owner.components.builder.ingredientmod = TUNING.GREENAMULET_INGREDIENTMOD
        end
        inst.onitembuild = inst.onitembuild or function(owner, data)
            --V2C: backward compatibility so that no data or discounted == nil still consumes a charge
            --     (discounted is newly added; in the past, it would always consume a charge)
            if not (data ~= nil and data.discounted == false) then
                inst.components.finiteuses:Use(1)
            end
        end
        inst:ListenForEvent("consumeingredients", inst.onitembuild, owner)
    end
    local function on_unequip_green(inst,owner)
        if owner.components.builder ~= nil then
            owner.components.builder.ingredientmod = 1
        end
        inst:RemoveEventCallback("consumeingredients", inst.onitembuild, owner)
    end
    local function onequiptomodel_green(inst, owner, from_ground)
        if owner.components.builder ~= nil then
            owner.components.builder.ingredientmod = 1
        end
        inst:RemoveEventCallback("consumeingredients", inst.onitembuild, owner)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 合并 onequiptomodel
    local function onequiptomodel(inst, owner, from_ground)
        onequiptomodel_yellow(inst,owner,from_ground)
        onequiptomodel_orange(inst,owner,from_ground)
        onequiptomodel_green(inst,owner,from_ground)
    end
    local function on_dropped_fn(inst)
        turnoff_yellow(inst)
    end
    local function onequip(inst, owner)
        on_equip_yellow(inst,owner)
        on_equip_orange(inst,owner)
        on_equip_green(inst,owner)
    end

    local function onunequip(inst, owner)
        on_unequip_yellow(inst,owner)
        on_unequip_orange(inst,owner)
        on_unequip_green(inst,owner)
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

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("moonrock_seed")
    inst.AnimState:SetBuild("hoshino_equipment_rune_core")
    inst.AnimState:PlayAnimation("idle",true)


    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_equipment_rune_core"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_rune_core.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)
    inst.components.inventoryitem:SetOnDroppedFn(on_dropped_fn)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetPercent(1)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    core_anim_controller_install(inst)

    MakeHauntableLaunch(inst)
    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_rune_core", fn, assets)
