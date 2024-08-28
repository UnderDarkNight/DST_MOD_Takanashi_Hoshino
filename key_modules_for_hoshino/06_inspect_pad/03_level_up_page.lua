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
    TUNING.HOSHINO_INSPECT_PAD_FNS = TUNING.HOSHINO_INSPECT_PAD_FNS or{}    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function page_create(front_root,MainScale)
        --------------------------------------------------------------------------------------
        --- 根节点
            local page = front_root:AddChild(Widget())
            page:SetScale(MainScale,MainScale,MainScale)
        --------------------------------------------------------------------------------------
        --- 卡牌选择区
            local card_select_box = page:AddChild(Image("images/inspect_pad/page_level_up.xml", "card_select_box.tex"))
            card_select_box:SetPosition(-270,50)
        --------------------------------------------------------------------------------------
        --- info button
            local button_info = card_select_box:AddChild(ImageButton(
                "images/inspect_pad/page_level_up.xml",
                "button_info.tex",
                "button_info.tex",
                "button_info.tex",
                "button_info.tex",
                "button_info.tex"
            ))
            button_info:SetPosition(-360,240)
            button_info:SetOnClick(function()
                print("info button")
            end)
            button_info.focus_scale = button_info.normal_scale
        --------------------------------------------------------------------------------------
        --- 刷新按钮
            local button_refresh = card_select_box:AddChild(ImageButton(
                "images/inspect_pad/page_level_up.xml",
                "button_refresh.tex",
                "button_refresh.tex",
                "button_refresh.tex",
                "button_refresh.tex",
                "button_refresh.tex"
            ))
            button_refresh:SetPosition(260,248)
            button_refresh:SetOnClick(function()
                print("button_refresh")
            end)
            button_refresh.focus_scale = {1.02,1.02,1.02}

        --------------------------------------------------------------------------------------
        --- 卡牌区（调试）。5张牌
            local current_cards = {}
            local function CreateCard(card_type,x,y,index)
                local png = card_type ..".tex"
                local temp_card = card_select_box:AddChild(ImageButton(
                    "images/inspect_pad/page_level_up.xml",
                    png,png,png,png,png
                ))
                temp_card:SetPosition(x,y)
                temp_card:SetOnClick(function()
                    print("card click",card_type,index)
                    --- 通过RPC上传
                    ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_event.card_click",{
                        card_type = card_type,
                        index = index,
                    })
                    --- 屏蔽卡牌选择。
                    for k, v in pairs(current_cards) do
                        v:Disable()
                    end
                end)
                return temp_card
            end
            ------ 计算卡牌位置
                local function Get_Card_Points(temp_card_num)
                    local full_start_x = -320
                    local full_end_x = 320
                    local full_mid_x = (full_start_x + full_end_x) / 2
                    local full_width = math.abs(full_end_x - full_start_x)
                    local card_y = 30
                
                    local card_num = temp_card_num or 1
                    card_num = math.clamp(card_num, 1, 5)
                
                    if card_num == 1 then
                        return {Vector3((full_start_x + full_end_x) / 2, card_y, 0)}
                    end
                
                    if card_num == 2 then
                        local temp_length = full_width / 5
                        local ret_table = {}
                        table.insert(ret_table, Vector3(full_mid_x - temp_length, card_y, 0))
                        table.insert(ret_table, Vector3(full_mid_x + temp_length, card_y, 0))
                        return ret_table
                    end
                
                    if card_num == 3 then
                        local delta_x = full_width / 4
                        local ret_table = {}
                        table.insert(ret_table, Vector3(full_mid_x - delta_x, card_y, 0))
                        table.insert(ret_table, Vector3(full_mid_x, card_y, 0))
                        table.insert(ret_table, Vector3(full_mid_x + delta_x, card_y, 0))
                        return ret_table
                    end
                
                    if card_num == 4 then
                        local delta_x = full_width / 3.5
                        local ret_table = {}
                        table.insert(ret_table, Vector3(full_mid_x - 1.5 * delta_x, card_y, 0))
                        table.insert(ret_table, Vector3(full_mid_x - 0.5 * delta_x, card_y, 0))
                        table.insert(ret_table, Vector3(full_mid_x + 0.5 * delta_x, card_y, 0))
                        table.insert(ret_table, Vector3(full_mid_x + 1.5 * delta_x, card_y, 0))
                        return ret_table
                    end
                
                    if card_num == 5 then
                        local delta_x = full_width / 4
                        local ret_table = {}
                        for i = 1, 5, 1 do
                            table.insert(ret_table, Vector3(full_start_x + (i - 1) * delta_x, card_y, 0))
                        end
                        return ret_table
                    end
                
                    return {}
                end
            
            local card_num = 5
            local ret_points = Get_Card_Points(card_num)
            for i, pt in pairs(ret_points) do
                current_cards[i] = CreateCard("card_black",pt.x,pt.y,i)
            end
            ---- 服务器返回下发的数据，然后更新卡牌正面。
            page.inst:ListenForEvent("hoshino_event.card_display",function(_,_table)
                local card_index = _table.index
                local atlas = _table.atlas
                local image = _table.image
                current_cards[card_index]:SetTextures(atlas,image,image,image,image,image)
            end,ThePlayer)
        --------------------------------------------------------------------------------------
        --- 当前状态区
            local current_phrase = page:AddChild(Image("images/inspect_pad/page_level_up.xml", "current_phrase.tex"))
            current_phrase:SetPosition(450,50-3)
        --------------------------------------------------------------------------------------
        ---
            return page
        --------------------------------------------------------------------------------------

end
TUNING.HOSHINO_INSPECT_PAD_FNS["level_up"] = page_create
