--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if inst.components.hoshino_com_task_sys_for_player == nil then
        inst:AddComponent("hoshino_com_task_sys_for_player")
    end

    ----------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 经验广播触发监听
        inst:ListenForEvent("hoshino_event.exp_broadcast",function(inst,_table)
            local max_health = _table.max_health
            local prefab = _table.prefab -- 暂时预留，给某些特殊经验爆表的怪。
            local exp = max_health/10
            inst.components.hoshino_com_task_sys_for_player:KillBroadcast(prefab,1,{
                exp = exp
            })
        end)
----------------------------------------------------------------------------------------------------------------------------------------------------------

end