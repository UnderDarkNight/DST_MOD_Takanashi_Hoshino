----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

Artifact 春风
（这是个项链）
不可拆解，具有唯一性。装备于护符栏位，装备该饰品时在聊天栏输入一些文字能获得相应效果，每次使用后有6分钟cd
骤雨：可以下雨或停雨（可以停酸雨和玻璃雨）
结缘：雇佣周围16码内生物（无限时间）
启迪：立刻使全天变为月圆
黯月：当晚变为月黑
掩日：当天全天变为黑夜
白昼：当天全天变为白天
岁稔：立即催熟周围30码内所有有生长周期的作物（农产品直接变为巨大作物）
借风：以自身为中心8码内所有玩家移动速度提升50%，持续8min
百炼：将自身所有有耐久的物品每秒恢复10%耐久，持续20s。

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_equipment_artifact_spring_wind.zip"),
        Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_artifact_spring_wind.tex" ),
        Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_artifact_spring_wind.xml" ),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local MAX_COOL_DOWN_TIME = TUNING.HOSHINO_DEBUGGING_MODE and 10 or 6*60
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 植物生长
    --helper function for book_gardening
        local function MaximizePlant(inst)
            if inst.components.farmplantstress ~= nil then
                inst.components.farmplantstress.GetFinalStressState  = function()   --- 压力值最小
                    return FARM_PLANT_STRESS.NONE
                end
                inst.force_oversized = true --- 强制巨大化
                if inst.components.farmplanttendable then
                    inst.components.farmplanttendable:TendTo()
                end
        
                inst.magic_tending = true
                local _x, _y, _z = inst.Transform:GetWorldPosition()
                local x, y = TheWorld.Map:GetTileCoordsAtPoint(_x, _y, _z)
        
                local nutrient_consumption = inst.plant_def.nutrient_consumption
                TheWorld.components.farming_manager:AddTileNutrients(x, y, nutrient_consumption[1]*6, nutrient_consumption[2]*6, nutrient_consumption[3]*6)
            end
        end
        local function trygrowth(inst, maximize)
            if not inst:IsValid()
                or inst:IsInLimbo()
                or (inst.components.witherable ~= nil and inst.components.witherable:IsWithered()) then

                return false
            end

            if inst:HasTag("leif") then
                inst.components.sleeper:GoToSleep(1000)
                return true
            end

            if maximize then
                MaximizePlant(inst)
            end

            if inst.components.growable ~= nil then
                -- If we're a tree and not a stump, or we've explicitly allowed magic growth, do the growth.
                if inst.components.growable.magicgrowable or ((inst:HasTag("tree") or inst:HasTag("winter_tree")) and not inst:HasTag("stump")) then
                    if inst.components.simplemagicgrower ~= nil then
                        inst.components.simplemagicgrower:StartGrowing()
                        return true
                    elseif inst.components.growable.domagicgrowthfn ~= nil then
                        -- The upgraded horticulture book has a delayed start to make sure the plants get tended to first
                        inst.magic_growth_delay = maximize and 2 or nil
                        inst.components.growable:DoMagicGrowth()

                        return true
                    else
                        return inst.components.growable:DoGrowth()
                    end
                end
            end

            if inst.components.pickable ~= nil then
                if inst.components.pickable:CanBePicked() and inst.components.pickable.caninteractwith then
                    return false
                end
                if inst.components.pickable:FinishGrowing() then
                    inst.components.pickable:ConsumeCycles(1) -- magic grow is hard on plants
                    return true
                end
            end

            if inst.components.crop ~= nil and (inst.components.crop.rate or 0) > 0 then
                if inst.components.crop:DoGrow(1 / inst.components.crop.rate, true) then
                    return true
                end
            end

            if inst.components.harvestable ~= nil and inst.components.harvestable:CanBeHarvested() and inst:HasTag("mushroom_farm") then
                if inst.components.harvestable:IsMagicGrowable() then
                    inst.components.harvestable:DoMagicGrowth()
                    return true
                else
                    if inst.components.harvestable:Grow() then
                        return true
                    end
                end

            end

            return false
        end
    local function book_gardening_try_growth(target)
        local flag,ret = pcall(trygrowth,target,true)
        if flag then
            return ret
        end
        -- return trygrowth(target,true)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local spell_cmd = {
        ["骤雨"] = function(inst,player)
            -- 骤雨：可以下雨或停雨（可以停酸雨和玻璃雨）
            if TheWorld.state.israining then
                TheWorld:PushEvent("ms_forceprecipitation", false)
            else
                TheWorld:PushEvent("ms_forceprecipitation", true)
            end
            return true
        end,
        ["结缘"] = function(inst,player)
            -- 结缘：雇佣周围16码内生物（无限时间）
            local musthavetags = {"_combat"}
            local canthavetags = nil
            local musthaveoneoftags = nil
            local can_not_be_freands = {
                ["abigail"] = true,
            }
            local succeed_flag = false
            local x,y,z = player.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x,0,z,16,musthavetags, canthavetags, musthaveoneoftags)
            for k, temp_monster in pairs(ents) do
                if not can_not_be_freands[temp_monster.prefab] and temp_monster.components.health and not temp_monster.components.health:IsDead() then
                    pcall(function() -- 做免崩溃处理
                        inst:PushEvent("makefriend")
                        inst.components.leader:AddFollower(temp_monster)
                        SpawnPrefab("crab_king_shine").Transform:SetPosition(temp_monster.Transform:GetWorldPosition())
                        succeed_flag = true
                    end)
                end
            end
            return succeed_flag
        end,
        ["启迪"] = function(inst,player)
            -- 启迪：立刻使全天变为月圆
            TheWorld:PushEvent("ms_setclocksegs", {day = 0, dusk = 0, night = 16})
            TheWorld:PushEvent("ms_setmoonphase", {moonphase = "full", iswaxing = false})
            return true
        end,
        ["黯月"] = function(inst,player)
            -- 黯月：当晚变为月黑
            TheWorld:PushEvent("ms_setmoonphase", {moonphase = "new", iswaxing = true})
            return true
        end,
        ["掩日"] = function(inst,player)
            -- 掩日：当天全天变为黑夜
            TheWorld:PushEvent("ms_setclocksegs", {day = 0, dusk = 0, night = 16})
            -- TheWorld:PushEvent("ms_setmoonphase", {moonphase = "new", iswaxing = true})
            return true
        end,
        ["白昼"] = function(inst,player)
            -- 白昼：当天全天变为白天
            TheWorld:PushEvent("ms_setclocksegs", {day = 16, dusk = 0, night = 0})
            -- TheWorld:PushEvent("ms_setmoonphase", {moonphase = "new", iswaxing = true})
            return true
        end,
        ["岁稔"] = function(inst,player)
            -- 岁稔：立即催熟周围30码内所有有生长周期的作物（农产品直接变为巨大作物）
            local x,y,z = player.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x,0,z,30,{"farm_plant"})
            local acitve_flag = false
            for k, temp_plant in pairs(ents) do
                if book_gardening_try_growth(temp_plant,true) then
                    acitve_flag = true
                end
            end
            return acitve_flag
        end,
        ["借风"] = function(inst,player)
            -- 借风：以自身为中心8码内所有玩家移动速度提升50%，持续8min
            local x,y,z = player.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, 0,z,8,{"player"})
            local debuff_prefab = "hoshino_equipment_artifact_spring_wind_speed_debuff"
            for k, temp_player in pairs(ents) do
                local test_num = 100
                while test_num > 0 do
                    local debuff_inst = temp_player:GetDebuff(debuff_prefab)
                    if debuff_inst and debuff_inst:IsValid() then
                        break
                    end
                    temp_player:AddDebuff(debuff_prefab,debuff_prefab)
                    test_num = test_num - 1
                end
            end
            return true
        end,
        ["百炼"] = function(inst,player)
            -- 百炼：将自身所有有耐久的物品每秒恢复10%耐久，持续20s。
            player.components.inventory:ForEachItem(function(item)
                if item and item.components.finiteuses then
                    item:AddDebuff("hoshino_equipment_artifact_spring_wind_repair_debuff","hoshino_equipment_artifact_spring_wind_repair_debuff")
                end
            end)
            return true
        end,        
    }
    local function spell_active(inst,player,str)
        if not inst.components.rechargeable:IsCharged() then
            return
        end
        if spell_cmd[str] and spell_cmd[str](inst,player) then            
            inst.components.rechargeable:Discharge(MAX_COOL_DOWN_TIME)
        end
        -- print("spell_active",inst,player,str)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 穿戴
    local function onequip(inst, owner)
        inst.__player_event = inst.__player_event or function(player,_table)
            local str = _table and _table.str
            if type(str) == "string" then
                spell_active(inst,player,str)
            end
        end
        inst:ListenForEvent("hoshino_event.talker_say",inst.__player_event,owner)
    end

    local function onunequip(inst, owner)
        if inst.__player_event then
            inst:RemoveEventCallback("hoshino_event.talker_say",inst.__player_event,owner)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 项链本身
    local function item_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)


        inst.AnimState:SetBank("hoshino_equipment_artifact_spring_wind")
        inst.AnimState:SetBuild("hoshino_equipment_artifact_spring_wind")
        inst.AnimState:PlayAnimation("idle",true)

        MakeInventoryFloatable(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
        inst.components.inventoryitem.imagename = "hoshino_equipment_artifact_spring_wind"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_artifact_spring_wind.xml"

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)

        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetMaxCharge(MAX_COOL_DOWN_TIME)
        -- inst.components.rechargeable:Discharge(cool_down_time)
        -- inst.components.rechargeable:IsCharged()
        MakeHauntableLaunch(inst)
        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 加速debuff
    local function debuff_speed_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        inst:AddTag("CLASSIFIED")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("hoshino_data")
        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(function(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。重复添加不会执行。
            inst.entity:SetParent(target.entity)
            inst.Network:SetClassifiedTarget(target)
            inst.target = target
            print("info hoshino_equipment_artifact_spring_wind_speed_debuff active",target)
            -----------------------------------------------------
            --- 减速 15%
                if target.components.locomotor then
                    local mult = 1.5
                    target.components.locomotor:SetExternalSpeedMultiplier(inst, "hoshino_equipment_artifact_spring_wind_speed_debuff", mult)
                end
            -----------------------------------------------------
            --- 计时器初始化
                if inst.components.hoshino_data:Get("time") == nil then
                    inst.components.hoshino_data:Set("time",8*60)
                end
            -----------------------------------------------------
            --- 计时器            
                inst:DoPeriodicTask(1,function()
                    if inst.components.hoshino_data:Add("time",-1) <= 0 then
                        inst:Remove()
                    end
                end)
            -----------------------------------------------------
        end)
        inst.components.debuff:SetExtendedFn(function(inst) -- 重复添加debuff 的时候执行。
            local target = inst.target
            -----------------------------------------------------
            --- 
                inst.components.hoshino_data:Add("time",8*60)
            -----------------------------------------------------
        end)
        inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆

        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 修理debuff
    local function debuff_repair_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        inst:AddTag("CLASSIFIED")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(function(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。重复添加不会执行。
            inst.entity:SetParent(target.entity)
            inst.Network:SetClassifiedTarget(target)
            inst.target = target
            -----------------------------------------------------
            --- 每秒恢复10%

            -----------------------------------------------------
            --- 计时器            
                inst:DoPeriodicTask(1,function()
                    if target.components.finiteuses then
                        local max_finiteuses = target.components.finiteuses.total
                        local delta_finiteuses = math.ceil(max_finiteuses*0.1)
                        target.components.finiteuses:Use(-delta_finiteuses)
                    end
                    inst.time = (inst.time or 20 ) - 1
                    if inst.time <= 0 then
                        inst:Remove()
                    end
                end)
            -----------------------------------------------------
        end)
        inst.components.debuff:SetExtendedFn(function(inst) -- 重复添加debuff 的时候执行。
            local target = inst.target
            -----------------------------------------------------
            --- 
                inst.time = (inst.time or 0 ) + 20
            -----------------------------------------------------
        end)
        -- inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆

        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_artifact_spring_wind", item_fn, assets),
    Prefab("hoshino_equipment_artifact_spring_wind_speed_debuff", debuff_speed_fn, assets),
    Prefab("hoshino_equipment_artifact_spring_wind_repair_debuff", debuff_repair_fn, assets)
