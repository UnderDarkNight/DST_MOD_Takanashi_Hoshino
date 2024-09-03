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
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local cards = {

    --------------------------------------------------------------------------------
    -- 测试缺省卡牌
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
        ["test_card_colourful"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                print("test_card_colourful")
            end,
            text = function(inst)
                return "测试用的空彩卡"
            end,
        },
        ["test_card_golden"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                print("test_card_golden")
            end,
            text = function(inst)
                return "测试用的空金卡"
            end,
        },
        ["test_card_white"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                print("test_card_white")
            end,
            text = function(inst)
                return "测试用的空白卡"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：生命上限+15
        ["max_health_up_15"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Max_Helth(15)
            end,
            text = function(inst)
                return "生命上限+15"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：san上限+10
        ["max_sanity_up_10"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Max_Sanity(10)
            end,
            text = function(inst)
                return "san上限+10"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：饥饿上限+8
        ["max_hunger_up_8"] ={
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Max_Hunger(8)
            end,
            text = function(inst)
                return "饥饿上限+8"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：移速+0.02
        ["speed_up_2_percent"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Speed_Mult(0.02)
            end,
            text = function(inst)
                return "移速+2%"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：攻击伤害倍率+0.04
        ["damage_mult_up_4_percent"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Damage_Mult(0.04)
            end,
            text = function(inst)
                return "攻击伤害+4%"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：立刻获得0.1攻击倍率，但是在接下来两天内每次失去san时会流失等量生命
        ["damage_mult_up_10_percent_and_sanity_down"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Damage_Mult(0.1)
                local debuff_prefab = "hoshino_card_debuff_damage_mult_and_sanity"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
                inst.components.hoshino_data:Add(debuff_prefab,2*480) -- 上两天时间
            end,
            text = function(inst)
                return "攻击伤害+10%，接下来两天内每次失去san时会流失等量生命"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：饥饿降低速率降低3%（上限30%，满了之后不再出现）
        ["hunger_down_mult_down_3_percent"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                if inst.components.hoshino_com_debuff:Is_Hunger_Down_Mult_Max() then
                    return false
                end
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Hunger_Down_Mult(0.03)
            end,
            text = function(inst)
                return "饥饿降低速率降低3%"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：经验值获取速率提升10%
        ["exp_up_mult_up_10_percent"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Exp_Mult(0.1)
            end,
            text = function(inst)
                return "经验值获取速率提升10%"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：随机获得一项原版boss掉落物
        ["random_boss_item_drop"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local reward_prefab = {"dreadstone","purebrilliance","malbatross_beak","deerclops_eyeball","minotaurhorn",
                "bearger_fur","dragon_scales","shroom_skin","phlegm","steelwool","lavae_egg_cracked","spidereggsack",}
                local reward = reward_prefab[math.random(#reward_prefab)]
                local item = SpawnPrefab(reward)
                if item then
                    inst.components.inventory:GiveItem(item)
                end
            end,
            text = function(inst)
                return "随机获得一项原版boss掉落物"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：随机召唤一个非boss生物
        ["random_monster_recall"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local monsters = {
                    "pigman","pigguard","bunnyman","merm","mermguard","little_walrus","walrus",
                    "knight","bishop","rook","knight_nightmare","bishop_nightmare","rook_nightmare",
                    "spider","spider_warrior","spider_hider","spider_spitter","spider_dropper",
                    "spider_moon","spider_healer","spider_water","hound","firehound","icehound",
                    "mutatedhound","frog","lightninggoat","bee","killerbee","monkey",
                }
                local ret_monster = monsters[math.random(#monsters)]
                local monster_inst = SpawnPrefab(ret_monster)
                if monster_inst then
                    monster_inst.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
            end,
            text = function(inst)
                return "随机召唤一个非boss生物"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：每次受到攻击时，对伤害来源造成3点伤害（可叠堆）。
        ["counter_damage"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Counter_Damage(3)
            end,
            text = function(inst)
                return "每次受到攻击时，对伤害来源造成3点伤害"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：使用荷鲁斯之眼(专属武器)时有5%的概率不消耗耐久（最高100%）
        ["the_eye_of_horus_finiteuses_down_block"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_TheEyeOfHorus_Finiteuses_Down_Block_Percent() < 1
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:TheEyeOfHorus_Finiteuses_Down_Block(0.05)
            end,
            text = function(inst)
                return "使用荷鲁斯之眼时有5%的概率不消耗耐久"
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：受伤时有5%的概率不损失盔甲耐久（最高100%）
        ["armor_down_blocker_percent"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_Armor_Down_Blocker_Percent() < 1
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Armor_Down_Blocker_Percent(0.05)
            end,
            text = function(inst)
                return "受伤时有5%的概率不损失盔甲耐久"
            end,
        },
    --------------------------------------------------------------------------------
    -- 【白】【防暴盾牌】【获得1点位面防御】【可叠加】
        ["armor_planar_defense"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Planar_Defense(1)
            end,
            text = function(inst)
                return "获得1点位面防御"
            end,
        },
    --------------------------------------------------------------------------------
    -- 【金】【抵抗】各个阵营伤害防御 + 20%（暗影阵营、月亮阵营）
        ["armor_damage_type_resist"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_Damage_Type_Resist() ~= 0
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Damage_Type_Resist(0.2)
                inst:PushEvent("hoshino_other_armor_item_param_refresh")
            end,
            text = function(inst)
                return "受到暗影、月亮阵营伤害减少20%"
            end,
        },
    --------------------------------------------------------------------------------
    -- 17、【白】【尤里卡】【获得一个随机物品蓝图】
        ["random_blueprint"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local item = SpawnPrefab("blueprint")
                inst.components.inventory:GiveItem(item)
            end,
            text = function(inst)
                return "获得一个随机物品蓝图"
            end,
        },
    --------------------------------------------------------------------------------
    -- 20、【白】【汲取】【从食物获取的「正向」三维x2的同时，增加厨子的挑食机制】【从卡池移除】
        ["warly_eater_modules_unlock"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return inst.components.hoshino_data:Get("Player_Unlocked_Warly_Eater_Modules") ~= true
            end,
            fn = function(inst)
                inst:PushEvent("player_unlocked_warly_eater_modules")
            end,
            text = function(inst)
                return "从食物获取的「正向」三维x2的同时，增加厨子的挑食机制"
            end,
        },
    --------------------------------------------------------------------------------
    -- 2、【诅咒】【消化不良】【从食物中获取的三维增加量减半，扣除的不减】【从诅咒池移除】
        -- ["eater_indigestion"] = {
        --     back = "card_black",
        --     front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
        --     test = function(inst)
        --         return inst.components.hoshino_data:Get("Player_Indigestion") ~= true
        --     end,
        --     fn = function(inst)
        --         inst:PushEvent("player_unlock_eater_indigestion")
        --     end,
        --     text = function(inst)
        --         return "从食物中获取的三维增加量减半，扣除的不减"
        --     end,
        -- },
    --------------------------------------------------------------------------------
    -- 21、【白】【巧匠】【每次制作物品的时候，有1%概率返还制作材料，最高50%】【满概率后从卡池移除】
        ["probability_of_returning_full_recipe"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_Probability_Of_Returning_Recipe() < 0.5
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Probability_Of_Returning_Recipe(0.01)
            end,
            text = function(inst)
                return "每次制作物品的时候，有1%概率返还制作材料，最高50%"
            end,
        },
    --------------------------------------------------------------------------------
    -- 25、【金】【星野的精算】【每天前3次制作返回一半的材料（向上取整，材料消耗1个的时候，直接返还1个）】【次数叠加】
        ["returning_half_recipe_by_count"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Returning_Recipe_By_Count(3)
            end,
            text = function(inst)
                return "每天前3次制作返回一半的材料"
            end,
        },
    --------------------------------------------------------------------------------
    -- 27、【金】【救命稻草】【获取一层buff：死亡瞬间随机传送一次，恢复10%血量。触发后消耗一层】【叠加buff层数】
        ["a_lifesaver"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Death_Snapshot_Protector(1)
            end,
            text = function(inst)
                return "获取一层buff：死亡瞬间随机传送一次，恢复10%血量。触发后消耗一层"
            end,
        },
    --------------------------------------------------------------------------------
    -- 28、【金】【刷新】【赠送卡组刷新次数20】【可叠加】
        ["cards_refresh_num"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:AddRefreshNum(20)
            end,
            text = function(inst)
                return "赠送卡组刷新次数20"
            end,
        },
    --------------------------------------------------------------------------------
    -- 19、【白】【好运】【金卡和彩卡的出现权重都+0.1】【可叠加】
        ["rare_cards_appearance_weight"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:Card_Pool_Delata("card_colourful",0.1)
                inst.components.hoshino_cards_sys:Card_Pool_Delata("card_golden",0.1)
            end,
            text = function(inst)
                return "金卡和彩卡的出现权重都+0.1"
            end,
        },
    --------------------------------------------------------------------------------
    -- 24、【金】【多多益善】【「升级卡包」选项+1，最高变成 5选1】【达到5选1的时候从卡池移除，小于的时候从新进卡池】
        ["more_default_selectting_cards"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return inst.components.hoshino_cards_sys:GetDefaultCardsNum() ~= 5
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:DefultCardsNum_Delta(1)
            end,
            text = function(inst)
                return "「升级卡包」选项+1，最高变成 5选1"
            end,
        },
    --------------------------------------------------------------------------------
    -- 26、【金】【精选】【每天便利店免费刷新次数+1】【不可叠加】【选择后从卡组移除】
        ["card_shop_refresh_count"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                if inst.components.hoshino_cards_sys:Add("card_shop_refresh_count",0) == 0 then
                    return true
                end
                return false
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:Add("card_shop_refresh_count",1)
                inst.components.hoshino_com_shop:RefreshDaily_Delta(1)
            end,
            text = function(inst)
                return "每天便利店免费刷新次数+1"
            end,
        },
    --------------------------------------------------------------------------------
    -- 29、【金】【焉知非福】【每次失去生命值的时候，获得10点「信用点」，持续2天】【时间叠加】
        ["buff_health_down_and_coins_up"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_data:Add("hoshino_card_debuff_health_down_and_coins_up",480*2) --- 计时器累加
                local buff_prefab = "hoshino_card_debuff_health_down_and_coins_up"  -- 用while上BUFF
                while true do
                    local buff_inst = inst:GetDebuff(buff_prefab)
                    if buff_inst and buff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(buff_prefab,buff_prefab)
                end
            end,
            text = function(inst)
                return "每次失去生命值的时候，获得10点「信用点」，持续2天"
            end,
        },
    --------------------------------------------------------------------------------
    -- 30、【金】【荷鲁斯的抗争】【立即获得8个「升级卡包」，「升级卡包」选项-1】【升级卡包变成1选1的时候从卡池移除，后续会重新进卡池】
        ["the_rsistance_of_horus"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                if inst.components.hoshino_cards_sys:GetDefaultCardsNum() == 1 then
                    return false
                end
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:DefultCardsNum_Delta(-1)
                for i = 1,8 do
                    inst.components.inventory:GiveItem(SpawnPrefab("hoshino_item_cards_pack"))
                end
            end,
            text = function(inst)
                return "立即获得8个「升级卡包」，「升级卡包」选项-1"
            end,
        },
    --------------------------------------------------------------------------------
    -- 31、【金】【我将富有】【立即获得9999「信用点」，同时获得诅咒「凡庸」】【从卡池移除】
        ["give_me_some_money"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_builder_blocker"
                for i = 1, 5, 1 do
                    local buff_inst = inst:GetDebuff(debuff_prefab)
                    if buff_inst and buff_inst:IsValid() then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_shop:CoinDelta(9999)
                local debuff_prefab = "hoshino_card_debuff_builder_blocker"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            text = function(inst)
                return "立即获得9999「信用点」，同时获得诅咒「凡庸」"
            end,
        },
    --------------------------------------------------------------------------------
    -- 33、【金】【寒暑不侵】【恒温5天】【叠加时间】
        ["card_temperature_locker"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_data:Add("hoshino_card_debuff_temperature_locker",5*480)
                local debuff_prefab = "hoshino_card_debuff_temperature_locker"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            text = function(inst)
                return "恒温5天"
            end,
        },
    --------------------------------------------------------------------------------
    -- 35、【金】【点金之手】【赠送1包金色3选1】
        ["hand_of_midas"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local item = SpawnPrefab("hoshino_item_cards_pack")
                item:PushEvent("Set",{
                    cards = {
                        "card_golden",
                        "card_golden",
                        "card_golden",
                    }
                })
                item:PushEvent("SetName","金色3选1")
                inst.components.inventory:GiveItem(item)
            end,
            text = function(inst)
                return "赠送1包金色3选1"
            end,
        },
    --------------------------------------------------------------------------------


}

TUNING.HOSHINO_CARDS_DATA_AND_FNS = cards