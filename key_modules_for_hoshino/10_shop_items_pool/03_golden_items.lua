TUNING.HOSHINO_SHOP_ITEMS_POOL = TUNING.HOSHINO_SHOP_ITEMS_POOL or {}
TUNING.HOSHINO_SHOP_ITEMS_POOL["golden"] = {
-----------------------------------------------------------
--  thulecite_pieces
{
  prefab = "thulecite_pieces",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("thulecite_pieces.tex"), image = "thulecite_pieces.tex"},
  price = 45, -- 价格
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
--  yellowgem
{
  prefab = "yellowgem",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("yellowgem.tex"), image = "yellowgem.tex"},
  price = 450, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  orangegem
{
  prefab = "orangegem",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("orangegem.tex"), image = "orangegem.tex"},
  price = 390, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  greengem
{
  prefab = "greengem",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("greengem.tex"), image = "greengem.tex"},
  price = 600, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  greengem
{
  prefab = "greengem",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("greengem.tex"), image = "greengem.tex"},
  price = 1, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "laplite", -- 货币需求。
  level = 2, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
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
--  opalstaff
{
  prefab = "opalstaff",
  bg = "item_slot_golden.tex",
  icon = {atlas = GetInventoryItemAtlas("opalstaff.tex"), image = "opalstaff.tex"},
  price = 2, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "laplite", -- 货币需求。
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
  price = 2, -- 价格
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
  price = 2, -- 价格
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
  price = 3600, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
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
  price = 7, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "laplite", -- 货币需求。
  level = 3, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
}
