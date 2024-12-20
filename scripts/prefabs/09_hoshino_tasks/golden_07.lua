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
--- net install
    local function Net_Vars_Install(inst)
        inst.__num = net_uint(inst.GUID, "hoshino_mission_golden_07","hoshino_mission_golden_07")
        inst:ListenForEvent("hoshino_mission_golden_07",function()
            inst.num = inst.__num:value()
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
        local bg = box:AddChild(Image("images/hoshino_mission/golden_mission.xml","golden_mission_07_pad.tex"))
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
        ---  91,112,136
            local display_text = bg:AddChild(Text(CODEFONT,35,"30",{ 91/255 , 112/255 ,136/255 , 1}))
            display_text:SetPosition(-300,-30)
        --------------------------------------------------------------------------
        --- 检查任务是否完成
            local update_fn = function()
                local num = inst.num or inst.__num:value() or 0
                if num >= 1 then
                    button_delivery:Show()
                else
                    button_delivery:Hide()
                end
                display_text:SetString(""..num.."/1")
            end
            update_fn()
            display_text.inst:ListenForEvent("hoshino_mission_golden_07",update_fn,inst)
        --------------------------------------------------------------------------
        return bg
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 用于任务栏显示的组件，返回Widget图像。client端调用
    local GetBoardDisplayBox = function(inst,box)
        local bg = box:AddChild(Image("images/hoshino_mission/golden_mission.xml","golden_mission_07_board.tex"))
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
            if owner and inst.components.hoshino_data:Add("num",0) >= 1 then
                inst:Remove()
                owner.components.hoshino_com_rpc_event:PushEvent("hoshino_event.update_task_box")
                owner:PushEvent("hoshino_event.delivery_task",{prefab = inst.prefab,inst = inst,type = inst.type}) -- 提交任务广播

                local current_max_exp = owner.components.hoshino_com_level_sys:GetMaxExp()
                local exp = current_max_exp*0.30 -- 30% 经验
                -- print("debug",owner.components.hoshino_com_level_sys:GetDebugString())
                -- print("获得经验",exp)
                owner.components.hoshino_com_level_sys:Exp_DoDelta(exp)
                owner.components.hoshino_com_shop:CreditCoinDelta(700)

                owner.components.inventory:GiveItem(SpawnPrefab("hoshino_item_yi"))

            end
        end)
        inst:ListenForEvent("task_give_up", function()
            print("放弃任务")
            local owner = inst:GetOwner()
            if owner then
                owner.components.hoshino_com_rpc_event:PushEvent("hoshino_event.update_task_box")
                owner:PushEvent("hoshino_event.give_up_task",{prefab = inst.prefab,inst = inst,type = inst.type}) -- 放弃任务广播
            end
            inst:Remove()
        end)
        --- 激活任务
        inst:ListenForEvent("active",function(inst,owner)
            --- 定时检查
            inst:DoPeriodicTask(10,function()
                local num = inst.components.hoshino_data:Add("num",0)
                if num >= 1 then
                    owner:PushEvent("hoshino_event.pad_warnning","main_page")
                end
            end)
            --- 召唤BOSS
            inst:DoTaskInTime(TUNING.HOSHINO_DEBUGGING_MODE and 5 or 15,function()
                if not inst.components.hoshino_data:Get("boss_spawned") then
                        local pt = TUNING.HOSHINO_FNS:Get_Random_Point(Vector3(owner.Transform:GetWorldPosition()),15)
                        if type(pt) == type(Vector3(0,0,0)) then
                            local boss = SpawnPrefab("mutatedwarg")
                            boss.Transform:SetPosition(pt.x,0,pt.z)
                            local test_num = 100
                            local debuff_prefab = "hoshino_mission_golden_07_debuff"
                            while test_num > 0 do
                                local debuff_inst = boss:GetDebuff(debuff_prefab)
                                if debuff_inst and debuff_inst:IsValid() then
                                    inst.components.hoshino_data:Set("boss_spawned",true)
                                    return
                                end
                                boss:AddDebuff(debuff_prefab,debuff_prefab)
                                test_num = test_num - 1
                            end
                        end
                end
            end)
            --- 击杀事件
            inst:ListenForEvent("hoshino_mission_golden_07_kill_with_debuff",function()
                local num = inst.components.hoshino_data:Add("num",1,0,1)
                inst.__num:set(num)
                if num >= 1 then
                    owner:PushEvent("hoshino_event.pad_warnning","main_page")
                end
            end,owner)

        end)

        --- 加载检查
        inst.components.hoshino_data:AddOnLoadFn(function(com)
            local num = com:Add("num",0)
            inst.__num:set(num)
        end)




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
        inst.type = "golden"  -- "white" "golden" "blue" "colourful" --- 给任务栏用的
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
    inst.entity:AddTransform()
    inst:AddTag("CLASSIFIED")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(function(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(target.entity)
        -- inst.Network:SetClassifiedTarget(target)
        inst.Transform:SetPosition(0, 0, 0)
        -----------------------------------------------------
        -- --- 60%减伤
        --     target.components.combat.externaldamagetakenmultipliers:SetModifier(inst, 0.2)
        -----------------------------------------------------
        --- 2倍攻击
            target.components.combat.externaldamagemultipliers:SetModifier(inst, 2)
        -----------------------------------------------------
        --- 血量2倍
            target.components.health:SetMaxHealth(TUNING.MUTATED_WARG_HEALTH*2)
        -----------------------------------------------------
        --- 死亡广播
            -- target:ListenForEvent("minhealth",function()
            --     local x,y,z = target.Transform:GetWorldPosition()
            --     local ents = TheSim:FindEntities(x,0, z, 100, {"player"})
            --     for k, v in pairs(ents) do
            --         v:PushEvent("hoshino_mission_blue_18_kill_with_debuff",target)
            --     end
            -- end)
            inst:ListenForEvent("entity_droploot",function(_,_table)
                if _table and _table.inst == target then
                    -- target.components.lootdropper:SpawnLootPrefab("krampus_sack")

                    local x,y,z = target.Transform:GetWorldPosition()
                    local ents = TheSim:FindEntities(x,0, z, 100, {"player"})
                    for k, v in pairs(ents) do
                        v:PushEvent("hoshino_mission_golden_07_kill_with_debuff",target)
                    end
                end
            end,TheWorld)
            target.hoshino_mission_golden_07_debuff = true
        -----------------------------------------------------
        ---
            target:DoPeriodicTask(3,function()
                target.components.combat:SuggestTarget(target:GetNearestPlayer(true))
            end)
        -----------------------------------------------------
    end)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆

    return inst
end

return Prefab("hoshino_mission_golden_07", fn, assets),
    Prefab("hoshino_mission_golden_07_debuff", debuff_fn, assets)