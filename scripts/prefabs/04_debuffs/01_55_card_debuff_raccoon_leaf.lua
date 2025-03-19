------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【彩】【狸猫树叶】当你超过一秒未进行任何操作时，免疫所有血量扣除，一旦进行任何操作就会失去上述免疫效果。【选择后从卡组移除】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local TIME = 1
    local UPDATE_TIME = 0.1

    local BLOCKING_SG = {

    }
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player        
        -----------------------------------------------------
        ---
            inst.__working_flag = 0
        -----------------------------------------------------
            inst:DoPeriodicTask(UPDATE_TIME,function()
                if player.sg and player.sg:HasStateTag("idle") then
                    inst.__working_flag = inst.__working_flag + UPDATE_TIME
                else
                    inst.__working_flag = 0
                end
            end)
        -----------------------------------------------------
            player.components.hoshino_com_health_hooker:Add_Modifier(inst,function(num)
                if inst.__working_flag > TIME and num < 0 then
                    return 0
                end
                return num
            end)
            player.components.hoshino_com_inventory_custom_apply_damage:AddBeforeApplyDamageFn(inst,function(player,damage, attacker, weapon,spdamage)
                if inst.__working_flag > TIME then
                    return 0,{}
                end
                return damage,spdamage
            end)
        -----------------------------------------------------
        --- 屏蔽sg切换
            inst:ListenForEvent("newstate",function(_,_table)
                if inst.__working_flag < TIME then
                    return
                end
                local statename = _table and _table.statename
                -- print("6666666",statename)
                if BLOCKING_SG[statename] then
                    player.sg:GoToState("idle")
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

return Prefab("hoshino_card_debuff_raccoon_leaf", fn)
