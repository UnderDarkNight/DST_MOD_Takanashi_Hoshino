if TUNING["hoshino.Strings"] == nil then
    TUNING["hoshino.Strings"] = {}
end

local this_language = "en"
if TUNING["hoshino.Language"] then
    if type(TUNING["hoshino.Language"]) == "function" and TUNING["hoshino.Language"]() ~= this_language then
        return
    elseif type(TUNING["hoshino.Language"]) == "string" and TUNING["hoshino.Language"] ~= this_language then
        return
    end
end

TUNING["hoshino.Strings"][this_language] = TUNING["hoshino.Strings"][this_language] or {
        --------------------------------------------------------------------
        --- 正在debug 测试的
            -- ["hoshino_skin_test_item"] = {
            --     ["name"] = "en皮肤测试物品",
            --     ["inspect_str"] = "en inspect单纯的测试皮肤",
            --     ["recipe_desc"] = " en 测试描述666",
            -- },        
        --------------------------------------------------------------------

}