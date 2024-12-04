    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


    平板

    角色界面

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
---
    local function GetInfoData()
        return ThePlayer.PAD_DATA and ThePlayer.PAD_DATA.info or {}
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 装备强化配方页面
    local current_display_recipes_page = 1
    local function Create_Special_Equipment_Recipes_Box(page,MainScale)
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

            local function set_recipe_page(page_num)
                recipe_image:SetTexture(atlas,"page_"..page_num..".tex")
                page_text:SetString(page_num)
            end
            local function recipe_page_switch(num)
                current_display_recipes_page = current_display_recipes_page + num
                if current_display_recipes_page > 9 then
                    current_display_recipes_page = 1
                end
                if current_display_recipes_page < 1 then
                    current_display_recipes_page = 9
                end
                set_recipe_page(current_display_recipes_page)
            end
            set_recipe_page(current_display_recipes_page)

            button_last:SetOnClick(function()
                recipe_page_switch(-1)
            end)
            button_next:SetOnClick(function()
                recipe_page_switch(1)
            end)
        ----------------------------------------------------------------------------------------
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function page_create(front_root,MainScale)
            --------------------------------------------------------------------------------------
            --- 根节点
                local page = front_root:AddChild(Widget())

            --------------------------------------------------------------------------------------
            --- 经验条
                local exp_bar = page:AddChild(UIAnim())
                local exp_bar_anim = exp_bar:GetAnimState()
                exp_bar_anim:SetBank("hoshino_exp_bar")
                exp_bar_anim:SetBuild("hoshino_exp_bar")
                exp_bar_anim:PlayAnimation("idle",true)

                exp_bar:SetPosition(-270,190)
                exp_bar:SetScale(MainScale,MainScale,MainScale)
            --------------------------------------------------------------------------------------
            --- 经验值
                local exp_txt = exp_bar:AddChild(Text(CODEFONT,30,"99999/99999",{ 117/255 , 181/255 ,221/255 , 1}))
                exp_txt:SetPosition(-130,-45)
            --------------------------------------------------------------------------------------
            --- 等级
                local level_txt = exp_bar:AddChild(Text(CODEFONT,90,"99",{  255/255 , 255/255 ,255/255 , 1}))
                level_txt:SetPosition(-30,15)

            --------------------------------------------------------------------------------------
            --- API
                page.SetExp = function(page,exp,exp_max)
                    --- exp 和 exp_max 最多保留一位小数
                    exp = math.floor(exp*10)/10
                    exp_max = math.floor(exp_max*10)/10
                    ---
                    local display_txt = tostring(exp) .. "/" .. tostring(exp_max)
                    exp_txt:SetString(display_txt)
                    exp_bar_anim:SetPercent("idle",exp/exp_max)
                    exp_bar_anim:Pause()
                end
                page:SetExp(300,900)

                page.SetLevel = function(page,level,txt_offset)
                    level_txt:SetString(tostring(level))
                    txt_offset = txt_offset or 0
                    level_txt:SetPosition(-30 + txt_offset,15)
                end
            --------------------------------------------------------------------------------------
            --- 角色技能
                local skill_box = page:AddChild(Image())
                skill_box:SetTexture("images/inspect_pad/page_character.xml","page_character_skill.tex")
                skill_box:SetScale(MainScale,MainScale,MainScale)
                skill_box:SetPosition(-270,-40)

            --------------------------------------------------------------------------------------
            --- 技能图标占位.两行、四列
                page.skill_icons = {}
                local icon_scale = MainScale*1.5
                local icon_delta = 110
                for i = 1, 4, 1 do
                    local temp_icon = skill_box:AddChild(Image())
                    temp_icon:SetTexture("images/inspect_pad/page_character.xml","page_character_skill_locked.tex")
                    temp_icon:SetScale(icon_scale,icon_scale,icon_scale)
                    temp_icon:SetPosition(-170 + (icon_delta * (i-1)),85)
                    -- temp_icon.inst.indicator_fn = function(mouse_indicator)
                    --     mouse_indicator.txt:SetString("spell  ".. tostring(i) .. " ")
                    -- end
                    table.insert(page.skill_icons,temp_icon)
                end
                for i = 1, 4, 1 do
                    local temp_icon = skill_box:AddChild(Image())
                    temp_icon:SetTexture("images/inspect_pad/page_character.xml","page_character_skill_locked.tex")
                    temp_icon:SetScale(icon_scale,icon_scale,icon_scale)
                    temp_icon:SetPosition(-170 + (icon_delta * (i-1)),-80)
                    -- temp_icon.inst.indicator_fn = function(mouse_indicator)
                    --     mouse_indicator.txt:SetString("spell  "..tostring(i+4) .. " ")
                    -- end
                    table.insert(page.skill_icons,temp_icon)
                end
                
            --------------------------------------------------------------------------------------
            --- 
            --------------------------------------------------------------------------------------
            --- 立绘
                -- local c_pic = page:AddChild(Image())
                -- c_pic:SetTexture("images/inspect_pad/page_character.xml","page_character_picture2.tex")
                -- c_pic:SetScale(MainScale,MainScale,MainScale)
                -- c_pic:SetPosition(0,30)
                local c_pic = page:AddChild(ImageButton())
                c_pic:SetPosition(0,30)
                c_pic:SetScale(MainScale,MainScale,MainScale)
                local function update_character_pic()
                    local character_spell_type = ThePlayer.PAD_DATA and ThePlayer.PAD_DATA.character_spell_type or "hoshino_spell_type_normal"
                    local temp_img = "page_character_picture2.tex"
                    if character_spell_type == "hoshino_spell_type_normal" then
                        temp_img = "page_character_picture_normal.tex"
                        -- temp_img = "page_character_picture_swimming.tex"
                    elseif character_spell_type == "hoshino_spell_type_swimming" then
                        temp_img = "page_character_picture_swimming.tex"
                        -- temp_img = "page_character_picture_normal.tex"
                    end
                    c_pic:SetTextures( "images/inspect_pad/page_character.xml", temp_img, temp_img, temp_img, temp_img)
                end
                update_character_pic()
                local switch_cd_task = nil
                c_pic:SetOnClick(function()
                    if switch_cd_task == nil then
                        c_pic:OnDisable()
                        ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_spell_type_change")
                        switch_cd_task = c_pic.inst:DoTaskInTime(3,function()
                            switch_cd_task = nil
                            c_pic:OnEnable()
                        end)
                    end
                end)
                c_pic.inst:ListenForEvent("hoshino_event.pad_data_update",update_character_pic,ThePlayer)
                c_pic.inst:DoTaskInTime(0,function()
                    c_pic:MoveToFront()
                end)
                c_pic.focus_scale = {1.1, 1.1, 1.1}
            --------------------------------------------------------------------------------------
            --- 状态栏
                local status_box = page:AddChild(Image())
                status_box:SetTexture("images/inspect_pad/page_character.xml","page_character_status.tex")
                status_box:SetScale(MainScale,MainScale,MainScale)
                status_box:SetPosition(270,30)
                
            --------------------------------------------------------------------------------------
            --- 状态栏数值
                local health_txt = status_box:AddChild(Text(CODEFONT,35,"300",{ 126/255 , 133/255 ,143/255 , 1}))
                health_txt:SetPosition(-150,230)

                local hunger_txt = status_box:AddChild(Text(CODEFONT,35,"400",{ 126/255 , 133/255 ,143/255 , 1}))
                hunger_txt:SetPosition(-150,190)

                local sanity_txt = status_box:AddChild(Text(CODEFONT,35,"500",{ 126/255 , 133/255 ,143/255 , 1}))
                sanity_txt:SetPosition(-150,150)

                --- 护盾值
                local defensive_txt = status_box:AddChild(Text(CODEFONT,35,"N/A",{ 126/255 , 133/255 ,143/255 , 1}))
                defensive_txt:SetPosition(60,230)
                --- 伤害值
                local damage_txt = status_box:AddChild(Text(CODEFONT,35,"N/A",{ 126/255 , 133/255 ,143/255 , 1}))
                damage_txt:SetPosition(60,190)
                --- 速度值
                local speed_txt = status_box:AddChild(Text(CODEFONT,35,"1",{ 126/255 , 133/255 ,143/255 , 1}))
                speed_txt:SetPosition(60,150)

                local function info_update()
                    local data = GetInfoData() or {}
                    --- 护盾值
                    if data.defence then
                        defensive_txt:SetString(tostring(data.defence))
                        defensive_txt:SetPosition(120,230)
                        defensive_txt:SetScale(0.7,1)
                    else
                        defensive_txt:SetString("N/A")
                        defensive_txt:SetPosition(60,230)
                        defensive_txt:SetScale(1,1)
                    end
                    --- 伤害值
                    if data.damage then
                        damage_txt:SetString(tostring(data.damage))
                        damage_txt:SetPosition(120,190)
                        damage_txt:SetScale(0.7,1)
                    else
                        damage_txt:SetString("N/A")
                        damage_txt:SetPosition(60,190)
                        damage_txt:SetScale(1,1)
                    end
                    --- 速度值
                    if data.speed then
                        speed_txt:SetString(tostring(data.speed))
                        speed_txt:SetPosition(120,150)
                        speed_txt:SetScale(0.7,1)
                    else
                        speed_txt:SetString("N/A")
                        speed_txt:SetPosition(60,150)
                        speed_txt:SetScale(1,1)
                    end
                end
                info_update()
                page.inst:ListenForEvent("HOSHINO_INFO_CLIENT_SIDE_UPDATE",info_update,ThePlayer)

                local function RoundToTwoDecimalPlaces(number)
                    return math.floor(number * 100 + 0.5) / 100
                end
                page.inst:DoPeriodicTask(FRAMES*3,function()
                    -- 数值向上取整
                    health_txt:SetString(tostring(math.ceil(ThePlayer.replica.health:GetCurrent())))   --- 血量
                    hunger_txt:SetString(tostring(math.ceil(ThePlayer.replica.hunger:GetCurrent()))) --- 饥饿
                    sanity_txt:SetString(tostring(math.ceil(ThePlayer.replica.sanity:GetCurrent()))) --- San

                    -- defensive_txt:SetString(tostring(ThePlayer.replica.defense:GetCurrent())) --- 防御
                    -- damage_txt:SetString(tostring(ThePlayer.replica.damage:GetCurrent())) --- 伤害
                    -- speed_txt:SetString(tostring( ThePlayer.components.locomotor and RoundToTwoDecimalPlaces(ThePlayer.components.locomotor:GetRunSpeed()) or "N/A"  )) --- 速度
                end)

            --------------------------------------------------------------------------------------
            --- 装备槽
                page.equip_slots = {}
                local equip_slot_icon_y = 10
                -- local equip_slot_1 = status_box:AddChild(Image())
                -- equip_slot_1:SetTexture("images/inspect_pad/page_character.xml","excample_equipment.tex")
                -- equip_slot_1:SetPosition(-187,equip_slot_icon_y)
                -- -- equip_slot_1.inst.indicator_fn = function(mouse_indicator)
                -- --     mouse_indicator.txt:SetString("equip slot 1")
                -- -- end
                

                -- local equip_slot_2 = status_box:AddChild(Image())
                -- equip_slot_2:SetTexture("images/inspect_pad/page_character.xml","excample_equipment.tex")
                -- equip_slot_2:SetPosition(-77,equip_slot_icon_y)
                -- -- equip_slot_2.inst.indicator_fn = function(mouse_indicator)
                -- --     mouse_indicator.txt:SetString("equip slot 2")
                -- -- end
                -- local equip_slot_3 = status_box:AddChild(Image())
                -- equip_slot_3:SetTexture("images/inspect_pad/page_character.xml","excample_equipment.tex")
                -- equip_slot_3:SetPosition(33,equip_slot_icon_y)
                -- -- equip_slot_3.inst.indicator_fn = function(mouse_indicator)
                -- --     mouse_indicator.txt:SetString("equip slot 3")
                -- -- end

                for i = 1, 3, 1 do
                    local temp_slot = status_box:AddChild(Image())
                    temp_slot:SetTexture("images/inspect_pad/page_character.xml","excample_equipment.tex")
                    temp_slot:SetPosition(-187 + (i-1)*110,equip_slot_icon_y)
                    -- temp_slot.inst.indicator_fn = function(mouse_indicator)
                    --     mouse_indicator.txt:SetString("equip slot "..i)
                    -- end
                    -- local old_OnMouseButton = temp_slot.OnMouseButton
                    -- temp_slot.OnMouseButton = function(self,button, down, x, y,...)
                    --     local origin_ret = old_OnMouseButton(self,button, down, x, y,...)
                    --     if down == false then
                    --         if button == MOUSEBUTTON_LEFT then
                    --             temp_slot.inst:PushEvent("mouse_left_clicked")
                    --         else
                    --         -- print("+++++666",i)
                    --             temp_slot.inst:PushEvent("mouse_right_clicked")
                    --         end
                    --     end
                    --     return origin_ret
                    -- end
                    temp_slot:Hide()
                    table.insert(page.equip_slots,temp_slot)
                end
            --------------------------------------------------------------------------------------
            --- 装备强化按钮
                local button_enhancement = status_box:AddChild(ImageButton(
                    "images/inspect_pad/page_character.xml",
                    "page_character_equipment_enhancement.tex",
                    "page_character_equipment_enhancement.tex",
                    "page_character_equipment_enhancement.tex",
                    "page_character_equipment_enhancement.tex",
                    "page_character_equipment_enhancement.tex"
                ))
                button_enhancement:SetPosition(163,10)
                button_enhancement:SetOnClick(function()
                    -- front_root.inst:PushEvent("pad_close")
                    Create_Special_Equipment_Recipes_Box(page,MainScale)
                end)
                local button_enhancement_focus_scale = 1.02
                button_enhancement.focus_scale = {button_enhancement_focus_scale,button_enhancement_focus_scale,button_enhancement_focus_scale}
            --------------------------------------------------------------------------------------
            --------------------------------------------------------------------------------------
            --- 鼠标指示器
                local mouse_indicator = page:AddChild(Widget())
                mouse_indicator:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
                mouse_indicator:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
                local mouse_indicator_img = mouse_indicator:AddChild(Image())
                -- mouse_indicator_img:SetTexture("images/inspect_pad/page_character.xml","page_character_status.tex")
                -- mouse_indicator_img:SetScale(MainScale,MainScale,MainScale)
                mouse_indicator.img = mouse_indicator_img
                local mouse_indicator_txt = mouse_indicator:AddChild(Text(CODEFONT,50,"",{ 0/255 , 0/255 ,0/255 , 1}))
                mouse_indicator.txt = mouse_indicator_txt

                local dx,dy = 80,-80
                local last_mouse_over_inst = nil
                local OnUpdateFn = function()
                    local current_mouse_over_inst = TheInput:GetHUDEntityUnderMouse()  -- 获取鼠标下的实体
                    local pt = TheInput:GetScreenPosition()         -- 获取鼠标屏幕坐标
                    mouse_indicator:SetPosition(pt.x + dx ,pt.y + dy ,0)
                    if current_mouse_over_inst == nil then
                        mouse_indicator:Hide()
                        return
                    end
                    if current_mouse_over_inst.indicator_fn then
                        current_mouse_over_inst.indicator_fn(mouse_indicator)
                        mouse_indicator:Show()
                    else
                        mouse_indicator:Hide()                            
                    end

                end
                page.inst:DoPeriodicTask(FRAMES,OnUpdateFn)
            --------------------------------------------------------------------------------------
            --- 装备槽
                
                local the_slots = {EQUIPSLOTS.HOSHINO_AMULET,EQUIPSLOTS.HOSHINO_BACKPACK,EQUIPSLOTS.HOSHINO_SHOES}
                for i,slot in ipairs(the_slots) do
                    local temp_equipment_inst = ThePlayer.replica.inventory:GetEquippedItem(slot)
                    if temp_equipment_inst and temp_equipment_inst.pad_data then
                        local atlas = temp_equipment_inst.pad_data.atlas
                        local image = temp_equipment_inst.pad_data.image
                        -- print(atlas,image)
                        local inspect_txt = temp_equipment_inst.pad_data.inspect_txt or ""
                        local mouse_indicator_fn = temp_equipment_inst.mouse_indicator_fn

                        page.equip_slots[i]:SetTexture(atlas,image)
                        page.equip_slots[i].inspect_txt = inspect_txt

                        if mouse_indicator_fn then
                            page.equip_slots[i].inst.indicator_fn = function(mouse_indicator)
                                mouse_indicator_fn(mouse_indicator)
                            end
                        else                        
                            page.equip_slots[i].inst.indicator_fn = function(mouse_indicator)
                                mouse_indicator.txt:SetString(inspect_txt)
                            end
                        end
                        page.equip_slots[i]:Show()

                        -- page.equip_slots[i].inst:ListenForEvent("mouse_left_clicked",function()
                        --     front_root.parent.inst:PushEvent("pad_close")
                        --     ThePlayer.replica.inventory:TakeActiveItemFromEquipSlot(slot)
                        --     -- print("装备槽被点击")
                        -- end)
                        -- page.equip_slots[i].inst:ListenForEvent("mouse_right_clicked",function()
                        --     -- print("装备槽被右键点击")
                        --     ThePlayer.replica.hoshino_com_rpc_event:PushEvent("pad_equip_slot_right_click",slot)
                        --     page.equip_slots[i]:Hide()
                        -- end)
                    end
                end
            --------------------------------------------------------------------------------------
            --- 经验值更新函数
                local function update_level_exp_data()
                    local level = ThePlayer.replica.hoshino_com_level_sys:GetLevel()
                    local exp = ThePlayer.replica.hoshino_com_level_sys:GetExp()
                    local exp_max = ThePlayer.replica.hoshino_com_level_sys:GetMaxExp()
                    page:SetExp(exp,exp_max)

                    --- 最大6位数。6位数的时候 偏移 70 。1位数的时候偏移-20
                    local function calculateOffset(number)
                        local numDigits = #tostring(number) -- 获取数字的位数
                        local minDigits = 1
                        local maxDigits = 6
                        local minValue = -20
                        local maxValue = 70                        
                        -- 线性插值公式
                        local offset = minValue + (maxValue - minValue) * (numDigits - minDigits) / (maxDigits - minDigits)                        
                        return offset
                    end
                    page:SetLevel(level,calculateOffset(level))
                end
                update_level_exp_data()
                page.inst:ListenForEvent("hoshino_com_level_sys_client_side_data_update",update_level_exp_data,ThePlayer)
            --------------------------------------------------------------------------------------
            ---
                return page
            --------------------------------------------------------------------------------------

end
TUNING.HOSHINO_INSPECT_PAD_FNS["character"] = page_create
