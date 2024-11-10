------------------------------------------------------------------------------------------------------------------------------------
--[[

    trader 组件 的 额外hook

]]--
------------------------------------------------------------------------------------------------------------------------------------



AddComponentPostInit("trader", function(self)

    self.inst:ListenForEvent("trade",function(inst,_table)
        local giver = _table and _table.giver
        local item = _table and _table.item
        if giver and giver:HasTag("player") then
            giver:PushEvent("hoshino_event.trade_2_target",{
                target = inst,
                item = item,
            })
        end
    end)

end)