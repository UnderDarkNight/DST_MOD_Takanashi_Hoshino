--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local Widget = require "widgets/widget"
    local Screen = require "widgets/screen"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    -- local SCREEN_OFFSET = 0.15 * RESOLUTION_X
    local function Get_SCREEN_OFFSET()
        -- if ThePlayer and ThePlayer._SCREEN_OFFSET then
        --     return ThePlayer._SCREEN_OFFSET
        -- end
        return 0.4 * RESOLUTION_X
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function CreateInspectHUD(inst)
        local front_root = inst.HUD

        local root = front_root:AddChild(Screen())

        local black = root:AddChild(ImageButton("images/global.xml", "square.tex"))
        black.image:SetVRegPoint(ANCHOR_MIDDLE)
        black.image:SetHRegPoint(ANCHOR_MIDDLE)
        black.image:SetVAnchor(ANCHOR_MIDDLE)
        black.image:SetHAnchor(ANCHOR_MIDDLE)
        black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
        black.image:SetTint(0,0,0,.5)    
        black:SetHelpTextMessage("")

        root.button_close_fn = function()
            TheFrontEnd:PopScreen()
            TheCamera:PopScreenHOffset(root, Get_SCREEN_OFFSET())
            -- SetAutopaused(false)
            root:Kill()
        end

        inst:DoTaskInTime(10/30,function()
            black:SetOnClick(function()
                -- root.button_close_fn()
                root.inst:PushEvent("pad_close")
            end)
        end)
        root.inst:ListenForEvent("pad_close",root.button_close_fn)

        TheCamera:PushScreenHOffset(root, Get_SCREEN_OFFSET())
        -- SetAutopaused(true)
        inst.HUD:OpenScreenUnderPause(root)

        inst:PushEvent("hoshino_event.inspect_hud_open",root)
        --- opening flag
        inst.hoshino_inspect_hud_opening = true
        root.inst:ListenForEvent("pad_close",function()
            inst.hoshino_inspect_hud_opening = false
        end)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function Hook_Inspect_Button(inst)
        ------------------------------------------------------------------------------------------------
        ---
            local function arrow_create()  --- 创建警示箭头
                local inventorybar = ThePlayer == inst and inst.HUD and ThePlayer.HUD.controls.inv
                if inventorybar then
                    local inspect_button = inventorybar.inspectcontrol
                    if inspect_button then               
                        local arrow = inspect_button:AddChild(UIAnim())
                        local arrow_anim = arrow:GetAnimState()
                        arrow_anim:SetBuild("hoshino_self_inspect_button_warning")
                        arrow_anim:SetBank("hoshino_self_inspect_button_warning")
                        arrow_anim:PlayAnimation("idle",true)
                        arrow:Hide()
                        inst:ListenForEvent("hoshino_event.inspect_hud_warning",function(_,flag)
                            if flag and not ThePlayer.hoshino_inspect_hud_opening then
                                arrow:Show()
                            else
                                arrow:Hide()
                            end
                        end)
                        return true
                    end
                end
                return false
            end

            if not arrow_create() then
                inst.___inspect_button_task = inst:DoPeriodicTask(1,function()
                    if arrow_create() then
                        inst.___inspect_button_task:Cancel()
                        inst.___inspect_button_task = nil
                    end
                end)
            end
        ------------------------------------------------------------------------------------------------
        --- 
            inst.HUD.InspectSelf = function(self)
                if self:IsVisible() and self.owner.components.playercontroller:IsEnabled() then
                    CreateInspectHUD(inst)
                    inst:PushEvent("hoshino_event.inspect_hud_warning",false)
                    return true
                end
            end
        ------------------------------------------------------------------------------------------------
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0,function()
        if ThePlayer == inst and inst.HUD then
            Hook_Inspect_Button(inst)
            inst:ListenForEvent("hoshino_event.inspect_pad_open_by_force",function() -- 服务器强制打开界面
                inst.HUD:InspectSelf()
            end)
        end
    end)

    inst:DoTaskInTime(3,function()
        if not TheWorld.ismastersim then
            return
        end
        if not inst.components.hoshino_data:Get("hoshino_self_inspect_button_first_warning") then
            inst.components.hoshino_data:Set("hoshino_self_inspect_button_first_warning",true)
            inst.components.hoshino_com_rpc_event:PushEvent("hoshino_event.inspect_hud_warning",true)
        end
    end)


    if not TheWorld.ismastersim then
        return
    end


    inst:ListenForEvent("attacked",function()
        inst.components.hoshino_com_rpc_event:PushEvent("hoshino_event.attacked")
    end)

end