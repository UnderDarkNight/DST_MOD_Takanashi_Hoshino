------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【宝石猎人】破坏石头时5%概率获得1随机宝石（彩虹宝石除外）（到达50%后移出池子）

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
--- 符合的列表
    local stone_prefabs = {
        ["rock1"] = true,	
        ["rock2"] = true,	
        ["rock_flintless"] = true,	
        ["rock_flintless_med"] = true,	
        ["rock_flintless_low"] = true,	
        ["rock_moon"] = true,	
        ["stalagmite_med"] = true,	
        ["stalagmite_low"] = true,	
        ["spiderhole_rock"] = true,	
        ["stalagmite_tall"] = true,	
        ["stalagmite_tall_full"] = true,	
        ["stalagmite_tall_med"] = true,	
        ["stalagmite_tall_low"] = true,	
        ["stalagmite"] = true,	
        ["stalagmite_full"] = true,
    }
    local rewards = {"redgem","orangegem","yellowgem","greengem","bluegem","purplegem"}
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player
        -----------------------------------------------------
        --
            inst:ListenForEvent("finishedwork",function(_,_table)
                local stone = _table and _table.target
                if stone and stone.prefab and stone_prefabs[stone.prefab] and stone.components.lootdropper 
                    and (math.random() <= player.components.hoshino_com_debuff:Get_Gem_Hunter() or TUNING.HOSHINO_DEBUGGING_MODE)
                    then
                    stone.components.lootdropper:SpawnLootPrefab(rewards[math.random(#rewards)])
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

return Prefab("hoshino_card_debuff_gem_hunter", fn)
