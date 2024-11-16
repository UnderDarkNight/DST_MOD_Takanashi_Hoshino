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
            },
        })

    设置外观
        item:PushEvent("SetDisplay",{
            bank = "hoshino_item_cards_pack_authority_to_unveil_secrets",
            build = "hoshino_item_cards_pack_authority_to_unveil_secrets",
            anim = "idle",
            imagename = "hoshino_item_cards_pack",
            atlasname = "images/inventoryimages/hoshino_item_cards_pack.xml",
        })

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
    local assets =
    {
        Asset("ANIM", "anim/hoshino_item_cards_pack.zip"),
        Asset("ANIM", "anim/hoshino_item_cards_pack_supreme_mystery.zip"),
        Asset("ANIM", "anim/hoshino_item_cards_pack_authority_to_unveil_secrets.zip"),
    }
------------------------------------------------------------------------------------------------------------------------------------------------
--- RPC 等辅助 函数
    local function GetRPC(doer)
        return doer.components.hoshino_com_rpc_event
    end
    local function Force_Open_Client_Side_Cards_Select_Box(doer) --- 强制下发界面打开命令
        doer:DoTaskInTime(0.5,function()
            GetRPC(doer):PushEvent("hoshino_event.inspect_pad_open_by_force")
        end)
        doer.components.hoshino_cards_sys:SendInspectWarning()  
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
            Force_Open_Client_Side_Cards_Select_Box(doer)
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
--- 设置外观
    local function SetDisplay(inst,data)
        local bank = data.bank
        local build = data.build
        local anim = data.anim
        local imagename = data.imagename
        local atlasname = data.atlasname
        if bank and build and anim and imagename and atlasname then
            inst.AnimState:SetBank(bank)
            inst.AnimState:SetBuild(build)
            inst.AnimState:PlayAnimation(anim)
            inst.components.inventoryitem.imagename = imagename
            inst.components.inventoryitem.atlasname = atlasname
        end
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 预设外观
    local function Custom_Type_Event_Install(inst)
        inst:ListenForEvent("Type",function(inst,pack_type)
            if pack_type == "hoshino_item_cards_pack_authority_to_unveil_secrets" then
                inst:PushEvent("SetName","窥秘权柄") -- 金色
                inst:PushEvent("Set",{
                        cards = {
                            "card_golden",
                            "card_golden",
                            "card_golden",
                        },
                    }
                )
                inst:PushEvent("SetDisplay",{
                    bank = "hoshino_item_cards_pack_authority_to_unveil_secrets",
                    build = "hoshino_item_cards_pack_authority_to_unveil_secrets",
                    anim = "idle",
                    imagename = "hoshino_item_cards_pack_authority_to_unveil_secrets",
                    atlasname = "images/inventoryimages/hoshino_item_cards_pack_authority_to_unveil_secrets.xml",
                })
            elseif pack_type == "hoshino_item_cards_pack_supreme_mystery" then
                inst:PushEvent("SetName","最高神秘") -- 彩色
                inst:PushEvent("Set",{
                        cards = {
                            "card_colourful",
                            "card_colourful",
                            "card_colourful",
                        },
                    }
                )
                inst:PushEvent("SetDisplay",{
                    bank = "hoshino_item_cards_pack_supreme_mystery",
                    build = "hoshino_item_cards_pack_supreme_mystery",
                    anim = "idle",
                    imagename = "hoshino_item_cards_pack_supreme_mystery",
                    atlasname = "images/inventoryimages/hoshino_item_cards_pack_supreme_mystery.xml",
                })
            end
        end)
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
    --- 设置外观
        inst:ListenForEvent("SetDisplay",function(inst,data)
            inst.components.hoshino_data:Set("display_data",data)
            SetDisplay(inst,data)
        end)
        inst.components.hoshino_data:AddOnLoadFn(function()
            local display_data = inst.components.hoshino_data:Get("display_data") or {}
            SetDisplay(inst,display_data)
        end)
    -------------------------------------------------------------------------
    -- 自定义预设外观
        Custom_Type_Event_Install(inst)
    -------------------------------------------------------------------------

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("hoshino_item_cards_pack", fn, assets)
