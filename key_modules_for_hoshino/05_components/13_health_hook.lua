------------------------------------------------------------------------------------------------------------------------------------
--[[

    

]]--
------------------------------------------------------------------------------------------------------------------------------------



AddComponentPostInit("health", function(self)

    if self.inst.components.hoshino_com_health_hooker == nil then
        self.inst:AddComponent("hoshino_com_health_hooker")
    end

    local old_DoDelta = self.DoDelta
    self.DoDelta = function(self, num,...)
        num = self.inst.components.hoshino_com_health_hooker:Active(num) or num
        return old_DoDelta(self,num,...)
    end
    
end)