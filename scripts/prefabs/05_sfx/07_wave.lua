local assets = {

	Asset("ANIM", "anim/hoshino_sfx_wave.zip"),
}


local function fx()
    local inst = CreateEntity()

    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("hoshino_sfx_wave")
    inst.AnimState:SetBuild("hoshino_sfx_wave")
    inst.AnimState:PlayAnimation("start")
    inst.AnimState:PushAnimation("idle",true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetFinalOffset(1)

    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     target = inst,
        --     color = Vector3(255,255,255),        -- color / colour 都行
        --     MultColour_Flag = false ,        
        --     a = 0.1,
        --     speed = 1,
        --     sound = "",
        --     nosound = false,
        --     scale = 1,
        --     radius = 1,   -- 半径，覆盖scale
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
        ------------------------------------------------------------------------------------------------------------------------------------
        _table.color = _table.color or _table.colour
        if _table.color and _table.color.x then
            if _table.MultColour_Flag ~= true then
                inst:AddComponent("colouradder")
                inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 1)
            else
                inst.AnimState:SetMultColour(_table.color.x,_table.color.y, _table.color.z, _table.a or 1)
            end
        end
        ------------------------------------------------------------------------------------------------------------------------------------
        if not _table.nosound then
            if _table.sound then
                inst.SoundEmitter:PlaySound(_table.sound,"explode")
            end
        end

        if type(_table.speed) == "number" then
            inst.AnimState:SetDeltaTimeMultiplier(_table.speed)
        end

        if type(_table.radius) == "number" then
            -- 默认 半径 800/150 = 5.33333
            local scale_per_radius = 150/800
            local final_scale = _table.radius * scale_per_radius
            inst.AnimState:SetScale(final_scale,final_scale,final_scale)
        elseif type(_table.scale) == "number" then
            inst.AnimState:SetScale(_table.scale,_table.scale,_table.scale)
        end

        if type(_table.remain_time) == "number" then
            inst:DoTaskInTime(_table.remain_time,function()
                inst.SoundEmitter:KillSound("explode")
                inst:Remove()
            end)
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

return Prefab("hoshino_sfx_wave",fx,assets)