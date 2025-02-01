----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 客户端代码·界面
    local little_smart_phone_atlas = "images/inspect_pad/little_smart_phone.xml"
    local drone_controller_atlas = "images/widgets/hoshino_drone_controller.xml"
    --- 坐标读取
    local function GetHUDLoation()
        local data = TUNING.HOSHINO_FNS:Get_ThePlayer_Cross_Archived_Data("drone_little_smart_phone_location")
        if data == nil then
            return 0.5,0.5
        else
            return data.x,data.y
        end
    end
    local function SetHUDLoation(x,y)
        TUNING.HOSHINO_FNS:Set_ThePlayer_Cross_Archived_Data("drone_little_smart_phone_location",{x = x,y = y})
    end
    local function CreatePAD(___front_root)
        -----------------------------------------------------------------------------------
        --- 前置根节点
            local front_root = ThePlayer.HUD
        -----------------------------------------------------------------------------------
        --- 创建根节点
            local root = front_root:AddChild(Widget())
            root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
            root:SetPosition(180,0)
            local MainScale = 0.6
            root.inst:ListenForEvent("pad_close",function()
                root:Kill()
            end,front_root.inst)
        -----------------------------------------------------------------------------------
        ---
            --- 平板外框
            local bg = root:AddChild(Image())
            bg:SetTexture(little_smart_phone_atlas,"background_frame.tex")
            bg:SetScale(MainScale,MainScale,MainScale)
            --- 背景颜色
            local bg_color = root:AddChild(Image())
            bg_color:SetTexture(little_smart_phone_atlas,"background_color.tex")
            bg_color:MoveToBack()
            bg_color:SetScale(MainScale,MainScale,MainScale)
        -----------------------------------------------------------------------------------
        ---
            local function CreateIconText(button,str)
                local text = button:AddChild(Text(CODEFONT,50,str or "测试文本",{ 0/255 , 0/255 ,0/255 , 1}))
                text:SetPosition(0,-100)
            end
        -----------------------------------------------------------------------------------
        --- close button
            local button_close =  root:AddChild(ImageButton(
                little_smart_phone_atlas,"button_close.tex","button_close.tex","button_close.tex","button_close.tex","button_close.tex"
            ))
            button_close:SetOnClick(function()
                front_root.inst:PushEvent("pad_close")
            end)
            button_close:SetScale(MainScale,MainScale,MainScale)
            button_close.focus_scale = {1.05, 1.05, 1.05}
            button_close:SetPosition(0,-235)
        -----------------------------------------------------------------------------------
        --- 扫描遍历,没有无人机的时候，自动销毁界面
            local function need_2_remove_task_fn()
                local need_2_remove_flag = true
                local new_table = {}
                for drone, v in pairs(ThePlayer.HOSHINO_DRONES) do
                    if drone and drone:IsValid() then
                        need_2_remove_flag = false
                        new_table[drone] = true
                    end
                end
                if need_2_remove_flag then
                    root:Kill()
                    ThePlayer.HOSHINO_DRONES = new_table
                end
            end
            root.inst:DoPeriodicTask(0.5,need_2_remove_task_fn)
        -----------------------------------------------------------------------------------
        --- 按钮坐标 横向4个按钮，高度4个按钮
            local start_x = -150
            local start_y = 150
            local delta_x = 100
            local delta_y = -100
            local button_pos = {
            }
            for y=1,4 do
                for x=1,4 do
                    table.insert(button_pos,Vector3(start_x + delta_x * (x-1),start_y + delta_y * (y-1),0))
                end
            end
        -----------------------------------------------------------------------------------
        --- 测试布局
            -- root.test_buttons = {}
            -- for i = 1, #button_pos do
            --     local test_button = root:AddChild(ImageButton(
            --         drone_controller_atlas,"stop_attack.tex","stop_attack.tex","stop_attack.tex","stop_attack.tex","stop_attack.tex"
            --     ))
            --     test_button:SetOnClick(function()
            --         print("test_button",i)
            --     end)
            --     test_button:SetScale(MainScale,MainScale,MainScale)
            --     test_button.focus_scale = {1.05, 1.05, 1.05}
            --     test_button:SetPosition(button_pos[i].x,button_pos[i].y)
            -- end
        -----------------------------------------------------------------------------------
        --- 停止攻击 stop_attack
            local button_stop_attack =  root:AddChild(ImageButton(
                drone_controller_atlas,"stop_attack.tex","stop_attack.tex","stop_attack.tex","stop_attack.tex","stop_attack.tex"
            ))
            button_stop_attack:SetOnClick(function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_com_drone_leader.commmand","stop_attack")
            end)
            button_stop_attack:SetScale(MainScale,MainScale,MainScale)
            button_stop_attack.focus_scale = {1.05, 1.05, 1.05}
            button_stop_attack:SetPosition(button_pos[1].x,button_pos[1].y)
            CreateIconText(button_stop_attack,"停止攻击")
        -----------------------------------------------------------------------------------
        --- 解除攻击 disarm
            local button_disarm =  root:AddChild(ImageButton(
                drone_controller_atlas,"disarm.tex","disarm.tex","disarm.tex","disarm.tex","disarm.tex"
            ))
            button_disarm:SetOnClick(function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_com_drone_leader.commmand","disarm")                
            end)
            button_disarm:SetScale(MainScale,MainScale,MainScale)
            button_disarm.focus_scale = {1.05, 1.05, 1.05}
            button_disarm:SetPosition(button_pos[2].x,button_pos[2].y)
            CreateIconText(button_disarm,"解除炮塔")
        -----------------------------------------------------------------------------------
        --- 停止工作 stop_working
            local button_stop_working =  root:AddChild(ImageButton(
                drone_controller_atlas,"stop_working.tex","stop_working.tex","stop_working.tex","stop_working.tex","stop_working.tex"
            ))
            button_stop_working:SetOnClick(function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_com_drone_leader.commmand","stop_working")
            end)
            button_stop_working:SetScale(MainScale,MainScale,MainScale)
            button_stop_working.focus_scale = {1.05, 1.05, 1.05}
            button_stop_working:SetPosition(button_pos[3].x,button_pos[3].y)
            CreateIconText(button_stop_working,"解除项链")
        -----------------------------------------------------------------------------------
        --- 落地打包 trans_2_item
            local button_trans_2_item =  root:AddChild(ImageButton(
                drone_controller_atlas,"trans_2_item.tex","trans_2_item.tex","trans_2_item.tex","trans_2_item.tex","trans_2_item.tex"
            ))
            button_trans_2_item:SetOnClick(function()
                ThePlayer.replica.hoshino_com_rpc_event:PushEvent("hoshino_com_drone_leader.commmand","trans_2_item")
                root:Hide()
                ___front_root:Hide()
            end)
            button_trans_2_item:SetScale(MainScale,MainScale,MainScale)
            button_trans_2_item.focus_scale = {1.05, 1.05, 1.05}
            button_trans_2_item:SetPosition(button_pos[4].x,button_pos[4].y)
            CreateIconText(button_trans_2_item,"落地打包")
        -----------------------------------------------------------------------------------
        return root
    end
    local function ButtonInstall(inst)
        local front_root = inst.HUD

        --------------------------------------------------------------------------
        --- 创建根节点
            local root = front_root:AddChild(Widget())
            root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(1000,500)
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        --------------------------------------------------------------------------
        -------- 启动坐标跟随缩放循环任务，缩放的时候去到指定位置。官方好像没预留这类API，或者暂时找不到方法
            function root:LocationScaleFix()
                if self.x_percent and not self.__mouse_holding  then
                    local scrnw, scrnh = TheSim:GetScreenSize()
                    if self.____last_scrnh ~= scrnh then
                        local tarX = self.x_percent * scrnw
                        local tarY = self.y_percent * scrnh
                        self:SetPosition(tarX,tarY)
                    end
                    self.____last_scrnh = scrnh
                end
            end
            
            root.x_percent,root.y_percent = GetHUDLoation()
            root:LocationScaleFix()    
            root.inst:DoPeriodicTask(2,function()
                root:LocationScaleFix()
            end)
        --------------------------------------------------------------------------
        ---- 鼠标拖动
            local old_OnMouseButton = root.OnMouseButton
            root.OnMouseButton = function(self,button, down, x, y)
                if down and button == MOUSEBUTTON_RIGHT then

                    if not root.__mouse_holding  then
                        root.__mouse_holding = true      --- 上锁
                            --------- 添加鼠标移动监听任务
                            root.___follow_mouse_event = TheInput:AddMoveHandler(function(x, y)  
                                root:SetPosition(x,y,0)
                            end)
                            --------- 添加鼠标按钮监听
                            root.___mouse_button_up_event = TheInput:AddMouseButtonHandler(function(button, down, x, y) 
                                if button == MOUSEBUTTON_RIGHT and down == false then    ---- 左键被抬起来了
                                    root.___mouse_button_up_event:Remove()       ---- 清掉监听
                                    root.___mouse_button_up_event = nil

                                    root.___follow_mouse_event:Remove()          ---- 清掉监听
                                    root.___follow_mouse_event = nil

                                    root:SetPosition(x,y,0)                      ---- 设置坐标
                                    root.__mouse_holding = false                 ---- 解锁

                                    local scrnw, scrnh = TheSim:GetScreenSize()
                                    root.x_percent = x/scrnw
                                    root.y_percent = y/scrnh

                                    -- owner:PushEvent("loramia_wellness_bars.save_cmd",{    --- 发送储存坐标。
                                    --     pt = {x_percent = root.x_percent,y_percent = root.y_percent},
                                    -- })
                                    SetHUDLoation(root.x_percent,root.y_percent)

                                end
                            end)
                    end

                end
                return old_OnMouseButton(self,button, down, x, y)
            end
        --------------------------------------------------------------------------
        ---- 按钮
            local button_phone = root:AddChild(ImageButton(
                drone_controller_atlas,"controller.tex","controller.tex","controller.tex","controller.tex","controller.tex"
            ))
            local button_scale = 0.5
            button_phone:SetScale(button_scale,button_scale,button_scale)
            button_phone:SetOnClick(function()
                if root.pad_hud and root.pad_hud.inst:IsValid() then
                    root.pad_hud:Kill()
                    root.pad_hud = nil
                else
                    root.pad_hud = CreatePAD(root)
                end
                root.inst:PushEvent("clicked")
            end)
        --------------------------------------------------------------------------
        --- 按钮图标
            -- local icon = button_phone.image:AddChild(Image("images/inventoryimages/hoshino_building_white_drone_item.xml","hoshino_building_white_drone_item.tex"))
            -- icon:SetScale(0.7,0.7,0.7)
            -- icon:SetRotation(30)
            -- icon:SetPosition(1,5,0)
            -- button_phone.icon = icon
        --------------------------------------------------------------------------
        --- 扫描遍历,没有无人机的时候，自动销毁界面
            local function need_2_remove_task_fn()
                local need_2_remove_flag = true
                local new_table = {}
                for drone, v in pairs(ThePlayer.HOSHINO_DRONES) do
                    if drone and drone:IsValid() then
                        need_2_remove_flag = false
                        new_table[drone] = true
                    end
                end
                if need_2_remove_flag then
                    root:Kill()
                    ThePlayer.HOSHINO_DRONES = new_table
                end
            end
            root.inst:DoPeriodicTask(0.5,need_2_remove_task_fn)
        --------------------------------------------------------------------------
        return root
    end
    local function Client_Side_Code_UI(inst,player)
        if ThePlayer and ThePlayer == player and ThePlayer.HUD then
            ThePlayer.HOSHINO_DRONES = ThePlayer.HOSHINO_DRONES or {}
            ThePlayer.HOSHINO_DRONES[inst] = true
            ---- 安装无人机 控制器按钮
            if ThePlayer.HOSHINO_DRONES_LITTLE_SMART_PHONE and ThePlayer.HOSHINO_DRONES_LITTLE_SMART_PHONE.inst:IsValid() then
                --- PASS
            else
                ThePlayer.HOSHINO_DRONES_LITTLE_SMART_PHONE = ButtonInstall(ThePlayer)
            end
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 客户端代码
    local function Client_Side_Code(inst)
        inst:ListenForEvent("_linked_player",function()
            inst:DoTaskInTime(0,function()
                local player = inst._linked_player:value()
                if player and player:HasTag("player") then
                    inst.player = player
                    Client_Side_Code_UI(inst,player)
                end
            end)
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 服务端代码
    local command = {
        ---------------------------------------------------------------
        --- 停止攻击
            ["stop_attack"] = function(inst)
                print("无人机控制命令：停止攻击")
                inst:SetTarget(nil,true)
            end,
        ---------------------------------------------------------------
        --- 解除攻击
            ["disarm"] = function(inst)
                print("无人机控制命令：解除攻击")
                local item = inst.components.container:DropItemBySlot(21)
                local player = inst:GetPlayer()
                if item and item:IsValid() and player and player:IsValid() then
                    player.components.inventory:GiveItem(item)
                end
            end,
        ---------------------------------------------------------------
        --- 停止工作
            ["stop_working"] = function(inst)
                print("无人机控制命令：停止工作")
                local item = inst.components.container:DropItemBySlot(22)
                local player = inst:GetPlayer()
                if item and item:IsValid() and player and player:IsValid() then
                    player.components.inventory:GiveItem(item)
                end
            end,
        ---------------------------------------------------------------
        --- 打包成盒
            ["trans_2_item"] = function(inst)
                print("无人机控制命令：打包成盒")
            end,
        ---------------------------------------------------------------
    }
    local function Server_Side_Code(inst)
        inst:ListenForEvent("command",function(_,cmd)
            local fn = command[tostring(cmd)]
            if fn then
                fn(inst)
            end
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    if not TheNet:IsDedicated() then
        -- 客户端代码
        Client_Side_Code(inst)
    end
    if TheWorld.ismastersim then
        -- 服务端代码
        Server_Side_Code(inst)
    end
end