------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    【白】【窃贼】击杀血量高于50的生物会获得2信用点 【选择之后从卡组移除】
]]--
------------------------------------------------------------------------------------------------------------------------------------------------
local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(player.entity)
    -- inst.Network:SetClassifiedTarget(player)
    inst.Transform:SetPosition(0,0,0)
    inst.player = player
    -----------------------------------------------------
    --- 
        inst:ListenForEvent("killed",function(_,_table)
            local killed_target = _table and _table.victim
            if killed_target and killed_target.components.health and killed_target.components.health.maxhealth > 50 then
                player.components.hoshino_com_shop:CreditCoinDelta(2)
            end
        end,player)
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
    inst.components.debuff:SetDetachedFn(inst.Remove)
    return inst
end

return Prefab("hoshino_card_debuff_kill_and_coins_up_thief", fn)
