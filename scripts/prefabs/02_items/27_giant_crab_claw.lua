----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

龙蝇之护：
饰品 amulet 耐久16min
龙蝇掉落
免疫火焰伤害 免疫过热伤害 你的所有动作加快20%（这个效果有参考代码）

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/armor_bramble.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function onequip(inst, owner)
        if not owner:HasTag("player") then
            return
        end

        if owner.components.drownable and owner.components.drownable.enabled ~= false then
            owner.components.drownable.enabled = false
        end
        owner.Physics:ClearCollisionMask()
        owner.Physics:CollidesWith(COLLISION.GROUND)
        owner.Physics:CollidesWith(COLLISION.OBSTACLES)
        owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
        owner.Physics:CollidesWith(COLLISION.CHARACTERS)
        owner.Physics:CollidesWith(COLLISION.GIANTS)
        -- MakeInventoryPhysics(inst)
        -- RemovePhysicsColliders(inst)
        owner.Physics:Teleport(owner.Transform:GetWorldPosition())

        ---- 水上行走加速
        if inst.__walking_task == nil then
            inst.__walking_task = inst:DoPeriodicTask(0.3,function()
                if owner.components.locomotor then
                    if owner:IsOnOcean(false) then
                        owner.components.locomotor:SetExternalSpeedMultiplier(inst, "hoshino_equipment_giant_crab_claw",TUNING.HOSHINO_DEBUGGING_MODE and 2 or 1.5)
                    else
                        owner.components.locomotor:SetExternalSpeedMultiplier(inst, "hoshino_equipment_giant_crab_claw", 1)
                    end
                end
            end)
        end
    end

    local function onunequip(inst, owner)
        if not owner:HasTag("player") then
            return
        end
        if owner.components.drownable then
            owner.components.drownable.enabled = true
        end
        owner.Physics:ClearCollisionMask()
        owner.Physics:CollidesWith(COLLISION.WORLD)
        owner.Physics:CollidesWith(COLLISION.OBSTACLES)
        owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
        owner.Physics:CollidesWith(COLLISION.CHARACTERS)
        owner.Physics:CollidesWith(COLLISION.GIANTS)
        MakeCharacterPhysics(inst, 75, .5)
        owner.Physics:Teleport(owner.Transform:GetWorldPosition())


        if inst.__walking_task ~= nil then
            inst.__walking_task:Cancel()
            inst.__walking_task = nil

            if owner.components.locomotor then
                owner.components.locomotor:RemoveExternalSpeedMultiplier(inst,"hoshino_equipment_giant_crab_claw")
            end
        end
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


    MakeHauntableLaunch(inst)
    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_giant_crab_claw", fn, assets)
