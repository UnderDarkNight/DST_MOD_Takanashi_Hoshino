----------------------------------------------------------------------------------------------------------------------------------
--[[

    任务系统。给玩家 添加的。

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_task_sys_for_player = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}

    self.max_task_num = 5  -- 最大可接数量
    self.slots = {}

    ------------------------------------------------
    --- 刷新次数。
        self.refresh_num = 5
        self.refresh_num_max = 5
        self:AddOnLoadFn(function()
            self.refresh_num = self:Get("refresh_num") or 0
        end)
        self:AddOnSaveFn(function()
            self:Set("refresh_num", self.refresh_num)
        end)
        inst:WatchWorldState("cycles",function()
            self:Refresh_DoDelta(5)
        end)
    ------------------------------------------------
    --- 初始化
        self.inst:DoTaskInTime(0,function()
            self:Init()
        end)
    ------------------------------------------------

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
-- 初始化
    function hoshino_com_task_sys_for_player:Init()
        self.backpack_item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HOSHINO_TASK_BACKPACK)
        if self.backpack_item == nil then
            self.backpack_item = SpawnPrefab("hoshino_other_task_backpack")
            self.inst.components.inventory:Equip(self.backpack_item)
        end
        self.slots = self.backpack_item.components.container.slots
    end
    function hoshino_com_task_sys_for_player:GetContainer()
        if self.backpack_item == nil then
            self:Init()
        end
        return self.backpack_item.components.container
    end
------------------------------------------------------------------------------------------------------------------------------
-- 任务给予。
    function hoshino_com_task_sys_for_player:GetCurrentTaskNum()
        if self.backpack_item == nil then
            self:Init()
        end
        local num = 0
        for i = 1, self.max_task_num, 1 do
            if self.slots[i] ~= nil then
                num = num + 1
            end
        end
        return num
    end
    function hoshino_com_task_sys_for_player:IsFull()
        if self:GetCurrentTaskNum() == self.max_task_num then
            return true
        end
        return false
    end
    function hoshino_com_task_sys_for_player:GiveTask(prefab)
        if self:IsFull() then
            return nil
        end
        local item = SpawnPrefab(prefab)
        if item then
            if item:HasTag("hoshino_task_item") then
                self:GetContainer():GiveItem(item)
                self:GetContainer():Open(self.inst)
                return item
            else
                item:Remove()
                return nil
            end
        end
        return nil
    end
------------------------------------------------------------------------------------------------------------------------------
-- 击杀广播,给外部调用。
    function hoshino_com_task_sys_for_player:KillBroadcast(prefab,num,other_data)
        num = num or 1
        if self.backpack_item == nil then
            self:Init()
        end
        self.backpack_item.components.container:ForEachItem(function(item)
            if item then
                item:PushEvent("killed",{
                    prefab = prefab,
                    num = num,
                    other_data = other_data,
                })
            end
        end)
    end
------------------------------------------------------------------------------------------------------------------------------
-- 刷新次数
    function hoshino_com_task_sys_for_player:Get_Refresh_Num()
        return self.refresh_num
    end
    function hoshino_com_task_sys_for_player:Refresh_DoDelta(num)
        self.refresh_num = math.clamp(self.refresh_num + num,0,self.refresh_num_max)
    end
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function hoshino_com_task_sys_for_player:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function hoshino_com_task_sys_for_player:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function hoshino_com_task_sys_for_player:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function hoshino_com_task_sys_for_player:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function hoshino_com_task_sys_for_player:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function hoshino_com_task_sys_for_player:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function hoshino_com_task_sys_for_player:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
    function hoshino_com_task_sys_for_player:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_com_task_sys_for_player:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_task_sys_for_player







