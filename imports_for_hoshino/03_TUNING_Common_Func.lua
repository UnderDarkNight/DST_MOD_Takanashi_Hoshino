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
---- 给指定数量的物品（用来减少卡顿）
    function TUNING.HOSHINO_FNS:GiveItemByPrefab(inst,prefab,num)
        -- print("main info fwd_in_pdt_func:GiveItemByPrefab",prefab,num)
        if type(prefab) ~= "string" or not PrefabExists(prefab) then
            return {}
        end

        num = num or 1
        if num == 1 then
            local item = SpawnPrefab(prefab)
            inst.components.inventory:GiveItem(item)
            return {item}
        end

        local base_item_inst = SpawnPrefab(prefab)
        if not base_item_inst.components.stackable then --- 不可叠堆的物品
            local ret_items_table = {}
            for i = 2, num, 1 do
                local item = SpawnPrefab(prefab)
                inst.components.inventory:GiveItem(item)
                table.insert(ret_items_table,item)
            end
            table.insert(ret_items_table,base_item_inst)
            inst.components.inventory:GiveItem(base_item_inst)
            return ret_items_table
        end
        ---------------------------------- 
        -- 叠堆计算
        local ret_items_table = {}
        local max_stack_num = base_item_inst.components.stackable.maxsize
        local rest_num = math.floor( num % max_stack_num )      --- 不够一组的个数
        local stack_groups = math.floor(   (num - rest_num)/max_stack_num    )  --- 够一组的个数
        if rest_num > 0 then
            base_item_inst.components.stackable.stacksize = rest_num
            inst.components.inventory:GiveItem(base_item_inst)
            table.insert(ret_items_table,base_item_inst)
        else
            base_item_inst:Remove()
        end
        if stack_groups > 0 then
            for i = 1, stack_groups, 1 do
                local items = SpawnPrefab(prefab)
                items.components.stackable.stacksize = max_stack_num
                inst.components.inventory:GiveItem(items)
                table.insert(ret_items_table,items)
            end
        end
        return ret_items_table
    end
--------------------------------------------------------------------------------------------
