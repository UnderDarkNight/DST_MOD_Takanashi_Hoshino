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
                ["name"] = "卡牌芯片",
                ["inspect_str"] = "卡牌芯片",
                ["recipe_desc"] = "卡牌芯片",
                -- ["level_up_default"] = ""
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
            ["hoshino_special_equipment_shoes_t1"] = {
                ["name"] = "T1: 粉色休闲鞋",
                ["inspect_str"] = "T1: 粉色休闲鞋",
                ["recipe_desc"] = "移动速度+5%",
            },
        --------------------------------------------------------------------
        --- 04_debuffs
            ["hoshino_card_debuff_bloodshed"] = {
                ["name"] = "流血",
            },
        --------------------------------------------------------------------
        --- 06_buildings
            ["hoshino_building_shop24"] = {
                ["name"] = "24小时商店",
                ["inspect_str"] = "商店",
                ["recipe_desc"] = "商店",
            },
        --------------------------------------------------------------------
}

