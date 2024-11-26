--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local TheInput = require("input")
--------------------------------------------------------------------------------------
    TheInput.__hoshino_modify_fns = {}
    TheInput.__hoshino_remove_fn = function(inst)
        TheInput:Hoshino_Remove_Update_Modify_Fn(inst)
    end
    function TheInput:Hoshino_Add_Update_Modify_Fn(inst,fn)
        if inst and fn then
            self.__hoshino_modify_fns[inst] = fn
        end
        inst:ListenForEvent("onremove",self.__hoshino_remove_fn)
    end
    function TheInput:Hoshino_Remove_Update_Modify_Fn(inst)
        local new_table = {}
        for k,v in pairs(self.__hoshino_modify_fns) do
            if k ~= inst then
                new_table[k] = v
            end
        end
        self.__hoshino_modify_fns = new_table
        inst:RemoveEventCallback("onremove",self.__hoshino_remove_fn)
    end

--------------------------------------------------------------------------------------
---
    local old_OnUpdate = TheInput.OnUpdate
    function TheInput:OnUpdate(...)
        if ThePlayer then
            for k,v in pairs(self.__hoshino_modify_fns) do
                if k and k:IsValid() and ( k.Transform == nil or ThePlayer:GetDistanceSqToInst(k) < 2500 ) then
                    v(self)
                end
            end
        end
        return old_OnUpdate(self,...)
    end
--------------------------------------------------------------------------------------