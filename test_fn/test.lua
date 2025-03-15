
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
        local item = SpawnPrefab("hoshino_item_cards_pack")
        item:PushEvent("Set",{
                cards = {
                    -- "card_golden",
                    -- "card_white",
        --             -- "card_colourful",
        --             -- "card_colourful",
        --             -- "card_golden",
                    -- "card_black",
                    -- "card_black",
                    -- "card_colourful",

                    "hell_contract",
        --             -- "unlock_spell_normal_ex",
        --             -- "unlock_spell_swimming_ex",
        --             -- "unlock_spell_all_normal",
        --             -- "unlock_spell_all_swimming",
        --             -- "kill_and_explode",
        --             -- "give_me_some_money",
        --             "level_up_and_double_card_pack",
                },
            }
        )
        ThePlayer.components.inventory:GiveItem(item)
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
        -- local inst = ThePlayer
        -- inst.components.hoshino_com_debuff:Add_Halo_Radius(1)
        -- inst:PushEvent("hoshino_event.halo_refresh")

        -- local function CreateHudInfo(anim_data)
        --     -----------------------------------------------------
        --     -- 前置根节点
        --         local front_root = ThePlayer.HUD
        --     -----------------------------------------------------
        --     -- 根节点
        --         local root = front_root:AddChild(Widget())
        --         root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        --         root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        --         root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        --     -----------------------------------------------------
        --     --- 跟随玩家
        --         TheInput:Hoshino_Add_Update_Custom_Fn(root.inst,function()
        --             local s_pt_x,s_pt_y= TheSim:GetScreenPos(ThePlayer.Transform:GetWorldPosition()) -- 左下角为原点。
        --             -- print("player in screen",s_pt_x,s_pt_y)
        --             root:SetPosition(s_pt_x,s_pt_y,0)
        --         end)
        --     -----------------------------------------------------
        --     ----
        --         local scale = 0.5
        --         local start_x = -90
        --         local start_y = 0
        --         local offset_y = 30
        --         local time = 0
        --         local time_offset = 0.6
        --         for anim_name, v in pairs(anim_data) do
        --             local temp = root:AddChild(UIAnim())
        --             temp:SetPosition(start_x,start_y,0)
        --             temp:GetAnimState():SetBank("hoshino_card_debuff_experimental_therapy")
        --             temp:GetAnimState():SetBuild("hoshino_card_debuff_experimental_therapy")
        --             temp:GetAnimState():PlayAnimation(anim_name,true)
        --             temp:GetAnimState():SetTime(time)
        --             temp:SetScale(scale,scale,scale)
        --             start_y = start_y + offset_y
        --             time = time + time_offset
        --         end
        --     -----------------------------------------------------
        --         return root
        --     -----------------------------------------------------
        -- end
        -- local data = {
        --     health = 10,
        --     sanity = -10,
        --     hunger = 10,
        --     damage = 0.05,
        --     speed = -0.05,
        --     planar_defense = 3,
        -- }
        -- local anim_data = {}
        -- for index, value in pairs(data) do
        --     if value > 0 then
        --         anim_data["up_"..index] = value
        --     else
        --         anim_data["down_"..index] = -value
        --     end
        -- end
        -- if ThePlayer.test_root then
        --     ThePlayer.test_root:Kill()
        -- end
        -- ThePlayer.test_root = CreateHudInfo(anim_data)

        -- ThePlayer:AddDebuff("hoshino_card_debuff_nine_lives_cat","hoshino_card_debuff_nine_lives_cat")


    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))