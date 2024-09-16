

TUNING.HOSHINO_SHOP_ITEMS_POOL = TUNING.HOSHINO_SHOP_ITEMS_POOL or {}

TUNING.HOSHINO_SHOP_ITEMS_POOL["gray"] = {
    
    ------------------------------------------------------------------
    --- 示例物品 木头
        {
            prefab = "log",
            -- name = STRINGS.NAMES[string.upper(prefab_name)], --- 自动补全。也可强制下发。
            bg = "item_slot_gray.tex", --- 背景颜色  item_slot_blue.tex  item_slot_colourful.tex  item_slot_golden.tex  item_slot_gray.tex
            icon = {atlas = GetInventoryItemAtlas("log.tex"),image = "log.tex"},
            -- right_click = false,    --- 客户端上传回来标记位。

            price = 100, --- 价格
            num_to_give = 1, --- 单次购买的数量。【注意】nil 自动处理为1。
            price_type = "credit_coins",  -- 货币需求。

            level = 0, --- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
            type = "normal", --- 类型。normal  special  。这个可以不下发。

            -- index = "log_credit_coins_100_1_blue",  --- 自动合并下发，用于相应购买事件，并索引到本参数表。

        },
    ------------------------------------------------------------------



}


-- --- 自动生成index。
-- for bg_type, single_pool in pairs(TUNING.HOSHINO_SHOP_ITEMS_POOL) do    
--     for k, single_item_data in pairs(single_pool) do
--         single_item_data.num_to_give = single_item_data.num_to_give or 1
--         single_item_data.level = single_item_data.level or 0
--         --- index 合并。
--         local index = single_item_data.type .. "_" .. single_item_data.prefab .. "_" .. single_item_data.price_type .. "_" .. single_item_data.price .. "_" .. single_item_data.num_to_give .. "_" .. single_item_data.bg
--         single_item_data.index = index
--     end
-- end
