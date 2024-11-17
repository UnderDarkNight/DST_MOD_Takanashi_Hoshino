----------------------------------------------------------------------------------------------------------------------------------
--[[

     
     
]]--
----------------------------------------------------------------------------------------------------------------------------------
    STRINGS.ACTIONS.HOSHINO_COM_ITEM_USE_ACTION = STRINGS.ACTIONS.HOSHINO_COM_ITEM_USE_ACTION or {
        DEFAULT = STRINGS.ACTIONS.OPEN_CRAFTING.USE
    }
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_item_use_to = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}

    self.sg = "dolongaction"
    self.str_index = "DEFAULT"
    self.str = "test"

    self.distance = nil

end,
nil,
{

})


----------------------------------------------------------------------------------------------------------------------------------
    function hoshino_com_item_use_to:SetTestFn(fn)
        if type(fn) == "function" then
            self.test_fn = fn
        end
    end

    function hoshino_com_item_use_to:Test(target,doer,right_click)
        if self.test_fn then
            return self.test_fn(self.inst,target,doer,right_click)
        end
        return false
    end
----------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--- DoPreActionFn
    function hoshino_com_item_use_to:SetPreActionFn(fn)
        if type(fn) == "function" then
            self.__pre_action_fn = fn
        end
    end
    function hoshino_com_item_use_to:DoPreAction(target,doer)
        if self.__pre_action_fn then
            return self.__pre_action_fn(self.inst,target,doer)
        end
    end
--------------------------------------------------------------------------------------------------------------
--- sg
    function hoshino_com_item_use_to:SetSGAction(sg)
        self.sg = sg
    end
    function hoshino_com_item_use_to:GetSGAction()
        return self.sg
    end
--------------------------------------------------------------------------------------------------------------
--- 显示文本
    function hoshino_com_item_use_to:SetText(index,str)
        self.str_index = string.upper(index)
        self.str = str
        STRINGS.ACTIONS.HOSHINO_COM_ITEM_USE_ACTION[self.str_index] = self.str
    end

    function hoshino_com_item_use_to:GetTextIndex()
        return self.str_index
    end
--------------------------------------------------------------------------------------------------------------
--- distance
    function hoshino_com_item_use_to:SetDistance(distance)
        self.distance = distance
    end
    function hoshino_com_item_use_to:GetDistance()
        return self.distance
    end
--------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_item_use_to






