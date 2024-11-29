---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 统一注册 【 images\inventoryimages 】 里的所有图标
--- 每个 xml 里面 只有一个 tex

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if Assets == nil then
    Assets = {}
end

local files_name = {

	---------------------------------------------------------------------------------------

		-- "hoshino_weapon_scythe",											--- 冥界之镰
		-- "hoshino_weapon_scythe_overcome_confinement",						--- 冲破禁锢


		-- "hoshino_item_faded_memory",										--- 褪色的记忆
		-- "hoshino_item_blissful_memory",										--- 幸福的记忆
	---------------------------------------------------------------------------------------
	-- 02_items
		"hoshino_item_cards_pack",										--- 卡牌芯片
		"hoshino_item_cards_pack_supreme_mystery",						--- 卡牌芯片-最高神秘
		"hoshino_item_cards_pack_authority_to_unveil_secrets",			--- 卡牌芯片-窥秘权柄
		"hoshino_weapon_gun_eye_of_horus",								--- 专属武器
		"hoshino_item_abydos_high_purity_alloy",						--- 阿拜索斯高纯度合金
		"hoshino_item_blue_schist",										--- 青辉石
		"hoshino_item_12mm_shotgun_shells",								--- 12mm霰弹
		"hoshino_item_special_packer",									--- 超级打包盒
		"hoshino_item_special_wraped_box",								--- 超级打包盒（已经打包）
		"hoshino_item_yi",												--- 镒
		"hoshino_item_fragments_of_divine_script",						--- 神明文字碎片
		"hoshino_item_ether_essence",									--- 以太精髓
		"hoshino_item_treasure_map",									--- 藏宝图
		"hoshino_equipment_holiday_glasses",							--- 假日眼镜
		"hoshino_item_travel_traces",									--- 遍历之迹
		"hoshino_item_anti_entropy_crystal_wheel",						--- 反熵水晶殖轮
		"hoshino_equipment_sandstorm_core",								--- 沙暴核心
		"hoshino_equipment_cacti_core",									--- 仙人掌核心
		"hoshino_equipment_cacti_core_summer",							--- 仙人掌核心-夏日
		"hoshino_equipment_oasis_core",									--- 绿洲核心
		"hoshino_equipment_desert_core",								--- 沙漠核心
		"hoshino_item_pillow",											--- 抱枕
		"hoshino_equipment_rune_core",									--- 符文核心
		"hoshino_equipment_guardian_core",								--- 守护核心
		"hoshino_equipment_tree_core",									--- 树木核心
		"hoshino_equipment_spider_core",								--- 蜘蛛核心
		"hoshino_weapon_nanotech_black_reaper",							--- 纳米黑死神
		"hoshino_equipment_proof_of_harmony",							--- 和谐证明
		"hoshino_equipment_shadow_core",								--- 暗影核心

		"hoshino_equipment_giant_crab_claw",							--- 巨蟹之爪
		"hoshino_equipment_ruins_core",									--- 至纯铥矿

		"hoshino_item_nine",											--- 九
		"hoshino_item_sky",												--- 天
		"hoshino_item_spring",											--- 春
		"hoshino_item_snow",											--- 雪

		"hoshino_item_artifact_du",										--- Artifact 都
		"hoshino_item_artifact_sky",									--- Artifact 天
		"hoshino_equipment_artifact_spring_wind",						--- Artifact 春风
		"hoshino_item_artifact_hia",									--- Artifact 希亚
	---------------------------------------------------------------------------------------
	-- 03_special_equipment
		"hoshino_special_equipment_shoes_clear",								--- 清除鞋子
		"hoshino_special_equipment_amulet_clear",								--- 清除护符
		"hoshino_special_equipment_backpack_clear",								--- 清除背包

		"hoshino_special_equipment_shoes_t1",								--- 1级鞋子
		"hoshino_special_equipment_shoes_t2",								--- 2级鞋子
		"hoshino_special_equipment_shoes_t3",								--- 3级鞋子
		"hoshino_special_equipment_shoes_t4",								--- 4级鞋子
		"hoshino_special_equipment_shoes_t5",								--- 5级鞋子
		"hoshino_special_equipment_shoes_t6",								--- 6级鞋子
		"hoshino_special_equipment_shoes_t7",								--- 7级鞋子
		"hoshino_special_equipment_shoes_t8",								--- 8级鞋子
		"hoshino_special_equipment_shoes_t9",								--- 9级鞋子
	---------------------------------------------------------------------------------------
	-- 06_buildings
		"hoshino_building_white_drone_item",								--- 白子无人机
	---------------------------------------------------------------------------------------
	-- 10_foods
		"hoshino_food_shiba_seki_ramen",								--- 柴关拉面
		"hoshino_food_mandrake_concentrate",								--- 曼德拉草浓缩液
		"hoshino_food_energy_drink",								--- 能量饮料
	---------------------------------------------------------------------------------------

}

for k, name in pairs(files_name) do
    table.insert(Assets, Asset( "IMAGE", "images/inventoryimages/".. name ..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/inventoryimages/".. name ..".xml" ))
	RegisterInventoryItemAtlas("images/inventoryimages/".. name ..".xml", name .. ".tex")
end


