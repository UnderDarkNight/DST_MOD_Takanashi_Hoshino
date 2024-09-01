----------------------------------------------------------------------------------------------------------------------------------
--[[

    制作栏  屏蔽模块.
    注意最后加载。

]]--
----------------------------------------------------------------------------------------------------------------------------------
--- hook
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
    local function CheckCanStartChecker(origin_recipe)
        local new_list,empty_flag = GetRealRecipes(origin_recipe)
        ---------------------------------------------
        --- 空表则不检查次数
            if empty_flag then
                return false
            end
        ---------------------------------------------
        --- 所有的消耗为0，则不检查次数
            local all_cost_0_flag = true
            for prefab, num in pairs(new_list) do
                if num > 0 then
                    all_cost_0_flag = false
                    break
                end
            end
            if all_cost_0_flag then
                return false
            end
        ---------------------------------------------
        return true
    end

    local function HookBuilderCom(inst)
        local old_HasIngredients = inst.components.builder.HasIngredients
        inst.components.builder.HasIngredients = function(self,origin_recipe,...)
            -------------------------------------------------------
            --- 检查函数
                local recipe = origin_recipe
                if type(recipe) == "string" then 
                    recipe = GetValidRecipe(recipe)
                end
                if CheckCanStartChecker(recipe) and not inst.components.hoshino_com_builder_blocker:CanBuild() then
                    return false
                end
            -------------------------------------------------------
            return old_HasIngredients(self,origin_recipe,...)
        end

        -- local old_MakeRecipe = inst.components.builder.MakeRecipe
        -- inst.components.builder.MakeRecipe = function(self,origin_recipe,...)
        --     -------------------------------------------------------
        --     --- 检查函数
        --         local recipe = origin_recipe
        --         if type(recipe) == "string" then
        --             recipe = GetValidRecipe(recipe)
        --         end
        --         if CheckCanStartChecker(recipe) and not inst.components.hoshino_com_builder_blocker:CanBuild() then
        --             return false
        --         end
        --     -------------------------------------------------------
        --         local old_ret = old_MakeRecipe(self,origin_recipe,...)
        --         if old_ret then
        --             inst.components.hoshino_com_builder_blocker:DoDelta(-1)
        --         end
        --     -------------------------------------------------------
        --     return old_ret
        -- end
        inst:ListenForEvent("consumeingredients",function()
            inst.components.hoshino_com_builder_blocker:DoDelta(-1)
        end)

    end

    local function HookBuilderReplicaCom(inst)
        local replica_com = inst.replica.builder or inst.replica._.builder
        local old_HasIngredients = replica_com.HasIngredients
        replica_com.HasIngredients = function(self,origin_recipe)
            -------------------------------------------------------
            --- 检查函数
                local recipe = origin_recipe
                if type(recipe) == "string" then
                    recipe = GetValidRecipe(recipe)
                end
                if CheckCanStartChecker(recipe) and not inst.replica.hoshino_com_builder_blocker:CanBuild() then
                    return false
                end
            -------------------------------------------------------
            return old_HasIngredients(self,origin_recipe)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_builder_blocker = Class(function(self, inst)
    self.inst = inst


    self.daily_origin_max = 4000000000 --每日最大次数
    self.daily_max = self.daily_origin_max
    self.count = self.daily_origin_max --每日计数

    self.___net_count = net_uint(inst.GUID,"hoshino_com_builder_blocker_count","hoshino_com_builder_blocker_update")
    inst:ListenForEvent("hoshino_com_builder_blocker_update",function()
        self:SetCount(self.___net_count:value())
        inst:PushEvent("refreshcrafting")
    end)

    ------------------------------------------------------------------------------------------
    --- hook master 和 client
        inst:DoTaskInTime(0,function()            
            if inst.components.builder then
                HookBuilderCom(inst)
            end
            if inst.replica.builder or inst.replica._.builder then
                HookBuilderReplicaCom(inst)
            end
        end)
    ------------------------------------------------------------------------------------------
    --- 每日重置
    ------------------------------------------------------------------------------------------

end)

------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_builder_blocker:SetCount(value)
        value = math.clamp(value,0,self.daily_max)
        if TheWorld.ismastersim then
            self.___net_count:set(value)
        end
        self.count = value
    end
------------------------------------------------------------------------------------------------------------------------------
--- 
    function hoshino_com_builder_blocker:CanBuild()
        return self.count > 0
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_builder_blocker







