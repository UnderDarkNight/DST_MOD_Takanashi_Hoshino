------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【趋吉避凶】当你选择诅咒牌时，真正的诅咒会被高亮标出（选择后从卡牌移除）

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player
        -----------------------------------------------------
        -- 通过net间断下发目标，确保不会出现event安装失败的情况
            inst.__net_target:set(player)
            inst:DoPeriodicTask(5,function()
                if inst.__net_target:value() == player then
                    inst.__net_target:set(inst)
                else
                    inst.__net_target:set(player)
                end
            end)
        -----------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function ExtendDebuff(inst)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local Widget = require "widgets/widget"
    local Image = require "widgets/image"
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local function CreateBlackCardWarning(inst)
        if inst.__warning_event_installed_flag then
            return
        end
        inst.__warning_event_installed_flag = true
        inst:ListenForEvent("hoshino_event.cards_selectting_box_created_in_pad",function(inst,cards)
            local cards_data = ThePlayer.PAD_DATA and ThePlayer.PAD_DATA.cards
            if not(type(cards_data) == "table" and #cards_data == #cards )then
                return
            end
            for i=1,#cards_data do
                if cards_data[i].is_curse_card then
                    local card_node = cards[i]
                    local icon = card_node:AddChild(UIAnim())
                    -- icon:GetAnimState():SetBank("charliesnap")
                    -- icon:GetAnimState():SetBuild("charliesnap")
                    -- icon:GetAnimState():PlayAnimation("snap",true)
                    icon:GetAnimState():SetBank("statue_ruins_fx")
                    icon:GetAnimState():SetBuild("statue_ruins_fx")
                    icon:GetAnimState():PlayAnimation("transform_nightmare",true)
                    local scale = 0.5
                    icon:SetScale(scale,scale,scale)
                    icon:SetPosition(0,-100,0)
                end
            end
        end,ThePlayer)
    end
    local function hud_event_install(inst)
        local net_target = inst.__net_target:value()
        if ThePlayer and net_target == ThePlayer and ThePlayer.HUD then
            CreateBlackCardWarning(inst)
        end
    end
------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst:AddTag("CLASSIFIED")
    inst.entity:SetPristine()
    inst.__net_target = net_entity(inst.GUID,"net_target","net_target")
    if not TheNet:IsDedicated() then
        inst:ListenForEvent("net_target",hud_event_install)
    end
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    return inst
end

return Prefab("hoshino_card_debuff_seek_good_avoid_bad", fn)
