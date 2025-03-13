
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
        -- --             -- "card_golden",
        -- --             -- "card_white",
        -- --             -- "card_colourful",
        -- --             -- "card_colourful",
        -- --             -- "card_golden",
        -- --             -- "card_black",
        --             "speed_up_and_damage_up_6_10",
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

        local box = TheSim:FindFirstEntityWithTag("hoshino_building_task_board")
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
        -- ThePlayer.components.hoshino_com_debuff:Add_Planar_Defense(200)
        -- ThePlayer.components.hoshino_com_inventory_custom_apply_damage:AddBeforeApplyDamageFn(ThePlayer,function(inst,damage, attacker, weapon, spdamage)
        --     return 0,nil
        -- end)
        -- SpawnPrefab("hoshino_sfx_explode"):PushEvent("Set",{
        --     target = ThePlayer,
        -- })
        -- ThePlayer:AddDebuff("hoshino_card_debuff_weapon_dmg_up_by_range","hoshino_card_debuff_weapon_dmg_up_by_range")
        -- print(math.random(-10,10))
        -- local item = SpawnPrefab("log")
        -- -- item.Transform:SetPosition(x,y,z)
        -- -- LaunchAt(item,ThePlayer, nil, 0.2, 0.1)
        -- local record = item:GetSaveRecord()
        -- for k, v in pairs(record) do
        --     print(k,v)
        -- end

        local gift_pack = SpawnPrefab("hoshino_item_special_gift_pack")
        gift_pack:PushEvent("Set",{
            num = math.random(6),
            name = "AAAAA",
            desc = "BBBBB",
        })
        gift_pack:PushEvent("AddItemRecord",SpawnPrefab("log"))
        gift_pack:PushEvent("AddItemRecord",SpawnPrefab("goldnugget"))
        gift_pack:PushEvent("AddItemRecord",SpawnPrefab("moonrocknugget"))

        local s_pt = Vector3(x,y,z)
        SpawnPrefab("hoshino_sfx_colorful_sky_door"):PushEvent("Set",{
            pt = Vector3(s_pt.x,s_pt.y+1,s_pt.z),
            scale = Vector3(2.5,1,2.5)
        })
        ThePlayer:DoTaskInTime(3,function()
            gift_pack.Transform:SetPosition(s_pt.x,8,s_pt.z)
        end)
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))