-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    官方的代码 在 玩家死亡的瞬间，设置 inst.components.debuffable:Enable(false)

    这个时候，会把所有激活的debuff 进行移除。

    必须在这个情况下，进行屏蔽。

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPlayerPostInit(function(inst)

    if not TheWorld.ismastersim then
        return
    end

    if inst.components.debuffable ==  nil then
        inst:AddComponent("debuffable")
    end


    local function is_hoshino_debuff(prefab)
        local start, end_ = string.find(prefab, "hoshino", 1, true)  -- 第四个参数 true 表示进行简单匹配，不使用模式匹配
        if start then
            return true  -- 如果找到 "hoshino" 返回 true
        else
            return false -- 如果没找到 "hoshino" 返回 false
        end
    end

    
    local old_RemoveDebuff = inst.components.debuffable.RemoveDebuff
    inst.components.debuffable.RemoveDebuff = function(self, name,...)
        local debuff = self.debuffs[name]
        if (not self.enable) and debuff and debuff.inst and debuff.inst.prefab and is_hoshino_debuff(debuff.inst.prefab) then
            --- enable 为 false 的时候，不进行移除
            return
        end
        return old_RemoveDebuff(self, name,...)
    end

    local old_AddDebuff = inst.components.debuffable.AddDebuff
    inst.components.debuffable.AddDebuff = function(self,name,...)
        if not self.enable and is_hoshino_debuff(name) then
            --- enable 为 false 的时候，保持继续添加
            self.enable = true
            local ret = old_AddDebuff(self,name,...)
            self.enable = false
            return ret
        end
        return old_AddDebuff(self,name,...)
    end



end)
