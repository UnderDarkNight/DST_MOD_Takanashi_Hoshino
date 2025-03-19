------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【封眠】受到你造成伤害的生物无法再恢复生命值

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function OnAttached_for_player(inst,player)
        inst:ListenForEvent("onhitother",function(_,_table)
            local target = _table and _table.target
            if target and target.components.health and not target.components.health:IsDead() then
                target:DoTaskInTime(0,function()
                    if not target.components.health:IsDead() then
                       target:AddDebuff(inst.prefab,inst.prefab)
                    end
                end)
            end
        end,player)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function OnAttached_for_monster(inst,monster)
        monster.components.hoshino_com_health_hooker:Add_Modifier(inst,function(num)
            if num > 0 then
                return 0
            end
            return num
        end)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(target.entity)
        -- inst.Network:SetClassifiedTarget(target)
        inst.Transform:SetPosition(0,0,0)
        inst.target = target
        -----------------------------------------------------
        --  
            if TheNet:GetPVPEnabled() then
                -- PVP不生效，避免某些奇怪的BUG
                return
            end
            if target:HasTag("player") then
                OnAttached_for_player(inst,target)
            else
                OnAttached_for_monster(inst,target)
            end
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

return Prefab("hoshino_card_debuff_block_health_auto_up", fn)
