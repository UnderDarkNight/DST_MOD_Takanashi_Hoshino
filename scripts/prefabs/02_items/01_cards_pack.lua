------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    卡牌包。

    数据缺省：直接启用默认卡组生成。

    item:PushEvent("SetName","卡包名字")

    数据结构和用法
        item:PushEvent("Set",{
            cards = {
                "card_golden",
                "card_white",
                "card_colourful",
                "card_colourful",
                "card_golden",
            },
            force_result_index = nil, --- 强制赋予开卡结果
        })

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
    local assets =
    {
        Asset("ANIM", "anim/hoshino_item_cards_pack.zip"),
    }
------------------------------------------------------------------------------------------------------------------------------------------------
--- RPC 等辅助 函数
    local function GetRPC(doer)
        return doer.components.hoshino_com_rpc_event
    end
    local function Force_Open_Client_Side_Cards_Select_Box(doer) --- 强制下发界面打开命令
        GetRPC(doer):PushEvent("hoshino_event.pad_data_update",{
            default_page = "level_up",
        })
        doer:DoTaskInTime(0.5,function()
            GetRPC(doer):PushEvent("hoshino_event.inspect_pad_open_by_force")
        end)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- workable 安装
    local function workable_replica_fn(inst,replica_com)
        replica_com:SetText("hoshino_item_cards_pack",STRINGS.ACTIONS.REMOTE_TELEPORT.GENERIC)
        replica_com:SetSGAction("give")
        replica_com:SetTestFn(function(inst,doer,right_click)
            return doer:HasTag("hoshino") and inst.replica.inventoryitem:IsGrandOwner(doer)    --- 在背包里才能使用 
        end)
    end
    local function workable_active_fn(inst,doer)
        local CardsData = inst.components.hoshino_data:Get("CardsData")
        --------------------------------------------------------------------------
        --- 检查是否有等待开的卡包
            if doer.components.hoshino_cards_sys:IsCardsSelectting() then
                Force_Open_Client_Side_Cards_Select_Box(doer)
                return false
            end
        --------------------------------------------------------------------------
        --- 空数据的时候，按照默认卡组生成
            if CardsData == nil or CardsData.cards == nil then
                doer.components.hoshino_cards_sys:CreateCardsByPool_Default()
                Force_Open_Client_Side_Cards_Select_Box(doer)
                inst:Remove()
                return true
            end
        --------------------------------------------------------------------------
        --- 非空的时候，下发卡牌数据
            local cards = CardsData.cards
            doer.components.hoshino_cards_sys:CreateCardsByForceCMD(cards)
            doer.components.hoshino_cards_sys:SetForceCardResult(CardsData.force_result_index)  -- 强制结果
            inst:Remove()
        --------------------------------------------------------------------------
        return true
    end
    local function workable_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_workable",workable_replica_fn)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_workable")
        inst.components.hoshino_com_workable:SetOnWorkFn(workable_active_fn)
    end
------------------------------------------------------------------------------------------------------------------------------------------------


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_item_cards_pack")
    inst.AnimState:SetBuild("hoshino_item_cards_pack")
    inst.AnimState:PlayAnimation("idle")

    -- inst:AddTag("weapon")


    MakeInventoryFloatable(inst)


    inst.entity:SetPristine()
    workable_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("tillweedsalve")
    inst.components.inventoryitem.imagename = "hoshino_item_cards_pack"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_cards_pack.xml"

    inst:AddComponent("hoshino_data")

    -------------------------------------------------------------------------
    --- 名字
        inst:AddComponent("named")
        inst.components.hoshino_data:AddOnLoadFn(function()
            local saved_name = inst.components.hoshino_data:Get("name")
            if saved_name then
                inst.components.named:SetName(saved_name)
            end
        end)
        -- inst.components.hoshino_data:AddOnSaveFn(function()            
        -- end)
        inst:ListenForEvent("SetName",function(inst,name)
            inst.components.named:SetName(name)
            inst.components.hoshino_data:Set("name",name)
        end)
    -------------------------------------------------------------------------
    --- 卡组参数
        inst:ListenForEvent("Set",function(inst,data)
            inst.components.hoshino_data:Set("CardsData",data)
        end)
    -------------------------------------------------------------------------

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("hoshino_item_cards_pack", fn, assets)
