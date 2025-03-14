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
        -- ["test_card_white"] = {
        --     back = "card_white",
        --     front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
        --     test = function(inst)
        --         return true
        --     end,
        --     fn = function(inst)
        --         print("test_card_white")
        --     end,
        --     text = function(inst)
        --         return "测试用的空白卡"
        --     end,
        -- },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 1、【白】【生命值上限+15】【可叠加】
        ["max_health_up_15"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Max_Helth(9)
            end,
            text = function(inst)
                return "生命上限+9"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 2、【白】【San上限+10】【可叠加】
        ["max_sanity_up_10"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
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
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Max_Hunger(12)
            end,
            text = function(inst)
                return "饥饿上限+12"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 4、【白】【移动速度+3%】【可叠加】
        ["speed_up_2_percent"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
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
    --- 5、【白】【基础攻击伤害+3%】【可叠加】
        ["damage_mult_up_4_percent"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Damage_Mult(0.02)
            end,
            text = function(inst)
                return "攻击伤害+2%"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 6、【白】【饥饿自然掉速-3%，最高-30%】【达到最高后从卡池移除】
        ["hunger_down_mult_down_3_percent"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
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
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:GetExpMult() < 0.9
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Exp_Mult(0.1)
            end,
            text = function(inst)
                return "【日积月累】 经验值获取速率提升10%"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 8、【白】【好东西！】【随机获得一个BOSS掉落物（列表形式）】
        ["random_boss_item_drop"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
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
                return "【好东西!】 随机获得一项原版boss掉落物"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 9、【白】【神秘仪式】【随机召唤一只生物（列表形式）】
        ["random_monster_summon"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local monsters = {
                    "pigman","pigguard","bunnyman","merm","mermguard","little_walrus","walrus",
                    "knight","bishop","rook","knight_nightmare","bishop_nightmare","rook_nightmare",
                    "spider","spider_warrior","spider_hider","spider_spitter","spider_dropper",
                    "spider_moon","spider_healer","spider_water","hound","firehound","icehound",
                    "mutatedhound","frog","lightninggoat","bee","killerbee","monkey","worm_boss",
                    "eyeofterror","leif","moose","dragonfly","beequeen","bearger"
                }
                local ret_monster = monsters[math.random(#monsters)]
                local monster_inst = SpawnPrefab(ret_monster)
                if monster_inst then
                    monster_inst.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
            end,
            text = function(inst)
                return "【神秘仪式】 随机召唤一个生物"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 10、【白】【透支】【根据当前剩余未选择的卡牌数量，给玩家N张1选1卡包，包括颜色对应，下1次升级不再赠送升级卡包。如果当前未翻开的剩余卡牌数量为0，则重新赠送一包1选1卡包】
        ["overdraft"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
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
                inst.components.hoshino_com_debuff:Add("level_up_card_pack_gift_blocker",2)
            end,
            text = function(inst)
                return " \n【透支】\n根据当前剩余未选择的卡牌数量，给玩家N张 1选1卡包。\n包括颜色对应。下2次升级不再赠送升级卡包"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 11、【白】【邪咒】【基础攻击伤害+10%，然后获取debuff : 2天内San掉落的时候，同数值掉落血量】【debuff时间叠加】【攻击倍率也叠加】
        ["damage_mult_up_10_percent_and_sanity_down"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Damage_Mult(0.05)
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
                return "【邪咒】攻击伤害+5%\n接下来两天内每次失去san时会流失等量生命"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 12、【白】【荆棘】【每次受到攻击时候，对伤害来源直接反伤3点（任何玩家都不会触发这个）】【可叠加】
        ["counter_damage"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Counter_Damage(10)
            end,
            text = function(inst)
                return "【荆棘】 每次受到攻击时，对伤害来源造成10点伤害"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 13、【白】【节约风气】【使用专属武器「荷鲁斯之眼（枪）」的时候，有10%概率不消耗耐久，最高100%概率】【满概率后从卡池移除】
        ["the_eye_of_horus_finiteuses_down_block"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_TheEyeOfHorus_Finiteuses_Down_Block_Percent() < 1
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:TheEyeOfHorus_Finiteuses_Down_Block(0.1)
            end,
            text = function(inst)
                return "【节约风气】 使用荷鲁斯之眼时有10%的概率不消耗耐久"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 14、【白】【白日梦】【选择之后传送到一个位置并开始睡觉，每一秒获得9点「信用点」，直到醒来】
        ["sleep_and_coins"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                ----------------------------------------------------------------------------------------------------------
                --- 随机传送一个位置
                    local function GetRandomPos()
                        local centers = {}
                        for i, node in ipairs(TheWorld.topology.nodes) do
                            if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then
                                table.insert(centers, {x = node.x, z = node.y})
                            end
                        end
                        if #centers > 0 then
                            local pos = centers[math.random(#centers)]
                            return Vector3(pos.x, 0, pos.z)
                        else
                            --- 上面失败，则返回绚丽之门位置
                            local door = TheSim:FindFirstEntityWithTag("multiplayer_portal")
                            if door then
                                return Vector3(door.Transform:GetWorldPosition())
                            end
                        end
                        return nil
                    end
                    local pos = GetRandomPos()
                    if pos then
                        inst.components.playercontroller:RemotePausePrediction(3)   --- 暂停远程预测。
                        inst.Transform:SetPosition(pos.x,0,pos.z)
                    end
                ----------------------------------------------------------------------------------------------------------
                --- 添加BUFF
                    local debuff_prefab = "hoshino_card_debuff_sleep_and_coins"
                    while true do
                        local debuff_inst = inst:GetDebuff(debuff_prefab)
                        if debuff_inst and debuff_inst:IsValid() then
                            break
                        end
                        inst:AddDebuff(debuff_prefab,debuff_prefab)
                    end
                ----------------------------------------------------------------------------------------------------------
                --- 来自 曼德拉草(mandrake) 的代码。
                    local function start_sleep(inst)
                        --- 来自 曼德拉草(mandrake) 的代码。
                        local SLEEPTARGETS_CANT_TAGS = { "playerghost", "FX", "DECOR", "INLIMBO" }
                        local SLEEPTARGETS_ONEOF_TAGS = { "sleeper", "player" }
                        local function doareasleep(inst, range, time)
                            local x, y, z = inst.Transform:GetWorldPosition()
                            local ents = TheSim:FindEntities(x, y, z, range, nil, SLEEPTARGETS_CANT_TAGS, SLEEPTARGETS_ONEOF_TAGS)
                            local canpvp = not inst:HasTag("player") or TheNet:GetPVPEnabled() or true
                            for i, v in ipairs(ents) do
                                if (v == inst or canpvp or not v:HasTag("player")) and
                                    not (v.components.freezable ~= nil and v.components.freezable:IsFrozen()) and
                                    not (v.components.pinnable ~= nil and v.components.pinnable:IsStuck()) and
                                    not (v.components.fossilizable ~= nil and v.components.fossilizable:IsFossilized()) then
                                    local mount = v.components.rider ~= nil and v.components.rider:GetMount() or nil
                                    if mount ~= nil then
                                        mount:PushEvent("ridersleep", { sleepiness = 7, sleeptime = time + math.random() })
                                    end
                                    if v:HasTag("player") then
                                        v:PushEvent("yawn", { grogginess = 6, knockoutduration = time + math.random() })
                                    elseif v.components.sleeper ~= nil then
                                        v.components.sleeper:AddSleepiness(7, time + math.random())
                                    elseif v.components.grogginess ~= nil then
                                        v.components.grogginess:AddGrogginess(4, time + math.random())
                                    else
                                        v:PushEvent("knockedout")
                                    end
                                end
                            end
                        end
                        doareasleep(inst,1,480)
                    end
                    start_sleep(inst)
                ----------------------------------------------------------------------------------------------------------

            end,
            text = function(inst)
                return "【白日梦】 随机传送到一个位置然后睡觉\n每一秒获得6点「信用点」，直到醒来"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 15、【白】【避重就轻】【受到伤害的时候，有10%的概率不损失盔甲的耐久，最高100%】【满概率后从卡池移除】
        ["armor_down_blocker_percent"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_Armor_Down_Blocker_Percent() < 1
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Armor_Down_Blocker_Percent(0.08)
            end,
            text = function(inst)
                return "【避重就轻】 受伤时有8%的概率不损失盔甲耐久"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 16、【白】【防暴盾牌】【获得2点位面防御】【可叠加】
        ["armor_planar_defense"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Planar_Defense(2)
            end,
            text = function(inst)
                return "【防暴盾牌】 获得2点位面防御"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 17、【白】【尤里卡】【获得一个随机物品蓝图】
        ["random_blueprint"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local item = SpawnPrefab("blueprint")
                inst.components.inventory:GiveItem(item)
            end,
            text = function(inst)
                return "【尤里卡】 获得一个随机物品蓝图"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 19、【白】【好运】【金卡和彩卡的出现权重很~大~幅~度~上升】【可叠加】
        ["rare_cards_appearance_weight"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:Card_Pool_Delata("card_colourful",0.03)
                inst.components.hoshino_cards_sys:Card_Pool_Delata("card_golden",0.2)
            end,
            text = function(inst)
                return "【好运】 金卡和彩卡的出现权重很~大~幅~度~上升"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 20、【白】【汲取】【从食物获取的「正向」三维x2.5的同时，增加厨子的挑食机制】【从卡池移除】
        ["warly_eater_modules_unlock"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return inst.components.hoshino_data:Get("Player_Unlocked_Warly_Eater_Modules") ~= true
            end,
            fn = function(inst)
                inst:PushEvent("player_unlocked_warly_eater_modules")
            end,
            text = function(inst)
                return "【汲取】\n从食物获取的「正向」三维x2.5的同时，增加厨子的挑食机制"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 21、【白】【巧匠】【每次制作物品的时候，有1%概率返还制作材料，最高50%】【满概率后从卡池移除】
        ["probability_of_returning_full_recipe"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_Probability_Of_Returning_Recipe() < 0.5
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Probability_Of_Returning_Recipe(0.01)
            end,
            text = function(inst)
                return "【巧匠】\n每次制作物品的时候，有1%概率返还制作材料，最高50%"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 22、【白】【石虾助我！】【生成一只永久石虾跟随】
        ["summon_rocky"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst:PushEvent("hoshino_event.create_rocky")
            end,
            text = function(inst)
                return "【石虾助我！】 生成一只永久跟随的石虾"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 23、【白】【滚草成灾】【立刻在玩家身边生成15个风滚草】
        ["summon_tumbleweed"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local points = TUNING.HOSHINO_FNS:GetSurroundPoints({
                    target = inst,
                    range = 2,
                    num = 15,
                })
                if points then
                    for _,pt in ipairs(points) do
                        SpawnPrefab("tumbleweed").Transform:SetPosition(pt.x,0,pt.z)
                    end
                end
                inst.components.hoshino_com_rpc_event:PushEvent("hoshino_event.inspect_hud_force_close")
            end,
            text = function(inst)
                return "【滚草成灾】 立刻在玩家身边生成15个风滚草"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】 【格斗高手】你使用攻击距离小于等于2的武器时伤害+12%（可叠加）
        ["weapon_damage_up_by_range"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_weapon_dmg_up_by_range","hoshino_card_debuff_weapon_dmg_up_by_range",true)
            end,
            text = function(inst)
                return "【格斗高手】你使用攻击距离小于等于2的武器时伤害+12%（可叠加）"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】 【重装战士】移速-10% 基础攻击+5%，受到的伤害*0.95（此效果全部为乘算叠加，即选n次卡之后受伤为0.95n）
        ["armored_warrior"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_armored_warrior","hoshino_card_debuff_armored_warrior",true)
            end,
            text = function(inst)
                return "【重装战士】移速-10%*X(-最多90%) \n基础攻击+5%*X，受到的伤害*0.95*X"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】 【雨中漫步】当你的潮湿度大于50时，造成的基础伤害提升10% (可叠加)
        ["moisture_and_dmg"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_moisture_and_dmg","hoshino_card_debuff_moisture_and_dmg",true)
            end,
            text = function(inst)
                return "【雨中漫步】当你的潮湿度大于50时，造成的基础伤害提升10%*X"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】 【苦路】你的饥饿，san，血量立刻开始以10/s的速度降低，在其中一项达到0的时候停止，你在此期间内每降低一点饥饿/san/血量就会获得2信用点
        ["road_of_pain"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_road_of_pain_"..math.random(1000000),"hoshino_card_debuff_road_of_pain",true)
            end,
            text = function(inst)
                return "【苦路】你的饥饿，san，血量立刻开始以10/s的速度降低，在其中一项达到0的时候停止。\n你在此期间内每降低一点饥饿/san/血量就会获得2信用点"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】【电灯泡】你的光环发光半径+0.1（发光范围叠加）
        ["halo_radius_up"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Halo_Radius(0.1)
                inst:PushEvent("hoshino_event.halo_refresh")
            end,
            text = function(inst)
                return "【电灯泡】你的光环发光半径+0.1（发光范围叠加）"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】【窃贼】击杀血量高于50的生物会获得2信用点 【选择之后从卡组移除】
        ["kill_and_coins_up_thief"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                for i = 1, 10, 1 do
                    if inst:GetDebuff("hoshino_card_debuff_kill_and_coins_up_thief") then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                local test_num = 10
                while test_num > 0 do
                    inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_kill_and_coins_up_thief","hoshino_card_debuff_kill_and_coins_up_thief",true)
                    test_num = test_num - 1
                end
            end,
            text = function(inst)
                return "【窃贼】击杀血量高于50的生物会获得2信用点\n【选择之后从卡组移除】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】【嗝屁猫的尾巴】将金卡权重提高1，诅咒卡权重提高0.5
        ["the_tail_of_the_fart_cat"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:Card_Pool_Delata("card_golden",1)
                inst.components.hoshino_cards_sys:Card_Pool_Delata("card_black",0.5)
            end,
            text = function(inst)
                return "【嗝屁猫的尾巴】将金卡权重提高1，诅咒卡权重提高0.5"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】【形变】将你的所有随从变为永久跟随你的同一种，并恢复满血
        ["set_the_same_followers"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                if inst.components.leader:CountFollowers() <= 0 then
                    return
                end
                local following_prefab = {}
                local num = 0
                for monster, v in pairs(inst.components.leader.followers) do
                    if monster and monster:IsValid() and monster.components.combat then
                        table.insert(following_prefab,monster.prefab)
                        monster:Remove()
                        num = num + 1
                    end
                end
                if num == 0 then
                    return
                end
                local x,y,z = inst.Transform:GetWorldPosition()
                local ret_monster_prefab = following_prefab[math.random(#following_prefab)]
                for i = 1, num, 1 do
                    local temp_monster = SpawnPrefab(ret_monster_prefab)
                    temp_monster.Transform:SetPosition(x+math.random(-20,20)/10,0,z+math.random(-20,20)/10)
                    inst:PushEvent("makefriend")
                    inst.components.leader:AddFollower(temp_monster)
                    SpawnPrefab("crab_king_shine").Transform:SetPosition(temp_monster.Transform:GetWorldPosition())                    
                end
            end,
            text = function(inst)
                return "【形变】将你的所有随从变为永久跟随你的同一种，并恢复满血"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】【空投支援】 接下来3天内获得物资支援，每到新的一天时在从空中落下一个物资支援包 其内从以下四种物品中随机出现一种(土豆手雷*4 12号霰弹*10 神名文字碎片*1 能量药水*3 )
        ["air_drop_support"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst:AddDebuff("hoshino_card_debuff_air_drop_support","hoshino_card_debuff_air_drop_support")
            end,
            text = function(inst)
                return "【白】【空投支援】接下来3天内获得物资支援，每到新的一天时在从空中落下一个物资支援包\n天数叠加"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】【交易高手】与猪王交易时2.5%额外获得一颗随机初级宝石【红，蓝，紫】，达到100%后移除
        ["trading_master_pigking_and_gems"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_PigKing_Trade_And_Gems_Percent() < 1
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_PigKing_Trade_And_Gems_Percent(2.5/100)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_trading_master_pigking_and_gems","hoshino_card_debuff_trading_master_pigking_and_gems",true)
            end,
            text = function(inst)
                return "【交易高手】与猪王交易时2.5%额外获得一颗随机初级宝石【红/蓝/紫】，达到100%后移除"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】【似曾相识】标记月岛和远古的位置（选择后从卡池移除）
        --【笔记】不能在平板开启状态下 执行代码，容易造成玩家脱控。通过debuff 中转
        -- 平板关闭后再执行坐标查看。
        ["mark_moon_land_and_ancient_land"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                if TheWorld:HasTag("cave") and not inst.components.hoshino_com_debuff:Get("mark_moon_land_and_ancient_land.cave") then
                    return true
                elseif not TheWorld:HasTag("cave") and not inst.components.hoshino_com_debuff:Get("mark_moon_land_and_ancient_land.ground") then
                    return true
                end
                return false
            end,
            fn = function(inst)
                if TheWorld:HasTag("cave") then
                    inst.components.hoshino_com_debuff:Set("mark_moon_land_and_ancient_land.cave",true)
                else                    
                    inst.components.hoshino_com_debuff:Set("mark_moon_land_and_ancient_land.ground",true)
                end
                inst:AddDebuff("hoshino_card_debuff_mark_moon_land_and_ancient_land","hoshino_card_debuff_mark_moon_land_and_ancient_land")
            end,
            text = function(inst)
                return "【似曾相识】标记月岛和远古的位置（选择后从卡池移除）"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】【实验性疗法】在血、San、饥饿、移速、攻击、位面防御中，随机增加四项属性，减少两项属性（血，san，饥饿，变化量：10（三维不低于1），攻击，移速5%，位面防御：3（位面防御不会低于0）
        ["experimental_therapy"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst:AddDebuff("hoshino_card_debuff_experimental_therapy"..math.random(1000000000),"hoshino_card_debuff_experimental_therapy")
            end,
            text = function(inst)
                return "【实验性疗法】在血、San、饥饿、移速、攻击、位面防御中，随机增加四项属性，减少两项属性（血，san，饥饿，变化量：10（三维不低于1），攻击，移速5%，位面防御：3（位面防御不会低于0）"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】【精力分配】每次使用技能有10%概率返还1点cost （到达50%后移出池子）
        ["energy_distribution"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return inst.components.hoshino_com_debuff:Get_Energy_Distribution() < 0.5
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Energy_Distribution(0.1)
            end,
            text = function(inst)
                return "【精力分配】每次使用技能有10%概率返还1点cost （到达50%后移出池子）"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】【净化之光】每0.2s扣除半径6码范围内所有敌人1点生命【重复选择扣血量叠加】
        ["purifying_light"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add("purifying_light",1)
                inst.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_card_debuff_purifying_light","hoshino_card_debuff_purifying_light",true)
            end,
            text = function(inst)
                return "【净化之光】每0.2s扣除半径6码范围内所有敌人1点生命【重复选择扣血量叠加】"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 【白】【活力迸发】回复所有三维（生命，饥饿，san），并获得buff：攻击+50%，此buff持续5min。
        ["energy_burst"] = {
            back = "card_white",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_white.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.health:SetPercent(1)
                inst.components.hunger:SetPercent(1)
                inst.components.sanity:SetPercent(1)
                local debuff_prefab = "hoshino_card_debuff_energy_burst"
                local debuff_inst = nil
                local test_num = 100
                while test_num > 0 do
                    debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                    test_num = test_num - 1
                end
                if debuff_inst then
                    debuff_inst:PushEvent("add_time",5*60)
                end
            end,
            text = function(inst)
                return "【活力迸发】回复所有三维并获得buff：攻击+50%，此buff持续5min。"
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

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end
    inst:DoTaskInTime(3, function()
        if #TUNING.HOSHINO_CARDS_DATA_AND_FNS_WARNING > 0 then
            TheNet:Announce("警告：检测到有重复的卡牌数据，请检查是否重复定义了卡牌")
            for _,card_name in ipairs(TUNING.HOSHINO_CARDS_DATA_AND_FNS_WARNING) do
                print("警告：重复定义的卡牌数据为 : ",card_name)
            end
        end
    end)
end)