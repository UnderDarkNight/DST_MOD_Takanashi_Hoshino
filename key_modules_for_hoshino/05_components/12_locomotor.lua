------------------------------------------------------------------------------------------------------------------------------------
--[[

    drawable 组件 的 额外hook

]]--
------------------------------------------------------------------------------------------------------------------------------------



AddComponentPostInit("locomotor", function(self)

    self.___hoshino_speed_mult_override_fns = {}
    self.___hoshino_temp_inst_remove_event = function(temp_inst)
        self:Hoshino_RemoveSpeedMultOverrideFn(temp_inst)
    end

    self.Hoshino_AddSpeedMultOverrideFn = function(self,temp_inst,fn)
        if self.___hoshino_speed_mult_override_fns[temp_inst] == nil then
            temp_inst:ListenForEvent("onremove",self.___hoshino_temp_inst_remove_event)
        end
        self.___hoshino_speed_mult_override_fns[temp_inst] = fn
    end
    self.Hoshino_RemoveSpeedMultOverrideFn = function(self,temp_inst)
        if self.___hoshino_speed_mult_override_fns[temp_inst] == nil then
            return
        end
        temp_inst:RemoveEventCallback("onremove",self.___hoshino_temp_inst_remove_event)
        local new_table = {}
        for k,v in pairs(self.___hoshino_speed_mult_override_fns) do
            if k ~= temp_inst then
                new_table[k] = v
            end
            self.___hoshino_speed_mult_override_fns = new_table
        end
    end

    self.inst:DoTaskInTime(1,function()
        local old_GetSpeedMultiplier = self.GetSpeedMultiplier
        self.GetSpeedMultiplier = function(self)
            local result = old_GetSpeedMultiplier(self)
            for temp_inst, fn in pairs(self.___hoshino_speed_mult_override_fns) do
                result = fn(self.inst,result,temp_inst) or result
            end
            return result
        end
    end)


    
end)