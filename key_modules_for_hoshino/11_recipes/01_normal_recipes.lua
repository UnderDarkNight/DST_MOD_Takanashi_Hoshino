


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
--------------------------------------------------------------------------------------------------------------------------------------------
---- 12号霰弹
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("hoshino_item_12mm_shotgun_shells","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_item_12mm_shotgun_shells",            --  --  inst.prefab  实体名字
        {Ingredient("gunpowder", 1),Ingredient("goldnugget", 2)} ,
        TECH.NONE, ---
        {
            -- nounlock=true,
            no_deconstruction=false,
            builder_tag = "hoshino",
            atlas = "images/inventoryimages/hoshino_item_12mm_shotgun_shells.xml",
            image = "hoshino_item_12mm_shotgun_shells.tex",
            -- sg_state="carvewood",
        },
        {"CHARACTER",}
    )
    RemoveRecipeFromFilter("hoshino_item_12mm_shotgun_shells","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 任务看板
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("hoshino_building_task_board_pre","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_building_task_board_pre",            --  --  inst.prefab  实体名字
        {} ,
        TECH.NONE, --- 魔法三本
        {
            -- nounlock=true,
            no_deconstruction=false,
            builder_tag = "hoshino",
            atlas = "images/map_icons/hoshino_building_task_board.xml",
            image = "hoshino_building_task_board.tex",
            placer = "hoshino_building_task_board_pre_placer",                       -------- 建筑放置器
            -- sg_state="carvewood",
        },
        {"CHARACTER",}
    )
    RemoveRecipeFromFilter("hoshino_building_task_board_pre","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 神明文字碎片
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("hoshino_item_fragments_of_divine_script","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_item_fragments_of_divine_script",            --  --  inst.prefab  实体名字
        {Ingredient("hoshino_item_yi", 3),Ingredient("opalpreciousgem", 1),} ,
        TECH.NONE,
        {
            -- nounlock=true,
            no_deconstruction=false,
            builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_item_fragments_of_divine_script.xml",
            image = "hoshino_item_fragments_of_divine_script.tex",
            -- sg_state="carvewood",
        },
        {"CHARACTER",}
    )
    RemoveRecipeFromFilter("hoshino_item_fragments_of_divine_script","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 超级打包盒
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("hoshino_item_special_packer","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_item_special_packer",            --  --  inst.prefab  实体名字
        {Ingredient("bundlewrap", 3),Ingredient("hoshino_item_yi", 1),} ,
        TECH.SCIENCE_TWO,
        {
            -- nounlock = true,
            -- no_deconstruction = false,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_item_special_packer.xml",
            image = "hoshino_item_special_packer.tex",
            -- sg_state="carvewood",
        },
        {"CHARACTER","TOOLS"}
    )
    RemoveRecipeFromFilter("hoshino_item_special_packer","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 阿拜多斯高纯度合金
--------------------------------------------------------------------------------------------------------------------------------------------
    -- AddRecipeToFilter("hoshino_item_abydos_high_purity_alloy","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_item_abydos_high_purity_alloy",            --  --  inst.prefab  实体名字
        {Ingredient("hoshino_item_yi", 2),Ingredient("lunarplant_husk", 15),Ingredient("thulecite", 15),Ingredient("goldnugget", 15),} ,
        TECH.LUNARFORGING_TWO, -- 辉煌铁匠铺
        {
            nounlock = true,
            -- no_deconstruction = false,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_item_abydos_high_purity_alloy.xml",
            image = "hoshino_item_abydos_high_purity_alloy.tex",
            station_tag="lunar_forge"
        }--,
        -- {"CHARACTER","TOOLS"}
    )
    RemoveRecipeFromFilter("hoshino_item_abydos_high_purity_alloy","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 沙暴核心
--------------------------------------------------------------------------------------------------------------------------------------------
    -- AddRecipeToFilter("hoshino_equipment_sandstorm_core","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_equipment_sandstorm_core",            --  --  inst.prefab  实体名字
        {Ingredient("hoshino_item_ether_essence", 1),Ingredient("hoshino_item_yi", 1),Ingredient("hoshino_item_abydos_high_purity_alloy", 1),} ,
        TECH.ANCIENT_FOUR, -- 完整的远古科技
        {
            nounlock = true,
            -- no_deconstruction = false,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_equipment_sandstorm_core.xml",
            image = "hoshino_equipment_sandstorm_core.tex",
            -- station_tag="lunar_forge"
        }--,
        -- {"CHARACTER","TOOLS"}
    )
    RemoveRecipeFromFilter("hoshino_equipment_sandstorm_core","MODS")
