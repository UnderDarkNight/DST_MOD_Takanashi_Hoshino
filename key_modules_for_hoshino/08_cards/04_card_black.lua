--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    卡牌相关参数和执行函数

    只有4种卡牌: card_black , card_colourful , card_golden , card_white  ， 【诅咒】 curse - card_black

    所有函数均在 server 上执行。和client端无关

    卡牌参数:
    ["卡牌名称"] = {
        back = "卡牌背景",
        front = {atlas = "卡牌正面图集" ,image = "卡牌正面图"},
        test = function(inst)   end,    --- 卡牌是否可使用
        fn = function(inst)     end,    --- 卡牌执行函数
        text = function(inst)   end,    --- 卡牌描述    
    }
        
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 表格初始化
    Assets = Assets or {}
    TUNING.HOSHINO_CARDS_DATA_AND_FNS =  TUNING.HOSHINO_CARDS_DATA_AND_FNS or {}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local cards = {
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 测试用的空黑卡
            ["test_card_black"] = {
                back = "card_black",
                front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
                test = function(inst)
                    return true
                end,
                fn = function(inst)
                    print("test_card_black")
                end,
                text = function(inst)
                    return "测试用的空黑卡"
                end,
            },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 1、【诅咒】【依神紫苑】【你每天至多获得300信用点】【从诅咒池移除】
        ["max_daily_earn"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                if inst.components.hoshino_com_shop:Get("card_black_active.max_daily_earn") then
                    return false
                end
                return true
            end,
            fn = function(inst)
                inst:PushEvent("card_black_active.max_daily_earn")
            end,
            text = function(inst)
                return "你每天至多获得300信用点"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 2、【诅咒】【消化不良】【从食物中获取的三维增加量减半，扣除的不减】【从诅咒池移除】
        ["eater_indigestion"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return inst.components.hoshino_data:Get("Player_Indigestion") ~= true
            end,
            fn = function(inst)
                inst:PushEvent("player_unlock_eater_indigestion")
            end,
            text = function(inst)
                return "从食物中获取的三维增加量减半，扣除的不减"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 3、【诅咒】【噩梦】【无法通过睡觉恢复生命值】【从诅咒池移除】
        ["sleeping_bag_health_blocker"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                if inst.components.hoshino_cards_sys:Get("card_black.sleeping_bag_health_blocker") then
                    return false
                end
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:Set("card_black.sleeping_bag_health_blocker",true)
            end,
            text = function(inst)
                return "从食物中获取的三维增加量减半，扣除的不减"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


}


for card_name,data in pairs(cards) do
    TUNING.HOSHINO_CARDS_DATA_AND_FNS[card_name] = data
    --- 自动插入卡牌正面
    local front_data = data.front
    local atlas = front_data.atlas
    local image = front_data.image

    table.insert(Assets, Asset("ATLAS", atlas )     )
    table.insert(Assets, Asset("IMAGE", "images/inspect_pad/"..image ) )
end