----------------------------------------------------------------------------------------------------------------------------------
--[[

    

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_level_sys = Class(function(self, inst)
    self.inst = inst


    self.level = 0
    
    self.exp = 0
    self.max_exp = 10
    ------------------------------------------------------------------
    --
        self.__net_level = net_uint(inst.GUID,"hoshino_com_level_sys_level","hoshino_com_level_sys_net_update")
        self.__net_exp = net_uint(inst.GUID,"hoshino_com_level_sys_exp","hoshino_com_level_sys_net_update")
        self.__net_max_exp = net_uint(inst.GUID,"hoshino_com_level_sys_max_exp","hoshino_com_level_sys_net_update")
        if not TheNet:IsDedicated() then
            self.inst:ListenForEvent("hoshino_com_level_sys_net_update",function()
                self.level = self.__net_level:value()
                self.exp = self.__net_exp:value()
                self.max_exp = self.__net_max_exp:value()
                self.inst:PushEvent("hoshino_com_level_sys_client_side_data_update")
            end)
        end
    ------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------
end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
--
    function hoshino_com_level_sys:SetExp(value)
        self.__net_exp:set(value)
        self.exp = value
    end
    function hoshino_com_level_sys:GetExp()
        return self.exp
    end
    function hoshino_com_level_sys:SetMaxExp(value)
        self.__net_max_exp:set(value)
        self.max_exp = value
    end
    function hoshino_com_level_sys:GetMaxExp()
        return self.max_exp
    end
    function hoshino_com_level_sys:SetLevel(value)
        self.__net_level:set(value)
        self.level = value
    end
    function hoshino_com_level_sys:GetLevel()
        return self.level
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_level_sys







