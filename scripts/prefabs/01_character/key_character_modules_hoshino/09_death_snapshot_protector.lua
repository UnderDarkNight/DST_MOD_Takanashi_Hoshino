--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

27、【金】【救命稻草】
【赠送buff：仅一次，受到致命伤的时候保留一点生命，并随机传送一次，恢复10%血量，并消耗掉buff】
【叠加buff层数】

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 传送并恢复玩家血量
    local function GetRandomPos()
        local centers = {}
		for i, node in ipairs(TheWorld.topology.nodes) do
			if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then
				table.insert(centers, {x = node.x, z = node.y})
			end
		end
		if #centers > 0 then
			local pos = centers[math.random(#centers)]
			return Vector3(pos.x, 0, pos.z)
		else
            --- 上面失败，则返回绚丽之门位置
            local door = TheSim:FindFirstEntityWithTag("multiplayer_portal")
			if door then
                return Vector3(door.Transform:GetWorldPosition())
            end
		end
        return nil
    end
    local function Active_Trans(inst)
        inst.components.health:SetPercent(0.1)
        local pos = GetRandomPos()
        if pos then
            inst.components.playercontroller:RemotePausePrediction(3)   --- 暂停远程预测。  --- 暂停10帧预测
            inst.Transform:SetPosition(pos.x,0,pos.z)
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("minhealth",function()        
        if inst.components.hoshino_com_debuff:Get_Death_Snapshot_Protector() > 0 then
           inst.components.hoshino_com_debuff:Add_Death_Snapshot_Protector(-1)
           Active_Trans(inst)
        end
    end)
end