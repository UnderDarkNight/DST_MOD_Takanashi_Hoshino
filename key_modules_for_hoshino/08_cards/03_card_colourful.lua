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
    --- 测试用的空白卡
        -- ["test_card_colourful"] = {
        --     back = "card_colourful",
        --     front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
        --     test = function(inst)
        --         return true
        --     end,
        --     fn = function(inst)
        --         print("test_card_colourful")
        --     end,
        --     text = function(inst)
        --         return "测试用的空彩卡"
        --     end,
        -- },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 53、【彩】【并非钨合金棍】【最终血量扣除结算的时候，所扣除点数减少1点】（未超过一点则免疫，选择后从池子内移除，无法叠加）【笔记】按照可叠加的形式写
        ["final_health_down_value_reduce"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
            test = function(inst)
                -- return inst.components.hoshino_com_debuff:Get_Health_Down_Reduce() == 0
                return true
            end,
            fn = function(inst)
               inst.components.hoshino_com_debuff:Add_Health_Down_Reduce(1)
            end,
            text = function(inst)
                return "【并非钨合金棍】\n血量扣除时，扣除点数减少1点"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 54、【彩】【我已膨胀】【三维+300/300/300，基础攻击力倍增器2（2倍原始基础伤害，不算卡牌加成），受伤倍增器0.2（80%减伤）】【此后无法再获取经验】【选择之后从卡池移除】
        ["i_have_expanded"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_i_have_expanded"
                return inst:GetDebuff(debuff_prefab) == nil
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_i_have_expanded"
                inst.components.hoshino_com_debuff:Add_Buff_Memory(debuff_prefab,debuff_prefab,true)
                inst.components.hoshino_com_debuff:Add_Max_Helth(300)
                inst.components.health:DoDelta(300)
                inst.components.hoshino_com_debuff:Add_Max_Sanity(300)
                inst.components.hoshino_com_debuff:Add_Max_Hunger(300)

                inst.components.health:ForceUpdateHUD(true)
            end,
            text = function(inst)
                return " \n【我已膨胀】 三维+300/300/300\n基础攻击力X2\n防御力+80%，你无法再获取经验"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 55、【彩】【照我以火】【击杀任意生物会产生半径6伤害200的爆炸，被爆炸炸死的也一样触发】【从卡池移除】
        ["kill_and_explode"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_kill_and_explode"
                return inst:GetDebuff(debuff_prefab) == nil
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_kill_and_explode"
                inst.components.hoshino_com_debuff:Add_Buff_Memory(debuff_prefab,debuff_prefab,true)
            end,
            text = function(inst)
                return "【照我以火】 击杀任意生物会产生半径8，伤害200的爆炸\n被爆炸击杀的单位也一样触发"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 56、【彩】【每次升级额外获得一包「升级卡包」，同时每次升级 10%概率获得随机诅咒】【不可叠加，选择后从卡组移除】
        ["level_up_and_double_card_pack"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_level_up_and_double_card_pack"
                return inst:GetDebuff(debuff_prefab) == nil
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_level_up_and_double_card_pack"
                inst.components.hoshino_com_debuff:Add_Buff_Memory(debuff_prefab,debuff_prefab,true)
            end,
            text = function(inst)
                return "【神秘解放】 每次升级额外获得一个「神秘核心」\n同时每次升级 10%概率获得随机诅咒"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 58、【彩】【绝对防御】【每10s内，受到的总【血量扣除值】超过20以后，变成0】【从卡池移除】
        ["absolute_defense"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_absolute_defense"
                return inst:GetDebuff(debuff_prefab) == nil
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_absolute_defense"
                inst.components.hoshino_com_debuff:Add_Buff_Memory(debuff_prefab,debuff_prefab,true)
            end,
            text = function(inst)
                return "【绝对防御】\n每5s，血量扣除总额不超过最大生命值的20%"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 59、【彩】【金色传说】【赠送5包金色的1选1】
        ["the_golden_legend"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                for i = 1, 5, 1 do
                    local item = SpawnPrefab("hoshino_item_cards_pack")
                    item:PushEvent("Set",{
                        cards = {
                            "card_golden",
                        },
                    })
                    item:PushEvent("SetName","Golden 1-1")
                    inst.components.inventory:GiveItem(item)
                end
            end,
            text = function(inst)
                return "【金色传说】 赠送5包金色的1选1"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 60、【彩】【壁垒】【受到攻击后，获得一个10s的铥矿冒效果，效果持续期间，攻击伤害的1%转换为玩家血量】【吸血叠加】
        ["ruins_sheild_and_vengeance"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                if inst.components.hoshino_com_debuff:Add("hoshino_card_debuff_ruins_sheild_and_vengeance",0.05) > 1 then
                    inst.components.hoshino_com_debuff:Set("hoshino_card_debuff_ruins_sheild_and_vengeance",1)
                end
                local debuff_prefab = "hoshino_card_debuff_ruins_sheild_and_vengeance"
                inst.components.hoshino_com_debuff:Add_Buff_Memory(debuff_prefab,debuff_prefab,true)
            end,
            text = function(inst)
                return " \n【壁垒】 受到攻击后，获得一个6s的护盾\n效果持续期间，敌人伤害的5%转换为玩家血量\n重复选择吸血百分比叠加"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【彩】【虚空之喉】每当玩家进行一次攻击动作，获得一个围绕在玩家周围（半径为4.5）的，持续3s的黑圈，触碰到黑圈的敌人每0.05s受到15真实伤害（受攻击倍率影响，无伤害来源），且被黑圈杀死的敌人有3%的概率给予玩家一层【爆炸护盾】【重复选择伤害和概率叠加】
        ["void_throat"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_void_throat","hoshino_card_debuff_void_throat",true)
            end,
            text = function(inst)
                return "【虚空之喉】每当玩家进行一次攻击动作，获得一个围绕在玩家周围（半径为4.5）的，持续3s的黑圈，触碰到黑圈的敌人每0.05s受到15真实伤害（受攻击倍率影响，无伤害来源），且被黑圈杀死的敌人有3%的概率给予玩家一层【爆炸护盾】【重复选择伤害和概率叠加】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【彩】【混沌】使你的所有卡牌权重变为相等
        ["chaos"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local CardPools = {
                    ["card_white"] = 100,
                    ["card_colourful"] = 100,
                    ["card_golden"] = 100,
                    ["card_black"] = 100,
                }
                for card_type, value in pairs(CardPools) do
                    inst.components.hoshino_cards_sys:Card_Pool_Set(card_type,value)
                end
            end,
            text = function(inst)
                return "【混沌】使你的所有卡牌权重变为相等"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【彩】【献祭】杀死你的所有随从，并获得等量一选一金色卡包
        ["sacrifice"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                if inst.components.leader == nil then
                    return
                end
                local function GiveItem()
                    local item = SpawnPrefab("hoshino_item_cards_pack")
                    item:PushEvent("Set",{
                            cards = {
                                "card_golden",    
                            },
                        }
                    )
                    inst.components.inventory:GiveItem(item)
                end
                for follower, flag in pairs(inst.components.leader.followers) do
                    if follower and follower:IsValid() and follower.components.health and not follower.components.health:IsDead() then
                        follower.components.health:Kill()
                        inst:DoTaskInTime(0.5,function()
                            if follower.components.health and follower.components.health:IsDead() then
                                GiveItem()
                            end
                        end)
                    end
                end
            end,
            text = function(inst)
                return "【献祭】杀死你的所有随从，并获得等量一选一金色卡包"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【彩】 【裁定】此后被回收的卡牌将从卡组中移除，且返还信用点（白卡100 金卡500 彩卡2000）    【选择之后从卡组移除】
        ["judgment"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_judgment") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_judgment","hoshino_card_debuff_judgment",true)
            end,
            text = function(inst)
                return "【裁定】此后被回收的卡牌将从卡组中移除（黑卡不算数、不移除）。\n每张卡返还信用点（白卡100 金卡500 彩卡2000）\n【选择之后从卡组移除】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【彩】【命途不止】 当你死亡时，免疫死亡事件，并把生命恢复到1，上述效果持续10s，cd3min   【选择后从卡组移除】
        ["fate_continues"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_colourful.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_fate_continues") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_fate_continues","hoshino_card_debuff_fate_continues",true)
            end,
            text = function(inst)
                return "【命途不止】 当你死亡时，免疫死亡事件，并把生命恢复到1，上述效果持续10s，cd3min   【选择后从卡组移除】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

}

TUNING.HOSHINO_CARDS_DATA_AND_FNS_WARNING = TUNING.HOSHINO_CARDS_DATA_AND_FNS_WARNING or {}
for card_name,data in pairs(cards) do
    if TUNING.HOSHINO_CARDS_DATA_AND_FNS[card_name] ~= nil then
        table.insert(TUNING.HOSHINO_CARDS_DATA_AND_FNS_WARNING,card_name)
    end
    TUNING.HOSHINO_CARDS_DATA_AND_FNS[card_name] = data
    --- 自动插入卡牌正面
    local front_data = data.front
    local atlas = front_data.atlas
    local image = front_data.image
    if atlas ~= "images/inspect_pad/page_level_up.xml" then
        table.insert(Assets, Asset("ATLAS", atlas )     )
        table.insert(Assets, Asset("IMAGE", "images/inspect_pad/"..image ) )
    end
end