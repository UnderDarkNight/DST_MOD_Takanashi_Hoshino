----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

沙漠核心：
饰品 amulet 无耐久
合成材料：绿洲核心*1 仙人掌核心*1 沙暴核心*1
拥有其材料的增强效果：
攻击时有15%的概率生成龙卷风（同天气风向标），龙卷风会造成每0.4秒15伤害+其最大生命值0.3%的生命流失
你被攻击时会爆出尖刺，对周围造成40点aoe伤害
你可以一次钓上很多鱼（1次钓鱼=3次）

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/armor_bramble.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 钓鱼
    local function GetNearestPool(pools,pt)
        local ret_pool = pools[1]
        local distance_sq = 10000000
        for k, temp in pairs(pools) do
            if temp and temp:IsValid() and temp.components.fishable then
                local temp_dis_sq = temp:GetDistanceSqToPoint(pt.x,0,pt.z)
                if temp_dis_sq < distance_sq then
                    distance_sq = temp_dis_sq
                    ret_pool = temp
                end
            end
        end
        return ret_pool
    end
    local function Get_Hooking_Pool(player)
        local weapon = player.components.combat:GetWeapon()
        if weapon and weapon.components.fishingrod then
            return weapon.components.fishingrod.target
        end
        return nil
    end
    local function player_fishingcollect_event(player,_table)
        local player_pt = Vector3(player.Transform:GetWorldPosition())
        local fish = _table and _table.fish
        if fish then
            local hooking_pool = Get_Hooking_Pool(player)
            fish:DoTaskInTime(1,function()
                -- SpawnPrefab("log").Transform:SetPosition(fish.Transform:GetWorldPosition())
                --- 寻找附近池子，再多次钓鱼。
                local x,y,z = fish.Transform:GetWorldPosition()
                local pools = TheSim:FindEntities(x,0,z,20,{"fishable"})
                local ret_pool = hooking_pool or GetNearestPool(pools,player_pt)
                if ret_pool then
                    local crash_flag,crash_reason = pcall(function() -- 做防崩溃处理
                        for i = 1, 2, 1 do
                        local new_fish = ret_pool.components.fishable:HookFish(player)
                        if new_fish then
                                local code = new_fish:GetSaveRecord()
                                new_fish:Remove()
                                SpawnSaveRecord(code).Transform:SetPosition(x,y,z)
                        end
                        end
                    end)
                    if not crash_flag then
                        print("error",crash_reason)
                    end

                end
            end)
        end
    end

    local function oasis_onequip(inst, owner)
        inst:ListenForEvent("fishingcollect",player_fishingcollect_event,owner)        
    end
    local function oasis_onunequip(inst,owner)
        inst:RemoveEventCallback("fishingcollect",player_fishingcollect_event,owner)        
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 反伤
    local DAMAGE_PER_HIT = 40   -- 直接反伤
    local DAMAGE_SP_PER_HIT = nil -- 位面伤害
    local function cacti_onequip(inst, owner)

            inst.__player_get_attaked_event = inst.__player_get_attaked_event or function(player,_table)
                local damage = _table and _table.damage
                if type(damage) == "number" and damage > 0 then
                        local fx = SpawnPrefab("bramblefx_armor")
                        fx.damage = DAMAGE_PER_HIT -- 直接伤害
                        if DAMAGE_SP_PER_HIT then -- 位面伤害
                            fx.spdmg = { planar = DAMAGE_SP_PER_HIT }
                            fx.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
                        end
                        fx:SetFXOwner(player)
                        if player.SoundEmitter ~= nil then
                            player.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
                        end
                end
            end
            inst:ListenForEvent("attacked",inst.__player_get_attaked_event,owner)

    end
    local function cacti_onunequip(inst, owner)
        if inst.__player_get_attaked_event then
            inst:RemoveEventCallback("attacked",inst.__player_get_attaked_event,owner)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 龙卷风
    local function getspawnlocation(inst, target)
        local x1, y1, z1 = inst.Transform:GetWorldPosition()
        local x2, y2, z2 = target.Transform:GetWorldPosition()
        return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
    end
    local function Tornado_Do_Attack_Fn(inst,_table)
        local target = _table and _table.target
        if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
            local max_health = target.components.health.maxhealth
            local delta_health = max_health * 0.3/100
            target.components.health:DoDelta(-delta_health,nil,"wind")
        end
    end
    local function player_on_hit_other_tornado_event(player,_table)
        local target = _table and _table.target
        if target and target:IsValid() and target.components.health and (TUNING.HOSHINO_DEBUGGING_MODE or math.random(1000)/1000 <=0.15) then

            local tornado = SpawnPrefab("hoshino_equipment_sandstorm_core_tornado")
            tornado.WINDSTAFF_CASTER = player
            tornado.WINDSTAFF_CASTER_ISPLAYER = tornado.WINDSTAFF_CASTER ~= nil and tornado.WINDSTAFF_CASTER:HasTag("player")
            tornado.Transform:SetPosition(getspawnlocation(player, target))
            tornado.components.knownlocations:RememberLocation("target", target:GetPosition())
            if tornado.WINDSTAFF_CASTER_ISPLAYER then
                tornado.overridepkname = tornado.WINDSTAFF_CASTER:GetDisplayName()
                tornado.overridepkpet = true
            end
            tornado.DAMAGE_PER_HIT = 40
            tornado:ListenForEvent("Tornado_Do_Attack",Tornado_Do_Attack_Fn)

        end
    end
    local function sandstorm_onequip(inst,owner)
        inst:ListenForEvent("onhitother",player_on_hit_other_tornado_event,owner)        
    end
    local function sandstorm_onunequip(inst,owner)
        inst:RemoveEventCallback("onhitother",player_on_hit_other_tornado_event,owner)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function onequip(inst, owner)
    inst:DoTaskInTime(1,function()
        oasis_onequip(inst,owner)
        cacti_onequip(inst,owner)
        sandstorm_onequip(inst,owner)
    end)
end

local function onunequip(inst, owner)
    oasis_onunequip(inst,owner)
    cacti_onunequip(inst,owner)
    sandstorm_onunequip(inst,owner)
end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)


    inst:AddTag("bramble_resistant") -- 避免被自己装备伤害

    inst.AnimState:SetBank("armor_bramble")
    inst.AnimState:SetBuild("armor_bramble")
    inst.AnimState:PlayAnimation("anim")

    inst.foleysound = "dontstarve/movement/foley/cactus_armor"

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("leafymeatburger")
            -- inst.components.inventoryitem.imagename = "hoshino_equipment_sandstorm_core"
            -- inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_sandstorm_core.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)




    MakeHauntableLaunch(inst)
    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_desert_core", fn, assets)
