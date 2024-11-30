local assets =
{
    Asset("ANIM", "anim/hoshino_projectile_nanotech_black_reaper_shadow.zip"),
}

local function OnHit(inst, attacker, target)

end

local function OnAnimOver(inst)
    -- inst:DoTaskInTime(.3, inst.Remove)
end

local function OnThrown(inst)
    -- inst:ListenForEvent("animover", OnAnimOver)
end

local function CreateAnim(parent)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    parent:AddChild(inst)
    inst.AnimState:SetBank("hoshino_projectile_nanotech_black_reaper_shadow")
    inst.AnimState:SetBuild("hoshino_projectile_nanotech_black_reaper_shadow")
    inst.AnimState:PlayAnimation("idle2",true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.Transform:SetPosition(0,1,0)
    inst.AnimState:SetDeltaTimeMultiplier(3)
    parent:DoTaskInTime(0,function()
        if parent:HasTag("main") then
            inst.AnimState:PlayAnimation("main",true)
        end
    end)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    -- inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    if not TheNet:IsDedicated() then
        CreateAnim(inst)
    end
    -- inst.Transform:SetFourFaced()

    -- inst.AnimState:SetBank("hoshino_projectile_nanotech_black_reaper")
    -- inst.AnimState:SetBuild("hoshino_projectile_nanotech_black_reaper")
    -- inst.AnimState:PlayAnimation("idle",true)
    -- inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:AddComponent("weapon")

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(1.5)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(inst.Remove)
    -- inst.components.projectile:SetOnThrownFn(OnThrown)
    inst:DoTaskInTime(0,function()
        if not inst.Ready and not TUNING.HOSHINO_DEBUGGING_MODE then
            inst:Remove()
        end
    end)
    return inst
end


return Prefab("hoshino_projectile_nanotech_black_reaper_shadow", fn, assets)