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
    local MISSION_TYPE = "blue" -- "gray" "golden" "blue" "colourful" --- 给任务栏用的

    local MISSION_ITEM_1 = "bunnyman"
    local MISSION_ITEM_1_NUM = 1
    local MISSION_ITEM_2 = "pigman"
    local MISSION_ITEM_2_NUM = 1
    local MISSION_ITEM_3 = "beefalo"
    local MISSION_ITEM_3_NUM = 1
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function Has_Enough_Items(owner,prefab,num)
        local flag,num = owner.replica.inventory:Has(prefab,num,true)
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

        inst.__bunnyman_num = net_uint(inst.GUID, "hoshino_mission_blue_33.bunnyman","hoshino_mission_blue_33")
        inst.__pigman_num = net_uint(inst.GUID, "hoshino_mission_blue_33.pigman","hoshino_mission_blue_33")
        inst.__beefalo_num = net_uint(inst.GUID, "hoshino_mission_blue_33.beefalo","hoshino_mission_blue_33")
        inst:ListenForEvent("hoshino_mission_blue_33",function()
            inst.bunnyman_num = inst.__bunnyman_num:value()
            inst.pigman_num = inst.__pigman_num:value()
            inst.beefalo_num = inst.__beefalo_num:value()
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
        local bg = box:AddChild(Image("images/hoshino_mission/blue_mission.xml","blue_mission_33_pad.tex"))
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
            local x = -210+60
            local y = 2
            local delta_y = -22
            local front_size = 25
            local bunnyman_text = bg:AddChild(Text(CODEFONT,front_size,"0/1",{ 91/255 , 112/255 ,136/255 , 1}))
            bunnyman_text:SetPosition(x,y)

            local pigman_text = bg:AddChild(Text(CODEFONT,front_size,"0/1",{ 91/255 , 112/255 ,136/255 , 1}))
            pigman_text:SetPosition(x,y+delta_y)

            local beefalo_text = bg:AddChild(Text(CODEFONT,front_size,"0/1",{ 91/255 , 112/255 ,136/255 , 1}))
            beefalo_text:SetPosition(x,y+delta_y*2)
        --------------------------------------------------------------------------
        --- 检查任务是否完成
            local update_fn = function()

                local bunnyman_num = inst.__bunnyman_num:value()
                local pigman_num = inst.__pigman_num:value()
                local beefalo_num = inst.__beefalo_num:value()

                if bunnyman_num + pigman_num + beefalo_num >= 3 then
                    button_delivery:Show()
                else
                    button_delivery:Hide()
                end

                bunnyman_text:SetString(""..bunnyman_num.."/1")
                pigman_text:SetString(""..pigman_num.."/1")
                beefalo_text:SetString(""..beefalo_num.."/1")
            end
            update_fn()
            bunnyman_text.inst:ListenForEvent("hoshino_mission_blue_33",update_fn,inst)
        --------------------------------------------------------------------------
        return bg
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 用于任务栏显示的组件，返回Widget图像。client端调用
    local GetBoardDisplayBox = function(inst,box)
        local bg = box:AddChild(Image("images/hoshino_mission/blue_mission.xml","blue_mission_33_board.tex"))
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

            local bunnyman_num = inst.components.hoshino_data:Add("bunnyman",0)
            local pigman_num = inst.components.hoshino_data:Add("pigman",0)
            local beefalo_num = inst.components.hoshino_data:Add("beefalo",0)
            
            if owner and bunnyman_num + pigman_num + beefalo_num >= 3 then
                inst:Remove()
                owner.components.hoshino_com_rpc_event:PushEvent("hoshino_event.update_task_box")
                owner:PushEvent("hoshino_event.delivery_task",{prefab = inst.prefab,inst = inst,type = inst.type}) -- 提交任务广播

                local current_max_exp = owner.components.hoshino_com_level_sys:GetMaxExp()
                local exp = current_max_exp*0.25 -- 25% 经验
                -- print("debug",owner.components.hoshino_com_level_sys:GetDebugString())
                -- print("获得经验",exp)
                owner.components.hoshino_com_level_sys:Exp_DoDelta(exp)

                local item = SpawnPrefab("goldnugget")
                item.components.stackable.stacksize = 10
                owner.components.inventory:GiveItem(item) -- 给予物品

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
        -- --- 激活任务
        inst:ListenForEvent("active",function(inst,owner)

            local function warnning_checker()
                local bunnyman_num = inst.components.hoshino_data:Add("bunnyman",0)
                inst.__bunnyman_num:set(bunnyman_num)
                local pigman_num = inst.components.hoshino_data:Add("pigman",0)
                inst.__pigman_num:set(pigman_num)
                local beefalo_num = inst.components.hoshino_data:Add("beefalo",0)
                inst.__beefalo_num:set(beefalo_num)

                if bunnyman_num + pigman_num + beefalo_num >= 3 then
                    owner:PushEvent("hoshino_event.pad_warnning","main_page")
                end
            end

            --- 火堆烹饪
            inst:ListenForEvent("hoshino_event.cookable_cooked",function(_,_table)
                local product = _table and _table.product
                -- print("cookable_cooked+++",product)
                if product and product.prefab == "cookedmeat" then
                    local x,y,z = owner.Transform:GetWorldPosition()
                    local ents = TheSim:FindEntities(x,0,z,12,{"_health"})
                    local succeed_flag = false
                    for k, temp_target in pairs(ents) do
                        if temp_target then
                            if temp_target.prefab == "bunnyman" then
                                inst.components.hoshino_data:Add("bunnyman",1,0,1)
                                succeed_flag = true
                            elseif temp_target.prefab == "pigman" then
                                inst.components.hoshino_data:Add("pigman",1,0,1)
                                succeed_flag = true
                            elseif temp_target.prefab == "beefalo" then
                                inst.components.hoshino_data:Add("beefalo",1,0,1)
                                succeed_flag = true
                            end
                        end
                    end
                    if not succeed_flag then
                        return
                    end

                    warnning_checker()
                end
            end,owner)

            inst:DoPeriodicTask(5,warnning_checker)

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
return Prefab("hoshino_mission_blue_33", fn, assets)