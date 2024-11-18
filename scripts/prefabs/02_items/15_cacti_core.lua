----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

仙人掌核心
饰品 amulet 24min	
合成材料：仙人掌*20 烤仙人掌*20 树枝*20
你被攻击时会爆出尖刺，对周围造成12点aoe伤害

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/armor_bramble.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- finiteuses
    local FINITEUSES_MAX = TUNING.HOSHINO_DEBUGGING_MODE and 60 or 24*60
    local DAMAGE_PER_HIT = 12   -- 直接反伤
    local DAMAGE_SP_PER_HIT = nil -- 位面伤害
----------------------------------------------------------------------------------------------------------------------------------------------------



local function onequip(inst, owner)
    inst:DoTaskInTime(1,function()


        inst.__player_get_attaked_event = inst.__player_get_attaked_event or function(player,_table)
            local damage = _table and _table.damage
            if type(damage) == "number" and damage > 0 then
                    local fx = SpawnPrefab("bramblefx_armor")
                    fx.damage = DAMAGE_PER_HIT -- 直接伤害
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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("bramble_resistant") -- 避免被自己装备伤害

    inst.AnimState:SetBank("armor_bramble")
    inst.AnimState:SetBuild("armor_bramble")
    inst.AnimState:PlayAnimation("anim")

    inst.foleysound = "dontstarve/movement/foley/cactus_armor"

    MakeInventoryFloatable(inst)

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

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(FINITEUSES_MAX)
    inst.components.finiteuses:SetPercent(1)
    inst.components.finiteuses:SetOnFinished(inst.Remove)


    MakeHauntableLaunch(inst)
    return inst
end

----------------------------------------------------------------------------------------------------------------------------------------------------
-- --- 复制自 bramblefx.lua
    -- --DSV uses 4 but ignores physics radius
    -- local MAXRANGE = 3
    -- local NO_TAGS_NO_PLAYERS =	{ "bramble_resistant", "INLIMBO", "notarget", "noattack", "flight", "invisible", "wall", "player", "companion" }
    -- local NO_TAGS =				{ "bramble_resistant", "INLIMBO", "notarget", "noattack", "flight", "invisible", "wall", "playerghost" }
    -- local COMBAT_TARGET_TAGS = { "_combat" }

    -- local function OnUpdateThorns(inst)
    --     inst.range = inst.range + .75

    --     local x, y, z = inst.Transform:GetWorldPosition()
    --     for i, v in ipairs(TheSim:FindEntities(x, y, z, inst.range + 3, COMBAT_TARGET_TAGS, inst.canhitplayers and NO_TAGS or NO_TAGS_NO_PLAYERS)) do
    --         if not inst.ignore[v] and
    --             v:IsValid() and
    --             v.entity:IsVisible() and
    --             v.components.combat ~= nil and
    --             not (v.components.inventory ~= nil and
    --                 v.components.inventory:EquipHasTag("bramble_resistant")) then
    --             local range = inst.range + v:GetPhysicsRadius(0)
    --             if v:GetDistanceSqToPoint(x, y, z) < range * range then
    --                 if inst.owner ~= nil and not inst.owner:IsValid() then
    --                     inst.owner = nil
    --                 end
    --                 if inst.owner ~= nil then
    --                     if inst.owner.components.combat ~= nil and
    --                         inst.owner.components.combat:CanTarget(v) and
    --                         not inst.owner.components.combat:IsAlly(v)
    --                     then
    --                         inst.ignore[v] = true
    --                         v.components.combat:GetAttacked(v.components.follower and v.components.follower:GetLeader() == inst.owner and inst or inst.owner, inst.damage, nil, nil, inst.spdmg)
    --                         --V2C: wisecracks make more sense for being pricked by picking
    --                         --v:PushEvent("thorns")
    --                     end
    --                 elseif v.components.combat:CanBeAttacked() then
    --                     -- NOTES(JBK): inst.owner is nil here so this is for non worn things like the bramble trap.
    --                     local isally = false
    --                     if not inst.canhitplayers then
    --                         --non-pvp, so don't hit any player followers (unless they are targeting a player!)
    --                         local leader = v.components.follower ~= nil and v.components.follower:GetLeader() or nil
    --                         isally = leader ~= nil and leader:HasTag("player") and
    --                             not (v.components.combat ~= nil and
    --                                 v.components.combat.target ~= nil and
    --                                 v.components.combat.target:HasTag("player"))
    --                     end
    --                     if not isally then
    --                         inst.ignore[v] = true
    --                         v.components.combat:GetAttacked(inst, inst.damage, nil, nil, inst.spdmg)
    --                         --v:PushEvent("thorns")
    --                     end
    --                 end
    --             end
    --         end
    --     end

    --     if inst.range >= MAXRANGE then
    --         inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateThorns)
    --     end
    -- end

    -- local function SetFXOwner(inst, owner,damage,spdamage)
    --     inst.Transform:SetPosition(owner.Transform:GetWorldPosition())
    --     inst.owner = owner
    --     inst.canhitplayers = not owner:HasTag("player") or TheNet:GetPVPEnabled()
    --     inst.ignore[owner] = true

    --     if spdamage then
    --         inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    --     end
    --     inst.damage = damage or TUNING.ARMORBRAMBLE_DMG
    --     if spdamage then
    --         inst.spdmg = { planar = spdamage or TUNING.ARMORBRAMBLE_DMG_PLANAR_UPGRADE }
    --     end
    -- end

    -- local function fx()

    --     local inst = CreateEntity()
    --     inst.entity:AddTransform()
    --     inst.entity:AddAnimState()
    --     inst.entity:AddNetwork()

    --     inst:AddTag("FX")
    --     inst:AddTag("thorny")

    --     inst.Transform:SetFourFaced()

    --     inst.AnimState:SetBank("bramblefx")
    --     inst.AnimState:SetBuild("bramblefx")
    --     inst.AnimState:PlayAnimation("idle")

    --     inst:SetPrefabNameOverride("bramblefx")

    --     inst.entity:SetPristine()

    --     if not TheWorld.ismastersim then
    --         return inst
    --     end

    --     inst:AddComponent("updatelooper")
    --     inst.components.updatelooper:AddOnUpdateFn(OnUpdateThorns)

    --     inst:ListenForEvent("animover", inst.Remove)
    --     inst.persists = false
    --     inst.damage = TUNING.ARMORBRAMBLE_DMG
    --     -- inst.spdmg = planardamage and { planar = TUNING.ARMORBRAMBLE_DMG_PLANAR_UPGRADE } or nil
    --     inst.range = .75
    --     inst.ignore = {}
    --     inst.canhitplayers = true
    --     --inst.owner = nil

    --     inst.SetFXOwner = SetFXOwner

    --     return inst
    -- end

----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_cacti_core", fn, assets)
        -- ,Prefab("hoshino_equipment_cacti_core_fx", fx, assets)
