--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    玩家新选择的时候，发送一个礼物

    基于userid 给 TheWorld 和 玩家自身同时上flag

]]--
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
    local function Create_New_Gift_Pack()
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
        return item
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


        --- 初始携带一个只会出白色三选一的卡包（称为【基础之理】）
        inst.components.inventory:GiveItem(Create_New_Gift_Pack())



    end)
end