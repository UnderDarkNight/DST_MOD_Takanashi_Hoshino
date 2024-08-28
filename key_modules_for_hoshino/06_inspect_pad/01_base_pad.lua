--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


    平板界面生成

    部分数据从 ThePlayer.PAD_DATA 中获取
    里面的数据以RPC形式下发更新 "hoshino_event.pad_data_update"
    数据结构：
        {
            ["button_main_page_red_dot"] = true，
            ["button_level_up_red_dot"] = true，
            ["button_character_red_dot"] = true，

        }
]]---
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local Widget = require "widgets/widget"
    local Screen = require "widgets/screen"
    local Image = require "widgets/image"
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

AddPrefabPostInit(
    "hoshino",
    function(inst)
        inst.PAD_DATA = inst.PAD_DATA or {}
        inst:ListenForEvent("hoshino_event.inspect_hud_open",function(inst,front_root)
            -----------------------------------------------------------------------------------
            ---
                local root = front_root:AddChild(Widget())
                root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
                root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
                root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
                root:SetPosition(180,0)
            -----------------------------------------------------------------------------------
            ---
                local MainScale = 0.6
            -----------------------------------------------------------------------------------
            --- 背景
                local bg = root:AddChild(Image())
                bg:SetTexture("images/inspect_pad/inspect_pad.xml","main_background.tex")
                bg:SetScale(MainScale,MainScale,MainScale)
            -----------------------------------------------------------------------------------
            --- button_close
                local button_close = root:AddChild(ImageButton(
                    "images/inspect_pad/inspect_pad.xml",
                    "button_close.tex",
                    "button_close.tex",
                    "button_close.tex",
                    "button_close.tex",
                    "button_close.tex"
                ))
                root.button_close = button_close
                button_close:SetPosition(465,0)
                button_close:SetScale(MainScale,MainScale,MainScale)
                button_close:SetOnClick(function()
                    front_root.inst:PushEvent("pad_close")
                end)
                local button_close_focus_scale = 1.02
                button_close.focus_scale = {button_close_focus_scale,button_close_focus_scale,button_close_focus_scale}
            -----------------------------------------------------------------------------------
            ---
                local button_main_page = root:AddChild(ImageButton(
                    "images/inspect_pad/inspect_pad.xml",
                    "button_main_page.tex",
                    "button_main_page.tex",
                    "button_main_page.tex",
                    "button_main_page.tex",
                    "button_main_page.tex"
                ))
                root.button_main_page = button_main_page
                button_main_page:SetPosition(-220-5,-200+5)
                button_main_page:SetScale(MainScale,MainScale,MainScale)
                local button_main_page_red_dot = button_main_page:AddChild(Image())
                button_main_page_red_dot:SetTexture("images/inspect_pad/inspect_pad.xml","red_dot.tex")
                button_main_page_red_dot:SetPosition(20,20)
                button_main_page.red_dot = button_main_page_red_dot
                button_main_page:SetOnClick(function()
                    root.inst:PushEvent("button","main_page")
                    button_main_page_red_dot:Hide()
                    inst.PAD_DATA.button_main_page_red_dot = false
                end)
                if inst.PAD_DATA.button_main_page_red_dot == true then
                    button_main_page_red_dot:Show()
                else
                    button_main_page_red_dot:Hide()
                end
            -----------------------------------------------------------------------------------
            ---
                local button_level_up = root:AddChild(ImageButton(
                    "images/inspect_pad/inspect_pad.xml",
                    "button_level_up.tex",
                    "button_level_up.tex",
                    "button_level_up.tex",
                    "button_level_up.tex",
                    "button_level_up.tex"
                ))
                root.button_level_up = button_level_up
                button_level_up:SetPosition(12,-200+5)
                button_level_up:SetScale(MainScale,MainScale,MainScale)
                local button_level_up_red_dot = button_level_up:AddChild(Image())
                button_level_up_red_dot:SetTexture("images/inspect_pad/inspect_pad.xml","red_dot.tex")
                button_level_up_red_dot:SetPosition(20,20)

                button_level_up.red_dot = button_level_up_red_dot
                button_level_up:SetOnClick(function()
                    root.inst:PushEvent("button","level_up")
                    button_level_up_red_dot:Hide()
                    inst.PAD_DATA.button_level_up_red_dot = false
                end)
                if inst.PAD_DATA.button_level_up_red_dot == true then
                    button_level_up_red_dot:Show()
                else
                    button_level_up_red_dot:Hide()
                end
            -----------------------------------------------------------------------------------
            ---
                local button_character = root:AddChild(ImageButton(
                    "images/inspect_pad/inspect_pad.xml",
                    "button_character.tex",
                    "button_character.tex",
                    "button_character.tex",
                    "button_character.tex",
                    "button_character.tex"
                ))
                root.button_character = button_character
                button_character:SetPosition(253,-200+5)
                button_character:SetScale(MainScale,MainScale,MainScale)
                local button_character_red_dot = button_character:AddChild(Image())
                button_character_red_dot:SetTexture("images/inspect_pad/inspect_pad.xml","red_dot.tex")
                button_character_red_dot:SetPosition(20,20)

                button_character.red_dot = button_character_red_dot
                button_character:SetOnClick(function()
                    root.inst:PushEvent("button","character")
                    button_character_red_dot:Hide()
                    inst.PAD_DATA.button_character_red_dot = false
                end)
                if inst.PAD_DATA.button_character_red_dot == true then
                    button_character_red_dot:Show()
                else
                    button_character_red_dot:Hide()
                end
            -----------------------------------------------------------------------------------
            --- 键盘监听
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
                    -- print("remove key_handler")
                end)
            -----------------------------------------------------------------------------------
            ---
                local pages_create_fn = {
                    ["character"] = TUNING.HOSHINO_INSPECT_PAD_FNS["character"],
                    ["level_up"] = TUNING.HOSHINO_INSPECT_PAD_FNS["level_up"],
                }
                local page_swtich_buttons = {
                    ["character"] = "button_main_page",
                    ["level_up"] = "button_level_up",
                    ["main_page"] = "button_main_page",
                }

                local pages = {}
                for index,temp_fn in pairs(pages_create_fn) do
                    if temp_fn then
                        local temp_page = temp_fn(root,MainScale)
                        pages[index] = temp_page
                    end
                end
                for k, temp_page in pairs(pages) do
                    temp_page:Hide()
                end
                -------------------------------------------------------------------------------
                --- 默认展示界面
                    local default_page = "level_up"
                    pages[default_page]:Show()
                    root[page_swtich_buttons[default_page]].red_dot:Hide()
                    inst.PAD_DATA[page_swtich_buttons[default_page].."red_dot"] = false
                -------------------------------------------------------------------------------
                ---- 按钮点击
                    root.inst:ListenForEvent("button",function(_,page_index)
                        for index, temp_page in pairs(pages) do
                            if index == page_index then
                                temp_page:Show()
                            else
                                temp_page:Hide()
                            end
                        end
                    end)
                -------------------------------------------------------------------------------

                -- if ThePlayer.___test then
                --     ThePlayer.___test(root,MainScale)
                -- end
            -----------------------------------------------------------------------------------


        end)
    end
)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "hoshino",
    function(inst)
        inst.PAD_DATA = inst.PAD_DATA or {}
        inst:ListenForEvent("hoshino_event.pad_data_update",function(inst,data)
            data = data or {}
            for k, v in pairs(data) do
                inst.PAD_DATA[k] = v
            end
        end)
    end
)