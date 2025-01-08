--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    弱视系统


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
-- 
    local main_mask = nil
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0,function()
        if inst == ThePlayer and inst.HUD then
            inst:ListenForEvent("hoshino_event.amblyopia_active_client",function(_,active_flag)
                if active_flag and main_mask == nil then
                    --------------------------------------------------------------------------------
                    --- 前置节点
                        local front_root = ThePlayer.HUD
                    --------------------------------------------------------------------------------
                    --- 根节点
                        local root = front_root:AddChild(Widget())
                        root:SetHAnchor(0) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
                        root:SetVAnchor(0) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
                        root:SetPosition(0,0)
                        root:MoveToBack()
                        root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
                        root:SetClickable(false)
                        root.inst:DoPeriodicTask(3,function()
                            root:MoveToBack()
                        end)
                    --------------------------------------------------------------------------------
                    --  
                        local scale = 0.7
                        local temp_mask = root:AddChild(Image())
                        temp_mask:SetTexture("images/widgets/hoshino_amblyopia_mask.xml","hoshino_amblyopia_mask.tex")
                        temp_mask:SetPosition(0,0)
                        temp_mask:Show()
                        temp_mask:SetScale(scale,scale,scale)
                        temp_mask:SetTint(1,1,1,0.85)
                    --------------------------------------------------------------------------------
                    -- 
                        main_mask = root
                    --------------------------------------------------------------------------------
                elseif main_mask and not active_flag then
                    main_mask:Kill()
                    main_mask = nil       
                end
            end)
        end
    end)

    if not TheWorld.ismastersim then
        return
    end


    inst:ListenForEvent("hoshino_event.amblyopia_active",function(_,active_flag)
        if active_flag then
            inst.components.hoshino_cards_sys:Set("amblyopia_active",true)
            inst.components.hoshino_com_rpc_event:PushEvent("hoshino_event.amblyopia_active_client",true)
        else
            inst.components.hoshino_cards_sys:Set("amblyopia_active",false)
            inst.components.hoshino_com_rpc_event:PushEvent("hoshino_event.amblyopia_active_client",false)
        end
    end)
    inst.components.hoshino_cards_sys:AddOnLoadFn(function()
        if inst.components.hoshino_cards_sys:Get("amblyopia_active") then
            inst:DoTaskInTime(1,function()
                inst:PushEvent("hoshino_event.amblyopia_active",true)                
            end)
        end
    end)

end