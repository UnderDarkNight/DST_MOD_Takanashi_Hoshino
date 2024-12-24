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
    local function GetEquipSlot()
        if TheWorld.ismastersim then
            return TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("goggleshat") or EQUIPSLOTS.HEAD
        else
            return EQUIPSLOTS.HEAD
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 外观穿戴
    local function onequip(inst, owner)
        if inst.__onequip_task then
            inst.__onequip_task:Cancel()
            inst.__onequip_task = nil
        end
        if inst.__onunequip_task then
            inst.__onunequip_task:Cancel()
            inst.__onunequip_task = nil
        end
        inst.__onequip_task = inst:DoTaskInTime(0,function()
            inst:PushEvent("glasses_on_equip",owner)
        end)
    end

    local function onunequip(inst, owner)
        if inst.__onequip_task then
            inst.__onequip_task:Cancel()
            inst.__onequip_task = nil
        end
        if inst.__onunequip_task then
            inst.__onunequip_task:Cancel()
            inst.__onunequip_task = nil
        end
        inst.__onunequip_task = inst:DoTaskInTime(0,function()
            inst:PushEvent("glasses_on_unequip",owner)
        end)
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
--- 虚假光源
    local function fake_light_install(inst)
        if TheWorld.ismastersim then
            --------------------------------------------------------------------------------------------------------
            --- 穿戴、脱下、耐久空
                inst:ListenForEvent("glasses_on_equip",function(_,owner)
                    -- print("眼镜穿戴")                
                    if inst.components.finiteuses:GetPercent() > 0 then
                        inst:PushEvent("fake_vision_server_active",owner)
                    end
                end)
                inst:ListenForEvent("glasses_on_unequip",function(_,owner)
                    -- print("眼镜脱下")
                    inst:PushEvent("fake_vision_server_deactive",owner)
                end)
                inst:ListenForEvent("finiteuses_empty",function()
                    local owner = inst.components.inventoryitem:GetGrandOwner()
                    if owner and owner:HasTag("player") then
                        inst:PushEvent("fake_vision_server_deactive",owner)
                    end
                end)
            --------------------------------------------------------------------------------------------------------
            ---- 激活和关闭
                inst:ListenForEvent("fake_vision_server_active",function(_,owner)
                    if owner.components.grue then
                        owner.components.grue:AddImmunity("hoshino_equipment_holiday_glasses")
                    end
                    owner.components.hoshino_com_rpc_event:PushEvent("fake_vision_client_active",{},inst)
                end)

                inst:ListenForEvent("fake_vision_server_deactive",function(_,owner)
                    if owner.components.grue then
                        owner.components.grue:RemoveImmunity("hoshino_equipment_holiday_glasses")
                    end
                    owner.components.hoshino_com_rpc_event:PushEvent("fake_vision_client_deactive",{},inst)
                end)
            --------------------------------------------------------------------------------------------------------

        end

        if TheNet:IsDedicated() then
           return 
        end

        inst:ListenForEvent("fake_vision_client_active",function()
            -- print("客户端激活")
            if inst._fake_light and inst._fake_light:IsValid() or ThePlayer == nil then
                -- print("客户端激活失败")
                return
            end
            local fake_light = CreateEntity()
            inst._fake_light = fake_light

            fake_light.entity:AddTransform()
            fake_light.entity:AddLight()
            fake_light.entity:AddNetwork()        
            fake_light.Light:SetFalloff(0.1)
            fake_light.Light:SetIntensity(.9)
            fake_light.Light:SetRadius(40)
            fake_light.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
            fake_light.Light:Enable(true)
            fake_light.entity:SetParent(ThePlayer.entity)
            -- if ThePlayer.__light_test then
            --     ThePlayer.__light_test(fake_light)
            -- end

            fake_light:DoPeriodicTask(0.5,function()
                local item = ThePlayer.replica.inventory:GetEquippedItem(GetEquipSlot())
                if item ~= inst then
                    -- print("客户端激活失败+++++++",item,inst)
                    fake_light:Remove()
                    inst._fake_light = nil
                end
            end)
        end)
        inst:ListenForEvent("fake_vision_client_deactive",function()
            -- print("客户端关闭")
            if inst._fake_light and inst._fake_light:IsValid() then
                inst._fake_light:Remove()
                inst._fake_light = nil
            end
        end)



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
    fake_light_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_equipment_holiday_glasses"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_holiday_glasses.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = GetEquipSlot()
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.restrictedtag = "hoshino"


    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(function(inst)
        inst:PushEvent("finiteuses_empty")
    end)
    inst.components.finiteuses:SetMaxUses(FULL_FINITEUSES)
    inst.components.finiteuses:SetPercent(1)

    active_event_install(inst)


    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("hoshino_equipment_holiday_glasses", fn, assets)
