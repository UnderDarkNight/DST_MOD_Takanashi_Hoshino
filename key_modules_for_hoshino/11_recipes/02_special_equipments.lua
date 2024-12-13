


-- --------------------------------------------------------------------------------------------------------------------------------------------
-- ---- 清除护符
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- AddRecipeToFilter("hoshino_special_equipment_amulet_clear","CHARACTER")     ---- 添加物品到目标标签
-- AddRecipe2(
--     "hoshino_special_equipment_amulet_clear",            --  --  inst.prefab  实体名字
--     {} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
--     TECH.NONE, --- 魔法三本
--     {
--         -- nounlock=true,
--         no_deconstruction=false,
--         builder_tag = "hoshino",    
--         atlas = "images/inventoryimages/hoshino_special_equipment_amulet_clear.xml",
--         image = "hoshino_special_equipment_amulet_clear.tex",
--     },
--     {"CHARACTER",}
-- )
-- RemoveRecipeFromFilter("hoshino_special_equipment_amulet_clear","MODS")                       -- -- 在【模组物品】标签里移除这个。
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- ---- 清除背包
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- AddRecipeToFilter("hoshino_special_equipment_backpack_clear","CHARACTER")     ---- 添加物品到目标标签
-- AddRecipe2(
--     "hoshino_special_equipment_backpack_clear",            --  --  inst.prefab  实体名字
--     {} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
--     TECH.NONE, --- 魔法三本
--     {
--         -- nounlock=true,
--         no_deconstruction=false,
--         builder_tag = "hoshino",    
--         atlas = "images/inventoryimages/hoshino_special_equipment_backpack_clear.xml",
--         image = "hoshino_special_equipment_backpack_clear.tex",
--     },
--     {"CHARACTER",}
-- )
-- RemoveRecipeFromFilter("hoshino_special_equipment_backpack_clear","MODS")                       -- -- 在【模组物品】标签里移除这个。

-- --------------------------------------------------------------------------------------------------------------------------------------------
-- ---- 清除鞋子
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- AddRecipeToFilter("hoshino_special_equipment_shoes_clear","CHARACTER")     ---- 添加物品到目标标签
-- AddRecipe2(
--     "hoshino_special_equipment_shoes_clear",            --  --  inst.prefab  实体名字
--     {} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
--     TECH.NONE, --- 魔法三本
--     {
--         -- nounlock=true,
--         no_deconstruction=false,
--         builder_tag = "hoshino",    
--         atlas = "images/inventoryimages/hoshino_special_equipment_shoes_clear.xml",
--         image = "hoshino_special_equipment_shoes_clear.tex",
--     },
--     {"CHARACTER",}
-- )
-- RemoveRecipeFromFilter("hoshino_special_equipment_shoes_clear","MODS")                       -- -- 在【模组物品】标签里移除这个。
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------
---- T1: 粉色休闲鞋 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_shoes_t1","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_shoes_t1",            --  --  inst.prefab  实体名字
    {Ingredient("feather_robin", 2),Ingredient("rope", 2),Ingredient("froglegs", 5)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_shoes_t0",    
        atlas = "images/inventoryimages/hoshino_special_equipment_shoes_t1.xml",
        image = "hoshino_special_equipment_shoes_t1.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_shoes_t1","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_shoes_t2","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_shoes_t2",            --  --  inst.prefab  实体名字
    {Ingredient("beefalowool", 6),Ingredient("pigskin", 3),Ingredient("coontail", 3)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_shoes_t1",    
        atlas = "images/inventoryimages/hoshino_special_equipment_shoes_t2.xml",
        image = "hoshino_special_equipment_shoes_t2.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_shoes_t2","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_shoes_t3","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_shoes_t3",            --  --  inst.prefab  实体名字
    {Ingredient("lightninggoathorn", 2),Ingredient("tentaclespots", 3),Ingredient("redgem", 2)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_shoes_t2",    
        atlas = "images/inventoryimages/hoshino_special_equipment_shoes_t3.xml",
        image = "hoshino_special_equipment_shoes_t3.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_shoes_t3","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_shoes_t4","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_shoes_t4",            --  --  inst.prefab  实体名字
    {Ingredient("pigskin", 3),Ingredient("orangegem", 2),Ingredient("dragon_scales", 1)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_shoes_t3",    
        atlas = "images/inventoryimages/hoshino_special_equipment_shoes_t4.xml",
        image = "hoshino_special_equipment_shoes_t4.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_shoes_t4","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_shoes_t5","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_shoes_t5",            --  --  inst.prefab  实体名字
    {Ingredient("opalpreciousgem", 1),Ingredient("nightmare_timepiece", 1),Ingredient("nightmarefuel", 20)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_shoes_t4",    
        atlas = "images/inventoryimages/hoshino_special_equipment_shoes_t5.xml",
        image = "hoshino_special_equipment_shoes_t5.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_shoes_t5","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_shoes_t6","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_shoes_t6",            --  --  inst.prefab  实体名字
    {Ingredient("dreadstone", 4),Ingredient("papyrus", 3),Ingredient("nightmarefuel", 15)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_shoes_t5",    
        atlas = "images/inventoryimages/hoshino_special_equipment_shoes_t6.xml",
        image = "hoshino_special_equipment_shoes_t6.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_shoes_t6","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_shoes_t7","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_shoes_t7",            --  --  inst.prefab  实体名字
    {Ingredient("hoshino_item_blue_schist", 1),Ingredient("bearger_fur", 1),Ingredient("shadowheart", 2)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_shoes_t6",    
        atlas = "images/inventoryimages/hoshino_special_equipment_shoes_t7.xml",
        image = "hoshino_special_equipment_shoes_t7.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_shoes_t7","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_shoes_t8","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_shoes_t8",            --  --  inst.prefab  实体名字
    {Ingredient("hoshino_item_travel_traces", 1),Ingredient("alterguardianhatshard", 1),Ingredient("deerclops_eyeball", 1)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_shoes_t7",    
        atlas = "images/inventoryimages/hoshino_special_equipment_shoes_t8.xml",
        image = "hoshino_special_equipment_shoes_t8.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_shoes_t8","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_shoes_t9","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_shoes_t9",            --  --  inst.prefab  实体名字
    {Ingredient("hoshino_item_blue_schist", 3),Ingredient("purebrilliance", 9),Ingredient("alterguardianhatshard", 1)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_shoes_t8",    
        atlas = "images/inventoryimages/hoshino_special_equipment_shoes_t9.xml",
        image = "hoshino_special_equipment_shoes_t9.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_shoes_t9","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_backpack_t1","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_backpack_t1",            --  --  inst.prefab  实体名字
    {Ingredient("tentaclespots", 2),Ingredient("rope", 2),Ingredient("boards", 2)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_backpack_t0",    
        atlas = "images/inventoryimages/hoshino_special_equipment_backpack_t1.xml",
        image = "hoshino_special_equipment_backpack_t1.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_backpack_t1","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_backpack_t2","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_backpack_t2",            --  --  inst.prefab  实体名字
    {Ingredient("livinglog", 3),Ingredient("boards", 3),Ingredient("reviver", 1)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_backpack_t1",    
        atlas = "images/inventoryimages/hoshino_special_equipment_backpack_t2.xml",
        image = "hoshino_special_equipment_backpack_t2.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_backpack_t2","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_backpack_t3","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_backpack_t3",            --  --  inst.prefab  实体名字
    {Ingredient("feather_robin_winter", 6),Ingredient("driftwood_log", 3),Ingredient("silk", 10)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_backpack_t2",    
        atlas = "images/inventoryimages/hoshino_special_equipment_backpack_t3.xml",
        image = "hoshino_special_equipment_backpack_t3.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_backpack_t3","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_backpack_t4","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_backpack_t4",            --  --  inst.prefab  实体名字
    {Ingredient("armorruins", 1),Ingredient("armormarble", 1),Ingredient("armor_sanity", 1)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_backpack_t3",    
        atlas = "images/inventoryimages/hoshino_special_equipment_backpack_t4.xml",
        image = "hoshino_special_equipment_backpack_t4.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_backpack_t4","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_backpack_t5","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_backpack_t5",            --  --  inst.prefab  实体名字
    {Ingredient("shroom_skin", 3),Ingredient("eyemaskhat", 1),Ingredient("moonglass", 10)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_backpack_t4",    
        atlas = "images/inventoryimages/hoshino_special_equipment_backpack_t5.xml",
        image = "hoshino_special_equipment_backpack_t5.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_backpack_t5","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_backpack_t6","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_backpack_t6",            --  --  inst.prefab  实体名字
    {Ingredient("shadowheart", 1),Ingredient("armorskeleton", 1),Ingredient("nightmarefuel", 30)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_backpack_t5",    
        atlas = "images/inventoryimages/hoshino_special_equipment_backpack_t6.xml",
        image = "hoshino_special_equipment_backpack_t6.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_backpack_t6","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_backpack_t7","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_backpack_t7",            --  --  inst.prefab  实体名字
    {Ingredient("minotaurhorn", 2),Ingredient("hoshino_item_blue_schist", 1),Ingredient("hermit_cracked_pearl", 1)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_backpack_t6",    
        atlas = "images/inventoryimages/hoshino_special_equipment_backpack_t7.xml",
        image = "hoshino_special_equipment_backpack_t7.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_backpack_t7","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_backpack_t8","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_backpack_t8",            --  --  inst.prefab  实体名字
    {Ingredient("butterflywings", 99),Ingredient("moonbutterflywings", 99),Ingredient("hoshino_item_travel_traces", 1)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_backpack_t7",    
        atlas = "images/inventoryimages/hoshino_special_equipment_backpack_t8.xml",
        image = "hoshino_special_equipment_backpack_t8.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_backpack_t8","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_backpack_t9","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_backpack_t9",            --  --  inst.prefab  实体名字
    {Ingredient("hoshino_item_blue_schist", 3),Ingredient("slurtle_shellpieces", 30),Ingredient("waxpaper", 3)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_backpack_t8",    
        atlas = "images/inventoryimages/hoshino_special_equipment_backpack_t9.xml",
        image = "hoshino_special_equipment_backpack_t9.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_backpack_t9","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_amulet_t1","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_amulet_t1",            --  --  inst.prefab  实体名字
    {Ingredient("papyrus", 3),Ingredient("goldnugget", 1),Ingredient("feather_robin", 2)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_amulet_t0",    
        atlas = "images/inventoryimages/hoshino_special_equipment_amulet_t1.xml",
        image = "hoshino_special_equipment_amulet_t1.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_amulet_t1","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_amulet_t2","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_amulet_t2",            --  --  inst.prefab  实体名字
    {Ingredient("heatrock", 1),Ingredient("manrabbit_tail", 2),Ingredient("ice", 12)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_amulet_t1",    
        atlas = "images/inventoryimages/hoshino_special_equipment_amulet_t2.xml",
        image = "hoshino_special_equipment_amulet_t2.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_amulet_t2","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_amulet_t3","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_amulet_t3",            --  --  inst.prefab  实体名字
    {Ingredient("goose_feather", 5),Ingredient("malbatross_feather", 5),Ingredient("moon_tree_blossom", 6)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_amulet_t2",    
        atlas = "images/inventoryimages/hoshino_special_equipment_amulet_t3.xml",
        image = "hoshino_special_equipment_amulet_t3.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_amulet_t3","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_amulet_t4","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_amulet_t4",            --  --  inst.prefab  实体名字
    {Ingredient("thulecite", 5),Ingredient("marble", 3),Ingredient("redgem", 1)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_amulet_t3",    
        atlas = "images/inventoryimages/hoshino_special_equipment_amulet_t4.xml",
        image = "hoshino_special_equipment_amulet_t4.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_amulet_t4","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_amulet_t5","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_amulet_t5",            --  --  inst.prefab  实体名字
    {Ingredient("dreadstone", 3),Ingredient("hoshino_item_blue_schist", 1),Ingredient("moonglass_charged", 15)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_amulet_t4",    
        atlas = "images/inventoryimages/hoshino_special_equipment_amulet_t5.xml",
        image = "hoshino_special_equipment_amulet_t5.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_amulet_t5","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_amulet_t6","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_amulet_t6",            --  --  inst.prefab  实体名字
    {Ingredient("horrorfuel", 3),Ingredient("shadowheart", 1),Ingredient("purplegem", 8)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_amulet_t5",    
        atlas = "images/inventoryimages/hoshino_special_equipment_amulet_t6.xml",
        image = "hoshino_special_equipment_amulet_t6.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_amulet_t6","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_amulet_t7","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_amulet_t7",            --  --  inst.prefab  实体名字
    {Ingredient("hoshino_item_blue_schist", 1),Ingredient("skeletonhat", 1),Ingredient("thurible", 1)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_amulet_t6",    
        atlas = "images/inventoryimages/hoshino_special_equipment_amulet_t7.xml",
        image = "hoshino_special_equipment_amulet_t7.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_amulet_t7","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_amulet_t8","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_amulet_t8",            --  --  inst.prefab  实体名字
    {Ingredient("hoshino_item_travel_traces", 1),Ingredient("hoshino_item_abydos_high_purity_alloy", 1),Ingredient("lightflier", 3)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_amulet_t7",    
        atlas = "images/inventoryimages/hoshino_special_equipment_amulet_t8.xml",
        image = "hoshino_special_equipment_amulet_t8.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_amulet_t8","MODS")                       -- -- 在【模组物品】标签里移除这个。

--------------------------------------------------------------------------------------------------------------------------------------------
---- 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_amulet_t9","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_amulet_t9",            --  --  inst.prefab  实体名字
    {Ingredient("hoshino_item_blue_schist", 3),Ingredient("klaussackkey", 1),Ingredient("walrus_tusk", 3),Ingredient("gnarwail_horn", 5)} ,--{ Ingredient("hoshino_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino_special_equipment_amulet_t8",    
        atlas = "images/inventoryimages/hoshino_special_equipment_amulet_t9.xml",
        image = "hoshino_special_equipment_amulet_t9.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_amulet_t9","MODS")                       -- -- 在【模组物品】标签里移除这个。
