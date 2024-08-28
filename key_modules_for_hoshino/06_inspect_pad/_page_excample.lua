    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


    平板

    

]]---
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
    TUNING.HOSHINO_INSPECT_PAD_FNS = TUNING.HOSHINO_INSPECT_PAD_FNS or{}    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function page_create(front_root,MainScale)
            --------------------------------------------------------------------------------------
            --- 根节点
                local page = front_root:AddChild(Widget())
            --------------------------------------------------------------------------------------
            ---
                return page
            --------------------------------------------------------------------------------------

end
TUNING.HOSHINO_INSPECT_PAD_FNS["character"] = page_create
