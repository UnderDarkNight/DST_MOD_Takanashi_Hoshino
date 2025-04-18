------------------------------------------------------------------------------------------------------------------------------------
--[[


    修改官方的倍增器，嵌入拦截一层

]]--
------------------------------------------------------------------------------------------------------------------------------------
-- local SourceModifierList = require("util/sourcemodifierlist")


AddGlobalClassPostConstruct("util/sourcemodifierlist", "SourceModifierList", function(self)
    

    self.__hoshino_got_override_fns = {}
    self.__hoshino_temp_inst_remove_event = function(temp_inst)
       self:Hoshino_RemoveGotOverrideFn(temp_inst) 
    end
    self.Hoshino_AddGotOverrideFn = function(self,temp_inst,fn)
        if self.__hoshino_got_override_fns[temp_inst] == nil then
            temp_inst:ListenForEvent("onremove",self.__hoshino_temp_inst_remove_event)
        end
        self.__hoshino_got_override_fns[temp_inst] = fn
    end
    self.Hoshino_RemoveGotOverrideFn = function(self,temp_inst)
        if self.__hoshino_got_override_fns[temp_inst] == nil then
            return
        end
        temp_inst:RemoveEventCallback("onremove",self.__hoshino_temp_inst_remove_event)
        local new_table = {}
        for k,v in pairs(self.__hoshino_got_override_fns) do
            if k ~= temp_inst then
                new_table[k] = v
            end
            self.__hoshino_got_override_fns = new_table
        end        
    end


    ---- 延时hook Get/IsEmpty 函数
    self.inst:DoTaskInTime(1,function()
        
        local old_Get = self.Get
        self.Get = function(self)
            local result = old_Get(self)
            for temp_inst, fn in pairs(self.__hoshino_got_override_fns) do
                result = fn(self.inst,result) or result
            end
            return result
        end

        local old_IsEmpty = self.IsEmpty
        self.IsEmpty = function(self)
            local result = old_IsEmpty(self) 
            if result then
                for temp_inst, fn in pairs(self.__hoshino_got_override_fns) do
                    if temp_inst and temp_inst:IsValid() then
                        return false
                    end
                end
            end
            return result
        end

    end)
end)
