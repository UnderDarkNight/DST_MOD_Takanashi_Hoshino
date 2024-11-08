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