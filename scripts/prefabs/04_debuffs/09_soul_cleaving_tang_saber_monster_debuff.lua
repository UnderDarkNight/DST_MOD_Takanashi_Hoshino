------------------------------------------------------------------------------------------------------------------------------------------------



local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    -- inst.Network:SetClassifiedTarget(target)
    inst.Transform:SetPosition(0,0,0)
    -----------------------------------------------------
    ---
        local linked_monster = target.linked_monster
        if linked_monster == nil or target.components.health == nil or linked_monster.components.health == nil then
            target:Remove()
        end
    -----------------------------------------------------
    ---
        target:AddTag("spawned_by_soul_cleaving_tang_saber")
    -----------------------------------------------------
    ---
        local linked_monster_old_DoDelta = linked_monster.components.health.DoDelta
        linked_monster.components.health.DoDelta = function(self,num,...)
            -- if not inst:IsValid() then
            --     linked_monster.components.health.DoDelta = linked_monster_old_DoDelta
            --     return linked_monster_old_DoDelta(self,num,...)
            -- end
            -- 先屏蔽回血
            if num > 0 then
                num = 0
            end
            -- 屏蔽掉血
            if not inst.unlock_flag then
                num = 0
            end
            return linked_monster_old_DoDelta(self,num,...)
        end
    -----------------------------------------------------
    ---
        local target_old_DoDelta = target.components.health.DoDelta
        target.components.health.DoDelta = function(self,num, overtime, cause, ignore_invincible, afflicter, ignore_absorb,...)
            -- 先屏蔽回血
            if num > 0 then
                num = 0
            end
            --- 同步扣血
            if num < 0 then
                inst.unlock_flag = true
                linked_monster.components.health:DoDelta(num, overtime, cause, true, afflicter, true,...)
                inst.unlock_flag = false
            end
            return target_old_DoDelta(self,num, overtime, cause, ignore_invincible, afflicter, ignore_absorb,...)
        end
    -----------------------------------------------------
    --- 
        inst:ListenForEvent("minhealth",function()
            linked_monster:RemoveTag("linked_by_soul_cleaving_tang_saber")
            target.components.health.DoDelta = target_old_DoDelta
            linked_monster.components.health.DoDelta = linked_monster_old_DoDelta
            inst:Remove()
            local brain_debuff = linked_monster:GetDebuff("hoshino_debuff_gun_eye_of_horus_spell_monster_brain_stop")
            if brain_debuff then
                brain_debuff:PushEvent("force_remove")
            end
        end,target)
    -----------------------------------------------------
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

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆

    return inst
end

return Prefab("hoshino_debuff_soul_cleaving_tang_saber_monster_debuff", fn)
