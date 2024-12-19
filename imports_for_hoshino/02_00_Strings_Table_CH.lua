if TUNING["hoshino.Strings"] == nil then
    TUNING["hoshino.Strings"] = {}
end

local this_language = "ch"
-- if TUNING["hoshino.Language"] then
--     if type(TUNING["hoshino.Language"]) == "function" and TUNING["hoshino.Language"]() ~= this_language then
--         return
--     elseif type(TUNING["hoshino.Language"]) == "string" and TUNING["hoshino.Language"] ~= this_language then
--         return
--     end
-- end

--------- 默认加载中文文本，如果其他语言的文本缺失，直接调取 中文文本。 03_TUNING_Common_Func.lua
--------------------------------------------------------------------------------------------------
--- 默认显示名字:  name
--- 默认显示描述:  inspect_str
--- 默认制作栏描述: recipe_desc
--------------------------------------------------------------------------------------------------
TUNING["hoshino.Strings"][this_language] = TUNING["hoshino.Strings"][this_language] or {
        --------------------------------------------------------------------
        --- 正在debug 测试的
            ["hoshino_skin_test_item"] = {
                ["name"] = "皮肤测试物品",
                ["inspect_str"] = "inspect单纯的测试皮肤",
                ["recipe_desc"] = "测试描述666",
            },
            ["hoshino_other_cards_debugger_1"] = {
                ["name"] = "激活1张卡牌选择",
                ["inspect_str"] = "激活1张卡牌选择",
            },
            ["hoshino_other_cards_debugger_2"] = {
                ["name"] = "激活2张卡牌选择",
                ["inspect_str"] = "激活2张卡牌选择",
            },
            ["hoshino_other_cards_debugger_3"] = {
                ["name"] = "激活3张卡牌选择",
                ["inspect_str"] = "激活3张卡牌选择",
            },
            ["hoshino_other_cards_debugger_4"] = {
                ["name"] = "激活4张卡牌选择",
                ["inspect_str"] = "激活4张卡牌选择",
            },
            ["hoshino_other_cards_debugger_5"] = {
                ["name"] = "激活5张卡牌选择",
                ["inspect_str"] = "激活5张卡牌选择",
            },
            ["hoshino_other_shop_debugger_refresh"] = {
                ["name"] = "商店刷新次数",
                ["inspect_str"] = "商店刷新次数",
            },
            ["hoshino_other_shop_debugger_coins"] = {
                ["name"] = "100信用币",
                ["inspect_str"] = "100信用币",
            },
            ["hoshino_other_shop_debugger_level_up"] = {
                ["name"] = "商店升级套件",
                ["inspect_str"] = "商店升级套件",
            },
            ["hoshino_other_shop_debugger_reset_level"] = {
                ["name"] = "商店等级重置",
                ["inspect_str"] = "商店等级重置",
            },
        --------------------------------------------------------------------
        --- 组件动作
           
        --------------------------------------------------------------------
        --- 02_items
            ["hoshino_item_cards_pack"] = {
                ["name"] = "神秘核心",
                ["inspect_str"] = "内含一些特殊能力",
                ["recipe_desc"] = "内含一些特殊能力",
            },
            ["hoshino_weapon_gun_eye_of_horus"] = {
                ["name"] = "荷鲁斯之眼",
                ["inspect_str"] = "荷鲁斯之眼",
                ["recipe_desc"] = "荷鲁斯之眼",
            },
            ["hoshino_item_abydos_high_purity_alloy"] = {
                ["name"] = "阿拜多斯高纯度合金",
                ["inspect_str"] = "结合了异界力量锻造而出的至纯合金",
                ["recipe_desc"] = "结合了异界力量锻造而出的至纯合金",
            },
            ["hoshino_item_blue_schist"] = {
                ["name"] = "青辉石",
                ["inspect_str"] = "“它绽放着天青色的光芒”",
                ["recipe_desc"] = "“它绽放着天青色的光芒”",
            },
            ["hoshino_item_12mm_shotgun_shells"] = {
<<<<<<< HEAD
                ["name"] = "12mm霰弹",
=======
                ["name"] = "12号霰弹",
>>>>>>> 89dbeb6afce24ed195edd5da7d52a995d91096cf
                ["inspect_str"] = "为荷鲁斯之眼填充八发弹药",
                ["recipe_desc"] = "为荷鲁斯之眼填充八发弹药",
            },
            ["hoshino_item_special_packer"] = {
                ["name"] = "超级打包盒-千年改",
                ["inspect_str"] = "千年制作的超级打包盒",
                ["recipe_desc"] = "千年制作的超级打包盒",
            },
            ["hoshino_item_special_wraped_box"] = {
                ["name"] = "超级打包盒-千年改（已经打包）",
                ["inspect_str"] = "超级打包盒-千年改（已经打包）",
                ["recipe_desc"] = "超级打包盒-千年改（已经打包）",
            },
            ["hoshino_item_yi"] = {
                ["name"] = "镒",
                ["inspect_str"] = "流光溢彩的金属",
                ["recipe_desc"] = "流光溢彩的金属",
            },
            ["hoshino_item_fragments_of_divine_script"] = {
                ["name"] = "神名文字碎片",
                ["inspect_str"] = "构成神名文字的神名精髓",
                ["recipe_desc"] = "构成神名文字的神名精髓",
            },
            ["hoshino_item_ether_essence"] = {
                ["name"] = "以太精髓",
                ["inspect_str"] = "纯度极高的以太，又称微光",
                ["recipe_desc"] = "纯度极高的以太，又称微光",
            },
            ["hoshino_item_treasure_map"] = {
                ["name"] = "藏宝图",
                ["inspect_str"] = "一定有宝物！",
                ["recipe_desc"] = "一定有宝物！",
            },
            ["hoshino_item_treasure_map_marker"] = {
                ["name"] = "可疑的土堆",
                ["inspect_str"] = "需要铲子",
            },
            ["hoshino_equipment_holiday_glasses"] = {
                ["name"] = "假日眼镜",
                ["inspect_str"] = "假日眼镜",
                ["recipe_desc"] = "假日眼镜",
            },
            ["hoshino_item_travel_traces"] = {
                ["name"] = "遍历之迹",
                ["inspect_str"] = "“永恒大陆的各处遍布你的足迹”",
                ["recipe_desc"] = "“永恒大陆的各处遍布你的足迹”",
            },
            ["hoshino_item_anti_entropy_crystal_wheel"] = {
                ["name"] = "反熵水晶殖轮",
                ["inspect_str"] = "“无序趋于有序”",
                ["recipe_desc"] = "“无序趋于有序”",
            },
            ["hoshino_equipment_sandstorm_core"] = {
                ["name"] = "沙暴核心",
                ["inspect_str"] = "“沙尘暴力量的来源”",
                ["recipe_desc"] = "“沙尘暴力量的来源”",
            },
            ["hoshino_equipment_cacti_core"] = {
                ["name"] = "仙人掌核心",
                ["inspect_str"] = "“众多仙人掌凝结而成的精华”",
                ["recipe_desc"] = "“众多仙人掌凝结而成的精华”",
            },
            ["hoshino_equipment_oasis_core"] = {
                ["name"] = "绿洲核心",
                ["inspect_str"] = "“常绿之地的祝福”",
                ["recipe_desc"] = "“常绿之地的祝福”",
            },
            ["hoshino_equipment_desert_core"] = {
                ["name"] = "沙漠核心",
                ["inspect_str"] = "“沙漠的力量为你所用”",
                ["recipe_desc"] = "“沙漠的力量为你所用”",
            },
            ["hoshino_item_pillow"] = {
                ["name"] = "随地入场券",
                ["inspect_str"] = "随时随地，进入梦乡",
                ["recipe_desc"] = "随时随地，进入梦乡",
            },
            ["hoshino_equipment_rune_core"] = {
                ["name"] = "符章核心",
                ["inspect_str"] = "“远古符章的结合体”",
                ["recipe_desc"] = "“远古符章的结合体”",
            },
            ["hoshino_equipment_guardian_core"] = {
                ["name"] = "守护者核心",
                ["inspect_str"] = "“远古的守护者交出了它万年的传承”",
                ["recipe_desc"] = "“远古的守护者交出了它万年的传承”",
            },
            ["hoshino_equipment_tree_core"] = {
                ["name"] = "树精之心",
                ["inspect_str"] = "“自然的祝福治愈你的身躯”",
                ["recipe_desc"] = "“自然的祝福治愈你的身躯”",
            },
            ["hoshino_equipment_spider_core"] = {
                ["name"] = "蛛后之心",
                ["inspect_str"] = "“你探明了蜘蛛的心灵”",
                ["recipe_desc"] = "“你探明了蜘蛛的心灵”",
            },
            ["hoshino_weapon_nanotech_black_reaper"] = {
                ["name"] = "纳米黑死神",
                ["inspect_str"] = "“生灵在她的无尽仇恨中溺亡”",
                ["recipe_desc"] = "“生灵在她的无尽仇恨中溺亡”",
            },
            ["hoshino_equipment_proof_of_harmony"] = {
                ["name"] = "和谐之证",
                ["inspect_str"] = "“投我以桃，报之以李”",
                ["recipe_desc"] = "“投我以桃，报之以李”",
            },
            ["hoshino_equipment_shadow_core"] = {
                ["name"] = "暗影核心",
                ["inspect_str"] = "“远古神明的阴谋向你展开”",
                ["recipe_desc"] = "“远古神明的阴谋向你展开”",
            },
            ["hoshino_equipment_dragonfly_core"] = {
                ["name"] = "龙蝇之护",
                ["inspect_str"] = "龙蝇之护",
                ["recipe_desc"] = "龙蝇之护",
            },
            ["hoshino_equipment_giant_crab_claw"] = {
                ["name"] = "巨蟹之眼",
                ["inspect_str"] = "“基沃托斯可看不到这么大的螃蟹”",
                ["recipe_desc"] = "“基沃托斯可看不到这么大的螃蟹”",
            },
            ["hoshino_equipment_ruins_core"] = {
                ["name"] = "至纯铥矿",
                ["inspect_str"] = "“古老的金属绽放了它的神秘能量”",
                ["recipe_desc"] = "“古老的金属绽放了它的神秘能量”",
            },
            ["hoshino_equipment_used_mechanical_sheets"] = {
                ["name"] = "废旧机械板材",
                ["inspect_str"] = "“只是几块漏电的钢板而已”",
                ["recipe_desc"] = "“只是几块漏电的钢板而已”",
            },
            ["hoshino_item_accessory_remnants"] = {
                ["name"] = "奈因",
                ["inspect_str"] = "奈因",
                ["recipe_desc"] = "奈因",
            },
            ["hoshino_item_nine"] = {
                ["name"] = "九",
                ["inspect_str"] = "九",
                ["recipe_desc"] = "九",
            },
            ["hoshino_item_sky"] = {
                ["name"] = "天",
                ["inspect_str"] = "天",
                ["recipe_desc"] = "天",
            },
            ["hoshino_item_spring"] = {
                ["name"] = "春",
                ["inspect_str"] = "春",
                ["recipe_desc"] = "春",
            },
            ["hoshino_item_snow"] = {
                ["name"] = "雪",
                ["inspect_str"] = "雪",
                ["recipe_desc"] = "雪",
            },
            ["hoshino_item_artifact_du"] = {
                ["name"] = "Artifact · 都",
                ["inspect_str"] = "Artifact · 都",
                ["recipe_desc"] = "Artifact · 都",
            },
            ["hoshino_item_artifact_sky"] = {
                ["name"] = "Artifact · 天",
                ["inspect_str"] = "Artifact · 天",
                ["recipe_desc"] = "Artifact · 天",
            },
            ["hoshino_equipment_artifact_spring_wind"] = {
                ["name"] = "Artifact · 春风",
                ["inspect_str"] = "Artifact · 春风",
                ["recipe_desc"] = "Artifact · 春风",
            },
            ["hoshino_item_artifact_hia"] = {
                ["name"] = "Artifact · 希亚",
                ["inspect_str"] = "Artifact · 希亚",
                ["recipe_desc"] = "Artifact · 希亚",
            },
            ["hoshino_item_shop_level_up_chip_1"] = {
                ["name"] = "商店升级芯片 lv 1",
                ["inspect_str"] = "商店升级芯片 lv 1",
                ["recipe_desc"] = "商店升级芯片 lv 1",
            },
            ["hoshino_item_shop_level_up_chip_2"] = {
                ["name"] = "商店升级芯片 lv 2",
                ["inspect_str"] = "商店升级芯片 lv 2",
                ["recipe_desc"] = "商店升级芯片 lv 2",
            },
            ["hoshino_item_shop_level_up_chip_3"] = {
                ["name"] = "商店升级芯片 lv 3",
                ["inspect_str"] = "商店升级芯片 lv 3",
                ["recipe_desc"] = "商店升级芯片 lv 3",
            },
            ["hoshino_weapon_soul_cleaving_tang_saber"] = {
                ["name"] = "斩灵唐刀",
                ["inspect_str"] = "希望在未来的某个林间，我斩绝了世间的“恶”，再次与你相逢",
                ["recipe_desc"] = "希望在未来的某个林间，我斩绝了世间的“恶”，再次与你相逢",
            },
            ["hoshino_equipment_worm_core"] = {
                ["name"] = "蠕虫之口",
                ["inspect_str"] = "让胃口更好",
                ["recipe_desc"] = "让胃口更好",
            },
        --------------------------------------------------------------------
        --- 03_special_equipment
            ["hoshino_equipment_excample_shoes"] = {
                ["name"] = "测试鞋子",
                ["inspect_str"] = "inspect单纯的测试皮肤",
                ["recipe_desc"] = "测试描述666",
            },
            ["hoshino_equipment_excample_backpack"] = {
                ["name"] = "测试背包",
                ["inspect_str"] = "inspect单纯的测试皮肤",
                ["recipe_desc"] = "测试描述666",
            },
            ["hoshino_equipment_excample_amulet"] = {
                ["name"] = "测试项链",
                ["inspect_str"] = "inspect单纯的测试皮肤",
                ["recipe_desc"] = "测试描述666",
            },
            ["hoshino_special_equipment_amulet_clear"] = {
                ["name"] = "移除护符",
                ["inspect_str"] = "移除护符",
                ["recipe_desc"] = "移除护符",
            },
            ["hoshino_special_equipment_backpack_clear"] = {
                ["name"] = "移除背包",
                ["inspect_str"] = "移除背包",
                ["recipe_desc"] = "移除背包",
            },
            ["hoshino_special_equipment_shoes_clear"] = {
                ["name"] = "移除鞋子",
                ["inspect_str"] = "移除鞋子",
                ["recipe_desc"] = "移除鞋子",
            },
            ["hoshino_special_equipment_shoes_t1"] = {
                ["name"] = "T1: 粉色休闲鞋",
                ["inspect_str"] = "移动速度+5%",
                -- ["recipe_desc"] = "移动速度+5%",
            },
            ["hoshino_special_equipment_shoes_t2"] = {
                ["name"] = "T2:雪地靴",
                ["inspect_str"] = "拥有其下位的效果\n环境较冷时提供90点保暖\n较热时提供90点隔热\nsan+6",
                -- ["recipe_desc"] = "保暖+120\nSan+6/min\n移动速度+10%",
            },
            ["hoshino_special_equipment_shoes_t3"] = {
                ["name"] = "T3:粉色羊驼拖鞋",
                ["inspect_str"] = "拥有其下位的效果\n免疫雷电，免疫麻痹，基础攻击伤害+10%",
                -- ["recipe_desc"] = "免疫雷电\n免疫麻痹\n基础攻击伤害+15%",
            },
            ["hoshino_special_equipment_shoes_t4"] = {
                ["name"] = "T4:中古漆制学生鞋",
                ["inspect_str"] = "拥有其下位的效果\n免疫火焰伤害，移动速度+10%",
                -- ["recipe_desc"] = "免疫火焰伤害\n移动速度+10%",
            },
            ["hoshino_special_equipment_shoes_t5"] = {
                ["name"] = "T5:战术长靴",
                ["inspect_str"] = "拥有其下位的效果\n受攻击时令攻击来源减少70%的移动速度\n该效果持续10s",
                -- ["recipe_desc"] = "特殊快捷键瞬移去鼠标位置\n消耗20San",
            },
            ["hoshino_special_equipment_shoes_t6"] = {
                ["name"] = "T6:高跟鞋",
                ["inspect_str"] = "拥有其下位的效果\n可以在水面和虚空行走，移动速度+10%",
                -- ["recipe_desc"] = "无视地形行走\n移动速度+10%",
            },
            ["hoshino_special_equipment_shoes_t7"] = {
                ["name"] = "T7:休闲运动鞋",
                ["inspect_str"] = "拥有其下位的效果，无视碰撞体积",
                -- ["recipe_desc"] = "无视碰撞体积",
            },
            ["hoshino_special_equipment_shoes_t8"] = {
                ["name"] = "T8:防水登山靴",
                ["inspect_str"] = "拥有其下位的效果\n100%防水，移动速度+10%，免疫滑倒",
                -- ["recipe_desc"] = "无视碰撞体积",
            },
            ["hoshino_special_equipment_shoes_t9"] = {
                ["name"] = "T9:水上专用运动鞋",
                ["inspect_str"] = "拥有其下位的效果\n按下预设键位可以闪现到鼠标位置\n移动速度+20%",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t1"] = {
                ["name"] = "T1:防水运动包",
                ["inspect_str"] = "获得50%防水，生命上限+20",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t2"] = {
                ["name"] = "T2:防寒斜挎包",
                ["inspect_str"] = "拥有其下位的效果\n生命上限+30，cost恢复速度+0.01/s",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t3"] = {
                ["name"] = "T3:佩洛洛书包",
                ["inspect_str"] = "拥有其下位的效果\n使人物自身格子获得75%的保鲜效果\ncost恢复速度+0.01/s",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t4"] = {
                ["name"] = "T4:藏蓝书包",
                ["inspect_str"] = "拥有其下位的效果\n基础伤害减免+20%，免疫击飞",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t5"] = {
                ["name"] = "T5:战术双肩包",
                ["inspect_str"] = "拥有其下位的效果\n位面防御+10，经验值获取速率增加100%",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t6"] = {
                ["name"] = "T6:恶魔之翼挎包",
                ["inspect_str"] = "拥有其下位的效果\n基础攻击伤害+30%，cost恢复+0.02/s",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t7"] = {
                ["name"] = "T7:街头包",
                ["inspect_str"] = "拥有其下位的效果\n商店所有物品打折20%\n每次击杀单位可以获得3信用点\n传奇单位则获得300信用点",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t8"] = {
                ["name"] = "T8:蝴蝶单肩包",
                ["inspect_str"] = "拥有其下位的效果\n30码内的其他玩家受到伤害的60%由你承担\ncost恢复+0.05/s",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t9"] = {
                ["name"] = "T9:斜挎式防水袋",
                ["inspect_str"] = "拥有其下位的效果\n每15s检索30码内的所有其他玩家\n若其没有护盾\n则为其提供一个能抵挡75点伤害的护盾",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t1"] = {
                ["name"] = "T1:交通安全护符",
                ["inspect_str"] = "免疫钢羊的控制效果，生命上限+20",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t2"] = {
                ["name"] = "T2:暖手贴",
                ["inspect_str"] = "拥有其下位的效果\n免疫冰冻\n半径30码内所有玩家获得15%减伤",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t3"] = {
                ["name"] = "T3:佩洛洛羽毛",
                ["inspect_str"] = "拥有其下位的效果\n金卡和彩卡的出现概率提升，移动速度+15%",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t4"] = {
                ["name"] = "T4:十字架",
                ["inspect_str"] = "拥有其下位的效果\n免疫精神控制",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t5"] = {
                ["name"] = "T5:迷彩不倒翁",
                ["inspect_str"] = "拥有其下位的效果\n半径30码内所有玩家基础攻击伤害+20%\n且每次攻击恢复5点san值",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t6"] = {
                ["name"] = "T6:诅咒娃娃",
                ["inspect_str"] = "拥有其下位的效果\n每次造成伤害都会扣除敌人0.2%最大生命\n每有一个诅咒效果\n攻击伤害增加30%，百分比扣血增加0.3%",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t7"] = {
                ["name"] = "T7:便携式除臭剂",
                ["inspect_str"] = "拥有其下位的效果\n半径30码内的枯萎植物会恢复\n半径30码内的玩家会每10s恢复3点生命值",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t8"] = {
                ["name"] = "T8:捕梦网",
                ["inspect_str"] = "拥有其下位的效果\n睡觉时cost恢复速率+0.02/s\n每次睡觉时获得神秘核心\n此效果每一天仅可触发1次",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t9"] = {
                ["name"] = "T9:鲨齿御守",
                ["inspect_str"] = "拥有其下位的效果\n每次攻击会恢复造成伤害1%的生命值\n被攻击到的生物获得debuff：\n受到的伤害增加100%，持续10s",
                -- ["recipe_desc"] = "???",
            },
        --------------------------------------------------------------------
        --- 04_debuffs
            ["hoshino_card_debuff_bloodshed"] = {
                ["name"] = "流血",
            },
            ["hoshino_buff_special_equipment_backpack_t8"] = {
                ["name"] = "伤害分摊",
            },
        --------------------------------------------------------------------
        --- 06_buildings
            ["hoshino_building_shop24"] = {
                ["name"] = "天使24自动售货机",
                ["inspect_str"] = "天使24自动售货机",
                ["recipe_desc"] = "天使24自动售货机",
            },
            ["hoshino_building_shop24_pre"] = {
                ["name"] = "天使24自动售货机",
                ["inspect_str"] = "在阿拜多斯的帮助下，天使24在永恒大陆也建立了分...店？",
                ["recipe_desc"] = "在阿拜多斯的帮助下，天使24在永恒大陆也建立了分...店？",
            },
            ["hoshino_building_shiba_seki_ramen_cart"] = {
                ["name"] = "柴关拉面店",
                ["inspect_str"] = "柴关拉面店永恒大陆分店",
                ["recipe_desc"] = "柴关拉面店永恒大陆分店",
            },
            ["hoshino_building_ether_pool"] = {
                ["name"] = "以太池",
                ["inspect_str"] = "以太池",
                ["recipe_desc"] = "以太池",
            },
            ["hoshino_building_white_drone"] = {
                ["name"] = "白子的无人机",
                ["inspect_str"] = "白子的无人机",
                ["recipe_desc"] = "白子的无人机",
            },
            ["hoshino_building_white_drone_item"] = {
                ["name"] = "白子的无人机",
                ["inspect_str"] = "白子的无人机",
                ["recipe_desc"] = "白子的无人机",
            },
        --------------------------------------------------------------------
        --- 07_spell
            ["hoshino_spell_gun_eye_of_horus_level_1_to_2"] = {
                ["name"] = "荷鲁斯之眼 升到2级",
                ["inspect_str"] = "商店",
                ["recipe_desc"] = "升级到2级",
            },
            ["hoshino_spell_gun_eye_of_horus_level_2_to_3"] = {
                ["name"] = "荷鲁斯之眼 升到3级",
                ["inspect_str"] = "商店",
                ["recipe_desc"] = "升级到3级",
            },
        --------------------------------------------------------------------
        --- 09_hoshino_tasks
            ["hoshino_building_task_board_pre"] = {
                ["name"] = "阿拜多斯告示牌",
                ["inspect_str"] = "能从中看到基沃托斯各地委托的告示牌",
                ["recipe_desc"] = "能从中看到基沃托斯各地委托的告示牌",
            },
            ["hoshino_building_task_board"] = {
                ["name"] = "阿拜多斯告示牌",
                ["inspect_str"] = "阿拜多斯告示牌",
                ["recipe_desc"] = "阿拜多斯告示牌",
            },
        --------------------------------------------------------------------
        --- 10_foods
            ["hoshino_food_shiba_seki_ramen"] = {
                ["name"] = "柴关拉面",
                ["inspect_str"] = "柴关拉面",
                ["recipe_desc"] = "柴关拉面",
            },
            ["hoshino_food_shiba_seki_ramen_spice_sugar"] = {
                ["name"] = "蜜制柴关拉面",
                ["inspect_str"] = "蜜制柴关拉面",
                ["recipe_desc"] = "蜜制柴关拉面",
            },
            ["hoshino_food_shiba_seki_ramen_spice_salt"] = {
                ["name"] = "特咸柴关拉面",
                ["inspect_str"] = "特咸柴关拉面",
                ["recipe_desc"] = "特咸柴关拉面",
            },
            ["hoshino_food_shiba_seki_ramen_spice_garlic"] = {
                ["name"] = "蒜香柴关拉面",
                ["inspect_str"] = "蒜香柴关拉面",
                ["recipe_desc"] = "蒜香柴关拉面",
            },
            ["hoshino_food_shiba_seki_ramen_spice_chili"] = {
                ["name"] = "特辣柴关拉面",
                ["inspect_str"] = "特辣柴关拉面",
                ["recipe_desc"] = "特辣柴关拉面",
            },
            ["hoshino_food_mandrake_concentrate"] = {
                ["name"] = "曼德拉草浓缩液",
                ["inspect_str"] = "曼德拉草浓缩液",
                ["recipe_desc"] = "曼德拉草浓缩液",
            },
            ["hoshino_food_energy_drink"] = {
                ["name"] = "能量饮料",
                ["inspect_str"] = "能量饮料",
                ["recipe_desc"] = "能量饮料",
            },
        --------------------------------------------------------------------
}

