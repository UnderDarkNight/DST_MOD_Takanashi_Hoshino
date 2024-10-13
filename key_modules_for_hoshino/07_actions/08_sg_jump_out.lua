
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local HOSHINO_SG_JUMP_OUT = Action({priority = 10,distance = 1000000})   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
HOSHINO_SG_JUMP_OUT.id = "HOSHINO_SG_JUMP_OUT"
HOSHINO_SG_JUMP_OUT.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    return "DEFAULT"
end

HOSHINO_SG_JUMP_OUT.fn = function(act)    --- 只在服务端执行~
    -- local item = act.invobject
    -- local target = act.target
    local doer = act.doer
    -- local pos = act.pos or {}

    if doer.components.playercontroller ~= nil then
        doer.components.playercontroller:RemotePausePrediction()
    end

    local pt = act:GetActionPoint()
    if pt then
        doer.Physics:Teleport(pt:Get())
        SpawnPrefab("crab_king_shine").Transform:SetPosition(pt:Get())
    end

    return true
end
AddAction(HOSHINO_SG_JUMP_OUT)

AddStategraphActionHandler("wilson",ActionHandler(HOSHINO_SG_JUMP_OUT,function(player)
    return "hoshino_portal_jump_out"
end))
-- AddStategraphActionHandler("wilson_client",ActionHandler(HOSHINO_COM_WORKABLE_ACTION, function(player)    
--     return handler_fn(player)
-- end))
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddStategraphState("wilson",State{
    name = "hoshino_portal_jump_out",
    tags = { "busy", "nopredict", "nomorph", "noattack", "nointerrupt" },

    onenter = function(inst, data)
        -- print("hoshino_portal_jump_out onenter")

        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("wortox_portal_jumpout")
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:RemotePausePrediction(5)
        end
        local pt = nil
        if data and data.pt then
            pt = data and data.pt
        end
        local buffaction = inst:GetBufferedAction()
        if buffaction then
            pt = buffaction:GetActionPoint()
        end
        if pt then
            inst.Physics:Teleport(pt:Get())
            SpawnPrefab("crab_king_shine").Transform:SetPosition(pt:Get())
        end
        inst.sg.statemem.target_pt = pt
    end,
    timeline =
    {
        TimeEvent(FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/hop_out")
        end),
        TimeEvent(5 * FRAMES, function(inst)

        end),
        TimeEvent(7 * FRAMES, function(inst)
            -- inst.sg:RemoveStateTag("noattack")
            inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")            
            inst:PushEvent("hoshino_portal_jump_out_end",inst.sg.statemem.target_pt)            
            -- print("hoshino_portal_jump_out_end event push",inst.sg.statemem.target_pt)
            inst.sg.statemem.target_pt = nil
        end),
        TimeEvent(8 * FRAMES, function(inst)
            inst.sg:GoToState("idle")
        end),
    },
    events =
    {
        EventHandler("animoever", function(inst)
            inst.sg:GoToState("idle")
        end),
    },
    onexit = function(inst)
    end,
})