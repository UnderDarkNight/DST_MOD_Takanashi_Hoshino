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
                inst.components.hoshino_com_debuff:Add_Returning_Recipe_By_Count(3)
            end,
            text = function(inst)
                return "【星野的精算】\n每天前3次制作返回一半的材料，向下取整"
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
                for i = 1,5 do
                    inst.components.inventory:GiveItem(SpawnPrefab("hoshino_item_cards_pack"))
                end
            end,
            text = function(inst)
                return "【荷鲁斯的抗争】\n立即获得5个「神秘核心」，「神秘核心」选项-1"
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
                inst.components.hoshino_com_shop:CreditCoinDelta(6666)
                -- local debuff_prefab = "hoshino_card_debuff_builder_blocker"
                -- while true do
                --     local debuff_inst = inst:GetDebuff(debuff_prefab)
                --     if debuff_inst and debuff_inst:IsValid() then
                --         break
                --     end
                --     inst:AddDebuff(debuff_prefab,debuff_prefab)
                -- end
                inst.components.hoshino_cards_sys:AcitveCardFnByIndex("mediocre")
                inst.components.hoshino_cards_sys:RememberActivedCard("mediocre")
                inst.components.hoshino_com_debuff:Set("golden_card_unlocked_give_me_some_money",true)
            end,
            text = function(inst)
                return "【我将富有】\n立即获得6666「信用点」，同时获得诅咒「凡庸」"
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
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
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
                    inst.components.hoshino_cards_sys:AcitveCardFnByIndex("keyhole_mountain_chick")
                    inst.components.hoshino_cards_sys:RememberActivedCard("keyhole_mountain_chick")
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
                inst.components.hoshino_com_shop:CreditCoinDelta(1500)
            end,
            text = function(inst)
                return " \n【竭泽】 获得1500点「信用点」\n随机清空以下的一项加成:\n血、San、饥饿、移速、经验、攻击、阵营减伤、反伤、位面防御"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 38、【金】【坚毅】【清除所有血量上限惩罚值（黑血），且永远不会出现惩罚】【从卡池移除】
        ["health_penalty_blocker"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_health_penalty_blocker"
                for i = 1, 5, 1 do
                    local buff_inst = inst:GetDebuff(debuff_prefab)
                    if buff_inst and buff_inst:IsValid() then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_health_penalty_blocker"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
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
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
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
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
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
                inst.components.hoshino_com_debuff:Add_Damage_Type_Resist(0.1)
                inst:PushEvent("hoshino_other_armor_item_param_refresh")
            end,
            text = function(inst)
                return "【抵抗】 受到暗影、月亮阵营伤害减少10%"
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
                inst.components.hoshino_com_debuff:Add_Max_Sanity(20)
                inst.components.hoshino_com_debuff:Add_Max_Hunger(20)                
            end,
            text = function(inst)
                return "生命值上限，San值上限，饥饿上限+20"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 51、【金】【移动速度+6%，基础攻击伤害+10%】【可叠加】
        ["speed_up_and_damage_up_6_10"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Speed_Mult(6/100)
                inst.components.hoshino_com_debuff:Add_Damage_Mult(10/100)
            end,
            text = function(inst)
                return "移动速度+6%，基础攻击伤害+10%"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 52、【金】【基础减伤值增加6%】【所有减伤值总和无法超过99%，达到之后移除该卡片】
        ["damage_taken_mult_6"] = {
            back = "card_golden",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_golden.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_Damage_Taken_Mult() < 0.94
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Damage_Taken_Mult(6/100)
            end,
            text = function(inst)
                return "基础伤害减免+6%"
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

    if atlas ~= "images/inspect_pad/page_level_up.xml" then
        table.insert(Assets, Asset("ATLAS", atlas )     )
        table.insert(Assets, Asset("IMAGE", "images/inspect_pad/"..image ) )
    end
end