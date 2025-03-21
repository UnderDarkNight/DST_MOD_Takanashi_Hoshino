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
        -- ["test_card_golden"] = {
        --     back = "card_golden",
        --     front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
        --     test = function(inst)
        --         return true
        --     end,
        --     fn = function(inst)
        --         print("test_card_golden")
        --     end,
        --     text = function(inst)
        --         return "测试用的空金卡"
        --     end,
        -- },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 24、【金】【多多益善】【「升级卡包」选项+1，最高变成 5选1】【达到5选1的时候从卡池移除，小于的时候从新进卡池】
        ["more_default_selectting_cards"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst.components.hoshino_cards_sys:GetDefaultCardsNum() ~= 5
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:DefultCardsNum_Delta(1)
            end,
            text = function(inst)
                return "【多多益善】「神秘核心」选项+1，最高变成 5选1"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 25、【金】【星野的精算】【每天前3次制作返回一半的材料（向下取整）】【次数叠加】
        ["returning_half_recipe_by_count"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Returning_Recipe_By_Count(1)
            end,
            text = function(inst)
                return "【星野的精算】\n每天第一次制作返回一半的材料，向下取整"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 26、【金】【精选】【每天便利店免费刷新次数+1】【不可叠加】【选择后从卡组移除】
        ["card_shop_refresh_count"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
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
                return "【精选】 每天便利店免费刷新次数+1"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 27、【金】【救命稻草】【获取一层buff：死亡瞬间随机传送一次，恢复10%血量。触发后消耗一层】【叠加buff层数】
        ["a_lifesaver"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Death_Snapshot_Protector(1)
            end,
            text = function(inst)
                return " \n【救命稻草】 获取一层buff：\n死亡瞬间随机传送一次，恢复10%血量\n触发后消耗一层"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 28、【金】【再来亿次】【赠送卡组刷新次数15】【可叠加】
        ["cards_refresh_num"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:AddRefreshNum(15)
            end,
            text = function(inst)
                return "【再来亿次】 赠送卡组刷新次数15"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 29、【金】【焉知非福】【每次失去生命值的时候，获得10点「信用点」，持续6分钟】【时间叠加】
        ["buff_health_down_and_coins_up"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_data:Add("hoshino_card_debuff_health_down_and_coins_up",60*6) --- 计时器累加
                local buff_prefab = "hoshino_card_debuff_health_down_and_coins_up"
                inst:AddDebuff(buff_prefab,buff_prefab)
            end,
            text = function(inst)
                return "【焉知非福】\n每次失去生命值的时候，获得10点「信用点」，持续6分钟"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 30、【金】【荷鲁斯的抗争】【立即获得5个「升级卡包」，「升级卡包」选项-1】【升级卡包变成1选1的时候从卡池移除，后续会重新进卡池】
        ["the_rsistance_of_horus"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                if inst.components.hoshino_cards_sys:GetDefaultCardsNum() == 1 then
                    return false
                end
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:DefultCardsNum_Delta(-1)
                for i = 1,3 do
                    inst.components.inventory:GiveItem(SpawnPrefab("hoshino_item_cards_pack"))
                end
            end,
            text = function(inst)
                return "【荷鲁斯的抗争】\n立即获得3个「神秘核心」，「神秘核心」选项-1"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 31、【金】【我将富有】【立即获得6666「信用点」，同时获得诅咒「凡庸」】【从卡池移除】
        ["give_me_some_money"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                if inst.components.hoshino_com_debuff:Get("golden_card_unlocked_give_me_some_money") then
                    return false
                end
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_shop:CreditCoinDelta(5555)
                if inst.components.hoshino_cards_sys:AcitveCardFnByIndexWithTest("mediocre") then
                    inst.components.hoshino_cards_sys:RememberActivedCard("mediocre")
                end
                inst.components.hoshino_com_debuff:Set("golden_card_unlocked_give_me_some_money",true)
            end,
            text = function(inst)
                return "【我将富有】\n立即获得5555「信用点」，同时获得诅咒「凡庸」"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 32、【金】【我必凯旋】【立即生成一只随机BOSS（列表形式），血量，攻击力是普通的3倍，击杀后获得3选1金色卡包】
        ["spawn_boss_with_golden_cards_pack"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local x,y,z = inst.Transform:GetWorldPosition()
                local monster_list = {
                                "bearger","mutatedbearger","deerclops","mutateddeerclops","spat",
                                "leif","spiderqueen","warglet","warg","mutatedwarg","klaus","mutatedwarg",
                                "beequeen","dragonfly"
                                }
                local ret_monster_prefab = monster_list[math.random(#monster_list)]
                local monster = SpawnPrefab(ret_monster_prefab or "hound")
                local debuff_prefab = "hoshino_card_debuff_for_monster_drop_cards_pack"                
                monster:AddDebuff(debuff_prefab,debuff_prefab)
                monster:AddDebuff(debuff_prefab,debuff_prefab)
                monster:AddDebuff(debuff_prefab,debuff_prefab)
                monster.Transform:SetPosition(x,y,z)
                inst.components.hoshino_com_rpc_event:PushEvent("hoshino_event.inspect_hud_force_close")

            end,
            text = function(inst)
                return " \n【我必凯旋】 立即生成一只随机BOSS\n血量、攻击力是普通的3倍\n击杀后获得3选1金色卡包"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 33、【金】【寒暑不侵】【恒温5天】【叠加时间】
        ["card_temperature_locker"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add("hoshino_card_debuff_temperature_locker",5*480)
                local debuff_prefab = "hoshino_card_debuff_temperature_locker"
                inst:AddDebuff(debuff_prefab,debuff_prefab)
            end,
            text = function(inst)
                return "【寒暑不侵】 恒温5天"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 34、【金】【七弦】【赠送7包结果注定一样的白色1选1卡包】。但是有20%的概率获得诅咒：【键山雏】
        ["7_identical_white_card_packs"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
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
                if math.random(10000)/10000 <= 0.2 then
                    -- inst.components.hoshino_cards_sys:Card_Pool_Delata("card_white",5)
                    if inst.components.hoshino_cards_sys:AcitveCardFnByIndexWithTest("keyhole_mountain_chick") then
                        inst.components.hoshino_cards_sys:RememberActivedCard("keyhole_mountain_chick")
                    end
                end
            end,
            text = function(inst)
                return "【七弦】 赠送7包结果注定一样的白色1选1卡包\n但是有20%的概率获得诅咒：【键山雏】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 35、【金】【点金之手】【赠送1包金色3选1】
        ["hand_of_midas"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local item = SpawnPrefab("hoshino_item_cards_pack")
                -- item:PushEvent("Set",{
                --     cards = {
                --         "card_golden",
                --         "card_golden",
                --         "card_golden",
                --     }
                -- })
                -- item:PushEvent("SetName","Golden 3-1")
                item:PushEvent("Type","hoshino_item_cards_pack_authority_to_unveil_secrets")
                inst.components.inventory:GiveItem(item)
            end,
            text = function(inst)
                return "【点金之手】 赠送1包金色3选1"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 37、【金】【竭泽】【随机清空一项白卡能力（血、San、饥饿、移速、经验、攻击、护甲、反伤、位面防御），然后获得1500点「信用点」】
        ["get_some_coins_and_delete_one_white_card_ability"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
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
                inst.components.hoshino_com_shop:CreditCoinDelta(5000)
            end,
            text = function(inst)
                return " \n【竭泽】 获得5000点「信用点」\n随机清空以下的一项加成:\n血、San、饥饿、移速、经验、攻击、阵营减伤、反伤、位面防御"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 38、【金】【坚毅】【清除所有血量上限惩罚值（黑血），且永远不会出现惩罚】【从卡池移除】
        ["health_penalty_blocker"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_health_penalty_blocker"
                return inst:GetDebuff(debuff_prefab) == nil
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_health_penalty_blocker"
                inst.components.hoshino_com_debuff:Add_Buff_Memory(debuff_prefab,debuff_prefab,true)
            end,
            text = function(inst)
                return "【坚毅】 清除所有血量上限惩罚值（黑血）\n永远不再出现惩罚"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 39、【金】【基沃托斯超人】【每10s恢复1点生命值】【数值叠加】
        ["health_auto_up"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add("hoshino_card_debuff_health_auto_up",1)
                local debuff_prefab = "hoshino_card_debuff_health_auto_up"
                inst.components.hoshino_com_debuff:Add_Buff_Memory(debuff_prefab,debuff_prefab,true)
            end,
            text = function(inst)
                return "【基沃托斯超人】 每10s恢复1点生命值"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 40、【金】【最高神秘】【攻击任何血量低于70%的 生物，都有0.1%的概率造成99999999999999伤害】【概率叠加】
        ["direct_kill_target"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add("hoshino_card_debuff_direct_kill_target",0.1/100)
                local debuff_prefab = "hoshino_card_debuff_direct_kill_target"
                inst.components.hoshino_com_debuff:Add_Buff_Memory(debuff_prefab,debuff_prefab,true)
            end,
            text = function(inst)
                return " \n【最高神秘】\n对于血量低于70%的目标，有0.1%的直接击杀概率\n重复卡牌则概率叠加"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 44、【金】【甘露】去除一个诅咒效果【如果可以就设计为无诅咒时不会出现在池子里】
        ["deactive_random_black_card"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                local actived_black_cards = inst.components.hoshino_cards_sys:GetActivatedCards("card_black") or {}
                local count = 0
                for card_name_index, active_times in pairs(actived_black_cards) do
                    if type(active_times) == "number" then
                        count = count + 1
                    end
                end
                return count > 0
            end,
            fn = function(inst)
                local actived_black_cards = inst.components.hoshino_cards_sys:GetActivatedCards("card_black") or {}
                --- 提取出激活次数大于等于1的卡牌
                local black_cards = {}
                for card_name_index, active_times in pairs(actived_black_cards) do
                    if type(active_times) == "number" and active_times > 0 then
                        table.insert(black_cards, card_name_index)
                    end
                end
                --- 随机选择一个卡牌
                local ret_card_name_index = black_cards[math.random(#black_cards)]
                --- 移除卡牌
                inst.components.hoshino_cards_sys:TryToDeactiveCardByName(ret_card_name_index)
            end,
            text = function(inst)
                return "【甘露】 去除一个随机诅咒效果\n如果是层数叠加类型，则去除一层"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 45、【金】解锁技能：普通EX
        ["unlock_spell_normal_ex"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return not inst.components.hoshino_com_spell_cd_timer:Is_Spell_Unlocked("gun_eye_of_horus_ex")
            end,
            fn = function(inst)
                inst.components.hoshino_com_spell_cd_timer:Unlock_Spell("gun_eye_of_horus_ex")
            end,
            text = function(inst)
                return "解锁技能：普通EX"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 46、【金】解锁技能：泳装EX
        ["unlock_spell_swimming_ex"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return not inst.components.hoshino_com_spell_cd_timer:Is_Spell_Unlocked("swimming_ex_support")
            end,
            fn = function(inst)
                inst.components.hoshino_com_spell_cd_timer:Unlock_Spell("swimming_ex_support")
            end,
            text = function(inst)
                return "解锁技能：泳装EX"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 47、【金】解锁普通形态所有普通技能
        ["unlock_spell_all_normal"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                if inst.components.hoshino_com_spell_cd_timer:Is_Spell_Unlocked("normal_heal") and
                    inst.components.hoshino_com_spell_cd_timer:Is_Spell_Unlocked("normal_covert_operation") and
                    inst.components.hoshino_com_spell_cd_timer:Is_Spell_Unlocked("normal_breakthrough") then
                    return false
                else
                    return true
                end
            end,
            fn = function(inst)
                inst.components.hoshino_com_spell_cd_timer:Unlock_Spell("normal_heal")
                inst.components.hoshino_com_spell_cd_timer:Unlock_Spell("normal_covert_operation")
                inst.components.hoshino_com_spell_cd_timer:Unlock_Spell("normal_breakthrough")
            end,
            text = function(inst)
                return "解锁普通形态所有普通技能"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 48、【金】解锁泳装形态所有普通技能
        ["unlock_spell_all_swimming"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                if inst.components.hoshino_com_spell_cd_timer:Is_Spell_Unlocked("swimming_efficient_work") and
                    inst.components.hoshino_com_spell_cd_timer:Is_Spell_Unlocked("swimming_emergency_assistance") and
                    inst.components.hoshino_com_spell_cd_timer:Is_Spell_Unlocked("swimming_dawn_of_horus") then
                    return false
                else
                    return true
                end
            end,
            fn = function(inst)
                inst.components.hoshino_com_spell_cd_timer:Unlock_Spell("swimming_efficient_work")
                inst.components.hoshino_com_spell_cd_timer:Unlock_Spell("swimming_emergency_assistance")
                inst.components.hoshino_com_spell_cd_timer:Unlock_Spell("swimming_dawn_of_horus")
            end,
            text = function(inst)
                return "解锁泳装形态所有普通技能"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 49、【金】【抵抗】【各个阵营伤害防御 + 10%（暗影阵营、月亮阵营）】【最高80%】
        ["armor_damage_type_resist"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_Damage_Type_Resist() > 0.2
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Damage_Type_Resist(0.08)
                inst:PushEvent("hoshino_other_armor_item_param_refresh")
            end,
            text = function(inst)
                return "【抵抗】 受到暗影、月亮阵营伤害减少8%"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 50、【金】【生命值上限，san值上限，饥饿上限+20】【可叠加】
        ["halth_sanity_hunger_max_up_20"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Max_Helth(20)
                inst.components.health:DoDelta(20)
                inst.components.hoshino_com_debuff:Add_Max_Sanity(20)
                inst.components.hoshino_com_debuff:Add_Max_Hunger(20)                
            end,
            text = function(inst)
                return "生命值上限，San值上限，饥饿上限+20"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 51、【金】【移动速度+3%，基础攻击伤害+10%】【可叠加】
        ["speed_up_and_damage_up_6_10"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Speed_Mult(3/100)
                inst.components.hoshino_com_debuff:Add_Damage_Mult(7/100)
            end,
            text = function(inst)
                return "移动速度+3%，基础攻击伤害7%"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 52、【金】【基础减伤值增加6%】【所有减伤值总和无法超过99%，达到之后移除该卡片】
        ["damage_taken_mult_6"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_Damage_Taken_Mult() < 0.6
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Damage_Taken_Mult(6/100)
            end,
            text = function(inst)
                return "基础伤害减免+6%，总和不超过60%"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【收集癖】你每拥有1个卡牌词条，伤害+1% 【选择之后从卡组移除】
        ["collecting_fetish"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_collecting_fetish") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_collecting_fetish","hoshino_card_debuff_collecting_fetish",true)
            end,
            text = function(inst)
                return "【收集癖】\n你每拥有1个卡牌词条，伤害+1% 【选择之后从卡组移除】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【实质打击】基础攻击伤害-50%，但是你的所有攻击会扣除敌人30点生命值 （选择之后从卡池移除）
        ["substantive_strike"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_substantive_strike") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_substantive_strike","hoshino_card_debuff_substantive_strike",true)
            end,
            text = function(inst)
                return "【实质打击】\n基础攻击伤害-50%，但是你的所有攻击会扣除敌人30点生命值。【选择之后从卡池移除】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【战车】当你接触到敌对生物时(半径6），每0.3秒扣除其10点生命值（重复选择伤害叠加）
        ["war_chariot"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add("war_chariot",10)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_war_chariot","hoshino_card_debuff_war_chariot",true)
            end,
            text = function(inst)
                return "【战车】\n当你接触到敌对生物时，每0.3秒扣除其10点生命值（重复选择伤害叠加）"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【负重前行】当你获得诅咒时，获得一个神秘核心（选择后从卡池移除）
        ["burdened_forward"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_burdened_forward") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_burdened_forward","hoshino_card_debuff_burdened_forward",true)
            end,
            text = function(inst)
                return "【负重前行】\n当你获得诅咒时，获得一个神秘核心（选择后从卡池移除）"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【趋吉避凶】当你选择诅咒牌时，真正的诅咒会被高亮标出（选择后从卡牌移除）
        ["seek_good_avoid_bad"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_seek_good_avoid_bad") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_seek_good_avoid_bad","hoshino_card_debuff_seek_good_avoid_bad",true)
            end,
            text = function(inst)
                return "【趋吉避凶】\n你能看出哪张牌是真正的诅咒牌（选择后从卡牌移除）"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【嗝屁猫】当你死亡时，你立刻复活，此效果最多触发九次，但是你获得诅咒【无实体】
        ["nine_lives_cat"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst:AddDebuff("hoshino_card_debuff_nine_lives_cat","hoshino_card_debuff_nine_lives_cat")
                if inst.components.hoshino_cards_sys:AcitveCardFnByIndexWithTest("max_health_1") then
                    inst.components.hoshino_cards_sys:RememberActivedCard("max_health_1")
                end
            end,
            text = function(inst)
                return " \n【嗝屁猫】当你死亡时，你立刻复活\n此效果最多触发九次\n你获得诅咒【无实体】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【嗝屁猫的项圈】当你死亡时，50%的概率立即复活
        ["cat_amulet"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_cat_amulet") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_cat_amulet","hoshino_card_debuff_cat_amulet",true)
            end,
            text = function(inst)
                return " \n【嗝屁猫的项圈】\n当你死亡时，50%的概率立即复活。\n（选择之后从卡池移除）"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【嗝屁猫的爪子】生命上限-40（最低保留1），获得3点固定减伤（受到的伤害-3，不包含过冷过热等扣血效果）
        ["cat_hand"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_cat_hand","hoshino_card_debuff_cat_hand",true)
            end,
            text = function(inst)
                return " \n【嗝屁猫的爪子】\n生命上限-40（最低保留1,可叠加）\n获得3点固定伤害减免"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【地狱契约】击杀生物时，66%的概率双倍掉落
        ["hell_contract"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_hell_contract") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_hell_contract","hoshino_card_debuff_hell_contract",true)
            end,
            text = function(inst)
                return " \n【地狱契约】亲自击杀生物时，66%的概率再掉落一次\n（选择之后从卡池移除）\n(一击致死的不算数)"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【亚巴顿】生命上限-50%（黑血），根据扣除生命上限的数额获得[n/5]次【爆炸护盾】
        ["abaddon"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local max_health_1 = inst.components.health:GetMaxWithPenalty()
                inst.components.health:DeltaPenalty(0.5)
                local max_health_2 = inst.components.health:GetMaxWithPenalty()
                local delta_health = math.abs(max_health_1 - max_health_2)
                local num = math.max( math.floor(delta_health / 5) , 1 )
                for i = 1, num, 1 do
                    inst:AddDebuff("hoshino_debuff_bomb_shield","hoshino_debuff_bomb_shield")
                end
                TheNet:Announce("【亚巴顿】"..inst:GetDisplayName().."获得"..num.."层【爆炸护盾】")
            end,
            text = function(inst)
                return " \n【亚巴顿】\n生命上限-50%（黑血）\n根据扣除生命上限的数额获得[n/5]次【爆炸护盾】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【洁癖】基础攻击伤害+60% 生命上限+60 但你每获得1全新词条，降低2%基础伤害 减少2生命上限【选择之后从卡组移除】
        ["neatness_obsession"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_neatness_obsession") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_neatness_obsession","hoshino_card_debuff_neatness_obsession",true)
            end,
            text = function(inst)
                return " \n【洁癖】基础攻击伤害+60% 生命上限+60 \n但你每获得1全新词条，降低2%基础伤害 减少2生命上限\n【选择之后从卡组移除】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【貔貅】你每拥有每500信用点 +1%伤害 以此法提供的伤害加成最多不超过100%【选择之后从卡池移除】
        ["coins_and_dmg_up"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_coins_and_dmg_up") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_coins_and_dmg_up","hoshino_card_debuff_coins_and_dmg_up",true)
            end,
            text = function(inst)
                return " \n【貔貅】你每拥有每500信用点+1%伤害 \n以此法提供的伤害加成最多不超过100%\n【选择之后从卡池移除】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【宝石猎人】破坏石头时5%概率获得1随机宝石（彩虹宝石除外）（到达50%后移出池子）
        ["gem_hunter"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_Gem_Hunter() < 0.5
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Gem_Hunter(0.05)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_gem_hunter","hoshino_card_debuff_gem_hunter",true)
            end,
            text = function(inst)
                return " \n【宝石猎人】\n破坏石头时5%概率获得1随机宝石（彩虹宝石除外）\n（到达50%后移出池子）"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【独行天途】当30码内没有友方单位时，获得buff:每次造成伤害+0.1cost，cost恢复速度+0.04/s【选择后从卡池移除】
        ["solitary_heaven_path"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_solitary_heaven_path") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_solitary_heaven_path","hoshino_card_debuff_solitary_heaven_path",true)
            end,
            text = function(inst)
                return " \n【独行天途】当30码内没有友方单位时\n获得buff:每次造成伤害+0.1cost\ncost恢复速度+0.04/s【选择后从卡池移除】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【破灭】立即获得一包【神秘核心】，该神秘核心中你选择的卡牌将从卡组中移除
        ["destruction"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst:DoTaskInTime(0.3,function()
                    inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_destruction","hoshino_card_debuff_destruction",true)
                    inst.components.inventory:GiveItem(SpawnPrefab("hoshino_item_cards_pack"))
                end)                
            end,
            text = function(inst)
                return " \n【破灭】\n立即获得一包【神秘核心】\n下一张激活的卡牌将从卡组中永久移除"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【封眠】受到你造成伤害的生物无法再恢复生命值
        ["block_monster_health_auto_up"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_block_health_auto_up") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_block_health_auto_up","hoshino_card_debuff_block_health_auto_up",true)
            end,
            text = function(inst)
                return "【封眠】受到你造成伤害的生物无法再恢复生命值，\n【选择后从卡池移除】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【援助补给】接下来10天内，每到新的一天都会从天而降一个资源补给箱，资源补给箱从下列几种物资中随机出现一个(曼德拉草浓缩液*1 超级打包盒-千年改*1 神秘核心*1  12mm霰弹*20 能量药水*6)
        ["air_drop_support_golden"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst:AddDebuff("hoshino_card_debuff_air_drop_support_golden","hoshino_card_debuff_air_drop_support_golden")
            end,
            text = function(inst)
                return "【援助补给】\n接下来10天内，每到新的一天都会从天而降一个资源补给箱。"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【垫脚石】你的攻击倍率和移速倍率不低于1.0
        ["pad_stone"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_pad_stone") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_pad_stone","hoshino_card_debuff_pad_stone",true)
            end,
            text = function(inst)
                return "【垫脚石】你的攻击倍率和移速倍率不低于1"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【弹簧】选择这张卡时检测人物基础攻击倍率，若小于等于1则翻倍，若大于等于1.5则-30%，其他情况下选中则无影响。
        ["spring"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst:AddDebuff("hoshino_card_debuff_spring"..tostring(math.random(1000000)),"hoshino_card_debuff_spring")
            end,
            text = function(inst)
                return " \n【弹簧】激活这张卡时检测人物基础攻击倍率,\n若小于等于1则翻倍,若大于等于1.5则-30%。\n其他情况下选中则无影响。\n角色重选则失效"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【全域反击】你的【荆棘】伤害翻倍（单次增加数额不超过100）
        ["global_counterattack"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local current = inst.components.hoshino_com_debuff:Get_Counter_Damage()
                inst.components.hoshino_com_debuff:Add_Counter_Damage(math.min(100,current))
            end,
            text = function(inst)
                return "【全域反击】你的【荆棘】伤害翻倍（单次增加数额不超过100）"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【全年无休】每日委托刷新次数+1
        ["year_round"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_task_sys_for_player:Add_Daily_Refresh_Num(1)
            end,
            text = function(inst)
                return "【全年无休】每日委托刷新次数+1"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【金】【黑暗乞丐】选择后生成一个跟随玩家的黑暗乞丐【选择之后移出卡池】
        ["black_beggar"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst:GetDebuff("hoshino_card_debuff_black_beggar") == nil
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_black_beggar","hoshino_card_debuff_black_beggar",true)
            end,
            text = function(inst)
                return " \n【黑暗乞丐】选择后生成一个跟随玩家的黑暗乞丐\n给予其能恢复生命的食物可获得随机效果\n【选择之后移出卡池】"
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