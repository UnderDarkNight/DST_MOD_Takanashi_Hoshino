----------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_stewer_hooker = Class(function(self, inst)
    self.inst = inst

    self.__start_cooking_blockers = {}
    self.__start_cooking_blocker_remove_event = function(temp_inst)
        self:RemoveStartCookingBlocker(temp_inst)
    end

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
--  
    function hoshino_com_stewer_hooker:StartCookingTest(cookpot)
        local ret_flag = true
        for k,fn in pairs(self.__start_cooking_blockers) do
            ret_flag = fn(self.inst,cookpot)
        end
        return ret_flag
    end
    function hoshino_com_stewer_hooker:AddStartCookingBlocker(blocker,fn)
        if self.__start_cooking_blockers[blocker] == nil then
            blocker:ListenForEvent("onremove",self.__start_cooking_blocker_remove_event)
        end
        self.__start_cooking_blockers[blocker] = fn
    end
    function hoshino_com_stewer_hooker:RemoveStartCookingBlocker(blocker)
        if not self.__start_cooking_blockers[blocker] then
            return
        end
        blocker:RemoveEventCallback("onremove",self.__start_cooking_blocker_remove_event)
        local new_table = {}
        for k,v in pairs(self.__start_cooking_blockers) do
            if k ~= blocker then
                new_table[k] = v
            end
        end
        self.__start_cooking_blockers = new_table
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_stewer_hooker







