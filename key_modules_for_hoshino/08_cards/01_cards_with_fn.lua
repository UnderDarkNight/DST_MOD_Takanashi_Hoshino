--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    卡牌相关参数和执行函数

    只有4种卡牌: card_black , card_colourful , card_golden , card_white
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local cards = {

    --------------------------------------------------------------------------------
    -- 白：生命上限+15
        {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Max_Helth(15)
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：san上限+10
        {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Max_Sanity(10)
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：饥饿上限+8
        {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Max_Hunger(8)
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：移速+0.02
        {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Speed_Mult(0.02)
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：攻击伤害倍率+0.04
        {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Damage_Mult(0.04)
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：立刻获得0.1攻击倍率，但是在接下来两天内每次失去san时会流失等量生命
        {
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
        },
    --------------------------------------------------------------------------------
    -- 白：饥饿降低速率降低3%（上限30%，满了之后不再出现）
        {
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
        },
    --------------------------------------------------------------------------------
    -- 白：经验值获取速率提升10%
        {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Exp_Mult(0.1)
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：随机获得一项原版boss掉落物
        {
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
        },
    --------------------------------------------------------------------------------
    -- 白：随机召唤一个非boss生物
        {
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
        },
    --------------------------------------------------------------------------------
    -- 白：每次受到攻击时，对伤害来源造成3点伤害（可叠堆）。
        {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Counter_Damage(3)
            end,
        },
    --------------------------------------------------------------------------------
    -- 白：使用荷鲁斯之眼(专属武器)时有5%的概率不消耗耐久（最高100%）
        {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:TheEyeOfHorus_Finiteuses_Down_Block(0.05)
            end,
        },
    --------------------------------------------------------------------------------


}

TUNING.HOSHINO_CARDS_DATA_AND_FNS = cards