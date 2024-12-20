------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    -- inst.Network:SetClassifiedTarget(target)
    inst.Transform:SetPosition(0,0,0)
    inst.player = target
    -----------------------------------------------------
    --- 链接玩家
        inst.linked_player = nil
        inst:ListenForEvent("link",function(inst,player)
            inst.linked_player = player
        end)
        function inst:GetLinkedPlayer()
            if inst.linked_player and inst.linked_player:IsValid() and not inst.linked_player:HasTag("playerghost") and target:GetDistanceSqToInst(inst.linked_player) <= 30*30 then
                return inst.linked_player
            end
            return nil
        end
    -----------------------------------------------------
    --- 分摊伤害。 每次受到伤害时，触发
        if target.components.hoshino_com_health_hooker then
            target.components.hoshino_com_health_hooker:Add_Modifier(inst,function(num)
                -- print("特殊装备背包T8 BUFF 函数 开始")
                --------------------------------------------
                -- 血量是增加的
                    if num >= 0 then
                        return num
                    end
                --------------------------------------------
                -- 
                --------------------------------------------
                -- num 此时是负数
                    local linked_player = inst:GetLinkedPlayer()
                    if linked_player == nil then
                        inst:Remove()
                        -- print("链接的玩家在范围外")
                    else
                        target:SpawnChild("wanda_attack_shadowweapon_old_fx")
                        local linked_delta = num*0.6
                        linked_player.components.health:DoDelta(linked_delta,nil,inst.prefab)

                        num = num*0.4 -- 当前玩家承受的值

                        linked_player:PushEvent("hoshino_buff_special_equipment_backpack_t8_linked",{
                            num = math.abs(linked_delta),
                            from = target,
                        })
                    end
                --------------------------------------------
                return num
            end)            
        end
    -----------------------------------------------------
    --- 
        inst:DoPeriodicTask(1, function(inst)
            local player = inst:GetLinkedPlayer()
            if player == nil then
                inst:Remove()
            end
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
    inst.entity:AddTransform()

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

return Prefab("hoshino_buff_special_equipment_backpack_t8", fn)
