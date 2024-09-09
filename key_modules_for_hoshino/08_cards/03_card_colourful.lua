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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 53、【彩】【钨合金棍】【最终血量扣除结算的时候，所扣除点数减少1点】（未超过一点则免疫，选择后从池子内移除，无法叠加）【笔记】按照可叠加的形式写
        ["final_health_down_value_reduce"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                -- return inst.components.hoshino_com_debuff:Get_Health_Down_Reduce() == 0
                return true
            end,
            fn = function(inst)
               inst.components.hoshino_com_debuff:Add_Health_Down_Reduce(1)
            end,
            text = function(inst)
                return "最终血量扣除结算的时候，所扣除点数减少1点"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 54、【彩】【我已膨胀】【三维+300/300/300，基础攻击力倍增器2（2倍原始基础伤害，不算卡牌加成），受伤倍增器0.2（80%减伤）】【此后无法再获取经验】【选择之后从卡池移除】
        ["i_have_expanded"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_i_have_expanded"
                for i = 1, 5, 1 do
                    local buff_inst = inst:GetDebuff(debuff_prefab)
                    if buff_inst and buff_inst:IsValid() then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_i_have_expanded"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
                inst.components.hoshino_com_debuff:Add_Max_Helth(300)
                inst.components.hoshino_com_debuff:Add_Max_Sanity(300)
                inst.components.hoshino_com_debuff:Add_Max_Hunger(300)

            end,
            text = function(inst)
                return "三维+300/300/300\n基础攻击力X2\n基础伤害减免80%"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 55、【彩】【照我以火】【击杀任意生物会产生半径12伤害200的爆炸，被爆炸炸死的也一样触发】【从卡池移除】
        ["kill_and_explode"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_kill_and_explode"
                for i = 1, 5, 1 do
                    local buff_inst = inst:GetDebuff(debuff_prefab)
                    if buff_inst and buff_inst:IsValid() then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_kill_and_explode"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            text = function(inst)
                return "击杀任意生物会产生半径12伤害200的爆炸\n被爆炸炸死的也一样触发"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 56、【彩】【每次升级额外获得一包「升级卡包」，同时每次升级 20%概率获得随机诅咒】【不可叠加，选择后从卡组移除】
        ["level_up_and_double_card_pack"] = {
            back = "card_colourful",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_level_up_and_double_card_pack"
                for i = 1, 5, 1 do
                    local buff_inst = inst:GetDebuff(debuff_prefab)
                    if buff_inst and buff_inst:IsValid() then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_level_up_and_double_card_pack"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            text = function(inst)
                return "每次升级额外获得一包「升级卡包」\n同时每次升级 20%概率获得随机诅咒"
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