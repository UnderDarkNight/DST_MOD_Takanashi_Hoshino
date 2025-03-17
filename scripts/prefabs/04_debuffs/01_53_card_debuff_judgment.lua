------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【彩】 【裁定】此后被回收的卡牌将从卡组中移除，且返还信用点（白卡100 金卡500 彩卡2000）    【选择之后从卡组移除】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player        
        -----------------------------------------------------
        ---
            local CardPools = {
                ["card_white"] = 100,
                ["card_colourful"] = 500,
                ["card_golden"] = 2000,
                -- ["card_black"] = 0.6,
            }
            inst:ListenForEvent("hoshino_cards_sys.card_recycled",function(_,_table)
                local card_name = _table and _table.card_name or nil
                local card_type = _table and _table.card_type or nil
                if card_name and card_type and card_type ~= "card_black" and CardPools[card_type] then
                    player.components.hoshino_cards_sys:RemoveCardForever(card_name)
                    player.components.hoshino_com_shop:CreditCoinDelta(CardPools[card_type])
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
    return inst
end

return Prefab("hoshino_card_debuff_judgment", fn)
