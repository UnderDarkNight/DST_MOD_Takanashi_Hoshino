--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    卡牌相关参数和执行函数

    只有4种卡牌: card_black , card_colourful , card_golden , card_white

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


}

TUNING.HOSHINO_CARDS_DATA_AND_FNS = cards