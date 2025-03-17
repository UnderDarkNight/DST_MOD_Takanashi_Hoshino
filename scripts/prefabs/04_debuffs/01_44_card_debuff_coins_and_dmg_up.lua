------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【貔貅】你每拥有每500信用点 +1%伤害 以此法提供的伤害加成最多不超过100%【选择之后从卡池移除】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---

------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player
        -----------------------------------------------------
        --
            inst:DoPeriodicTask(3+math.random(50)/10,function()
                local current_coins = player.components.hoshino_com_shop:GetCreditCoins()
                local num = math.floor(current_coins / 500)
                local damage_mult = math.min(num * 0.01, 1)
                player.components.combat.externaldamagemultipliers:SetModifier(inst,1+damage_mult)
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
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    return inst
end

return Prefab("hoshino_card_debuff_coins_and_dmg_up", fn)
