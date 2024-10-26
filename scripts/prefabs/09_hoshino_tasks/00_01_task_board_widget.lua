---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    任务界面

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
return function(inst,front_root)
    ------------------------------------------------------------------
    --- 隐藏容器界面的各种东西
        front_root.bganim:Hide()
        front_root.bgimage:Hide()
        local hide_item_tile = function()
            for _,v in pairs(front_root.inv) do
                v:Hide()
            end
        end
        ----
        local old_Refresh = front_root.Refresh
        front_root.Refresh = function(...)
            old_Refresh(...)
            hide_item_tile()
        end
        ----
        local old_OnItemGet = front_root.OnItemGet
        front_root.OnItemGet = function(...)
            old_OnItemGet(...)
            hide_item_tile()
        end
        ----
        hide_item_tile()
    ------------------------------------------------------------------
    --- root 节点创建
        local ex_root = front_root:AddChild(Widget())
        ex_root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        ex_root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        ex_root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        local root = ex_root:AddChild(Widget())
        local MainScale = 0.5
        root:SetScale(MainScale,MainScale,MainScale)
    ------------------------------------------------------------------
    --- 参数
        local atlas = "images/widgets/hoshino_building_task_board_widget.xml"
    ------------------------------------------------------------------
    --- 背景
        local bg = root:AddChild(Image(atlas,"background.tex"))
    ------------------------------------------------------------------
    --- 关闭按钮
        local button_close = root:AddChild(ImageButton(atlas,"button_close.tex","button_close.tex","button_close.tex","button_close.tex","button_close.tex"))
        button_close:SetPosition(780,375)
        button_close:SetOnClick(function()
            inst.replica.container:Close()
            front_root:Hide()
            ThePlayer.replica.hoshino_com_rpc_event:PushEvent("close_button_clicked",{},inst)
        end)
    ------------------------------------------------------------------
    --- 刷新次数
        local refresh_count_text = root:AddChild(Text(CODEFONT,40,"30",{ 0/255 , 0/255 ,0/255 , 1}))
        refresh_count_text:SetPosition(660,375)
        local refresh_count_text_update_fn = function()
            local num = inst.replica.hoshino_com_task_sys_for_building and inst.replica.hoshino_com_task_sys_for_building:Get_Refresh_Num() or 0
            refresh_count_text:SetString(tostring(num))
        end
        refresh_count_text.inst:DoPeriodicTask(0.1,refresh_count_text_update_fn)
        refresh_count_text_update_fn()
    ------------------------------------------------------------------
    --- 任务盒子
        local task_box = {}
        local points = { 
                        Vector3(-550,145,0) , Vector3(0,145,0) ,Vector3(550,145,0),
                        Vector3(-550,-233,0) , Vector3(0,-233,0) ,Vector3(550,-233,0),
                    }
        ------- 底部刷新按钮
        for index, pt in pairs(points) do
            local empty_refresh_button = root:AddChild(ImageButton(atlas,"button_refresh.tex","button_refresh.tex","button_refresh.tex","button_refresh.tex","button_refresh.tex"))
            empty_refresh_button.focus_scale = {1.1, 1.1, 1.1}
            empty_refresh_button:SetScale(1.5,1.5,1.5)
            empty_refresh_button:SetOnClick(function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("refresh_button_click",index,inst)
                empty_refresh_button:Hide()
                empty_refresh_button.inst:DoTaskInTime(2,function()
                    empty_refresh_button:Show()
                end)
            end)
            empty_refresh_button:SetPosition(pt.x+20,pt.y)
        end
        ------- 任务盒子                    
        for index, pt in pairs(points) do
            local box = root:AddChild(Widget())
            task_box[index] = box
            box:SetPosition(pt.x,pt.y)
            ------ 背景图片
            local bg = box:AddChild(Image(atlas,"excample_task.tex"))
            box.bg = bg
            ------- 刷新按钮
            local button_refresh = box:AddChild(ImageButton(atlas,"button_refresh.tex","button_refresh.tex","button_refresh.tex","button_refresh.tex","button_refresh.tex"))
            button_refresh.focus_scale = {1.1, 1.1, 1.1}
            local temp_scale = 1
            button_refresh:SetScale(temp_scale,temp_scale,temp_scale)
            button_refresh:SetPosition(180,150)
            button_refresh:SetOnClick(function()
                if button_refresh.cd_task == nil then
                    ThePlayer.replica.hoshino_com_rpc_event:PushEvent("refresh_button_click",index,inst)
                    button_refresh.cd_task = button_refresh.inst:DoTaskInTime(2,function()
                        button_refresh.cd_task = nil
                    end)
                end
            end)
            box.button_refresh = button_refresh
            ------- 接受按钮
            local button_accept = box:AddChild(ImageButton(atlas,"button_accept.tex","button_accept.tex","button_accept.tex","button_accept.tex","button_accept.tex"))
            button_accept.focus_scale = {1.1, 1.1, 1.1}
            temp_scale = 1
            button_accept:SetScale(temp_scale,temp_scale,temp_scale)
            button_accept:SetPosition(160,-130)
            button_accept:SetOnClick(function()
                if button_accept.cd_task == nil then
                    ThePlayer.replica.hoshino_com_rpc_event:PushEvent("accept_button_click",index,inst)
                    button_accept.cd_task = button_accept.inst:DoTaskInTime(2,function()
                        button_accept.cd_task = nil
                    end)
                end
            end)
            box.button_accept = button_accept
        end
    ------------------------------------------------------------------
    --- 刷新界面
        local function task_box_update_fn()
            local items = inst.replica.container:GetItems()
            for index = 1, 6, 1 do
                local item = items[index]
                if item and item.GetBoardDisplayBox then
                    if task_box[index].bg then
                        task_box[index].bg:Kill()
                    end
                    task_box[index]:Show()
                    local bg = item:GetBoardDisplayBox(task_box[index])
                    task_box[index].bg = bg
                    task_box[index].button_accept:Show()
                    task_box[index].button_accept:MoveToFront()
                    task_box[index].button_refresh:Show()
                    task_box[index].button_refresh:MoveToFront()
                    task_box[index].displaying = true
                else  
                    task_box[index]:Hide()
                    task_box[index].displaying = false
                end
            end
        end
        root.inst:ListenForEvent("update_task_box",task_box_update_fn,inst)
        task_box_update_fn()
        root.inst:ListenForEvent("refresh_widget_box",function()
            for i = 0, 10, 1 do
                root.inst:DoTaskInTime(0.2*i,task_box_update_fn)
            end
        end,inst)
    ------------------------------------------------------------------
    --- 刷新检查
        local function task_box_check_fn()
            local items = inst.replica.container:GetItems()
            for index = 1, 6, 1 do
                if items[index] and not task_box[index].displaying then
                    task_box_update_fn()
                    return
                end
            end
        end
        root.inst:DoPeriodicTask(0.5,task_box_check_fn)
    ------------------------------------------------------------------
end
