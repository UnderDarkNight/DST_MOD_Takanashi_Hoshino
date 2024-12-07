    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


    平板

    

]]---
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local Widget = require "widgets/widget"
    local Screen = require "widgets/screen"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    TUNING.HOSHINO_INSPECT_PAD_BOX_FNS = TUNING.HOSHINO_INSPECT_PAD_BOX_FNS or {}
    local buff_icon_atlas = "images/inspect_pad/hoshino_pad_buff_icon.xml"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 基础API
    local has_icon = {
        ["absolute_defense"] = true,
        ["amblyopia"] = true,
        ["armor_damage_type_resist"] = true,
        ["armor_down_blocker_percent"] = true,
        ["armor_planar_defense"] = true,
        ["a_lifesaver"] = true,
        ["bloodshed"] = true,
        ["buff_health_down_and_coins_up"] = true,
        ["cards_refresh_num"] = true,
        ["card_shop_refresh_count"] = true,
        ["card_temperature_locker"] = true,
        ["counter_damage"] = true,
        ["damage_mult_up_10_percent_and_sanity_down"] = true,
        ["damage_mult_up_4_percent"] = true,
        ["damage_taken_mult_6"] = true,
        ["direct_kill_target"] = true,
        ["eater_indigestion"] = true,
        ["equipment_blocker"] = true,
        ["exp_up_mult_up_10_percent"] = true,
        ["final_health_down_value_reduce"] = true,
        ["force_night_sleep"] = true,
        ["give_me_some_money"] = true,
        ["halth_sanity_hunger_max_up_20"] = true,
        ["health_auto_up"] = true,
        ["health_penalty_blocker"] = true,
        ["hunger_auto_down_by_the_xth_power_of_2"] = true,
        ["hunger_down_mult_down_3_percent"] = true,
        ["i_have_expanded"] = true,
        ["keyhole_mountain_chick"] = true,
        ["kill_and_explode"] = true,
        ["level_up_and_double_card_pack"] = true,
        ["max_daily_earn"] = true,
        ["max_health_1"] = true,
        ["max_health_up_15"] = true,
        ["max_hunger_up_8"] = true,
        ["max_sanity_up_10"] = true,
        ["mediocre"] = true,
        ["moisture_down_blocker"] = true,
        ["more_default_selectting_cards"] = true,
        ["only_epic_exp"] = true,
        ["probability_of_returning_full_recipe"] = true,
        ["rare_cards_appearance_weight"] = true,
        ["reduced_work_efficiency"] = true,
        ["returning_half_recipe_by_count"] = true,
        ["ruins_sheild_and_vengeance"] = true,
        ["sanity_ever_zero"] = true,
        ["shop_price_increase"] = true,
        ["sleeping_bag_health_blocker"] = true,
        ["speed_up_2_percent"] = true,
        ["speed_up_and_damage_up_6_10"] = true,
        ["summon_rocky"] = true,
        ["the_eye_of_horus_finiteuses_down_block"] = true,
        ["the_rsistance_of_horus"] = true,
        ["unlock_spell_all_normal"] = true,
        ["unlock_spell_all_swimming"] = true,
        ["unlock_spell_normal_ex"] = true,
        ["unlock_spell_swimming_ex"] = true,
        ["warly_eater_modules_unlock"] = true,
    }
    local function Get_Card_And_Num(data)
            local ret_data = {}
            local ret_data2 = {}
            for card_type ,_temp_data in pairs(data) do
                if type(_temp_data) == "table" then
                    for card_name_index, v in pairs(_temp_data) do
                        if type(card_name_index) == "string" and type(v) == "number" and v > 0 and has_icon[card_name_index] then
                            ret_data[card_name_index] = v
                            table.insert(ret_data2,{card_name_index, v})
                        end
                    end
                end
            end
            return ret_data2
    end
    local function GetActivedCardsData()
        return ThePlayer.PAD_DATA and ThePlayer.PAD_DATA.actived_cards or {}
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    function TUNING.HOSHINO_INSPECT_PAD_BOX_FNS:Create_Buff_Icon_Box(front_root)
        -------------------------------------------------------------
        ---
            local root = front_root:AddChild(Widget())
            root:SetPosition(250,280)
        -------------------------------------------------------------
        ---
            local start_pt = Vector3(0,0,0)
            local icon_pos = {}
            local delta_x = 50
            local delta_y = -70
            local x_num = 9 -- 每行个数
            local y_num = 8 -- 有多少列
            local max_num = x_num * y_num
            for y = 1, y_num do
                for x = 1, x_num do
                    local pt = Vector3(start_pt.x + (x-1)*delta_x,start_pt.y + (y-1)*delta_y,start_pt.z)
                    table.insert(icon_pos,pt)
                end
            end
        -------------------------------------------------------------
        ---            
            local data = GetActivedCardsData()
            data = Get_Card_And_Num(data)
            for i = 1, max_num, 1 do
                if data[i] ~= nil then
                    local card_name = data[i][1]
                    local card_num = data[i][2]
                    local pt = icon_pos[i]
                    -- print("card_name",card_name,card_num,pt.x,pt.y)
                    local icon = root:AddChild(Image(buff_icon_atlas,card_name..".tex"))
                    local text = icon:AddChild(Text(CODEFONT,25,"0",{ 0/255 , 0/255 ,0/255 , 1}))
                    text:SetPosition(10,-30)
                    if card_num > 1 then
                        text:SetString("x"..tostring(card_num))
                    else
                        text:SetString(" ")
                    end
                    icon:SetPosition(pt.x,pt.y)
                    icon.OnGainFocus = function()
                        -- print("OnGainFocus",data[i][1])
                        front_root.card_select_box:SetDescByCardName(card_name,true)
                    end
                end
            end
        -------------------------------------------------------------

        -------------------------------------------------------------
        return root
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------