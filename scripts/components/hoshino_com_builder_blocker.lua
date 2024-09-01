----------------------------------------------------------------------------------------------------------------------------------
--[[

    制作栏  屏蔽模块

]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local function count_update(self,value)
        local replica_com = self.inst.replica.hoshino_com_builder_blocker or self.inst.replica._.hoshino_com_builder_blocker
        if replica_com then
            replica_com:SetCount(value)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_builder_blocker = Class(function(self, inst)
    self.inst = inst


    
    self.daily_origin_max = 4000000000 --每日最大次数
    self.daily_max = self.daily_origin_max
    self.count = self.daily_origin_max --每日计数

    inst:WatchWorldState("cycles",function()
        self.count = self.daily_max
        -- inst:PushEvent("refreshcrafting")
    end)

end,
nil,
{
    count = count_update,
})

------------------------------------------------------------------------------------------------------------------------------
---- 
    function hoshino_com_builder_blocker:DoDelta(value)
        local old_value = self.count
        self.count = math.clamp(old_value + value, 0, self.daily_max)
        -- print("屏蔽模块计数：",self.count,old_value)
    end
    function hoshino_com_builder_blocker:SetDailyMax(value)
        self.daily_max = math.clamp(value, 0, self.daily_origin_max)
        self:DoDelta(0)
    end
------------------------------------------------------------------------------------------------------------------------------
---- 
    function hoshino_com_builder_blocker:CanBuild()
        return self.count > 0
    end
------------------------------------------------------------------------------------------------------------------------------
---- 
    function hoshino_com_builder_blocker:OnSave()
        local data =
        {
            count = self.count,
            daily_max = self.daily_max,
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_com_builder_blocker:OnLoad(data)
        if data.count then
            self.count = data.count
        end
        if data.daily_max then
            self.daily_max = data.daily_max
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_builder_blocker







