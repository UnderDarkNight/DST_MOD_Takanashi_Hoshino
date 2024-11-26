
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
    -- local EmoteButton = require "widgets/hoshino_emote_button"
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
        --             "card_golden",
        --             -- "kill_and_explode",
        --         },
        --     }
        -- )
        -- ThePlayer.components.inventory:GiveItem(item)
    ----------------------------------------------------------------------------------------------------------------
    --- 卡牌调试-变种
        -- local item = SpawnPrefab("hoshino_item_cards_pack")
        -- item:PushEvent("Type","hoshino_item_cards_pack_authority_to_unveil_secrets")

        -- -- item:PushEvent("SetName","窥秘权柄") -- 金色
        -- -- item:PushEvent("Set",{
        -- --         cards = {
        -- --             "card_golden",
        -- --             "card_golden",
        -- --             "card_golden",
        -- --         },
        -- --     }
        -- -- )
        -- -- item:PushEvent("SetDisplay",{
        -- --     bank = "hoshino_item_cards_pack_authority_to_unveil_secrets",
        -- --     build = "hoshino_item_cards_pack_authority_to_unveil_secrets",
        -- --     anim = "idle",
        -- --     imagename = "hoshino_item_cards_pack_authority_to_unveil_secrets",
        -- --     atlasname = "images/inventoryimages/hoshino_item_cards_pack_authority_to_unveil_secrets.xml",
        -- -- })
        -- ThePlayer.components.inventory:GiveItem(item)

        -- local item = SpawnPrefab("hoshino_item_cards_pack")
        -- item:PushEvent("Type","hoshino_item_cards_pack_supreme_mystery")

        -- -- item:PushEvent("SetName","最高神秘") -- 彩色
        -- -- item:PushEvent("Set",{
        -- --         cards = {
        -- --             "card_colourful",
        -- --             "card_colourful",
        -- --             "card_colourful",
        -- --         },
        -- --     }
        -- -- )
        -- -- item:PushEvent("SetDisplay",{
        -- --     bank = "hoshino_item_cards_pack_supreme_mystery",
        -- --     build = "hoshino_item_cards_pack_supreme_mystery",
        -- --     anim = "idle",
        -- --     imagename = "hoshino_item_cards_pack_supreme_mystery",
        -- --     atlasname = "images/inventoryimages/hoshino_item_cards_pack_supreme_mystery.xml",
        -- -- })
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
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- ThePlayer.components.hoshino_com_shop:BlueSchistDelta(123)
        -- ThePlayer.components.hoshino_com_shop:CreditCoinDelta(222)
        -- ThePlayer.components.hoshino_com_task_sys_for_player:GiveTask("hoshino_task_excample_kill")
        -- ThePlayer.components.hoshino_com_task_sys_for_player:GiveTask("hoshino_task_excample_item")
        -- print("+++++++++",inst)
        -- print(inst:GetDebugString())

        -- local container = ThePlayer.components.hoshino_com_task_sys_for_player:GetContainer()
        -- local items = container:GetAllItems()
        -- for i = 1, 5, 1 do
        --     print("+++++++++",items[i])
        -- end


        -- local task_backpack = ThePlayer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_TASK_BACKPACK)
        -- local items = task_backpack.replica.container:GetItems()
        -- for i = 1, 5, 1 do
        --     print("+++++++++",items[i])
        -- end
    ----------------------------------------------------------------------------------------------------------------
    --- 调试任务栏
        -- ThePlayer.___task_board_widget_fn = function(inst,front_root)
            
        -- end
        -- ThePlayer.components.hoshino_com_task_sys_for_player:Refresh_DoDelta(10)

        -- print(TheWorld.Map:GetTileAtPoint(x,y,z))

        -- local box = TheSim:FindFirstEntityWithTag("hoshino_building_task_board")
        -- box.components.container:GiveItem(SpawnPrefab("hoshino_mission_white_12"))
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_colourful_12")
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_golden_27")
        -- box.components.hoshino_com_task_sys_for_building:Refresh_All()
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_white_11")

        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_blue_02",2)
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_blue_02",3)
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_blue_02",4)
        -- box.components.hoshino_com_task_sys_for_building:Debug_Set_Mission("hoshino_mission_blue_02",5)

        -- TUNING.HOSHINO_FNS:Client_PlaySound("dontstarve/common/together/celestial_orb/active")
        -- local inst = CreateEntity()
        -- inst.entity:AddSoundEmitter()        
        -- ThePlayer.components.hoshino_com_shop:CreditCoinDelta(-10000)

        -- ThePlayer.components.hoshino_com_power_cost:DoDelta(100)

        -- print("66",ThePlayer.components.hoshino_com_task_sys_for_player:HasTask("hoshino_mission_golden_29"))

        -- print(ThePlayer.components.hoshino_data:Add("travel_traces_spanwer_golden",0,0,1000))
    ----------------------------------------------------------------------------------------------------------------
    --- 
        -- if ThePlayer.__old_AddDebuff == nil then
        --     ThePlayer.__old_AddDebuff = ThePlayer.AddDebuff
        --     ThePlayer.AddDebuff = function(inst,debuff_name,debuff_prefab,...)
        --         print("AddDebuff",debuff_name,debuff_prefab,...)
        --         return inst:__old_AddDebuff(debuff_name,debuff_prefab,...)
        --     end
        -- end
        
    ----------------------------------------------------------------------------------------------------------------
    --- 精神控制
        -- local inst = ThePlayer
        -- for i = 1, 15, 1 do
        --     inst:DoTaskInTime(0.5*i, function()
        --         inst:AddDebuff("mindcontroller", "mindcontroller")
        --     end)
        -- end
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- ThePlayer:AddDebuff("hoshino_equipment_spider_core_debuff", "hoshino_equipment_spider_core_debuff")

    ----------------------------------------------------------------------------------------------------------------
    ----
        -- TheWorld:PushEvent("ms_setclocksegs", {day = 0, dusk = 0, night = 16})
        -- TheWorld:PushEvent("ms_setmoonphase", {moonphase = "new", iswaxing = true})

        -- TheWorld:PushEvent("ms_setclocksegs", {day = 0, dusk = 0, night = 16})
        -- TheWorld:PushEvent("ms_setmoonphase", {moonphase = "full", iswaxing = false})
    ----------------------------------------------------------------------------------------------------------------
    ---- 拉面店调试
        local inst = TheSim:FindFirstEntityWithTag("hoshino_building_shiba_seki_ramen_cart")
        -- -------------------------------------------------------------------------------
        -- ---
        --     local item_left = SpawnPrefab("bonestew")
        --     item_left.entity:SetParent(inst.entity)
        --     if item_left.components.perishable ~= nil then
        --         item_left.components.perishable:StopPerishing()
        --     end    
        --     item_left:AddTag("NOCLICK")
        --     item_left:ReturnToScene()
        --     if item_left.Follower == nil then
        --         item_left.entity:AddFollower()
        --     end
        --     item_left.Follower:FollowSymbol(inst.GUID, "LEFT", 0, 0, 0, true)
        -- -------------------------------------------------------------------------------
        -- ---
        --     local item_mid = SpawnPrefab("ceviche_spice_garlic")
        --     item_mid.entity:SetParent(inst.entity)
        --     if item_mid.components.perishable ~= nil then
        --         item_mid.components.perishable:StopPerishing()
        --     end
        --     item_mid:AddTag("NOCLICK")
        --     item_mid:ReturnToScene()
        --     if item_mid.Follower == nil then
        --         item_mid.entity:AddFollower()
        --     end
        --     item_mid.Follower:FollowSymbol(inst.GUID, "MID", 0, 0, 0, true)
        -- -------------------------------------------------------------------------------
        -- --- 
        --     local item_right = SpawnPrefab("seafoodgumbo_spice_chili")
        --     item_right.entity:SetParent(inst.entity)
        --     if item_right.components.perishable ~= nil then
        --         item_right.components.perishable:StopPerishing()
        --     end
        --     item_right:AddTag("NOCLICK")
        --     item_right:ReturnToScene()
        --     if item_right.Follower == nil then
        --         item_right.entity:AddFollower()
        --     end
        --     item_right.Follower:FollowSymbol(inst.GUID, "RIGHT", 0, 0, 0, true)
        -- -------------------------------------------------------------------------------
        -- inst:SetItem(SpawnPrefab("bonestew"),"left")
        -- inst:SetItem(SpawnPrefab("hotchili"),"mid",true)
        -- inst:SetItem(SpawnPrefab("shroomcake"),"right",true)
    ----------------------------------------------------------------------------------------------------------------
    ---
        local slots = {["left"] = true,["mid"] = true,["right"] = true,}            
        ThePlayer.__install_buttons_fn = function(inst)

            if inst.hud_button_widget then
                inst.hud_button_widget:Kill()
            end
            
            -----------------------------------------------------
            --- 前置根节点
                local front_root = TheInput and ThePlayer and ThePlayer.HUD
                if front_root == nil then
                    return
                end
            -----------------------------------------------------
            --- 根节点
                local root = front_root:AddChild(Widget())
                root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
                root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
                root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
                local MainScale = 0.6
            -----------------------------------------------------
            --- 绑定inst
                inst.hud_button_widget = root
                root.inst:ListenForEvent("onremove",function()
                    root:Kill()
                end,inst)                
            -----------------------------------------------------
            --- 绑定更新点
                TheInput:Hoshino_Add_Update_Modify_Fn(root.inst,function()
                    if ThePlayer:GetDistanceSqToInst(inst) < 25 then
                        local s_pt_x,s_pt_y= TheSim:GetScreenPos(inst.Transform:GetWorldPosition()) -- 左下角为原点。
                        -- print("player in screen",s_pt_x,s_pt_y)
                        root:SetPosition(s_pt_x,s_pt_y,0)
                        root:Show()
                    else
                        root:Hide()
                    end
                end)
            -----------------------------------------------------
            --- 按钮节点
                local button_widget = root:AddChild(Widget())
                button_widget:SetScale(MainScale,MainScale,MainScale)
                button_widget:SetPosition(0,0,0)                
            -----------------------------------------------------
            ---
                local bubbles = {}
                local bubble_scale = 1.5

                bubbles["left"] = button_widget:AddChild(AnimButton("hoshino_building_shiba_seki_ramen_cart",{
                    idle = "bubble", -- 按钮默认状态
                    over = "bubble", -- 按钮悬停状态
                    disabled = "bubble", -- 按钮禁用状态
                }))
                bubbles["left"]:SetPosition(-200,360,0)
                bubbles["left"]:SetOnClick(function()
                    ThePlayer.replica.hoshino_com_rpc_event:PushEvent("item_buy",{
                        slot = "left",
                        userid = ThePlayer.userid
                    },inst)
                end)
                bubbles["left"]:SetScale(bubble_scale,bubble_scale,bubble_scale)
                bubbles["left"].name_text = bubbles["left"]:AddChild(Text(CODEFONT,30,"肉汤",{ 0/255 , 0/255 ,0/255 , 1}))
                bubbles["left"].name_text:SetString("肉汤")
                bubbles["left"].name_text:SetPosition(0,10,0)
                bubbles["left"].icon = bubbles["left"]:AddChild(UIAnim())
                bubbles["left"].icon:GetAnimState():SetBank("hoshino_building_shiba_seki_ramen_cart")
                bubbles["left"].icon:GetAnimState():SetBuild("hoshino_building_shiba_seki_ramen_cart")
                bubbles["left"].icon:GetAnimState():PlayAnimation("credit_coins")
                bubbles["left"].icon:SetScale(0.2,0.2,0.2)
                bubbles["left"].icon:SetPosition(-30,-12,0)
                bubbles["left"].price_text = bubbles["left"]:AddChild(Text(CODEFONT,20,"50",{ 0/255 , 0/255 ,0/255 , 1}))
                bubbles["left"].price_text:SetString("50")
                bubbles["left"].price_text:SetPosition(10,-12,0)
                bubbles["left"].on_sale = bubbles["left"]:AddChild(UIAnim())
                bubbles["left"].on_sale:GetAnimState():SetBank("hoshino_building_shiba_seki_ramen_cart")
                bubbles["left"].on_sale:GetAnimState():SetBuild("hoshino_building_shiba_seki_ramen_cart")
                bubbles["left"].on_sale:GetAnimState():PlayAnimation("sale2")
                bubbles["left"].on_sale:SetPosition(0,-35,0)
                bubbles["left"].on_sale:SetScale(1,1,1)


                
                bubbles["mid"] = button_widget:AddChild(AnimButton("hoshino_building_shiba_seki_ramen_cart",{
                    idle = "bubble", -- 按钮默认状态
                    over = "bubble", -- 按钮悬停状态
                    disabled = "bubble", -- 按钮禁用状态
                }))
                bubbles["mid"]:SetPosition(0,430,0)
                bubbles["mid"]:SetOnClick(function()
                    ThePlayer.replica.hoshino_com_rpc_event:PushEvent("item_buy",{
                        slot = "mid",
                        userid = ThePlayer.userid
                    },inst)
                end)
                bubbles["mid"]:SetScale(bubble_scale,bubble_scale,bubble_scale)
                bubbles["mid"].name_text = bubbles["mid"]:AddChild(Text(CODEFONT,30,"拉面",{ 0/255 , 0/255 ,0/255 , 1}))
                bubbles["mid"].name_text:SetPosition(0,10,0)
                bubbles["mid"].icon = bubbles["mid"]:AddChild(UIAnim())
                bubbles["mid"].icon:GetAnimState():SetBank("hoshino_building_shiba_seki_ramen_cart")
                bubbles["mid"].icon:GetAnimState():SetBuild("hoshino_building_shiba_seki_ramen_cart")
                bubbles["mid"].icon:GetAnimState():PlayAnimation("credit_coins")
                bubbles["mid"].icon:SetPosition(-30,-12,0)
                bubbles["mid"].icon:SetScale(0.2,0.2,0.2)
                bubbles["mid"].price_text = bubbles["mid"]:AddChild(Text(CODEFONT,20,"50",{ 0/255 , 0/255 ,0/255 , 1}))
                bubbles["mid"].price_text:SetPosition(10,-12,0)
                bubbles["mid"].price_text:SetString("50")
                bubbles["mid"].on_sale = bubbles["mid"]:AddChild(UIAnim())
                bubbles["mid"].on_sale:GetAnimState():SetBank("hoshino_building_shiba_seki_ramen_cart")
                bubbles["mid"].on_sale:GetAnimState():SetBuild("hoshino_building_shiba_seki_ramen_cart")
                bubbles["mid"].on_sale:GetAnimState():PlayAnimation("sale2")
                bubbles["mid"].on_sale:SetPosition(0,-35,0)
                bubbles["mid"].on_sale:SetScale(1,1,1)



                bubbles["right"] = button_widget:AddChild(AnimButton("hoshino_building_shiba_seki_ramen_cart",{
                    idle = "bubble", -- 按钮默认状态
                    over = "bubble", -- 按钮悬停状态
                    disabled = "bubble", -- 按钮禁用状态
                }))
                bubbles["right"]:SetPosition(200,360,0)
                bubbles["right"]:SetOnClick(function()
                    ThePlayer.replica.hoshino_com_rpc_event:PushEvent("item_buy",{
                        slot = "right",
                        userid = ThePlayer.userid
                    },inst)
                end)
                bubbles["right"]:SetScale(bubble_scale,bubble_scale,bubble_scale)
                bubbles["right"].name_text = bubbles["right"]:AddChild(Text(CODEFONT,30,"排骨拉面",{ 0/255 , 0/255 ,0/255 , 1}))
                bubbles["right"].name_text:SetPosition(0,10,0)
                bubbles["right"].icon = bubbles["right"]:AddChild(UIAnim())
                bubbles["right"].icon:GetAnimState():SetBank("hoshino_building_shiba_seki_ramen_cart")
                bubbles["right"].icon:GetAnimState():SetBuild("hoshino_building_shiba_seki_ramen_cart")
                bubbles["right"].icon:GetAnimState():PlayAnimation("credit_coins")
                bubbles["right"].icon:SetPosition(-30,-12,0)
                bubbles["right"].icon:SetScale(0.2,0.2,0.2)
                bubbles["right"].price_text = bubbles["right"]:AddChild(Text(CODEFONT,20,"50",{ 0/255 , 0/255 ,0/255 , 1}))
                bubbles["right"].price_text:SetPosition(10,-12,0)
                bubbles["right"].price_text:SetString("50")
                bubbles["right"].on_sale = bubbles["right"]:AddChild(UIAnim())
                bubbles["right"].on_sale:GetAnimState():SetBank("hoshino_building_shiba_seki_ramen_cart")
                bubbles["right"].on_sale:GetAnimState():SetBuild("hoshino_building_shiba_seki_ramen_cart")
                bubbles["right"].on_sale:GetAnimState():PlayAnimation("sale2")
                bubbles["right"].on_sale:SetPosition(0,-35,0)
                bubbles["right"].on_sale:SetScale(1,1,1)


            -----------------------------------------------------
            ---
                print(inst.hud_button_widget.inst)                
            -----------------------------------------------------
            --- 物品刷新
                local items = {}
                for slot, _ in pairs(slots) do
                    local temp = inst["__item_"..slot]:value()
                    items[slot] = temp
                end
                for slot, tempItem in pairs(items) do
                    if tempItem and tempItem:IsValid() then
                        bubbles[slot]:Show()
                        bubbles[slot].name_text:SetString(tempItem:GetDisplayName())
                        bubbles[slot].price_text:SetString(tostring(100))
                        if tempItem:HasTag("on_sale") then
                            bubbles[slot].on_sale:Show()
                        else
                            bubbles[slot].on_sale:Hide()
                        end
                    else
                        bubbles[slot]:Hide()
                    end
                end
            -----------------------------------------------------        
        
        end


        inst:SetItem(SpawnPrefab("bonestew"),"left",true)
        inst:SetItem(SpawnPrefab("hotchili"),"mid",true)
        inst:SetItem(SpawnPrefab("shroomcake"),"right",true)
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))