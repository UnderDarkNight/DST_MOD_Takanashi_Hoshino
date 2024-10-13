------------------------------------------------------------------------------------------------------------------------------------
--[[

    combat 的目标屏蔽器 hook

]]--
------------------------------------------------------------------------------------------------------------------------------------



AddComponentPostInit("combat", function(self)

    local old_SetTarget = self.SetTarget
    self.SetTarget = function(self, target,...)
        if target and target:HasTag("hoshino_tag.combat_set_target_block") then
            return
        end
        old_SetTarget(self, target,...)
    end

    local old_EngageTarget = self.EngageTarget
    self.EngageTarget = function(self, target,...)
        if target and target:HasTag("hoshino_tag.combat_set_target_block") then
            return
        end
        old_EngageTarget(self, target,...)
    end

    local old_SuggestTarget = self.SuggestTarget
    self.SuggestTarget = function(self, target,...)
        if target and target:HasTag("hoshino_tag.combat_set_target_block") then
            return true
        end
        return old_SuggestTarget(self, target,...)
    end

end)