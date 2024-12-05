
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
    --- 卡牌调试
        -- local item = SpawnPrefab("hoshino_item_cards_pack")
        -- item:PushEvent("Set",{
        --         cards = {
        --             -- "card_golden",
        --             -- "card_white",
        --             -- "card_colourful",
        --             -- "card_colourful",
        --             -- "card_golden",
        --             -- "card_black",
        --             -- "kill_and_explode",
        --             "unlock_spell_normal_ex",
        --             -- "unlock_spell_swimming_ex",
        --             -- "unlock_spell_all_normal",
        --             -- "unlock_spell_all_swimming",
        --             -- "kill_and_explode",
        --         },
        --     }
        -- )
        -- ThePlayer.components.inventory:GiveItem(item)
        -- local item = SpawnPrefab("hoshino_item_cards_pack")
        -- item:PushEvent("Set",{
        --         cards = {
        --             -- "card_golden",
        --             -- "card_white",
        --             -- "card_colourful",
        --             -- "card_colourful",
        --             -- "card_golden",
        --             -- "card_black",
        --             -- "kill_and_explode",
        --             -- "unlock_spell_normal_ex",
        --             -- "unlock_spell_swimming_ex",
        --             "unlock_spell_all_normal",
        --             -- "unlock_spell_all_swimming",
        --         },
        --     }
        -- )
        -- ThePlayer.components.inventory:GiveItem(item)
    ----------------------------------------------------------------------------------------------------------------
    --- 卡牌调试-变种
        -- local item = SpawnPrefab("hoshino_item_cards_pack")
        -- item:PushEvent("Type","hoshino_item_cards_pack_authority_to_unveil_secrets")

        -- -- item:PushEvent("SetName","窥秘权柄") -- 金色
        -- -- item:PushEvent("Set",{
        -- --         cards = {
        -- --             "card_golden",
        -- --             "card_golden",
        -- --             "card_golden",
        -- --         },
        -- --     }
        -- -- )
        -- -- item:PushEvent("SetDisplay",{
        -- --     bank = "hoshino_item_cards_pack_authority_to_unveil_secrets",
        -- --     build = "hoshino_item_cards_pack_authority_to_unveil_secrets",
        -- --     anim = "idle",
        -- --     imagename = "hoshino_item_cards_pack_authority_to_unveil_secrets",
        -- --     atlasname = "images/inventoryimages/hoshino_item_cards_pack_authority_to_unveil_secrets.xml",
        -- -- })
        -- ThePlayer.components.inventory:GiveItem(item)

        -- local item = SpawnPrefab("hoshino_item_cards_pack")
        -- item:PushEvent("Type","hoshino_item_cards_pack_supreme_mystery")

        -- -- item:PushEvent("SetName","最高神秘") -- 彩色
        -- -- item:PushEvent("Set",{
        -- --         cards = {
        -- --             "card_colourful",
        -- --             "card_colourful",
        -- --             "card_colourful",
        -- --         },
        -- --     }
        -- -- )
        -- -- item:PushEvent("SetDisplay",{
        -- --     bank = "hoshino_item_cards_pack_supreme_mystery",
        -- --     build = "hoshino_item_cards_pack_supreme_mystery",
        -- --     anim = "idle",
        -- --     imagename = "hoshino_item_cards_pack_supreme_mystery",
        -- --     atlasname = "images/inventoryimages/hoshino_item_cards_pack_supreme_mystery.xml",
        -- -- })
        -- ThePlayer.components.inventory:GiveItem(item)
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- ThePlayer:ListenForEvent("newstate",function(inst,_table)
        --     local statename = _table and _table.statename
        --     if statename then
        --         print("newstate:",statename)
        --     end
        -- end)
    ----------------------------------------------------------------------------------------------------------------
    ---
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- ThePlayer.components.hoshino_com_shop:BlueSchistDelta(123)
        -- ThePlayer.components.hoshino_com_shop:CreditCoinDelta(222)
        -- ThePlayer.components.hoshino_com_task_sys_for_player:GiveTask("hoshino_task_excample_kill")
        -- ThePlayer.components.hoshino_com_task_sys_for_player:GiveTask("hoshino_task_excample_item")
        -- print("+++++++++",inst)
        -- print(inst:GetDebugString())

        -- local container = ThePlayer.components.hoshino_com_task_sys_for_player:GetContainer()
        -- local items = container:GetAllItems()
        -- for i = 1, 5, 1 do
        --     print("+++++++++",items[i])
        -- end


        -- local task_backpack = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_TASK_BACKPACK)
        -- local items = task_backpack.replica.container:GetItems()
        -- for i = 1, 5, 1 do
        --     print("+++++++++",items[i])
        -- end
    ----------------------------------------------------------------------------------------------------------------
    --- 调试任务栏
        -- ThePlayer.___task_board_widget_fn = function(inst,front_root)
            
        -- end
        -- ThePlayer.components.hoshino_com_task_sys_for_player:Refresh_DoDelta(10)

        -- print(TheWorld.Map:GetTileAtPoint(x,y,z))

        -- local box = TheSim:FindFirstEntityWithTag("hoshino_building_task_board")
        -- box.components.container:GiveItem(SpawnPrefab("hoshino_mission_white_12"))
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_colourful_12")
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_golden_27")
        -- box.components.hoshino_com_task_sys_for_building:Refresh_All()
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_white_11")

        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_blue_02",2)
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_blue_02",3)
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_blue_02",4)
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_blue_02",5)

        -- TUNING.HOSHINO_FNS:Client_PlaySound("dontstarve/common/together/celestial_orb/active")
        -- local inst = CreateEntity()
        -- inst.entity:AddSoundEmitter()        
        -- ThePlayer.components.hoshino_com_shop:CreditCoinDelta(-10000)

        ThePlayer.components.hoshino_com_power_cost:DoDelta(100)

        -- print("66",ThePlayer.components.hoshino_com_task_sys_for_player:HasTask("hoshino_mission_golden_29"))

        -- print(ThePlayer.components.hoshino_data:Add("travel_traces_spanwer_golden",0,0,1000))
    ----------------------------------------------------------------------------------------------------------------
    --- 
        -- if ThePlayer.__old_AddDebuff == nil then
        --     ThePlayer.__old_AddDebuff = ThePlayer.AddDebuff
        --     ThePlayer.AddDebuff = function(inst,debuff_name,debuff_prefab,...)
        --         print("AddDebuff",debuff_name,debuff_prefab,...)
        --         return inst:__old_AddDebuff(debuff_name,debuff_prefab,...)
        --     end
        -- end
        
    ----------------------------------------------------------------------------------------------------------------
    --- 精神控制
        -- local inst = ThePlayer
        -- for i = 1, 15, 1 do
        --     inst:DoTaskInTime(0.5*i, function()
        --         inst:AddDebuff("mindcontroller", "mindcontroller")
        --     end)
        -- end
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- ThePlayer:AddDebuff("hoshino_equipment_spider_core_debuff", "hoshino_equipment_spider_core_debuff")

    ----------------------------------------------------------------------------------------------------------------
    ----
        -- TheWorld:PushEvent("ms_setclocksegs", {day = 0, dusk = 0, night = 16})
        -- TheWorld:PushEvent("ms_setmoonphase", {moonphase = "new", iswaxing = true})

        -- TheWorld:PushEvent("ms_setclocksegs", {day = 0, dusk = 0, night = 16})
        -- TheWorld:PushEvent("ms_setmoonphase", {moonphase = "full", iswaxing = false}) 
    ----------------------------------------------------------------------------------------------------------------
    ---
    ----------------------------------------------------------------------------------------------------------------
    ---
    -- local target_num = 0
    -- TheNet:Announce("触发连锁爆炸,炸到了"..target_num.."个生物")
        if  ThePlayer.__old_AddDebuff == nil then
            ThePlayer.__old_AddDebuff = ThePlayer.AddDebuff
            ThePlayer.AddDebuff = function(inst,debuff_name,debuff_prefab,...)
                print("AddDebuff",debuff_name,debuff_prefab,...)
                return inst:__old_AddDebuff(debuff_name,debuff_prefab,...)
            end
        end
    ----------------------------------------------------------------------------------------------------------------
    --- 无人机控制器
        local drone_controller_atlas = "images/widgets/hoshino_drone_controller.xml"
        local MainScale = 0.6
        ThePlayer.___test_fn = function(root)
            -----------------------------------------------------------------------------------
            --- 按钮坐标 横向4个按钮，高度4个按钮
                local start_x = -150
                local start_y = 150
                local delta_x = 100
                local delta_y = -100
                local button_pos = {
                }
                for y=1,4 do
                    for x=1,4 do
                        table.insert(button_pos,Vector3(start_x + delta_x * (x-1),start_y + delta_y * (y-1),0))
                    end
                end
            -----------------------------------------------------------------------------------
            --- 测试布局
                -- root.test_buttons = {}
                -- for i = 1, #button_pos do
                --     local test_button = root:AddChild(ImageButton(
                --         drone_controller_atlas,"stop_attack.tex","stop_attack.tex","stop_attack.tex","stop_attack.tex","stop_attack.tex"
                --     ))
                --     test_button:SetOnClick(function()
                --         print("test_button",i)
                --     end)
                --     test_button:SetScale(MainScale,MainScale,MainScale)
                --     test_button.focus_scale = {1.05, 1.05, 1.05}
                --     test_button:SetPosition(button_pos[i].x,button_pos[i].y)
                -- end
            -----------------------------------------------------------------------------------
            --- 停止攻击 stop_attack
                local button_stop_attack =  root:AddChild(ImageButton(
                    drone_controller_atlas,"stop_attack.tex","stop_attack.tex","stop_attack.tex","stop_attack.tex","stop_attack.tex"
                ))
                button_stop_attack:SetOnClick(function()
                    
                end)
                button_stop_attack:SetScale(MainScale,MainScale,MainScale)
                button_stop_attack.focus_scale = {1.05, 1.05, 1.05}
                button_stop_attack:SetPosition(button_pos[1].x,button_pos[1].y)
            -----------------------------------------------------------------------------------
            --- 解除攻击 disarm
                local button_disarm =  root:AddChild(ImageButton(
                    drone_controller_atlas,"disarm.tex","disarm.tex","disarm.tex","disarm.tex","disarm.tex"
                ))
                button_disarm:SetOnClick(function()
                    
                end)
                button_disarm:SetScale(MainScale,MainScale,MainScale)
                button_disarm.focus_scale = {1.05, 1.05, 1.05}
                button_disarm:SetPosition(button_pos[2].x,button_pos[2].y)
            -----------------------------------------------------------------------------------
            --- 停止工作 stop_working
                local button_stop_working =  root:AddChild(ImageButton(
                    drone_controller_atlas,"stop_working.tex","stop_working.tex","stop_working.tex","stop_working.tex","stop_working.tex"
                ))
                button_stop_working:SetOnClick(function()
                    
                end)
                button_stop_working:SetScale(MainScale,MainScale,MainScale)
                button_stop_working.focus_scale = {1.05, 1.05, 1.05}
                button_stop_working:SetPosition(button_pos[3].x,button_pos[3].y)
            -----------------------------------------------------------------------------------
            --- 落地打包 trans_2_item
                local button_trans_2_item =  root:AddChild(ImageButton(
                    drone_controller_atlas,"trans_2_item.tex","trans_2_item.tex","trans_2_item.tex","trans_2_item.tex","trans_2_item.tex"
                ))
                button_trans_2_item:SetOnClick(function()
                    
                end)
                button_trans_2_item:SetScale(MainScale,MainScale,MainScale)
                button_trans_2_item.focus_scale = {1.05, 1.05, 1.05}
                button_trans_2_item:SetPosition(button_pos[4].x,button_pos[4].y)
            -----------------------------------------------------------------------------------
        end

        -- local inst = TheSim:FindFirstEntityWithTag("hoshino_building_white_drone")
        -- inst:PushEvent("command.trans_2_item")
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))