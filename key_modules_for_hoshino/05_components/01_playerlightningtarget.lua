------------------------------------------------------------------------------------------------------------------------------------
--[[

    雷电屏蔽器

]]--
------------------------------------------------------------------------------------------------------------------------------------



AddComponentPostInit("playerlightningtarget", function(self)

    self._hoshino_blocker = SourceModifierList(self.inst)

    function self:Hoshino_Add_Blocker(blocker_inst)
        self._hoshino_blocker:SetModifier(blocker_inst, 2)
    end
    function self:Hoshino_Remove_Blocker(blocker_inst)
        self._hoshino_blocker:RemoveModifier(blocker_inst)
    end

    function self:Hoshino_Has_Blocker()
        local value = self._hoshino_blocker:Get()
        if value > 1 then
            return true
        end
        return false
    end

    local old_GetHitChance = self.GetHitChance
    function self:GetHitChance(...)
        if self:Hoshino_Has_Blocker() then
            return -1
        else
            return old_GetHitChance(self,...)
        end
    end


end)