
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
        ThePlayer.____recipe_box_fn = function(page,MainScale)
            local atlas = "images/inspect_pad/special_equipment_recipes.xml"
            local recipe_box = page:AddChild(Image())
            recipe_box:SetTexture(atlas,"background.tex")
            recipe_box:SetPosition(270,-28)
            recipe_box:SetScale(MainScale,MainScale,MainScale)

            ----------------------------------------------------------------------------------------
            --- 关闭按钮
                local button_close = recipe_box:AddChild(ImageButton(
                        atlas,"button_close.tex","button_close.tex","button_close.tex",
                        "button_close.tex","button_close.tex"))
                    button_close:SetPosition(140,190)
                    button_close:SetOnClick(function()
                        recipe_box:Kill()
                    end)
                local close_button_focus_scale = 1.02
                button_close.focus_scale = {close_button_focus_scale,close_button_focus_scale,close_button_focus_scale}
            ----------------------------------------------------------------------------------------
            --- 页面
                local current_page = 1
                local recipe_image = recipe_box:AddChild(Image())
                recipe_image:SetTexture(atlas,"page_1.tex")
                recipe_image:SetPosition(0,-5)                
            ----------------------------------------------------------------------------------------
            --- 上下页面

                local page_switch_box = recipe_box:AddChild(Widget())
                page_switch_box:SetPosition(0,-185)
                local page_text = page_switch_box:AddChild(Text(CODEFONT,50,"1",{ 0/255 , 0/255 ,0/255 , 1}))
                local button_last = page_switch_box:AddChild(ImageButton(
                        atlas,"button_last.tex","button_last.tex","button_last.tex",
                        "button_last.tex","button_last.tex"))
                button_last:SetPosition(-40,0)
                local button_next = page_switch_box:AddChild(ImageButton(
                        atlas,"button_next.tex","button_next.tex","button_next.tex",
                        "button_next.tex","button_next.tex"))
                button_next:SetPosition(40,0)

                local function recipe_page_switch(num)
                    current_page = current_page + num
                    if current_page > 9 then
                        current_page = 1
                    end
                    if current_page < 1 then
                        current_page = 9
                    end
                    recipe_image:SetTexture(atlas,"page_"..current_page..".tex")
                    page_text:SetString(current_page)
                end

                button_last:SetOnClick(function()
                    recipe_page_switch(-1)
                end)
                button_next:SetOnClick(function()
                    recipe_page_switch(1)
                end)
            ----------------------------------------------------------------------------------------
        end
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))