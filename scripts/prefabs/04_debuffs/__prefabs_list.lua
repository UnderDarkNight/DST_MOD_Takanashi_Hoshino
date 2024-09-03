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

}

---------------------------------------------------------------------------
---- 正在测试的物品
if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE == true then
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