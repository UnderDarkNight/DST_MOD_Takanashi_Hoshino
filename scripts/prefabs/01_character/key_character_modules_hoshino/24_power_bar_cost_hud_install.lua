--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 坐标读取
    local function GetHUDLoation()
        local data = TUNING.HOSHINO_FNS:Get_ThePlayer_Cross_Archived_Data("powerbar_cost_location")
        if data == nil then
            return 0.5,0.5
        else
            return data.x,data.y
        end
    end
    local function SetHUDLoation(x,y)
        TUNING.HOSHINO_FNS:Set_ThePlayer_Cross_Archived_Data("powerbar_cost_location",{x = x,y = y})
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function CreatePowerBar(inst)
        local front_root = inst.HUD.controls.status
        --------------------------------------------------------------------------
        --- 创建根节点
            local root = front_root:AddChild(Widget())
            root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(1000,500)
            root:MoveToBack()
            local scale = 0.5
            root:SetScale(scale,scale,scale)
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
                if down then

                    if not root.__mouse_holding  then
                        root.__mouse_holding = true      --- 上锁
                            --------- 添加鼠标移动监听任务
                            root.___follow_mouse_event = TheInput:AddMoveHandler(function(x, y)  
                                root:SetPosition(x,y,0)
                            end)
                            --------- 添加鼠标按钮监听
                            root.___mouse_button_up_event = TheInput:AddMouseButtonHandler(function(button, down, x, y) 
                                if button == MOUSEBUTTON_LEFT and down == false then    ---- 左键被抬起来了
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
        --- anim
            local bar = root:AddChild(UIAnim())
            local bar_animstate = bar:GetAnimState()
            bar_animstate:SetBank("hoshino_power_bar_cost")
            bar_animstate:SetBuild("hoshino_power_bar_cost")
            bar_animstate:PlayAnimation("idle",true)
            bar_animstate:Pause()
        --------------------------------------------------------------------------
        --- 动态值
            local value_text = root:AddChild(Text(CODEFONT,60,"100",{ 255/255 , 255/255 ,255/255 , 1}))
            value_text:SetPosition(3,-10)
        --------------------------------------------------------------------------
            if ThePlayer.replica.hoshino_com_power_cost then
                local param_update_fn = function()
                    local current = ThePlayer.replica.hoshino_com_power_cost:GetCurrent()
                    local max = ThePlayer.replica.hoshino_com_power_cost:GetMax()
                    local percent = current/max
                    --- 四舍五入，保留小数点后一位。
                    -- current = math.floor(current*10+0.5)/10

                    value_text:SetString(string.format("%.1f", current))
                    local precent = math.clamp(percent+0.02,0,1) --- 修正一下动画的偏差。
                    -- print("hud power bar cost percent:",current,max,precent)
                    bar_animstate:SetPercent("idle",percent) 
                end
                param_update_fn()
                ThePlayer.replica.hoshino_com_power_cost:AddUpdateFn(param_update_fn)
            end
        --------------------------------------------------------------------------
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0,function()
        if ThePlayer == inst and inst.HUD then
            CreatePowerBar(inst)
        end
    end)

end