
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
        -- ThePlayer.AnimState:PlayAnimation("hoshino_ex_walk_loop")
        -- ThePlayer.AnimState:PlayAnimation("hoshino_atk")
        -- ThePlayer.AnimState:PlayAnimation("hoshino_ex_pre")
        -- ThePlayer.AnimState:PushAnimation("hoshino_ex_loop")

        -- ThePlayer.AnimState:PlayAnimation("anim_02_pre")
        -- ThePlayer.AnimState:PushAnimation("anim_02_walk_loop",true)
    ----------------------------------------------------------------------------------------------------------------
    ---
            -- local weapon = ThePlayer.components.combat:GetWeapon()
            -- weapon.components.finiteuses:SetPercent(1)
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- ThePlayer.__time_fn = function(i)
        --     return (i-1)*0.02
        -- end
        -- ThePlayer.__test_color = Vector3(255/255, 255/255, 0/255)
    ----------------------------------------------------------------------------------------------------------------
    ---
            -- for k, v in pairs(ThePlayer.HOSHINO_SHOP) do
            --     print(k,v)
            -- end
            -- ThePlayer.components.hoshino_com_shop:CreditCoinDelta(1000)
            -- ThePlayer.components.hoshino_com_shop:BlueSchistDelta(15)

                -- ThePlayer.components.hoshino_com_level_sys:Exp_DoDelta(1000)

                -- local TEMP = ThePlayer.components.builder:GetIngredients("pighouse")
                -- for k, v in pairs(TEMP) do
                --     print(k)
                --     for k2, v2 in pairs(v) do
                --         print(k2,v2)
                --     end
                -- end
    ----------------------------------------------------------------------------------------------------------------
    --- 技能名和CD
                    -- ThePlayer.components.hoshino_com_spell_cd_timer:StartCDTimer("gun_eye_of_horus_ex",30)
                    -- ThePlayer.components.hoshino_com_spell_cd_timer:StartCDTimer("gun_eye_of_horus_ex_test",5)
                    -- ThePlayer.components.hoshino_com_power_cost:DoDelta(10)
                    ThePlayer.components.hoshino_com_level_sys:Exp_DoDelta(30)
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))