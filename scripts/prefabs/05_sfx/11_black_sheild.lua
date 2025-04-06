local assets =
{
   Asset("ANIM", "anim/forcefield.zip"),
--    Asset("ANIM", "anim/hoshino_sfx_ruiins_sheild.zip"),
   Asset("ANIM", "anim/hoshino_backguard.zip"),
   Asset("ANIM", "anim/hoshino_fx_blackguard_glow.zip"),
}

local MAX_LIGHT_FRAME = 6

local function OnUpdateLight(inst, dframes)
    local done
    if inst._islighton:value() then
        local frame = inst._lightframe:value() + dframes
        done = frame >= MAX_LIGHT_FRAME
        inst._lightframe:set_local(done and MAX_LIGHT_FRAME or frame)
    else
        local frame = inst._lightframe:value() - dframes
        done = frame <= 0
        inst._lightframe:set_local(done and 0 or frame)
    end

    inst.Light:SetRadius(3 * inst._lightframe:value() / MAX_LIGHT_FRAME)

    if done then
        inst._lighttask:Cancel()
        inst._lighttask = nil
    end
end

local function OnLightDirty(inst)
    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
    end
    OnUpdateLight(inst, 0)
end

local function kill_fx(inst)
    -- inst.AnimState:PlayAnimation("close")
    -- inst._islighton:set(false)
    -- inst._lightframe:set(inst._lightframe:value())
    -- OnLightDirty(inst)
    -- inst:DoTaskInTime(.6, inst.Remove)
    inst:Remove()
end

local function create_fx2(parent)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.AnimState:SetBank("hoshino_fx_blackguard_glow")
    inst.AnimState:SetBuild("hoshino_fx_blackguard_glow")
    inst.AnimState:PlayAnimation("idle",true)

    inst.entity:SetParent(parent.entity)
    inst.Transform:SetPosition(0,0,0)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("hoshino_backguard")
    inst.AnimState:SetBuild("hoshino_backguard")
    inst.AnimState:PlayAnimation("idle",true)
    inst.AnimState:SetMultColour(1,1,1,1)

    inst.AnimState:SetFinalOffset(1)

    inst.SoundEmitter:PlaySound("dontstarve/wilson/forcefield_LP", "loop")

    inst.Light:SetRadius(0)
    inst.Light:SetIntensity(.9)
    inst.Light:SetFalloff(.9)
    -- inst.Light:SetColour(1, 1, 1)
    inst.Light:SetColour(255/255, 100/255, 100/255)
    inst.Light:Enable(true)
    inst.Light:EnableClientModulation(true)

    inst._lightframe = net_tinybyte(inst.GUID, "forcefieldfx._lightframe", "lightdirty")
    inst._islighton = net_bool(inst.GUID, "forcefieldfx._islighton", "lightdirty")
    inst._lighttask = nil
    inst._islighton:set(true)

    inst.entity:SetPristine()

    OnLightDirty(inst)
    if not TheNet:IsDedicated() then
        create_fx2(inst)
    end
    if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty)

        return inst
    end

    inst:ListenForEvent("close", kill_fx)

    inst.kill_fx = kill_fx

    return inst
end

return Prefab("hoshino_sfx_black_sheild", fn, assets)
