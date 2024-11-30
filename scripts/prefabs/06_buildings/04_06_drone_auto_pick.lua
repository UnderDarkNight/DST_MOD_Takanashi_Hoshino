----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    自动采集
    自动采集附近的作物，并返回仓库
    
]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local SEARCH_RADIUS = 20
    local SEARCH_RADIUS_SQR = SEARCH_RADIUS * SEARCH_RADIUS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 黑名单
    local Pickable_Black_List = {
        ["flower"] = true,
        ["flower_rose"] = true,
        ["flower_evil"] = true,
    }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 判断巨大作物
    local function GetExtractAnimationInfo(text)
        -- 提取 AnimState 行
        local anim_state_line = string.match(text, "AnimState:%s*(.-)\n")
        -- 提取 bank, build, anim 参数
        local bank = string.match(anim_state_line, "bank:%s*([^%s]+)")
        local build = string.match(anim_state_line, "build:%s*([^%s]+)")
        local anim = string.match(anim_state_line, "anim:%s*([^%s]+)")
        return bank, build, anim
    end
    local function containsOversized(str)
        str = tostring(str)
        -- 使用 string.find 查找 "oversized"
        local pos = str:find("oversized")
        -- 如果找到了，则返回 true；否则返回 false
        if pos then
            return true
        else
            return false
        end
    end
    local function IsLargePlant(inst)
        local debug_strings = inst:GetDebugString()
        local bank, build, anim = GetExtractAnimationInfo(debug_strings)
        if containsOversized(build) or containsOversized(anim) or containsOversized(bank) then
            return true
        end
        return false
    end
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
        if inst:IsBusy() or not inst:IsWorking() or not inst:HasEquipment("orangeamulet") or inst.components.container:IsFull() then
            return
        end
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,0,z,SEARCH_RADIUS,{"pickable"})
        local plants = {}
        local num_plants = 0
        for k, temp_plant in pairs(ents) do
            if temp_plant and temp_plant:IsValid() 
                and not Pickable_Black_List[temp_plant.prefab] 
                and temp_plant.components.pickable and temp_plant.components.pickable:CanBePicked() 
                and not IsLargePlant(temp_plant) then
                    plants[temp_plant] = true
                    num_plants = num_plants + 1
            end
        end
        
        if num_plants == 0 then
            return
        end

        local ret_plant = GetFinalTargetFromTable(plants)
        local player = inst:GetPlayer()


        inst:StopMoving()
        inst:SetBusy("auto_pick_plant")
        inst:FaceTo(ret_plant)
        inst:PushEvent("spawn_missile",{
            target = ret_plant,
            onhit = function()
                if ret_plant and ret_plant.components.pickable then                    
                    SpawnPrefab("balloon_pop_head").Transform:SetPosition(ret_plant.Transform:GetWorldPosition())
                    -- SpawnPrefab("statue_transition_2").Transform:SetPosition(target.Transform:GetWorldPosition())
                    SpawnPrefab("chester_transform_fx").Transform:SetPosition(ret_plant.Transform:GetWorldPosition())

                    if ret_plant.components.pickable:CanBePicked() then
                        ------------------------------------------------------------------------
                        --- 模拟玩家采集
                            -- local flag,loot = ret_plant.components.pickable:Pick(player)
                            local flag,loot = ret_plant.components.pickable:Pick(inst)
                        ------------------------------------------------------------------------
                    end
                end
            end,
            custom_fn = function(self)
                self:ListenForEvent("onremove",function()
                    SpawnPrefab("balloon_pop_head").Transform:SetPosition(self.Transform:GetWorldPosition())
                    -- SpawnPrefab("statue_transition_2").Transform:SetPosition(target.Transform:GetWorldPosition())
                    SpawnPrefab("chester_transform_fx").Transform:SetPosition(self.Transform:GetWorldPosition())
                    self:Remove()
                end,ret_plant)
            end,
        })
        inst:DoTaskInTime(0.3,function()
            inst:RemoveBusy("auto_pick_plant")
        end)

    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    inst:DoPeriodicTask(2,searching_task)
    --- 伪装成玩家，以便采集植物
    inst:AddComponent("inventory")
    inst.components.inventory.maxslots = 0
    inst.components.inventory.GiveItem = function(self,item,...)
        if item and item.components.inventoryitem then
            if item.components.inventoryitem.cangoincontainer then
                self.inst.components.container:GiveItem(item,...)
            else
                -- item.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
            end
        end
    end
end