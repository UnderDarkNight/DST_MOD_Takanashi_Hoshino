--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    遍历之迹：  hoshino_item_travel_traces

    合成材料，在击败天体英雄或者织影者后，每完成10个金色任务获得一个。

    alterguardian_phase3

    stalker_atrium
]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 记录器
    local function HasKilledBoss(inst,prefab)
        local list = inst.components.hoshino_data:Get("killed_boss_list") or {}
        if list[prefab] then
            return true, list[prefab]
        end
        return false, 0
    end
    local function RememberKilledBoss(inst,prefab)
        local list = inst.components.hoshino_data:Get("killed_boss_list") or {}
        list[prefab] = (list[prefab] or 0) + 1
        inst.components.hoshino_data:Set("killed_boss_list",list)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 合成材料
    local GIVE_ITM_PER_NUM = TUNING.HOSHINO_DEBUGGING_MODE and 2 or 10
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("hoshino_event.exp_broadcast",function(_,_table)
        local prefab = _table and _table.prefab
        local epic = _table and _table.epic
        if prefab and epic then
            RememberKilledBoss(inst,prefab)
        end
    end)

    inst:ListenForEvent("hoshino_event.delivery_task",function(_,_table)
        local mission_type = _table and _table.type
        -- print("delivery_task mission_type",mission_type)        
        if HasKilledBoss(inst,"alterguardian_phase3") and HasKilledBoss(inst,"stalker_atrium") and mission_type == "golden" then
            local num = inst.components.hoshino_data:Add("travel_traces_spanwer_golden",1,0,1000)
            -- print("travel_traces_spanwer_golden",num)
            if num >= GIVE_ITM_PER_NUM then
                inst.components.hoshino_data:Add("travel_traces_spanwer_golden",-GIVE_ITM_PER_NUM,0,1000)
                inst.components.inventory:GiveItem(SpawnPrefab("hoshino_item_travel_traces"))
                -- print("+++give travel_traces_spanwer_golden")
            end
        end    
    end)


end