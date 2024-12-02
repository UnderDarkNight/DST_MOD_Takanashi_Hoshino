--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    物品制作触发材料返回。
    注意0材料制作物（技能、行为等）不会触发。
    注意特殊材料制作物（血量、San 等)

    无视绿宝石佩戴，全都按照没有佩戴绿宝石。

    材料向上取整。例如：制作一个需要1个材料，返还一半的时候会返还1个材料。

    21、【白】【巧匠】【每次制作物品的时候，有1%概率返还制作材料，最高50%】【满概率后从卡池移除】
    25、【金】【星野的精算】【每天前3次制作返回一半的材料（向上取整，材料消耗1个的时候，直接返还1个）】【次数叠加】


    TUNING.HOSHINO_FNS:GiveItemByPrefab(inst,prefab,num)

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function GetRealRecipes(old_recipe)
        local new_recipes = {}
        local empty_flag = true
        local item_ignore = { -- 忽略的物品
            [CHARACTER_INGREDIENT.HEALTH] = true,
            [CHARACTER_INGREDIENT.MAX_HEALTH] = true,
            [CHARACTER_INGREDIENT.SANITY] = true,
            [CHARACTER_INGREDIENT.MAX_SANITY] = true,
        }
        for index, temp_table in pairs(old_recipe.ingredients) do
            -- for k, v in pairs(temp_table) do
            --     -- print(index, k, v)
            -- end
            if temp_table.type and not item_ignore[temp_table.type] and PrefabExists(temp_table.type) and (temp_table.amount or 0) > 0 then
                new_recipes[temp_table.type] = temp_table.amount
                empty_flag = false
            end
        end
        -- for prefab, num in pairs(new_recipes) do
        --     print(prefab, num)
        -- end
        return new_recipes,empty_flag
    end
    local function Active_Give_Back_Recipe_Items(inst,old_recipe)
        local recipe,is_empty = GetRealRecipes(old_recipe)
        if is_empty then
            return
        end
        -------------------------------------------------------------------------------------------------------------
        --- 按概率全部返还
            if math.random(10000)/10000 <= inst.components.hoshino_com_debuff:Get_Probability_Of_Returning_Recipe() then
                for prefab, num in pairs(recipe) do
                    TUNING.HOSHINO_FNS:GiveItemByPrefab(inst,prefab,num)
                end
                return
            end
        -------------------------------------------------------------------------------------------------------------
        ---- 按次数返还一半
            local max_num = inst.components.hoshino_com_debuff:Get_Returning_Recipe_By_Count()
            if max_num > 0 and inst.components.hoshino_data:Add("Returning_Recipe_By_Count_Current",0) < max_num then
                inst.components.hoshino_data:Add("Returning_Recipe_By_Count_Current",1)
                ---- 返还一半材料
                local ret_recipe = {}
                for prefab, num in pairs(recipe) do
                    local ret_num = math.floor(num/2)
                    if ret_num > 0 then
                        ret_recipe[prefab] = ret_num
                    end
                end
                for prefab, num in pairs(ret_recipe) do
                    TUNING.HOSHINO_FNS:GiveItemByPrefab(inst,prefab,num)
                end
            end
        -------------------------------------------------------------------------------------------------------------

    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("buildstructure",function(inst,_table)      --- 放下建筑的时候触发
        local recipe = _table.recipe or {}
        Active_Give_Back_Recipe_Items(inst,recipe)
    end)

    inst:ListenForEvent("builditem",function(inst,_table)            --- 物品制作完成的瞬间触发
        local recipe = _table.recipe or {}
        Active_Give_Back_Recipe_Items(inst,recipe)
    end)

    ----- 重置材料一半返还的计数器
    inst:WatchWorldState("cycles",function()
        inst.components.hoshino_data:Set("Returning_Recipe_By_Count_Current",0)
    end)

end