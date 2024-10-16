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
                ["inspect_str"] = "神秘核心",
                ["recipe_desc"] = "神秘核心",
                -- ["level_up_default"] = ""
            },
            ["hoshino_weapon_gun_eye_of_horus"] = {
                ["name"] = "荷鲁斯之眼",
                ["inspect_str"] = "荷鲁斯之眼",
                ["recipe_desc"] = "荷鲁斯之眼",
            },
            ["hoshino_item_abydos_high_purity_alloy"] = {
                ["name"] = "阿拜索斯高纯度合金",
                ["inspect_str"] = "阿拜索斯高纯度合金",
                ["recipe_desc"] = "阿拜索斯高纯度合金",
            },
            ["hoshino_item_blue_schist"] = {
                ["name"] = "青辉石",
                ["inspect_str"] = "青辉石",
                ["recipe_desc"] = "青辉石",
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
                ["inspect_str"] = "T1: 粉色休闲鞋",
                -- ["recipe_desc"] = "移动速度+5%",
            },
            ["hoshino_special_equipment_shoes_t2"] = {
                ["name"] = "T2:雪地靴",
                ["inspect_str"] = "T2:雪地靴",
                -- ["recipe_desc"] = "保暖+120\nSan+6/min\n移动速度+10%",
            },
            ["hoshino_special_equipment_shoes_t3"] = {
                ["name"] = "T3:粉色羊驼拖鞋",
                ["inspect_str"] = "T3:粉色羊驼拖鞋",
                -- ["recipe_desc"] = "免疫雷电\n免疫麻痹\n基础攻击伤害+15%",
            },
            ["hoshino_special_equipment_shoes_t4"] = {
                ["name"] = "T4:中古漆制学生鞋",
                ["inspect_str"] = "T4:中古漆制学生鞋",
                -- ["recipe_desc"] = "免疫火焰伤害\n移动速度+10%",
            },
            ["hoshino_special_equipment_shoes_t5"] = {
                ["name"] = "T5:战术长靴",
                ["inspect_str"] = "T5:战术长靴",
                -- ["recipe_desc"] = "特殊快捷键瞬移去鼠标位置\n消耗20San",
            },
            ["hoshino_special_equipment_shoes_t6"] = {
                ["name"] = "T6:高跟鞋",
                ["inspect_str"] = "T6:高跟鞋",
                -- ["recipe_desc"] = "无视地形行走\n移动速度+10%",
            },
            ["hoshino_special_equipment_shoes_t7"] = {
                ["name"] = "T7:休闲运动鞋",
                ["inspect_str"] = "T7:休闲运动鞋",
                -- ["recipe_desc"] = "无视碰撞体积",
            },
            ["hoshino_special_equipment_shoes_t8"] = {
                ["name"] = "T8:防水登山靴",
                ["inspect_str"] = "T8:防水登山靴",
                -- ["recipe_desc"] = "无视碰撞体积",
            },
            ["hoshino_special_equipment_shoes_t9"] = {
                ["name"] = "T9:闪闪鞋",
                ["inspect_str"] = "T9:闪闪鞋",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t1"] = {
                ["name"] = "T1:防水运动包",
                ["inspect_str"] = "T1:防水运动包",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t2"] = {
                ["name"] = "T2:防寒斜挎包",
                ["inspect_str"] = "T2:防寒斜挎包",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t3"] = {
                ["name"] = "T3:佩洛洛书包",
                ["inspect_str"] = "T3:佩洛洛书包",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t4"] = {
                ["name"] = "T4:藏蓝书包",
                ["inspect_str"] = "T4:藏蓝书包",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t5"] = {
                ["name"] = "T5:战术双肩包",
                ["inspect_str"] = "T5:战术双肩包",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t6"] = {
                ["name"] = "T6:恶魔之翼挎包",
                ["inspect_str"] = "T6:恶魔之翼挎包",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t7"] = {
                ["name"] = "T7:街头包",
                ["inspect_str"] = "T7:街头包",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t8"] = {
                ["name"] = "T8:蝴蝶单肩包",
                ["inspect_str"] = "T8:蝴蝶单肩包",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_backpack_t9"] = {
                ["name"] = "T9:斜挎式防水袋",
                ["inspect_str"] = "T9:斜挎式防水袋",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t1"] = {
                ["name"] = "T1:交通安全护符",
                ["inspect_str"] = "T1:交通安全护符",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t2"] = {
                ["name"] = "T2:暖手贴",
                ["inspect_str"] = "T2:暖手贴",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t3"] = {
                ["name"] = "T3:佩洛洛羽毛",
                ["inspect_str"] = "T3:佩洛洛羽毛",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t4"] = {
                ["name"] = "T4:十字架",
                ["inspect_str"] = "T4:十字架",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t5"] = {
                ["name"] = "T5:迷彩不倒翁",
                ["inspect_str"] = "T5:迷彩不倒翁",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t6"] = {
                ["name"] = "T6:诅咒娃娃",
                ["inspect_str"] = "T6:诅咒娃娃",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t7"] = {
                ["name"] = "T7:便携式除臭剂",
                ["inspect_str"] = "T7:便携式除臭剂",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t8"] = {
                ["name"] = "T8:捕梦网",
                ["inspect_str"] = "T8:捕梦网",
                -- ["recipe_desc"] = "???",
            },
            ["hoshino_special_equipment_amulet_t9"] = {
                ["name"] = "T9:鲨齿御守",
                ["inspect_str"] = "T9:鲨齿御守",
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
                ["name"] = "24小时商店",
                ["inspect_str"] = "商店",
                ["recipe_desc"] = "商店",
            },
            ["hoshino_building_task_board"] = {
                ["name"] = "任务公告栏",
                ["inspect_str"] = "任务公告栏",
                ["recipe_desc"] = "任务公告栏",
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
}

