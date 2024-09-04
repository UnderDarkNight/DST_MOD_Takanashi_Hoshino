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
    --- 测试用的空金卡
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 24、【金】【多多益善】【「升级卡包」选项+1，最高变成 5选1】【达到5选1的时候从卡池移除，小于的时候从新进卡池】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 25、【金】【星野的精算】【每天前3次制作返回一半的材料（向上取整）】【次数叠加】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 26、【金】【精选】【每天便利店免费刷新次数+1】【不可叠加】【选择后从卡组移除】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 27、【金】【救命稻草】【获取一层buff：死亡瞬间随机传送一次，恢复10%血量。触发后消耗一层】【叠加buff层数】
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
                return "获取一层buff：\n死亡瞬间随机传送一次，恢复10%血量\n触发后消耗一层"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 28、【金】【刷新】【赠送卡组刷新次数20】【可叠加】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 29、【金】【焉知非福】【每次失去生命值的时候，获得10点「信用点」，持续2天】【时间叠加】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 30、【金】【荷鲁斯的抗争】【立即获得8个「升级卡包」，「升级卡包」选项-1】【升级卡包变成1选1的时候从卡池移除，后续会重新进卡池】
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 31、【金】【我将富有】【立即获得9999「信用点」，同时获得诅咒「凡庸」】【从卡池移除】
        ["give_me_some_money"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                if inst.components.hoshino_com_debuff:Get("golden_card_unlocked_give_me_some_money") then
                    return false
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
                inst.components.hoshino_com_debuff:Set("golden_card_unlocked_give_me_some_money",true)
            end,
            text = function(inst)
                return "立即获得9999「信用点」，同时获得诅咒「凡庸」"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 32、【金】【我必凯旋】【立即生成一只随机BOSS（列表形式），血量，攻击力是普通的3倍，击杀后获得3选1金色卡包】
        ["spawn_boss_with_golden_cards_pack"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local x,y,z = inst.Transform:GetWorldPosition()
                local monster_list = {
                                "bearger","mutatedbearger","deerclops","mutateddeerclops","spat",
                                "leif","leif_sparse","spiderqueen","warglet","warg","mutatedwarg"
                                }
                local ret_monster_prefab = monster_list[math.random(#monster_list)]
                local monster = SpawnPrefab(ret_monster_prefab or "hound")
                local debuff_prefab = "hoshino_card_debuff_for_monster_drop_cards_pack"
                while true do
                    local debuff_inst = monster:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    monster:AddDebuff(debuff_prefab,debuff_prefab)
                end
                monster.Transform:SetPosition(x,y,z)

                inst.components.hoshino_com_rpc_event:PushEvent("hoshino_event.inspect_hud_force_close")

            end,
            text = function(inst)
                return "立即生成一只随机BOSS\n血量、攻击力是普通的3倍\n击杀后获得3选1金色卡包"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 33、【金】【寒暑不侵】【恒温5天】【叠加时间】
        ["card_temperature_locker"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add("hoshino_card_debuff_temperature_locker",5*480)
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
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 34、【金】【七弦】【赠送7包结果注定一样的白色1选1卡包】
        ["7_identical_white_card_packs"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local card_name_index = inst.components.hoshino_cards_sys:SelectRandomCardFromPoolByType("card_white")
                for i = 1, 7, 1 do
                    local item = SpawnPrefab("hoshino_item_cards_pack")
                    item:PushEvent("Set",{cards = {card_name_index},})
                    item:PushEvent("SetName","White 1-1")
                    inst.components.inventory:GiveItem(item)
                end
            end,
            text = function(inst)
                return "赠送7包结果注定一样的白色1选1卡包"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 35、【金】【点金之手】【赠送1包金色3选1】
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
                item:PushEvent("SetName","Golden 3-1")
                inst.components.inventory:GiveItem(item)
            end,
            text = function(inst)
                return "赠送1包金色3选1"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 37、【金】【背水】【随机清空一项白卡能力（血、San、饥饿、移速、经验、攻击、护甲、反伤、位面防御），然后获得1500点「信用点」】
        ["get_some_coins_and_delete_one_white_card_ability"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local active_fns = {
                    [1] = function(inst) -- 血量
                        local origin_max_health = TUNING[string.upper("hoshino").."_HEALTH"]
                        local current_health = inst.components.health.currenthealth
                        if current_health > origin_max_health then
                            inst.components.health:SetMaxHealth(origin_max_health)
                        else
                            inst.components.health.maxhealth = origin_max_health
                            inst.components.health:DoDelta(1)
                        end
                    end,
                    [2] = function(inst) -- San值
                        local origin_max_sanity = TUNING[string.upper("hoshino").."_SANITY"]
                        local current_sanity = inst.components.sanity.current
                        if current_sanity > origin_max_sanity then
                            inst.components.sanity:SetMax(origin_max_sanity)
                        else
                            inst.components.sanity.max = origin_max_sanity
                            inst.components.sanity:DoDelta(1)
                        end
                    end,
                    [3] = function(inst) -- 饥饿
                        local origin_max_hunger = TUNING[string.upper("hoshino").."_HUNGER"]
                        local current_hunger = inst.components.hunger.current
                        if current_hunger > origin_max_hunger then
                            inst.components.hunger:SetMax(origin_max_hunger)
                        else
                            inst.components.hunger.max = origin_max_hunger
                            inst.components.hunger:DoDelta(1)
                        end
                    end,
                    [4] = function(inst) -- 移速
                        inst.components.hoshino_com_debuff:Set("speed_mult",0) -- 清除数据
                        inst.components.hoshino_com_debuff:Add_Speed_Mult(0) -- 刷新倍增器参数
                    end,
                    [5] = function(inst) -- 经验
                        inst.components.hoshino_com_debuff:Set("exp_up_mult",0)
                    end,
                    [6] = function(inst) -- 攻击
                        inst.components.hoshino_com_debuff:Set("damage_mult",0)
                        inst.components.hoshino_com_debuff:Add_Damage_Mult(0)
                    end,
                    [7] = function(inst) -- 阵营减伤
                        inst.components.hoshino_com_debuff:Add_Damage_Type_Resist(-100)
                    end,
                    [8] = function(inst) -- 反伤
                        inst.components.hoshino_com_debuff:Set("counter_damage",0)
                    end,
                    [9] = function(inst) -- 位面防御
                        local current = inst.components.hoshino_com_debuff:Add("planar_defense_value",0)
                        inst.components.hoshino_com_debuff:Add("planar_defense_value",-current)
                    end,
                }
                local ret_fn = active_fns[math.random(#active_fns)]
                if ret_fn then
                    ret_fn(inst)
                end
                inst.components.hoshino_com_shop:CoinDelta(1500)
            end,
            text = function(inst)
                return "获得1500点「信用点」\n随机清空一项白卡能力:\n血、San、饥饿、移速、经验、攻击、阵营减伤、反伤、位面防御"
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