


--------------------------------------------------------------------------------------------------------------------------------------------
---- T1: 粉色休闲鞋 
--------------------------------------------------------------------------------------------------------------------------------------------
AddRecipeToFilter("hoshino_special_equipment_shoes_t1","CHARACTER")     ---- 添加物品到目标标签
AddRecipe2(
    "hoshino_special_equipment_shoes_t1",            --  --  inst.prefab  实体名字
    {} ,--{ Ingredient("fwd_in_pdt_material_realgar", 1),Ingredient("nightmarefuel", 10) }, 
    TECH.NONE, --- 魔法三本
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino",    
        atlas = "images/inventoryimages/hoshino_special_equipment_shoes_t1.xml",
        image = "hoshino_special_equipment_shoes_t1.tex",
    },
    {"CHARACTER",}
)
RemoveRecipeFromFilter("hoshino_special_equipment_shoes_t1","MODS")                       -- -- 在【模组物品】标签里移除这个。
