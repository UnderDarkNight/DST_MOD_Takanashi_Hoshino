------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【彩】【命途不止】 当你死亡时，免疫死亡事件，并把生命恢复到1，上述效果持续10s，cd3min   【选择后从卡组移除】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local PROTCET_CD_TIME = 3*60    -- CD 时间
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player        
        -----------------------------------------------------
        ---
            inst.__protect_activting = nil
            inst.components.hoshino_data:Add("cd",0) -- 初始化
        -----------------------------------------------------
        --- 监听死亡事件
            inst:ListenForEvent("minhealth",function(_,_table)
                if inst.__protect_activting then
                    return
                end
                if inst.components.hoshino_data:Add("cd",0) > 0 then    --- CD期间
                    return
                end
                inst.__protect_activting = inst:DoTaskInTime(10,function()
                    inst.components.hoshino_data:Add("cd",PROTCET_CD_TIME)
                    inst.__protect_activting = nil
                    print("【命途不止】进入冷却",player)
                end)
                player.components.health.currenthealth = 1
                print("【命途不止】开启保护",player)
            end,player)
        -----------------------------------------------------
        --- 监听掉血事件
            inst:ListenForEvent("minhealth",function(_,_table)
                if inst.__protect_activting == nil then
                    return
                end
                player.components.health.currenthealth = 1
                player.components.health:ForceUpdateHUD(true)                
            end,player)
        -----------------------------------------------------
        ---
            inst:DoPeriodicTask(1,function()
                local cd_time = inst.components.hoshino_data:Add("cd",-1,0,PROTCET_CD_TIME)
                if cd_time ~= 0 then
                    -- print("【命途不止】冷却中",cd_time,player)
                end
            end)
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
    inst:AddComponent("hoshino_data")
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    inst.components.debuff:SetDetachedFn(inst.Remove)

    return inst
end

return Prefab("hoshino_card_debuff_fate_continues", fn)
