----------------------------------------------------------------------------------------------------------------------------------
--[[

    统一CD控制器

]]--
----------------------------------------------------------------------------------------------------------------------------------
--- 技能名和CD
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
local hoshino_com_spell_cd_timer = Class(function(self, inst)
    self.inst = inst
    ---------------------------------------------------------------------------
    --- 
        self._net_index = {}
    ---------------------------------------------------------------------------
    --- 创建 net 管道。
        for temp_spell_name, v in pairs(all_spell_names) do
            local index = "_net_vars_"..temp_spell_name
            table.insert(self._net_index,index)
            self[index] = net_float(inst.GUID,"hoshino_com_spell_cd_timer."..temp_spell_name,"hoshino_com_spell_cd_timer_update")
        end
    ---------------------------------------------------------------------------
    --- 创建外部调取API
        for temp_spell_name, v in pairs(all_spell_names) do
            self[string.upper(temp_spell_name)] = function(self,value)
                self["_net_vars_"..temp_spell_name]:set(value)
            end
            self["GET_"..string.upper(temp_spell_name)] = function(self)
                return self["_net_vars_"..temp_spell_name]:value()
            end
        end
    ---------------------------------------------------------------------------
    -- 
        -- if not TheNet:IsDedicated() then
        --     inst:ListenForEvent("hoshino_com_spell_cd_timer_update",function()
        --         for temp_spell_name, v in pairs(all_spell_names) do
        --             print("spell cd time update",temp_spell_name,self:GetTime(temp_spell_name))
        --         end
        --     end)
        -- end
    ---------------------------------------------------------------------------
end)
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_spell_cd_timer:IsReady(spell_name)
        local index = "_net_vars_"..spell_name
        if self[index] == nil then
            return false
        end
        return self[index]:value() <= 0
    end
    function hoshino_com_spell_cd_timer:GetTime(spell_name)
        local index = "_net_vars_"..spell_name
        if self[index] == nil then
            return 0
        end
        return self[index]:value()
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_spell_cd_timer







