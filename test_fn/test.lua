
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
        --             "kill_and_explode",
        --         },
        --     }
        -- )
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
    ---
        -- ThePlayer.___task_board_widget_fn = function(inst,front_root)
            
        -- end
        ThePlayer.components.hoshino_com_task_sys_for_player:Refresh_DoDelta(10)









    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))