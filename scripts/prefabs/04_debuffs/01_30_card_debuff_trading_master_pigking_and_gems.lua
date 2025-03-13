------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【白】【交易高手】与猪王交易时2.5%额外获得一颗随机初级宝石【红，蓝，紫】，达到100%后移除

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
-- 
    local Gems = {
        ["redgem"] = 1,
        ["bluegem"] = 1,
        ["purplegem"] = 1,
    }
------------------------------------------------------------------------------------------------------------------------------------------------
local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(player.entity)
    -- inst.Network:SetClassifiedTarget(player)
    inst.Transform:SetPosition(0,0,0)
    inst.player = player
    -----------------------------------------------------
    --
        inst:ListenForEvent("hoshino_event.pigking_accepted",function(_,item)
            -- print("debuff : pigking accepted",player,item)
            local percent = player.components.hoshino_com_debuff:Get_PigKing_Trade_And_Gems_Percent()
            if math.random() <= percent or TUNING.HOSHINO_DEBUGGING_MODE then
                local prefab,num = GetRandomItemWithIndex(Gems)
                local item = SpawnPrefab(prefab)
                item.components.stackable.stacksize = num
                player.components.inventory:GiveItem(item)
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
    return inst
end

return Prefab("hoshino_card_debuff_trading_master_pigking_and_gems", fn)
