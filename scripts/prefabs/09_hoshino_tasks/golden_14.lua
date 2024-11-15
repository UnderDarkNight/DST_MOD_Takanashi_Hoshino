---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    任务物品

]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- UI常用组件
    local Widget = require "widgets/widget"
    local Image = require "widgets/image"
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材
    local assets =
    {
        Asset("IMAGE", "images/hoshino_mission/golden_mission.tex"),
        Asset("ATLAS", "images/hoshino_mission/golden_mission.xml"),
    }
    local button_atlas = "images/inspect_pad/page_main.xml"     --- 按钮图集
    local button_give_up_img = "button_give_up.tex"             --- 放弃按钮
    local button_delivery_img = "button_delivery.tex"           --- 交付按钮

    local button_give_up_location = Vector3(290,40,0)          --- 放弃按钮位置
    local button_delivery_location = Vector3(270,-20,0)         --- 交付按钮位置
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 专属参数
    local MISSION_TYPE = "golden" -- "gray" "golden" "blue" "colourful" --- 给任务栏用的
    
    local MISSION_ITEM_1 = "sharkboi"
    local MISSION_ITEM_1_NUM = 1
    local MISSION_ITEM_2 = "bearger"
    local MISSION_ITEM_2_NUM = 1
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- net install
    local function Net_Vars_Install(inst)

        inst.__sharkboi_num = net_uint(inst.GUID, "hoshino_mission_golden_14.sharkboi","hoshino_mission_golden_14")
        inst.__bearger_num = net_uint(inst.GUID, "hoshino_mission_golden_14.bearger","hoshino_mission_golden_14")
        inst:ListenForEvent("hoshino_mission_golden_14",function()
            inst.sharkboi_num = inst.__sharkboi_num:value()
            inst.bearger_num = inst.__bearger_num:value()
        end)

        if not TheWorld.ismastersim then
            return
        end
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 用于平板显示的API，返回Widget图像。client端调用
    local function CreateGiveUpButton(root,x,y,fn)
        local button_give_up = root:AddChild(ImageButton(button_atlas,button_give_up_img,button_give_up_img,
        button_give_up_img,button_give_up_img,button_give_up_img))
        button_give_up:SetPosition(x,y)
        button_give_up.focus_scale = {1.1, 1.1, 1.1}
        button_give_up:SetScale(0.5,0.5,0.5)
        button_give_up:SetOnClick(fn)
        return button_give_up
    end
    local function CreateDeliveryButton(root,x,y,fn)
        local button_delivery = root:AddChild(ImageButton(button_atlas,button_delivery_img,button_delivery_img,
        button_delivery_img,button_delivery_img,button_delivery_img))
        button_delivery:SetScale(0.9,0.9,0.9)
        button_delivery:SetPosition(x,y)
        button_delivery.focus_scale = {1.1, 1.1, 1.1}
        button_delivery:SetOnClick(fn)
        return button_delivery
    end

    local GetPadDisplayBox = function(inst,box)
        local bg = box:AddChild(Image("images/hoshino_mission/golden_mission.xml","golden_mission_14_pad.tex"))
        --------------------------------------------------------------------------
        --- 放弃按钮
            local button_give_up = CreateGiveUpButton(bg,button_give_up_location.x,button_give_up_location.y,function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("task_give_up",{},inst)
                bg:Hide()
            end)
        --------------------------------------------------------------------------
        --- 提交按钮
            local button_delivery = CreateDeliveryButton(bg,button_delivery_location.x,button_delivery_location.y,function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("task_delivery",{},inst)
                TUNING.HOSHINO_FNS:Client_PlaySound("dontstarve/common/together/celestial_orb/active")
            end)
        --------------------------------------------------------------------------
        ---       
        --------------------------------------------------------------------------
        ---
            local x = -210
            local y = 2
            local delta_y = -22
            local front_size = 25

            local sharkboi_text = bg:AddChild(Text(CODEFONT,front_size,"0/10",{ 91/255 , 112/255 ,136/255 , 1}))
            sharkboi_text:SetPosition(x,y)
            
            local bearger_text = bg:AddChild(Text(CODEFONT,front_size,"0/10",{ 91/255 , 112/255 ,136/255 , 1}))
            bearger_text:SetPosition(x,y+delta_y)

        --------------------------------------------------------------------------
        --- 检查任务是否完成
            local update_fn = function()

                local sharkboi_num = inst.__sharkboi_num:value()
                local bearger_num = inst.__bearger_num:value()

                if sharkboi_num >0 and bearger_num > 0 then
                    button_delivery:Show()
                else
                    button_delivery:Hide()
                end
                sharkboi_num = math.clamp(sharkboi_num,0,MISSION_ITEM_1_NUM)
                bearger_num = math.clamp(bearger_num,0,MISSION_ITEM_2_NUM)

                sharkboi_text:SetString(""..sharkboi_num.."/"..MISSION_ITEM_1_NUM)
                bearger_text:SetString(""..bearger_num.."/"..MISSION_ITEM_2_NUM)
            end
            update_fn()
            sharkboi_text.inst:ListenForEvent("hoshino_mission_golden_14",update_fn,inst)
        --------------------------------------------------------------------------
        return bg
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 用于任务栏显示的组件，返回Widget图像。client端调用
    local GetBoardDisplayBox = function(inst,box)
        local bg = box:AddChild(Image("images/hoshino_mission/golden_mission.xml","golden_mission_14_board.tex"))
        ------- 任务描述
        -- local display_text = bg:AddChild(Text(CODEFONT,40,"10只猎犬",{ 0/255 , 0/255 ,0/255 , 1}))

        return bg
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 检查和提交
    local function Task_Delivery_Event_Install(inst)
        inst:ListenForEvent("task_delivery", function()
            print("提交任务",inst:GetOwner())
            local owner = inst:GetOwner()
            local sharkboi_num = inst.components.hoshino_data:Add("sharkboi",0)
            local bearger_num = inst.components.hoshino_data:Add("bearger",0)
            if owner and sharkboi_num >= MISSION_ITEM_1_NUM and bearger_num >= MISSION_ITEM_2_NUM then
                inst:Remove()
                owner.components.hoshino_com_rpc_event:PushEvent("hoshino_event.update_task_box")
                owner:PushEvent("hoshino_event.delivery_task",inst.prefab) -- 提交任务广播

                local current_max_exp = owner.components.hoshino_com_level_sys:GetMaxExp()
                local exp = current_max_exp*0.05 -- 25% 经验
                owner.components.hoshino_com_level_sys:Exp_DoDelta(exp)
                owner.components.hoshino_com_shop:CreditCoinDelta(400)

                owner.components.inventory:GiveItem(SpawnPrefab("opalstaff"))


            end
        end)
        inst:ListenForEvent("task_give_up", function()
            print("放弃任务")
            local owner = inst:GetOwner()
            if owner then
                owner.components.hoshino_com_rpc_event:PushEvent("hoshino_event.update_task_box")
                owner:PushEvent("hoshino_event.give_up_task",inst.prefab) -- 放弃任务广播
            end
            inst:Remove()
        end)
        --- 检查任务内容
        local function mission_check()
            local owner = inst:GetOwner()

            if owner then

                local sharkboi_num = inst.components.hoshino_data:Add("sharkboi",0)
                local bearger_num = inst.components.hoshino_data:Add("bearger",0)

                sharkboi_num = math.clamp(sharkboi_num,0,MISSION_ITEM_1_NUM)
                bearger_num = math.clamp(bearger_num,0,MISSION_ITEM_2_NUM)

                inst.__sharkboi_num:set(sharkboi_num)
                inst.__bearger_num:set(bearger_num)

                if sharkboi_num >= MISSION_ITEM_1_NUM and bearger_num >= MISSION_ITEM_2_NUM then
                    owner:PushEvent("hoshino_event.pad_warnning","main_page")
                end

            end        
        end
        --- 激活任务
        inst:ListenForEvent("active",function(inst,owner)

            inst:DoPeriodicTask(5,mission_check)
            inst:DoTaskInTime(0,mission_check)

            inst:ListenForEvent("hoshino_mission_golden_14_kill_with_debuff",function(_,target)
                if target and target.prefab == "sharkboi" then
                    inst.components.hoshino_data:Add("sharkboi",1,0,1)
                elseif target and target.prefab == "bearger" then
                    inst.components.hoshino_data:Add("bearger",1,0,1)
                end
                mission_check()
            end,owner)

            local function add_debuff_2_boss(monster)
                local debuff_prefab = "hoshino_mission_golden_14_debuff"
                local test_num = 100
                while test_num > 0 do
                    local debuff_inst = monster:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        return
                    end
                    monster:AddDebuff(debuff_prefab,debuff_prefab)
                    test_num = test_num - 1
                end
            end

            inst:DoTaskInTime(TUNING.HOSHINO_DEBUGGING_MODE and 5 or 15,function()
                if not inst.components.hoshino_data:Get("boss_spawned") then
                    inst.components.hoshino_data:Set("boss_spawned",true)

                    -- local x,y,z = owner.Transform:GetWorldPosition()
                    local pt = nil
                    local pt = TUNING.HOSHINO_FNS:Get_Random_Point(Vector3(owner.Transform:GetWorldPosition()),15)
                    if type(pt) == type(Vector3(0,0,0)) then
                        local boss = SpawnPrefab("sharkboi")
                        boss.Transform:SetPosition(pt.x,0,pt.z)
                        add_debuff_2_boss(boss)
                    end

                    local pt = TUNING.HOSHINO_FNS:Get_Random_Point(Vector3(owner.Transform:GetWorldPosition()),15)
                    if type(pt) == type(Vector3(0,0,0)) then
                        local boss = SpawnPrefab("bearger")
                        boss.Transform:SetPosition(pt.x,0,pt.z)
                        add_debuff_2_boss(boss)
                    end

                end
            end)

        end)

        -- --- 加载检查
        -- inst.components.hoshino_data:AddOnLoadFn(function(com)
        --     local num = com:Add("num",0)
        --     inst.__num:set(num)
        -- end)

    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
    inst.AnimState:SetBank("cane")
    inst.AnimState:SetBuild("swap_cane")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()
    --------------------------------------------------------------------------------------------
    --- 
        function inst:GetOwner()
            if ThePlayer and self.replica.inventoryitem:IsGrandOwner(ThePlayer) then
                return ThePlayer
            end
            if self.components.inventoryitem then
                return self.components.inventoryitem:GetGrandOwner()
            end
            return self.owner
        end
    --------------------------------------------------------------------------------------------
    --- 
        inst:AddTag("nosteal")
        inst:AddTag("hoshino_task_item")
        inst.type = MISSION_TYPE or "gray"  -- "gray" "golden" "blue" "colourful" --- 给任务栏用的
    --------------------------------------------------------------------------------------------
    --- 数据组件
        if TheWorld.ismastersim then
            inst:AddComponent("hoshino_data")
        end
    --------------------------------------------------------------------------------------------
    --- net 组件
        Net_Vars_Install(inst)
    --------------------------------------------------------------------------------------------
    ---
    --------------------------------------------------------------------------------------------
    --- 引导API
        inst.GetPadDisplayBox = GetPadDisplayBox    -- 平板显示
        inst.GetBoardDisplayBox = GetBoardDisplayBox -- 任务栏显示
    --------------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("cane")


    Task_Delivery_Event_Install(inst)

    return inst
end


local function debuff_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(function(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(target.entity)
        inst.Network:SetClassifiedTarget(target)
        -----------------------------------------------------
        -- --- 60%减伤
        --     target.components.combat.externaldamagetakenmultipliers:SetModifier(inst, 0.2)
        -----------------------------------------------------
        --- 2倍攻击
            target.components.combat.externaldamagemultipliers:SetModifier(inst, 2)
        -----------------------------------------------------
        --- 血量2倍
            -- 
            local current_max = target.components.health.maxhealth
            target.components.health:SetMaxHealth(current_max*2)
        -----------------------------------------------------
        --- 死亡广播
            target:AddTag("hostile")
            target:ListenForEvent("minhealth",function()
                local x,y,z = target.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x,0, z, 100, {"player"})
                for k, v in pairs(ents) do
                    v:PushEvent("hoshino_mission_golden_14_kill_with_debuff",target)
                end
                target:DoTaskInTime(10,function()
                    target:Remove()
                end)
            end)
            target.hoshino_mission_golden_14_debuff = true
        -----------------------------------------------------
        ---
            target:DoPeriodicTask(3,function()
                if target:HasTag("hostile") then
                    target.components.combat:SuggestTarget(target:GetNearestPlayer(true))
                end
            end)
        -----------------------------------------------------
    end)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆

    return inst
end

return Prefab("hoshino_mission_golden_14", fn, assets),
    Prefab("hoshino_mission_golden_14_debuff", debuff_fn, assets)