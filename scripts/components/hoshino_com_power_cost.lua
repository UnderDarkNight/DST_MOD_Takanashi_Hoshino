----------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local function GetReplicaCom(self)
        return self.inst.replica.hoshino_com_power_cost or self.inst.replica._.hoshino_com_power_cost
    end
    local function SetCurrent(self,value)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:SetCurrent(value)
        end
    end
    local function SetMax(self,value)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:SetMax(value)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_power_cost = Class(function(self, inst)
    self.inst = inst

    self.current = 0
    self.max = 100
end,
nil,
{
    current = SetCurrent,
    max = SetMax,
})
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_power_cost:SetCurrent(value)
        self.current = math.clamp(value, 0, self.max)
    end
    function hoshino_com_power_cost:SetMax(value)
        self.max = value
    end
    function hoshino_com_power_cost:GetCurrent()
        return self.current
    end
    function hoshino_com_power_cost:GetMax()
        return self.max
    end
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_power_cost:DoDelta(value)
        self:SetCurrent(self.current + value)
    end
------------------------------------------------------------------------------------------------------------------------------
--- 保存/加载
    function hoshino_com_power_cost:OnSave()
        local data =
        {
            current = self.current,
            max = self.max,
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_com_power_cost:OnLoad(data)
        if data.current then
            self.current = data.current
        end
        if data.max then
            self.max = data.max
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----
------------------------------------------------------------------------------------------------------------------------------
----
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_power_cost







