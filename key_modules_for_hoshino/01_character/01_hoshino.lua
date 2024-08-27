------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    角色基础初始化

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local function Language_check()
    local language = "en"
    if type(TUNING["hoshino.Language"]) == "function" then
        language = TUNING["hoshino.Language"]()
    elseif type(TUNING["hoshino.Language"]) == "string" then
        language = TUNING["hoshino.Language"]
    end
    return language
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色立绘大图
    GLOBAL.PREFAB_SKINS["hoshino"] = {
        "hoshino_none",
    }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色选择时候都文本
    if Language_check() == "ch" then
        -- The character select screen lines  --人物选人界面的描述
        STRINGS.CHARACTER_TITLES["hoshino"] = "小鸟游星野"
        STRINGS.CHARACTER_NAMES["hoshino"] = "小鸟游星野"
        STRINGS.CHARACTER_DESCRIPTIONS["hoshino"] = "XXXXXXXX"
        STRINGS.CHARACTER_QUOTES["hoshino"] = "XXXXXXXX"

        -- Custom speech strings  ----人物语言文件  可以进去自定义
        -- STRINGS.CHARACTERS[string.upper("hoshino")] = require "speech_hoshino"

        -- The character's name as appears in-game  --人物在游戏里面的名字
        STRINGS.NAMES[string.upper("hoshino")] = "小鸟游星野"
        STRINGS.SKIN_NAMES["hoshino_none"] = "小鸟游星野"  --检查界面显示的名字

        --生存几率
        STRINGS.CHARACTER_SURVIVABILITY["hoshino"] = "特别容易"
    else
        -- The character select screen lines  --人物选人界面的描述
        STRINGS.CHARACTER_TITLES["hoshino"] = "Takanashi Hoshino"
        STRINGS.CHARACTER_NAMES["hoshino"] = "Takanashi Hoshino"
        STRINGS.CHARACTER_DESCRIPTIONS["hoshino"] = "XXXXXXXX"
        STRINGS.CHARACTER_QUOTES["hoshino"] = "XXXXXXXX"

        -- Custom speech strings  ----人物语言文件  可以进去自定义
        -- STRINGS.CHARACTERS[string.upper("hoshino")] = require "speech_hoshino"

        -- The character's name as appears in-game  --人物在游戏里面的名字
        STRINGS.NAMES[string.upper("hoshino")] = "Takanashi Hoshino"
        STRINGS.SKIN_NAMES["hoshino_none"] = "Takanashi Hoshino"  --检查界面显示的名字

        --生存几率
        STRINGS.CHARACTER_SURVIVABILITY["hoshino"] = "easy"

    end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------增加人物到mod人物列表的里面 性别为女性（ MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL）
    AddModCharacter("hoshino", "FEMALE")

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----选人界面人物三维显示
    TUNING[string.upper("hoshino").."_HEALTH"] = 150
    TUNING[string.upper("hoshino").."_HUNGER"] = 150
    TUNING[string.upper("hoshino").."_SANITY"] = 150
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----选人界面初始物品显示，物品相关的prefab
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT[string.upper("hoshino")] = {"log"}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
