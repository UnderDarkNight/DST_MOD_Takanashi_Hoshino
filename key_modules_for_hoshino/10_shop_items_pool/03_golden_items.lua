TUNING.HOSHINO_SHOP_ITEMS_POOL = TUNING.HOSHINO_SHOP_ITEMS_POOL or {}
TUNING.HOSHINO_SHOP_ITEMS_POOL["golden"] = {
-----------------------------------------------------------
--  bandage
{
  prefab = "bandage",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("bandage.tex"), image = "bandage.tex"},
  price = 90, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  bluegem
{
  prefab = "bluegem",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("bluegem.tex"), image = "bluegem.tex"},
  price = 180, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  redgem
{
  prefab = "redgem",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("redgem.tex"), image = "redgem.tex"},
  price = 180, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  purplegem
{
  prefab = "purplegem",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("purplegem.tex"), image = "purplegem.tex"},
  price = 240, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  icestaff
{
  prefab = "icestaff",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("icestaff.tex"), image = "icestaff.tex"},
  price = 300, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  firestaff
{
  prefab = "firestaff",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("firestaff.tex"), image = "firestaff.tex"},
  price = 230, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  telestaff
{
  prefab = "telestaff",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("telestaff.tex"), image = "telestaff.tex"},
  price = 300, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  hermit_pearl
{
  prefab = "hermit_pearl",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("hermit_pearl.tex"), image = "hermit_pearl.tex"},
  price = 1800, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  glommerwings
{
  prefab = "glommerwings",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("glommerwings.tex"), image = "glommerwings.tex"},
  price = 600, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  gelblob_storage_kit
{
  prefab = "gelblob_storage_kit",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("gelblob_storage_kit.tex"), image = "gelblob_storage_kit.tex"},
  price = 450, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  greenstaff
{
  prefab = "greenstaff",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("greenstaff.tex"), image = "greenstaff.tex"},
  price = 750, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  thulecite_pieces
{
  prefab = "thulecite_pieces",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("thulecite_pieces.tex"), image = "thulecite_pieces.tex"},
  price = 60, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  hoshino_item_anti_entropy_crystal_wheel
{
  prefab = "hoshino_item_anti_entropy_crystal_wheel",
  bg = "item_slot_golden.tex",
  icon = {atlas = "images/inventoryimages/hoshino_item_anti_entropy_crystal_wheel.xml", image = "hoshino_item_anti_entropy_crystal_wheel.tex"},
  price = 1200, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  orangestaff
{
  prefab = "orangestaff",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("orangestaff.tex"), image = "orangestaff.tex"},
  price = 600, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  hoshino_food_mandrake_concentrate
{
  prefab = "hoshino_food_mandrake_concentrate",
  bg = "item_slot_golden.tex",
  icon = {atlas = "images/inventoryimages/hoshino_food_mandrake_concentrate.xml", image = "hoshino_food_mandrake_concentrate.tex"},
  price = 1000, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  bomb_lunarplant
{
  prefab = "bomb_lunarplant",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("bomb_lunarplant.tex"), image = "bomb_lunarplant.tex"},
  price = 120, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  security_pulse_cage_full
{
  prefab = "security_pulse_cage_full",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("security_pulse_cage_full.tex"), image = "security_pulse_cage_full.tex"},
  price = 1, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "laplite", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  houndstooth_blowpipe
{
  prefab = "houndstooth_blowpipe",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("houndstooth_blowpipe.tex"), image = "houndstooth_blowpipe.tex"},
  price = 1, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "laplite", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  shadowheart
{
  prefab = "shadowheart",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("shadowheart.tex"), image = "shadowheart.tex"},
  price = 2400, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  moonstorm_static_item
{
  prefab = "moonstorm_static_item",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("moonstorm_static_item.tex"), image = "moonstorm_static_item.tex"},
  price = 1800, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  hoshino_item_cards_pack_authority_to_unveil_secrets
{
  prefab = "hoshino_item_cards_pack_authority_to_unveil_secrets",
  bg = "item_slot_golden.tex",
  icon = {atlas = "images/inventoryimages/hoshino_item_cards_pack_authority_to_unveil_secrets.xml", image = "hoshino_item_cards_pack_authority_to_unveil_secrets.tex"},
  price = 4000, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  hoshino_item_treasure_map
{
  prefab = "hoshino_item_treasure_map",
  bg = "item_slot_golden.tex",
  icon = {atlas = "images/inventoryimages/hoshino_item_treasure_map.xml", image = "hoshino_item_treasure_map.tex"},
  price = 3000, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  hoshino_item_fragments_of_divine_script
{
  prefab = "hoshino_item_fragments_of_divine_script",
  bg = "item_slot_golden.tex",
  icon = {atlas = "images/inventoryimages/hoshino_item_fragments_of_divine_script.xml", image = "hoshino_item_fragments_of_divine_script.tex"},
  price = 2400, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  hoshino_item_ether_essence
{
  prefab = "hoshino_item_ether_essence",
  bg = "item_slot_golden.tex",
  icon = {atlas = "images/inventoryimages/hoshino_item_ether_essence.xml", image = "hoshino_item_ether_essence.tex"},
  price = 4000, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
}
