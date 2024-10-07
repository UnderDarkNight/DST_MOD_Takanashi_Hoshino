

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.onBuild = function(builder,inst)
        print("onBuild",builder,inst)
    end

    return inst
end

return Prefab("spell_reject_the_npc", fn)


