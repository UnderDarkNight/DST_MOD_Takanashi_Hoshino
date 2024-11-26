--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    聊天泡泡安装

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
    local Widget = require "widgets/widget"
    local Image = require "widgets/image"
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local slots = {["left"] = true,["mid"] = true,["right"] = true,}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function install_buttons(inst)
        
        if inst.hud_button_widget then
            inst.hud_button_widget:Kill()
        end
        
        -----------------------------------------------------
        --- 前置根节点
            local front_root = TheInput and ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls
            if front_root == nil then
                return
            end
        -----------------------------------------------------
        --- 根节点
            local root = front_root:AddChild(Widget())
            root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
            local MainScale = 0.6
        -----------------------------------------------------
        --- 绑定inst
            inst.hud_button_widget = root
            root.inst:ListenForEvent("onremove",function()
                root:Kill()
            end,inst)
        -----------------------------------------------------
        --- 绑定更新点
            TheInput:Hoshino_Add_Update_Modify_Fn(root.inst,function()
                if ThePlayer:GetDistanceSqToInst(inst) < 25 then
                    local s_pt_x,s_pt_y= TheSim:GetScreenPos(inst.Transform:GetWorldPosition()) -- 左下角为原点。
                    -- print("player in screen",s_pt_x,s_pt_y)
                    root:SetPosition(s_pt_x,s_pt_y,0)
                    root:Show()
                else
                    root:Hide()
                end
            end)
        -----------------------------------------------------
        --- 按钮节点
            local button_widget = root:AddChild(Widget())
            button_widget:SetScale(MainScale,MainScale,MainScale)
            button_widget:SetPosition(0,0,0)                
        -----------------------------------------------------
        ---
            local bubbles = {}
            local bubble_scale = 1.5

            bubbles["left"] = button_widget:AddChild(AnimButton("hoshino_building_shiba_seki_ramen_cart",{
                idle = "left_bubble", -- 按钮默认状态
                over = "left_bubble", -- 按钮悬停状态
                disabled = "left_bubble", -- 按钮禁用状态
            }))
            bubbles["left"]:SetPosition(-200,360,0)
            bubbles["left"]:SetOnClick(function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("item_buy",{
                    slot = "left",
                    userid = ThePlayer.userid
                },inst)
            end)
            bubbles["left"]:SetScale(bubble_scale,bubble_scale,bubble_scale)
            bubbles["left"].name_text = bubbles["left"]:AddChild(Text(CODEFONT,30,"肉汤",{ 0/255 , 0/255 ,0/255 , 1}))
            bubbles["left"].name_text:SetString("肉汤")
            bubbles["left"].name_text:SetPosition(0,22,0)
            bubbles["left"].icon = bubbles["left"]:AddChild(UIAnim())
            bubbles["left"].icon:GetAnimState():SetBank("hoshino_building_shiba_seki_ramen_cart")
            bubbles["left"].icon:GetAnimState():SetBuild("hoshino_building_shiba_seki_ramen_cart")
            bubbles["left"].icon:GetAnimState():PlayAnimation("credit_coins")
            bubbles["left"].icon:SetScale(0.2,0.2,0.2)
            bubbles["left"].icon:SetPosition(-45,0,0)
            bubbles["left"].price_text = bubbles["left"]:AddChild(Text(CODEFONT,20,"50",{ 0/255 , 0/255 ,0/255 , 1}))
            bubbles["left"].price_text:SetString("50")
            bubbles["left"].price_text:SetPosition(10,0,0)
            bubbles["left"].on_sale = bubbles["left"]:AddChild(UIAnim())
            bubbles["left"].on_sale:GetAnimState():SetBank("hoshino_building_shiba_seki_ramen_cart")
            bubbles["left"].on_sale:GetAnimState():SetBuild("hoshino_building_shiba_seki_ramen_cart")
            bubbles["left"].on_sale:GetAnimState():PlayAnimation("sale")
            bubbles["left"].on_sale:SetPosition(50,0,0)
            bubbles["left"].on_sale:SetScale(0.5,0.5,0.5)


            
            bubbles["mid"] = button_widget:AddChild(AnimButton("hoshino_building_shiba_seki_ramen_cart",{
                idle = "mid_bubble", -- 按钮默认状态
                over = "mid_bubble", -- 按钮悬停状态
                disabled = "mid_bubble", -- 按钮禁用状态
            }))
            bubbles["mid"]:SetPosition(0,430,0)
            bubbles["mid"]:SetOnClick(function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("item_buy",{
                    slot = "mid",
                    userid = ThePlayer.userid
                },inst)
            end)
            bubbles["mid"]:SetScale(bubble_scale,bubble_scale,bubble_scale)
            bubbles["mid"].name_text = bubbles["mid"]:AddChild(Text(CODEFONT,30,"拉面",{ 0/255 , 0/255 ,0/255 , 1}))
            bubbles["mid"].name_text:SetPosition(0,22,0)
            bubbles["mid"].icon = bubbles["mid"]:AddChild(UIAnim())
            bubbles["mid"].icon:GetAnimState():SetBank("hoshino_building_shiba_seki_ramen_cart")
            bubbles["mid"].icon:GetAnimState():SetBuild("hoshino_building_shiba_seki_ramen_cart")
            bubbles["mid"].icon:GetAnimState():PlayAnimation("credit_coins")
            bubbles["mid"].icon:SetPosition(-45,0,0)
            bubbles["mid"].icon:SetScale(0.2,0.2,0.2)
            bubbles["mid"].price_text = bubbles["mid"]:AddChild(Text(CODEFONT,20,"50",{ 0/255 , 0/255 ,0/255 , 1}))
            bubbles["mid"].price_text:SetPosition(10,0,0)
            bubbles["mid"].price_text:SetString("50")
            bubbles["mid"].on_sale = bubbles["mid"]:AddChild(UIAnim())
            bubbles["mid"].on_sale:GetAnimState():SetBank("hoshino_building_shiba_seki_ramen_cart")
            bubbles["mid"].on_sale:GetAnimState():SetBuild("hoshino_building_shiba_seki_ramen_cart")
            bubbles["mid"].on_sale:GetAnimState():PlayAnimation("sale")
            bubbles["mid"].on_sale:SetPosition(55,25,0)
            bubbles["mid"].on_sale:SetScale(0.5,0.5,0.5)



            bubbles["right"] = button_widget:AddChild(AnimButton("hoshino_building_shiba_seki_ramen_cart",{
                idle = "right_bubble", -- 按钮默认状态
                over = "right_bubble", -- 按钮悬停状态
                disabled = "right_bubble", -- 按钮禁用状态
            }))
            bubbles["right"]:SetPosition(200,360,0)
            bubbles["right"]:SetOnClick(function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("item_buy",{
                    slot = "right",
                    userid = ThePlayer.userid
                },inst)
            end)
            bubbles["right"]:SetScale(bubble_scale,bubble_scale,bubble_scale)
            bubbles["right"].name_text = bubbles["right"]:AddChild(Text(CODEFONT,30,"排骨拉面",{ 0/255 , 0/255 ,0/255 , 1}))
            bubbles["right"].name_text:SetPosition(0,22,0)
            bubbles["right"].icon = bubbles["right"]:AddChild(UIAnim())
            bubbles["right"].icon:GetAnimState():SetBank("hoshino_building_shiba_seki_ramen_cart")
            bubbles["right"].icon:GetAnimState():SetBuild("hoshino_building_shiba_seki_ramen_cart")
            bubbles["right"].icon:GetAnimState():PlayAnimation("credit_coins")
            bubbles["right"].icon:SetPosition(-45,0,0)
            bubbles["right"].icon:SetScale(0.2,0.2,0.2)
            bubbles["right"].price_text = bubbles["right"]:AddChild(Text(CODEFONT,20,"50",{ 0/255 , 0/255 ,0/255 , 1}))
            bubbles["right"].price_text:SetPosition(10,0,0)
            bubbles["right"].price_text:SetString("50")
            bubbles["right"].on_sale = bubbles["right"]:AddChild(UIAnim())
            bubbles["right"].on_sale:GetAnimState():SetBank("hoshino_building_shiba_seki_ramen_cart")
            bubbles["right"].on_sale:GetAnimState():SetBuild("hoshino_building_shiba_seki_ramen_cart")
            bubbles["right"].on_sale:GetAnimState():PlayAnimation("sale")
            bubbles["right"].on_sale:SetPosition(55,25,0)
            bubbles["right"].on_sale:SetScale(0.5,0.5,0.5)


        -----------------------------------------------------
        ---
            -- print(inst.hud_button_widget.inst)
        -----------------------------------------------------
        --- 物品刷新
            local items = {}
            for slot, _ in pairs(slots) do
                local temp = inst["__item_"..slot]:value()
                items[slot] = temp
            end
            for slot, tempItem in pairs(items) do
                if tempItem and tempItem:IsValid() and tempItem ~= inst then
                    bubbles[slot]:Show()
                    bubbles[slot].name_text:SetString(tempItem:GetDisplayName())
                    bubbles[slot].price_text:SetString(tostring(inst:GetPrice(tempItem) or 50))
                    if tempItem:HasTag("on_sale") then
                        bubbles[slot].on_sale:Show()
                    else
                        bubbles[slot].on_sale:Hide()
                    end
                else
                    bubbles[slot]:Hide()
                end
            end
        -----------------------------------------------------        
    
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function update_display(inst)
        -- local item_left = inst.__item_left:value()
        -- local item_mid = inst.__item_mid:value()
        -- local item_right = inst.__item_right:value()

        local items = {}
        for slot, _ in pairs(slots) do
            local temp = inst["__item_"..slot]:value()
            items[slot] = temp
        end

        print("+++++++++ 柴关拉面店 +++++++++++")
        for slot, item in pairs(items) do
            print("+++++",slot, item, item and item:HasTag("on_sale") and "特价中")
        end
        print("+++++++++++++++++++++++++++++++")
        install_buttons(inst)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


return function(inst)
    inst:DoTaskInTime(1,update_display)
    inst:ListenForEvent("item_update",update_display)
end