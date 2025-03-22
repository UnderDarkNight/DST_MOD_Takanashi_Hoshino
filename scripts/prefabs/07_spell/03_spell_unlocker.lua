
-- hoshino_spell_unlock_

local all_spell_names = {
    "swimming_emergency_assistance",
    "swimming_ex_support",
    "normal_heal",
    "normal_covert_operation",
    "gun_eye_of_horus_ex",
    "swimming_dawn_of_horus",
}


local ret = {}

for k, spell_name in pairs(all_spell_names) do
    local on_build = function(inst,builder)
        -- print("onBuild",builder,inst)
        inst:Remove()
        if builder:HasTag("hoshino") and not builder.components.hoshino_com_spell_cd_timer:Is_Spell_Unlocked(spell_name) then
            builder.components.hoshino_com_spell_cd_timer:Unlock_Spell(spell_name)
            -- print("解锁技能",spell_name)
        else

        end
    end
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("inventoryitem")
        inst:DoTaskInTime(0,inst.Remove)
        inst.OnBuilt = on_build
        return inst
    end    
    table.insert(ret,Prefab("hoshino_spell_unlock_"..spell_name, fn))
end

return unpack(ret)




