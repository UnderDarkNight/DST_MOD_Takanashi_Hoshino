------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    【白】 【苦路】你的饥饿，san，血量立刻开始以10/s的速度降低，在其中一项达到0的时候停止，
    你在此期间内每降低一点饥饿/san/血量就会获得2信用点
]]--
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function need_2_remove_debuff(player)
        if player.components.health:IsDead() then
            return true
        end
        if player.components.health.currenthealth < 1 then
            return true
        end
        if player.components.sanity.current < 1 then
            return true
        end
        if player.components.hunger.current < 1 then
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
    --- 
        inst:DoPeriodicTask(0.1,function()
            if need_2_remove_debuff(player) then
                inst:Remove()
                return
            end
            ---------------------------------------------
            --- health
                player.components.health.currenthealth = player.components.health.currenthealth - 1
                player.components.health:ForceUpdateHUD(true)
            ---------------------------------------------
            --- sanity
                player.components.sanity.current = player.components.sanity.current - 1
            ---------------------------------------------
            --- hunger
                player.components.hunger.current = player.components.hunger.current - 1
            ---------------------------------------------
            --- credit
                player.components.hoshino_com_shop:CreditCoinDelta(2*3)
            ---------------------------------------------
        end)
    -----------------------------------------------------
end
local function ExtendDebuff(inst)

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

return Prefab("hoshino_card_debuff_road_of_pain", fn)
