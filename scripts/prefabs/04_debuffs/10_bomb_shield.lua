------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数表
    local AOE_RADIUS = 15
    local BOUNCE_MUST_TAGS = { "_combat" }
    local BOUNCE_NO_TAGS = { "INLIMBO", "wall", "notarget", "player", "companion", "flight", "invisible", "noattack", "hiding" } -- "player" 是为了防止玩家自己攻击自己
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function Active_Sheild_Fx(player,inst) -- 激活护盾特效
        -- if inst.__sheild_fx == nil then
        --     inst.__sheild_fx = player:SpawnChild("hoshino_sfx_ruiins_sheild")
        -- end
        -- if inst.__sheild_fx_remove_task then
        --     inst.__sheild_fx_remove_task:Cancel()
        -- end
        -- inst.__sheild_fx_remove_task = inst.__sheild_fx:DoTaskInTime(2,function()
        --     inst.__sheild_fx:PushEvent("close")
        --     inst.__sheild_fx_remove_task = nil
        -- end)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function DoAoe(player,inst) -- 爆炸范围
        local x,y,z = player.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,0,z, AOE_RADIUS, BOUNCE_MUST_TAGS, BOUNCE_NO_TAGS)
        for k, tempMonster in pairs(ents) do
            if tempMonster.components.health and not tempMonster.components.health:IsDead() then
                SpawnPrefab("hoshino_sfx_explode"):PushEvent("Set",{
                    target = tempMonster,
                })
                tempMonster.components.health:DoDelta(-666)
            end
        end
        Active_Sheild_Fx(player,inst)
    end
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
    --- 函数
        player.components.hoshino_com_inventory_custom_apply_damage:AddBeforeApplyDamageFn(inst,function(player,damage, attacker, weapon,spdamage)
            DoAoe(player,inst)
            if inst.components.hoshino_data:Add("num",-1) <= 0 then
                inst:Remove()
            end
            return 0,nil
        end)
    -----------------------------------------------------
    ---
        if inst.__sheild_fx == nil then
            inst.__sheild_fx = player:SpawnChild("hoshino_sfx_ruiins_sheild")
        end
        inst:ListenForEvent("onremove",function()
            inst.__sheild_fx:PushEvent("close")
        end)
    -----------------------------------------------------
end
local function ExtendDebuff(inst)
    inst.components.hoshino_data:Add("num", 1)
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

return Prefab("hoshino_debuff_bomb_shield", fn)
