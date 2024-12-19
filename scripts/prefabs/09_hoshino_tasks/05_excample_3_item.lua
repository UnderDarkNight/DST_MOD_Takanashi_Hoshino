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
        Asset("IMAGE", "images/hoshino_mission/blue_mission.tex"),
        Asset("ATLAS", "images/hoshino_mission/blue_mission.xml"),
    }
    local button_atlas = "images/inspect_pad/page_main.xml"     --- 按钮图集
    local button_give_up_img = "button_give_up.tex"             --- 放弃按钮
    local button_delivery_img = "button_delivery.tex"           --- 交付按钮

    local button_give_up_location = Vector3(290,40,0)          --- 放弃按钮位置
    local button_delivery_location = Vector3(270,-20,0)         --- 交付按钮位置
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 专属参数
    local MISSION_TYPE = "blue" -- "white" "golden" "blue" "colourful" --- 给任务栏用的

    local MISSION_ITEM_1 = "sewing_kit"
    local MISSION_ITEM_1_NUM = 2
    local MISSION_ITEM_2 = "gears"
    local MISSION_ITEM_2_NUM = 4
    local MISSION_ITEM_3 = "wagpunkbits_kit"
    local MISSION_ITEM_3_NUM = 2
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function Has_Enough_Items(owner,prefab,num)
        local flag,num = owner.replica.inventory:Has(prefab,num,false)
        return flag or false,num
    end
    local function Remove_Items_By_Prefab(owner,prefab,num)
        if not Has_Enough_Items(owner,prefab,num) then
            return
        end

        local ask_num = num
        owner.components.inventory:ForEachItem(function(item)
            if not (item and item.prefab == prefab) then
                return
            end
            if ask_num <= 0 then
                return
            end

            if item.components.stackable == nil then
                item:Remove()
                ask_num = ask_num - 1
            else
               local current_stack_num = item.components.stackable:StackSize()
               if current_stack_num >= ask_num then
                    --- 叠堆数量充足
                    item.components.stackable:Get(ask_num):Remove()
                    ask_num = 0
               else
                    --- 叠堆数量不足
                    item:Remove()
                    ask_num = ask_num - current_stack_num
               end
            end

        end)

    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- net install
    local function Net_Vars_Install(inst)

        inst.__sewing_kit_num = net_uint(inst.GUID, "hoshino_mission_blue_30.sewing_kit","hoshino_mission_blue_30")
        inst.__gears_num = net_uint(inst.GUID, "hoshino_mission_blue_30.gears","hoshino_mission_blue_30")
        inst.__wagpunkbits_kit_num = net_uint(inst.GUID, "hoshino_mission_blue_30.wagpunkbits_kit","hoshino_mission_blue_30")
        inst:ListenForEvent("hoshino_mission_blue_30",function()
            inst.sewing_kit_num = inst.__sewing_kit_num:value()
            inst.gears_num = inst.__gears_num:value()
            inst.wagpunkbits_kit_num = inst.__wagpunkbits_kit_num:value()
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
        local bg = box:AddChild(Image("images/hoshino_mission/blue_mission.xml","blue_mission_30_pad.tex"))
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
            local x = -210+30
            local y = 2
            local delta_y = -22
            local front_size = 25
            local sewing_kit_text = bg:AddChild(Text(CODEFONT,front_size,"0/1",{ 91/255 , 112/255 ,136/255 , 1}))
            sewing_kit_text:SetPosition(x,y)

            local gears_text = bg:AddChild(Text(CODEFONT,front_size,"0/1",{ 91/255 , 112/255 ,136/255 , 1}))
            gears_text:SetPosition(x,y+delta_y)

            local wagpunkbits_kit_text = bg:AddChild(Text(CODEFONT,front_size,"0/1",{ 91/255 , 112/255 ,136/255 , 1}))
            wagpunkbits_kit_text:SetPosition(x,y+delta_y*2)
        --------------------------------------------------------------------------
        --- 检查任务是否完成
            local update_fn = function()
                local sewing_kit_flag,sewing_kit_num = Has_Enough_Items(ThePlayer,"sewing_kit",MISSION_ITEM_1_NUM)
                local gears_flag,gears_num = Has_Enough_Items(ThePlayer,"gears",MISSION_ITEM_2_NUM)
                local wagpunkbits_kit_flag,wagpunkbits_kit_num = Has_Enough_Items(ThePlayer,"wagpunkbits_kit",MISSION_ITEM_3_NUM)
                if sewing_kit_flag and gears_flag and wagpunkbits_kit_flag then
                    button_delivery:Show()
                else
                    button_delivery:Hide()
                end
                sewing_kit_num = math.clamp(sewing_kit_num,0,MISSION_ITEM_1_NUM)
                gears_num = math.clamp(gears_num,0,MISSION_ITEM_2_NUM)
                wagpunkbits_kit_num = math.clamp(wagpunkbits_kit_num,0,MISSION_ITEM_3_NUM)
                sewing_kit_text:SetString(""..sewing_kit_num.."/"..MISSION_ITEM_1_NUM)
                gears_text:SetString(""..gears_num.."/"..MISSION_ITEM_2_NUM)
                wagpunkbits_kit_text:SetString(""..wagpunkbits_kit_num.."/"..MISSION_ITEM_3_NUM)
            end
            update_fn()
            sewing_kit_text.inst:ListenForEvent("hoshino_mission_blue_30",update_fn,inst)
        --------------------------------------------------------------------------
        return bg
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 用于任务栏显示的组件，返回Widget图像。client端调用
    local GetBoardDisplayBox = function(inst,box)
        local bg = box:AddChild(Image("images/hoshino_mission/blue_mission.xml","blue_mission_30_board.tex"))
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
            if owner and Has_Enough_Items(owner,"sewing_kit",MISSION_ITEM_1_NUM) and Has_Enough_Items(owner,"gears",MISSION_ITEM_2_NUM) and Has_Enough_Items(owner,"wagpunkbits_kit",MISSION_ITEM_3_NUM) then
                inst:Remove()
                owner.components.hoshino_com_rpc_event:PushEvent("hoshino_event.update_task_box")
                owner:PushEvent("hoshino_event.delivery_task",{prefab = inst.prefab,inst = inst,type = inst.type}) -- 提交任务广播

                local current_max_exp = owner.components.hoshino_com_level_sys:GetMaxExp()
                local exp = current_max_exp*0.05 -- 5% 经验
                -- print("debug",owner.components.hoshino_com_level_sys:GetDebugString())
                -- print("获得经验",exp)
                owner.components.hoshino_com_level_sys:Exp_DoDelta(exp)

                -- owner.components.hoshino_com_shop:CreditCoinDelta(800)

                Remove_Items_By_Prefab(owner,"sewing_kit",MISSION_ITEM_1_NUM)
                Remove_Items_By_Prefab(owner,"gears",MISSION_ITEM_2_NUM)
                Remove_Items_By_Prefab(owner,"wagpunkbits_kit",MISSION_ITEM_3_NUM)

                -- local item = SpawnPrefab("hoshino_item_12mm_shotgun_shells")
                -- item.components.stackable.stacksize = 5
                -- owner.components.inventory:GiveItem(item) -- 给予物品

                owner.components.inventory:GiveItem(SpawnPrefab("glasscutter")) -- 给予物品
                owner.components.inventory:GiveItem(SpawnPrefab("hoshino_item_cards_pack")) -- 给予物品

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
        --- 检查任务内容
        local function mission_check()
            local owner = inst:GetOwner()

            if owner then

                local sewing_kit_flag,sewing_kit_num = Has_Enough_Items(owner,"sewing_kit",MISSION_ITEM_1_NUM)
                local gears_flag,gears_num = Has_Enough_Items(owner,"gears",MISSION_ITEM_2_NUM)
                local wagpunkbits_kit_flag,wagpunkbits_kit_num = Has_Enough_Items(owner,"wagpunkbits_kit",MISSION_ITEM_3_NUM)

                sewing_kit_num = math.clamp(sewing_kit_num,0,MISSION_ITEM_1_NUM)
                gears_num = math.clamp(gears_num,0,MISSION_ITEM_2_NUM)
                wagpunkbits_kit_num = math.clamp(wagpunkbits_kit_num,0,MISSION_ITEM_3_NUM)

                inst.__sewing_kit_num:set(sewing_kit_num)
                inst.__gears_num:set(gears_num)
                inst.__wagpunkbits_kit_num:set(wagpunkbits_kit_num)

                if sewing_kit_num >= MISSION_ITEM_1_NUM and gears_num >= MISSION_ITEM_2_NUM and wagpunkbits_kit_num >= MISSION_ITEM_3_NUM then
                    owner:PushEvent("hoshino_event.pad_warnning","main_page")
                end

            end        
        end
        --- 激活任务
        inst:ListenForEvent("active",function(inst,owner)

            inst:DoPeriodicTask(5,mission_check)
            inst:DoTaskInTime(0,mission_check)
            inst:ListenForEvent("itemlose",mission_check,owner)
            inst:ListenForEvent("dropitem",mission_check,owner)
            inst:ListenForEvent("itemget",mission_check,owner)
            inst:ListenForEvent("gotnewitem",mission_check,owner)
            inst:ListenForEvent("itemget",mission_check,owner)
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
        inst.type = MISSION_TYPE or "gray"  -- "white" "golden" "blue" "colourful" --- 给任务栏用的
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
return Prefab("hoshino_mission_blue_30", fn, assets)