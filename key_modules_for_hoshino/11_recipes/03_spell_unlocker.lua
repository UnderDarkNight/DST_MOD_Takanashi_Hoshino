
local function CustomAddRecipe2(prefab,_Ingredients,tech,data,recipe_filters)
    TUNING.HOSHINO_TECH_ADD_RECIPE(prefab,_Ingredients,tech,data,recipe_filters)
end


local all_spell_names = {
    ["gun_eye_of_horus_ex"] = {Ingredient("hoshino_item_cards_pack", 5)},
    ["swimming_ex_support"] = {Ingredient("hoshino_item_cards_pack", 5)},
    ["normal_heal"] = {Ingredient("hoshino_item_cards_pack", 3)},
    ["normal_covert_operation"] = {Ingredient("hoshino_item_cards_pack", 3)},
    ["swimming_emergency_assistance"] = {Ingredient("hoshino_item_cards_pack", 3)},
    ["swimming_dawn_of_horus"] = {Ingredient("hoshino_item_cards_pack", 3)},
}

for spell_name,_Ingredients in pairs(all_spell_names) do
    local spell_prefab = "hoshino_spell_unlock_" .. spell_name
    -- print("Info Creating recipe for ", spell_prefab)
    CustomAddRecipe2(
    spell_prefab,
    _Ingredients,
    TECH.NONE,
    {
        -- nounlock=true,
        no_deconstruction=false,
        builder_tag = "hoshino",    
        atlas = "images/inventoryimages/"..spell_prefab..".xml",
        image = spell_prefab .. ".tex",
        canbuild = function(recipe,inst)
            if inst:HasTag("hoshino") and not inst.replica.hoshino_com_spell_cd_timer:Is_Spell_Unlocked(spell_name) then
                return true
            end
            return false
        end
    },
    {"CHARACTER",}
    )
    RemoveRecipeFromFilter(spell_prefab,"MODS")                       -- -- 在【模组物品】标签里移除这个。

end