--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]---
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
return function(inst,front_root)
    
        -- print("open",front_root)
        ------------------------------------------------------------------------------
        --- 
            local root = front_root:AddChild(Widget())
            local atlas = "images/widgets/hoshino_shop_widget.xml"
            root.inst:DoTaskInTime(0,function()
                TheCamera.HOSHINO_ZOOM_BLOCK = true
            end)
            root.inst:ListenForEvent("onremove",function()
                TheCamera.HOSHINO_ZOOM_BLOCK = false
            end)
        ------------------------------------------------------------------------------
        --- 关闭按钮
            local button_close = root:AddChild(ImageButton(
                atlas,
                "close_button.tex",
                "close_button.tex",
                "close_button.tex",
                "close_button.tex",
                "close_button.tex"
            ))
            button_close:SetPosition(730,340)
            button_close:SetOnClick(function()
                root.inst:PushEvent("container_widget_close")
            end)
        ------------------------------------------------------------------------------
        --- 售卖box
            local sell_box = root:AddChild(Widget())
            local price_box = sell_box:AddChild(Image(atlas,"sell_price.tex"))
            local price_text = price_box:AddChild(Text(CODEFONT,35,"500",{ 255/255 , 255/255 ,255/255 , 1}))
            price_text:SetPosition(0,-19)
            local button_sell = sell_box:AddChild(ImageButton(
                atlas,
                "buttom_sell_items.tex",
                "buttom_sell_items.tex",
                "buttom_sell_items.tex",
                "buttom_sell_items.tex",
                "buttom_sell_items.tex"
            ))
            button_sell:SetPosition(132,-15)
            button_sell:SetOnClick(function()
                print("sell")
            end)
            button_sell.focus_scale = {1.05, 1.05, 1.05}
            sell_box:SetPosition(-623,-352)
        ------------------------------------------------------------------------------
        --- 货币按钮组
            --- 信用币按钮
            local coin_box = root:AddChild(Widget())
            coin_box:SetPosition(-600,250)
            local credit_coins_button = coin_box:AddChild(ImageButton(
                atlas,"button_credit_coins.tex",
                "button_credit_coins.tex",
                "button_credit_coins.tex",
                "button_credit_coins.tex",
                "button_credit_coins.tex"))
            credit_coins_button:SetPosition(0,0)
            credit_coins_button.focus_scale = {1.05, 1.05, 1.05}
            local credit_coins_text = credit_coins_button:AddChild(Text(CODEFONT,35,"500",{ 0/255 , 0/255 ,0/255 , 1}))
            credit_coins_button.inst:ListenForEvent("hoshino_event.shop_credit_coins_refresh",function()
                local credit_coins = ThePlayer.HOSHINO_SHOP and ThePlayer.HOSHINO_SHOP.credit_coins or 0
                credit_coins_text:SetString(tostring(credit_coins))
            end,ThePlayer)
            ThePlayer:PushEvent("hoshino_event.shop_credit_coins_refresh")
            credit_coins_button.inst:ListenForEvent("hoshino_com_shop_client_side_data_updated_for_widget",function()
                ThePlayer:PushEvent("hoshino_event.shop_credit_coins_refresh")
            end,ThePlayer)
            --- 绿币按钮
            local green_coins_button = coin_box:AddChild(ImageButton(
                atlas,"button_empty_num.tex",
                "button_empty_num.tex",
                "button_empty_num.tex",
                "button_empty_num.tex",
                "button_empty_num.tex"))
            green_coins_button:SetPosition(0,-70)
            green_coins_button.focus_scale = {1.05, 1.05, 1.05}
            local green_coins_text = green_coins_button:AddChild(Text(CODEFONT,35,"500",{ 0/255 , 0/255 ,0/255 , 1}))
            --- 刷新按钮
            local refresh_button = coin_box:AddChild(ImageButton(
                atlas,"button_refresh.tex",
                "button_refresh.tex",
                "button_refresh.tex",
                "button_refresh.tex",
                "button_refresh.tex"))
            refresh_button:SetPosition(0,-140)
            refresh_button.focus_scale = {1.05, 1.05, 1.05}
            local refresh_cost_text = refresh_button:AddChild(Text(CODEFONT,35,"500",{ 0/255 , 0/255 ,0/255 , 1}))
            refresh_button.inst:ListenForEvent("hoshino_event.shop_refresh_count",function()
                local refresh_count = ThePlayer.HOSHINO_SHOP and ThePlayer.HOSHINO_SHOP.refresh_count or 0
                refresh_cost_text:SetString(tostring(refresh_count))
            end,ThePlayer)
            ThePlayer:PushEvent("hoshino_event.shop_refresh_count")
            refresh_button:SetOnClick(function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_com_shop_refresh_button_clicked")
            end)
            refresh_button.inst:ListenForEvent("hoshino_com_shop_client_side_data_updated_for_widget",function()
                ThePlayer:PushEvent("hoshino_event.shop_refresh_count")
            end,ThePlayer)
        ------------------------------------------------------------------------------
        --- 商店物品盒子
            local items_box = root:AddChild(Image(atlas,"items_background.tex"))
            items_box:SetPosition(170,-100)

            local items_pages_button = items_box:AddChild(Widget())
            items_pages_button:SetPosition(-400,350)

            items_pages_button.buttons = {} -- 方便做今后的类型拓展
            --------------------------------------------------------------------------------
            ---- 特殊物品按钮
                local button_special_items = items_pages_button:AddChild(ImageButton(
                    atlas,"button_special_items_white.tex",
                    "button_special_items_white.tex",
                    "button_special_items_white.tex",
                    "button_special_items_white.tex",
                    "button_special_items_white.tex"))
                button_special_items:SetPosition(0,0)
                button_special_items.focus_scale = {1.02, 1.02, 1.02}
                local button_special_items_icon = button_special_items.image:AddChild(Image(atlas,"button_icon_special_item.tex"))
                button_special_items_icon:SetPosition(-140,30)
                table.insert(items_pages_button.buttons,button_special_items)
                function button_special_items:SetBlack()                --- 变黑函数
                    local image = "button_special_items_black.tex"
                    self:SetTextures(atlas,image,image,image,image,image)
                end
                function button_special_items:SetWhite()                --- 变白函数
                    local image = "button_special_items_white.tex"
                    self:SetTextures(atlas,image,image,image,image,image)
                end
                button_special_items:SetOnClick(function()
                    for i, temp_button in ipairs(items_pages_button.buttons) do
                        if temp_button == button_special_items then
                            button_special_items:SetBlack()
                        elseif temp_button.SetWhite then
                            temp_button:SetWhite()
                        end
                    end
                    items_box.inst:PushEvent("items_page_switch", "special_items")
                end)
            --------------------------------------------------------------------------------
            ---- 普通物品按钮
                local button_normal_items = items_pages_button:AddChild(ImageButton(
                    atlas,"button_normal_items_white.tex",
                    "button_normal_items_white.tex",
                    "button_normal_items_white.tex",
                    "button_normal_items_white.tex",
                    "button_normal_items_white.tex"))
                button_normal_items:SetPosition(290,0)
                button_normal_items.focus_scale = {1.02, 1.02, 1.02}
                local button_normal_items_icon = button_normal_items.image:AddChild(Image(atlas,"button_icon_normal_item.tex"))
                button_normal_items_icon:SetPosition(-140,30)
                table.insert(items_pages_button.buttons,button_normal_items)
                function button_normal_items:SetBlack()                 --- 变黑函数
                    local image = "button_normal_items_black.tex"
                    self:SetTextures(atlas,image,image,image,image,image)
                end
                function button_normal_items:SetWhite()                 --- 变白函数
                    local image = "button_normal_items_white.tex"
                    self:SetTextures(atlas,image,image,image,image,image)
                end
                button_normal_items:SetOnClick(function()
                    for i, temp_button in ipairs(items_pages_button.buttons) do
                        if temp_button == button_normal_items then
                            button_normal_items:SetBlack()
                        elseif temp_button.SetWhite then
                            temp_button:SetWhite()
                        end
                    end
                    items_box.inst:PushEvent("items_page_switch", "normal_items")
                end)
            --------------------------------------------------------------------------------
            --- 储存当前显示的页面，方便刷新
                items_box.inst:ListenForEvent("items_page_switch", function(self, page)
                    items_box.current_display_page = page
                end)
            --------------------------------------------------------------------------------
            --- 默认显示第一页
                items_box.inst:DoTaskInTime(0,function()
                    pcall(function()
                        local temp_button = items_pages_button.buttons[1]
                        temp_button:SetBlack()
                        temp_button.onclick()
                    end)
                end)
            --------------------------------------------------------------------------------
        ------------------------------------------------------------------------------
        --- 
        ------------------------------------------------------------------------------
        --- 滚动条区域创建函数。得到区域位置，和所有slot
            local function create_scroll_box_and_get_slots(slots_num)
                --------------------------------------------------------------------------
                ---- 行数计算
                    local lines_num = 10
                    if slots_num then
                        --- 取8倍的整数，向上取整。
                        lines_num = math.ceil(slots_num/8)
                    end
                --------------------------------------------------------------------------
                --- 单行操作
                    local line_items_box = {}
                    local num = 1
                    local lines = {}
                    local all_slots = {}
                    local slot_width = 136
                    local slot_height = 155
                    local function create_line()
                        local line = Widget()
                        --- 8 个格子 。 第一个格子 -4.5*slot_width 。第八个 4.5*slot_width   
                        for i = 1, 8, 1 do
                            local temp_slot = line:AddChild(Image(atlas,"item_slot_bg.tex"))
                            temp_slot:SetPosition((i-4.5)*slot_width,0)
                            table.insert(all_slots,temp_slot)
                        end
                        -- local text = line:AddChild(Text(CODEFONT,35,"500",{ 0/255 , 0/255 ,0/255 , 1}))
                        -- text:SetString("第"..num.."行")
                        num = num + 1
                        return line
                    end
                --------------------------------------------------------------------------
                --- 滚动条区域创建
                    for i = 1, lines_num, 1 do
                        table.insert(line_items_box,create_line())
                    end
                    local listwidth = 800
                    local listheight = 620
                    local itemheight = 5
                    local itempadding = 150
                    local updatefn = function() end
                    local widgetstoupdate = nil
                    local scroll_bar_area = items_box:AddChild(ScrollableList(line_items_box,listwidth, listheight, itemheight, itempadding,updatefn,widgetstoupdate))
                    scroll_bar_area:SetPosition(390,-60) -- 设置滚动区域位置
                    scroll_bar_area.scroll_bar_container:SetPosition(-245,60)  --- 设置滚动条位置
                    ---- 设置滚动条样式
                    scroll_bar_area.up_button:SetTextures(atlas,"arrow_scrollbar_up.tex")
                    scroll_bar_area.down_button:SetTextures(atlas,"arrow_scrollbar_down.tex")
                    scroll_bar_area.scroll_bar_line:SetTexture(atlas,"scrollbarline.tex")
                    scroll_bar_area.position_marker:SetTextures(atlas,"scrollbarbox.tex","scrollbarbox.tex","scrollbarbox.tex","scrollbarbox.tex","scrollbarbox.tex")
                    scroll_bar_area.position_marker:OnGainFocus() --- 不知道为什么，贴图替换失败。只能用这种方式刷一下。
                    scroll_bar_area.position_marker:OnLoseFocus()
                --------------------------------------------------------------------------
                --- 单个格子函数添加
                    for k, single_slot in pairs(all_slots) do
                        function single_slot:SetBlue()
                            self:SetTexture(atlas,"item_slot_bg.tex")
                            self:SetTint(1,1,1,1)
                        end
                        function single_slot:SetGray()
                            self:SetTexture(atlas,"item_slot_bg_gray.tex")
                            self:SetTint(1,1,1,0.5)
                        end

                        --[[
                            商品数据。格式如下：
                            {
                                prefab = "log",
                                name = STRINGS.NAMES[string.upper(prefab_name)], --- 自动补全。也可强制下发。
                                bg = "item_slot_blue.tex", --- 背景颜色  item_slot_blue.tex  item_slot_colourful.tex  item_slot_golden.tex  item_slot_gray.tex
                                icon = {atlas,image}, --- 图标
                                right_click = false,    --- 用于上传
                                price = 100, --- 价格
                                price_type = "credit_coins"  -- 货币需求。
                                index = "log_credit_coins_100",  --- 自动合并上传，用于相应购买事件.
                            }

                        ]]--
                        function single_slot:SetData(_table)
                            self:SetBlue() -- 换背景。
                            local bg = _table.bg or "item_slot_gray.tex"                                --- 背景颜色
                            local prefab = _table.prefab or "log"                                       --- 物品的prefab
                            local name = _table.mouseover_text or STRINGS.NAMES[string.upper(prefab)]  --- 显示的名字
                            local price = _table.price or 0                         --- 显示的价格
                            local index = _table.index                              --- 购买index
                            local price_type = _table.price_type or "credit_coins"  --- 货币类型

                            self.index = index
                            self.prefab = prefab
                            self.inst.mouseover_text = name -- 给mouseover调用。
                            --- 添加图标背景
                                if self.bg == nil then
                                    self.bg = self:AddChild(Image())
                                    self.bg:SetPosition(0,25)
                                    self.bg:SetScale(0.7,0.7)
                                end
                                self.bg:SetTexture(atlas,bg)
                                self.bg.inst.mouseover_text = name -- 给mouseover调用。
                            --- 物品图标
                                if self.icon == nil then
                                    self.icon = self:AddChild(Image())
                                    self.icon:SetPosition(0,25)
                                end
                                self.icon:SetTexture(_table.icon.atlas,_table.icon.image)
                                self.icon.inst.mouseover_text = name -- 给mouseover调用。
                            --- 物品价格(背景)
                                if self.price_bg == nil then
                                    self.price_bg = self:AddChild(Image())
                                    self.price_bg:SetPosition(0,-25)
                                end
                                if price_type == "credit_coins" then
                                    self.price_bg:SetTexture(atlas,"price_slot.tex")
                                else
                                    --- 预留给其他货币
                                end
                                self.price_bg.inst.mouseover_text = name -- 给mouseover调用。
                            --- 物品价格(文本)
                                if self.price_text == nil then
                                    self.price_text = self:AddChild(Text(CODEFONT,30,"500",{ 255/255 , 255/255 ,255/255 , 1}))
                                    self.price_text:SetPosition(10,-27)
                                end
                                self.price_text.inst.mouseover_text = name -- 给mouseover调用。
                                self.price_text:SetString(tostring(price))
                            --- 购买按钮。
                                if self.buy_btn == nil then
                                    local buy_btn_image = "button_item_buy.tex"
                                    self.buy_btn = self:AddChild(ImageButton(atlas,buy_btn_image,buy_btn_image,buy_btn_image,buy_btn_image))
                                    self.buy_btn.index = self.index --- 数据绑定到按钮。给点击事件上传用。
                                    self.buy_btn:SetPosition(20,-60)
                                    self.buy_btn.focus_scale = {1.04,1.04,1.04}
                                    local buy_btn_OnControl = self.buy_btn.OnControl
                                    self.buy_btn.OnControl = function(btn_self,control,down)
                                        -- print("click",control)
                                        btn_self.control = control  --- 确保鼠标右键、左键都能点击。 右键 control = 1, 左键 control = 29
                                        if buy_btn_OnControl(btn_self,control,down) then
                                            if not down then
                                                -- print("shop button click",btn_self.index)
                                                if control == 1 and btn_self.index then
                                                    ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_event.shop_item_buy",{index = btn_self.index , right_click = true})
                                                elseif control == 29 and btn_self.index then
                                                    ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_event.shop_item_buy",{index = btn_self.index })
                                                end
                                            end
                                            return true
                                        end
                                        return false
                                    end
                                end
                                self.buy_btn.inst.mouseover_text = name -- 给mouseover调用。
                                self.buy_btn.image.inst.mouseover_text = name -- 给mouseover调用。

                        end
                        function single_slot:Clear()
                            pcall(function()
                                self.bg:Kill()
                                self.bg = nil
                                self.icon:Kill()
                                self.icon = nil
                                self.price_bg:Kill()
                                self.price_bg = nil
                                self.price:Kill()
                                self.price = nil
                                self.mouseover_text = nil
                                self.buy_btn:Kill()
                                self.buy_btn = nil

                                self.prefab = nil
                                self.index = nil
                                self.inst.mouseover_text = nil
                            end)
                            self:SetGray()
                        end

                        -- -- --- 测试数据
                        -- local test_data = {
                        --     prefab = "log",
                        --     -- name = STRINGS.NAMES[string.upper("log")],
                        --     bg = "item_slot_golden.tex",
                        --     icon = {atlas = GetInventoryItemAtlas("log.tex"),image = "log.tex"},
                        --     price = 100,
                        -- }
                        -- single_slot:SetData(test_data)


                        single_slot:SetGray()
                    end
                --------------------------------------------------------------------------

                return scroll_bar_area,all_slots
            end
        ------------------------------------------------------------------------------
        --- 数据格式获取。
        ------------------------------------------------------------------------------
        --- 普通物品区域
            root.inst:ListenForEvent("create_normal_items_page",function()
                local normal_items = ThePlayer.HOSHINO_SHOP["normal_items"] or {}
                if #normal_items > 0 and root.normal_items_page_last_data ~= normal_items then
                    root.normal_items_page_last_data = normal_items
                    if root.normal_items_page then
                        root.normal_items_page:Kill()
                    end
                    local normal_items_page,normal_item_slots = create_scroll_box_and_get_slots(#normal_items) -- 暂时默认300个格子
                    root.normal_items_page = normal_items_page
                    normal_items_page:Hide()
                    normal_items_page.inst:ListenForEvent("items_page_switch",function(_,page)
                        if page == "normal_items" then
                            normal_items_page:Show()
                        else
                            normal_items_page:Hide()
                        end
                    end,items_box.inst)
                    --- 给格子设置数据
                    for index, item_slot in pairs(normal_items) do
                        normal_item_slots[index]:SetData(normal_items[index])
                    end
                end

            end)
            root.inst:ListenForEvent("hoshino_com_shop_client_side_data_updated_for_widget",function()
                --- 服务器下发新数据的时候刷新
                root.inst:PushEvent("create_normal_items_page")
                if items_box.current_display_page == "normal_items" then
                    root.normal_items_page:Show()
                end
            end,ThePlayer)
            root.inst:PushEvent("create_normal_items_page") -- 初始化普通物品页面
        ------------------------------------------------------------------------------
        --- 特殊物品区域                
            root.inst:ListenForEvent("create_special_items_page",function()
                local special_items = ThePlayer.HOSHINO_SHOP["special_items"] or {}
                if #special_items > 0 and root.special_items_page_data ~= special_items then
                    root.special_items_page_data = special_items
                    if root.special_items_page then
                        root.special_items_page:Kill()
                    end
                    local special_items_page,special_item_slots = create_scroll_box_and_get_slots(#special_items) -- 暂时默认300个格子
                    root.special_items_page = special_items_page
                    special_items_page:Hide()
                    special_items_page.inst:ListenForEvent("items_page_switch",function(_,page)
                        if page == "special_items" then
                            special_items_page:Show()
                        else
                            special_items_page:Hide()
                        end
                    end,items_box.inst)
                    --- 给格子设置数据
                    for index, item_slot in pairs(special_items) do
                        special_item_slots[index]:SetData(special_items[index])
                    end
                end
            end)
            root.inst:ListenForEvent("hoshino_com_shop_client_side_data_updated_for_widget",function()
                --- 服务器下发新数据的时候刷新
                root.inst:PushEvent("create_special_items_page")
                if items_box.current_display_page == "special_items" then
                    root.special_items_page:Show()
                end
            end,ThePlayer)
            root.inst:PushEvent("create_special_items_page") -- 初始化特殊物品页面
        ------------------------------------------------------------------------------
        ------------------------------------------------------------------------------
        --- 关闭事件
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
                    root.inst:PushEvent("container_widget_close")
                end
            end)
            root.inst:ListenForEvent("onremove",function()
                key_handler:Remove()
            end)
            root.inst:ListenForEvent("container_widget_close",function()
                inst.replica.container:Close()
            end)
        ------------------------------------------------------------------------------
        --- mouseover 显示
            --- 鼠标指示器
            local mouse_indicator = front_root:AddChild(Widget())
            mouse_indicator:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            mouse_indicator:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            local mouse_indicator_img = mouse_indicator:AddChild(Image())
            -- mouse_indicator_img:SetTexture("images/inspect_pad/page_character.xml","page_character_status.tex")
            -- mouse_indicator_img:SetScale(MainScale,MainScale,MainScale)
            mouse_indicator.img = mouse_indicator_img
            local mouse_indicator_txt = mouse_indicator:AddChild(Text(TALKINGFONT,50,"",{ 0/255 , 255/255 ,0/255 , 1})) --- 纯粹绿色
            -- local mouse_indicator_txt = mouse_indicator:AddChild(Text(TALKINGFONT,50,"",{ 255/255 , 255/255 ,255/255 , 1})) --- 白色
            -- local mouse_indicator_txt = mouse_indicator:AddChild(Text(TALKINGFONT,50,"",{ 51/255 , 255/255 ,255/255 , 1})) --- 天蓝色
            mouse_indicator.txt = mouse_indicator_txt

            local dx,dy = -40,40
            local last_mouse_over_inst = nil
            local OnUpdateFn = function()
                local current_mouse_over_inst = TheInput:GetHUDEntityUnderMouse()  -- 获取鼠标下的实体
                local pt = TheInput:GetScreenPosition()         -- 获取鼠标屏幕坐标
                mouse_indicator:SetPosition(pt.x + dx ,pt.y + dy ,0)
                if current_mouse_over_inst == nil then
                    mouse_indicator:Hide()
                    return
                end
                if current_mouse_over_inst.mouseover_text then
                    mouse_indicator.txt:SetString(current_mouse_over_inst.mouseover_text)                        
                    mouse_indicator:Show()
                else
                    mouse_indicator:Hide()                            
                end

            end
            front_root.inst:DoPeriodicTask(FRAMES,OnUpdateFn)
        ------------------------------------------------------------------------------
        --- 界面打开的时候初始化。（点击【特殊资源】按钮）
        ------------------------------------------------------------------------------



end