-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    雇佣监听广播控制器

    雇佣奖励控制器

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 雇佣监听广播控制器
    AddPlayerPostInit(function(inst)
        if not TheWorld.ismastersim then
            return
        end


        inst:DoTaskInTime(1,function()  --- 延时一下，避免加载的时候执行
            if not inst.components.leader then
                return
            end


            inst:ListenForEvent("makefriend",function()
                --- 先记录旧的已经雇佣的
                local old_list = {}
                for temp_follower,flag in pairs(inst.components.leader.followers) do
                    if flag and temp_follower and temp_follower:IsValid() then
                        old_list[temp_follower] = true
                    end
                end

                inst:DoTaskInTime(0.2,function()
                    local new_list = {}
                    for temp_follower,flag in pairs(inst.components.leader.followers) do
                        if flag and temp_follower and temp_follower:IsValid() then
                            new_list[temp_follower] = true
                        end
                    end

                    ---- 匹配 old_list 和 new_list ，得到新增的
                    local new_added_list = {}
                    local num = 0
                    for temp_follower,flag in pairs(new_list) do
                        if not old_list[temp_follower] then
                            new_added_list[temp_follower] = true
                            num = num + 1
                        end
                    end

                    if num > 0 then
                        for temp_inst, v in pairs(new_added_list) do
                            inst:PushEvent("hoshino_event.leader_follower_added",temp_inst)                        
                        end
                    end


                end)
            
            
            end)


        end)

    end)


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 雇佣奖励控制器
    AddPlayerPostInit(function(inst)
        if not TheWorld.ismastersim then
            return
        end

        local monster_prefabs = {
            ["pigman"] = true,
            ["bunnyman"] = true,
            ["merm"] = true,
            ["mermguard"] = true,
        }

        inst:ListenForEvent("hoshino_event.leader_follower_added",function(inst,target)

            if target and monster_prefabs[target.prefab] and (math.random(10000)/10000 <= 1/100 or TUNING.HOSHINO_DEBUGGING_MODE) then
                inst.components.inventory:GiveItem(SpawnPrefab("hoshino_equipment_proof_of_harmony"))
            end

        end)

    end)