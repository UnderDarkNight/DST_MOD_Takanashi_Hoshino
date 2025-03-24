------------------------------------------------------------------------------------------------------------------------------------------------
--[[

千年战术委托终端 

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---- 
    local assets =
    {
        Asset("ANIM", "anim/hoshino_building_millennium_tactics_delegate_terminal.zip"),
    }
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    --- OnBuild
    local function on_build_event(inst,_table)
        inst.AnimState:PlayAnimation("place")
        inst.AnimState:PushAnimation("idle")
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.entity:AddMiniMapEntity()
        inst.MiniMapEntity:SetIcon("hoshino_building_millennium_tactics_delegate_terminal.png")
        inst.MiniMapEntity:SetPriority(6)
        MakeObstaclePhysics(inst, 1)

        inst.AnimState:SetBank("hoshino_building_millennium_tactics_delegate_terminal")
        inst.AnimState:SetBuild("hoshino_building_millennium_tactics_delegate_terminal")
        inst.AnimState:PlayAnimation("idle")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        MakeHauntableLaunch(inst)

        inst:AddComponent("prototyper") ---- 靠近触发科技的交易系统
        -- inst.components.prototyper.onturnon = prototyper_onturnon
        -- inst.components.prototyper.onturnoff = prototyper_onturnoff
        -- inst.components.prototyper.onactivate = prototyper_onactivate
        inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES[string.upper("millennium_tactics_delegate_terminal")]
        inst:ListenForEvent("onbuilt",on_build_event)

        return inst
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function placer_postinit_fn(inst)
        
    end
------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_building_millennium_tactics_delegate_terminal", fn, assets),
    MakePlacer("hoshino_building_millennium_tactics_delegate_terminal_placer", "hoshino_building_millennium_tactics_delegate_terminal", "hoshino_building_millennium_tactics_delegate_terminal", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil)
