--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("master_postinit_hoshino",function()
        
        if inst.components.sleepingbaguser == nil then
            return
        end

        local old_SleepTick = inst.components.sleepingbaguser.SleepTick
        inst.components.sleepingbaguser.SleepTick = function(self,...)
            local origin_ret = {old_SleepTick(self,...)}
            ---------------------------------------------------------------------------------------
            --- 
                if self.inst.components.hoshino_cards_sys:Get("card_black.sleeping_bag_health_blocker") then
                    local health_tick = self.bed.components.sleepingbag.health_tick * self.health_bonus_mult
                    self.inst.components.health:DoDelta(-health_tick, true)
                end
            ---------------------------------------------------------------------------------------
            return unpack(origin_ret)
        end



    end)
end