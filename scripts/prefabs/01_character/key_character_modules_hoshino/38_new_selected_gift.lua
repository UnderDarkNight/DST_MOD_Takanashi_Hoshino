--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    玩家新选择的时候，发送一个礼物

    基于userid 给 TheWorld 和 玩家自身同时上flag

    {description = "基础之理 x1",data = 1},
    {description = "神秘核心 x1",data = 2},
    {description = "神秘核心 x3",data = 3},
    {description = "窥秘权柄 x3",data = 4},
    {description = "最高神秘 x3",data = 5},
    {description = "最高神秘 x10",data = 6},

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local GIFT_TYPE = TUNING["hoshino.Config"].NEW_SPAWN_GIFT_TYPE or 1
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function Get_Data_Index(inst)
        return "new_selected_gift_flag_"..tostring(inst.userid)
    end
    local function Check_Is_New_Selected(inst)
        if TheWorld.components.hoshino_data:Get(Get_Data_Index(inst)) then
            return false
        end
        if inst.components.hoshino_data:Get(Get_Data_Index(inst)) then
            return false
        end
        return true
    end
    local function Set_Flag(inst)
        TheWorld.components.hoshino_data:Set(Get_Data_Index(inst),true)
        inst.components.hoshino_data:Set(Get_Data_Index(inst),true)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function SpawnGiftByType(inst)
        if GIFT_TYPE == 6 then
            for i = 1, 10, 1 do
                local item = SpawnPrefab("hoshino_item_cards_pack")
                item:PushEvent("Type","hoshino_item_cards_pack_supreme_mystery")
                inst.components.inventory:GiveItem(item)
            end
        elseif GIFT_TYPE == 5 then
            for i = 1, 3, 1 do
                local item = SpawnPrefab("hoshino_item_cards_pack")
                item:PushEvent("Type","hoshino_item_cards_pack_supreme_mystery")
                inst.components.inventory:GiveItem(item)
            end
        elseif GIFT_TYPE == 4 then
            for i = 1, 3, 1 do
                local item = SpawnPrefab("hoshino_item_cards_pack")
                item:PushEvent("Type","hoshino_item_cards_pack_authority_to_unveil_secrets")
                inst.components.inventory:GiveItem(item)
            end
        elseif GIFT_TYPE == 3 then
            for i = 1, 3, 1 do
                local item = SpawnPrefab("hoshino_item_cards_pack")
                inst.components.inventory:GiveItem(item)
            end
        elseif GIFT_TYPE == 2 then
            local item = SpawnPrefab("hoshino_item_cards_pack")
            inst.components.inventory:GiveItem(item)
        else
            local item = SpawnPrefab("hoshino_item_cards_pack")
            item:PushEvent("Set",{
                    cards = {
                        "card_white",
                        "card_white",
                        "card_white",
                    },
                }
            )
            item:PushEvent("SetName","基础之理")
            inst.components.inventory:GiveItem(item)
        end                
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:DoTaskInTime(0,function()
        if not Check_Is_New_Selected(inst) then
            Set_Flag(inst) --- 刷一下flag 给 TheWorld 和 玩家自身
            return
        end
        Set_Flag(inst)


        -- --- 初始携带一个只会出白色三选一的卡包（称为【基础之理】）
        -- inst.components.inventory:GiveItem(Create_New_Gift_Pack())
        SpawnGiftByType(inst)


    end)
end