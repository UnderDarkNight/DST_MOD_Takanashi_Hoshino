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
    --- 【重装战士】移速-10% 基础攻击+5%，受到的伤害*0.95（此效果全部为乘算叠加，即选n次卡之后受伤为0.95n）
        inst:ListenForEvent("refresh",function()
            local num = inst.components.hoshino_data:Get("num") or 1
            player.components.combat.externaldamagemultipliers:SetModifier(inst,1+(0.05*num))
            -- player.components.combat.externaldamagetakenmultipliers:SetModifier(inst,math.pow(0.95,num))
            player.components.hoshino_com_health_hooker:Add_Modifier(inst, function(damage)
                if damage < 0 then 
                    return damage * math.pow(0.95, num) 
                end
                return damage
            end)
            player.components.locomotor:SetExternalSpeedMultiplier(inst, "hoshino_card_debuff_armored_warrior", math.max( 1.0-(0.1*num) , 0.1 )  )
        end)
    -----------------------------------------------------
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
    inst.components.debuff:SetDetachedFn(inst.Remove)
    return inst
end

return Prefab("hoshino_card_debuff_armored_warrior", fn)
