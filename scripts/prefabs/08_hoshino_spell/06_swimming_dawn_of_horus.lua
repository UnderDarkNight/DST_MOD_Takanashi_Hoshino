--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    技能指示物品。

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/cane.zip"),
    Asset("ANIM", "anim/swap_cane.zip"),
}

local function spell_com_install(inst)
    inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_item_spell",function(inst,replica_com)
        replica_com:Set_Dotted_Circle_Radius(7)
        replica_com:Set_Mouse_Left_Click_Fn(function(inst,owner,pt,target)
                        --- 往物品自身发送event
                        owner.replica.hoshino_com_rpc_event:PushEvent("left_clicked",{
                            pt = pt
                        },inst)
        end)
        replica_com:Set_Mouse_Right_Click_Fn(function(inst,owner,pt,target)
                        --- 往物品自身发送event
                        owner.replica.hoshino_com_rpc_event:PushEvent("right_clicked",{
                            pt = pt
                        },inst)

        end)
    end)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddComponent("hoshino_com_item_spell")
    inst.components.hoshino_com_item_spell:SetNeed2CloseController(false)
    -----------------------------------------------------------------------------
    ---
        -- inst:ListenForEvent("left_clicked",function(inst,_table)
        --     print("left_clicked +++++++++++++++ ",_table.pt.x,_table.pt.y,_table.pt.z)
        --     inst:Remove()
        -- end)
        -- inst:ListenForEvent("right_clicked",function(inst,_table)
        --     inst:Remove()
        --     print("取消技能")
        -- end)
    -----------------------------------------------------------------------------
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()


    inst:AddTag("hoshino_spell_item")
    inst:AddTag("FX")
    inst:AddTag("INLIMBO")

    inst.entity:SetPristine()
    spell_com_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end



local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    -----------------------------------------------------
    --- 80% 伤害减免
        if target.components.combat then
            target.components.combat.externaldamagetakenmultipliers:SetModifier(inst,0.2)
        end
    -----------------------------------------------------
    ----
        if target.components.health then
            inst:DoPeriodicTask(3,function()
                target.components.health:DoDelta(3)
            end)
        end
    -----------------------------------------------------
end

local function buff_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst:AddTag("CLASSIFIED")
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    -- inst.components.debuff:SetDetachedFn(inst.Remove)
    -- inst.components.debuff:SetDetachedFn(OnDetached)
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)
    -- inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务
    return inst
end

return Prefab("hoshino_spell_swimming_dawn_of_horus", fn, assets),
    Prefab("hoshino_spell_swimming_dawn_of_horus_buff", buff_fn, assets)
