----------------------------------------------------------------------------------------------------------------------------------
--[[

    统一CD控制器

]]--
----------------------------------------------------------------------------------------------------------------------------------
--- 技能名和 缺省CD
    local all_spell_names = {
        ["gun_eye_of_horus_ex"] = 20,
        ["gun_eye_of_horus_ex_test"] = 30,
    }
    local max_spell_cd_time = 500000
----------------------------------------------------------------------------------------------------------------------------------
--- 
    local function GetReplicaCom(self)
        return self.inst.replica.hoshino_com_spell_cd_timer or self.inst.replica._.hoshino_com_spell_cd_timer or nil
    end

    local function Creating_Synchronization_Controllers()
        local ret_table = {}
        for temp_spell_name, v in pairs(all_spell_names) do
                ret_table[temp_spell_name] = function(self,value)
                    local replica_com = GetReplicaCom(self)
                    if replica_com and replica_com[string.upper(temp_spell_name)] then -- API 用大写。避免造成函数混乱。
                        replica_com[string.upper(temp_spell_name)](replica_com,value)
                    end
                end
        end
        return ret_table
    end
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_spell_cd_timer = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}
    ---------------------------------------------------------------------------
    --- 

    ---------------------------------------------------------------------------
    --- 数据储存。
        for temp_spell_name, v in pairs(all_spell_names) do
            self[temp_spell_name] = 0
        end
        self:AddOnSaveFn(function()
            for temp_spell_name, v in pairs(all_spell_names) do
                self:Set(temp_spell_name,self[temp_spell_name])
            end
        end)
        self:AddOnLoadFn(function()
            for temp_spell_name, v in pairs(all_spell_names) do
                local temp_num = self:Get(temp_spell_name)
                if temp_num then
                    self[temp_spell_name] = temp_num
                end
            end
        end)
    ---------------------------------------------------------------------------
    --- 刷计时器。
        inst:DoPeriodicTask(1,function()
            for temp_spell_name, v in pairs(all_spell_names) do
                self[temp_spell_name] = math.clamp(self[temp_spell_name] - 1,0,max_spell_cd_time)
            end
        end)
    ---------------------------------------------------------------------------
end,
nil,
Creating_Synchronization_Controllers() or {}
)
------------------------------------------------------------------------------------------------------------------------------
--
    function hoshino_com_spell_cd_timer:IsReady(spell_name)
        return self[spell_name] == 0
    end
    function hoshino_com_spell_cd_timer:StartCDTimer(spell_name, time)
        if self[spell_name] then
            self[spell_name] = time or all_spell_names[spell_name] or 30
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function hoshino_com_spell_cd_timer:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function hoshino_com_spell_cd_timer:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function hoshino_com_spell_cd_timer:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function hoshino_com_spell_cd_timer:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存
    function hoshino_com_spell_cd_timer:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function hoshino_com_spell_cd_timer:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function hoshino_com_spell_cd_timer:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
    function hoshino_com_spell_cd_timer:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_com_spell_cd_timer:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_spell_cd_timer







