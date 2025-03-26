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
            target.components.health:DoDelta(-damage,nil, nil, nil, nil, true)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_real_damage







