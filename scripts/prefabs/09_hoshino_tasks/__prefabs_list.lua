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


    "00_00_task_board",                                  --- 任务公告栏
    "01_excample_task_kill",                             --- 测试用的卷轴(击杀)
    "02_excample_task_item",                             --- 测试用的卷轴（物品）

    "white_01",                             --- 白色01
    "white_02",                             --- 白色02
    "white_03",                             --- 白色03
    "white_04",                             --- 白色04
    "white_05",                             --- 白色05
    "white_06",                             --- 白色06
    "white_07",                             --- 白色07
    "white_08",                             --- 白色08
    "white_09",                             --- 白色09
    "white_10",                             --- 白色10
    "white_11",                             --- 白色11
    "white_12",                             --- 白色12
    "white_13",                             --- 白色13
    "white_14",                             --- 白色14
    "white_15",                             --- 白色15
    "white_16",                             --- 白色16
    "white_17",                             --- 白色17
    "white_18",                             --- 白色18
    "white_19",                             --- 白色19
    "white_20",                             --- 白色20
    "white_21",                             --- 白色21
    "white_22",                             --- 白色22
    "white_23",                             --- 白色23
    "white_24",                             --- 白色24
    "white_25",                             --- 白色25
    "white_26",                             --- 白色26
    "white_27",                             --- 白色27
    "white_28",                             --- 白色28
    "white_29",                             --- 白色29
    "white_30",                             --- 白色30
    "white_31",                             --- 白色31
    "white_32",                             --- 白色32
    "white_33",                             --- 白色33
    "white_34",                             --- 白色34
    "white_35",                             --- 白色35
    "white_36",                             --- 白色36
    "white_37",                             --- 白色37
    "white_38",                             --- 白色38
    "white_39",                             --- 白色39
    "white_40",                             --- 白色40
    "white_41",                             --- 白色41
    "white_42",                             --- 白色42
    "white_43",                             --- 白色43
    "white_44",                             --- 白色44
    "white_45",                             --- 白色45
    "white_46",                             --- 白色46
    "white_47",                             --- 白色47

    "blue_01",                             --- 蓝色01
    "blue_02",                             --- 蓝色02
    "blue_03",                             --- 蓝色03
    "blue_04",                             --- 蓝色04
    "blue_05",                             --- 蓝色05
    "blue_06",                             --- 蓝色06
    "blue_07",                             --- 蓝色07
    "blue_08",                             --- 蓝色08
    "blue_09",                             --- 蓝色09
    "blue_10",                             --- 蓝色10
    "blue_11",                             --- 蓝色11
    "blue_12",                             --- 蓝色12
    "blue_13",                             --- 蓝色13
    "blue_14",                             --- 蓝色14
    "blue_15",                             --- 蓝色15
    "blue_16",                             --- 蓝色16
    "blue_17",                             --- 蓝色17
    "blue_18",                             --- 蓝色18
    "blue_19",                             --- 蓝色19
    "blue_20",                             --- 蓝色20
    "blue_21",                             --- 蓝色21
    "blue_22",                             --- 蓝色22
    "blue_23",                             --- 蓝色23
    "blue_24",                             --- 蓝色24
    "blue_25",                             --- 蓝色25
    "blue_26",                             --- 蓝色26
    "blue_27",                             --- 蓝色27
    "blue_28",                             --- 蓝色28
    "blue_29",                             --- 蓝色29
    "blue_30",                             --- 蓝色30
    "blue_31",                             --- 蓝色31
    "blue_32",                             --- 蓝色32
    "blue_33",                             --- 蓝色33
    "blue_34",                             --- 蓝色34
    "blue_35",                             --- 蓝色35
    "blue_36",                             --- 蓝色36
    "blue_37",                             --- 蓝色37
    "blue_38",                             --- 蓝色38
    "blue_39",                             --- 蓝色39
    "blue_40",                             --- 蓝色40
    "blue_41",                             --- 蓝色41
    "blue_42",                             --- 蓝色42
    "blue_43",                             --- 蓝色43
    "blue_44",                             --- 蓝色44
    "blue_45",                             --- 蓝色45
    "blue_46",                             --- 蓝色46

    "golden_01",                             --- 金色01
    "golden_02",                             --- 金色02
    "golden_03",                             --- 金色03
    "golden_04",                             --- 金色04
    "golden_05",                             --- 金色05
    "golden_06",                             --- 金色06
    "golden_07",                             --- 金色07
    "golden_08",                             --- 金色08
    "golden_09",                             --- 金色09
    "golden_10",                             --- 金色10
    "golden_11",                             --- 金色11
    "golden_12",                             --- 金色12
    "golden_13",                             --- 金色13
    "golden_14",                             --- 金色14
    "golden_16",                             --- 金色16
    "golden_17",                             --- 金色17
    "golden_18",                             --- 金色18
    "golden_19",                             --- 金色19
    "golden_20",                             --- 金色20
    "golden_21",                             --- 金色21
    "golden_22",                             --- 金色22
    "golden_23",                             --- 金色23
    "golden_24",                             --- 金色24
    "golden_25",                             --- 金色25
    "golden_26",                             --- 金色26


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