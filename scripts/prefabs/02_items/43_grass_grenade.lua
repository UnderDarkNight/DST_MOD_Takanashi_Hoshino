----------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local assets =
    {
        Asset("ANIM", "anim/hoshino_item_grass_grenade.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local DAMAGE = 100                  --- 伤害
    local DAMAGE_RADIUS = 6             --- 伤害范围
    local DEBUFF_DMG_TAKEN_MULT = 1.3   --- Debuff 造成的 受伤 倍增
    local PANIC_TIME = 5                --- 惊恐时间
    
    
    local BOUNCE_MUST_TAGS = { "_combat" }
    local BOUNCE_NO_TAGS = { "INLIMBO", "wall", "notarget", "player", "companion", "flight", "invisible", "noattack", "hiding" }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function do_aoe(inst,attacker)
        local x,y,z = inst.Transform:GetWorldPosition()
        -- SpawnPrefab("hoshino_item_grass_grenade_fx"):PushEvent("Set",{pt = Vector3(x,0,z)})
        SpawnPrefab("bomb_lunarplant_explode_fx").Transform:SetPosition(x,0,z)
        local fx_points = {}
        -- table.insert(fx_points,Vector3(x,0,z))
        local ents = TheSim:FindEntities(x,0,z,DAMAGE_RADIUS,BOUNCE_MUST_TAGS,BOUNCE_NO_TAGS)
        for k,temp_monster in pairs(ents) do
            if temp_monster.components.combat then
                temp_monster.components.combat:GetAttacked(attacker,DAMAGE,inst)
                if temp_monster.components.hauntable then
                    temp_monster.components.hauntable:Panic(PANIC_TIME)                    
                end
                table.insert(fx_points,Vector3(temp_monster.Transform:GetWorldPosition()))
                temp_monster:AddDebuff("hoshino_item_grass_grenade_debuff","hoshino_item_grass_grenade_debuff")
            end
        end
        for k, pt in pairs(fx_points) do
            SpawnPrefab("hoshino_item_grass_grenade_fx"):PushEvent("Set",{pt = pt})            
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function OnHitInGround(inst, attacker, target)
        -- SpawnPrefab("waterballoon_splash").Transform:SetPosition(inst.Transform:GetWorldPosition())
        -- SpawnPrefab("hoshino_item_grass_grenade_fx"):PushEvent("Set",{target = inst})
        -- print("OnHitInGround",inst,attacker,target)
        do_aoe(inst,attacker)
        inst:Remove()
    end

    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "hoshino_item_grass_grenade", "waterballoon01")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end

    local function onunequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end

    local function onthrown(inst)
        inst:AddTag("NOCLICK")
        inst.persists = false

        inst.AnimState:PlayAnimation("spin_loop", true)

        inst.Physics:SetMass(1)
        inst.Physics:SetCapsule(0.2, 0.2)
        inst.Physics:SetFriction(0)
        inst.Physics:SetDamping(0)
        inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.GROUND)
        inst.Physics:CollidesWith(COLLISION.OBSTACLES)
        inst.Physics:CollidesWith(COLLISION.ITEMS)
    end

    local function ReticuleTargetFn()
        local player = ThePlayer
        local ground = TheWorld.Map
        local pos = Vector3()
        --Attack range is 8, leave room for error
        --Min range was chosen to not hit yourself (2 is the hit range)
        for r = 6.5, 3.5, -.25 do
            pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
            if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
                return pos
            end
        end
        return pos
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 物品代码
    local function item_fn()
        --weapon (from weapon component) added to pristine state for optimization
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        --projectile (from complexprojectile component) added to pristine state for optimization
        inst:AddTag("projectile")
        inst:AddTag("complexprojectile")
        inst:AddTag("weapon")
        inst.AnimState:SetBank("hoshino_item_grass_grenade")
        inst.AnimState:SetBuild("hoshino_item_grass_grenade")
        inst.AnimState:PlayAnimation("idle", false)

        inst.entity:SetPristine()

        inst:AddComponent("reticule")
        inst.components.reticule.targetfn = ReticuleTargetFn
        inst.components.reticule.ease = true

        MakeInventoryFloatable(inst, "med", 0.05, 0.65)


        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("locomotor")
        inst:AddComponent("complexprojectile")

        inst.components.complexprojectile:SetHorizontalSpeed(15)
        inst.components.complexprojectile:SetGravity(-35)
        inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
        inst.components.complexprojectile:SetOnLaunch(onthrown)
        inst.components.complexprojectile:SetOnHit(OnHitInGround)

        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(DAMAGE)
        inst.components.weapon:SetRange(13, 18)

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
        inst.components.inventoryitem.imagename = "hoshino_item_grass_grenade"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_grass_grenade.xml"

        inst:AddComponent("stackable")

        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.equipstack = true


        MakeHauntableLaunch(inst)

        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 爆炸特效
    local function fx()
        local inst = CreateEntity()

        inst.entity:AddSoundEmitter()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetBank("waterballoon")
        inst.AnimState:SetBuild("hoshino_item_grass_grenade")
        inst.AnimState:PlayAnimation("used")

        inst:AddTag("INLIMBO")
        inst:AddTag("FX")
        inst:AddTag("fx")
        inst:AddTag("NOBLOCK")
        inst:AddTag("NOCLICK")

        inst.entity:SetPristine()
        inst:ListenForEvent("animover",inst.Remove)
        if not TheWorld.ismastersim then
            return inst
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
        inst:ListenForEvent("Set",function(inst,_table)
            -- _table = {
            --     pt = Vector3(0,0,0),
            --     target = inst,
            -- }
            if _table == nil then
                return
            end
            if _table.pt and _table.pt.x then
                inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
            end
            if _table.target then
                inst.Transform:SetPosition(_table.target.Transform:GetWorldPosition())
            end

            inst.Ready = true
        end)

        inst:DoTaskInTime(0,function()
            if inst.Ready ~= true then
                inst:Remove()
            end
        end)

        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- debuff
    local function debuff_OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0,0,0)
        -----------------------------------------------------
        ---
            if target.components.combat then
                target.components.combat.externaldamagetakenmultipliers:SetModifier(inst,DEBUFF_DMG_TAKEN_MULT)
            end
        -----------------------------------------------------
    end
    local function debuff_fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddNetwork()
        inst.entity:AddTransform()
        inst:AddTag("CLASSIFIED")
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(debuff_OnAttached)
        inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
        return inst
    end

----------------------------------------------------------------------------------------------------------------------------------------------------



return Prefab("hoshino_item_grass_grenade", item_fn, assets),
    Prefab("hoshino_item_grass_grenade_fx", fx, assets),
    Prefab("hoshino_item_grass_grenade_debuff", debuff_fn, assets)

