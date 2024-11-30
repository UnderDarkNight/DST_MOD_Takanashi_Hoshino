----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    植物列表  inst.__farm_plants = {}    index 为 inst ，value 为优先级，数值低的优先，同优先级则随机。

    超出距离则移除

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local SEARCH_RADIUS = 20
    local SEARCH_RADIUS_SQR = SEARCH_RADIUS * SEARCH_RADIUS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function GetFinalTargetFromTable(_table)
        -- if #_table == 0 then
        --     return nil
        -- end
        -- return _table[math.random(#_table)]
        return GetRandomKey(_table)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function searching_task(inst)
        if inst:IsBusy() or not inst:IsWorking() or not inst:HasEquipment("orangeamulet") then
            return
        end
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,0,z,SEARCH_RADIUS,{"tendable_farmplant"})
        for k, temp_plant in pairs(ents) do
            if temp_plant and temp_plant:IsValid() and temp_plant.components.farmplanttendable and temp_plant.components.farmplanttendable.tendable then
                inst.__farm_plants[temp_plant] = inst.__farm_plants[temp_plant] or 0
            end
        end
        --- 洗一次
        local new_table = {}
        local ret_plant_num = 0
        for temp_plant , value in pairs(inst.__farm_plants) do
            if temp_plant and temp_plant:IsValid() and temp_plant.components.farmplanttendable.tendable and inst:GetDistanceSqToInst(temp_plant) <= SEARCH_RADIUS_SQR then
                new_table[temp_plant] = value
                ret_plant_num = ret_plant_num + 1
            end
        end
        inst.__farm_plants = new_table


        if ret_plant_num == 0 then
            return
        end

        local ret_plant = GetFinalTargetFromTable(inst.__farm_plants)
        local player = inst:GetPlayer()
        if ret_plant == nil or player == nil then
            return
        end

        inst:StopMoving()
        inst:SetBusy("care_plant")
        inst:FaceTo(ret_plant)
        inst:PushEvent("spawn_missile",{
            target = ret_plant,
            onhit = function()
                if ret_plant then
                    if ret_plant:IsValid() and ret_plant.components.farmplanttendable then
                        ret_plant.components.farmplanttendable:TendTo(player)
                    end
                    SpawnPrefab("balloon_pop_head").Transform:SetPosition(ret_plant.Transform:GetWorldPosition())
                    -- SpawnPrefab("statue_transition_2").Transform:SetPosition(target.Transform:GetWorldPosition())
                    SpawnPrefab("chester_transform_fx").Transform:SetPosition(ret_plant.Transform:GetWorldPosition())
                end
            end,
        })
        inst:DoTaskInTime(0.3,function()
            inst:RemoveBusy("care_plant")
        end)

    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    inst.__farm_plants = {}
    inst:DoPeriodicTask(1,searching_task)
end