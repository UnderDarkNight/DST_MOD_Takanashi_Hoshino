
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
    local EmoteButton = require "widgets/hoshino_emote_button"
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
                    ThePlayer.components.hoshino_com_power_cost:DoDelta(10)
                    -- ThePlayer.components.hoshino_com_power_cost:DoDelta(-10)
                    -- ThePlayer.components.hoshino_com_level_sys:Exp_DoDelta(10000000)
    ----------------------------------------------------------------------------------------------------------------
    --- 技能圈圈指示器
        -- ThePlayer.components.inventory:Equip(SpawnPrefab("hoshino_spell_excample_mouse_radius"))

        -- local spell_item = SpawnPrefab("hoshino_spell_normal_breakthrough")
        -- local spell_item = SpawnPrefab("hoshino_spell_excample_mouse_radius")
        -- local spell_item = ThePlayer:SpawnChild("hoshino_spell_excample_mouse_radius")
        -- spell_item.components.hoshino_com_item_spell:SetOwner(ThePlayer)

    ----------------------------------------------------------------------------------------------------------------
    ---
        -- ThePlayer.AnimState:PlayAnimation("wortox_portal_jumpin")
        -- ThePlayer.AnimState:PlayAnimation("wortox_portal_jumpout")

        -- ThePlayer.sg:GoToState("hoshino_portal_jump_out",{
        --     pt = Vector3(x+10,0,z)
        -- })
        -- local doer = ThePlayer
        -- doer.components.playercontroller:DoAction(BufferedAction(doer, nil, ACTIONS.HOSHINO_SG_JUMP_OUT,nil,Vector3(x+10,0,z)))
    ----------------------------------------------------------------------------------------------------------------
    ---
        --  ThePlayer._test_spell_ring_hud_fn = function(inst)

        --     local front_root = inst.HUD  -- 前置节点。

        --     --------------------------------------------------------------------------
        --     --- 根节点创建
        --         if front_root.hoshino_spell_ring_hud then   --- 杀掉重复的节点。重复点击则关闭界面
        --             front_root.hoshino_spell_ring_hud:Kill()
        --             front_root.hoshino_spell_ring_hud = nil
        --             return
        --         end
        --         local root = front_root:AddChild(Widget())
        --         front_root.hoshino_spell_ring_hud = root

        --         function root:CloseSpellRing() -- 关闭技能圈圈
        --             self:Kill()
        --             front_root.hoshino_spell_ring_hud = nil
        --         end
        --     --------------------------------------------------------------------------
        --     --- 根节点参数
        --         root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        --         root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        --         root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        --         local MainScale = 0.6                
        --     --------------------------------------------------------------------------
        --     --- 按钮盒子
        --         local button_box = root:AddChild(Widget())
        --         button_box:SetPosition(0,0,0)
        --         button_box:SetScale(MainScale,MainScale,MainScale)
        --     --------------------------------------------------------------------------
        --     --- 按钮创建基础API
        --         local atlas = "images/widgets/hoshino_spell_ring.xml"
        --         local function CreateButton(image,x,y,button_custom_fn,onclick_fn)
        --             image = image or "test_img.tex"
        --             local temp_button = button_box:AddChild(ImageButton(
        --                 atlas,image,image,image,image,image
        --             ))
        --             if button_custom_fn then
        --                 button_custom_fn(temp_button)
        --             end
        --             temp_button:SetOnClick(function()                        
        --                 if onclick_fn then
        --                     onclick_fn(temp_button)
        --                 end
        --             end)
        --             temp_button:SetPosition(x,y)
        --             return temp_button
        --         end
        --         local function CreateText(font,size,text,color)
        --             local temp_text = Text(font,size,text,color)
        --             function temp_text:CustomSetStr(str,x,y)
        --                 self:SetString(str)
        --                 self:SetPosition(x + self:GetRegionSize()/2,y)
        --             end
        --             return temp_text
        --         end
        --     --------------------------------------------------------------------------
        --     --- 类型。
        --         local character_spell_type = ThePlayer.PAD_DATA and ThePlayer.PAD_DATA.character_spell_type or "hoshino_spell_type_normal"

        --     --------------------------------------------------------------------------
        --     --- 3 个布局
        --         local txt_font = CODEFONT
        --         if character_spell_type == "hoshino_spell_type_normal" then
        --                 local base_x,base_y = 200,0
        --                 local delta_x,delta_y = 40,120
        --                 local button_spell_text_pt = Vector3(60,25,0)
        --                 ---- 
        --                 CreateButton(nil,base_x - delta_x,base_y + delta_y,function(temp_button)
        --                     local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_name:CustomSetStr("疗愈",button_spell_text_pt.x,button_spell_text_pt.y)
        --                     local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
        --                 end,function()
        --                     --- 按钮点击
        --                     root:CloseSpellRing()                            
        --                 end)
        --                 ----
        --                 CreateButton(nil,base_x,base_y,function(temp_button)
        --                     local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_name:CustomSetStr("隐秘行动",button_spell_text_pt.x,button_spell_text_pt.y)
        --                     local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
        --                 end,function()
        --                     --- 按钮点击
        --                     root:CloseSpellRing()  
        --                 end)
        --                 ----
        --                 CreateButton(nil,base_x -delta_x,base_y - delta_y,function(temp_button)
        --                     local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_name:CustomSetStr("突破",button_spell_text_pt.x,button_spell_text_pt.y)
        --                     local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
        --                 end,function()
        --                     --- 按钮点击
        --                     root:CloseSpellRing()  
        --                 end)
        --         elseif character_spell_type == "hoshino_spell_type_swimming" then
        --                 local base_x,base_y = 200,0
        --                 local delta_x,delta_y = 40,120
        --                 local button_spell_text_pt = Vector3(60,25,0)
        --                 CreateButton(nil,base_x - delta_x,base_y + 1.5*delta_y,function(temp_button)
        --                     local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_name:CustomSetStr("高效率工作",button_spell_text_pt.x,button_spell_text_pt.y)
        --                     local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
        --                 end,function()
        --                     --- 按钮点击
        --                     root:CloseSpellRing()  
        --                 end)
        --                 CreateButton(nil,base_x,base_y + delta_y/2,function(temp_button)
        --                     local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_name:CustomSetStr("急援",button_spell_text_pt.x,button_spell_text_pt.y)
        --                     local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
        --                 end,function()
        --                     --- 按钮点击
        --                     -- root:CloseSpellRing()
        --                     if root.emote_box then
        --                         root.emote_box:Show()
        --                     end
        --                     button_box:Hide()

        --                 end)
        --                 CreateButton(nil,base_x,base_y - delta_y/2,function(temp_button)
        --                     local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_name:CustomSetStr("晓之荷鲁斯",button_spell_text_pt.x,button_spell_text_pt.y)
        --                     local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
        --                 end,function()
        --                     --- 按钮点击
        --                     root:CloseSpellRing()  
        --                 end)
        --                 CreateButton(nil,base_x -delta_x,base_y - 1.5*delta_y,function(temp_button)
        --                     local spell_name = temp_button:AddChild(CreateText(txt_font,45,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_name:CustomSetStr("水上支援",button_spell_text_pt.x,button_spell_text_pt.y)
        --                     local spell_info = temp_button:AddChild(CreateText(txt_font,40,"",{  255/255 , 255/255 ,255/255 , 1}))
        --                     spell_info:CustomSetStr("7777777774444444444",button_spell_text_pt.x,-button_spell_text_pt.y)
        --                 end,function()
        --                     --- 按钮点击
        --                     root:CloseSpellRing()  
        --                 end)
        --         end                            
        --     --------------------------------------------------------------------------
        --     --------------------------------------------------------------------------
        --     ------------------- 角色选择界面            -------------------------------
        --     --------------------------------------------------------------------------
        --     --------------------------------------------------------------------------
        --     --- 
        --         if character_spell_type ~= "hoshino_spell_type_swimming" then
        --             return
        --         end
        --     --------------------------------------------------------------------------
        --     --- 表情盒子。
        --         local emote_box = root:AddChild(Widget())
        --         emote_box:SetPosition(0,0)
        --         root.emote_box = emote_box
        --         emote_box:Hide()
        --         emote_box:SetScale(0.7,0.7)
        --     --------------------------------------------------------------------------
        --     --- 按钮创建 API                
        --         local DLC_CHARACTERS = {
        --             ["wormwood"] = true,
        --             ["wortox"] = true,
        --             ["wurt"] = true,
        --             ["wanda"] = true,
        --         }
        --         local function CreateEmoteButton(x,y,player,clicked_fn)
        --             local temp_button = emote_box:AddChild(EmoteButton("annoyed",player,function()
        --                 if clicked_fn then
        --                     clicked_fn(player)
        --                 end
        --                 root:CloseSpellRing()
        --             end))
        --             for k,v in pairs(temp_button.text_box or {}) do
        --                 v:Hide()
        --             end
        --             local display_name = temp_button:AddChild(Text(txt_font,35,"",{  255/255 , 255/255 ,255/255 , 1}))
        --             display_name:SetPosition(0,-50)
        --             display_name:SetString(player:GetDisplayName())

        --             temp_button:SetPosition(x,y)
                    
        --             if ThePlayer ~= player then
        --                 if DLC_CHARACTERS[player.prefab] then
        --                     temp_button.puppet:Hide()
        --                     pcall(function()
        --                         local icon = temp_button:AddChild(Image("minimap/minimap_data.xml",player.prefab..".png"))                            
        --                     end)
        --                 else
        --                     temp_button.puppet.animstate:SetBuild(player.prefab)
        --                 end
        --             end

        --             return temp_button
        --         end
        --     --------------------------------------------------------------------------
        --     ---
        --         -- CreateEmoteButton(0,0,ThePlayer,function(player)
        --         --     print("emote button click",player)
        --         -- end)
        --     --------------------------------------------------------------------------
        --     --- 按人数矩形布局。每行6个人。最多5行.
        --         local player_num = 6
        --         local start_x,start_y = -500,300
        --         local delta_x  = 130
        --         local delta_y  = -150
        --         local ret_points = {}
        --         for y = 1, 5, 1 do
        --             for x = 1, 6, 1 do
        --                 local offset_x = start_x + (x-1) * (delta_x )
        --                 local offset_y = start_y + (y-1) * (delta_y )
        --                 table.insert(ret_points,Vector3(offset_x,offset_y,0))
        --             end
        --         end
        --     --------------------------------------------------------------------------
        --     ---
        --         for k, temp_player in pairs(AllPlayers) do
        --             if ret_points[k] then
        --                 local temp_button = CreateEmoteButton(ret_points[k].x,ret_points[k].y,temp_player,function(player)
        --                     print("emote button click",player)
        --                 end)
        --             end
        --         end
        --     --------------------------------------------------------------------------



        --  end
    ----------------------------------------------------------------------------------------------------------------
    --- 技能圆环(玩家选择）。
        -- ThePlayer.__emote_ring_fn = function(inst)

        --     local front_root = inst.HUD

        --     local root = front_root:AddChild(Widget())
        --     --------------------------------------------------------------------------
        --         root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        --         root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        --         root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        --     --------------------------------------------------------------------------
        --     -- 
        --         local EmoteButton = require "widgets/hoshino_emote_button"
        --         -- local emoji = "dance"
        --         local emoji = "annoyed"
        --     --------------------------------------------------------------------------
        --     --
        --         local temp_button = root:AddChild(EmoteButton(emoji,ThePlayer.prefab,function()
        --             root:Kill()
        --         end))
        --         for k,v in pairs(temp_button.text_box or {}) do
        --             v:Hide()
        --         end
        --         -- print(temp_button.text_box)
        --     --------------------------------------------------------------------------

        -- end
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))