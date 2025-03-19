------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【白】【活力迸发】回复所有三维（生命，饥饿，san），并获得buff：攻击+50%，此buff持续5min。

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
           inst:ListenForEvent("add_time",function(inst,dt)
                inst.components.hoshino_data:Add("time",dt)
           end)
        -----------------------------------------------------
        --
           player.components.combat.externaldamagemultipliers:SetModifier(inst,1.5) -- 伤害加成
        -----------------------------------------------------
        -- 计时器
           inst:DoPeriodicTask(1,function()
                if inst.components.hoshino_data:Add("time",-1) <= 0 then
                    inst:Remove()
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
    inst.components.debuff:SetDetachedFn(inst.Remove)
    return inst
end

return Prefab("hoshino_card_debuff_energy_burst", fn)
