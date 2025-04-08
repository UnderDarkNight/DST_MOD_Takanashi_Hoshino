local assets = {
	Asset("ANIM", "anim/hoshino_fx_blackguard_poof.zip"),
}

local fx_fns = {
    [1] = "for_monster",
    [2] = "for_player",
    [3] = function(inst)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround) --设置贴地
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:PlayAnimation("in_ground")
    end
}

local function fx()
    local inst = CreateEntity()

    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("hoshino_fx_blackguard_poof")
    inst.AnimState:SetBuild("hoshino_fx_blackguard_poof")
    -- inst.AnimState:PlayAnimation("small_firecrackers",false)
    inst.AnimState:SetFinalOffset(1)
    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst:ListenForEvent("animover",inst.Remove)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     target = inst,
        --     sound = "",
        --     nosound = false,
        --     scale = 1,
        --     type = 1
        -- }

        if _table == nil then
            return
        end
        ------------------------------------------------------------------------------------------------------------------------------------
        ---
            local anim_type = math.clamp(_table.type or 1,1,3)
            local anim_or_fn = fx_fns[anim_type]
            if type(anim_or_fn) == "string" then
                inst.AnimState:PlayAnimation(anim_or_fn)
            elseif type(anim_or_fn) == "function" then
                anim_or_fn(inst)
            end
        ------------------------------------------------------------------------------------------------------------------------------------
        ---
            if _table.pt and _table.pt.x then
                inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
            end
            if _table.target then
                inst.Transform:SetPosition(_table.target.Transform:GetWorldPosition())
            end
        ------------------------------------------------------------------------------------------------------------------------------------
        ---
            if not _table.nosound then
                if _table.sound then
                    inst.SoundEmitter:PlaySound(_table.sound,"explode")
                else
                    inst.SoundEmitter:PlaySound("dontstarve/common/together/fire_cracker","explode")
                end
            end
        ------------------------------------------------------------------------------------------------------------------------------------
        --- 
            if type(_table.scale) == "number" then
                inst.AnimState:SetScale(_table.scale,_table.scale,_table.scale)
            end
        ------------------------------------------------------------------------------------------------------------------------------------

        inst.Ready = true
    end)

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)

    return inst
end

return Prefab("hoshino_fx_blackguard_poof", fx, assets)