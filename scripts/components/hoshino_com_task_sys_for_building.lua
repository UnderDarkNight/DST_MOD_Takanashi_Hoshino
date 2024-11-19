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
    local one_time_list = {
        ["hoshino_task_excample_kill_excample"] = true,
    }
    function hoshino_com_task_sys_for_building:OneTimeRemember(prefab)
        if one_time_list[prefab] then
            local remembered_list = TheWorld.components.hoshino_data:Get("hoshino_com_task_sys_for_building.one_time_list") or {}
            remembered_list[prefab] = true
            TheWorld.components.hoshino_data:Set("hoshino_com_task_sys_for_building.one_time_list",remembered_list)
        end
    end
    function hoshino_com_task_sys_for_building:One_Time_Remembered_Check_Succeed(prefab)
        if one_time_list[prefab] then
            local remembered_list = TheWorld.components.hoshino_data:Get("hoshino_com_task_sys_for_building.one_time_list") or {}
            if remembered_list[prefab] then
                return false
            end
        end
        return true
    end
    function hoshino_com_task_sys_for_building:Get_White_Mission_Prefabs()
        local ret_table = {}
        for i = 1, 47 do
            -- 使用 string.format 格式化数字，确保至少有两个数字，不足的前面补0
            local formatted_number = string.format("%02d", i)
            local ret_prefab = "hoshino_mission_white_" .. formatted_number
            if PrefabExists(ret_prefab) then
                table.insert(ret_table,ret_prefab)
            end
        end
        return ret_table
    end
    function hoshino_com_task_sys_for_building:Get_Blue_Mission_Prefabs()
        local ret_table = {}
        for i = 1, 45 do
            -- 使用 string.format 格式化数字，确保至少有两个数字，不足的前面补0
            local formatted_number = string.format("%02d", i)
            local ret_prefab = "hoshino_mission_blue_" .. formatted_number
            if PrefabExists(ret_prefab) then
                table.insert(ret_table,ret_prefab)
            end
        end
        return ret_table
    end
    function hoshino_com_task_sys_for_building:Get_Golden_Mission_Prefabs()
        local ret_table = {}
        for i = 1, 34 do
            -- 使用 string.format 格式化数字，确保至少有两个数字，不足的前面补0
            local formatted_number = string.format("%02d", i)
            local ret_prefab = "hoshino_mission_golden_" .. formatted_number
            if PrefabExists(ret_prefab) then
                table.insert(ret_table,ret_prefab)
            end
        end
        return ret_table
    end
    function hoshino_com_task_sys_for_building:Get_Colourful_Mission_Prefabs()
        if TheWorld.state.cycles < 40 then
            return {}
        end
        local ret_table = {}
        for i = 1, 11 do
            -- 使用 string.format 格式化数字，确保至少有两个数字，不足的前面补0
            local formatted_number = string.format("%02d", i)
            local ret_prefab = "hoshino_mission_colourful_" .. formatted_number
            if PrefabExists(ret_prefab) then
                table.insert(ret_table,ret_prefab)
            end
        end
        return ret_table
    end
    function hoshino_com_task_sys_for_building:Get_Colourful_Egg_Mission_Prefabs()
        if TheWorld.state.cycles < 40 then
            return {}
        end
        local ret_table = {}
        for i = 12, 16 do
            -- 使用 string.format 格式化数字，确保至少有两个数字，不足的前面补0
            local formatted_number = string.format("%02d", i)
            local ret_prefab = "hoshino_mission_colourful_" .. formatted_number
            if PrefabExists(ret_prefab) then
                table.insert(ret_table,ret_prefab)
            end
        end
        return ret_table
    end
    function hoshino_com_task_sys_for_building:GetNewPrefab()
        -- local white_pool = self:Get_White_Mission_Prefabs()
        -- local blue_pool = self:Get_Blue_Mission_Prefabs()
        -- local golden_pool = self:Get_Golden_Mission_Prefabs()
        -- local colourful_pool = self:Get_Colourful_Mission_Prefabs()
        -- local colourful_egg_pool = self:Get_Colourful_Egg_Mission_Prefabs()
        -------------------------------------------------------------------------
        --- 定义概率池及其权重
            local weights = {
                ["white"] = 100,
                ["blue"] = 50,
                ["golden"] = 25,
                ["colourful"] = 6,
                ["colourful_egg"] = 1,
            }
        -------------------------------------------------------------------------
        --- 从概率池中随机选择一个任务
            local chosen_pool = nil
            local chosen_pool_name = nil
            local chosen_pool_weight = nil
            local total_weight = 0
            for pool_name, pool_weight in pairs(weights) do
                total_weight = total_weight + pool_weight
            end
            local random_number = math.random(1, total_weight)
            for pool_name, pool_weight in pairs(weights) do
                if random_number <= pool_weight then
                    chosen_pool_name = pool_name
                    chosen_pool_weight = pool_weight
                    break
                end
                random_number = random_number - pool_weight
            end
            if chosen_pool_name == "white" then
                chosen_pool = self:Get_White_Mission_Prefabs()
            elseif chosen_pool_name == "blue" then
                chosen_pool = self:Get_Blue_Mission_Prefabs()
            elseif chosen_pool_name == "golden" then
                chosen_pool = self:Get_Golden_Mission_Prefabs()
            elseif chosen_pool_name == "colourful" then
                chosen_pool = self:Get_Colourful_Mission_Prefabs()
            elseif chosen_pool_name == "colourful_egg" then
                chosen_pool = self:Get_Colourful_Egg_Mission_Prefabs()
            end
            if chosen_pool == nil or #chosen_pool == 0 then
                return nil
            end
            local chosen_prefab = tostring( chosen_pool[math.random(1, #chosen_pool)] )
        -------------------------------------------------------------------------
        --- 重复检查
            if self:HasTask(chosen_prefab) then
                print("fake error : 自动刷新出现重复任务")
                return nil
            end
        -------------------------------------------------------------------------
        --- 检查是否是 单次任务
            if one_time_list[chosen_prefab] and not self:One_Time_Remembered_Check_Succeed(chosen_prefab) then
                return nil
            end
            if one_time_list[chosen_prefab] then
                self:OneTimeRemember(chosen_prefab)
            end
        -------------------------------------------------------------------------
        return chosen_prefab
    end
    function hoshino_com_task_sys_for_building:GetNewTaskItem()
        -----------------------------------------------------------------
        --- 返回任务物品inst
            local ret_prefab = nil
            while true do
                ret_prefab = self:GetNewPrefab()
                if ret_prefab then
                        print("spawn new task item",ret_prefab)                
                        local task_item = SpawnPrefab(ret_prefab)
                        if task_item then
                            if task_item.SpawnTest then
                                --- 有测试检查函数，则进行测试
                                local test_ret = task_item:SpawnTest()
                                if test_ret == true then
                                    --- 测试通过，返回物品
                                    return task_item
                                else
                                    --- 测试不通过，prefab 替换。
                                    task_item:Remove()
                                    ret_prefab = test_ret or self:GetNewPrefab()
                                end
                            else
                                --- 没有测试检查函数，直接返回物品
                                return task_item
                            end
                        end
                end
            end
        -----------------------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------
--- 用于检查
    function hoshino_com_task_sys_for_building:HasTask(prefab)
        local container_com = self:GetContainer()
        for i = 1, container_com:GetNumSlots(), 1 do
            local item = container_com:GetItemInSlot(i)
            if item and item.prefab == prefab then
                return true
            end
        end
        return false
    end
------------------------------------------------------------------------------------------------------------------------------
--- 刷新全部
    function hoshino_com_task_sys_for_building:Refresh_All()
        local container_com = self:GetContainer()
        container_com:Close()
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
--- debug
    function hoshino_com_task_sys_for_building:Debug_Set_Mission(prefab,slot)
        local container_com = self:GetContainer()
        if container_com == nil then
            return
        end
        container_com:Close()
        slot = math.clamp(slot or 1,1,6)
        local old_item = container_com.slots[slot]
        if old_item then
            old_item:Remove()
        end
        local new_item = SpawnPrefab(prefab)
        if new_item then
            if new_item:HasTag("hoshino_task_item") then
                container_com:GiveItem(new_item,slot)
            else
                new_item:Remove()
            end
        end
        self.inst:PushEvent("task_item_update")        
    end
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







