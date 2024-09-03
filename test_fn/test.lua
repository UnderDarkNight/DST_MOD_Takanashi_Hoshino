
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

        local item = SpawnPrefab("hoshino_item_cards_pack")
        item:PushEvent("Set",{
            cards = {
                "card_golden",
                "overdraft",
                "card_white",
            },
        })
        -- item:PushEvent("SetName","3-1")
        ThePlayer.components.inventory:GiveItem(item)

        -- local ret = ThePlayer.components.hoshino_cards_sys:GetCardsIndexByType("card_golden")
        -- print(ret)
        -- for k, v in pairs(ret) do
        --     print(k,v)
        -- end
        
        -- local ret = ThePlayer.components.hoshino_cards_sys:SelectRandomCardFromPoolByType("card_golden")
        -- print(ret)

        -- local function GetCardsDesc()
        --     -- local cards_data = ThePlayer.PAD_DATA and ThePlayer.PAD_DATA.cards
        --     local cards_data = ThePlayer.components.hoshino_cards_sys.cards_data
        --     if cards_data then
        --         for index, data in pairs(cards_data) do
        --             if type(data) == "table" then
        --                 -- return data.card_name
        --                 for k, v in pairs(data) do
        --                     print(k,v)
        --                 end
        --             end
        --         end
        --     end
        -- end
        -- print("GetCardsDesc",GetCardsDesc())
    ----------------------------------------------------------------------------------------------------------------
    --- 
        -- local inst = ThePlayer
        -- local debuff_prefab = "hoshino_card_debuff_force_night_sleep"
        -- while true do
        --     local debuff_inst = inst:GetDebuff(debuff_prefab)
        --     if debuff_inst and debuff_inst:IsValid() then
        --         break
        --     end
        --     inst:AddDebuff(debuff_prefab,debuff_prefab)
        -- end
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))