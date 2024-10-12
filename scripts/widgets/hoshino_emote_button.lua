--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面调试
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"


    local Screen = require "widgets/screen"

    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local TextButton = require "widgets/textbutton"
    local UIAnimButton = require "widgets/uianimbutton"

    local Button = require "widgets/button"

    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"

    local Badge = require "widgets/badge"

    local SkinsPuppet = require "widgets/skinspuppet"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 参数表
    local base_emote = {
        ["rude"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_waving4",true)
            root:SetPosition(0,-28,0)
        end,
        ["annoyed"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_annoyed",true)
            root:SetPosition(0,-28,0)
        end,
        ["sad"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_sad",true)
            root:SetPosition(0,-28,0)
            local fx = root:AddChild(UIAnim())
            fx:GetAnimState():SetBank("tears_fx")
            fx:GetAnimState():SetBuild("tears")
            fx:GetAnimState():PlayAnimation("tears_fx",true)
            fx:SetScale(0.2)
            fx:SetPosition(0,80,0)
        end,
        ["joy"] = function(root,AnimState)
            AnimState:PlayAnimation("research",true)
            root:SetPosition(0,-28,0)
        end,
        ["facepalm"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_facepalm",true)
            root:SetPosition(0,-28,0)
        end,
        ["wave"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_waving1")
            AnimState:PushAnimation("emoteXL_waving2")
            AnimState:PushAnimation("emoteXL_waving3",true)
            root:SetPosition(0,-28,0)
        end,
        ["dance"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_pre_dance0")
            AnimState:PushAnimation("emoteXL_loop_dance0",true)
            root:SetPosition(0,-28,0)
        end,
        ["pose"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_strikepose",true)
            root:SetPosition(0,-28,0)
        end,
        ["kiss"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_kiss",true)
            root:SetPosition(0,-28,0)
        end,
        ["bonesaw"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_bonesaw",true)
            root:SetPosition(0,-28,0)
        end,
        ["happy"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_happycheer",true)
            root:SetPosition(0,-28,0)
        end,
        ["angry"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_angry",true)
            root:SetPosition(0,-28,0)
        end,
        ["sit"] = function(root,AnimState)
            if math.random() < 0.5 then
                AnimState:PlayAnimation("emote_pre_sit2",false)
                AnimState:PushAnimation("emote_loop_sit2",true)
            else
                AnimState:PlayAnimation("emote_pre_sit4",false)
                AnimState:PushAnimation("emote_loop_sit4",true)
            end
            root:SetPosition(0,-25,0)
        end,
        ["squat"] = function(root,AnimState)
            if math.random() < 0.5 then
                AnimState:PlayAnimation("emote_pre_sit1",false)
                AnimState:PushAnimation("emote_loop_sit1",true)
            else
                AnimState:PlayAnimation("emote_pre_sit3",false)
                AnimState:PushAnimation("emote_loop_sit3",true)
            end
            root:SetPosition(0,-25,0)
        end,
        ["toast"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_pre_toast",false)
            AnimState:PushAnimation("emote_loop_toast",true)
            root:SetPosition(0,-28,0)
        end,
    }
    local other_emote = {
        ["sleepy"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_sleepy",true)
            root:SetPosition(0,-28,0)
        end,
        ["yawn"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_yawn",true)
            root:SetPosition(0,-28,0)
        end,
        ["swoon"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_swoon",true)
            root:SetPosition(0,-28,0)
        end,
        ["chicken"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_loop_dance6",true)
            root:SetPosition(0,-28,0)
        end,
        ["robot"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_loop_dance8",true)
            root:SetPosition(0,-28,0)
        end,
        ["step"] = function(root,AnimState)
            AnimState:PlayAnimation("emoteXL_loop_dance7",true)
            root:SetPosition(0,-28,0)
        end,
        ["fistshake"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_fistshake",true)
            root:SetPosition(0,-28,0)
        end,
        ["flex"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_flex",true)
            root:SetPosition(0,-28,0)
        end,
        ["impatient"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_impatient",true)
            root:SetPosition(0,-28,0)
        end,
        ["cheer"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_jumpcheer",true)
            root:SetPosition(0,-28,0)
        end,
        ["laugh"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_laugh",true)
            root:SetPosition(0,-28,0)
        end,
        ["shrug"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_shrug",true)
            root:SetPosition(0,-28,0)
        end,
        ["slowclap"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_slowclap",true)
            root:SetPosition(0,-28,0)
        end,
        ["carol"] = function(root,AnimState)
            AnimState:PlayAnimation("emote_loop_carol",true)
            root:SetPosition(0,-28,0)
        end,
    }
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local EmoteButton = Class(Button, function(self,emote_name,tar_player_inst,on_click_fn)
    Button._ctor(self, "EmoteButton")

    local button = self
    local text_color = {255/255,255/255,255/255,1}
    local frame_color = {102/255,51/255,0/255,255/255}

    button.bg = button:AddChild(Image("images/avatars.xml", "avatar_bg.tex"))
    button.puppetframe = button:AddChild(Image("images/avatars.xml", "avatar_frame_white.tex"))
    button.puppetframe:SetTint(unpack(frame_color))

    ---------------------------------------------------------------------------------
    --- 指示器
        local emotename = emote_name or "dance"
        button.txtbg = button:AddChild(Image("images/widgets/gesture_bg.xml", "gesture_bg.tex"))
        button.txtbg:SetScale(.11*(emotename:len()+1),.5,0)
        button.txtbg:SetPosition(-.5,-28,0)
        button.txtbg:SetTint(unpack(frame_color))

        local text = button:AddChild(Text(NUMBERFONT, 28,nil,text_color))
        text:SetHAlign(ANCHOR_MIDDLE)
        text:SetPosition(3.5, -50, 0)
        text:SetScale(1,.78,1)
        text:SetString("/"..emotename)

        self.text_box = {}
        self.text_box.text = text
        self.text_box.bg = button.txtbg
    ---------------------------------------------------------------------------------
    -- 角色外观
        local tar_prefab = tar_player_inst and tar_player_inst.prefab or nil
        local prefab = PrefabExists(tar_prefab) and tar_prefab or ThePlayer.prefab
        -- print("info EmoteButton prefab",prefab)
        local prefabname = nil
        if not table.contains(DST_CHARACTERLIST, prefab) and not table.contains(MODCHARACTERLIST, prefab) then
            prefabname = "wilson"
        else
            prefabname = prefab
        end                        
        button.puppet = button:AddChild(SkinsPuppet())
        button.puppet:SetClickable(false)
        button.puppet.animstate:SetBank("wilson")
        button.puppet.animstate:Hide("ARM_carry")
        local data = TheNet:GetClientTableForUser(tar_player_inst and tar_player_inst.userid or ThePlayer.userid)
        if data == nil then
            data = TheNet:GetClientTableForUser(ThePlayer.userid)
        end
        button.puppet:SetSkins(
            prefabname,
            data.base_skin,
            {	body = data.body_skin,
                hand = data.hand_skin,
                legs = data.legs_skin,
                feet = data.feet_skin	},
            true)

        -- print(button.puppet.animstate)
        if base_emote[emotename] then
            base_emote[emotename](button.puppet,button.puppet.animstate)
        elseif other_emote[emotename] then
            other_emote[emotename](button.puppet,button.puppet.animstate)
        end
    ---------------------------------------------------------------------------------
    ---
        on_click_fn = on_click_fn or function()        end
        self:SetOnClick(on_click_fn)
    ---------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------

end)

function EmoteButton:SetTint(...)
    self.puppetframe:SetTint(...)
    self.txtbg:SetTint(...)
end

function EmoteButton:GetData()
    return base_emote,other_emote
end


return EmoteButton