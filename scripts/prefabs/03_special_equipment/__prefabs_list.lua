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


    "_excample",                           --- 示例装备
    "00_equipment_clear",                  --- 清除装备
    "01_01_shoes_t1",                           --- T1 鞋子
    "01_02_shoes_t2",                           --- T2 鞋子
    "01_03_shoes_t3",                           --- T3 鞋子
    "01_04_shoes_t4",                           --- T4 鞋子
    "01_05_shoes_t5",                           --- T5 鞋子
    "01_06_shoes_t6",                           --- T6 鞋子
    "01_07_shoes_t7",                           --- T7 鞋子
    "01_08_shoes_t8",                           --- T8 鞋子
    "01_09_shoes_t9",                           --- T9 鞋子

    "02_01_backpack_t1",                           --- T1 背包
    "02_02_backpack_t2",                           --- T2 背包
    "02_03_backpack_t3",                           --- T3 背包
    "02_04_backpack_t4",                           --- T4 背包
    "02_05_backpack_t5",                           --- T5 背包
    "02_06_backpack_t6",                           --- T6 背包
    "02_07_backpack_t7",                           --- T7 背包
    "02_08_backpack_t8",                           --- T8 背包
    "02_09_backpack_t9",                           --- T9 背包

    "03_01_amulet_t1",                           --- T1 项链
    "03_02_amulet_t2",                           --- T2 项链
    "03_03_amulet_t3",                           --- T3 项链
    "03_04_amulet_t4",                           --- T4 项链
    "03_05_amulet_t5",                           --- T5 项链
    "03_06_amulet_t6",                           --- T6 项链
    "03_07_amulet_t7",                           --- T7 项链
    "03_08_amulet_t8",                           --- T8 项链
    "03_09_amulet_t9",                           --- T9 项链


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