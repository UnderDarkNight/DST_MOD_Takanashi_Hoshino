--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 示例用的真伤函数。
    local excampe_damage_fn = function(player,target,damage)
        target.components.health:DoDelta(-damage)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    if inst.components.hoshino_com_real_damage == nil then
        inst:AddComponent("hoshino_com_real_damage")
    end

    inst.components.hoshino_com_real_damage:AddRealDamageFn("pigman",excampe_damage_fn)     --- 针对猪人的真伤

end