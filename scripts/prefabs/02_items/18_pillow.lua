----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

“随地入场券”

抱枕，无耐久，不可制作（后面的池子里可以钓出来）。可以随时入睡，使用该抱枕睡觉时cost恢复速度+0.2/s

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------


local assets =
{
    Asset("ANIM", "anim/hoshino_item_pillow.zip"),
}
local function IsWalkButtonDown()
    return TheInput and TheInput:IsControlPressed(CONTROL_MOVE_UP) or TheInput:IsControlPressed(CONTROL_MOVE_DOWN) or TheInput:IsControlPressed(CONTROL_MOVE_LEFT) or TheInput:IsControlPressed(CONTROL_MOVE_RIGHT)
end

local function workable_com_install(inst)
    inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_workable",function(inst,replica_com)
        replica_com:SetTestFn(function(inst,doer,right_click)
            if doer.prefab == "hoshino" and inst.replica.inventoryitem:IsGrandOwner(doer) then
                return true
            end
        end)
        replica_com:SetSGAction("hoshino_sg_bedroll")
        replica_com:SetText("hoshino_item_pillow",STRINGS.ACTIONS.SLEEPIN)
        replica_com:SetPreActionFn(function(inst,doer)
            doer.AnimState:OverrideSymbol("swap_bedroll", "hoshino_item_pillow", "bedroll_straw")
        end)        
    end)
    inst:ListenForEvent("hoshino_item_pillow.player_enter_sleep",function()
        if TheInput and ThePlayer then
                local temp_inst = CreateEntity()
                temp_inst:DoPeriodicTask(FRAMES*5,function()
                    if IsWalkButtonDown() then
                        ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_item_pillow.wake_up_button_down")
                    end
                end)
                temp_inst:ListenForEvent("hoshino_item_pillow.wakeup_pst",function()
                    temp_inst:Remove()
                    if ThePlayer.sg then
                        ThePlayer.sg:GoToState("wakeup")
                    end
                end,ThePlayer)
        end
    end)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddComponent("hoshino_com_workable")
    inst.components.hoshino_com_workable:SetOnWorkFn(function(inst,doer)

        local temp_inst = CreateEntity()
        temp_inst:ListenForEvent("hoshino_item_pillow.wake_up_button_down",function()
            temp_inst:Remove()
            doer.sg:GoToState("wakeup")
            doer.components.hoshino_com_rpc_event:PushEvent("hoshino_item_pillow.wakeup_pst")
        end,doer)
        temp_inst:DoPeriodicTask(FRAMES*10,function()
            if not doer.sg:HasStateTag("hoshino_sg_bedroll") then
                temp_inst:Remove()
            end
        end)
        -- temp_inst:ListenForEvent("newstate",function()            
        -- end,doer)
        temp_inst:ListenForEvent("onremove",function()
            doer:PushEvent("hoshino_event.hoshino_item_pillow.leave")
        end)
        doer:PushEvent("hoshino_event.hoshino_item_pillow.enter")

        doer.components.hoshino_com_rpc_event:PushEvent("hoshino_item_pillow.player_enter_sleep",{},inst)

        temp_inst:DoPeriodicTask(1,function()
            if doer.components.hoshino_com_power_cost then
                doer.components.hoshino_com_power_cost:DoDelta(TUNING.HOSHINO_DEBUGGING_MODE and 1 or 0.2)
            end
        end)
        return true
    end)

end

local function fn(bank, build)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_item_pillow")
    inst.AnimState:SetBuild("hoshino_item_pillow")
    inst.AnimState:PlayAnimation("idle")

    local swap_data = {bank = "hoshino_item_pillow", anim = "idle"}
    MakeInventoryFloatable(inst, "small", 0.2, 0.95, nil, nil, swap_data)


    inst.entity:SetPristine()
    workable_com_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_item_pillow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_pillow.xml"



    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

return Prefab("hoshino_item_pillow", fn, assets)
