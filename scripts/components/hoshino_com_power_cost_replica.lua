----------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_power_cost = Class(function(self, inst)
    self.inst = inst

    self.current = 0
    self.max = 100

    self.__update_fns = {}
    self._current = net_float(inst.GUID,"hoshino_com_power_cost.current","hoshino_com_power_cost_update")
    self._max = net_float(inst.GUID,"hoshino_com_power_cost.max","hoshino_com_power_cost_update")

    inst:ListenForEvent("hoshino_com_power_cost_update",function()
        self.current = self._current:value()
        self.max = self._max:value()
        self:Update()
    end)


end)
------------------------------------------------------------------------------------------------------------------------------
--- 
    function hoshino_com_power_cost:SetCurrent(value)
        self._current:set(value)
        self.current = value
    end
    function hoshino_com_power_cost:SetMax(value)
        self._max:set(value)
        self.max = value
    end
    function hoshino_com_power_cost:GetCurrent()
        return self.current
    end
    function hoshino_com_power_cost:GetMax()
        return self.max
    end
------------------------------------------------------------------------------------------------------------------------------
--- update
    function hoshino_com_power_cost:AddUpdateFn(fn)
        if type(fn) == "function" then
            table.insert(self.__update_fns,fn)
        end
    end
    function hoshino_com_power_cost:Update()
        for k, v in pairs(self.__update_fns) do
            v()
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_power_cost







