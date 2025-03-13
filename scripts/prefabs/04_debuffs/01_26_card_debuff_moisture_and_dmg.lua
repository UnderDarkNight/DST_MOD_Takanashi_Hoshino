------------------------------------------------------------------------------------------------------------------------------------------------
--[[


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
    --- 初始化层数
        if inst.components.hoshino_data:Get("num") == nil then
            inst.components.hoshino_data:Set("num", 1)
        end
    -----------------------------------------------------
    -----------------------------------------------------
    --- 【雨中漫步】当你的潮湿度大于50时，造成的基础伤害提升10%
        inst:ListenForEvent("refresh",function()
            if player.components.moisture.moisture > 50 then
                local num = inst.components.hoshino_data:Get("num") or 1
                player.components.combat.externaldamagemultipliers:SetModifier(inst,1+(0.1*num))
            else
                player.components.combat.externaldamagemultipliers:SetModifier(inst,1)
            end
        end)
    -----------------------------------------------------
    --- 
        inst:ListenForEvent("moisturedelta",function()
            inst:PushEvent("refresh")
        end,player)
        inst:PushEvent("refresh")
    -----------------------------------------------------
end
local function ExtendDebuff(inst)
    inst.components.hoshino_data:Add("num", 1)
    inst:PushEvent("refresh")
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

return Prefab("hoshino_card_debuff_moisture_and_dmg", fn)
