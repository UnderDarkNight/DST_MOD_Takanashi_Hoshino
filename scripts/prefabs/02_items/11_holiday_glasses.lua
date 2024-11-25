----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    假日眼镜

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_equipment_holiday_glasses.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local FULL_FINITEUSES = 18*60
    local FINITEUSES_DELTA_PER_SECOND = TUNING.HOSHINO_DEBUGGING_MODE and 10 or 1
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 外观穿戴
    local function onequip(inst, owner)

    end

    local function onunequip(inst, owner)

    end
----------------------------------------------------------------------------------------------------------------------------------------------------
---
--- acceptable
    local function acceptable_com_inst(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_acceptable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,item,doer,right_click)
                if item and item.prefab == "nightmarefuel" then
                    return true
                end
                return false
            end)
            replica_com:SetText("hoshino_equipment_holiday_glasses","修理")
            replica_com:SetSGAction("dolongaction")
        end)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("hoshino_com_acceptable")
        inst.components.hoshino_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
            if inst.components.finiteuses:GetPercent() > 1 then
                return false
            end
            item.components.stackable:Get():Remove()
            inst.components.finiteuses:Use(-0.15*FULL_FINITEUSES)
            if inst.components.finiteuses:GetPercent() > 1 then
                inst.components.finiteuses:SetPercent(1)
            end
            inst:PushEvent("finiteuses_repair")
            return true
        end)

    end
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function Re_Equip(inst,owner)
        owner.components.inventory:Unequip(inst.components.equippable.equipslot)
        -- owner.components.inventory:DropItem(owner.components.inventory:Unequip(inst.components.equippable.equipslot),true,true)
        owner.components.inventory:Equip(inst)
        -- owner:PushEvent("unequip", {item=inst, eslot=inst.components.equippable.equipslot})
        -- owner:PushEvent("equip", { item = inst, eslot = inst.components.equippable.equipslot, no_animation = true })
    end
    local function active_event_install(inst)
        --------------------------------------------------------------------------------
        --- 
            inst.__finiteuses_task = nil
        --------------------------------------------------------------------------------
        --- 耐久度空的时候
            inst:ListenForEvent("finiteuses_empty",function()
                if inst:HasTag("goggles") then
                    inst:RemoveTag("goggles")
                    local owner = inst.components.inventoryitem:GetGrandOwner()
                    if inst.components.equippable:IsEquipped() and owner and owner:HasTag("player") then
                        Re_Equip(inst,owner)
                    end
                    if inst.__finiteuses_task then
                        inst.__finiteuses_task:Cancel()
                        inst.__finiteuses_task = nil
                    end                    
                end
            end)
        --------------------------------------------------------------------------------
        --- 穿戴的时候
            inst:ListenForEvent("equipped",function(_,_table)
                local owner = _table and _table.owner
                if inst.components.finiteuses:GetPercent() > 0 and owner and owner:HasTag("player") and not inst:HasTag("goggles") then
                    inst:AddTag("goggles")
                    Re_Equip(inst,owner)
                    return
                end
                if inst:HasTag("goggles") and inst.__finiteuses_task == nil and owner and owner:HasTag("player") then
                    inst.__finiteuses_task = inst:DoPeriodicTask(1,function()

                        if inst.components.inventoryitem:GetGrandOwner() and inst.components.finiteuses:GetPercent() > 0 then
                            inst.components.finiteuses:Use(FINITEUSES_DELTA_PER_SECOND)
                        else
                            inst.__finiteuses_task:Cancel()
                            inst.__finiteuses_task = nil
                            inst:RemoveTag("goggles")
                            -- print("fake error 删除tag ")
                        end
                        --- 可能重复，但是为了避免bug，依然要判断
                        if inst.components.finiteuses:GetPercent() <= 0 then
                            inst:RemoveTag("goggles")
                            -- print("fake error 删除tag ")
                            local owner = inst.components.inventoryitem:GetGrandOwner()
                            if inst.components.equippable:IsEquipped() and owner then
                                Re_Equip(inst,owner)
                                if inst.__finiteuses_task then
                                    inst.__finiteuses_task:Cancel()
                                    inst.__finiteuses_task = nil
                                end
                            end
                        end


                    end)
                end
            end)
        --------------------------------------------------------------------------------
        --- 脱下的时候
            inst:ListenForEvent("unequipped",function()
                if inst.__finiteuses_task then
                    inst.__finiteuses_task:Cancel()
                    inst.__finiteuses_task = nil
                end
            end)
        --------------------------------------------------------------------------------
        --- 修理的时候
            inst:ListenForEvent("finiteuses_repair",function()
                local owner = inst.components.inventoryitem:GetGrandOwner()
                if inst.components.equippable:IsEquipped() and owner and owner:HasTag("player") then
                    Re_Equip(inst,owner)
                end
            end)
        --------------------------------------------------------------------------------

    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_equipment_holiday_glasses")
    inst.AnimState:SetBuild("hoshino_equipment_holiday_glasses")
    inst.AnimState:PlayAnimation("idle")


    MakeInventoryFloatable(inst)



    inst.entity:SetPristine()

    acceptable_com_inst(inst)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_equipment_holiday_glasses"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_holiday_glasses.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("goggleshat") or EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)


    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(function(inst)
        inst:PushEvent("finiteuses_empty")
    end)
    inst.components.finiteuses:SetMaxUses(FULL_FINITEUSES)

    active_event_install(inst)


    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("hoshino_equipment_holiday_glasses", fn, assets)
