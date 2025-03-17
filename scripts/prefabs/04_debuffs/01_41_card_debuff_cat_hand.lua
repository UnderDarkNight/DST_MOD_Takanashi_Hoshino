------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【嗝屁猫的爪子】生命上限-40（最低保留1），获得3点固定减伤（受到的伤害-3，不包含过冷过热等扣血效果）

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
        -- 初始化次数
            if inst.components.hoshino_data:Get("active_times") == nil then
                inst.components.hoshino_data:Set("active_times",1)
            end
        -----------------------------------------------------
        --- 
            inst:ListenForEvent("refresh",function()
                local active_times = inst.components.hoshino_data:Add("active_times",0)
                --- 血量上限
                player.components.hoshino_com_max_value_controller:AddTempExtraHealth(inst,-40*active_times)
            end)
        -----------------------------------------------------
        --- 固定减伤
            player.components.hoshino_com_inventory_custom_apply_damage:AddBeforeApplyDamageFn(inst,function(player,damage, attacker, weapon, spdamage)
                damage = math.max( damage - 3*inst.components.hoshino_data:Add("active_times",0) , 0 )
                return damage,spdamage
            end)
        -----------------------------------------------------
        inst:PushEvent("refresh")
        -----------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function ExtendDebuff(inst)
        inst.components.hoshino_data:Add("active_times",1)
        inst:PushEvent("refresh")
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

return Prefab("hoshino_card_debuff_cat_hand", fn)
