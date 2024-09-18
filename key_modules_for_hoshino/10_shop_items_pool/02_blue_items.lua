TUNING.HOSHINO_SHOP_ITEMS_POOL = TUNING.HOSHINO_SHOP_ITEMS_POOL or {}
TUNING.HOSHINO_SHOP_ITEMS_POOL["blue"] = {
-----------------------------------------------------------
--  log
{
  prefab = "log",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("log.tex"), image = "log.tex"},
  price = 1, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 0, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
},
-----------------------------------------------------------
--  rocks
{
  prefab = "rocks",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("rocks.tex"), image = "rocks.tex"},
  price = 1, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 0, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
},
-----------------------------------------------------------
--  ancientfruit_gem
{
  prefab = "ancientfruit_gem",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("ancientfruit_gem.tex"), image = "ancientfruit_gem.tex"},
  price = 1, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 0, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
},
-----------------------------------------------------------
--  petals_evil
{
  prefab = "petals_evil",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("petals_evil.tex"), image = "petals_evil.tex"},
  price = 2, -- 价格
  num_to_give = 10, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 0, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
},
-----------------------------------------------------------
}
