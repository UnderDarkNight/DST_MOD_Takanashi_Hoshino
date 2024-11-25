----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

蛛后之心
饰品，无耐久
蜘蛛女王10%掉落
蜘蛛不会主动攻击你，免疫蜘蛛网减速，

和蜘蛛帽同时穿戴时，蜘蛛帽的掉san效果消失，

攻击敌人的时候会使被攻击目标减速15%，且每秒钟损失10生命 持续5s

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_equipment_spider_core.zip"),
        Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_spider_core.tex" ),
        Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_spider_core.xml" ),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function spider_web_blocker_install(owner)
        if owner and owner.components.locomotor then
            owner.components.locomotor:SetTriggersCreep(false)
            owner.components.locomotor.fasteroncreep = true
        end
    end
    local function spider_web_blocker_uninstall(owner)
        if owner and owner.components.locomotor then
            owner.components.locomotor:SetTriggersCreep(true)
            owner.components.locomotor.fasteroncreep = false
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 蜘蛛帽代码
    local function spider_disable(inst)
        if inst.updatetask then
            inst.updatetask:Cancel()
            inst.updatetask = nil
        end
        local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
        if owner and owner.components.leader then
            if not owner:HasTag("spiderwhisperer") then
                if not owner:HasTag("playermonster") then
                    owner:RemoveTag("monster")
                    spider_web_blocker_uninstall(owner)
                end
                owner:RemoveTag("spiderdisguise")

                for k,v in pairs(owner.components.leader.followers) do
                    if k:HasTag("spider") and k.components.combat then
                        k.components.combat:SuggestTarget(owner)
                    end
                end
                owner.components.leader:RemoveFollowersByTag("spider")
            else
                owner.components.leader:RemoveFollowersByTag("spider", function(follower)
                    if follower and follower.components.follower then
                        if follower.components.follower:GetLoyaltyPercent() > 0 then
                            return false
                        else
                            return true
                        end
                    end
                end)
            end

        end
    end
    local function spider_update(inst)
        local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
        if owner and owner.components.leader then
            owner.components.leader:RemoveFollowersByTag("pig")
            -- local x,y,z = owner.Transform:GetWorldPosition()
            -- local ents = TheSim:FindEntities(x,y,z, TUNING.SPIDERHAT_RANGE, SPIDER_TAGS)
            -- for k,v in pairs(ents) do
            --     if v.components.follower and not v.components.follower.leader and not owner.components.leader:IsFollower(v) and owner.components.leader.numfollowers < 10 then
            --         owner.components.leader:AddFollower(v)
            --     end
            -- end
        end
    end
    local function spider_enable(inst)
        local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
        if owner and owner.components.leader then
            owner.components.leader:RemoveFollowersByTag("pig")
            owner:AddTag("monster")
            owner:AddTag("spiderdisguise")
            spider_web_blocker_install(owner)
        end
        inst.updatetask = inst:DoPeriodicTask(0.5, spider_update, 1)
    end
    local function spider_onequiptomodel(inst, owner, from_ground)
        spider_disable(inst)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function has_spider_hat(owner)
        if owner and owner.components.inventory then
            for k, item in pairs(owner.components.inventory.equipslots) do
                if item and item.prefab == "spiderhat" then
                    return true
                end
            end
        end
        return false
    end
    local function on_hit_other_fn_for_player(player,_table)
        local target = _table and _table.target
        if target and target:IsValid() and target.AddDebuff then
            target:AddDebuff("hoshino_equipment_spider_core_debuff","hoshino_equipment_spider_core_debuff")
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function onequip(inst, owner)
        spider_enable(inst)
        inst:ListenForEvent("onhitother", on_hit_other_fn_for_player,owner)
    end
    local function onunequip(inst, owner)
        spider_disable(inst)
        inst:RemoveEventCallback("onhitother", on_hit_other_fn_for_player,owner)
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
    inst.AnimState:SetBuild("hoshino_equipment_spider_core")
    inst.AnimState:PlayAnimation("idle",true)


    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_equipment_spider_core"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_spider_core.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(spider_onequiptomodel)
    -- inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    inst.components.equippable.dapperness = 0
    inst.components.equippable.is_magic_dapperness = true
    local old_GetDapperness = inst.components.equippable.GetDapperness
    inst.components.equippable.GetDapperness = function(self,owner,...)
        local old_ret = old_GetDapperness(self,owner,...)
        if has_spider_hat(owner) then
            old_ret = old_ret + TUNING.DAPPERNESS_SMALL
        end
        return old_ret
    end

    MakeHauntableLaunch(inst)
    core_anim_controller_install(inst)

    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function debuff_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(function(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。重复添加不会执行。
        inst.entity:SetParent(target.entity)
        inst.Network:SetClassifiedTarget(target)
        inst.target = target
        -- print("新增debuff")
        -----------------------------------------------------
        --- 减速 15%
            if target.components.locomotor then
                local mult = 1-0.15
                if TUNING.HOSHINO_DEBUGGING_MODE then
                    mult = 0.2
                end
                target.components.locomotor:SetExternalSpeedMultiplier(inst, "hoshino_equipment_spider_core_debuff", mult)
            end
        -----------------------------------------------------
        --- 扣血debuff
            inst.time = 5
            inst:DoPeriodicTask(1,function()
                if target.components.health and not target.components.health:IsDead() then
                    target.components.health:DoDelta(-10,nil,inst.prefab)
                end
                inst.time = (inst.time or 0) - 1
                if inst.time <= 0 then
                    inst:Remove()
                end
            end)
        -----------------------------------------------------
    end)
    inst.components.debuff:SetExtendedFn(function(inst) -- 重复添加debuff 的时候执行。
        local target = inst.target
        -----------------------------------------------------
        ---
            inst.time = (inst.time or 0) + 5
        -----------------------------------------------------
    end)
    -- inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆

    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_spider_core", fn, assets),
    Prefab("hoshino_equipment_spider_core_debuff", debuff_fn, assets)
