------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【独行天途】当30码内没有友方单位时，获得buff:每次造成伤害+0.1cost，cost恢复速度+0.04/s【选择后从卡池移除】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function IsNearOtherPlayers(player)
        local x,y,z = player.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, 0, z, 30,{"player"})
        if #ents > 1 then
            return true
        end
        return false
    end
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player
        -----------------------------------------------------
        --
            inst:DoPeriodicTask(1,function()
                if not IsNearOtherPlayers(player) then
                    player.components.hoshino_com_power_cost:DoDelta(0.04)
                end
            end)
        -----------------------------------------------------
        --
            inst:ListenForEvent("onhitother",function(_,_table)
                if IsNearOtherPlayers(player) then
                    return
                end
                local damage = _table and _table.damage or 0
                if damage > 0 then
                    player.components.hoshino_com_power_cost:DoDelta(0.1)
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

return Prefab("hoshino_card_debuff_solitary_heaven_path", fn)
