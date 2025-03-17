------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local WEAPON_RANGE = 2 -- 武器攻击范围
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function weapon_checker(weapon)
        if weapon == nil or weapon.components.weapon == nil then
            return false
        end
        -- if TUNING.HOSHINO_DEBUGGING_MODE then
        --     return true
        -- end
        if (weapon.components.weapon.attackrange or 0) <= WEAPON_RANGE then
            return true
        end
        if (weapon.components.weapon.attackrange or 0) <= WEAPON_RANGE then
            return true
        end
        return false
    end
------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(player.entity)
    -- inst.Network:SetClassifiedTarget(player)
    inst.Transform:SetPosition(0,0,0)
    inst.player = player
    -----------------------------------------------------
    --- 初始化层数
        if inst.components.hoshino_data:Get("num") == nil then
            inst.components.hoshino_data:Set("num", 1)
        end
    -----------------------------------------------------
    --- 你使用攻击距离小于等于2的武器时伤害+12%（可叠加）
        player.components.hoshino_com_combat_hooker:Add_CalcDamage_Modifier(inst,function(player,target,damage,spdamage,weapon,multiplier)
            -- print("AAAAAAAAAAA",player,target,damage,weapon,weapon_checker(weapon))
            if weapon_checker(weapon) then
                local num = inst.components.hoshino_data:Get("num") or 1
                damage = damage*(1+num*0.12)
                if type(spdamage) == "table" then
                    for dmg_type, value in pairs(spdamage) do
                        spdamage[dmg_type] = value*(1+num*0.12)
                    end
                end
            end
            return damage,spdamage
        end)
    -----------------------------------------------------
end
local function ExtendDebuff(inst)
    inst.components.hoshino_data:Add("num", 1)
end

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

return Prefab("hoshino_card_debuff_weapon_dmg_up_by_range", fn)
