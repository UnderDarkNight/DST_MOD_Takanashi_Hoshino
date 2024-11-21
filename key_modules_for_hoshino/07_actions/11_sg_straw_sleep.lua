
---------------------------------------------------------------------------------------------------------------------------------------------------------

local HOSHINO_SG_BEDROLL = Action({})
HOSHINO_SG_BEDROLL.id = "HOSHINO_SG_BEDROLL"
HOSHINO_SG_BEDROLL.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    return "DEFAULT"
end

HOSHINO_SG_BEDROLL.fn = function(act)    --- 只在服务端执行~
    -- local item = act.invobject
    -- local target = act.target
    -- local doer = act.doer
    return true
end
AddAction(HOSHINO_SG_BEDROLL)

AddStategraphActionHandler("wilson",ActionHandler(HOSHINO_SG_BEDROLL,function(player)
    return "hoshino_sg_bedroll"
end))
AddStategraphActionHandler("wilson_client",ActionHandler(HOSHINO_SG_BEDROLL, function(player)
    return "hoshino_sg_bedroll"
end))
---------------------------------------------------------------------------------------------------------------------------------------------------------
local function SetSleeperSleepState(inst)
    if inst.components.grue ~= nil then
        inst.components.grue:AddImmunity("sleeping")
    end
    if inst.components.talker ~= nil then
        inst.components.talker:IgnoreAll("sleeping")
    end
    if inst.components.firebug ~= nil then
        inst.components.firebug:Disable()
    end
    if inst.components.playercontroller ~= nil then
        inst.components.playercontroller:EnableMapControls(false)
        inst.components.playercontroller:Enable(false)
    end
    inst:OnSleepIn()
    inst.components.inventory:Hide()
    inst:PushEvent("ms_closepopups")
    inst:ShowActions(false)
end

local function SetSleeperAwakeState(inst)
    if inst.components.grue ~= nil then
        inst.components.grue:RemoveImmunity("sleeping")
    end
    if inst.components.talker ~= nil then
        inst.components.talker:StopIgnoringAll("sleeping")
    end
    if inst.components.firebug ~= nil then
        inst.components.firebug:Enable()
    end
    if inst.components.playercontroller ~= nil then
        inst.components.playercontroller:EnableMapControls(true)
        inst.components.playercontroller:Enable(true)
    end
    inst:OnWakeUp()
    inst.components.inventory:Show()
    inst:ShowActions(true)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------
--- 无法控制起床。只能外部挂载个监听。
    local temp_inst = nil
    local function add_wake_up_event_listener(inst)
        if not TheInput then
            return
        end

        local temp_inst = CreateEntity()
        temp_inst:DoPeriodicTask(FRAMES*2,function()
            if TheInput:IsControlPressed(CONTROL_MOVE_UP) 
                or TheInput:IsControlPressed(CONTROL_MOVE_DOWN) 
                or TheInput:IsControlPressed(CONTROL_MOVE_LEFT)    
                or TheInput:IsControlPressed(CONTROL_MOVE_RIGHT) then
                print("info moving key press !!")
                temp_inst:Remove()
                inst:ClearBufferedAction()
            end
        end)

    end
---------------------------------------------------------------------------------------------------------------------------------------------------------
    AddStategraphState("wilson",State{
        name = "hoshino_sg_bedroll",
        tags = { "bedroll", "busy", "nomorph","hoshino_sg_bedroll" },

        onenter = function(inst)
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("bedroll", false)
            SetSleeperSleepState(inst)

            --Hack since we've already temp unequipped hand items at this point
            --but we want to show the correct arms for action_uniqueitem_pre
            if inst._sleepinghandsitem ~= nil then
                inst.AnimState:Show("ARM_carry")
                inst.AnimState:Hide("ARM_normal")
            end

        end,

        timeline =
        {
            TimeEvent(20 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
            end),
        },

        events =
        {
            EventHandler("firedamage", function(inst)
                if inst.sg:HasStateTag("sleeping") then
                    inst.sg.statemem.iswaking = true
                    inst.sg:GoToState("wakeup")
                end
            end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    if (inst.components.health ~= nil and inst.components.health.takingfiredamage) or
                        (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
                        -- inst:PushEvent("performaction", { action = inst.bufferedaction })
                        inst:ClearBufferedAction()
                        inst.sg.statemem.iswaking = true
                        inst.sg:GoToState("wakeup")
                        -- print("waking up from wakeup +++")
                    else
                        inst:PerformBufferedAction()
                        if inst.components.playercontroller ~= nil then
                            inst.components.playercontroller:Enable(true)
                        end
                        inst.sg:AddStateTag("sleeping")
                        inst.sg:AddStateTag("silentmorph")
                        inst.sg:RemoveStateTag("nomorph")
                        inst.sg:RemoveStateTag("busy")
                        inst.AnimState:PlayAnimation("bedroll_sleep_loop", true)
                        inst:PushEvent("hoshino_event.sg_bedroll.start")
                    end
                    
                end
            end),
        },

        onexit = function(inst)
            if not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Hide("ARM_carry")
                inst.AnimState:Show("ARM_normal")
            end
            if inst.sleepingbag ~= nil then
                --Interrupted while we are "sleeping"
                inst.sleepingbag.components.sleepingbag:DoWakeUp(true)
                inst.sleepingbag = nil
                SetSleeperAwakeState(inst)
            elseif not inst.sg.statemem.iswaking then
                --Interrupted before we are "sleeping"
                SetSleeperAwakeState(inst)
            end
            inst:PushEvent("hoshino_event.sg_bedroll.stop")
        end,
    })
---------------------------------------------------------------------------------------------------------------------------------------------------------
--- client side
AddStategraphState('wilson_client', State{
    name = "hoshino_sg_bedroll",
    tags = { "bedroll", "busy", "nomorph","hoshino_sg_bedroll" },
    server_states = { "hoshino_sg_bedroll" },
    forward_server_states = true,
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("action_uniqueitem_pre")
        inst.AnimState:PushAnimation("bedroll", false)
        inst.AnimState:PushAnimation("bedroll_sleep_loop", true)

        inst:PerformPreviewBufferedAction()
    end,
    events = {
        EventHandler("animqueueover", function(inst)

        end),
        EventHandler("animover", function(inst)

        end),
    }
})
---------------------------------------------------------------------------------------------------------------------------------------------------------