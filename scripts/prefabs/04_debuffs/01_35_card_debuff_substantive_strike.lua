------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【实质打击】基础攻击伤害-50%，但是你的所有攻击会扣除敌人30点生命值 （选择之后从卡池移除）

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
            player.components.combat.externaldamagemultipliers:SetModifier(inst, 0.5) -- 伤害加成
        -----------------------------------------------------
        --
            inst.__dmg_lock = false
            inst:ListenForEvent("onhitother",function(_,_table)
                if inst.__dmg_lock then return end
                local target = _table and _table.target
                if target and target.components.health and not target.components.health:IsDead() then
                    inst.__dmg_lock = true
                    target.components.health:DoDelta(-30)
                    target:PushEvent("attacked", {attacker = player, damage = -30} )
                    inst.__dmg_lock = false
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
    inst:AddComponent("hoshino_data")
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    return inst
end

return Prefab("hoshino_card_debuff_substantive_strike", fn)
