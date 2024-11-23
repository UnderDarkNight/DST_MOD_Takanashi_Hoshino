-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    inventory_classified 添加event ,用来对 物品 pushevent

    物品 带 tag  hoshino_tag.cursor_sight 就能激活

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 坐标读取
    local function GetHUDLoation()
        local data = TUNING.HOSHINO_FNS:Get_ThePlayer_Cross_Archived_Data("little_smart_phone_location")
        if data == nil then
            return 0.5,0.5
        else
            return data.x,data.y
        end
    end
    local function SetHUDLoation(x,y)
        TUNING.HOSHINO_FNS:Set_ThePlayer_Cross_Archived_Data("little_smart_phone_location",{x = x,y = y})
    end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local atlas = "images/inspect_pad/little_smart_phone.xml"
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
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
        ---- 用来回环的event
            local smart_phone_widget = {
                widget = nil,
            }
            local function Is_Smart_Phone_Openning()
                if smart_phone_widget.widget and smart_phone_widget.widget.inst:IsValid() then
                    return true
                end
                return false
            end
        --------------------------------------------------------------------------
        ----
            local button_phone = root:AddChild(ImageButton(
                atlas,"button_phone.tex","button_phone.tex","button_phone.tex","button_phone.tex","button_phone.tex"
            ))
            local button_scale = 0.8
            button_phone:SetScale(button_scale,button_scale,button_scale)
            button_phone:SetOnClick(function()
                -- print("button_phone clicked")
                -- if ThePlayer.___test_phone_fn then
                --     ThePlayer.___test_phone_fn()
                -- end
                ThePlayer:PushEvent("hoshino_event.little_smart_phone_open",smart_phone_widget)
                root.inst:PushEvent("clicked")
            end)
        --------------------------------------------------------------------------
        --- 警示图标
            local warnning_arrow = root:AddChild(UIAnim())
            local arrow_anim = warnning_arrow:GetAnimState()
            arrow_anim:SetBuild("hoshino_self_inspect_button_warning")
            arrow_anim:SetBank("hoshino_self_inspect_button_warning")
            arrow_anim:PlayAnimation("idle",true)
            warnning_arrow:Hide()
            warnning_arrow:SetClickable(false)
            local arrow_scale = 1
            warnning_arrow:SetScale(arrow_scale,arrow_scale,arrow_scale)
            root.inst:ListenForEvent("clicked",function(inst)
                warnning_arrow:Hide()
            end)
            root.inst:ListenForEvent("hoshino_event.little_smart_phone_warnning",function()
                if not Is_Smart_Phone_Openning() then
                    warnning_arrow:Show()
                end
            end,ThePlayer)
            root.inst:ListenForEvent("onremove",function()
                warnning_arrow:Kill()
            end)
        --------------------------------------------------------------------------
        ---
            -- local old_update = root.Update or function() end
            -- root.Update = function(self,dt,...)
            --     warnning_arrow:SetPosition(self:GetLocalPosition())
            --     old_update(self,dt,...)
            -- end
            -- root.OnUpdate = root.Update
            -- root:StartUpdating()
            -- root.inst:ListenForEvent("onremove",function()
            --     root:StopUpdating()
            -- end)
        --------------------------------------------------------------------------

    end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPlayerPostInit(function(inst)
    if inst.prefab == "hoshino" then
        return
    end
    inst:DoTaskInTime(1,function()
        if inst == ThePlayer and inst.HUD then
            ButtonInstall(inst)
        end
    end)
    inst:ListenForEvent("hoshino_event.pad_warnning",function(inst,index)
        inst.components.hoshino_com_rpc_event:PushEvent("hoshino_event.little_smart_phone_warnning")
    end)
end)