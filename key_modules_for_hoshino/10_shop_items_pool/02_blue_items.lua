TUNING.HOSHINO_SHOP_ITEMS_POOL = TUNING.HOSHINO_SHOP_ITEMS_POOL or {}
TUNING.HOSHINO_SHOP_ITEMS_POOL["blue"] = {
-----------------------------------------------------------
--  goldnugget
{
  prefab = "goldnugget",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("goldnugget.tex"), image = "goldnugget.tex"},
  price = 45, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  livinglog
{
  prefab = "livinglog",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("livinglog.tex"), image = "livinglog.tex"},
  price = 75, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  marble
{
  prefab = "marble",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("marble.tex"), image = "marble.tex"},
  price = 54, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  moonglass
{
  prefab = "moonglass",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("moonglass.tex"), image = "moonglass.tex"},
  price = 30, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  pigskin
{
  prefab = "pigskin",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("pigskin.tex"), image = "pigskin.tex"},
  price = 30, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  manrabbit_tail
{
  prefab = "manrabbit_tail",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("manrabbit_tail.tex"), image = "manrabbit_tail.tex"},
  price = 42, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  moonrocknugget
{
  prefab = "moonrocknugget",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("moonrocknugget.tex"), image = "moonrocknugget.tex"},
  price = 45, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  gears
{
  prefab = "gears",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("gears.tex"), image = "gears.tex"},
  price = 120, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "normal", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  malbatross_beak
{
  prefab = "malbatross_beak",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("malbatross_beak.tex"), image = "malbatross_beak.tex"},
  price = 105, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  malbatross_feather
{
  prefab = "malbatross_feather",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("malbatross_feather.tex"), image = "malbatross_feather.tex"},
  price = 60, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  minotaurhorn
{
  prefab = "minotaurhorn",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("minotaurhorn.tex"), image = "minotaurhorn.tex"},
  price = 240, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  panflute
{
  prefab = "panflute",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("panflute.tex"), image = "panflute.tex"},
  price = 180, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  mandrake
{
  prefab = "mandrake",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("mandrake.tex"), image = "mandrake.tex"},
  price = 150, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  walrus_tusk
{
  prefab = "walrus_tusk",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("walrus_tusk.tex"), image = "walrus_tusk.tex"},
  price = 210, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  bearger_fur
{
  prefab = "bearger_fur",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("bearger_fur.tex"), image = "bearger_fur.tex"},
  price = 600, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  deerclops_eyeball
{
  prefab = "deerclops_eyeball",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("deerclops_eyeball.tex"), image = "deerclops_eyeball.tex"},
  price = 600, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  shroom_skin
{
  prefab = "shroom_skin",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("shroom_skin.tex"), image = "shroom_skin.tex"},
  price = 200, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  dragon_scales
{
  prefab = "dragon_scales",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("dragon_scales.tex"), image = "dragon_scales.tex"},
  price = 600, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  yellowamulet
{
  prefab = "yellowamulet",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("yellowamulet.tex"), image = "yellowamulet.tex"},
  price = 540, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  yellowstaff
{
  prefab = "yellowstaff",
  bg = "item_slot_blue.tex",
  icon = {atlas = GetInventoryItemAtlas("yellowstaff.tex"), image = "yellowstaff.tex"},
  price = 600, -- 价格
  num_to_give = 1, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 1, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = false, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
--  hoshino_item_abydos_high_purity_alloy
{
  prefab = "hoshino_item_abydos_high_purity_alloy",
  bg = "item_slot_blue.tex",
  icon = {atlas = "images/inventoryimages/hoshino_item_abydos_high_purity_alloy.xml", image = "hoshino_item_abydos_high_purity_alloy.tex"},
  price = 2, -- 价格
  num_to_give = 0, -- 单次购买的数量。【注意】nil 自动处理为1。
  price_type = "credit_coins", -- 货币需求。
  level = 0, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
  type = "special", -- 类型。normal special 。这个可以不下发。
  is_permanent = true, -- 是否永久。0 非永久 1 永久
},
-----------------------------------------------------------
}
