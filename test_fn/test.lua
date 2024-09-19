
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
local flg,error_code = pcall(function()
    print("WARNING:PCALL START +++++++++++++++++++++++++++++++++++++++++++++++++")
    local x,y,z =    ThePlayer.Transform:GetWorldPosition()  
    ----------------------------------------------------------------------------------------------------------------    ----------------------------------------------------------------------------------------------------------------
        -- local inst  = ThePlayer.components.inventory:GetActiveItem()
        -- print(inst)
        -- ThePlayer.components.inventory:DropActiveItem()
    ----------------------------------------------------------------------------------------------------------------
        -- print(ThePlayer.components.inventory:IsHeavyLifting())
        -- for k, v in pairs(forest_network.components.worldtemperature) do
        --     print(k,v)
        -- end
        -- local inst = TheSim:FindFirstEntityWithTag("hoshino_equipment_cape")
        -- print(inst)
        -- inst.replica.container:Open(ThePlayer)
    ----------------------------------------------------------------------------------------------------------------
            -- for k, v in pairs(TUNING["hoshino.equippable"]) do
            --     print(k,v)
            -- end
            -- print(TUNING["hoshino.equippable"]:GetAmuletSlot())
    ----------------------------------------------------------------------------------------------------------------
            -- local npc = SpawnPrefab("woodie")
            -- npc.Transform:SetPosition(x, y, z)
            -- npc.components.health:Kill()
    ----------------------------------------------------------------------------------------------------------------
        -- local spriter_big = SpawnPrefab("hoshino_fx_spriter_big")
        -- spriter_big.components.hoshino_com_linearcircler:SetCircleTarget(ThePlayer)
        -- spriter_big.components.hoshino_com_linearcircler:Start()
        -- spriter_big.components.hoshino_com_linearcircler.randAng = 0.125
        -- spriter_big.components.hoshino_com_linearcircler.clockwise = math.random(100) < 50
        -- spriter_big.components.hoshino_com_linearcircler.distance_limit = 2.5
        -- spriter_big.components.hoshino_com_linearcircler.setspeed = 0.2
    ----------------------------------------------------------------------------------------------------------------
            -- ThePlayer.AnimState:PlayAnimation("erd_run_loop",true)
    ----------------------------------------------------------------------------------------------------------------
            -- ThePlayer.components.hoshino_func:RPC_PushEvent("rpc_test",{
            --     x = 100,y = 100,z = 101
            -- })
            -- ThePlayer.replica.hoshino_func:RPC_PushEvent("rpc_test",{
            --     x = 100,y = 100,z = 101
            -- })
    ----------------------------------------------------------------------------------------------------------------
            -- 立绘测试  hoshino_drawing_test
                -- ThePlayer:PushEvent("hoshino.drawing.display",{
                --     bank = "hoshino_drawing_test",
                --     build = "hoshino_drawing_test",
                --     anim = "idle",
                --     location = 5 ,
                --     speed = 1.5,
                --     scale = 0.5,
                -- })
    ----------------------------------------------------------------------------------------------------------------
        -- --- 精灵调试

        --     if ThePlayer.__spriter then
        --         ThePlayer.__spriter:Remove()
        --     end

        --     ThePlayer.__spriter = SpawnPrefab("hoshino_fx_spriter_big")
        --     ThePlayer.__spriter:PushEvent("Set",{
        --         player = ThePlayer,  --- 跟随目标
        --         range = 3,           --- 环绕点半径
        --         point_num = 15,       --- 环绕点
        --         -- new_pt_time = 0.5 ,    --- 新的跟踪点时间
        --         -- speed = 8,           --- 强制固定速度
        --         speed_mult = 2,      --- 速度倍速
        --         next_pt_dis = 0.5,      --- 触碰下一个点的距离
        --         speed_soft_delta = 20, --- 软增加
        --         y = 1.5,
        --         tail_time = 0.2,
        --     })
    ----------------------------------------------------------------------------------------------------------------
            -- SpawnPrefab("hoshino_fx_sharp"):PushEvent("Set",{
            --     target = ThePlayer                
            -- })
    ----------------------------------------------------------------------------------------------------------------
    -----   等级系统
                -- if not TheNet:IsDedicated() then
                --     ThePlayer.replica.hoshino_level_sys:AddClientSideUpdateFn(function(num)
                --         print("level client side",num)
                --     end)
                -- else
                --     ThePlayer.components.hoshino_level_sys:LevelUp()
                -- end

                -- ThePlayer.components.hoshino_level_sys:LevelUp()

    ----------------------------------------------------------------------------------------------------------------

    ----------------------------------------------------------------------------------------------------------------
        --  SpawnPrefab("hoshino_fx_shadow_pillar"):PushEvent("Set",{
        --     pt = Vector3(x,y,z),
        --     time = 3,
        --     warningtime = 2,
        --  })
    ----------------------------------------------------------------------------------------------------------------
            -- if ThePlayer.PushEvent_old == nil then
            --     ThePlayer.PushEvent_old = ThePlayer.PushEvent
            --     ThePlayer.PushEvent = function(self,event,...)
            --         print("player event",event)
            --         return self.PushEvent_old(self,event,...)
            --     end
            -- end
            -- ThePlayer.components.hoshino_level_sys:DoDelta(2)

            -- if TheWorld.PushEvent_old == nil then
            --     TheWorld.PushEvent_old = TheWorld.PushEvent
            --     TheWorld.PushEvent = function(self,event,...)
            --         print("world event",event)
            --         return self.PushEvent_old(self,event,...)
            --     end
            -- else
            --     TheWorld.PushEvent = TheWorld.PushEvent_old
            -- end

    ----------------------------------------------------------------------------------------------------------------
                -- ThePlayer.HUD:hoshino_powerbar_show()
                -- -- if not ThePlayer.replica.hoshino_level_sys then
                -- --     return
                -- -- end
                -- -- if not ThePlayer.replica.hoshino_resolve_power then
                -- --     return
                -- -- end
                -- print("hoshino_level_sys",ThePlayer.replica.hoshino_level_sys)
                -- print("hoshino_resolve_power",ThePlayer.replica.hoshino_resolve_power)

                -- ThePlayer.HUD:hoshino_powerbar_show(function(root)
                --     -- bar:SetPosition(15,-24)

                --     local lv_text_2 = root:AddChild(Text(CODEFONT,30,"Lv.50",{ 255/255 , 255/255 ,255/255 , 1}))
                --     lv_text_2:SetPosition(-(20-1.5),18.5)

                --     local lv_text = root:AddChild(Text(CODEFONT,30,"Lv.50",{ 102/255 , 255/255 ,102/255 , 1}))
                --     lv_text:SetPosition(-20,20)



                --     local num_text_2 = root:AddChild(Text(CODEFONT,30,"100",{ 255/255 , 255/255 ,255/255 , 1}))
                --     num_text_2:SetPosition(15+1.5,-(24+1.5))

                --     local num_text = root:AddChild(Text(CODEFONT,30,"100",{ 0/255 , 0/255 ,0/255 , 1}))
                --     num_text:SetPosition(15,-24)

                -- end)
    ----------------------------------------------------------------------------------------------------------------
    ---- 击飞屏蔽
                -- ThePlayer:ListenForEvent("newstate",function(_,_table)
                --     if _table == nil then
                --         return
                --     end

                --     print("newstate",_table.statename)
                -- end)
                -- ThePlayer:ListenForEvent("newstate",function(_,_table)
                --     if _table == nil then
                --         return
                --     end

                --     -- print("newstate",_table.statename)
                --     if _table.statename == "knockback" then
                --         ThePlayer.sg:GoToState("idle")
                --     end

                -- end)
    ----------------------------------------------------------------------------------------------------------------
    -- --- 褪色的记忆
    --         SpawnPrefab("hoshino_projectile_faded_memory"):PushEvent("Set",{
    --             pt = Vector3(x+10,0,z+10),
    --             -- y = 3,
    --             tail_time = 0.3,
    --             speed = 8,
    --         })
    ----------------------------------------------------------------------------------------------------------------
    --- 技能特效
            -- SpawnPrefab("hoshino_fx_scythe_attack"):PushEvent("Set",{
            --     pt = Vector3(x,y,z),
            --     speed = 2,
            --     scale = 3,
            -- })
    ----------------------------------------------------------------------------------------------------------------
        -- ThePlayer.components.playercontroller:DoAction(BufferedAction(ThePlayer, nil, ACTIONS.hoshino_SCYTHE_SPELL_ACTION))
        -- ThePlayer.components.hoshino_func:RPC_PushEvent("hoshino_spell_sound_client","dontstarve/common/together/celestial_orb/active")
        -- ThePlayer:ListenForEvent("hoshino_spell_sound_client",function(_,addr)
        --     print("hoshino_spell_sound_client",addr)
        -- end)
        -- TheFrontEnd:GetSound():PlaySound("dontstarve/common/together/celestial_orb/active")
    ----------------------------------------------------------------------------------------------------------------
    --
        -- ThePlayer.___test = function(front_root,MainScale)
            
        -- end

    ----------------------------------------------------------------------------------------------------------------
    --- 卡牌系统调试
        -- ThePlayer.components.hoshino_cards_sys:CreateWhiteCards(3)
        -- ThePlayer.components.hoshino_com_rpc_event:PushEvent("hoshino_event.inspect_hud_warning",true)  -- 下发HUD警告    
    ----------------------------------------------------------------------------------------------------------------
    --- 等级系统
        -- ThePlayer.components.hoshino_com_level_sys:SetLevel(111999798)
        -- ThePlayer.components.hoshino_com_level_sys:SetMaxExp(66000)
        -- ThePlayer.components.hoshino_com_level_sys:SetExp(52345)
    ----------------------------------------------------------------------------------------------------------------
    --- 卡牌 buff 调试
        -- ThePlayer.components.hoshino_com_debuff:Add_Max_Helth(33)
        -- ThePlayer.components.hoshino_com_debuff:Add_Max_Sanity(22)
        -- ThePlayer.components.hoshino_com_debuff:Add_Max_Hunger(66)
        -- ThePlayer.components.hoshino_com_debuff:Add_Hunger_Down_Mult(0.03)
        -- print("max",ThePlayer.components.hoshino_com_debuff:Is_Hunger_Down_Mult_Max())


        -- ThePlayer.components.hoshino_com_debuff:Add_Damage_Mult(1)
        -- ThePlayer.components.sanity:DoDelta(-10)

        -- ThePlayer.components.hoshino_com_debuff:Add_Armor_Down_Blocker_Percent(0.1)

    ----------------------------------------------------------------------------------------------------------------
    ---
        -- local item = TheSim:FindFirstEntityWithTag("hoshino_other_armor_item")
        -- print(item:GetDebugString())
    ----------------------------------------------------------------------------------------------------------------
    --- 配方返回
            -- ThePlayer.components.hoshino_com_debuff:Add_Probability_Of_Returning_Recipe(0.1)
            -- ThePlayer.components.hoshino_com_debuff:Add_Returning_Recipe_By_Count(3)
            -- print(ThePlayer.components.hoshino_data:Add("Returning_Recipe_By_Count_Current",0))
            -- print(ThePlayer.components.hoshino_com_debuff:Get_Returning_Recipe_By_Count())
            -- print(ThePlayer.components.hoshino_com_debuff:Get_Probability_Of_Returning_Recipe())
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- ThePlayer.components.hoshino_com_debuff:Add_Death_Snapshot_Protector(1)
    ----------------------------------------------------------------------------------------------------------------
    --- 卡牌创建
        -- ThePlayer.components.hoshino_cards_sys:DefultCardsNum_Delta(1)
        -- ThePlayer.components.hoshino_cards_sys:CreateCardsByPool_Default()
        -- ThePlayer.components.hoshino_cards_sys:AddRefreshNum(100)
        -- print(ThePlayer.components.hoshino_cards_sys:GetDefaultCardsNum())
        -- print(ThePlayer.components.hoshino_cards_sys:IsCardsSelectting())

        -- ThePlayer.components.hoshino_cards_sys:CreateCardsByForceCMD({
        --     "test_card_black",
        --     -- "card_white",
        --     "card_colourful",
        --     "card_colourful",
        --     "card_golden",
        --     "card_golden",
        -- })

        -- ThePlayer.components.hoshino_cards_sys:CreateCardsByPool_Default()

        -- for k, v in pairs(ThePlayer.PAD_DATA) do
        --     print(k,v)
        -- end
        -- for k, current_card_data in pairs(ThePlayer.PAD_DATA.cards) do
        --     print(current_card_data.card_name)
        -- end
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- ThePlayer.components.hoshino_com_builder_blocker:SetDailyMax(10)

        -- local item = SpawnPrefab("hoshino_item_cards_pack")
        -- item:PushEvent("Set",{
        --     cards = {
        --         -- "card_golden",
        --         "overdraft",
        --         -- "card_black",
        --         -- "summon_tumbleweed",
        --         -- "test_card_white",
        --         -- "test_card_white",
        --     },
        -- })
        -- -- item:PushEvent("SetName","3-1")
        -- ThePlayer.components.inventory:GiveItem(item)

    ----------------------------------------------------------------------------------------------------------------
    --- 
        -- local inst = ThePlayer
        local inst = SpawnPrefab("moonhound")
        local debuff_prefab = "hoshino_card_debuff_for_monster_drop_cards_pack"
        while true do
            local debuff_inst = inst:GetDebuff(debuff_prefab)
            if debuff_inst and debuff_inst:IsValid() then
                print("test 成功安装debuff",debuff_inst)
                break
            end
            inst:AddDebuff(debuff_prefab,debuff_prefab)
        end
        inst.Transform:SetPosition(x,y,z)
        inst:DoTaskInTime(2,function()
            inst.components.health:Kill()
        end)
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- SpawnPrefab("hoshino_sfx_explode"):PushEvent("Set",{
        --     pt = Vector3(x,y,z),
        --     scale = 2,
        -- })
    ----------------------------------------------------------------------------------------------------------------
    --- 
        -- ThePlayer.___test_container_fn = function(inst,front_root)
        --     -- -- print("open",front_root)
        --     -- ------------------------------------------------------------------------------
        --     -- --- 
        --     --     local root = front_root:AddChild(Widget())
        --     --     local atlas = "images/widgets/hoshino_shop_widget.xml"
        --     --     root.inst:DoTaskInTime(0,function()
        --     --         TheCamera.HOSHINO_ZOOM_BLOCK = true
        --     --     end)
        --     --     root.inst:ListenForEvent("onremove",function()
        --     --         TheCamera.HOSHINO_ZOOM_BLOCK = false
        --     --     end)
        --     -- ------------------------------------------------------------------------------
        --     -- --- 关闭按钮
        --     --     local button_close = root:AddChild(ImageButton(
        --     --         atlas,
        --     --         "close_button.tex",
        --     --         "close_button.tex",
        --     --         "close_button.tex",
        --     --         "close_button.tex",
        --     --         "close_button.tex"
        --     --     ))
        --     --     button_close:SetPosition(730,340)
        --     --     button_close:SetOnClick(function()
        --     --         root.inst:PushEvent("container_widget_close")
        --     --     end)
        --     -- ------------------------------------------------------------------------------
        --     -- --- 售卖box
        --     --     local sell_box = root:AddChild(Widget())
        --     --     local price_box = sell_box:AddChild(Image(atlas,"sell_price.tex"))
        --     --     local price_text = price_box:AddChild(Text(CODEFONT,35,"500",{ 255/255 , 255/255 ,255/255 , 1}))
        --     --     price_text:SetPosition(0,-19)
        --     --     local button_sell = sell_box:AddChild(ImageButton(
        --     --         atlas,
        --     --         "buttom_sell_items.tex",
        --     --         "buttom_sell_items.tex",
        --     --         "buttom_sell_items.tex",
        --     --         "buttom_sell_items.tex",
        --     --         "buttom_sell_items.tex"
        --     --     ))
        --     --     button_sell:SetPosition(132,-15)
        --     --     button_sell:SetOnClick(function()
        --     --         print("sell")
        --     --     end)
        --     --     button_sell.focus_scale = {1.05, 1.05, 1.05}
        --     --     sell_box:SetPosition(-623,-352)
        --     -- ------------------------------------------------------------------------------
        --     -- --- 货币按钮组
        --     --     local coin_box = root:AddChild(Widget())
        --     --     coin_box:SetPosition(-600,250)
        --     --     local credit_coins_button = coin_box:AddChild(ImageButton(
        --     --         atlas,"button_credit_coins.tex",
        --     --         "button_credit_coins.tex",
        --     --         "button_credit_coins.tex",
        --     --         "button_credit_coins.tex",
        --     --         "button_credit_coins.tex"))
        --     --     credit_coins_button:SetPosition(0,0)
        --     --     credit_coins_button.focus_scale = {1.05, 1.05, 1.05}
        --     --     local credit_coins_text = credit_coins_button:AddChild(Text(CODEFONT,35,"500",{ 0/255 , 0/255 ,0/255 , 1}))

        --     --     local green_coins_button = coin_box:AddChild(ImageButton(
        --     --         atlas,"button_empty_num.tex",
        --     --         "button_empty_num.tex",
        --     --         "button_empty_num.tex",
        --     --         "button_empty_num.tex",
        --     --         "button_empty_num.tex"))
        --     --     green_coins_button:SetPosition(0,-70)
        --     --     green_coins_button.focus_scale = {1.05, 1.05, 1.05}
        --     --     local green_coins_text = green_coins_button:AddChild(Text(CODEFONT,35,"500",{ 0/255 , 0/255 ,0/255 , 1}))

        --     --     local refresh_button = coin_box:AddChild(ImageButton(
        --     --         atlas,"button_refresh.tex",
        --     --         "button_refresh.tex",
        --     --         "button_refresh.tex",
        --     --         "button_refresh.tex",
        --     --         "button_refresh.tex"))
        --     --     refresh_button:SetPosition(0,-140)
        --     --     refresh_button.focus_scale = {1.05, 1.05, 1.05}
        --     --     local refresh_cost_text = refresh_button:AddChild(Text(CODEFONT,35,"500",{ 0/255 , 0/255 ,0/255 , 1}))

        --     -- ------------------------------------------------------------------------------
        --     -- --- 商店物品盒子
        --     --     local items_box = root:AddChild(Image(atlas,"items_background.tex"))
        --     --     items_box:SetPosition(170,-100)

        --     --     local items_pages_button = items_box:AddChild(Widget())
        --     --     items_pages_button:SetPosition(-400,350)

        --     --     items_pages_button.buttons = {} -- 方便做今后的类型拓展
        --     --     --------------------------------------------------------------------------------
        --     --     ---- 特殊物品按钮
        --     --         local button_special_items = items_pages_button:AddChild(ImageButton(
        --     --             atlas,"button_special_items_white.tex",
        --     --             "button_special_items_white.tex",
        --     --             "button_special_items_white.tex",
        --     --             "button_special_items_white.tex",
        --     --             "button_special_items_white.tex"))
        --     --         button_special_items:SetPosition(0,0)
        --     --         button_special_items.focus_scale = {1.02, 1.02, 1.02}
        --     --         local button_special_items_icon = button_special_items.image:AddChild(Image(atlas,"button_icon_special_item.tex"))
        --     --         button_special_items_icon:SetPosition(-140,30)
        --     --         table.insert(items_pages_button.buttons,button_special_items)
        --     --         function button_special_items:SetBlack()                --- 变黑函数
        --     --             local image = "button_special_items_black.tex"
        --     --             self:SetTextures(atlas,image,image,image,image,image)
        --     --         end
        --     --         function button_special_items:SetWhite()                --- 变白函数
        --     --             local image = "button_special_items_white.tex"
        --     --             self:SetTextures(atlas,image,image,image,image,image)
        --     --         end
        --     --         button_special_items:SetOnClick(function()
        --     --             for i, temp_button in ipairs(items_pages_button.buttons) do
        --     --                 if temp_button == button_special_items then
        --     --                     button_special_items:SetBlack()
        --     --                 elseif temp_button.SetWhite then
        --     --                     temp_button:SetWhite()
        --     --                 end
        --     --             end
        --     --             items_box.inst:PushEvent("items_page_switch", "special_items")
        --     --         end)
        --     --     --------------------------------------------------------------------------------
        --     --     ---- 普通物品按钮
        --     --         local button_normal_items = items_pages_button:AddChild(ImageButton(
        --     --             atlas,"button_normal_items_white.tex",
        --     --             "button_normal_items_white.tex",
        --     --             "button_normal_items_white.tex",
        --     --             "button_normal_items_white.tex",
        --     --             "button_normal_items_white.tex"))
        --     --         button_normal_items:SetPosition(290,0)
        --     --         button_normal_items.focus_scale = {1.02, 1.02, 1.02}
        --     --         local button_normal_items_icon = button_normal_items.image:AddChild(Image(atlas,"button_icon_normal_item.tex"))
        --     --         button_normal_items_icon:SetPosition(-140,30)
        --     --         table.insert(items_pages_button.buttons,button_normal_items)
        --     --         function button_normal_items:SetBlack()                 --- 变黑函数
        --     --             local image = "button_normal_items_black.tex"
        --     --             self:SetTextures(atlas,image,image,image,image,image)
        --     --         end
        --     --         function button_normal_items:SetWhite()                 --- 变白函数
        --     --             local image = "button_normal_items_white.tex"
        --     --             self:SetTextures(atlas,image,image,image,image,image)
        --     --         end
        --     --         button_normal_items:SetOnClick(function()
        --     --             for i, temp_button in ipairs(items_pages_button.buttons) do
        --     --                 if temp_button == button_normal_items then
        --     --                     button_normal_items:SetBlack()
        --     --                 elseif temp_button.SetWhite then
        --     --                     temp_button:SetWhite()
        --     --                 end
        --     --             end
        --     --             items_box.inst:PushEvent("items_page_switch", "normal_items")
        --     --         end)
        --     --     --------------------------------------------------------------------------------
        --     --     --- 默认显示第一页
        --     --         items_box.inst:DoTaskInTime(0,function()
        --     --             pcall(function()
        --     --                 local temp_button = items_pages_button.buttons[1]
        --     --                 temp_button:SetBlack()
        --     --                 temp_button.onclick()
        --     --             end)
        --     --         end)
        --     --     --------------------------------------------------------------------------------
        --     -- ------------------------------------------------------------------------------
        --     -- --- 
        --     -- ------------------------------------------------------------------------------
        --     -- --- 滚动条区域创建函数。得到区域位置，和所有slot
        --     --     local function create_scroll_box_and_get_slots(slots_num)
        --     --         --------------------------------------------------------------------------
        --     --         ---- 行数计算
        --     --             local lines_num = 10
        --     --             if slots_num then
        --     --                 --- 取8倍的整数，向上取整。
        --     --                 lines_num = math.ceil(slots_num/8)
        --     --             end
        --     --         --------------------------------------------------------------------------
        --     --         --- 单行操作
        --     --             local line_items_box = {}
        --     --             local num = 1
        --     --             local lines = {}
        --     --             local all_slots = {}
        --     --             local slot_width = 136
        --     --             local slot_height = 155
        --     --             local function create_line()
        --     --                 local line = Widget()
        --     --                 --- 8 个格子 。 第一个格子 -4.5*slot_width 。第八个 4.5*slot_width   
        --     --                 for i = 1, 8, 1 do
        --     --                     local temp_slot = line:AddChild(Image(atlas,"item_slot_bg.tex"))
        --     --                     temp_slot:SetPosition((i-4.5)*slot_width,0)
        --     --                     table.insert(all_slots,temp_slot)
        --     --                 end
        --     --                 local text = line:AddChild(Text(CODEFONT,35,"500",{ 0/255 , 0/255 ,0/255 , 1}))
        --     --                 text:SetString("第"..num.."行")
        --     --                 num = num + 1
        --     --                 return line
        --     --             end
        --     --         --------------------------------------------------------------------------
        --     --         --- 滚动条区域创建
        --     --             for i = 1, lines_num, 1 do
        --     --                 table.insert(line_items_box,create_line())
        --     --             end
        --     --             local listwidth = 800
        --     --             local listheight = 620
        --     --             local itemheight = 5
        --     --             local itempadding = 150
        --     --             local updatefn = function() end
        --     --             local widgetstoupdate = nil
        --     --             local scroll_bar_area = items_box:AddChild(ScrollableList(line_items_box,listwidth, listheight, itemheight, itempadding,updatefn,widgetstoupdate))
        --     --             scroll_bar_area:SetPosition(390,-60) -- 设置滚动区域位置
        --     --             scroll_bar_area.scroll_bar_container:SetPosition(-245,60)  --- 设置滚动条位置
        --     --             ---- 设置滚动条样式
        --     --             scroll_bar_area.up_button:SetTextures(atlas,"arrow_scrollbar_up.tex")
        --     --             scroll_bar_area.down_button:SetTextures(atlas,"arrow_scrollbar_down.tex")
        --     --             scroll_bar_area.scroll_bar_line:SetTexture(atlas,"scrollbarline.tex")
        --     --             scroll_bar_area.position_marker:SetTextures(atlas,"scrollbarbox.tex","scrollbarbox.tex","scrollbarbox.tex","scrollbarbox.tex","scrollbarbox.tex")
        --     --             scroll_bar_area.position_marker:OnGainFocus() --- 不知道为什么，贴图替换失败。只能用这种方式刷一下。
        --     --             scroll_bar_area.position_marker:OnLoseFocus()
        --     --         --------------------------------------------------------------------------
        --     --         --- 单个格子函数添加
        --     --             for k, single_slot in pairs(all_slots) do
        --     --                 function single_slot:SetBlue()
        --     --                     self:SetTexture(atlas,"item_slot_bg.tex")
        --     --                     self:SetTint(1,1,1,1)
        --     --                 end
        --     --                 function single_slot:SetGray()
        --     --                     self:SetTexture(atlas,"item_slot_bg_gray.tex")
        --     --                     self:SetTint(1,1,1,0.5)
        --     --                 end

        --     --                 --[[
        --     --                     商品数据。格式如下：
        --     --                     {
        --     --                         prefab = "log",
        --     --                         name = STRINGS.NAMES[string.upper(prefab_name)], --- 自动补全。也可强制下发。
        --     --                         bg = "item_slot_blue.tex", --- 背景颜色  item_slot_blue.tex  item_slot_colourful.tex  item_slot_golden.tex  item_slot_gray.tex
        --     --                         icon = {atlas,image}, --- 图标
        --     --                         right_click = false,    --- 用于上传
        --     --                         price = 100, --- 价格
        --     --                         price_type = "credit_coins"  -- 货币需求。
        --     --                         index = "log_credit_coins_100",  --- 自动合并上传，用于相应购买事件.
        --     --                     }

        --     --                 ]]--
        --     --                 function single_slot:SetData(_table)
        --     --                     self:SetBlue() -- 换背景。
        --     --                     local bg = _table.bg or "item_slot_gray.tex"                                --- 背景颜色
        --     --                     local prefab = _table.prefab or "log"                                       --- 物品的prefab
        --     --                     local name = _table.mouseover_text or STRINGS.NAMES[string.upper(prefab)]  --- 显示的名字
        --     --                     local price = _table.price or 0                         --- 显示的价格
        --     --                     local index = _table.index                              --- 购买index
        --     --                     local price_type = _table.price_type or "credit_coins"  --- 货币类型

        --     --                     self.index = index
        --     --                     self.prefab = prefab
        --     --                     self.inst.mouseover_text = name -- 给mouseover调用。
        --     --                     --- 添加图标背景
        --     --                         if self.bg == nil then
        --     --                             self.bg = self:AddChild(Image())
        --     --                             self.bg:SetPosition(0,25)
        --     --                             self.bg:SetScale(0.7,0.7)
        --     --                         end
        --     --                         self.bg:SetTexture(atlas,bg)
        --     --                         self.bg.inst.mouseover_text = name -- 给mouseover调用。
        --     --                     --- 物品图标
        --     --                         if self.icon == nil then
        --     --                             self.icon = self:AddChild(Image())
        --     --                             self.icon:SetPosition(0,25)
        --     --                         end
        --     --                         self.icon:SetTexture(_table.icon.atlas,_table.icon.image)
        --     --                         self.icon.inst.mouseover_text = name -- 给mouseover调用。
        --     --                     --- 物品价格(背景)
        --     --                         if self.price_bg == nil then
        --     --                             self.price_bg = self:AddChild(Image())
        --     --                             self.price_bg:SetPosition(0,-25)
        --     --                         end
        --     --                         if price_type == "credit_coins" then
        --     --                             self.price_bg:SetTexture(atlas,"price_slot.tex")
        --     --                         else
        --     --                             --- 预留给其他货币
        --     --                         end
        --     --                         self.price_bg.inst.mouseover_text = name -- 给mouseover调用。
        --     --                     --- 物品价格(文本)
        --     --                         if self.price_text == nil then
        --     --                             self.price_text = self:AddChild(Text(CODEFONT,30,"500",{ 255/255 , 255/255 ,255/255 , 1}))
        --     --                             self.price_text:SetPosition(10,-27)
        --     --                         end
        --     --                         self.price_text.inst.mouseover_text = name -- 给mouseover调用。
        --     --                         self.price_text:SetString(tostring(price))
        --     --                     --- 购买按钮。
        --     --                         if self.buy_btn == nil then
        --     --                             local buy_btn_image = "button_item_buy.tex"
        --     --                             self.buy_btn = self:AddChild(ImageButton(atlas,buy_btn_image,buy_btn_image,buy_btn_image,buy_btn_image))
        --     --                             self.buy_btn:SetPosition(20,-60)
        --     --                             self.buy_btn.focus_scale = {1.04,1.04,1.04}
        --     --                             local buy_btn_OnControl = self.buy_btn.OnControl
        --     --                             self.buy_btn.OnControl = function(btn_self,control,down)
        --     --                                 -- print("click",control)
        --     --                                 btn_self.control = control  --- 确保鼠标右键、左键都能点击。 右键 control = 1, 左键 control = 29
        --     --                                 if buy_btn_OnControl(btn_self,control,down) then
        --     --                                     if control == 1 and self.index then
        --     --                                         ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_event.shop_item_buy",{index = self.index,num = 10})
        --     --                                     elseif control == 29 and self.index then
        --     --                                         ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_event.shop_item_buy",{index = self.index,num = 1})
        --     --                                     end                                                    
        --     --                                     return true
        --     --                                 end
        --     --                                 return false
        --     --                             end
        --     --                         end
        --     --                         self.buy_btn.inst.mouseover_text = name -- 给mouseover调用。
        --     --                         self.buy_btn.image.inst.mouseover_text = name -- 给mouseover调用。

        --     --                 end
        --     --                 function single_slot:Clear()
        --     --                     pcall(function()
        --     --                         self.bg:Kill()
        --     --                         self.bg = nil
        --     --                         self.icon:Kill()
        --     --                         self.icon = nil
        --     --                         self.price_bg:Kill()
        --     --                         self.price_bg = nil
        --     --                         self.price:Kill()
        --     --                         self.price = nil
        --     --                         self.mouseover_text = nil
        --     --                         self.buy_btn:Kill()
        --     --                         self.buy_btn = nil

        --     --                         self.prefab = nil
        --     --                         self.index = nil
        --     --                         self.inst.mouseover_text = nil
        --     --                     end)
        --     --                     self:SetGray()
        --     --                 end

        --     --                 -- -- --- 测试数据
        --     --                 -- local test_data = {
        --     --                 --     prefab = "log",
        --     --                 --     -- name = STRINGS.NAMES[string.upper("log")],
        --     --                 --     bg = "item_slot_golden.tex",
        --     --                 --     icon = {atlas = GetInventoryItemAtlas("log.tex"),image = "log.tex"},
        --     --                 --     price = 100,
        --     --                 -- }
        --     --                 -- single_slot:SetData(test_data)


        --     --                 single_slot:SetGray()
        --     --             end
        --     --         --------------------------------------------------------------------------

        --     --         return scroll_bar_area,all_slots
        --     --     end
        --     -- ------------------------------------------------------------------------------
        --     -- --- 数据格式获取。
        --     -- ------------------------------------------------------------------------------
        --     -- --- 普通物品区域
        --     --     root.inst:ListenForEvent("create_normal_items_page",function()
        --     --         local normal_items = ThePlayer.HOSHINO_SHOP["normal_items"] or {}
        --     --         if #normal_items > 0 then
        --     --             if root.normal_items_page then
        --     --                 root.normal_items_page:Kill()
        --     --             end
        --     --             local normal_items_page,normal_item_slots = create_scroll_box_and_get_slots(#normal_items) -- 暂时默认300个格子
        --     --             root.normal_items_page = normal_items_page
        --     --             normal_items_page:Hide()
        --     --             normal_items_page.inst:ListenForEvent("items_page_switch",function(_,page)
        --     --                 if page == "normal_items" then
        --     --                     normal_items_page:Show()
        --     --                 else
        --     --                     normal_items_page:Hide()
        --     --                 end
        --     --             end,items_box.inst)
        --     --             --- 给格子设置数据
        --     --             for index, item_slot in pairs(normal_items) do
        --     --                 item_slot:SetData(normal_items[index])
        --     --             end
        --     --         end

        --     --     end)
        --     --     root.inst:ListenForEvent("hoshino_com_shop_client_side_data_updated_for_widget",function()
        --     --         --- 服务器下发新数据的时候刷新
        --     --         root.inst:PushEvent("create_normal_items_page")
        --     --     end,ThePlayer)
        --     --     root.inst:PushEvent("create_normal_items_page") -- 初始化普通物品页面
        --     -- ------------------------------------------------------------------------------
        --     -- --- 特殊物品区域                
        --     --     root.inst:ListenForEvent("create_special_items_page",function()
        --     --         local special_items = ThePlayer.HOSHINO_SHOP["special_items"] or {}
        --     --         if #special_items > 0 then
        --     --             if root.special_items_page then
        --     --                 root.special_items_page:Kill()
        --     --             end
        --     --             local special_items_page,special_item_slots = create_scroll_box_and_get_slots(#special_items) -- 暂时默认300个格子
        --     --             root.special_items_page = special_items_page
        --     --             special_items_page:Hide()
        --     --             special_items_page:ListenForEvent("items_page_switch",function(_,page)
        --     --                 if page == "special_items" then
        --     --                     special_items_page:Show()
        --     --                 else
        --     --                     special_items_page:Hide()
        --     --                 end
        --     --             end,items_box.inst)
        --     --             --- 给格子设置数据
        --     --             for index, item_slot in pairs(special_items) do
        --     --                 item_slot:SetData(special_items[index])
        --     --             end
        --     --         end
        --     --     end)
        --     --     root.inst:ListenForEvent("hoshino_com_shop_client_side_data_updated_for_widget",function()
        --     --         --- 服务器下发新数据的时候刷新
        --     --         root.inst:PushEvent("create_special_items_page")
        --     --     end,ThePlayer)
        --     --     root.inst:PushEvent("create_special_items_page") -- 初始化特殊物品页面
        --     -- ------------------------------------------------------------------------------
        --     -- ------------------------------------------------------------------------------
        --     -- --- 关闭事件
        --     --     local fast_close_keys = {
        --     --         [MOVE_UP] = true,
        --     --         [MOVE_DOWN] = true,
        --     --         [MOVE_LEFT] = true,
        --     --         [MOVE_RIGHT] = true,
        --     --         [KEY_ESCAPE] = true,
        --     --         [KEY_W] = true,
        --     --         [KEY_S] = true,
        --     --         [KEY_A] = true,
        --     --         [KEY_D] = true,
        --     --     }
        --     --     local key_handler = TheInput:AddKeyHandler(function(key,down)
        --     --         if down and fast_close_keys[key] then
        --     --             root.inst:PushEvent("container_widget_close")
        --     --         end
        --     --     end)
        --     --     root.inst:ListenForEvent("onremove",function()
        --     --         key_handler:Remove()
        --     --     end)
        --     --     root.inst:ListenForEvent("container_widget_close",function()
        --     --         inst.replica.container:Close()
        --     --     end)
        --     -- ------------------------------------------------------------------------------
        --     -- --- mouseover 显示
        --     --     --- 鼠标指示器
        --     --     local mouse_indicator = front_root:AddChild(Widget())
        --     --     mouse_indicator:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        --     --     mouse_indicator:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        --     --     local mouse_indicator_img = mouse_indicator:AddChild(Image())
        --     --     -- mouse_indicator_img:SetTexture("images/inspect_pad/page_character.xml","page_character_status.tex")
        --     --     -- mouse_indicator_img:SetScale(MainScale,MainScale,MainScale)
        --     --     mouse_indicator.img = mouse_indicator_img
        --     --     local mouse_indicator_txt = mouse_indicator:AddChild(Text(TALKINGFONT,50,"",{ 0/255 , 255/255 ,0/255 , 1})) --- 纯粹绿色
        --     --     -- local mouse_indicator_txt = mouse_indicator:AddChild(Text(TALKINGFONT,50,"",{ 255/255 , 255/255 ,255/255 , 1})) --- 白色
        --     --     -- local mouse_indicator_txt = mouse_indicator:AddChild(Text(TALKINGFONT,50,"",{ 51/255 , 255/255 ,255/255 , 1})) --- 天蓝色
        --     --     mouse_indicator.txt = mouse_indicator_txt

        --     --     local dx,dy = -40,40
        --     --     local last_mouse_over_inst = nil
        --     --     local OnUpdateFn = function()
        --     --         local current_mouse_over_inst = TheInput:GetHUDEntityUnderMouse()  -- 获取鼠标下的实体
        --     --         local pt = TheInput:GetScreenPosition()         -- 获取鼠标屏幕坐标
        --     --         mouse_indicator:SetPosition(pt.x + dx ,pt.y + dy ,0)
        --     --         if current_mouse_over_inst == nil then
        --     --             mouse_indicator:Hide()
        --     --             return
        --     --         end
        --     --         if current_mouse_over_inst.mouseover_text then
        --     --             mouse_indicator.txt:SetString(current_mouse_over_inst.mouseover_text)                        
        --     --             mouse_indicator:Show()
        --     --         else
        --     --             mouse_indicator:Hide()                            
        --     --         end

        --     --     end
        --     --     front_root.inst:DoPeriodicTask(FRAMES,OnUpdateFn)
        --     -- ------------------------------------------------------------------------------
        --     -- --- 界面打开的时候初始化。（点击【特殊资源】按钮）
        --     -- ------------------------------------------------------------------------------
        -- end
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- local inst = TheInput:GetHUDEntityUnderMouse()
        -- print(inst)
        -- ThePlayer:PushEvent("yawn", { grogginess = 4, knockoutduration = 10 })
        -- ThePlayer.AnimState:PlayAnimation("dozy")
        -- ThePlayer.AnimState:PlayAnimation("insomniac_dozy")
        -- ThePlayer.components.hoshino_com_shop:Spawn_Items_List_And_Send_2_Client(true)

        -- local item_list_from_world = TheWorld.components.hoshino_com_shop_items_pool:GetItemsList(true)
        -- for k, v in pairs(item_list_from_world) do
        --     print(k,v)
        -- end

        -- for k, v in pairs(ThePlayer.HOSHINO_SHOP) do
        --     print(k,v)
        -- end

        -- for k, v in pairs(TUNING.HOSHINO_SHOP_ITEMS_POOL) do
        --     print(k,v)
        -- end

        -- ThePlayer.components.hoshino_com_shop:Refresh_Delta(100)
        -- ThePlayer.components.hoshino_com_shop:RefreshDaily_Delta(100)
        -- ThePlayer.components.hoshino_com_shop:CreditCoinDelta(100)
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))