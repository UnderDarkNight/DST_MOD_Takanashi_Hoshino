local assets = {
    -- Asset("IMAGE", "images/inventoryimages/spell_reject_the_npc.tex"),
	-- Asset("ATLAS", "images/inventoryimages/spell_reject_the_npc.xml"),
	-- Asset("ANIM", "anim/npc_fx_chat_bubble.zip"),
}


local function fx()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")      --- 不可点击
    inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
    inst:AddTag("NOBLOCK")      -- 不会影响种植和放置

    inst.AnimState:SetBank("warg_mutated_breath_fx")
	inst.AnimState:SetBuild("warg_mutated_breath_fx")
	-- inst.AnimState:PlayAnimation("flame1_pre")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetLightOverride(0.1)

    -- inst:ListenForEvent("animover", inst.Remove)
    -- inst:ListenForEvent("animqueueover", inst.Remove)

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",function(_,_table)
        -- _table = {
        --     target = inst,
        --     pt = Vector3(0,0,0),
        --     scale = Vector3(0,0,0)
        --     color = Vector3(255,255,255),
        --     a = 0.1,
        --     MultColour_Flag = false,
        --     type = 1,
        --     time = 1,
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

        if _table.scale then
            if type(_table.scale) == "table" then
                inst.AnimState:SetScale(_table.scale.x, _table.scale.y, _table.scale.z)
            elseif type(_table.scale) == "number" then
                inst.AnimState:SetScale(_table.scale, _table.scale, _table.scale)
            end                    
        end

        _table.color = _table.color or _table.colour
        if _table.color and _table.color.x then
            if _table.MultColour_Flag ~= true then
                inst:AddComponent("colouradder")
                inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 1)
            else
                inst.AnimState:SetMultColour(_table.color.x,_table.color.y, _table.color.z, _table.a or 1)
            end
        end

        local flame_type = _table.type or 1  -- flame1_pre  flame2_loop flame1_pst
        if flame_type > 3 then
            flame_type = 3
        end

        if _table.time == nil then
            inst.AnimState:PlayAnimation("flame"..flame_type.."_pre")
            inst.AnimState:PushAnimation("flame"..flame_type.."_loop")
            inst.AnimState:PushAnimation("flame"..flame_type.."_pst",false)
            inst:ListenForEvent("animqueueover",inst.Remove)
        else
            inst.AnimState:PlayAnimation("flame"..flame_type.."_pre")
            inst.AnimState:PushAnimation("flame"..flame_type.."_loop",true)
            inst:DoTaskInTime(_table.time,function()
                inst.AnimState:PlayAnimation("flame"..flame_type.."_pst",false)
                inst:ListenForEvent("animover",inst.Remove)
            end)
        end
        inst.Ready = true
    end)
    inst:DoTaskInTime(0,function()
        if not inst.Ready then
            inst:Remove()
        end
    end)

    return inst
end

return Prefab("hoshino_fx_spell_flame",fx,assets)