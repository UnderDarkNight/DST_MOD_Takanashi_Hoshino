


--------------------------------------------------------------------------------------------------------------------------------------------
---- 荷鲁斯之眼
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("hoshino_weapon_gun_eye_of_horus","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_weapon_gun_eye_of_horus",            --  --  inst.prefab  实体名字
        { Ingredient("gears", 2),Ingredient("transistor", 5),Ingredient("wagpunk_bits", 4),Ingredient("nitre", 10) }, 
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
        {Ingredient("hoshino_weapon_gun_eye_of_horus", 0),Ingredient("orangegem", 2),Ingredient("bluegem", 2),Ingredient("thulecite", 5),Ingredient("moonrocknugget", 5),Ingredient("dreadstone", 5)} ,
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
        {Ingredient("hoshino_weapon_gun_eye_of_horus", 0),Ingredient("hoshino_item_yi", 2),Ingredient("hoshino_item_abydos_high_purity_alloy", 3),Ingredient("hoshino_item_blue_schist", 2)} ,
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
        {Ingredient("gunpowder", 1),Ingredient("goldnugget", 1)} ,
        TECH.NONE, ---
        {
            -- nounlock=true,
            no_deconstruction=false,
            builder_tag = "hoshino",
            numtogive = 4,
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
    AddRecipeToFilter("hoshino_building_task_board_pre","STRUCTURES")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_building_task_board_pre",            --  --  inst.prefab  实体名字
        {Ingredient("cutstone", 2),Ingredient("boards", 3),Ingredient("rope", 2)} ,
        TECH.NONE, --- 魔法三本
        {
            -- nounlock=true,
            no_deconstruction=false,
            -- builder_tag = "hoshino",
            atlas = "images/map_icons/hoshino_building_task_board.xml",
            image = "hoshino_building_task_board.tex",
            placer = "hoshino_building_task_board_pre_placer",                       -------- 建筑放置器
            -- sg_state="carvewood",
        },
        {"STRUCTURES",}
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
            no_deconstruction=true,
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
            no_deconstruction = true,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_item_abydos_high_purity_alloy.xml",
            image = "hoshino_item_abydos_high_purity_alloy.tex",
            station_tag="lunar_forge"
        }--,
        -- {"CHARACTER","TOOLS"}
    )
    RemoveRecipeFromFilter("hoshino_item_abydos_high_purity_alloy","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 假日眼镜
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("hoshino_item_abydos_high_purity_alloy","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_equipment_holiday_glasses",            --  --  inst.prefab  实体名字
        {Ingredient("nightmarefuel",5),Ingredient("purplegem",2),Ingredient("livinglog",2)} ,
        TECH.MAGIC_THREE, -- 暗影操控器
        {
            nounlock = true,
            -- no_deconstruction = false,
            builder_tag = "hoshino",
            atlas = "images/inventoryimages/hoshino_equipment_holiday_glasses.xml",
            image = "hoshino_equipment_holiday_glasses.tex",
            -- station_tag="shadow_forge"
        },
        {"CHARACTER","MAGIC"}
    )
    RemoveRecipeFromFilter("hoshino_equipment_holiday_glasses","MODS")
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
            no_deconstruction = true,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_equipment_sandstorm_core.xml",
            image = "hoshino_equipment_sandstorm_core.tex",
            -- station_tag="lunar_forge"
        }--,
        -- {"CHARACTER","TOOLS"}
    )
    RemoveRecipeFromFilter("hoshino_equipment_sandstorm_core","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 仙人掌核心
--------------------------------------------------------------------------------------------------------------------------------------------
    -- AddRecipeToFilter("hoshino_equipment_cacti_core","MAGIC")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_equipment_cacti_core",            --  --  inst.prefab  实体名字
        {Ingredient("cactus_meat", 20),Ingredient("cactus_meat_cooked", 20),Ingredient("twigs", 20),} ,
        TECH.ANCIENT_FOUR, -- 完整的远古科技
        {
            nounlock = true,
            -- no_deconstruction = false,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_equipment_cacti_core.xml",
            image = "hoshino_equipment_cacti_core.tex",
            -- station_tag="lunar_forge"
        }--,
        -- {"MAGIC"}
    )
    RemoveRecipeFromFilter("hoshino_equipment_cacti_core","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 绿洲核心
--------------------------------------------------------------------------------------------------------------------------------------------
    -- AddRecipeToFilter("hoshino_equipment_oasis_core","MAGIC")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_equipment_oasis_core",            --  --  inst.prefab  实体名字
        {Ingredient("succulent_picked", 18),Ingredient("wetpouch", 10)} ,
        TECH.ANCIENT_FOUR, -- 完整的远古科技
        {
            nounlock = true,
            -- no_deconstruction = false,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_equipment_oasis_core.xml",
            image = "hoshino_equipment_oasis_core.tex",
            -- station_tag="lunar_forge"
        }--,
        -- {"MAGIC"}
    )
    RemoveRecipeFromFilter("hoshino_equipment_oasis_core","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 沙漠核心
--------------------------------------------------------------------------------------------------------------------------------------------
    -- AddRecipeToFilter("hoshino_equipment_desert_core","MAGIC")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_equipment_desert_core",            --  --  inst.prefab  实体名字
        {Ingredient("hoshino_equipment_sandstorm_core", 1),Ingredient("hoshino_equipment_cacti_core", 1),Ingredient("hoshino_equipment_oasis_core", 1)} ,
        TECH.ANCIENT_FOUR, -- 完整的远古科技
        {
            nounlock = true,
            no_deconstruction = true,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_equipment_desert_core.xml",
            image = "hoshino_equipment_desert_core.tex",
            -- station_tag="lunar_forge"
        }--,
        -- {"MAGIC"}
    )
    RemoveRecipeFromFilter("hoshino_equipment_desert_core","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 符章核心
--------------------------------------------------------------------------------------------------------------------------------------------
    -- AddRecipeToFilter("hoshino_equipment_rune_core","MAGIC")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_equipment_rune_core",            --  --  inst.prefab  实体名字
        {Ingredient("yellowamulet", 1),Ingredient("orangeamulet", 1),Ingredient("greenamulet", 1)} ,
        TECH.ANCIENT_FOUR, -- 完整的远古科技
        {
            nounlock = true,
            no_deconstruction = true,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_equipment_rune_core.xml",
            image = "hoshino_equipment_rune_core.tex",
            -- station_tag="lunar_forge"
        }--,
        -- {"MAGIC"}
    )
    RemoveRecipeFromFilter("hoshino_equipment_rune_core","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 暗影核心
--------------------------------------------------------------------------------------------------------------------------------------------
    -- AddRecipeToFilter("hoshino_item_abydos_high_purity_alloy","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_equipment_shadow_core",            --  --  inst.prefab  实体名字
        {Ingredient("nightmarefuel",50),Ingredient("horrorfuel",15),Ingredient("thurible",1),Ingredient("skeletonhat",1),Ingredient("armorskeleton",1),} ,
        TECH.SHADOWFORGING_TWO, -- 暗影术基座
        {
            nounlock = true,
            no_deconstruction = true,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_equipment_shadow_core.xml",
            image = "hoshino_equipment_shadow_core.tex",
            station_tag="shadow_forge"
        }--,
        -- {"CHARACTER","TOOLS"}
    )
    RemoveRecipeFromFilter("hoshino_equipment_shadow_core","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 至纯铥矿
--------------------------------------------------------------------------------------------------------------------------------------------
    -- AddRecipeToFilter("hoshino_equipment_ruins_core","MAGIC")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_equipment_ruins_core",            --  --  inst.prefab  实体名字
        {Ingredient("armorruins", 1),Ingredient("ruinshat", 1),Ingredient("ruins_bat", 1),Ingredient("nightmare_timepiece", 3)} ,
        TECH.ANCIENT_FOUR, -- 完整的远古科技
        {
            nounlock = true,
            -- no_deconstruction = false,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_equipment_ruins_core.xml",
            image = "hoshino_equipment_ruins_core.tex",
            -- station_tag="lunar_forge"
        }--,
        -- {"MAGIC"}
    )
    RemoveRecipeFromFilter("hoshino_equipment_ruins_core","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 废旧机械板材
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("hoshino_equipment_used_mechanical_sheets","MAGIC")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_equipment_used_mechanical_sheets",            --  --  inst.prefab  实体名字
        {Ingredient("trinket_6", 15),Ingredient("trinket_1", 15),Ingredient("gears", 15)} ,
        TECH.NONE, -- 
        {
            nounlock = true,
            -- no_deconstruction = false,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_equipment_used_mechanical_sheets.xml",
            image = "hoshino_equipment_used_mechanical_sheets.tex",
            -- station_tag="lunar_forge"
        }--,
        -- {"MAGIC"}
    )
    RemoveRecipeFromFilter("hoshino_equipment_used_mechanical_sheets","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
 ---- 纳米黑死神
--------------------------------------------------------------------------------------------------------------------------------------------
if TUNING["hoshino.Config"].COLOURFUL_EGG_ITEMS then
AddRecipeToFilter("hoshino_weapon_nanotech_black_reaper","MAGIC")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_weapon_nanotech_black_reaper",            --  --  inst.prefab  实体名字
        {Ingredient("shadowheart_infused", 3),Ingredient("voidcloth_scythe", 1),Ingredient("hoshino_item_abydos_high_purity_alloy", 3)} ,
        TECH.SHADOWFORGING_TWO, -- 暗影术基座
        {
            nounlock = true,
            no_deconstruction = true,
            -- builder_tag = "hoshino_building_shop24_level_3",
            atlas = "images/inventoryimages/hoshino_weapon_nanotech_black_reaper.xml",
            image = "hoshino_weapon_nanotech_black_reaper.tex",
            -- station_tag="lunar_forge"
        }--,
        -- {"MAGIC"}
    )
    RemoveRecipeFromFilter("hoshino_weapon_nanotech_black_reaper","MODS")
end
--------------------------------------------------------------------------------------------------------------------------------------------
---- 拉面店
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("hoshino_building_shiba_seki_ramen_cart","STRUCTURES")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_building_shiba_seki_ramen_cart",            --  --  inst.prefab  实体名字
        {Ingredient("boards", 5),Ingredient("cutstone", 5),Ingredient("charcoal", 5)} ,
        TECH.SCIENCE_ONE, --- 魔法三本
        {
            -- nounlock=true,
            -- no_deconstruction=false,
            -- builder_tag = "hoshino",
            atlas = "images/map_icons/hoshino_building_shiba_seki_ramen_cart.xml",
            image = "hoshino_building_shiba_seki_ramen_cart.tex",
            placer = "hoshino_building_shiba_seki_ramen_cart_placer",                       -------- 建筑放置器
            -- sg_state="carvewood",
        },
        {"STRUCTURES"}
    )
    RemoveRecipeFromFilter("hoshino_building_shiba_seki_ramen_cart","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 24小时商店
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("hoshino_building_shop24_pre","STRUCTURES")     ---- 添加物品到目标标签
    AddRecipe2(
        "hoshino_building_shop24_pre",            --  --  inst.prefab  实体名字
        {Ingredient("boards", 5),Ingredient("cutstone", 5),Ingredient("gears", 1)} ,
        TECH.NONE, --- 
        {
            -- nounlock=true,
            no_deconstruction = false,
            -- builder_tag = "hoshino",
            atlas = "images/map_icons/hoshino_building_shop24.xml",
            image = "hoshino_building_shop24.tex",
            placer = "hoshino_building_shop24_pre_placer",                       -------- 建筑放置器
            -- sg_state="carvewood",
        },
        {"STRUCTURES"}
    )
    RemoveRecipeFromFilter("hoshino_building_shop24_pre","MODS")
--------------------------------------------------------------------------------------------------------------------------------------------
---- 24小时商店 升级芯片 LV 1 - 3
--------------------------------------------------------------------------------------------------------------------------------------------
    local recipe_level = {
        {Ingredient("goldnugget", 6),Ingredient("gears", 2),Ingredient("moonglass", 6)},
        {Ingredient("thulecite", 6),Ingredient("greengem", 2)},
        {Ingredient("opalpreciousgem", 1),Ingredient("glommerwings", 1),Ingredient("alterguardianhatshard", 1)},
    }
    for i, v in ipairs(recipe_level) do
        local chip_prefab = "hoshino_item_shop_level_up_chip_"..i
        AddRecipeToFilter(chip_prefab,"REFINE")     ---- 添加物品到目标标签
        AddRecipe2(
            chip_prefab,            --  --  inst.prefab  实体名字
            v,
            TECH.NONE, --- 
            {
                -- nounlock=true,
                no_deconstruction = false,
                -- builder_tag = "hoshino",
                atlas = "images/inventoryimages/"..chip_prefab..".xml",
                image = chip_prefab .. ".tex",
                -- sg_state="carvewood",
            },
            {"REFINE"}
        )
        RemoveRecipeFromFilter(chip_prefab,"MODS")
    end
