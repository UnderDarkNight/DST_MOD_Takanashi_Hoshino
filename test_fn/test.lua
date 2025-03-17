
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面调试
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"


    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"

    local ScrollableList = require "widgets/scrollablelist"
    -- local EmoteButton = require "widgets/hoshino_emote_button"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local flg,error_code = pcall(function()
    print("WARNING:PCALL START +++++++++++++++++++++++++++++++++++++++++++++++++")
    local x,y,z =    ThePlayer.Transform:GetWorldPosition()  
    ----------------------------------------------------------------------------------------------------------------    ----------------------------------------------------------------------------------------------------------------
    --- 
        if TheWorld.ismastersim then
            ThePlayer.components.hoshino_com_power_cost:DoDelta(100)
        end
        
    ----------------------------------------------------------------------------------------------------------------    ----------------------------------------------------------------------------------------------------------------
    --- 卡牌调试
        -- local item = SpawnPrefab("hoshino_item_cards_pack")
        -- item:PushEvent("Set",{
        --         cards = {
        --             -- "card_golden",
        --             -- "card_white",
        -- --             -- "card_colourful",
        -- --             -- "card_colourful",
        -- --             -- "card_golden",
        --             -- "card_black",
        --             -- "card_black",
        --             -- "card_colourful",

        --             "sacrifice",
        -- --             -- "unlock_spell_normal_ex",
        -- --             -- "unlock_spell_swimming_ex",
        -- --             -- "unlock_spell_all_normal",
        -- --             -- "unlock_spell_all_swimming",
        -- --             -- "kill_and_explode",
        -- --             -- "give_me_some_money",
        -- --             "level_up_and_double_card_pack",
        --         },
        --     }
        -- )
        -- ThePlayer.components.inventory:GiveItem(item)
    ----------------------------------------------------------------------------------------------------------------
    --- 调试任务栏
        -- ThePlayer.___task_board_widget_fn = function(inst,front_root)
            
        -- end
        -- ThePlayer.components.hoshino_com_task_sys_for_player:Refresh_DoDelta(10)

        -- print(TheWorld.Map:GetTileAtPoint(x,y,z))

        local box = TheSim:FindFirstEntityWithTag("set_the_same_followers")
        -- box.components.container:GiveItem(SpawnPrefab("hoshino_mission_white_12"))
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_colourful_12")
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_golden_31")
        -- box.components.hoshino_com_task_sys_for_building:Refresh_All()
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_white_11")

        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_blue_02",2)
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_blue_02",3)
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_blue_02",4)
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_blue_02",5)

        -- TUNING.HOSHINO_FNS:Client_PlaySound("dontstarve/common/together/celestial_orb/active")
        -- local inst = CreateEntity()
        -- inst.entity:AddSoundEmitter()        
        -- ThePlayer.components.hoshino_com_shop:CreditCoinDelta(1000)

        -- ThePlayer.__test_speed = 1
        -- print("66",ThePlayer.components.hoshino_com_task_sys_for_player:HasTask("hoshino_mission_golden_29"))

        -- print(ThePlayer.components.hoshino_data:Add("travel_traces_spanwer_golden",0,0,1000))
    ----------------------------------------------------------------------------------------------------------------
    --- 
        -- for i = 1, 30, 1 do
        --     ThePlayer:AddDebuff("hoshino_card_debuff_void_throat","hoshino_card_debuff_void_throat")
        -- end
        ThePlayer:AddDebuff("hoshino_debuff_bomb_shield","hoshino_debuff_bomb_shield")
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))