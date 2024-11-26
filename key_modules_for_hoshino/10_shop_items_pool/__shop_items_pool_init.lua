

TUNING.HOSHINO_SHOP_ITEMS_POOL = TUNING.HOSHINO_SHOP_ITEMS_POOL or {}


modimport("key_modules_for_hoshino/10_shop_items_pool/01_gray_items.lua") 
modimport("key_modules_for_hoshino/10_shop_items_pool/02_blue_items.lua") 
modimport("key_modules_for_hoshino/10_shop_items_pool/03_golden_items.lua") 
modimport("key_modules_for_hoshino/10_shop_items_pool/04_colourful_items.lua") 



--- 自动生成index。
for bg_type, single_pool in pairs(TUNING.HOSHINO_SHOP_ITEMS_POOL) do    
    for k, single_item_data in pairs(single_pool) do
        single_item_data.num_to_give = single_item_data.num_to_give or 1
        single_item_data.level = single_item_data.level or 0
        --- 常驻标记位
        local is_permanent = single_item_data.is_permanent or false
        if is_permanent then
            is_permanent = "permanent"
        else
            is_permanent = ""
        end
        --- index 合并。
        local index = single_item_data.type .. "_" .. single_item_data.prefab .. "_" .. single_item_data.price_type .. "_" .. single_item_data.price .. "_" .. single_item_data.num_to_give .. "_" .. bg_type.."_"..is_permanent
        single_item_data.index = index
    end
end


modimport("key_modules_for_hoshino/10_shop_items_pool/05_recycle_items.lua") 
--- 商品回收列表。

modimport("key_modules_for_hoshino/10_shop_items_pool/06_shiba_seki_ramen_cart_pool.lua") 
--- 拉面店商品列表
