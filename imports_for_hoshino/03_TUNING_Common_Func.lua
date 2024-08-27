--------------------------------------------------------------------------------------------
------ 常用函数放 TUNING 里
--------------------------------------------------------------------------------------------
----- RPC 命名空间
TUNING["hoshino.RPC_NAMESPACE"] = "hoshino_RPC"


--------------------------------------------------------------------------------------------

TUNING["hoshino.fn"] = {}
TUNING["hoshino.fn"].GetStringsTable = function(prefab_name)
    -------- 读取文本表
    -------- 如果没有当前语言的问题，调取中文的那个过去
    -------- 节省重复调用运算处理
    if TUNING["hoshino.fn"].GetStringsTable_last_prefab_name == prefab_name then
        return TUNING["hoshino.fn"].GetStringsTable_last_table or {}
    end


    local LANGUAGE = "ch"
    if type(TUNING["hoshino.Language"]) == "function" then
        LANGUAGE = TUNING["hoshino.Language"]()
    elseif type(TUNING["hoshino.Language"]) == "string" then
        LANGUAGE = TUNING["hoshino.Language"]
    end
    local ret_table = prefab_name and TUNING["hoshino.Strings"][LANGUAGE] and TUNING["hoshino.Strings"][LANGUAGE][tostring(prefab_name)] or nil
    if ret_table == nil and prefab_name ~= nil then
        ret_table = TUNING["hoshino.Strings"]["ch"][tostring(prefab_name)]
    end

    ret_table = ret_table or {}
    TUNING["hoshino.fn"].GetStringsTable_last_prefab_name = prefab_name
    TUNING["hoshino.fn"].GetStringsTable_last_table = ret_table

    return ret_table
end
--------------------------------------------------------------------------------------------

TUNING.HOSHINO_FNS = {}
--------------------------------------------------------------------------------------------
--- 文本参数表
    function TUNING.HOSHINO_FNS:GetString(prefab,index)
        local ret_table = TUNING["hoshino.fn"].GetStringsTable(prefab) or {}
        if index then
            return ret_table[index]
        else
            return ret_table
        end
    end
--------------------------------------------------------------------------------------------
