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
    --- 测试用的空黑卡
            -- ["test_card_black"] = {
            --     back = "card_black",
            --     front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            --     test = function(inst)
            --         return true
            --     end,
            --     fn = function(inst)
            --         print("test_card_black")
            --     end,
            --     deactive_fn = function(inst) --- 诅咒去除（单次）
                    
            --     end,
            --     text = function(inst)
            --         return "测试用的空黑卡"
            --     end,
            -- },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 1、【诅咒】【依神紫苑】【你每天至多获得300信用点】【从诅咒池移除】
        ["max_daily_earn"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                if inst.components.hoshino_com_shop:Get("card_black_active.max_daily_earn") then
                    return false
                end
                return true
            end,
            fn = function(inst)
                inst:PushEvent("card_black_active.max_daily_earn")
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                inst.components.hoshino_com_shop:Set("card_black_active.max_daily_earn", nil)
                inst.components.hoshino_com_shop:SetCreditCoinDeltaFn(nil)
                inst.components.hoshino_com_shop:Set("card_black_active.max_daily_earn.current",nil)
            end,
            text = function(inst)
                return "【依神紫苑】 你每天至多获得300信用点"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 2、【诅咒】【消化不良】【从食物中获取的三维增加量减半，扣除的不减】【从诅咒池移除】
        ["eater_indigestion"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                return inst.components.hoshino_data:Get("Player_Indigestion") ~= true
            end,
            fn = function(inst)
                inst:PushEvent("player_unlock_eater_indigestion")
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                -- inst.components.eater.preferseatingtags = nil  --- 移除喜好标签组
                inst.components.hoshino_data:Set("Player_Indigestion",nil)
            end,
            text = function(inst)
                return "【消化不良】 从食物中获取的三维增加量减半，扣除的不减"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 3、【诅咒】【噩梦】【无法通过睡觉恢复生命值】【从诅咒池移除】
        ["sleeping_bag_health_blocker"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                if inst.components.hoshino_cards_sys:Get("card_black.sleeping_bag_health_blocker") then
                    return false
                end
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:Set("card_black.sleeping_bag_health_blocker",true)
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                inst.components.hoshino_cards_sys:Set("card_black.sleeping_bag_health_blocker",nil)
            end,
            text = function(inst)
                return "【噩梦】 无法通过睡觉恢复生命值"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 4、【诅咒】【凡庸】【每天最多只能制作10个物品】【从诅咒池移除】
        ["mediocre"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
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
                local debuff_prefab = "hoshino_card_debuff_builder_blocker"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                local debuff_prefab = "hoshino_card_debuff_builder_blocker"
                for i = 1, 100, 1 do
                    inst:RemoveDebuff("hoshino_card_debuff_builder_blocker")
                end
                inst.components.hoshino_com_builder_blocker:ResetDailyMax()
            end,
            text = function(inst)
                return "【凡庸】 每天最多只能制作10个物品"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 5、【诅咒】【键山雏】【白卡的权重提升5】【可叠加】
        ["keyhole_mountain_chick"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_cards_sys:Card_Pool_Delata("card_white",5)
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                inst.components.hoshino_cards_sys:Card_Pool_Delata("card_white",-5)
            end,
            text = function(inst)
                return "【键山雏】 白卡的权重提升5"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 6、【诅咒】【弱视】【出现遮挡视线的遮罩】【不可叠加】
        ["amblyopia"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                if inst.components.hoshino_cards_sys:Get("amblyopia_active") then
                    return false
                end
                return true
            end,
            fn = function(inst)
                inst:PushEvent("hoshino_event.amblyopia_active",true)
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                inst:PushEvent("hoshino_event.amblyopia_active",false)
                inst.components.hoshino_cards_sys:Set("amblyopia_active",nil)
            end,
            text = function(inst)
                return "【弱视】 视线将被遮挡"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 7、【诅咒】【泛社会悖论】【商店物品售价+10%（向上取整）】【可叠加】
        ["shop_price_increase"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                --------------------------------------------------------------------------------------------
                --- 设置倍增参数（包括初始化）
                    local current = inst.components.hoshino_com_shop:Add("black_card_price_mult",0)
                    --- 初始化
                    if current == 0 then
                        current = 1
                    end
                    current = current + 0.10
                    inst.components.hoshino_com_shop:Set("black_card_price_mult",current)
                --------------------------------------------------------------------------------------------
                --- 没debuff就上debuff
                    local debuff_prefab = "hoshino_card_debuff_price_mult"
                    while true do
                        local debuff_inst = inst:GetDebuff(debuff_prefab)
                        if debuff_inst and debuff_inst:IsValid() then
                            break
                        end
                        inst:AddDebuff(debuff_prefab,debuff_prefab)
                    end
                --------------------------------------------------------------------------------------------
                --- 更新debuff的参数
                    inst:PushEvent("hoshino_event.black_card_price_mult_update")
                --------------------------------------------------------------------------------------------

            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                inst.components.hoshino_com_shop:Add("black_card_price_mult",-0.10)
            end,
            text = function(inst)
                return "【泛社会悖论】 商店物品售价+10%（向上取整）"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 8、【诅咒】【流血】【当你受到伤害掉血X点（向上取整）的时候，在X秒内每秒掉1点】【从诅咒池移除】
        ["bloodshed"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_bloodshed"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_bloodshed"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                local debuff_prefab = "hoshino_card_debuff_bloodshed"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        debuff_inst:Remove()
                    end
                end
            end,
            text = function(inst)
                return "【流血】\n当你受到伤害掉血X点（向上取整）\n的时候，在X秒内每秒掉1点"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 9、【诅咒】【无实体】【血量的最高上限为1】【从诅咒池移除】
        ["max_health_1"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_max_health_1"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_max_health_1"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                local debuff_prefab = "hoshino_card_debuff_max_health_1"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        debuff_inst:Remove()
                    end
                end
            end,
            text = function(inst)
                return "【无实体】 “你觉得自己没有了实体”"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 10、【诅咒】【嗜睡】【每到晚上，立马原地睡觉（至少20s ）】【从诅咒池移除】
        ["force_night_sleep"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_force_night_sleep"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_force_night_sleep"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                local debuff_prefab = "hoshino_card_debuff_force_night_sleep"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        debuff_inst:Remove()
                    end
                end
            end,
            text = function(inst)
                return "【嗜睡】 每到晚上，立马原地睡觉"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 11、【诅咒】【斗争之心】【你只能从BOSS生物中获取经验值】【从诅咒池移除】
        ["only_epic_exp"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_exp_and_epic"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_exp_and_epic"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                local debuff_prefab = "hoshino_card_debuff_exp_and_epic"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        debuff_inst:Remove()
                    end
                end
            end,
            text = function(inst)
                return "【斗争之心】 只能从BOSS生物中获取经验值"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 12、【诅咒】【饥饿值自然掉速进行2的X次幂】【可叠加】
        ["hunger_auto_down_by_the_xth_power_of_2"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                inst.components.hoshino_com_debuff:Add_Hunger_Down_Mult_2x_Times(1)
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                inst.components.hoshino_com_debuff:Add_Hunger_Down_Mult_2x_Times(-1)
            end,
            text = function(inst)
                return " \n【反魂胃 八分饱】\n饥饿值自然掉速进行2的X次幂\n当前X值+1"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 13、【诅咒】【黑星】【你的San永久为0】【从诅咒池移除】
        ["sanity_ever_zero"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_sanity_ever_zero"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_sanity_ever_zero"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                local debuff_prefab = "hoshino_card_debuff_sanity_ever_zero"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        debuff_inst:Remove()
                    end
                end
                inst.components.sanity:DoDelta(100)
            end,
            text = function(inst)
                return "【黑星】 San永久为0"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 14、【诅咒】【咒印】【你无法穿戴任何装备，持续2天】【时间叠加】
        ["equipment_blocker"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                return true
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_equipment_blocker"
                inst.components.hoshino_com_debuff:Add(debuff_prefab,2*480)
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                local debuff_prefab = "hoshino_card_debuff_equipment_blocker"
                inst.components.hoshino_com_debuff:Add(debuff_prefab,-2*480)
            end,
            text = function(inst)
                return "【咒印】 你无法穿戴任何装备，持续2天"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 15、【诅咒】【潮湿】【你的潮湿度永远无法降低】【从诅咒池移除】
        ["moisture_down_blocker"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_moisture_down_blocker"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_moisture_down_blocker"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                local debuff_prefab = "hoshino_card_debuff_moisture_down_blocker"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        debuff_inst:Remove()
                    end
                end
            end,
            text = function(inst)
                return "【潮湿】 你的潮湿度永远无法降低"
            end,
        },
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 16、【诅咒】【虚弱】【工作效率降低50%】【从诅咒池移除】
        ["reduced_work_efficiency"] = {
            back = "card_black",
            front = {atlas = "images/inspect_pad/page_level_up.xml" ,image = "card_black.tex"},
            test = function(inst)
                local debuff_prefab = "hoshino_card_debuff_reduced_work_efficiency"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        return false
                    end
                end
                return true
            end,
            fn = function(inst)
                local debuff_prefab = "hoshino_card_debuff_reduced_work_efficiency"
                while true do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    inst:AddDebuff(debuff_prefab,debuff_prefab)
                end
            end,
            deactive_fn = function(inst) --- 诅咒去除（单次）
                local debuff_prefab = "hoshino_card_debuff_reduced_work_efficiency"
                for i = 1, 5, 1 do
                    local debuff_inst = inst:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        debuff_inst:Remove()
                    end
                end
            end,
            text = function(inst)
                return "【虚弱】 工作效率降低50%"
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