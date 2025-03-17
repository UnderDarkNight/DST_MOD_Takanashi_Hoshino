------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【弹簧】选择这张卡时检测人物基础攻击倍率，若小于等于1则翻倍，若大于等于1.5则-30%，其他情况下选中则无影响。

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
            if inst.components.hoshino_data:Get("mult") == nil then
                local current_dmg_mult = player.components.combat.externaldamagemultipliers:Get()
                if current_dmg_mult <= 1 then
                    inst.components.hoshino_data:Set("mult",2)
                elseif current_dmg_mult >= 1.5 then
                    inst.components.hoshino_data:Set("mult",0.7)
                end
            end
        -----------------------------------------------------
        ---
            inst:DoTaskInTime(0,function()
                local mult = inst.components.hoshino_data:Get("mult") or 1
                player.components.combat.externaldamagemultipliers:SetModifier(inst,mult)
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

return Prefab("hoshino_card_debuff_spring", fn)
