------------------------------------------------------------------------------------------------------------------------------------
--[[

    drawable 组件 的 额外hook

]]--
------------------------------------------------------------------------------------------------------------------------------------



AddComponentPostInit("drawable", function(self)

    local old_OnDrawn = self.OnDrawn

    self.OnDrawn = function(self, ...)
        -- 寻找最近玩家广播event
        local player = self.inst:GetNearestPlayer(true)
        if player then
            player:PushEvent("hoshino_event.drawable_drawn", self.inst)
        end
        return old_OnDrawn(self, ...)
    end

end)