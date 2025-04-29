------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【洁癖】基础攻击伤害+60% 生命上限+60 但你每获得1全新词条，降低2%基础伤害 减少2生命上限【选择之后从卡组移除】

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
        -- 创建辅助器
            inst.helper = CreateEntity()
            inst.helper.entity:SetParent(inst.entity)
        -----------------------------------------------------
        -- 基础词条
            -- player.components.combat.externaldamagemultipliers:SetModifier(inst,1+0.6)
            player.components.hoshino_com_debuff:Add_Damage_Mult(0.6)
            player.components.hoshino_com_max_value_controller:AddTempExtraHealth(inst,60)
        -----------------------------------------------------
        --- 激活卡牌的时候记录
            inst:ListenForEvent("hoshino_cards_sys.actived_card_fn",function(_,data)
                player.components.hoshino_com_debuff:Add_Neatness_Obsession(1)
                player.components.hoshino_com_debuff:Add_Damage_Mult(-2/100)
                inst:PushEvent("refresh_param_down")
            end,player)
        -----------------------------------------------------
        ---
            inst:ListenForEvent("refresh_param_down",function()
                -- local crash_flag,crash_reason = pcall(function()
                    local num = player.components.hoshino_com_debuff:Get_Neatness_Obsession() or 0
                    -- player.components.combat.externaldamagemultipliers:SetModifier(inst.helper,math.max(0,1-0.02*num))
                    player.components.hoshino_com_max_value_controller:AddTempExtraHealth(inst.helper,-2*num)
                    print("info 【洁癖】 Down 层数 : ",num,player)
                -- end)
                -- if not crash_flag then
                --     print("error 【洁癖】 层数检查: ",crash_reason)
                -- end
            end)
        -----------------------------------------------------
        ---
            inst:PushEvent("refresh_param_down")            
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
    inst.components.debuff:SetDetachedFn(inst.Remove)
    return inst
end

return Prefab("hoshino_card_debuff_neatness_obsession", fn)
