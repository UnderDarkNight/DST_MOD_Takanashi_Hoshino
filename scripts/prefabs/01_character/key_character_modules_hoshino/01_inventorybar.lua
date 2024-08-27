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
            SetAutopaused(false)
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
        SetAutopaused(true)
        inst.HUD:OpenScreenUnderPause(root)

        inst:PushEvent("hoshino_event.inspect_hud_open",root)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0,function()
        local inventorybar = ThePlayer == inst and inst.HUD and ThePlayer.HUD.controls.inv
        if inventorybar then

            -- local old_Rebuild = inventorybar.Rebuild
            -- inventorybar.Rebuild = function(self,...)
            --     old_Rebuild(self,...)
            --     if self.inspectcontrol then
            --         self.inspectcontrol:

            --     end
            -- end


            inst.HUD.InspectSelf = function(self)
                if self:IsVisible() and self.owner.components.playercontroller:IsEnabled() then
                    CreateInspectHUD(inst)
                    return true
                end
            end

        end
    end)
end