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
    TUNING.HOSHINO_INSPECT_PAD_BOX_FNS = TUNING.HOSHINO_INSPECT_PAD_BOX_FNS or {}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function GetCardTypeByName(card_name_index)
        if card_name_index == nil then
            return "card_white"
        end
        local all_data = TUNING.HOSHINO_CARDS_DATA_AND_FNS or {}
        if all_data[card_name_index] and all_data[card_name_index].back then
            return all_data[card_name_index].back
        end
        return "card_white"
    end
    local function Has_Black_Card()
        local cards_data = ThePlayer.PAD_DATA and ThePlayer.PAD_DATA.cards
        if cards_data then
            for k, temp_data in pairs(cards_data) do
                if temp_data.card_name == "card_black" then
                    return true
                end
            end
        end
        return false
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function page_create(front_root,MainScale)
        --------------------------------------------------------------------------------------
        --- 根节点
            local page = front_root:AddChild(Widget())
            page:SetScale(MainScale,MainScale,MainScale)
        --------------------------------------------------------------------------------------
        --- 卡牌选择区
            local card_select_box = page:AddChild(Image("images/inspect_pad/page_level_up.xml", "card_select_box.tex"))
            card_select_box:SetPosition(-270,50)
        --------------------------------------------------------------------------------------
        --- info button
            local button_recycle = card_select_box:AddChild(ImageButton(
                "images/inspect_pad/page_level_up.xml",
                "button_info.tex",
                "button_info.tex",
                "button_info.tex",
                "button_info.tex",
                "button_info.tex"
            ))
            button_recycle:SetPosition(-360,240)
            button_recycle:SetOnClick(function()
                -- print("info button")
            end)
            -- button_recycle.focus_scale = button_recycle.normal_scale
            local button_info_text = button_recycle:AddChild(Text(CODEFONT,50,"回收",{ 126/255 , 133/255 ,143/255 , 1}))
            button_info_text:SetPosition(80,-20)
        --------------------------------------------------------------------------------------
        --- 刷新按钮
            local button_refresh = card_select_box:AddChild(ImageButton(
                "images/inspect_pad/page_level_up.xml",
                "button_refresh.tex",
                "button_refresh.tex",
                "button_refresh.tex",
                "button_refresh.tex",
                "button_refresh.tex"
            ))
            button_refresh:SetPosition(260,248)
            button_refresh:SetOnClick(function()
                -- print("button_refresh")
                if not button_refresh.temp_disable then
                    ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_event.card_refresh_button_clicked")
                    button_refresh.temp_disable = true
                end
                button_refresh.inst:DoTaskInTime(1,function()
                    button_refresh.temp_disable = false
                end)
            end)
            button_refresh.focus_scale = {1.02,1.02,1.02}

        --------------------------------------------------------------------------------------
        --- 刷新次数
            local refresh_num_text = card_select_box:AddChild(Text(CODEFONT,40,"500",{ 126/255 , 133/255 ,143/255 , 1}))
            refresh_num_text:SetPosition(320,245)
            page.inst:ListenForEvent("refresh_num_update",function(inst)
                refresh_num_text:SetString(tostring(ThePlayer.PAD_DATA and ThePlayer.PAD_DATA.refresh_num or ThePlayer.replica.hoshino_cards_sys:Get_refresh_num()))
            end)
            page.inst:PushEvent("refresh_num_update")
        --------------------------------------------------------------------------------------
        --- 卡牌描述文本
            local card_desc_text = card_select_box:AddChild(Text(CODEFONT,50,"500",{ 0/255 , 0/255 ,0/255 , 1}))
            card_desc_text:SetPosition(0,-160)
            card_desc_text:SetString("     ")
            function card_select_box:SetDescByCardName(card_name,ignore_black)
                -- card_desc_text:SetString("测试卡牌描述")
                -- card_desc_text:SetColour({ 0/255 , 0/255 ,0/255 , 1})
                -- card_desc_text:SetPosition(0,-160)
                -- card_desc_text:SetSize(50)
                -- print("卡牌描述加载",card_name)
                if card_name == nil then
                    card_desc_text:SetString("未找到卡牌描述")
                end
                local all_cards_data = TUNING.HOSHINO_CARDS_DATA_AND_FNS or {}
                local ret_card_data = all_cards_data[card_name]
                if ret_card_data and ret_card_data.text then
                    card_desc_text:SetString(ret_card_data.text(ThePlayer))
                else
                    card_desc_text:SetString("未找到卡牌描述")
                end
                if Has_Black_Card() and not ignore_black then
                    card_desc_text:SetString("这可能是诅咒卡牌，请谨慎选择")
                end
                card_desc_text:MoveToFront()
            end
            page.card_select_box = card_select_box
        --------------------------------------------------------------------------------------
        --- 卡牌区。1-5张牌。数据从 ThePlayer.PAD_DATA.cards 获取。靠index返回。做决定，避免有MOD搞事。
            --[[                
                数据结构: 只有4种卡牌: card_black , card_colourful , card_golden , card_white
                {
                    [1] = {atlas,image,card_name},
                    [2] = {atlas,image,card_name},
                    [3] = {atlas,image,card_name},
                    [4] = {atlas,image,card_name},
                    [5] = {atlas,image,card_name}, -- 卡牌正面
                }
            ]]--

            local function CreateCardsByData()            
                local cards_data = ThePlayer.PAD_DATA and ThePlayer.PAD_DATA.cards
                if type(cards_data) == "table" then
                        -----------------------------------------------------
                        --- 按钮盒子
                            if card_select_box.cards_button_box then
                                card_select_box.cards_button_box:Kill()
                            end
                            local cards_button_box = card_select_box:AddChild(Widget())
                            card_select_box.cards_button_box = cards_button_box
                        -----------------------------------------------------

                        local current_cards = {}
                        local function CreateCard(x,y,index,atlas,image) --- 卡牌创建
                            local temp_card = cards_button_box:AddChild(ImageButton())
                            temp_card:SetTextures(atlas,image,image,image,image,image)
                            temp_card:SetPosition(x,y)
                            temp_card:SetOnClick(function()
                                --- 通过RPC上传
                                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_event.card_click",index)
                                --- 屏蔽卡牌选择。
                                for k, v in pairs(current_cards) do
                                    v:Disable()
                                    if v ~= temp_card then
                                        v:Hide() -- 隐藏所有卡牌，等待服务器回传再显示
                                    end
                                end
                                ThePlayer.PAD_DATA.cards_selectting = false
                                ThePlayer.PAD_DATA.cards = nil
                                ThePlayer.PAD_DATA.button_level_up_red_dot = nil
                            end)
                            return temp_card
                        end


                        ------ 计算卡牌位置
                            local function Get_Card_Points(temp_card_num)
                                local full_start_x = -320
                                local full_end_x = 320
                                local full_mid_x = (full_start_x + full_end_x) / 2
                                local full_width = math.abs(full_end_x - full_start_x)
                                local card_y = 30
                            
                                local card_num = temp_card_num or 1
                                card_num = math.clamp(card_num, 1, 5)
                            
                                if card_num == 1 then
                                    return {Vector3((full_start_x + full_end_x) / 2, card_y, 0)}
                                end
                            
                                if card_num == 2 then
                                    local temp_length = full_width / 5
                                    local ret_table = {}
                                    table.insert(ret_table, Vector3(full_mid_x - temp_length, card_y, 0))
                                    table.insert(ret_table, Vector3(full_mid_x + temp_length, card_y, 0))
                                    return ret_table
                                end
                            
                                if card_num == 3 then
                                    local delta_x = full_width / 4
                                    local ret_table = {}
                                    table.insert(ret_table, Vector3(full_mid_x - delta_x, card_y, 0))
                                    table.insert(ret_table, Vector3(full_mid_x, card_y, 0))
                                    table.insert(ret_table, Vector3(full_mid_x + delta_x, card_y, 0))
                                    return ret_table
                                end
                            
                                if card_num == 4 then
                                    local delta_x = full_width / 3.5
                                    local ret_table = {}
                                    table.insert(ret_table, Vector3(full_mid_x - 1.5 * delta_x, card_y, 0))
                                    table.insert(ret_table, Vector3(full_mid_x - 0.5 * delta_x, card_y, 0))
                                    table.insert(ret_table, Vector3(full_mid_x + 0.5 * delta_x, card_y, 0))
                                    table.insert(ret_table, Vector3(full_mid_x + 1.5 * delta_x, card_y, 0))
                                    return ret_table
                                end
                            
                                if card_num == 5 then
                                    local delta_x = full_width / 4
                                    local ret_table = {}
                                    for i = 1, 5, 1 do
                                        table.insert(ret_table, Vector3(full_start_x + (i - 1) * delta_x, card_y, 0))
                                    end
                                    return ret_table
                                end
                            
                                return {}
                            end
                        
                        local card_num = #cards_data
                        local ret_points = Get_Card_Points(card_num)
                        local card_clickable_flag = true
                        for i, pt in pairs(ret_points) do
                            --- 如果数据结构是卡牌背面index
                            current_cards[i] = CreateCard(pt.x,pt.y,i,cards_data[i].atlas,cards_data[i].image)
                            current_cards[i]:SetOnGainFocus(function()
                                if current_cards[i]:IsEnabled() then
                                    card_select_box:SetDescByCardName(cards_data[i].card_name)
                                end
                            end)
                            current_cards[i].card_name = cards_data[i].card_name
                        end
                        ---- 如果已经选择过了，则不再允许点击
                        if not ThePlayer.PAD_DATA.cards_selectting then
                            for k, v in pairs(current_cards) do
                                v:Disable()
                            end                            
                        end
                        ---- 服务器返回下发的数据，然后更新卡牌正面。
                        cards_button_box.inst:ListenForEvent("hoshino_event.card_display",function(_,_table)
                            local card_index = _table.index
                            local atlas = _table.atlas
                            local image = _table.image
                            local card_name = _table.card_name
                            -- print("hoshino_event.card_display",card_name)
                            current_cards[card_index]:SetTextures(atlas,image,image,image,image,image)
                            card_select_box:SetDescByCardName(card_name) -- 设置描述文本                            
                        end,ThePlayer)
                        return current_cards
                end
            end
            CreateCardsByData()
        --------------------------------------------------------------------------------------
        --- 刷新按钮事件服务器下发来的时候执行
            card_select_box.inst:ListenForEvent("hoshino_event.pad_data_update_by_refresh",function()
                local current_cards = CreateCardsByData()
                if current_cards then
                    for index, card in pairs(current_cards) do
                        local refresh_fx = card:AddChild(UIAnim())
                        local card_type = GetCardTypeByName(card.card_name)
                        if card_type  == "card_white" then
                            refresh_fx:GetAnimState():SetBank("halloween_embers_cold")
                            refresh_fx:GetAnimState():SetBuild("halloween_embers_cold")
                        elseif card_type == "card_golden" then
                            refresh_fx:GetAnimState():SetBank("halloween_embers")
                            refresh_fx:GetAnimState():SetBuild("halloween_embers")
                        elseif card_type == "card_colourful" then
                            refresh_fx:GetAnimState():SetBank("halloween_embers")
                            refresh_fx:GetAnimState():SetBuild("hoshino_fx_flame_purple")
                        elseif card_type == "card_black" then
                            refresh_fx:GetAnimState():SetBank("halloween_embers")
                            refresh_fx:GetAnimState():SetBuild("hoshino_fx_flame_black")
                        else
                            refresh_fx:GetAnimState():SetBank("halloween_embers")
                            refresh_fx:GetAnimState():SetBuild("halloween_embers")
                        end
                        refresh_fx:GetAnimState():PlayAnimation("puff_"..math.random(3))
                        refresh_fx:GetAnimState():SetBloomEffectHandle("shaders/anim.ksh")
                        
                        refresh_fx:SetScale(0.6,0.6,0.6)
                        refresh_fx:SetPosition(0,-100,0)
                    end
                    local sound_inst = CreateEntity()
                    sound_inst.entity:AddSoundEmitter()
                    sound_inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
                    sound_inst:DoTaskInTime(5,function()
                        sound_inst:Remove()
                    end)
                end
                local refresh_num = ThePlayer.PAD_DATA and ThePlayer.PAD_DATA.refresh_num or ThePlayer.replica.hoshino_cards_sys:Get_refresh_num()
                refresh_num_text:SetString(tostring(refresh_num))
                card_desc_text:SetString("     ")
            end,ThePlayer)
        --------------------------------------------------------------------------------------
        --- 当前状态区
            local current_phrase = page:AddChild(Image("images/inspect_pad/page_level_up.xml", "current_phrase.tex"))
            current_phrase:SetPosition(450,50-3)
        --------------------------------------------------------------------------------------
        ---  回收按钮
            button_recycle:SetOnClick(function()
                local PAD_DATA = ThePlayer.PAD_DATA or {}
                if card_select_box.cards_button_box and not Has_Black_Card() and PAD_DATA.cards_selectting then
                    PAD_DATA.cards_selectting = false
                    PAD_DATA.cards = nil                    -- 清除卡牌数据
                    PAD_DATA.button_level_up_red_dot = nil  -- 清除红点
                    card_desc_text:SetString("     ")       -- 清除描述文本
                    PAD_DATA.refresh_num = ( PAD_DATA.refresh_num or 0 )+ 1 -- 刷新次数加一
                    page.inst:PushEvent("refresh_num_update")   -- 刷新次数显示更新
                    ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_event.card_recycle_button_clicked")
                    card_select_box.cards_button_box:Kill() -- 清除卡牌选择按钮
                    card_select_box.cards_button_box = nil

                    ---- 服务器可能会下发来数据，做刷新处理
                    for i = 1, 60, 1 do
                        page.inst:DoTaskInTime(0.2*i,function()
                            page.inst:PushEvent("refresh_num_update")   -- 刷新次数显示更新
                        end)
                    end
                elseif card_select_box.cards_button_box and Has_Black_Card() then
                    card_desc_text:SetString("诅咒卡存在，不允许回收")
                end
            end)
        --------------------------------------------------------------------------------------
        --- hoshino_event.pad_data_update
            local debuff_icon_box = TUNING.HOSHINO_INSPECT_PAD_BOX_FNS:Create_Buff_Icon_Box(page)
            page.inst:ListenForEvent("refresh_buff_icon",function()
                debuff_icon_box:Kill()
                debuff_icon_box = TUNING.HOSHINO_INSPECT_PAD_BOX_FNS:Create_Buff_Icon_Box(page)
            end)
            page.inst:ListenForEvent("hoshino_event.pad_data_update",function()
                page.inst:PushEvent("refresh_buff_icon")
            end,ThePlayer)
        --------------------------------------------------------------------------------------
        ---
            return page
        --------------------------------------------------------------------------------------

end
TUNING.HOSHINO_INSPECT_PAD_FNS["level_up"] = page_create
