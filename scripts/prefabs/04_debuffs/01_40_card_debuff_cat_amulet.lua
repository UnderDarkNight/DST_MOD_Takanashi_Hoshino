------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【嗝屁猫的项圈】当你死亡时，50%的概率立即复活

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
        -- 
            inst:ListenForEvent("death",function()
                inst:DoTaskInTime(10,function()
                    if not player:HasTag("playerghost") then
                        return
                    end
                    if math.random() < 0.5 then
                        player:PushEvent("respawnfromghost", { source = inst })
                    else
                        local player_name = player:GetDisplayName()
                        TheNet:Announce("【嗝屁猫的项圈】"..player_name.."复活失败")
                    end
                end)
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
    inst.components.debuff:SetDetachedFn(inst.Remove)
    return inst
end

return Prefab("hoshino_card_debuff_cat_amulet", fn)
