--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


    平板界面生成

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

AddPrefabPostInit(
    "hoshino",
    function(inst)
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
                button_main_page:SetPosition(-220-5,-200+5)
                button_main_page:SetScale(MainScale,MainScale,MainScale)
                button_main_page:SetOnClick(function()
                    root.inst:PushEvent("button_main_page")
                end)
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
                button_level_up:SetPosition(12,-200+5)
                button_level_up:SetScale(MainScale,MainScale,MainScale)
                button_level_up:SetOnClick(function()
                    root.inst:PushEvent("button_level_up")
                end)
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
                button_character:SetPosition(253,-200+5)
                button_character:SetScale(MainScale,MainScale,MainScale)
                button_character:SetOnClick(function()
                    root.inst:PushEvent("button_character")
                end)
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
                }
                local pages = {}
                for index,temp_fn in pairs(pages_create_fn) do
                    if temp_fn then
                        local temp_page = temp_fn(root,MainScale)
                        pages[index] = temp_page
                    end
                end

                -- if ThePlayer.___test then
                --     ThePlayer.___test(root,MainScale)
                -- end
            -----------------------------------------------------------------------------------


        end)
    end
)