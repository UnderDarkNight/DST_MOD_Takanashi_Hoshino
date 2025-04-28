-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    尝试通过net 进行服务器、客户端 的 玩家同步。

    【笔记】科雷更新后 加载范围外的队友 被立马移除实体，无法再获取数据。

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local MAX_PLAYERS = 20
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- AddPrefabPostInit(
--     "world",
--     function(inst)
--         ----------------------------------------------------
--         ---
--             if inst.HOSHINO_ALLPLEYERS ~= nil then
--                 return
--             end
--             inst.HOSHINO_ALLPLEYERS = Class()                
--         ----------------------------------------------------

--         ----------------------------------------------------
--             inst.HOSHINO_ALLPLEYERS.ALL_PLAYERS_IDX = {}
--             TheWorld:ListenForEvent("playerentered",function(_,player)
--                 inst.HOSHINO_ALLPLEYERS.ALL_PLAYERS_IDX[player] = true
--             end)
--             TheWorld:ListenForEvent("playerexited",function(_,player)
--                 inst.HOSHINO_ALLPLEYERS.ALL_PLAYERS_IDX[player] = nil
--                 local new_table = {}
--                 for temp_inst, flag in pairs(inst.HOSHINO_ALLPLEYERS.ALL_PLAYERS_IDX) do
--                     if temp_inst and temp_inst:IsValid() and flag then
--                         new_table[temp_inst] = flag
--                     end
--                 end
--                 inst.HOSHINO_ALLPLEYERS.ALL_PLAYERS_IDX = new_table
--             end)
--         ----------------------------------------------------
--         ---
--             function inst.HOSHINO_ALLPLEYERS:Has(player_inst)
--                 return inst.HOSHINO_ALLPLEYERS.ALL_PLAYERS_IDX[player_inst] ~= nil
--             end
--             function inst.HOSHINO_ALLPLEYERS:Add(player_inst)

--             end
--             function inst.HOSHINO_ALLPLEYERS:GetAll()
--                 local new_table = {}
--                 for temp_inst, flag in pairs(inst.HOSHINO_ALLPLEYERS.ALL_PLAYERS_IDX) do
--                     if flag then
--                         table.insert(new_table, temp_inst)
--                     end
--                 end
--                 return new_table
--             end
--         ----------------------------------------------------


--     end
-- )


-- AddPlayerPostInit(function(inst)
--     if not TheWorld.ismastersim then
--         return
--     end
--     inst:DoTaskInTime(0,function()
--         inst:AddDebuff("hoshino_other_players_list_sync_debuff","hoshino_other_players_list_sync_debuff")
--     end)
-- end)


