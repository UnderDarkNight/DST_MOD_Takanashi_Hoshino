local assets = {
    -- Asset("IMAGE", "images/inventoryimages/spell_reject_the_npc.tex"),
	-- Asset("ATLAS", "images/inventoryimages/spell_reject_the_npc.xml"),
	-- Asset("ANIM", "anim/hoshino_fx_red_bats.zip"),
}
local easing = require("easing")


local function ping_OnUpdateDisc(inst)
	if inst.delta > 0 then
		if inst.alpha < 1 then
			inst.alpha = math.min(1, inst.alpha + inst.delta)
			local a = easing.outQuad(inst.alpha, 0, 1, 1)
			inst.AnimState:SetMultColour(1, 1, 1, a)
		end
	elseif inst.delta < 0 and inst.alpha > 0 then
		inst.alpha = math.max(0, inst.alpha + inst.delta)
		local a = easing.inQuad(inst.alpha, 0, 1, 1)
		inst.AnimState:SetMultColour(1, 1, 1, a)
		if inst.alpha <= 0 then
			inst:Hide()
		end
	end
end

local function ping_CreateDisc()
	local inst = CreateEntity()

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	--[[Non-networked entity]]
	--inst.entity:SetCanSleep(false) --commented out; follow parent sleep instead
	inst.persists = false

	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("deerclops")
	inst.AnimState:SetBuild("deerclops_mutated")
	inst.AnimState:PlayAnimation("target_fx_ring")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetMultColour(1, 1, 1, 0)

	inst:AddComponent("updatelooper")
	inst.components.updatelooper:AddOnUpdateFn(ping_OnUpdateDisc)

	inst.alpha = 0
	inst.delta = 0.1

	return inst
end

local function fx()
    local inst = CreateEntity()

    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetBank("deerclops")
	inst.AnimState:SetBuild("deerclops_mutated")
	inst.AnimState:PlayAnimation("target_fx_pre")
	inst.AnimState:PushAnimation("target_fx",true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetFinalOffset(1)



    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")



    inst.entity:SetPristine()

    inst.__net_radius_scale = net_float(inst.GUID,"net_radius_scale_update","net_radius_scale_update")
	--Dedicated server does not need to spawn the local fx
	if not TheNet:IsDedicated() then
		inst.disc = ping_CreateDisc(inst)
		inst.disc.entity:SetParent(inst.entity)
        inst:ListenForEvent("net_radius_scale_update",function()
            local scale = inst.__net_radius_scale:value()
            inst.disc.AnimState:SetScale(scale,scale,scale)
        end)
	end
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
        --     radius = 1,  --- 半径800pix 。1个距离150pix。覆盖scale
        -- }
        -- 
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
            inst.__net_radius_scale:set(final_scale)
        elseif type(_table.scale) == "number" then
            inst.AnimState:SetScale(_table.scale,_table.scale,_table.scale)
            inst.__net_radius_scale:set(_table.scale)
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

return Prefab("hoshino_sfx_icelance_ping",fx,assets)