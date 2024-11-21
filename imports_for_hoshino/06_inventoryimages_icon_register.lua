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

		"hoshino_equipment_sandstorm_core",								--- 沙暴核心
		"hoshino_item_pillow",											--- 抱枕
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


