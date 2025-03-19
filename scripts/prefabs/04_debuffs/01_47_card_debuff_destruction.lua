------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【破灭】立即获得一包【神秘核心】，该神秘核心中你选择的卡牌将从卡组中移除

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player
        -----------------------------------------------------
        --
            inst:ListenForEvent("hoshino_cards_sys.card_activated",function(_,_table)
                local card_name = _table and _table.card_name
                if card_name then
                    player.components.hoshino_cards_sys:RemoveCardForever(card_name)
                    player.components.hoshino_com_debuff:Remove_Buff_Memory("hoshino_card_debuff_destruction")
                    inst:Remove()
                end
            end,player)
        -----------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function ExtendDebuff(inst)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst:AddTag("CLASSIFIED")
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    return inst
end

return Prefab("hoshino_card_debuff_destruction", fn)
