------------------------------------------------------------------------------------------------------------------------------------
--[[

    combat 组件 的 额外hook

    给玩家上buff，被怪物设定为目标的时候触发。

]]--
------------------------------------------------------------------------------------------------------------------------------------



AddComponentPostInit("combat", function(self)

    -- local old_SetTarget = self.SetTarget
    -- self.SetTarget = function(self,target,...)
    --     local old_ret = {old_SetTarget(self,target,...)}
    --     if target and target:IsValid() then
    --         target:PushEvent("hoshino_event.combat_set_target",self.inst)
    --     end
    --     return unpack(old_ret)
    -- end

    local old_SuggestTarget = self.SuggestTarget
    self.SuggestTarget = function(self,target,...)
        local old_ret = {old_SuggestTarget(self,target,...)}
        if old_ret[1] and target and target:IsValid() then
            target:PushEvent("hoshino_event.combat_set_target",self.inst)
        end
        return unpack(old_ret)
    end


end)