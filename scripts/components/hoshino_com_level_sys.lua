----------------------------------------------------------------------------------------------------------------------------------
--[[

    

]]--
----------------------------------------------------------------------------------------------------------------------------------
--- 同步到replica
    local function GetReplica(self)
        return self.inst.replica.hoshino_com_level_sys or self.inst.replica._.hoshino_com_level_sys
    end
    local function set_level(self,value)
        local replica_com = GetReplica(self)
        if replica_com then
            replica_com:SetLevel(value)
        end
    end
    local function set_exp(self,value)
        local replica_com = GetReplica(self)
        if replica_com then
            replica_com:SetExp(value)
        end
    end
    local function set_max_exp(self,value)
        local replica_com = GetReplica(self)
        if replica_com then
            replica_com:SetMaxExp(value)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_level_sys = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}

    inst:AddTag("hoshino_com_level_sys")
    --------------------------------------------------
    --
        local max_32bit_float = 3.402823e+38

    --------------------------------------------------
    --
        self.level = 0
        self.max_level = 999999  -- 为了避免UI溢出，最大等级是这个

        self.exp = 0
        self.max_exp = 10
        self.full_max_exp = max_32bit_float  -- 最大经验值上限，避免net溢出崩溃。net_float

        self.exp_temp_pool = 0 -- 经验临时池，用于 单次获取经验 时，如果经验值不够升级，则将剩余经验值存入临时池中
    --------------------------------------------------
    -- 倍增器
        self.external_exp_multipliers = SourceModifierList(self.inst) -- exp multiplier
    --------------------------------------------------


end,
nil,
{
    level = set_level,
    exp = set_exp,
    max_exp = set_max_exp,
})
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function hoshino_com_level_sys:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function hoshino_com_level_sys:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function hoshino_com_level_sys:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function hoshino_com_level_sys:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function hoshino_com_level_sys:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function hoshino_com_level_sys:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function hoshino_com_level_sys:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------
-- 倍增器
    function hoshino_com_level_sys:GetExpMult()
        return self.external_exp_multipliers:Get()
    end
    function hoshino_com_level_sys:EXP_SetModifier(src,value)
        self.external_exp_multipliers:SetModifier(src,value)
    end
    function hoshino_com_level_sys:EXP_RemoveModifier(src)
        self.external_exp_multipliers:RemoveModifier(src)
    end
------------------------------------------------------------------------------------------------------------------------------
-- 数值设置
    function hoshino_com_level_sys:SetExp(value)
        self.exp = math.clamp(value or 0,0,self.max_exp)
    end
    function hoshino_com_level_sys:GetExp()
        return self.exp
    end
    function hoshino_com_level_sys:Exp_DoDelta(value)
        if value <= 0 then
            return
        end
        value = value * self:GetExpMult()
        self.exp_temp_pool = self.exp + value  --- 进入经验池。
        ----------------------------------------------------------------------
        ---
            while self.exp_temp_pool > 0 do
                local max_exp = self:GetMaxExp()
                if self.exp_temp_pool < max_exp then --- 经验不满
                    self:SetExp(self.exp_temp_pool)
                    self.exp_temp_pool = 0
                    break
                elseif self.exp_temp_pool == max_exp then --- 经验刚好满
                    self.exp_temp_pool = 0
                    self:Level_DoDelta(1)
                    self.inst:PushEvent("hoshino_com_level_sys.level_up",self:GetLevel()) -- Max Exp 靠这里进行更新。
                    print("玩家升级到",self:GetLevel())
                    self:ActiveMaxExpUpdate() -- 更新经验上限。
                    self:SetExp(self.exp_temp_pool)
                    break
                else --- 经验满
                    self.exp_temp_pool = self.exp_temp_pool - max_exp
                    self:Level_DoDelta(1)
                    self.inst:PushEvent("hoshino_com_level_sys.level_up",self:GetLevel()) -- Max Exp 靠这里进行更新。
                    print("玩家升级到",self:GetLevel())
                    self:ActiveMaxExpUpdate() -- 更新经验上限。
                end
            end
            self.exp_temp_pool = 0
        ----------------------------------------------------------------------
    end
    -------
    function hoshino_com_level_sys:SetMaxExp(value)
        self.max_exp = math.clamp(value or 0,10,self.full_max_exp)
    end
    function hoshino_com_level_sys:GetMaxExp()
        return self.max_exp
    end
    function hoshino_com_level_sys:MaxExp_DoDelta(value)
        self:SetMaxExp(self.max_exp + value)
    end
    function hoshino_com_level_sys:SetMaxExpUpdateFn(fn)
        if type(fn) == "function" then
            self.max_exp_update_fn = fn
        end
    end
    function hoshino_com_level_sys:ActiveMaxExpUpdate()
        if self.max_exp_update_fn then
            self.max_exp_update_fn(self)
        end
    end
    --------
    function hoshino_com_level_sys:SetLevel(value)
        self.level = math.clamp(value or 0,0,self.max_level)
    end
    function hoshino_com_level_sys:GetLevel()
        return self.level
    end
    function hoshino_com_level_sys:Level_DoDelta(value)
        self:SetLevel(self.level + value)
    end
------------------------------------------------------------------------------------------------------------------------------
    function hoshino_com_level_sys:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable,
            level = self.level,
            exp = self.exp,
            max_exp = self.max_exp,
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_com_level_sys:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        if data.level then
            self.level = data.level
        end
        if data.exp then
            self.exp = data.exp
        end
        if data.max_exp then
            self.max_exp = data.max_exp
        end
        self:ActiveOnLoadFns()
        self:ActiveMaxExpUpdate()
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_level_sys







