------------------------------------------------------------------------------------------------------------------------------------------------
--[[

56、【彩】【每次升级额外获得一包「升级卡包」，同时每次升级 20%概率获得随机诅咒】【不可叠加，选择后从卡组移除】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    inst.target = target
    -----------------------------------------------------
    --- event
        inst:ListenForEvent("hoshino_com_level_sys.level_up",function()            
            ---------------------------------------------
            --- 给个卡包
                local item = SpawnPrefab("hoshino_item_cards_pack")
                item.components.inventory:GiveItem(item)
            ---------------------------------------------
            --- 上诅咒
                if math.random(10000)/10000 < 0.2 then
                    local black_card_name_index = target.components.hoshino_cards_sys:SelectRandomCardFromPoolByType("card_black")
                    if black_card_name_index then
                        target.components.hoshino_cards_sys:AcitveCardFnByIndex(black_card_name_index)
                    end
                end
            ---------------------------------------------
        end,target)
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

return Prefab("hoshino_card_debuff_level_up_and_double_card_pack", fn)
