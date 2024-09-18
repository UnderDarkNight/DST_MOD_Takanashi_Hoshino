--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function GetStackNum(item)
    if item.components.stackable then
        return item.components.stackable:StackSize()
    else
        return 1
    end
end

local function GetPriceByPrefab(prefab)
    local price = TUNING.HOSHINO_SHOP_ITEMS_RECYCLE_LIST[prefab]
    if price == nil then
        price = TUNING.HOSHINO_SHOP_ITEMS_RECYCLE_LIST["default"]
    end
    return price
end

return function(inst)
    
    ----------------------------------------------------------------------------------------
    --- 下发数据给客户端
        local function refresh_client_side_widget(recycle_coins)
            local openers = inst.components.container:GetOpeners()
            local doer = openers[1]
            if doer and doer.components.hoshino_com_shop then
                doer.components.hoshino_com_shop:RecycleCoinsRefresh(recycle_coins)
            end
        end
    ----------------------------------------------------------------------------------------
    --- 计算回收价格
        local function recycle_coins_count()        
            local coins = 0
            inst.components.container:ForEachItem(function(item)
                if item and item.prefab then
                    local price = GetPriceByPrefab(item.prefab)
                    local num = GetStackNum(item)
                    coins = coins + price * num
                end
            end)
            return coins
        end
    ----------------------------------------------------------------------------------------
    --- 执行回收计价
        local task = nil
        inst:ListenForEvent("start_recycle_count", function()
            if task then
                return
            end
            task = inst:DoTaskInTime(0, function()
                task = nil
                local coins = recycle_coins_count()
                refresh_client_side_widget(coins)
            end)
        end)
    ----------------------------------------------------------------------------------------
    --- 关闭的时候，把东西还给玩家。
        inst:ListenForEvent("onclose", function(inst,_table)
            local doer = _table and _table.doer or nil
            refresh_client_side_widget(0)

            inst.components.container:DropEverything()            
        end)
    ----------------------------------------------------------------------------------------
    ---- 刷新事件
        local events = {
            ["itemlose"] = true,
            ["dropitem"] = true,
            ["itemget"] = true,
            ["onopen"] = true,
        }
        for event, v in pairs(events) do
            inst:ListenForEvent(event, function()
                inst:PushEvent("start_recycle_count")
            end)
        end
    ----------------------------------------------------------------------------------------
    --- 回收按钮点击后执行。
        inst:ListenForEvent("recycle_button_clicked", function(inst,_table)
            local doer = _table and _table.doer or nil
            print("recycle_button_clicked",inst,doer)
            if doer and doer.components.hoshino_com_shop then
                local coins = recycle_coins_count()
                if coins > 0 then
                    doer.components.hoshino_com_shop:CreditCoinDelta(coins,true)
                    inst.components.container:ForEachItem(function(item)
                        if item and item.prefab then
                            item:Remove()
                        end
                    end)
                end
                doer.components.hoshino_com_shop:RecycleCoinsRefresh(0)
            else
                print("recycle_button_clicked  empty",doer)
            end
        end)
    ----------------------------------------------------------------------------------------
    --- 绑定给回收系统的按钮点击事件。
        inst:ListenForEvent("onopen", function(inst,_table)
            local doer = _table and _table.doer or nil
            if doer and doer.components.hoshino_com_shop then
                doer.components.hoshino_com_shop:SetRecycleBuilding(inst)
            end
        end)
        inst:ListenForEvent("onclose", function(inst,_table)
            local doer = _table and _table.doer or nil
            if doer and doer.components.hoshino_com_shop then
                doer.components.hoshino_com_shop:SetRecycleBuilding(nil)
            end
        end)
    ----------------------------------------------------------------------------------------


end