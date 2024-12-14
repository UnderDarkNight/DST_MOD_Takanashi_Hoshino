------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    通过玩家身上的buff 和 net_entity 来同步玩家列表

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local MAX_PLAYERS = 20
------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.player = target
    -----------------------------------------------------
    ---
        inst:DoPeriodicTask(3,function()
            for k, v in pairs(AllPlayers) do
                inst:HOSHINO_ADD_PLAYER(v)                
            end
        end)
    -----------------------------------------------------
end

local function OnUpdate(inst)
    local player = inst.entity:GetParent()
    if player and player == ThePlayer and ThePlayer.HOSHINO_GET_ALLPLAYERS == nil then
        ThePlayer.HOSHINO_GET_ALLPLAYERS = function()
            print("info HOSHINO_GET_ALLPLAYERS in debuff")
            return inst:HOSHINO_GET_ALLPLAYERS()
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")
    inst.entity:SetPristine()
    ----------------------------------------------------------------------------------------------------------
    --- 
        local net_players = {}
        local client_side_list = {}
        for i = 1, MAX_PLAYERS, 1 do
            local temp_net = net_entity(inst.GUID,"hoshino_net_players_sync."..i,"hoshino_net_players_sync")
            table.insert(net_players,temp_net)
        end
        function inst:HOSHINO_GET_ALLPLAYERS()
            for index, net_temp in pairs(net_players) do
                local temp_player = net_temp:value()
                if temp_player then
                    -- table.insert(ret, temp_player)
                    client_side_list[temp_player] = temp_player.userid or "unkown_"..math.random(1000000)
                end
            end
            ------------------------------
            --- 洗一下，去掉userid重复的
                local temp_table = {}
                for temp_inst, userid in pairs(client_side_list) do
                    if temp_table[userid] == nil then
                        temp_table[userid] = temp_inst
                    end
                end
                local new_client_side_list = {}
                for userid, temp_player in pairs(temp_table) do
                    new_client_side_list[temp_player] = userid
                end
                client_side_list = new_client_side_list
            ------------------------------
            ---
                local ret_table = {}
                for temp_inst, userid in pairs(client_side_list) do
                    table.insert(ret_table, temp_inst)
                end
            ------------------------------
            return ret_table, client_side_list
        end
        function inst:HOSHINO_HAS_PLAYER(player)
            local _,_table = self:HOSHINO_GET_ALLPLAYERS()
            return _table[player] ~= nil
        end

        local players_list = {}
        function inst:HOSHINO_ADD_PLAYER(player)
            --------------------------------------------------
            --- 先清空list 里失效的
                local new_table = {}
                for temp_inst, flag in pairs(players_list) do
                    if temp_inst and temp_inst:IsValid() then
                        new_table[temp_inst] = flag
                    end
                end
                players_list = new_table
            --------------------------------------------------
            --- 添加新的
                players_list[player] = true
            --------------------------------------------------
            --- 从列表里最多提取 MAX_PLAYERS 个玩家
                local ret = {}
                local num = 0
                for temp_inst, flag in pairs(players_list) do
                    if temp_inst and temp_inst:IsValid() and num < MAX_PLAYERS then
                        table.insert(ret, temp_inst)
                        num = num + 1
                    end
                end
            --------------------------------------------------
            --- 同步到客户端
                for index, temp_net in pairs(net_players) do
                    if ret[index] then
                        temp_net:set(ret[index])
                    end
                end
            --------------------------------------------------
        end
    ----------------------------------------------------------------------------------------------------------
    ---
        inst:DoPeriodicTask(5,OnUpdate)
    ----------------------------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    return inst
end

return Prefab("hoshino_other_players_list_sync_debuff", fn)
