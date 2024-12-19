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
        Asset("IMAGE", "images/hoshino_mission/white_mission.tex"),
        Asset("ATLAS", "images/hoshino_mission/white_mission.xml"),
    }
    local button_atlas = "images/inspect_pad/page_main.xml"     --- 按钮图集
    local button_give_up_img = "button_give_up.tex"             --- 放弃按钮
    local button_delivery_img = "button_delivery.tex"           --- 交付按钮

    local button_give_up_location = Vector3(290,40,0)          --- 放弃按钮位置
    local button_delivery_location = Vector3(270,-20,0)         --- 交付按钮位置
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
    local function GetStackNum(item)
        if item.replica.stackable then
            return item.replica.stackable:StackSize()
        end
        return 1
    end
    local cooking = require("cooking")
    local cooking_ingredients = cooking.ingredients
    local function has_cooked_field(s)
        -- 使用 string.find 查找 '_cooked' 子字符串
        local start, stop = string.find(s, "_cooked", 1, true)  -- 第四个参数为 true 表示进行精确匹配
        return start ~= nil  -- 如果找到，则返回 true；否则返回 false
    end
    local function IsVeggie(item)
        if item and not has_cooked_field(item.prefab) then
            local food_base_prefab = item.prefab
            if cooking_ingredients[food_base_prefab] and cooking_ingredients[food_base_prefab].tags 
                and cooking_ingredients[food_base_prefab].tags["veggie"] then
                return true
            end
        end
        return false
    end
    local function Has_Veggie(owner,num)
        local count_num = 0
        local ret_veggie_inst = {}

        --- 玩家身上
        local inv_slots = owner.replica.inventory:GetItems()
        for i = 1, 50, 1 do
            if IsVeggie(inv_slots[i]) and ret_veggie_inst[inv_slots[i]] == nil then
                count_num = count_num + GetStackNum(inv_slots[i])
                ret_veggie_inst[inv_slots[i]] = true
            end
        end
        --- 遍历打开的背包
        local openning_containers = owner.replica.inventory:GetOpenContainers() or {}
        for temp_container_inst, flag in pairs(openning_containers) do
            if temp_container_inst and flag and temp_container_inst.replica.inventoryitem and temp_container_inst.replica.container:IsOpenedBy(owner) then
                --- 只算正在打开的背包，不算箱子。
                local max_slots_num = temp_container_inst.replica.container:GetNumSlots()
                -- local container_slots = temp_container_inst.replica.container
                for i = 1, max_slots_num, 1 do
                    local temp_item = temp_container_inst.replica.container:GetItemInSlot(i)
                    if IsVeggie(temp_item) and ret_veggie_inst[temp_item] == nil then
                        count_num = count_num + GetStackNum(temp_item)
                        ret_veggie_inst[temp_item] = true
                    end
                end
            end
        end
        --- 返回计算结果
        return count_num >= num,ret_veggie_inst
    end
    local function Remove_Veggie(owner,num)
        local enough_flag, ret_veggie_inst = Has_Veggie(owner,num)
        if not enough_flag then
            return false
        end
        for temp_item, flag in pairs(ret_veggie_inst) do
            if num <= 0 then
                break
            end
            if temp_item.components.stackable == nil then
                temp_item:Remove()
                num = num - 1
            else
               local current_stack_num = temp_item.components.stackable:StackSize()
               if current_stack_num >= num then
                    --- 叠堆数量充足
                    temp_item.components.stackable:Get(num):Remove()
                    num = 0
               else
                    --- 叠堆数量不足
                    temp_item:Remove()
                    num = num - current_stack_num
               end
            end
        end

        return true
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- net install
    local function Net_Vars_Install(inst)
        inst.__num = net_uint(inst.GUID, "hoshino_mission_white_28","hoshino_mission_white_28")
        inst:ListenForEvent("hoshino_mission_white_28",function()
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
        local bg = box:AddChild(Image("images/hoshino_mission/white_mission.xml","white_mission_28_pad.tex"))
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
            display_text:SetPosition(-300+10,-30)
        --------------------------------------------------------------------------
        --- 检查任务是否完成
            local update_fn = function()
                local num = inst.num or inst.__num:value() or 0
                if num >= 15 then
                    button_delivery:Show()
                else
                    button_delivery:Hide()
                end
                display_text:SetString(""..num.."/15")
            end
            update_fn()
            display_text.inst:ListenForEvent("hoshino_mission_white_28",update_fn,inst)
        --------------------------------------------------------------------------
        return bg
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 用于任务栏显示的组件，返回Widget图像。client端调用
    local GetBoardDisplayBox = function(inst,box)
        local bg = box:AddChild(Image("images/hoshino_mission/white_mission.xml","white_mission_28_board.tex"))
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
            if owner and Has_Veggie(owner,15) then
                inst:Remove()
                owner.components.hoshino_com_rpc_event:PushEvent("hoshino_event.update_task_box")
                owner:PushEvent("hoshino_event.delivery_task",{prefab = inst.prefab,inst = inst,type = inst.type}) -- 提交任务广播

                local current_max_exp = owner.components.hoshino_com_level_sys:GetMaxExp()
                local exp = current_max_exp*0.25 -- 25% 经验
                -- print("debug",owner.components.hoshino_com_level_sys:GetDebugString())
                -- print("获得经验",exp)
                owner.components.hoshino_com_level_sys:Exp_DoDelta(exp)
                owner.components.hoshino_com_shop:CreditCoinDelta(200)

                Remove_Veggie(owner,15)
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
                local enough_flag,item_list = Has_Veggie(owner,15)
                local item_num = 0

                for temp_item, v in pairs(item_list) do
                    if temp_item and v then
                        item_num = item_num + GetStackNum(temp_item)
                    end
                end

                item_num = math.clamp(item_num,0,15)
                inst.__num:set(item_num)
                if item_num >= 15 then
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
        inst.type = "white"  -- "white" "golden" "blue" "colourful" --- 给任务栏用的
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
return Prefab("hoshino_mission_white_28", fn, assets)