------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【收集癖】你每拥有1个卡牌词条，伤害+1% 【选择之后从卡组移除】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---

------------------------------------------------------------------------------------------------------------------------------------------------
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player
        -----------------------------------------------------
        --
           
        --    player.components.combat.externaldamagemultipliers:SetModifier(inst,1.5) -- 伤害加成
        -----------------------------------------------------
        -- 计时器
            local last_flag = nil
            inst:DoPeriodicTask(5,function()
                    local ActivatedCardsData = player.components.hoshino_cards_sys:GetActivatedCards()
                    local num = 0
                    for card_name, card_acitved_num in pairs(ActivatedCardsData) do
                        if card_acitved_num > 0 then
                            num = num + 1
                        end
                    end
                    player.components.combat.externaldamagemultipliers:SetModifier(inst, 1 + num * 0.01) -- 伤害加成
                    if last_flag ~= num then
                        print("【收集癖】",player,num)
                        last_flag = num
                    end
            end)
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
    inst:AddComponent("hoshino_data")
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    return inst
end

return Prefab("hoshino_card_debuff_collecting_fetish", fn)
