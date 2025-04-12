------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
------------------------------------------------------------------------------------------------------------------------------------
---
------------------------------------------------------------------------------------------------------------------------------------
---
    local assets = {
        Asset("ANIM", "anim/hoshino_fx_mawofthevoid.zip"),

    }
------------------------------------------------------------------------------------------------------------------------------------
---
    local function anim_play(inst)
        inst.AnimState:PlayAnimation("start")
        inst.AnimState:PushAnimation("loop")
        inst.AnimState:PushAnimation("end",false)
    end
------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function fx()
        local inst = CreateEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("INLIMBO")
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        inst:AddTag("hoshino_fx_mawofthevoid")

        inst.AnimState:SetBank("hoshino_fx_mawofthevoid")
        inst.AnimState:SetBuild("hoshino_fx_mawofthevoid")
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround) --设置贴地
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        anim_play(inst)
        inst:ListenForEvent("animqueueover",anim_play)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
        -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
        inst:ListenForEvent("Set",function(inst,_table)
            -- _table = {
            --     target = inst,
            --     scale = 1,
            --     speed = 1,
            --     height = 1
            -- }

            if _table == nil or _table.target == nil then
                return
            end
            ------------------------------------------------------------------------------------------------------------------------------------
            ---
                _table.target:AddChild(inst)
                
            ------------------------------------------------------------------------------------------------------------------------------------
            --- 
                local scale = _table.scale or 2
                inst.AnimState:SetScale(scale,scale,scale)

                local speed = _table.speed or 1
                inst.AnimState:SetDeltaTimeMultiplier(speed)

                local height = _table.height or 0
                inst.Transform:SetPosition(0,height,0)
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
------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_fx_mawofthevoid", fx, assets)