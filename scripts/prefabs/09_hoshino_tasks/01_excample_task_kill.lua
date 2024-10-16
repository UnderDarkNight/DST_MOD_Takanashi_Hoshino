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

    }
    local button_atlas = "images/inspect_pad/page_main.xml"     --- 按钮图集
    local button_give_up_img = "button_give_up.tex"             --- 放弃按钮
    local button_delivery_img = "button_delivery.tex"           --- 交付按钮

    local button_give_up_location = Vector3(290,40,0)          --- 放弃按钮位置
    local button_delivery_location = Vector3(260,-20,0)         --- 交付按钮位置
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- net install
    local function Net_Vars_Install(inst)
        inst.__killed_num = net_uint(inst.GUID, "hoshino_task_excample_kill","hoshino_task_excample_kill")
        inst:ListenForEvent("hoshino_task_excample_kill",function()
            inst.num = inst.__killed_num:value()
        end)
        if not TheWorld.ismastersim then
            return
        end


        -- inst.components.hoshino_data:AddOnSaveFn(function(com)

        -- end)
        -- inst:DoTaskInTime(1,function()
            
        -- end)

    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 用于平板显示的API，返回Widget图像。client端调用
    local GetPadDisplayBox = function(inst,box)
        local bg = box:AddChild(Image("images/inspect_pad/page_main.xml","task_box_excample.tex"))
        --------------------------------------------------------------------------
        --- 放弃按钮
            local button_give_up = bg:AddChild(ImageButton(button_atlas,button_give_up_img,button_give_up_img,
            button_give_up_img,button_give_up_img,button_give_up_img))
            button_give_up:SetPosition(button_give_up_location.x,button_give_up_location.y)
            button_give_up.focus_scale = {1.1, 1.1, 1.1}
            button_give_up:SetScale(0.5,0.5,0.5)
            button_give_up:SetOnClick(function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("task_give_up",{},inst)
                bg:Hide()
            end)
        --------------------------------------------------------------------------
        --- 提交按钮
            local button_delivery = bg:AddChild(ImageButton(button_atlas,button_delivery_img,button_delivery_img,
            button_delivery_img,button_delivery_img,button_delivery_img))
            button_delivery:SetPosition(button_delivery_location.x,button_delivery_location.y)
            button_delivery.focus_scale = {1.1, 1.1, 1.1}
            button_delivery:SetOnClick(function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("task_delivery",{},inst)            
            end)
        --------------------------------------------------------------------------
        ---
            local display_text = bg:AddChild(Text(CODEFONT,40,"30",{ 0/255 , 0/255 ,0/255 , 1}))
        --------------------------------------------------------------------------
        --- 检查任务是否完成
            local update_fn = function()
                local num = inst.__killed_num:value()
                if num >= 10 then
                    button_delivery:Show()
                else
                    button_delivery:Hide()
                end
                display_text:SetString("击杀猎犬"..num.."/10")
            end
            update_fn()
            inst:ListenForEvent("hoshino_task_excample_kill",update_fn)
        --------------------------------------------------------------------------
        return bg
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 用于任务栏显示的组件，返回Widget图像。client端调用
    local GetBoardDisplayBox = function(inst,box)
        
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 检查和提交
    local function Task_Delivery_Event_Install(inst)
        inst:ListenForEvent("task_delivery", function()
            print("提交任务",inst:GetOwner())
            local owner = inst:GetOwner()            
            if owner and inst.components.hoshino_data:Add("hound",0) >= 10 then
                inst:Remove()
                owner.components.hoshino_com_rpc_event:PushEvent("hoshino_event.update_task_box")
                owner.components.inventory:GiveItem(SpawnPrefab("eyebrellahat"))
            end
        end)
        inst:ListenForEvent("task_give_up", function()
            print("放弃任务")
            local owner = inst:GetOwner()
            inst:Remove()
            if owner then
                owner.components.hoshino_com_rpc_event:PushEvent("hoshino_event.update_task_box")
            end
        end)

        inst:ListenForEvent("killed",function(_,_table) --- 广播来的事件
            local prefab = _table and _table.prefab
            local num = _table and _table.num
            local other_data = _table and _table.other_data or {}
            if prefab == "hound" then
                local ret = inst.components.hoshino_data:Add("hound",num or 1)
                inst.__killed_num:set(ret)
            end
        end)
        --- 加载检查
        inst.components.hoshino_data:AddOnLoadFn(function(com)
            local num = com:Add("hound",0)
            inst.__killed_num:set(num)
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
        inst:AddTag("hoshino_task_item")
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
    function inst:GetOwner()
        return inst.components.inventoryitem:GetGrandOwner()
    end

    Task_Delivery_Event_Install(inst)

    return inst
end
return Prefab("hoshino_task_excample_kill", fn, assets)