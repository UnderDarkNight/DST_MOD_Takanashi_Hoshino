------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.player = target
    -----------------------------------------------------
    ---
        inst:DoPeriodicTask(1,function()
            -------------------------------------------
            --- 计时器
                local time = target.components.hoshino_data:Add("hoshino_spell_normal_covert_operation_buff",-1)
                if time <= 0 then
                    inst:Remove()
                    if target.components.hoshino_com_tag_sys then
                        target.components.hoshino_com_tag_sys:RemoveTag("hoshino_tag.combat_set_target_block")
                    end
                end
            -------------------------------------------
            ---
                if target:HasTag("playerghost") then
                    return
                end
            -------------------------------------------
            --- hoshino_tag.combat_set_target_block
                if target.components.hoshino_com_tag_sys then
                    target.components.hoshino_com_tag_sys:AddTag("hoshino_tag.combat_set_target_block")
                end
            -------------------------------------------
            ---
                local x,y,z = target.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, y, z, 50, {"_combat"})
                for k, monster in pairs(ents) do
                    if monster and monster.components.combat and monster.components.combat.target == target then
                        monster.components.combat:DropTarget()
                    end
                end
            -------------------------------------------
        end)
        inst:ListenForEvent("SetTime",function(inst,time)
            target.components.hoshino_data:Set("hoshino_spell_normal_covert_operation_buff",time)
        end)
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
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    -- inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetDetachedFn(OnDetached)
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)

    -- inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务


    return inst
end

return Prefab("hoshino_spell_normal_covert_operation_buff", fn)
