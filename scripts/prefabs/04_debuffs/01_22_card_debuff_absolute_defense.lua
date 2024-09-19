------------------------------------------------------------------------------------------------------------------------------------------------
--[[

58、【彩】【绝对防御】【每10s内，受到的总【血量扣除值】超过20以后，变成0】【从卡池移除】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.target = target
    -----------------------------------------------------
    --- 计数池 每10s内，受到的总【血量扣除值】超过20以后，变成0
        local num_max = 20 --- 最大值
        local num_pool = 0 --- 计数池
        local cd_task = nil --- 定时器
        local function health_delata_num_fx(num)
            -- num 进来是负数，注意处理。
            num = math.abs(num)
            if num_pool >= num_max then -- 如果已经满了
                num_pool = num_max
                return 0
            elseif num_pool < num_max and num_pool + num > num_max then -- 如果没满，但这一瞬会满
                local ret = -(num_max - num_pool)
                num_pool = num_max
                return ret
            else -- 如果没满，且这一瞬不会满
                num_pool = num_pool + num
                return -num
            end
        end
    -----------------------------------------------------
    --- 
        target.components.hoshino_com_health_hooker:Add_Modifier(inst,function(num)
            if num >= 0 then
                return num
            end
            if cd_task == nil then
                cd_task = inst:DoPeriodicTask(10,function()
                    num_pool = 0
                end)              
            end
            num = health_delata_num_fx(num)
            return num
        end)
    -----------------------------------------------------
end

local function OnDetached(inst) -- 被外部命令  inst:RemoveDebuff 移除debuff 的时候 执行
    local player = inst.target
end

local function OnUpdate(inst)
    local player = inst.target

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

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(200)

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

return Prefab("hoshino_card_debuff_absolute_defense", fn)
