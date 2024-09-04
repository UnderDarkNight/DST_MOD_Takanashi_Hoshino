--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

53、【彩】【钨合金棍】【最终血量扣除结算的时候，超过1点的时候，所扣除点数减少1点】（未超过一点则免疫，选择后从池子内移除，无法叠加）

暂时按照可叠加状态写。

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("master_postinit_hoshino",function()
        
        if inst.components.health == nil then
            return
        end


        local old_DoDelta = inst.components.health.DoDelta
        inst.components.health.DoDelta = function(self, num,...)
            if num < 0 then
                -- num 是负数
                local reduce_num = self.inst.components.hoshino_com_debuff:Get_Health_Down_Reduce()  -- 这个是正数
                if num + reduce_num > 0 then
                    num = 0
                else
                    num = num + reduce_num
                end
            end
            return old_DoDelta(self,num,...)
        end

    end)
end