--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(1,function()
        if inst == ThePlayer and TheCamera and TheCamera.HOSHINO_HOOKED_FLAG ~= true then
            TheCamera.HOSHINO_HOOKED_FLAG = true


            local old_ZoomIn = TheCamera.ZoomIn
            TheCamera.ZoomIn = function(self,...)
                if self.HOSHINO_ZOOM_BLOCK then
                    return
                end
                return old_ZoomIn(self,...)
            end
            local old_ZoomOut = TheCamera.ZoomOut
            TheCamera.ZoomOut = function(self,...)
                if self.HOSHINO_ZOOM_BLOCK then
                    return
                end
                return old_ZoomOut(self,...)
            end
            
        end
    end)
end