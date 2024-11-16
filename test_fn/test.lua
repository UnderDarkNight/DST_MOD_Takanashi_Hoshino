
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
        --             "card_golden",
        --             -- "kill_and_explode",
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

        local box = TheSim:FindFirstEntityWithTag("hoshino_building_task_board")
        -- box.components.container:GiveItem(SpawnPrefab("hoshino_mission_white_12"))
        box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_golden_29")
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_white_11")

        -- TUNING.HOSHINO_FNS:Client_PlaySound("dontstarve/common/together/celestial_orb/active")
        -- local inst = CreateEntity()
        -- inst.entity:AddSoundEmitter()        


        ThePlayer.components.hoshino_com_power_cost:DoDelta(100)

        print("66",ThePlayer.components.hoshino_com_task_sys_for_player:HasTask("hoshino_mission_golden_29"))
    ----------------------------------------------------------------------------------------------------------------
    --- 藏宝图 调试
        
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))