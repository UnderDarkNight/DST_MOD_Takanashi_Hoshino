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


    "01_cards_pack",                            --- 卡牌包
    "02_gun_eye_of_horus",                      --- 专属武器 荷鲁斯之眼
    "03_abydos_high_purity_alloy",              --- 阿拜索斯高纯度合金
    "04_blue_schist",                           --- 青辉石
    "05_12mm_shotgun_shells",                   --- 12mm霰弹
    "06_special_packer",                        --- 特殊打包盒
    "07_yi",                                    --- 镒
    "08_fragments_of_divine_script",            --- 神明文字碎片
    "09_ether_essence",                         --- 以太精髓
    "10_treasure_map",                          --- 藏宝图
    "11_holiday_glasses",                       --- 假日眼镜
    "12_travel_traces",                         --- 遍历之迹
    "13_anti_entropy_crystal_wheel",            --- 反熵水晶殖轮
    "14_sandstorm_core",                        --- 沙暴核心
    "15_cacti_core",                            --- 仙人掌核心
    "16_oasis_core",                            --- 绿洲核心
    "17_desert_core",                           --- 沙漠核心
    "18_pillow",                                --- 抱枕
    "19_rune_core",                             --- 符文核心
    "20_guardian_core",                         --- 守护者核心
    "21_tree_core",                             --- 树精核心
    "22_spider_core",                           --- 蛛后之心
    "23_00_nanotech_black_reaper",              --- 纳米黑死神
    "24_proof_of_harmony",                      --- 和谐之证
    "25_shadow_core",                           --- 暗影核心

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