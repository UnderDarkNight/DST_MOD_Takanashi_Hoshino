----------------------------------------------------------------------------------------------------------------------------------
--[[

    高自由度  真伤模块

    操作：

    hoshino_com_real_damage:AddRealDamageFn(prefab,fn)

    针对特定目标执行特定伤害函数。

    格式：
    fn = function(player,target,damage)
        
    end

]]--
----------------------------------------------------------------------------------------------------------------------------------
--
    local all_real_dmg_fns = {}
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_real_damage = Class(function(self, inst)
    self.inst = inst

    
end,
nil,
{

})

------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_real_damage:AddRealDamageFn(prefab,fn)
        all_real_dmg_fns[prefab] = fn
    end
    function hoshino_com_real_damage:DoRealDamage(target,damage)
        damage = math.abs(damage)
        if damage == 0 then
            return
        end
        local prefab = target.prefab
        if all_real_dmg_fns[prefab] then
            all_real_dmg_fns[prefab](self.inst,target,damage)
            return true
        end
        
        if target.components.health then
            -- 穿透型伤害实现
            local health = target.components.health
            local final_damage = damage
            
            -- 绕过所有条件检查直接操作
            health.currenthealth = math.max(0, health.currenthealth - final_damage)
            
            -- 使用原始数据更新方式
            health:DoDelta(0, true) -- 强制刷新显示
            health:SetCurrentHealth(health.currenthealth)
            
            -- 直接触发死亡事件链
            if health.currenthealth <= 0 then
                target:PushEvent("death", { 
                    afflicter = self.inst, 
                    cause = "REAL_DAMAGE_BYPASS" 
                })
            end
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_real_damage







