----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    自动种植 农作物

    farmplantable  -- 农场作物


    
]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local SEARCH_RADIUS = 20
    local SEARCH_RADIUS_SQR = SEARCH_RADIUS * SEARCH_RADIUS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function Get_Seed_Inst_From_Container(inst)
        local seed_insts = {}
        inst.components.container:ForEachItem(function(item)
            if item and item.components.farmplantable then
                table.insert(seed_insts,item)
            end
        end)
        if #seed_insts == 0 then
            return nil
        end
        return seed_insts[math.random(#seed_insts)]
    end
    local function GetStack(item)
        if item:IsValid() then
            if item.components.stackable then
                return item.components.stackable:StackSize()
            else
                return 1
            end
        else
            item:Remove()
        end
        return 0
    end
    local function GetSingleSeed(inst,item)
        return inst.components.container:RemoveItem(item)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function searching_task(inst)
        if inst:IsBusy() or not inst:IsWorking() or not inst:HasEquipment("orangeamulet") then
            return
        end

        local ret_seed_inst = Get_Seed_Inst_From_Container(inst)
        if ret_seed_inst == nil or GetStack(ret_seed_inst) < 1 then
            -- print("没有种子")
            return
        end

        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,0,z,SEARCH_RADIUS,{"soil"},{"NOCLICK"})
        local num_farm_soil = 0
        local farm_soils = {}
        for k, temp_farm_soil in pairs(ents) do
            if temp_farm_soil and temp_farm_soil:IsValid() and temp_farm_soil.prefab == "farm_soil" and temp_farm_soil.SetPlowing then
                num_farm_soil = num_farm_soil + 1
                table.insert(farm_soils,temp_farm_soil)
            end
        end
        
        if num_farm_soil == 0 then
            -- print("没有可种植的土地")
            return
        end

        local ret_soil = farm_soils[math.random(#farm_soils)]
        local player = inst:GetPlayer()
        -- print("info +++++++ ")
        -- print("找到可种植的土地",ret_soil:GetDebugString())
        -- print("info +++++++ ")


        inst:StopMoving()
        inst:SetBusy("auto_seed_plant")
        inst:FaceTo(ret_soil)
        inst:PushEvent("spawn_missile",{
            target = ret_soil,
            onhit = function()
                if ret_soil then
                    if ret_soil:IsValid() and not ret_soil:HasTag("NOCLICK") then
                        -----------------------------------------------------------------------------
                        -- 执行种植
                            local ret_seed_inst = Get_Seed_Inst_From_Container(inst)
                            if ret_seed_inst == nil then
                                return
                            end
                            local seed = GetSingleSeed(inst,ret_seed_inst)
                            if seed then
                                seed.components.farmplantable:Plant(ret_soil,player)
                                -- seed.components.farmplantable:Plant(ret_soil)
                            end
                        -----------------------------------------------------------------------------
                    end
                    SpawnPrefab("balloon_pop_head").Transform:SetPosition(ret_soil.Transform:GetWorldPosition())
                    -- SpawnPrefab("statue_transition_2").Transform:SetPosition(target.Transform:GetWorldPosition())
                    SpawnPrefab("chester_transform_fx").Transform:SetPosition(ret_soil.Transform:GetWorldPosition())
                    
                end
            end,
        })
        inst:DoTaskInTime(0.3,function()
            inst:RemoveBusy("auto_seed_plant")
        end)

    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    inst:DoPeriodicTask(2,searching_task)
end