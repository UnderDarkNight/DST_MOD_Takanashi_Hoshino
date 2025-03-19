------------------------------------------------------------------------------------------------------------------------------------
--[[

    烹饪锅屏蔽 器

]]--
------------------------------------------------------------------------------------------------------------------------------------



AddComponentPostInit("stewer", function(self)

    local old_StartCooking = self.StartCooking
    self.StartCooking = function(self,doer,...)
        if doer and doer.components.hoshino_com_stewer_hooker then
            if doer.components.hoshino_com_stewer_hooker:StartCookingTest(self.inst) ~= true then
                return
            end
        end
        return old_StartCooking(self,doer,...)
    end
    
end)