------------------------------------------------------------------------------------------------------------------------------------------------
--[[

千年战术委托终端 

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---- 
    local assets =
    {
        Asset("ANIM", "anim/cane.zip"),
        Asset("ANIM", "anim/swap_cane.zip"),
    }
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, 1)

        inst.AnimState:SetBank("hoshino_building_nilou_fire")
        inst.AnimState:SetBuild("hoshino_building_nilou_fire")
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

        return inst
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function placer_postinit_fn(inst)
        
    end
------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_building_millennium_tactics_delegate_terminal", fn, assets),
    MakePlacer("hoshino_building_millennium_tactics_delegate_terminal_placer", "hoshino_building_nilou_fire", "hoshino_building_nilou_fire", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil)
