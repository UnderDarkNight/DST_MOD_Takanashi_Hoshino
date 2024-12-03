----------------------------------------------------------------------------------------------------------------------------------
--[[

    统一CD控制器

]]--
----------------------------------------------------------------------------------------------------------------------------------
--- 技能名和 缺省CD
    local all_spell_names = {
        ["gun_eye_of_horus_ex"] = 20,                                                               --- 【普通模式】枪，EX技能
        ["normal_heal"] = 30,                                                                       --- 【普通模式】疗愈
        ["normal_covert_operation"] = TUNING.HOSHINO_DEBUGGING_MODE and 10 or 8*60,                 --- 【普通模式】隐秘行动
        ["normal_breakthrough"] = 0,                                                                --- 【普通模式】突破
        ["swimming_ex_support"] = TUNING.HOSHINO_DEBUGGING_MODE and 10 or  60,                      --- 【游泳模式】EX支援
        ["swimming_efficient_work"] = TUNING.HOSHINO_DEBUGGING_MODE and 10 or 16*60,                --- 【游泳模式】高效作业
        ["swimming_emergency_assistance"] = 0,                                                      --- 【游泳模式】紧急支援
        ["swimming_dawn_of_horus"] = TUNING.HOSHINO_DEBUGGING_MODE and 10 or 100*60,                --- 【游泳模式】晓之荷鲁斯
        -- ["gun_eye_of_horus_ex_test"] = 30,
    }
    local max_spell_cd_time = 50000000
----------------------------------------------------------------------------------------------------------------------------------
--- 
    local function GetReplicaCom(self)
        return self.inst.replica.hoshino_com_spell_cd_timer or self.inst.replica._.hoshino_com_spell_cd_timer or nil
    end
    -- local function Unlocked_Spells(self,data)
    --     local replica_com = GetReplicaCom(self)
    --     if replica_com then
    --         replica_com:Unlock_Spell_Sync(data)
    --     end
    -- end
    local function Creating_Synchronization_Controllers()
        local ret_table = {

            -- unlocked_spells = Unlocked_Spells,

        }
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
        -- inst:DoPeriodicTask(1,function()
        --     for temp_spell_name, v in pairs(all_spell_names) do
        --         self[temp_spell_name] = math.clamp(self[temp_spell_name] - 1,0,max_spell_cd_time)
        --     end
        -- end)
        inst:DoTaskInTime(0,function()
            self:StartAllTimer()
        end)
        self.timer_delta_time = 0.1 -- 计时器的递减速度。
    ---------------------------------------------------------------------------
    --- 技能解锁记录器
        self.unlocked_spells = {}
        inst:DoTaskInTime(0,function()
            self:Unlocked_Spell_Sync()
        end)
        self:AddOnLoadFn(function()
            self.unlocked_spells = self:Get("unlocked_spells") or {}
        end)
        self:AddOnSaveFn(function()
            self:Set("unlocked_spells",self.unlocked_spells)
        end)
    ---------------------------------------------------------------------------
end,
nil,
Creating_Synchronization_Controllers() or {}
)
------------------------------------------------------------------------------------------------------------------------------
--
    function hoshino_com_spell_cd_timer:IsReady(spell_name)
        return self[spell_name] == 0 and self:Is_Spell_Unlocked(spell_name)
    end
    function hoshino_com_spell_cd_timer:StartCDTimer(spell_name, time)
        if self[spell_name] then
            self[spell_name] = time or all_spell_names[spell_name] or 30
        end
        self:StartAllTimer()
    end
------------------------------------------------------------------------------------------------------------------------------
--- 为了保证计时器 不是常开状态。所以需要手动启动计时器。    
    function hoshino_com_spell_cd_timer:StartAllTimer()
        if self.__all_timer_task ~= nil then
            return
        end
        -------------------------------------------------------------------------------------
        --- 定时循环的函数
            self.__all_timer_task_fn = self.__all_timer_task_fn or function()
                    local need_to_stop_timer_flag_num = 0
                    for temp_spell_name, v in pairs(all_spell_names) do
                        self[temp_spell_name] = math.clamp(self[temp_spell_name] - (self.timer_delta_time or 0.5),0,max_spell_cd_time)

                        need_to_stop_timer_flag_num = need_to_stop_timer_flag_num + (self[temp_spell_name] or 0)
                    end
                    if need_to_stop_timer_flag_num == 0 and self.__all_timer_task then
                        self.__all_timer_task:Cancel()
                        self.__all_timer_task = nil
                        -- print("hoshino_com_spell_cd_timer : all timer stop")
                    end
            end
        -------------------------------------------------------------------------------------
        self.__all_timer_task = self.inst:DoPeriodicTask(self.timer_delta_time or 0.5,self.__all_timer_task_fn)
    end
------------------------------------------------------------------------------------------------------------------------------
--- 技能解锁控制器
    function hoshino_com_spell_cd_timer:Unlock_Spell(spell_name)
        self.unlocked_spells[spell_name] = true
        self:Unlocked_Spell_Sync()
    end
    function hoshino_com_spell_cd_timer:Is_Spell_Unlocked(spell_name)
        return self.unlocked_spells[spell_name] == true
    end
    function hoshino_com_spell_cd_timer:Unlocked_Spell_Sync()
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:Unlock_Spell_Sync(self.unlocked_spells)
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







