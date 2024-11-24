----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

龙蝇之护：
饰品 amulet 耐久16min
龙蝇掉落
免疫火焰伤害 免疫过热伤害 你的所有动作加快20%（这个效果有参考代码）

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/armor_bramble.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- finiteuses
    local MAX_FINITEUSES = TUNING.HOSHINO_DEBUGGING_MODE and 20 or 16*60
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function onequip(inst, owner)
        if owner.components.health then
            owner.components.health.externalfiredamagemultipliers:SetModifier(inst,0)
        end
        if owner.components.temperature then
            local old_overheattemp = owner.components.temperature.overheattemp
            inst.overheattemp = old_overheattemp
            owner.components.temperature.overheattemp = 1000

            inst.__overheattemp_remove_event = function()
                owner.components.temperature.overheattemp = old_overheattemp
                print("info overheattemp removed")
            end
            inst:ListenForEvent("onremove",inst.__overheattemp_remove_event)
        end
        if inst.__finiteuses_task == nil then
            inst.__finiteuses_task = inst:DoPeriodicTask(1,function()
                inst.components.finiteuses:Use(1)
            end)
        end
    end

    local function onunequip(inst, owner)
        if owner.components.health then
            owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
        end
        if owner.components.temperature and inst.overheattemp then
            owner.components.temperature.overheattemp = inst.overheattemp
            inst.overheattemp = nil
        end
        if inst.__overheattemp_remove_event then
            inst:RemoveEventCallback("onremove",inst.__overheattemp_remove_event)
            inst.__overheattemp_remove_event = nil
        end
        if inst.__finiteuses_task ~= nil then
            inst.__finiteuses_task:Cancel()
            inst.__finiteuses_task = nil
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    -- inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("armor_bramble")
    inst.AnimState:SetBuild("armor_bramble")
    inst.AnimState:PlayAnimation("anim")


    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("leafymeatburger")
            -- inst.components.inventoryitem.imagename = "hoshino_equipment_sandstorm_core"
            -- inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_sandstorm_core.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL*6
    -- inst.components.equippable.is_magic_dapperness = true

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(MAX_FINITEUSES)
    inst.components.finiteuses:SetPercent(1)
    inst.components.finiteuses:SetOnFinished(inst.Remove)


    MakeHauntableLaunch(inst)
    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_dragonfly_core", fn, assets)
