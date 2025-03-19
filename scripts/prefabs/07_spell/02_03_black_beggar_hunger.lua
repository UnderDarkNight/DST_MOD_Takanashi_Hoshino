----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    饥饿相关的模块

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local function hunger_hud_install(inst)
        -----------------------------------------------------
        --- 前置根节点
            local front_root = ThePlayer.HUD
        -----------------------------------------------------
        --- 
            local root = front_root:AddChild(Widget())
            root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(0,0)
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        -----------------------------------------------------            
        ---
            inst:ListenForEvent("onremove",function()
                root:Kill()
            end)
        -----------------------------------------------------
        --- 文字节点
            local hunger_text = root:AddChild(Text(CODEFONT,30,"󰀎100",{  255/255 , 255/255 ,255/255 , 1}))
            hunger_text:SetPosition(0,-35)
            hunger_text.show_flag_num = 0
        -----------------------------------------------------            
        --- 跟随
            TheInput:Hoshino_Add_Update_Custom_Fn(root.inst,function()
                local s_pt_x,s_pt_y= TheSim:GetScreenPos(inst.Transform:GetWorldPosition()) -- 左下角为原点。
                -- print("player in screen",s_pt_x,s_pt_y)
                root:SetPosition(s_pt_x,s_pt_y,0)
                if inst:GetDistanceSqToInst(ThePlayer) > 1.5*1.5 then
                    hunger_text:Hide()
                    hunger_text.show_flag_num = 0
                else
                    hunger_text.show_flag_num = hunger_text.show_flag_num + 1
                    if hunger_text.show_flag_num > 60 then
                        hunger_text:Show()
                        hunger_text:SetString("󰀎"..inst:GetHunger())
                    end
                end

            end)
        -----------------------------------------------------
        ---
            return root
        -----------------------------------------------------
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function SetHunger(inst,value)
        inst.__hunger:set(value)
    end
    local function GetHunger(inst)
        return inst.__hunger:value()
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    inst.__hunger = net_float(inst.GUID,"__hunger","hunger_update")
    inst.SetHunger = SetHunger
    inst.GetHunger = GetHunger

    if not TheNet:IsDedicated() then
        inst:ListenForEvent("_linked_player",function()
            local player = inst._linked_player:value()
            if ThePlayer and ThePlayer == player and ThePlayer.HUD then
                hunger_hud_install(inst)
            end
        end)
    end

    if not TheWorld.ismastersim then
        return
    end


end