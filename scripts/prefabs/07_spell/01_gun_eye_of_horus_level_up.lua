

local function lv_1_to_2_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnBuilt = function(inst,builder)
        -- print("onBuild",builder,inst)
        builder:PushEvent("weapon_gun_eye_of_horus_level_set",2)
        inst:Remove()
    end

    return inst
end
local function lv_2_to_3_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnBuilt = function(inst,builder)
        -- print("onBuild",builder,inst)
        builder:PushEvent("weapon_gun_eye_of_horus_level_set",3)
        inst:Remove()
    end

    return inst
end

return Prefab("hoshino_spell_gun_eye_of_horus_level_1_to_2", lv_1_to_2_fn),
    Prefab("hoshino_spell_gun_eye_of_horus_level_2_to_3", lv_2_to_3_fn)


