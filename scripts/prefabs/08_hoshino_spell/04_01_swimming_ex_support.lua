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
        replica_com:Set_Dotted_Circle_Radius(16)
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

return Prefab("hoshino_spell_swimming_ex_support", fn, assets)
