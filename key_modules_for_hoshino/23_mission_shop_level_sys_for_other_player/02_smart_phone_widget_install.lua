-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    inventory_classified 添加event ,用来对 物品 pushevent

    物品 带 tag  hoshino_tag.cursor_sight 就能激活

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"

    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local atlas = "images/inspect_pad/little_smart_phone.xml"
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function Smart_Phone_Widget_Create(inst)
        local front_root = ThePlayer.HUD
        -----------------------------------------------------------------------------------
        --- 创建根节点
            local root = front_root:AddChild(Widget())
            root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
            root:SetPosition(180,0)
            local MainScale = 0.6
            root.inst:ListenForEvent("pad_close",function()
                root:Kill()
            end,front_root.inst)
        -----------------------------------------------------------------------------------
        ---
            --- 平板外框
            local bg = root:AddChild(Image())
            bg:SetTexture(atlas,"background_frame.tex")
            bg:SetScale(MainScale,MainScale,MainScale)
            --- 背景颜色
            local bg_color = root:AddChild(Image())
            bg_color:SetTexture(atlas,"background_color.tex")
            bg_color:MoveToBack()
            bg_color:SetScale(MainScale,MainScale,MainScale)
        -----------------------------------------------------------------------------------
        --- close button
            local button_close =  root:AddChild(ImageButton(
                atlas,"button_close.tex","button_close.tex","button_close.tex","button_close.tex","button_close.tex"
            ))
            button_close:SetOnClick(function()
                front_root.inst:PushEvent("pad_close")
            end)
            button_close:SetScale(MainScale,MainScale,MainScale)
            button_close.focus_scale = {1.05, 1.05, 1.05}
            button_close:SetPosition(0,-235)
        -----------------------------------------------------------------------------------
        --- 快速关闭按键监听
            local fast_close_keys = {
                [MOVE_UP] = true,
                [MOVE_DOWN] = true,
                [MOVE_LEFT] = true,
                [MOVE_RIGHT] = true,
                [KEY_ESCAPE] = true,
                [KEY_W] = true,
                [KEY_S] = true,
                [KEY_A] = true,
                [KEY_D] = true,
            }
            local key_handler = TheInput:AddKeyHandler(function(key,down)
                if down and fast_close_keys[key] then
                    front_root.inst:PushEvent("pad_close")
                end
            end)
            root.inst:ListenForEvent("onremove",function()
                key_handler:Remove()
            end)
        -----------------------------------------------------------------------------------
        --- 任务区前置root
            local task_front_box = root:AddChild(Widget())
            task_front_box:SetScale(MainScale,MainScale,MainScale)
            task_front_box:SetPosition(0,35)
            local task_box = task_front_box:AddChild(Image(atlas,"task_box_background.tex"))
            task_box:SetPosition(0,0)
        -----------------------------------------------------------------------------------
        --- 任务条。
            local task_bars = {}
            local bar_delta_y = 120
            local bar_base_y = 240
        -----------------------------------------------------------------------------------
        --- 检查任务容器
            local function update_task_box()
                ----------------------------------------------
                --- 清除已有任务栏
                    for k, v in pairs(task_bars) do
                        v:Kill()
                    end
                    task_bars = {}
                ----------------------------------------------
                --- 重新生成任务条
                    local task_backpack = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_TASK_BACKPACK)
                    if task_backpack == nil then
                        return
                    end
                    local task_items = {}
                    local items_in_container = task_backpack.replica.container:GetItems()
                    for i = 1, 5, 1 do
                        local temp_item = items_in_container[i]
                        if temp_item and temp_item:IsValid() then
                            table.insert(task_items,temp_item)
                        end
                    end
                    for i, current_task_inst in pairs(task_items) do
                        task_bars[i] = current_task_inst:GetPadDisplayBox(task_box)
                        task_bars[i]:SetPosition(0,bar_base_y - (i-1)*bar_delta_y)
                    end
                ----------------------------------------------
            end
            update_task_box()
            task_box.inst:ListenForEvent("update_task_box",update_task_box)
            task_box._updatting_flag_num = 5
            task_box._updatting_task = nil
            task_box.inst:ListenForEvent("hoshino_event.update_task_box",function()
                task_box._updatting_flag_num = 5
                if task_box._updatting_task == nil then
                    task_box._updatting_task = task_box.inst:DoPeriodicTask(0.2,function()
                        task_box._updatting_flag_num = task_box._updatting_flag_num - 1
                        if task_box._updatting_flag_num <= 0 then
                            task_box._updatting_task:Cancel()
                            task_box._updatting_task = nil
                        end
                        update_task_box()
                    end)
                end
                update_task_box()
            end,ThePlayer)
        -----------------------------------------------------------------------------------
        --- 打开任务背包
            local task_backpack = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_TASK_BACKPACK)
            if task_backpack ~= nil then
                task_backpack.replica.container:Open(ThePlayer)
            end
        -----------------------------------------------------------------------------------
        --- 信用币
            local credit_coins_box = root:AddChild(Image(atlas,"empty_box.tex"))
            credit_coins_box:SetScale(MainScale,MainScale,MainScale)
            credit_coins_box:SetPosition(130,-180)
            local credit_coins_box_icon = credit_coins_box:AddChild(Image(atlas,"credit_coin_icon.tex"))
            credit_coins_box_icon:SetPosition(-90,0)
            local credit_coins_text = credit_coins_box:AddChild(Text(CODEFONT,40,"30",{ 0/255 , 0/255 ,0/255 , 1}))
            credit_coins_text:SetPosition(10,0)
            credit_coins_text:SetString("9999")
            local function credit_coins_update_fn()
                local credit_coins = ThePlayer.replica.hoshino_com_shop:GetCreditCoins()
                credit_coins_text:SetString(tostring(credit_coins))
            end
        -----------------------------------------------------------------------------------
        --- 青辉石
            local blue_schist_box = root:AddChild(Image(atlas,"empty_box.tex"))
            blue_schist_box:SetScale(MainScale,MainScale,MainScale)
            blue_schist_box:SetPosition(-30,-180)                    
            local blue_schist_icon = blue_schist_box:AddChild(Image(atlas,"blue_schist_icon.tex"))
            -- credit_coins_icon:SetScale(MainScale,MainScale,MainScale)
            blue_schist_icon:SetPosition(-90,0)
            local blue_schist_text = blue_schist_box:AddChild(Text(CODEFONT,40,"30",{ 0/255 , 0/255 ,0/255 , 1}))
            blue_schist_text:SetPosition(10,0)
            blue_schist_text:SetString("9999")
            local function blue_schist_update_fn()
                local blue_schists = ThePlayer.replica.hoshino_com_shop:GetBlueSchist()
                blue_schist_text:SetString(tostring(blue_schists))
            end
        -----------------------------------------------------------------------------------
        --- 货币更新 update
            local function update_coins()
                credit_coins_update_fn()
                blue_schist_update_fn()
            end
            update_coins()
            root.inst:DoPeriodicTask(0.1,update_coins)
        -----------------------------------------------------------------------------------
        return root
    end
    
    local function WidgetInstall(inst)
        local root = nil
        inst:ListenForEvent("hoshino_event.little_smart_phone_open",function(_,_call_back_table)
            if root ~= nil then
                root:Kill()
                root = nil
                return
            end
            root = Smart_Phone_Widget_Create(inst)
            root.inst:ListenForEvent("onremove",function()
                root = nil
            end)
            _call_back_table.widget = root
        end)
    end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPlayerPostInit(function(inst)
    if inst.prefab == "hoshino" then
        return
    end
    inst:DoTaskInTime(1,function()
        if inst == ThePlayer and inst.HUD then
            WidgetInstall(inst)
        end
    end)
end)