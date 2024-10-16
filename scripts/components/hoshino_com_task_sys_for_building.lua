----------------------------------------------------------------------------------------------------------------------------------
--[[

    任务系统。给建筑

    关键数据和API使用 RPC信道。

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_task_sys_for_building = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}    

    --------------------------------------------------------------------------------------
    --- owner
        self.owner = nil
        inst:ListenForEvent("onclose",function()
            self.owner = nil
            self.inst.components.container.canbeopened = false
        end)
    --------------------------------------------------------------------------------------
    --- 刷新按钮点击
        inst:ListenForEvent("refresh_button_click",function(inst,index)
            print("刷新按钮点击",index)
            self:Refresh_Clicked(index)
        end)
    --------------------------------------------------------------------------------------
    --- 任务接受点击
        inst:ListenForEvent("accept_button_click",function(inst,index)
            print("任务接受点击",index)
            self:Accept_Clicked(index)
        end)
    --------------------------------------------------------------------------------------
    --- 关闭按钮
        inst:ListenForEvent("close_button_clicked",function()
            self:GetContainer():Close()
            self.owner = nil
            self.inst.components.container.canbeopened = false
        end)
    --------------------------------------------------------------------------------------
    --- 刷新次数。
        inst:WatchWorldState("cycles",function()
            self:Refresh_Num_Init()
        end)
    --------------------------------------------------------------------------------------

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
-- RPC
    function hoshino_com_task_sys_for_building:GetRPC()
        if self.owner then
            return self.owner.components.hoshino_com_rpc_event
        end
    end
------------------------------------------------------------------------------------------------------------------------------
-- 刷新次数
    function hoshino_com_task_sys_for_building:Refresh_Num_Init()
        if self.owner == nil then
            return
        end
        local refresh_num = self.owner.components.hoshino_com_task_sys_for_player:Get_Refresh_Num()
        self:GetRPC():PushEvent("refresh_num_update",refresh_num,self.inst)
    end
    function hoshino_com_task_sys_for_building:Get_Refresh_Num()
        if self.owner == nil then
            return 0
        end
        local refresh_num = self.owner.components.hoshino_com_task_sys_for_player:Get_Refresh_Num()
        return refresh_num
    end
------------------------------------------------------------------------------------------------------------------------------
-- 打开
    function hoshino_com_task_sys_for_building:GetContainer()
        return self.inst.components.container
    end
    function hoshino_com_task_sys_for_building:Open(doer)
        if self.owner ~= nil then
            return
        end
        self:Refresh_Num_Init()
        local container_com = self:GetContainer()
        container_com.canbeopened = true
        self.owner = doer
        container_com:Open(doer)
        self:Refresh_Num_Init()
    end
------------------------------------------------------------------------------------------------------------------------------
--- 获取任务物品
    function hoshino_com_task_sys_for_building:GetNewTaskItem()
        local list = {
            "hoshino_task_excample_kill",
            "hoshino_task_excample_item",
        }
        local ret_prefab = list[math.random(1,#list)]
        print("spawn new task item",ret_prefab)
        return SpawnPrefab(ret_prefab)
    end
------------------------------------------------------------------------------------------------------------------------------
--- 刷新全部
    function hoshino_com_task_sys_for_building:Refresh_All()
        local container_com = self:GetContainer()
        for i = 1, 6, 1 do
            local item = container_com.slots[i]
            if item then
                item:Remove()
            end
        end
        for i = 1, 6, 1 do
            local new_item = self:GetNewTaskItem()
            container_com:GiveItem(new_item,i)
        end
        local rpc = self:GetRPC()
        if rpc then
            rpc:PushEvent("refresh_widget_box",{},self.inst)
        end
        self.inst:PushEvent("task_item_update")
    end
------------------------------------------------------------------------------------------------------------------------------
--- 刷新按钮点击
    function hoshino_com_task_sys_for_building:Refresh_Clicked(index)
        if self:Get_Refresh_Num() <= 0 then
            return
        end
        self.owner.components.hoshino_com_task_sys_for_player:Refresh_DoDelta(-1)
        self:Refresh_Num_Init()
        local container_com = self:GetContainer()
        local item = container_com.slots[index]
        if item then
            item:Remove()
        end
        local new_item = self:GetNewTaskItem()
        container_com:GiveItem(new_item,index)

        self:GetRPC():PushEvent("refresh_widget_box",{},self.inst)
        self.inst:PushEvent("task_item_update")
        self:Refresh_Num_Init()
    end
------------------------------------------------------------------------------------------------------------------------------
--- 接受按钮点击
    function hoshino_com_task_sys_for_building:Accept_Clicked(index)
        local container_com = self:GetContainer()
        local item = container_com.slots[index]
        if item and self.owner then
            local tesk_prefab = item.prefab
            item:Remove()
            self.owner.components.hoshino_com_task_sys_for_player:GiveTask(tesk_prefab)
        end
        self:GetRPC():PushEvent("refresh_widget_box",{},self.inst)
        self.inst:PushEvent("task_item_update")
    end
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function hoshino_com_task_sys_for_building:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function hoshino_com_task_sys_for_building:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function hoshino_com_task_sys_for_building:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function hoshino_com_task_sys_for_building:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function hoshino_com_task_sys_for_building:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function hoshino_com_task_sys_for_building:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function hoshino_com_task_sys_for_building:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
    function hoshino_com_task_sys_for_building:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_com_task_sys_for_building:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_task_sys_for_building







