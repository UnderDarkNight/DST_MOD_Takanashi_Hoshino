----------------------------------------------------------------------------------------------------------------------------------
--[[

    任务系统。给 物品 添加的。

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_task_sys_for_item = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}

    -----------------------------------------------------------
    ---- 初始化
        self._doer_event_name = nil
        self._doer_event_fn = nil
        self._doer_event_install_task = nil
        self._doer_event_installed = false
        inst:DoTaskInTime(5,function()
            self:Start_Install_Event()
        end)
    -----------------------------------------------------------

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
-- 挂载任务
    function hoshino_com_task_sys_for_item:GetOwner()
        local owner = self.inst.components.inventoryitem:GetGrandOwner()
        if owner and owner:HasTag("player") then
            return owner
        end
        return nil
    end
    function hoshino_com_task_sys_for_item:Add_Event_Listener(event_name,fn)
        if type(event_name) == "string" and type(fn) == "function" then
            self._doer_event_name = event_name
            self._doer_event_fn = fn
        end
    end
    function hoshino_com_task_sys_for_item:Start_Install_Event()
        if self._doer_event_install_task then
            return
        end
        self._doer_event_install_task = self.inst:DoPeriodicTask(5,function()
            local owner = self:GetOwner()
            if owner and self._doer_event_name and self._doer_event_fn and not self._doer_event_installed then
                self.inst:ListenForEvent(self._doer_event_name,self._doer_event_fn,owner)
                self._doer_event_install_task:Cancel()
                self._doer_event_install_task = nil
            end
        end)
    end
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function hoshino_com_task_sys_for_item:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function hoshino_com_task_sys_for_item:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function hoshino_com_task_sys_for_item:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function hoshino_com_task_sys_for_item:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function hoshino_com_task_sys_for_item:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function hoshino_com_task_sys_for_item:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function hoshino_com_task_sys_for_item:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
    function hoshino_com_task_sys_for_item:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_com_task_sys_for_item:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_task_sys_for_item







