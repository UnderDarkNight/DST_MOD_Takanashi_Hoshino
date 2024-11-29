----------------------------------------------------------------------------------------------------------------------------------
--[[

    无人机 记录器

]]--
----------------------------------------------------------------------------------------------------------------------------------
---

----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_drone_leader = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}

    self.drones = {}
end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function hoshino_com_drone_leader:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function hoshino_com_drone_leader:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function hoshino_com_drone_leader:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function hoshino_com_drone_leader:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function hoshino_com_drone_leader:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function hoshino_com_drone_leader:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function hoshino_com_drone_leader:Add(index,num,min,max)
        if index then
            if max == nil and min == nil then
                self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
                return self.DataTable[index]
            elseif type(max) == "number" and type(min) == "number" then
                self.DataTable[index] = math.clamp( (self.DataTable[index] or 0) + ( num or 0 ) , min , max )
                return self.DataTable[index]
            end                    
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------
--- 添加记录
    function hoshino_com_drone_leader:AddDrone(target)
        self.drones[target] = true
    end
    function hoshino_com_drone_leader:RemoveDrone(target)
        self.drones[target] = false
    end
    function hoshino_com_drone_leader:RemoveDroneByGUID(guid)
        local save_guid = self:Get("save_guid") or {}
        save_guid[tostring(guid)] = nil
        self:Set("save_guid",save_guid)
    end
    function hoshino_com_drone_leader:SaveDrones()
        local drone_num = 0
        local save_guid = self:Get("save_guid") or {}
        for tempInst, flag in pairs(self.drones) do
            if tempInst and tempInst:IsValid() and flag then
                drone_num = drone_num + 1
                save_guid[tostring(tempInst.GUID)] = tempInst:GetSaveRecord()            
            end
        end
        self:Set("save_guid",save_guid)
        -- print("info 保存无人机数量：",drone_num)
    end
    function hoshino_com_drone_leader:LoadDrones()
        local drone_num = 0
        local save_guid =  self:Get("save_guid") or {}
        for tempGuid, temp_record in pairs(save_guid) do
            if tempGuid and temp_record then
                drone_num = drone_num + 1
                local tempInst = SpawnSaveRecord(temp_record)
                if tempInst then
                    tempInst.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
                    tempInst:PushEvent("link",self.inst)
                end
                save_guid[tempGuid] = nil
            end
        end
        local new_table = {}
        for tempGuid, tempPrefab in pairs(save_guid) do
            if tempGuid and tempPrefab then
                new_table[tempGuid] = tempPrefab
            end
        end
        self:Set("save_guid",new_table)
        -- print("info 已经保存无人机数量：",drone_num)
    end
------------------------------------------------------------------------------------------------------------------------------
    function hoshino_com_drone_leader:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_com_drone_leader:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_drone_leader







