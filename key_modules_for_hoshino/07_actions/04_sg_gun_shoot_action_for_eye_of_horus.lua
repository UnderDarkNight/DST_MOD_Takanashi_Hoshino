------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    给 直接激活SG用。

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddStategraphState("wilson",State{
    name = "hoshino_sg_action_gun_shoot",
    tags = { "attack", "notalking", "abouttoattack", "autopredict" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()

        inst.AnimState:PlayAnimation("hoshino_ex_pre")
        inst.AnimState:PushAnimation("hoshino_ex_loop")
        
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil

        inst.sg.statemem.attacktarget = target

    end,
    timeline =
        {
            TimeEvent(10*FRAMES, function(inst)
                inst:PushEvent("hoshino_sg_action_gun_shoot_active",inst.sg.statemem.attacktarget)
                inst:PerformBufferedAction()
            end),
            TimeEvent(30*FRAMES, function(inst)
                inst.sg:GoToState("idle")
            end),

        },
    ontimeout = function(inst)
        -- StopTalkSound(inst)
    end,
    events =
        {
            -- EventHandler("animover", function(inst)
            --     if inst.AnimState:AnimDone() then
            --         inst.sg:GoToState("idle")
            --     end
            -- end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    onexit = function(inst)
        -- StopTalkSound(inst)
    end,
})

---------------------------------------------------------------------------------------------------------------------------------------------------------
---- 客户端上的，同 SGWilson_client.lua
    local TIMEOUT = 2
    AddStategraphState("wilson_client",State{
        name = "hoshino_sg_action_gun_shoot",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" },
        server_states = { "hoshino_sg_action_gun_shoot" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("hoshino_ex_pre")
            inst.AnimState:PushAnimation("hoshino_ex_loop")
            
            inst:PerformPreviewBufferedAction()
            inst.sg:SetTimeout(40*FRAMES)
        end,

        onupdate = function(inst)
            if inst.sg:ServerStateMatches() then
                if inst.entity:FlattenMovementPrediction() then
                    inst.sg:GoToState("idle", "noanim")
                end
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,
        timeline =
        {
            TimeEvent(30*FRAMES, function(inst)
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle")
            end),

        },

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
    })