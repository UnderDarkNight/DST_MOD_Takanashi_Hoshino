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
                -- front_root:ShowSlime()
                local page = front_root:AddChild(Widget())
                local root = page
            --------------------------------------------------------------------------------------
            --- 史莱姆标记
                page.inst:ListenForEvent("page_show",function(_,index)
                    if index == "main_page" then
                        front_root:ShowSlime()
                    else
                        front_root:HideSlime()
                    end
                end,front_root.inst)
                page.inst:ListenForEvent("on_loaded",function(_,index)
                    if index == "main_page" then
                        front_root:ShowSlime()
                    else
                        front_root:HideSlime()
                    end
                end,front_root.inst)
            --------------------------------------------------------------------------------------
            ---
            --------------------------------------------------------------------------------------
            --- level box
                local level_box = root:AddChild(Image("images/inspect_pad/page_main.xml","level_box_background.tex"))
                level_box:SetScale(MainScale,MainScale,MainScale)
                level_box:SetPosition(-300,200)

                local level_text = level_box:AddChild(Text(CODEFONT,100,"30",{ 255/255 , 255/255 ,255/255 , 1}))
                level_text:SetPosition(40,0)
                level_text:SetString("9999")
                local level_text_update_fn = function()
                    local player_level = ThePlayer.replica.hoshino_com_level_sys:GetLevel()
                    player_level = math.clamp(player_level,0,9999)
                    level_text:SetString(tostring(player_level))
                end
                -- level_text.inst:DoPeriodicTask(0.5,level_text_update_fn)
                level_text_update_fn()
            --------------------------------------------------------------------------------------
            --- 信用币
                local credit_coins_box = root:AddChild(Image("images/inspect_pad/page_main.xml","empty_box.tex"))
                credit_coins_box:SetScale(MainScale,MainScale,MainScale)
                credit_coins_box:SetPosition(-320,150-30)                    
                local credit_coins_icon = credit_coins_box:AddChild(Image("images/inspect_pad/page_main.xml","credit_coin_icon.tex"))
                -- credit_coins_icon:SetScale(MainScale,MainScale,MainScale)
                credit_coins_icon:SetPosition(-90,0)
                local credit_coins_text = credit_coins_box:AddChild(Text(CODEFONT,40,"30",{ 0/255 , 0/255 ,0/255 , 1}))
                credit_coins_text:SetPosition(10,0)
                credit_coins_text:SetString("9999")
                local function credit_coins_update_fn()
                    local credit_coins = ThePlayer.replica.hoshino_com_shop:GetCreditCoins()
                    credit_coins_text:SetString(tostring(credit_coins))
                end
            --------------------------------------------------------------------------------------
            --- 青辉石
                local blue_schist_box = root:AddChild(Image("images/inspect_pad/page_main.xml","empty_box.tex"))
                blue_schist_box:SetScale(MainScale,MainScale,MainScale)
                blue_schist_box:SetPosition(-320,110-30)                    
                local blue_schist_icon = blue_schist_box:AddChild(Image("images/inspect_pad/page_main.xml","blue_schist_icon.tex"))
                -- credit_coins_icon:SetScale(MainScale,MainScale,MainScale)
                blue_schist_icon:SetPosition(-90,0)
                local blue_schist_text = blue_schist_box:AddChild(Text(CODEFONT,40,"30",{ 0/255 , 0/255 ,0/255 , 1}))
                blue_schist_text:SetPosition(10,0)
                blue_schist_text:SetString("9999")
                local function blue_schist_update_fn()
                    local blue_schists = ThePlayer.replica.hoshino_com_shop:GetBlueSchist()
                    blue_schist_text:SetString(tostring(blue_schists))
                end
            --------------------------------------------------------------------------------------
            --- 货币更新 update
                local function update_coins()
                    credit_coins_update_fn()
                    blue_schist_update_fn()
                    level_text_update_fn()
                end
                update_coins()
                root.inst:DoPeriodicTask(0.1,update_coins)
            --------------------------------------------------------------------------------------
            --- 任务区前置root
                local task_front_box = root:AddChild(Image("images/inspect_pad/page_main.xml","task_box_tile.tex"))
                task_front_box:SetScale(MainScale,MainScale,MainScale)
                task_front_box:SetPosition(20,210)
                local task_box = task_front_box:AddChild(Image("images/inspect_pad/page_main.xml","task_box_background.tex"))
                task_box:SetPosition(275,-340+3)
            --------------------------------------------------------------------------------------
            --- 任务条。
                local task_bars = {}
                local bar_delta_y = 120
                local bar_base_y = 240
                -- task_bars[1] = task_box:AddChild(Image("images/inspect_pad/page_main.xml","task_box_excample.tex"))
                -- task_bars[1]:SetPosition(0,240)
                -- for i = 1, 5, 1 do
                --     local temp_bar = task_box:AddChild(Image("images/inspect_pad/page_main.xml","task_box_excample.tex"))
                --     temp_bar:SetPosition(0,bar_base_y - (i-1)*bar_delta_y)
                --     local button_give_up = temp_bar:AddChild(ImageButton(
                --         "images/inspect_pad/page_main.xml",
                --         "button_give_up.tex",
                --         "button_give_up.tex",
                --         "button_give_up.tex",
                --         "button_give_up.tex",
                --         "button_give_up.tex"
                --     ))
                --     button_give_up:SetPosition(290,40)
                --     button_give_up.focus_scale = {1.1, 1.1, 1.1}
                --     button_give_up:SetScale(0.5,0.5,0.5)
                --     local button_delivery = temp_bar:AddChild(ImageButton(
                --         "images/inspect_pad/page_main.xml",
                --         "button_delivery.tex",
                --         "button_delivery.tex",
                --         "button_delivery.tex",
                --         "button_delivery.tex",
                --         "button_delivery.tex"
                --     ))
                --     button_delivery:SetPosition(260,-20)
                --     button_delivery.focus_scale = {1.1, 1.1, 1.1}
                --     task_bars[i] = temp_bar
                -- end
            --------------------------------------------------------------------------------------
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
            --------------------------------------------------------------------------------------
            ---
                local task_backpack = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_TASK_BACKPACK)
                if task_backpack ~= nil then
                    task_backpack.replica.container:Open(ThePlayer)
                end
            --------------------------------------------------------------------------------------
            ---
                return page
            --------------------------------------------------------------------------------------

end
TUNING.HOSHINO_INSPECT_PAD_FNS["main_page"] = page_create
