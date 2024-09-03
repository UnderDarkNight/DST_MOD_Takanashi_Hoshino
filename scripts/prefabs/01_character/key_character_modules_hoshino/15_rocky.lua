--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.rockys = {}

    local item_accept_test_fn = nil
    local new_item_accept_test_fn = function(monster, item, giver, count)
        if giver ~= inst then
            return false
        end
        if item_accept_test_fn ~= nil then
            return item_accept_test_fn(monster, item, giver, count)
        end
        return false
    end

    inst:ListenForEvent("hoshino_event.create_rocky",function()
        local x,y,z = inst.Transform:GetWorldPosition()

        -------------------------------------------------------
        --- 创建石虾
            local rocky = SpawnPrefab("rocky")
            rocky.Transform:SetPosition(x+1,y+1,z)
            table.insert(inst.rockys,rocky)
            rocky.owner = inst
        -------------------------------------------------------
        --- 喂食石虾
            rocky.components.follower.neverexpire = true
            rocky.components.trader:AcceptGift(inst,SpawnPrefab("rocks"),1)
        -------------------------------------------------------
        --- 修改物品接受函数，防止被其他玩家拐走
            if item_accept_test_fn == nil then
                item_accept_test_fn = rocky.components.trader.test
            end
            rocky.components.trader.test = new_item_accept_test_fn
        -------------------------------------------------------

    end)

    inst:ListenForEvent("player_despawn",function()
        for i,monster in ipairs(inst.rockys) do
            if monster and monster:IsValid() then
                inst.components.hoshino_data:Add("rocky_by_card",1)
                monster:Remove()
            end
        end
    end)
    inst:DoTaskInTime(1,function()
        local rocky_num = inst.components.hoshino_data:Add("rocky_by_card",0)
        if rocky_num > 0 then
            for i = 1, rocky_num, 1 do
                inst:PushEvent("hoshino_event.create_rocky")
            end
            inst.components.hoshino_data:Set("rocky_by_card",0)
        end
    end)



end