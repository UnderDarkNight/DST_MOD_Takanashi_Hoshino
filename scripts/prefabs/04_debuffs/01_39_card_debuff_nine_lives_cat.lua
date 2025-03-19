------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【嗝屁猫】当你死亡时，你立刻复活，此效果最多触发九次，但是你获得诅咒【无实体】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local MAX_LIVES = 9
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player
        -----------------------------------------------------
        -- 初始化
            if inst.components.hoshino_data:Get("lives") == nil then
                inst.components.hoshino_data:Set("lives",MAX_LIVES)
            end
        -----------------------------------------------------
        --  
            local cd_task = nil
            local last_info_lives_num = nil
            inst:DoPeriodicTask(5,function()
                if player:HasTag("playerghost") and player.components.playercontroller:IsEnabled() and cd_task == nil then
                    cd_task = inst:DoTaskInTime(30,function()
                        cd_task = nil
                    end)
                    player:PushEvent("respawnfromghost", { source = inst })

                    if inst.components.hoshino_data:Add("lives",-1) <= 0 then
                        inst:Remove()
                    end
                end
                local current_lives_num = inst.components.hoshino_data:Add("lives",0)
                if current_lives_num ~= last_info_lives_num and not player:HasTag("playerghost") and player.components.playercontroller:IsEnabled() then
                    last_info_lives_num = current_lives_num
                    local player_name = player:GetDisplayName()
                    TheNet:Announce("【嗝屁猫】"..player_name.."还剩下"..current_lives_num.."次复活机会")
                end
            end)
        -----------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function ExtendDebuff(inst)
        inst.components.hoshino_data:Set("lives",MAX_LIVES)
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

return Prefab("hoshino_card_debuff_nine_lives_cat", fn)
