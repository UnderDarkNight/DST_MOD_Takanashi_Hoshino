----------------------------------------------------
--- 本文件单纯返还路径
----------------------------------------------------

-- local function sum(a, b)
--     return a + b
-- end

-- local info = debug.getinfo(sum)

-- for k,v in pairs(info) do
--         print(k,':', info[k])
-- end

--------------------------------------------------------------------------
local addr_test = debug.getinfo(1).source           ---- 找到绝对路径

local temp_str_index = string.find(addr_test, "scripts/prefabs/")
local temp_addr = string.sub(addr_test,temp_str_index,-1)
-- print("fake error 6666666666666:",temp_addr)    ---- 找到本文件所处的相对路径

local temp_str_index2 = string.find(temp_addr,"/__prefabs_list.lua")

local Prefabs_addr_base = string.sub(temp_addr,1,temp_str_index2) .. "/"    --- 得到最终文件夹路径

---------------------------------------------------------------------------
-- local Prefabs_addr_base = "scripts/prefabs/01_hoshino_items/"               --- 文件夹路径
local prefabs_name_list = {


    "01_01_card_debuff_damage_mult_and_sanity",                             --- 卡牌debuff: 伤害倍数和理智消耗惩罚
    "01_02_card_debuff_health_down_and_coins_up",                           --- 卡牌debuff：生命值下降和金币增加
    "01_03_card_debuff_builder_blocker",                                    --- 卡牌debuff：【诅咒】【凡庸】
    "01_04_card_debuff_temperature_locker",                                 --- 卡牌debuff：温度锁定器
    "01_05_card_debuff_price_mult",                                         --- 卡牌debuff：价格倍增器
    "01_06_card_debuff_bloodshed",                                          --- 卡牌debuff：流血
    "01_07_card_debuff_max_health_1",                                       --- 卡牌debuff：最大血量1
    "01_08_card_debuff_force_night_sleep",                                  --- 卡牌debuff：强制夜晚睡眠
    "01_09_card_debuff_exp_and_epic",                                       --- 卡牌debuff：只能从史诗怪物身上获得经验
    "01_10_card_debuff_sanity_ever_zero",                                   --- 卡牌debuff：理智永远为0
    "01_11_card_debuff_equipment_blocker",                                  --- 卡牌debuff：屏蔽装备
    "01_12_card_debuff_moisture_down_blocker",                              --- 卡牌debuff：湿度下降屏蔽
    "01_13_card_debuff_reduced_work_efficiency",                            --- 卡牌debuff：工作效率下降
    "01_14_card_debuff_sleep_and_coins",                                    --- 卡牌debuff：睡眠和金币
    "01_15_card_debuff_for_monster_drop_cards_pack",                        --- 卡牌debuff：怪物掉落卡包
    "01_16_card_debuff_health_penalty_blocker",                             --- 卡牌debuff：生命惩罚屏蔽
    "01_17_card_debuff_health_auto_up",                                     --- 卡牌debuff：生命自动上升
    "01_18_card_debuff_direct_kill_target",                                 --- 卡牌debuff：直接击杀目标(套给玩家和怪物)
    "01_19_card_debuff_i_have_expanded",                                    --- 卡牌debuff：我已膨胀
    "01_20_card_debuff_kill_and_explode",                                   --- 卡牌debuff：击杀爆炸
    "01_21_card_debuff_level_up_and_double_card_pack",                      --- 卡牌debuff：升级和双倍卡包
    "01_22_card_debuff_absolute_defense",                                   --- 卡牌debuff：绝对防御
    "01_23_card_debuff_ruins_sheild_and_vengeance",                         --- 卡牌debuff：铥矿护盾和吸血
    "01_24_card_debuff_weapon_dmg_up_by_range",                             --- 卡牌debuff：武器伤害随距离增加
    "01_25_card_debuff_armored_warrior",                                    --- 卡牌debuff：重装战士
    "01_26_card_debuff_moisture_and_dmg",                                   --- 卡牌debuff：湿度和伤害
    "01_27_card_debuff_road_of_pain",                                       --- 卡牌debuff：痛苦之路
    "01_28_card_debuff_kill_and_coins_up_thief",                            --- 卡牌debuff：击杀和金币增加
    "01_29_card_debuff_air_drop_support",                                   --- 卡牌debuff：空投支援
    "01_30_card_debuff_trading_master_pigking_and_gems",                    --- 卡牌debuff：猪王交易和宝石
    "01_31_card_debuff_mark_moon_land_and_ancient_land",                    --- 卡牌debuff：标记月岛和远古的位置
    "01_32_card_debuff_experimental_therapy",                               --- 卡牌debuff：实验性疗法
    "01_33_card_debuff_purifying_light",                                    --- 卡牌debuff：净化之光
    "01_33_card_debuff_energy_burst",                                       --- 卡牌debuff：活力迸发
    "01_34_card_debuff_collecting_fetish",                                  --- 卡牌debuff：收集癖
    "01_35_card_debuff_substantive_strike",                                 --- 卡牌debuff：实质性打击
    "01_36_card_debuff_war_chariot",                                        --- 卡牌debuff：战车
    "01_37_card_debuff_burdened_forward",                                   --- 卡牌debuff：负重前行
    "01_38_card_debuff_seek_good_avoid_bad",                                --- 卡牌debuff：趋吉避凶
    "01_39_card_debuff_nine_lives_cat",                                     --- 卡牌debuff：九命猫
    "01_40_card_debuff_cat_amulet",                                         --- 卡牌debuff：九命猫的项圈
    "01_41_card_debuff_cat_hand",                                           --- 卡牌debuff：猫爪
    "01_42_card_debuff_hell_contract",                                      --- 卡牌debuff：地狱契约
    "01_43_card_debuff_neatness_obsession",                                 --- 卡牌debuff：洁癖
    "01_44_card_debuff_coins_and_dmg_up",                                   --- 卡牌debuff：金币和伤害增加


    "02_monster_damage_down_debuff",                         --- 怪物伤害倍增器。
    "03_special_equipment_backpack_t8_buff",                 --- 特殊装备：T8背包 的 buff
    "04_special_equipment_backpack_t9_buff",                 --- 特殊装备：T9背包 的 buff
    "05_special_equipment_amulet_t2_buff",                   --- 特殊装备：T2护身符 的 buff
    "05_special_equipment_amulet_t5_buff",                   --- 特殊装备：T5护身符 的 buff
    "06_special_equipment_amulet_t6_buff",                   --- 特殊装备：T6护身符 的 buff
    "07_special_equipment_amulet_t9_debuff",                 --- 特殊装备：T9护身符 的 debuff

    "08_gun_eye_of_horus_spell_monster_brain_stop",                 --- 荷鲁斯之眼 战术镇压 的笨怪deubff

    "09_soul_cleaving_tang_saber_monster_debuff",                 --- 灵魂撕裂 剑术 的笨怪deubff

    "10_bomb_shield",                 --- 爆炸护盾
}

---------------------------------------------------------------------------
---- 正在测试的物品
if TUNING.HOSHINO_DEBUGGING_MODE == true then
    local debugging_name_list = {



    }
    for k, temp in pairs(debugging_name_list) do
        table.insert(prefabs_name_list,temp)
    end
end
---------------------------------------------------------------------------












local ret_addrs = {}
for i, v in ipairs(prefabs_name_list) do
    table.insert(ret_addrs,Prefabs_addr_base..v..".lua")
end
return ret_addrs