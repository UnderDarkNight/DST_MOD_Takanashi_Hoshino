



--------- 添加活动tag给指定的 prefab，不能大写。 制作栏 左上角 的图标 和 鼠标过去的文字
PROTOTYPER_DEFS["hoshino_building_millennium_tactics_delegate_terminal"] = {      ----- 必须是 prefab 的名字
    icon_atlas = "images/map_icons/hoshino_building_millennium_tactics_delegate_terminal.xml", 
    icon_image = "hoshino_building_millennium_tactics_delegate_terminal.tex",	
    is_crafting_station = true,
    -- action_str = "TRADE",  --- 相关参数 参考 recipes.lua
    filter_text = "千年战术委托终端"
} -- 正常

----------------------------------------------------------------------------------------
RECIPETABS[string.upper("millennium_tactics_delegate_terminal")] = { 
    str = string.upper("millennium_tactics_delegate_terminal"),
    sort = 999, 
    icon_atlas = "images/map_icons/hoshino_building_millennium_tactics_delegate_terminal.xml", 
    icon_image = "hoshino_building_millennium_tactics_delegate_terminal.tex",	
    crafting_station = true,
    shop = true
}
----------------------------------------------------------------------------------------
local TechTree = require("techtree")
TechTree.Create_____npc_old = TechTree.Create
TechTree.Create = function(t)
	t = t or {}
	for i, v in ipairs(TechTree.AVAILABLE_TECH) do
	    t[v] = t[v] or 0
	end
	return t
end

table.insert(TechTree.AVAILABLE_TECH,string.upper("millennium_tactics_delegate_terminal")) ---- 添加到科技树
table.insert(TechTree.BONUS_TECH,string.upper("millennium_tactics_delegate_terminal")) ---- 有奖励的科技树

-------------------- 科技参数
TECH.NONE[string.upper("millennium_tactics_delegate_terminal")] = 0
TECH[string.upper("millennium_tactics_delegate_terminal_one")] = {
    [string.upper("millennium_tactics_delegate_terminal")] = 1,
}
for k,v in pairs(TUNING.PROTOTYPER_TREES) do    ---------- 给其他标签注入0参数
    v[string.upper("millennium_tactics_delegate_terminal")] = 0
end

TUNING.PROTOTYPER_TREES[string.upper("millennium_tactics_delegate_terminal")] = TechTree.Create({   ---- 靠近inst 的时候触发科技树标记位切换
    [string.upper("millennium_tactics_delegate_terminal")] = 1,
})

------- 给其他的添加科技类别 --- TECH.NONE  ---- 这个可能就是 builder_replica 造成崩溃的原因
for i, v in pairs(AllRecipes) do
	if v.level[string.upper("millennium_tactics_delegate_terminal")] == nil then
		v.level[string.upper("millennium_tactics_delegate_terminal")] = 0
	end
end
TechTree.Create = TechTree.Create_____npc_old
TechTree.Create_____npc_old = nil






local function GetTech()
    return TECH[string.upper("millennium_tactics_delegate_terminal_one")]
end
local function GetRecipeFilter()
    return {string.upper("millennium_tactics_delegate_terminal")}
end


local function GetTech()
    return TECH[string.upper("millennium_tactics_delegate_terminal_one")]
end
local function GetRecipeFilter()
    return {string.upper("millennium_tactics_delegate_terminal")}
end

local function CustomAddRecipe2(prefab,_Ingredients,tech,data,recipe_filters)
    data.nounlock = true            -- 去自制科技树必须
    data.no_deconstruction = true   -- 去自制科技树必须
    data.station_tag = nil
    tech = GetTech()
    _Ingredients = _Ingredients or {}
    recipe_filters = GetRecipeFilter()
    AddRecipe2(prefab,_Ingredients,tech,data,recipe_filters)
end

--[[

        local items_in_shop_filer = {}  ---------- 用来清除多余的，不是本模组的东西
        local function Add_Recipe_To_Shop_Filter(_table)
            -- _table = {
            --     prefab = "log",
            --     NAME = "木头",
            --     RECIPE_DESC = "9999++++",
            --     Ingredients = { Ingredient("goldnugget", 100) },
            --     configs = {
            --         atlas = "images/inventoryimages/npc_item_goldnugget_coin.xml",
            --         image = "npc_item_goldnugget_coin.tex",
            --     }
            -- }
            if _table.NAME then    -- -- 制造栏里展示的名字
                GLOBAL.STRINGS.NAMES[string.upper(_table.prefab)] = _table.NAME
            end
            if _table.RECIPE_DESC then  -- --  制造栏里展示的说明
                STRINGS.RECIPE_DESC[string.upper(_table.prefab)] = _table.RECIPE_DESC
            end
            AddRecipeToFilter(_table.prefab,string.upper("intermediary_pigman_shop"))   --- 添加到指定栏目
            AddRecipe2(
                _table.prefab,            --  --  inst.prefab  实体名字
                _table.Ingredients or {}, 
                TECH[string.upper("intermediary_pigman_shop_one")], --- TECH.NONE
                {
                    nounlock=true,no_deconstruction=true,
                    -- min_spacing = 1,
                    builder_tag = "npc_tag_no_green_amulet",    --------- -- 【builder_tag】只给指定tag的角色能制造这件物品，角色添加/移除 tag 都能立马解锁/隐藏该物品
                    sg_state = "give",
                    actionstr = "CARNIVAL_HOSTSHOP",
                    atlas = _table.configs.atlas,
                    image = _table.configs.image,
                    placer = _table.configs.placer,
                },
                {string.upper("intermediary_pigman_shop")}
            )
            RemoveRecipeFromFilter(_table.prefab,"MODS")

            table.insert(items_in_shop_filer,_table.prefab)
        end


]]--