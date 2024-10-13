--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------- 界面相关 模块
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"


    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
    
    local EmoteButton = require "widgets/hoshino_emote_button"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 技能圆环。
    local function CreateSpellButtons(inst)
        --------------------------------------------------------------------------
        --- 调试区
            -- if TUNING.HOSHINO_DEBUGGING_MODE and inst._test_spell_ring_hud_fn then
            --     inst._test_spell_ring_hud_fn(inst)
            --     return
            -- end
        --------------------------------------------------------------------------

       
        local front_root = inst.HUD  -- 前置节点。

        --------------------------------------------------------------------------
        --- 根节点创建
            if front_root.hoshino_spell_ring_hud then   --- 杀掉重复的节点。重复点击则关闭界面
                front_root.hoshino_spell_ring_hud:Kill()
                front_root.hoshino_spell_ring_hud = nil
                return
            end
            local root = front_root:AddChild(Widget())
            front_root.hoshino_spell_ring_hud = root

            function root:CloseSpellRing() -- 关闭技能圈圈
                self:Kill()
                front_root.hoshino_spell_ring_hud = nil
            end
        --------------------------------------------------------------------------
        --- 根节点参数
            root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
            local MainScale = 0.6                
        --------------------------------------------------------------------------
        --- 按钮盒子
            local button_box = root:AddChild(Widget())
            button_box:SetPosition(0,0,0)
            button_box:SetScale(MainScale,MainScale,MainScale)
        --------------------------------------------------------------------------
        --- 按钮创建基础API
            local atlas = "images/widgets/hoshino_spell_ring.xml"
            local function CreateButton(image,x,y,button_custom_fn,onclick_fn)
                image = image or "test_img.tex"
                local temp_button = button_box:AddChild(ImageButton(
                    atlas,image,image,image,image,image
                ))
                if button_custom_fn then
                    button_custom_fn(temp_button)
                end
                temp_button:SetOnClick(function()                        
                    if onclick_fn then
                        onclick_fn(temp_button)
                    end
                end)
                temp_button:SetPosition(x,y)
                return temp_button
            end
            local function CreateText(font,size,text,color)
                local temp_text = Text(font,size,text,color)
                function temp_text:CustomSetStr(str,x,y)
                    self:SetString(str)
                    self:SetPosition(x + self:GetRegionSize()/2,y)
                end
                return temp_text
            end
        --------------------------------------------------------------------------
        --- 类型。
            local character_spell_type = ThePlayer.PAD_DATA and ThePlayer.PAD_DATA.character_spell_type or "hoshino_spell_type_normal"

        --------------------------------------------------------------------------
        --- 3 个布局
            local txt_font = CODEFONT
            if character_spell_type == "hoshino_spell_type_normal" then
                    local base_x,base_y = 200,0
                    local delta_x,delta_y = 40,120
                    local button_spell_text_pt = Vector3(60,25,0)
                    ---- 
                    CreateButton(nil,base_x - delta_x,base_y + delta_y,function(temp_button)
                        local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_name:CustomSetStr("疗愈",button_spell_text_pt.x,button_spell_text_pt.y)
                        local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
                        -- spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
                        local function button_info_update_fn()
                            local can_click_button = true
                            local info_txt = ""
                            if ThePlayer.replica.hoshino_com_power_cost:GetCurrent() < 3 then
                                info_txt = info_txt.."【 COST 3 】"
                                can_click_button = false
                            end
                            if not ThePlayer.replica.hoshino_com_spell_cd_timer:IsReady("normal_heal") then
                                local cd_time = ThePlayer.replica.hoshino_com_spell_cd_timer:GetTime("normal_heal")
                                info_txt = info_txt.."【"..string.format("%.1f",cd_time).."】"
                                can_click_button = false
                            end
                            spell_info:CustomSetStr(info_txt,button_spell_text_pt.x,-button_spell_text_pt.y)
                            temp_button:SetClickable(can_click_button)
                        end
                        temp_button.inst:DoPeriodicTask(FRAMES,button_info_update_fn)
                    end,function()
                        --- 按钮点击
                        ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_spell_ring_spells_selected",{spell_name = "normal_heal"})
                        root:CloseSpellRing()                            
                    end)
                    ----
                    CreateButton(nil,base_x,base_y,function(temp_button)
                        local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_name:CustomSetStr("隐秘行动",button_spell_text_pt.x,button_spell_text_pt.y)
                        local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
                    end,function()
                        --- 按钮点击
                        root:CloseSpellRing()  
                    end)
                    ----
                    CreateButton(nil,base_x -delta_x,base_y - delta_y,function(temp_button)
                        local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_name:CustomSetStr("突破",button_spell_text_pt.x,button_spell_text_pt.y)
                        local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
                    end,function()
                        --- 按钮点击
                        root:CloseSpellRing()  
                    end)
            elseif character_spell_type == "hoshino_spell_type_swimming" then
                    local base_x,base_y = 200,0
                    local delta_x,delta_y = 40,120
                    local button_spell_text_pt = Vector3(60,25,0)
                    CreateButton(nil,base_x - delta_x,base_y + 1.5*delta_y,function(temp_button)
                        local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_name:CustomSetStr("水上支援",button_spell_text_pt.x,button_spell_text_pt.y)
                        local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
                    end,function()
                        --- 按钮点击
                        root:CloseSpellRing()  
                    end)
                    CreateButton(nil,base_x,base_y + delta_y/2,function(temp_button)
                        local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_name:CustomSetStr("高效率工作",button_spell_text_pt.x,button_spell_text_pt.y)
                        local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
                    end,function()
                        --- 按钮点击
                        root:CloseSpellRing()
                    end)
                    CreateButton(nil,base_x,base_y - delta_y/2,function(temp_button)
                        local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_name:CustomSetStr("急援",button_spell_text_pt.x,button_spell_text_pt.y)
                        local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
                    end,function()
                        --- 按钮点击
                        -- root:CloseSpellRing()
                        if root.emote_box then
                            root.emote_box:Show()
                        end
                        button_box:Hide()
                    end)
                    CreateButton(nil,base_x -delta_x,base_y - 1.5*delta_y,function(temp_button)
                        local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_name:CustomSetStr("晓之荷鲁斯",button_spell_text_pt.x,button_spell_text_pt.y)
                        local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
                        spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
                    end,function()
                        --- 按钮点击
                        root:CloseSpellRing()  
                    end)
            end                            
        --------------------------------------------------------------------------
        --- 布局刷新检查.用来HUD打开后,玩家类型切换时,自动关闭界面
            root.inst:DoPeriodicTask(0.5,function()
                local temp_character_spell_type = ThePlayer.PAD_DATA and ThePlayer.PAD_DATA.character_spell_type or "hoshino_spell_type_normal"
                if temp_character_spell_type ~= character_spell_type or ThePlayer:HasTag("playerghost") then
                    root:CloseSpellRing()
                    return
                end
            end)
        --------------------------------------------------------------------------
        --------------------------------------------------------------------------
        ------------------- 角色选择界面            -------------------------------
        --------------------------------------------------------------------------
        --------------------------------------------------------------------------
        --- 
            if character_spell_type ~= "hoshino_spell_type_swimming" then
                return
            end
        --------------------------------------------------------------------------
        --- 表情盒子。
            local emote_box = root:AddChild(Widget())
            emote_box:SetPosition(0,0)
            root.emote_box = emote_box
            emote_box:Hide()
            emote_box:SetScale(0.7,0.7)
        --------------------------------------------------------------------------
        --- 按钮创建 API                
            local DLC_CHARACTERS = {
                ["wormwood"] = true,
                ["wortox"] = true,
                ["wurt"] = true,
                ["wanda"] = true,
            }
            local function CreateEmoteButton(x,y,player,clicked_fn)
                local temp_button = emote_box:AddChild(EmoteButton("annoyed",player,function()
                    if clicked_fn then
                        clicked_fn(player)
                    end
                    root:CloseSpellRing()
                end))
                for k,v in pairs(temp_button.text_box or {}) do
                    v:Hide()
                end
                local display_name = temp_button:AddChild(Text(txt_font,35,"",{  255/255 , 255/255 ,255/255 , 1}))
                display_name:SetPosition(0,-50)
                display_name:SetString(player:GetDisplayName())

                temp_button:SetPosition(x,y)
                
                if ThePlayer ~= player then
                    if DLC_CHARACTERS[player.prefab] then
                        temp_button.puppet:Hide()
                        pcall(function()
                            local icon = temp_button:AddChild(Image("minimap/minimap_data.xml",player.prefab..".png"))                            
                        end)
                    else
                        temp_button.puppet.animstate:SetBuild(player.prefab)
                    end
                end

                return temp_button
            end
        --------------------------------------------------------------------------
        ---
            -- CreateEmoteButton(0,0,ThePlayer,function(player)
            --     print("emote button click",player)
            -- end)
        --------------------------------------------------------------------------
        --- 按人数矩形布局。每行6个人。最多5行.
            local player_num = 6
            local start_x,start_y = -500,300
            local delta_x  = 130
            local delta_y  = -150
            local ret_points = {}
            for y = 1, 5, 1 do
                for x = 1, 6, 1 do
                    local offset_x = start_x + (x-1) * (delta_x )
                    local offset_y = start_y + (y-1) * (delta_y )
                    table.insert(ret_points,Vector3(offset_x,offset_y,0))
                end
            end
        --------------------------------------------------------------------------
        ---
            for k, temp_player in pairs(AllPlayers) do
                if ret_points[k] then
                    local temp_button = CreateEmoteButton(ret_points[k].x,ret_points[k].y,temp_player,function(player)
                        print("emote button click",player)
                    end)
                end
            end
        --------------------------------------------------------------------------

    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function key_event_fn(inst,key)
        if TUNING.HOSHINO_FNS:IsKeyPressed(TUNING["hoshino.Config"].SPELL_RING_HOTKEY,key) and not ThePlayer:HasTag("playerghost") then
            -- print("key_down SPELL_RING_HOTKEY")
            ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_event.spell_ring_active")
            CreateSpellButtons(ThePlayer)
        end
    end
    local function hotkey_listener_install(inst)
        ---------- 添加键盘监控
        local __key_handler = TheInput:AddKeyHandler(function(key,down)  ------ 30FPS 轮询，不要过于复杂
            if down == false then
                -- print("key_up",key)
                key_event_fn(ThePlayer,key)
            end
        end)
        ---------- 角色删除的时候顺便移除监听。避免切角色的时候出问题
        inst:ListenForEvent("onremove",function()
            __key_handler:Remove()
        end)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0,function()
        if inst == ThePlayer and inst.HUD and TheInput and TheFocalPoint then
            hotkey_listener_install(inst)
        end
    end)
end