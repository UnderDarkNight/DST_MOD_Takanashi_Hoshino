--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    hoshino_building_shop24_level_1
    hoshino_building_shop24_level_2
    hoshino_building_shop24_level_3
    ....

]]---
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function Add_Tag_2_Player(inst,player) -- 给玩家添加标签
        local level = TheWorld.components.hoshino_com_shop_items_pool:GetLevel()
        for i = 1, level, 1 do
            player.components.hoshino_com_tag_sys:AddTag("hoshino_building_shop24_level_"..i)
        end
    end
    local function Remove_Tag_From_Player(inst,player) -- 给玩家移除标签
        for i = 1, 20, 1 do
            player.components.hoshino_com_tag_sys:RemoveTag("hoshino_building_shop24_level_"..i)
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local DIS_NEAR = 3
    local DIS_FAR = 4
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)

    local playerprox = inst:AddComponent("playerprox")
    inst.components.playerprox:SetPlayerAliveMode(playerprox.AliveModes.DeadOrAlive) -- 玩家无论死或生
    inst.components.playerprox:SetTargetMode(playerprox.TargetModes.AllPlayers)
    inst.components.playerprox:SetDist(DIS_NEAR, DIS_FAR)
    inst.components.playerprox:SetOnPlayerNear(function(inst,player)
        print("player near",inst,player)
        if player and player.prefab == "hoshino" then
            Add_Tag_2_Player(inst,player)
        end
    end)
    inst.components.playerprox:SetOnPlayerFar(function(inst,player)
        print("player far",inst,player)
        if player and player.prefab == "hoshino" then
            Remove_Tag_From_Player(inst,player)
        end
    end)

    inst:ListenForEvent("shop24_level_update",function()
        local x,y,z = inst.Transform:GetWorldPosition()
        local players = TheSim:FindEntities(x,0,z,DIS_FAR,{"player"})
        for _,player in pairs(players) do
            if player.prefab == "hoshino" then
                Remove_Tag_From_Player(inst,player)
                inst:DoTaskInTime(1,function()
                    Add_Tag_2_Player(inst,player)                    
                end)
            end
        end
    end)

end