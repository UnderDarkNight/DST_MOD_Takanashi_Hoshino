------------------------------------------------------------------------------------------------------------------------------------------------
--[[

58、【彩】【绝对防御】【受到任何伤害之后的20s内，受到「血量扣除结算值」不会超过20点】【从卡池移除】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.target = target
    -----------------------------------------------------
    --- 
        local num_max = 20 --- 最大值
        local num_pool = 0 --- 计数池
        local function health_delata_num_fx(num)
            if num_pool >= num_max then -- 如果计数池 >= 最大值
                return num,false
            end
            --- 注意 num 值 小于 0。
            num = math.abs(num) -- 先取绝对值
            if num_pool + num > num_max then --（计数池不够） 如果计数池 + 当前伤害值 大于 最大值
                local absorbed = num_max - num_pool  --- 能够吸收的最大伤害值
                num_pool = num_max                   --- 计数池达到最大值
                num = num - absorbed                 --- 剩余的未被吸收的伤害值
                return -num,true                          --- 返回剩余的伤害值
            else
                num_pool = num_pool + num -- (计数池充足) 计数池 = 计数池 + 当前伤害值
                return 0,true
            end
        end
    -----------------------------------------------------
    --- 
        local cd_task = nil

        target.components.hoshino_com_health_hooker:Add_Modifier(inst,function(num)
            if num >= 0 then
                return num
            end
            if cd_task then
                local ret_num,active_flag = health_delata_num_fx(num)
                num = ret_num
                if active_flag then
                    -- print("++ 成功格挡")
                else
                    -- print("## 格挡失败")
                end
            else
                cd_task = inst:DoTaskInTime(20,function()
                    cd_task = nil
                    num_pool = 0
                end)                
            end
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
