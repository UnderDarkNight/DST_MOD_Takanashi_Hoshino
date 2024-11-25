----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

巨蟹钳
amulet 
饰品 无耐久
帝王蟹掉落
获得水上行走的能力，在水上行走时移动速度+50%

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_equipment_giant_crab_claw.zip"),
        Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_giant_crab_claw.tex" ),
        Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_giant_crab_claw.xml" ),
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
    inst.AnimState:SetBuild("hoshino_equipment_giant_crab_claw")
    inst.AnimState:PlayAnimation("idle",true)


    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_equipment_giant_crab_claw"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_giant_crab_claw.xml"


    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL*6
    -- inst.components.equippable.is_magic_dapperness = true


    MakeHauntableLaunch(inst)
    core_anim_controller_install(inst)

    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_giant_crab_claw", fn, assets)
