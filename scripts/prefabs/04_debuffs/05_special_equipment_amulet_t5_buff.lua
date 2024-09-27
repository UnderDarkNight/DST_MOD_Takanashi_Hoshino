------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.player = target
    -----------------------------------------------------
    --- 
        target.components.combat.externaldamagemultipliers:SetModifier(inst, 1.2)
    -----------------------------------------------------
    ---
        inst:DoPeriodicTask(1.5,function()
            local x,y,z = target.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x,y,z,30,{"hoshino_special_equipment_amulet_t5_damage_mult"}) or {}
            if #ents == 0 then
                inst:Remove()
            end
        end)
    -----------------------------------------------------
    --- 恢复San
        inst:ListenForEvent("onhitother",function(player,_table)
            local monster = _table and _table.target
            if not (monster and monster.brainfn) then
                return
            end
            if player.components.sanity then
                player.components.sanity:DoDelta(5,true)
            end
        end,target)
    -----------------------------------------------------
end

local function OnDetached(inst) -- 被外部命令  inst:RemoveDebuff 移除debuff 的时候 执行
    local player = inst.player
end

local function OnUpdate(inst)
    local player = inst.player

end

local function ExtendDebuff(inst)
    -- inst.countdown = 3 + (inst._level:value() < CONTROL_LEVEL and EXTEND_TICKS or math.floor(TUNING.STALKER_MINDCONTROL_DURATION / FRAMES + .5))
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = false -- 是否保持debuff 到下次登陆
    -- inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetDetachedFn(OnDetached)
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)

    inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务


    return inst
end

return Prefab("hoshino_buff_special_equipment_amulet_t5", fn)
