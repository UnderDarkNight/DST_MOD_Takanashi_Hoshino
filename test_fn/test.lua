
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
        --             "ruins_sheild_and_vengeance",
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
            -- print( ThePlayer.components.hoshino_com_level_sys:GetExpMult() )

            -- local debuff_prefab = "hoshino_buff_special_equipment_backpack_t9"
            -- while true do
            --     local debuff_inst = ThePlayer:GetDebuff(debuff_prefab)
            --     if debuff_inst and debuff_inst:IsValid() then
            --         debuff_inst:PushEvent("reset_pool")
            --         break
            --     end
            --     ThePlayer:AddDebuff(debuff_prefab,debuff_prefab)
            -- end
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- local Ball = SpawnPrefab("waterballoon")
        local Ball = SpawnPrefab("snowball")
        Ball.Transform:SetPosition(x,y,z)
        Ball.components.complexprojectile.onhitfn(Ball,ThePlayer, ThePlayer)
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))