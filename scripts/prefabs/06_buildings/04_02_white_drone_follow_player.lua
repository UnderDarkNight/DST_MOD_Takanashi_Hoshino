----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    跟随玩家系统

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 参数
    local CLOSE_DISTANCE = 6
    local CLOSE_DISTANCE_SQ = CLOSE_DISTANCE * CLOSE_DISTANCE
    local FOLLOW_SPEED = 8
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- API
    --- 跟随玩家
    local function following_player_task(inst)
        local player = inst:GetPlayer()
        if player == nil then
            inst:Remove()
            return
        end
        if inst.components.fueled:IsEmpty() then
            return
        end
        if inst:HasTag("flying") and not inst:IsBusy() and inst:GetDistanceSqToInst(player) > CLOSE_DISTANCE_SQ then
            inst.components.projectile:Throw(inst,player,player)
        end
    end
    --- 离开 加载范围后，自动回到玩家身边
    local function entitysleep_event_fn(inst)
        local player = inst:GetPlayer()
        if player then
            inst.Transform:SetPosition(player.Transform:GetWorldPosition())
        end
    end
    --- 链接玩家
    local function link_fn(inst,player)
        inst.player = player
        player.components.hoshino_com_drone_leader:AddDrone(inst)
    end
    --- GetPlayer
    local function GetPlayer(inst)
        if inst.player and inst.player:IsValid() then
            return inst.player
        end
        return nil
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:ListenForEvent("link",link_fn)
    inst:DoPeriodicTask(FRAMES*2,following_player_task)
    inst:ListenForEvent("entitysleep",entitysleep_event_fn)
    inst:SetSpeed(FOLLOW_SPEED + math.random(20)/10)
    inst.components.projectile:SetHitDist(math.random(15,40)/10)

    inst.GetPlayer = GetPlayer

    inst:DoTaskInTime(2,function()
        if inst:GetPlayer() == nil then
            inst:Remove()
        end
    end)

    inst:ListenForEvent("trans_2_item",function()
        local player = inst:GetPlayer()
        if player then
            player.components.hoshino_com_drone_leader:RemoveDroneByGUID(inst.GUID)
        end
    end)
end
