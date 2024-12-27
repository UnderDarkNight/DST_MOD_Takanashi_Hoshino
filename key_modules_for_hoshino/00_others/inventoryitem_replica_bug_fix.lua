--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    本文件用来处理 inventoryitem_replica 202 行 classified 丢失的崩溃bug

    这个bug通常是无人机采集的时候触发。


]]-- 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddClassPostConstruct("components/inventoryitem_replica", function(self)
    
    local old_SetPickupPos = self.SetPickupPos
    self.SetPickupPos = function(self, pos,...)
        local others_arg = {...}
        if self.classified == nil then
            self.inst:DoTaskInTime(0,function()
                if self.classified ~= nil then
                    old_SetPickupPos(self, pos,unpack(others_arg))
                end                
            end)
        else
            old_SetPickupPos(self, pos,...)
        end
    end

    -- self.inst:DoTaskInTime(0,function()
    --     print("info hook inventoryitem_replica",self.inst)
    -- end)

end)