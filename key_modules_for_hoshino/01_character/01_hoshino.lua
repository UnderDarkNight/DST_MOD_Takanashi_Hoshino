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
        STRINGS.CHARACTER_DESCRIPTIONS["hoshino"] = "阿拜多斯对策委员会会长\n废校危机结束后的旅行\n强大的适应与战斗能力\n在永恒大陆探寻更多神秘"
        STRINGS.CHARACTER_QUOTES["hoshino"] = "呼啊~摸鱼可是很重要的~"

        -- Custom speech strings  ----人物语言文件  可以进去自定义
        if not TUNING.HOSHINO_DEBUGGING_MODE then
            STRINGS.CHARACTERS[string.upper("hoshino")] = require("speech_hoshino")
        end

        -- The character's name as appears in-game  --人物在游戏里面的名字
        STRINGS.NAMES[string.upper("hoshino")] = "小鸟游星野"
        STRINGS.SKIN_NAMES["hoshino_none"] = "小鸟游星野"  --检查界面显示的名字

        --生存几率
        STRINGS.CHARACTER_SURVIVABILITY["hoshino"] = "旅行"
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
    TUNING[string.upper("hoshino").."_HEALTH"] = 200
    TUNING[string.upper("hoshino").."_HUNGER"] = 100
    TUNING[string.upper("hoshino").."_SANITY"] = 150
    -- if TUNING["hoshino.Config"].DIFFICULTY_MODE then
    --     TUNING[string.upper("hoshino").."_HEALTH"] = 250
    --     TUNING[string.upper("hoshino").."_HUNGER"] = 100
    --     TUNING[string.upper("hoshino").."_SANITY"] = 150
    -- else            
    --     TUNING[string.upper("hoshino").."_HEALTH"] = 450
    --     TUNING[string.upper("hoshino").."_HUNGER"] = 100
    --     TUNING[string.upper("hoshino").."_SANITY"] = 200
    -- end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----选人界面初始物品显示，物品相关的prefab
    -- TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT[string.upper("hoshino")] = {"log"}
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT[string.upper("hoshino")] = {}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
