--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{


}
------------------------------------------------------------------------------------------------------------------------------------------------
local function workable_com_install(inst)
    inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_workable",function(inst,replica_com)
        replica_com:SetTestFn(function(inst,doer,right_click)
            return true
        end)
        replica_com:SetSGAction("dolongaction")
        replica_com:SetText("hoshino_other_cards_debugger","激活")
    end)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddComponent("hoshino_com_workable")
    inst.components.hoshino_com_workable:SetOnWorkFn(function(inst,doer)            
        inst:Remove()
        return true
    end)

end
------------------------------------------------------------------------------------------------------------------------------------------------
local function common_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cane")
    inst.AnimState:SetBuild("swap_cane")
    inst.AnimState:PlayAnimation("idle")

    -- inst:AddTag("weapon")
    -- inst:AddTag("hoshino_special_equipment")

    -- MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    ---------------------------------------------------------------------
    --- 
        inst:AddComponent("inspectable")
    ---------------------------------------------------------------------
    ---
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem:ChangeImageName("tillweedsalve")
        -- inst.components.inventoryitem.imagename = "hoshino_equipment_excample_shoes"
        -- inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_excample_shoes.xml"
    ---------------------------------------------------------------------

    return inst
end

local function refresh_fn()
    local inst = common_fn()
    workable_com_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.hoshino_com_workable:SetOnWorkFn(function(inst,doer)
        if doer.components.hoshino_com_shop.refresh_count_daily < 100 then
            doer.components.hoshino_com_shop:RefreshDaily_Delta(100)
        end
        doer.components.hoshino_com_shop:Refresh_Delta(100)
        return true
    end)

    return inst
end
local function coins_fn()
    local inst = common_fn()
    workable_com_install(inst)

    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.hoshino_com_workable:SetOnWorkFn(function(inst,doer)
        doer.components.hoshino_com_shop:CreditCoinDelta(100)
        return true
    end)

    return inst
end


return Prefab("hoshino_other_shop_debugger_refresh", refresh_fn, assets)
    ,Prefab("hoshino_other_shop_debugger_coins", coins_fn, assets)
