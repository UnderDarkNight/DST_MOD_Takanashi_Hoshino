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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 1、【白】【生命值上限+15】【可叠加】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 2、【白】【San上限+10】【可叠加】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 3、【白】【饥饿值上限+8】【可叠加】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 4、【白】【移动速度+2%】【可叠加】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 5、【白】【基础攻击伤害+4%】【可叠加】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 6、【白】【饥饿自然掉速-3%，最高-30%】【达到最高后从卡池移除】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 7、【白】【日积月累】【经验获取增加10%】【可叠加】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 8、【白】【好东西！】【随机获得一个BOSS掉落物（列表形式）】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 9、【白】【神秘仪式】【随机召唤一只怪物（列表形式）】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 10、【白】【透支】【根据当前剩余未选择的卡牌数量，给玩家N张1选1卡包，包括颜色对应，下三次升级不再赠送升级卡包。如果当前未翻开的剩余卡牌数量为0，则重新赠送一包1选1卡包】
        ["overdraft"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                
                local current_cards_data = inst.components.hoshino_cards_sys.cards_data     --- 获取当前卡组数据。
                local ret_cards_type = {}
                local same_overdraft_card_blocker = false
                for index , single_card_data in pairs(current_cards_data) do
                    local current_card_name_index = single_card_data.card_name
                    -- print("+++ overdraft +++",current_card_name_index)
                    local current_card_type = inst.components.hoshino_cards_sys:GetCardTypeByName(current_card_name_index) or "card_white"
                    --- 得处理选择组里有多张 overdraft 。
                    -- if current_card_name_index ~= "overdraft" then
                    --     table.insert(ret_cards_type,current_card_type)
                    -- end
                    if current_card_name_index == "overdraft" then  --- 只屏蔽一张 overdraft
                        if same_overdraft_card_blocker == false then
                            same_overdraft_card_blocker = true
                        else
                            table.insert(ret_cards_type,current_card_type)
                        end
                    else
                        table.insert(ret_cards_type,current_card_type)
                    end                            
                    
                end
                --- 如果当前卡组只有1张卡，赠送额外一张白卡包
                if #ret_cards_type == 0 then
                    ret_cards_type = {"card_white"}
                end

                --- 生成物品给玩家
                for k, temp_card_type in pairs(ret_cards_type) do
                    local item = SpawnPrefab("hoshino_item_cards_pack")
                    item:PushEvent("Set",{ cards = {temp_card_type} })
                    inst.components.inventory:GiveItem(item)
                end
                --- 上屏蔽器
                inst.components.hoshino_com_debuff:Add("level_up_card_pack_gift_blocker",3)
            end,
            text = function(inst)
                return "根据当前剩余未选择的卡牌数量，给玩家N张 1选1卡包。\n包括颜色对应。下三次升级不再赠送升级卡包"
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