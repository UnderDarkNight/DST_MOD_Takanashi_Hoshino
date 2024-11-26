--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    每次刷新有30%令其中一个八折吧

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function GetList()
        local temp_list = TUNING.HOSHINO_SHIBA_SEKI_RAMEN_CART_ITEM_POOL or {}
        local ret_list = {}
        for prefab, price in pairs(temp_list) do
            if prefab and price and PrefabExists(prefab) then
                table.insert(ret_list,prefab)
            end
        end

        if #ret_list < 6 then
            ret_list = {"butterflymuffin","honeyham","jammypreserves","flowersalad","hotchili","bananajuice"}
        end
        return deepcopy(ret_list)
    end
    local function Get_3_Item_Prefab()
        --- 获取不重复的3个
        local list = GetList()
        local ret = {}
        for i = 1, 3 do
            local index = math.random(#list)
            table.insert(ret,list[index])
            table.remove(list,index)
        end
        return ret
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    -- local slots = {["left"] = true,["mid"] = true,["right"] = true,}
    local slots_index = {"left", "mid", "right"}
    local function Spawn_New_Items(inst)
        local item_prefabs = Get_3_Item_Prefab()
        local on_sale_slot = nil
        if math.random(1000)/1000 or TUNING.HOSHINO_DEBUGGING_MODE then
            on_sale_slot = math.random(3)
        end
        for i = 1, 3, 1 do
            local prefab = item_prefabs[i]
            local slot = slots_index[i]
            if PrefabExists(prefab) then
                local item = SpawnPrefab(prefab)
                inst:SetItem(item,slot,on_sale_slot == i)
            else
                inst:ClearItem(slot)
            end
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 物品购买
    local function item_buy_event(inst,_table)
        local slot = _table and _table.slot or "left"
        local userid = _table and _table.userid
        
        local player = nil
        for k, v in pairs(AllPlayers) do
            if userid and v.userid == userid then
                player = v
                break
            end
        end
        if player == nil then
            return
        end

        local item = inst:GetItem(slot)
        local item_prefab = nil
        if item and item:IsValid() and item.prefab then
            item_prefab = item.prefab
        end

        if item_prefab == nil then
            return
        end

        local price = inst:GetPrice(item)

        if player.components.hoshino_com_shop:GetCreditCoins() < price then            
            return
        end

        player.components.hoshino_com_shop:CreditCoinDelta(-price)
        player.components.inventory:GiveItem(SpawnPrefab(item_prefab))
        inst:ClearItem(slot)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    
    ----------------------------------------------------------
    --- 初始化
        inst:DoTaskInTime(1,function()
            if not inst.components.hoshino_data:Get("inited") then
                inst.components.hoshino_data:Set("inited",true)
                Spawn_New_Items(inst)
            end
        end)
    ----------------------------------------------------------
    --- 
        inst:WatchWorldState("cycles",Spawn_New_Items)
    ----------------------------------------------------------
    ---
        inst:ListenForEvent("item_buy",item_buy_event)
    ----------------------------------------------------------

end