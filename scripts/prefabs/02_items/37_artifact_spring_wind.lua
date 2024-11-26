----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

Artifact 春风
（这是个项链）
不可拆解，具有唯一性。装备于护符栏位，装备该饰品时在聊天栏输入一些文字能获得相应效果，每次使用后有6分钟cd
骤雨：可以下雨或停雨（可以停酸雨和玻璃雨）
结缘：雇佣周围16码内生物（无限时间）
启迪：立刻使全天变为月圆
黯月：当晚变为月黑
掩日：当天全天变为黑夜
白昼：当天全天变为白天
岁稔：立即催熟周围30码内所有有生长周期的作物（农产品直接变为巨大作物）
借风：以自身为中心8码内所有玩家移动速度提升50%，持续8min
百炼：将自身所有有耐久的物品每秒恢复10%耐久，持续20s。

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_equipment_artifact_spring_wind.zip"),
        Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_artifact_spring_wind.tex" ),
        Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_artifact_spring_wind.xml" ),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function onequip(inst, owner)
        
    end

    local function onunequip(inst, owner)

    end
----------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("hoshino_equipment_artifact_spring_wind")
    inst.AnimState:SetBuild("hoshino_equipment_artifact_spring_wind")
    inst.AnimState:PlayAnimation("idle",true)


    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_equipment_artifact_spring_wind"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_artifact_spring_wind.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)



    MakeHauntableLaunch(inst)
    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_artifact_spring_wind", fn, assets)
