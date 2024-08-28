----------------------------------------------------------------------------------------------------------------------------------
--[[

     
     
]]--
----------------------------------------------------------------------------------------------------------------------------------
STRINGS.ACTIONS.HOSHINO_COM_WORKABLE_ACTION = STRINGS.ACTIONS.HOSHINO_COM_WORKABLE_ACTION or {
    DEFAULT = STRINGS.ACTIONS.OPEN_CRAFTING.USE
}


local hoshino_com_workable = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}

    self.sg = "dolongaction"
    self.str_index = "DEFAULT"
    self.str = "test"

end,
nil,
{

})


--------------------------------------------------------------------------------------------------------------
--- test 函数
    function hoshino_com_workable:SetTestFn(fn)
        if type(fn) == "function" then
            self._test_fn = fn
        end
    end

    function hoshino_com_workable:Test(doer,right_click)
        if self.inst:HasTag("hoshino_com_workable_can_not_work") then
            return false
        end
        if self._test_fn then
            return self._test_fn(self.inst,doer,right_click)
        end
        return false
    end
--------------------------------------------------------------------------------------------------------------
--- DoPreActionFn
    function hoshino_com_workable:SetPreActionFn(fn)
        if type(fn) == "function" then
            self.__pre_action_fn = fn
        end
    end
    function hoshino_com_workable:DoPreAction(doer)
        if self.__pre_action_fn then
            return self.__pre_action_fn(self.inst,doer)
        end
    end
--------------------------------------------------------------------------------------------------------------
--- sg
    function hoshino_com_workable:SetSGAction(sg)
        self.sg = sg
    end
    function hoshino_com_workable:GetSGAction()
        return self.sg
    end
--------------------------------------------------------------------------------------------------------------
--- 显示文本
    function hoshino_com_workable:SetText(index,str)
        self.str_index = string.upper(index)
        self.str = str
        STRINGS.ACTIONS.HOSHINO_COM_WORKABLE_ACTION[self.str_index] = str
    end

    function hoshino_com_workable:GetTextIndex()
        return self.str_index
    end
--------------------------------------------------------------------------------------------------------------
    function hoshino_com_workable:GetCanWorlk()
        return not self.inst:HasTag("hoshino_com_workable_can_not_work")
    end
--------------------------------------------------------------------------------------------------------------

return hoshino_com_workable






