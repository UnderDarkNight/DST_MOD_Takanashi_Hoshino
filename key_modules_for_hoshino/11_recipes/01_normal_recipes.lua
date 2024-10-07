


--------------------------------------------------------------------------------------------------------------------------------------------
---- 荷鲁斯之眼
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("hoshino_weapon_gun_eye_of_horus","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_weapon_gun_eye_of_horus",            --  --  inst.prefab  实体名字
        { Ingredient("gears", 5),Ingredient("transistor", 5),Ingredient("orangegem", 2),Ingredient("bluegem", 2),Ingredient("nitre", 10) }, 
        TECH.NONE, --- 魔法三本
        {
            -- nounlock=true,
            no_deconstruction=false,
            builder_tag = "hoshino",    
            atlas = "images/inventoryimages/hoshino_weapon_gun_eye_of_horus.xml",
            image = "hoshino_weapon_gun_eye_of_horus.tex",
        },
        {"CHARACTER",}
    )
    RemoveRecipeFromFilter("hoshino_weapon_gun_eye_of_horus","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 荷鲁斯之眼 升级 1 到 2
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("hoshino_spell_gun_eye_of_horus_level_1_to_2","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_spell_gun_eye_of_horus_level_1_to_2",            --  --  inst.prefab  实体名字
        {Ingredient("hoshino_weapon_gun_eye_of_horus", 0),Ingredient("thulecite", 5),Ingredient("moonrocknugget", 5),Ingredient("dreadstone", 5)} ,
        TECH.NONE, --- 魔法三本
        {
            -- nounlock=true,
            no_deconstruction=false,
            builder_tag = "weapon_gun_eye_of_horus_level_1",
            atlas = "images/inventoryimages/hoshino_weapon_gun_eye_of_horus.xml",
            image = "hoshino_weapon_gun_eye_of_horus.tex",
            -- sg_state="carvewood",
        },
        {"CHARACTER",}
    )
    RemoveRecipeFromFilter("hoshino_spell_gun_eye_of_horus_level_1_to_2","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 荷鲁斯之眼 升级2 到 3
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("hoshino_spell_gun_eye_of_horus_level_2_to_3","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_spell_gun_eye_of_horus_level_2_to_3",            --  --  inst.prefab  实体名字
        {Ingredient("hoshino_weapon_gun_eye_of_horus", 0),Ingredient("opalpreciousgem", 2),Ingredient("hoshino_item_abydos_high_purity_alloy", 1),Ingredient("hoshino_item_blue_schist", 3)} ,
        TECH.NONE, --- 魔法三本
        {
            -- nounlock=true,
            no_deconstruction=false,
            builder_tag = "weapon_gun_eye_of_horus_level_2",
            atlas = "images/inventoryimages/hoshino_weapon_gun_eye_of_horus.xml",
            image = "hoshino_weapon_gun_eye_of_horus.tex",
            -- sg_state="carvewood",
        },
        {"CHARACTER",}
    )
    RemoveRecipeFromFilter("hoshino_spell_gun_eye_of_horus_level_2_to_3","MODS")
