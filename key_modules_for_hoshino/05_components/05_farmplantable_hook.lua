------------------------------------------------------------------------------------------------------------------------------------
--[[

    farmplantable 组件 的 额外hook

]]--
------------------------------------------------------------------------------------------------------------------------------------



AddComponentPostInit("farmplantable", function(self)

    -- self.inst:ListenForEvent("on_planted",function(_,_table)
    --     -- { doer = planter, seed = self.inst, in_soil = true }
    --     local doer = _table and _table.doer
    --     local seed = _table and _table.seed
    --     local in_soil = _table and _table.in_soil
    --     if doer and doer:HasTag("player") then
    --         doer:PushEvent("hoshino_event.farmplantable_on_planted",{
    --             seed = seed,
    --             in_soil = in_soil
    --         })
    --     end
    -- end)

    local old_Plant = self.Plant
    self.Plant = function(self,target, planter,...)
        local origin_ret = old_Plant(self,target, planter,...)
        if origin_ret then
            if self.plant ~= nil and target:HasTag("soil") then
                local pt = target:GetPosition()        
                local plant_prefab = FunctionOrValue(self.plant, self.inst)
                if plant_prefab ~= nil and planter:HasTag("player") then
                    planter:PushEvent("hoshino_event.farmplantable_on_planted",{
                        seed = self.inst,
                        plant_prefab = plant_prefab,
                        in_soil = true,
                        pt = pt
                    })
                end
            end
        end
        return origin_ret
    end

end)