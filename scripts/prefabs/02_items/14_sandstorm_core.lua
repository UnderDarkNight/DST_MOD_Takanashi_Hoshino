----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    沙暴核心
    饰品 amulet， 无耐久 
    合成材料：以太精髓*1 镒*1 阿拜多斯高纯度合金*1 在远古伪科学站合成
    装备后攻击时有15%的概率生成龙卷风（同天气风向标），龙卷风会造成每0.5秒15伤害+其最大生命值0.2%的生命流失

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------

local assets = {
    Asset("ANIM", "anim/hoshino_equipment_sandstorm_core.zip"), 
    Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_sandstorm_core.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_sandstorm_core.xml" ),
}
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 			attacker:PushEvent("onhitother", { target = self.inst, damage = damage, damageresolved = damageresolved, stimuli = stimuli, spdamage = spdamage, weapon = weapon, redirected = damageredirecttarget })
    local function getspawnlocation(inst, target)
        local x1, y1, z1 = inst.Transform:GetWorldPosition()
        local x2, y2, z2 = target.Transform:GetWorldPosition()
        return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
    end
    local function Tornado_Do_Attack_Fn(inst,_table)
        local target = _table and _table.target
        if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
            local max_health = target.components.health.maxhealth
            local delta_health = max_health * 0.2/100/2
            target.components.health:DoDelta(-delta_health,nil,"wind")
        end
    end
    local function player_on_hit_other_event(player,_table)
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
            tornado.DAMAGE_PER_HIT = 15/2
            tornado:ListenForEvent("Tornado_Do_Attack",Tornado_Do_Attack_Fn)

        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--
    local function onequip(inst, owner)
        inst:DoTaskInTime(1,function()
            owner:ListenForEvent("onhitother",player_on_hit_other_event)
        end)
    end
    local function onunequip(inst, owner)
        owner:RemoveEventCallback("onhitother",player_on_hit_other_event)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 动画控制器
    local function Player_Near(inst)
        if inst:IsOnOcean(false) then
            inst.AnimState:HideSymbol("shadow")
        else
            inst.AnimState:ShowSymbol("shadow")
        end
        inst.AnimState:PlayAnimation("proximity_pre")
        inst.AnimState:PushAnimation("proximity_loop",true)
    end
    local function Player_Far(inst)
        if inst:IsOnOcean(false) then
            inst.AnimState:HideSymbol("shadow")
        else
            inst.AnimState:ShowSymbol("shadow")
        end
        -- inst.AnimState:PlayAnimation("proximity_loop")
        inst.AnimState:PushAnimation("proximity_pst")
        inst.AnimState:PushAnimation("idle",true)
    end
    local function DropInWater(inst)
        inst.AnimState:HideSymbol("shadow")
    end
    local function DropLanded(inst)
        inst.AnimState:ShowSymbol("shadow")
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("moonrock_seed")
    inst.AnimState:SetBuild("hoshino_equipment_sandstorm_core")
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    MakeInventoryFloatable(inst)


    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    -------------------------------------------------------------------
    ------ 物品名 和检查文本
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
        inst.components.inventoryitem.imagename = "hoshino_equipment_sandstorm_core"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_sandstorm_core.xml"
        -- inst.components.inventoryitem:SetSinks(true)    -- 掉水里消失

    -------------------------------------------------------------------
    ----
        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY
    -------------------------------------------------------------------
        MakeHauntableLaunch(inst)
    -------------------------------------------------------------------
    ---
        inst:AddComponent("playerprox")
        inst.components.playerprox:SetDist(5, 6)
        inst.components.playerprox:SetOnPlayerNear(Player_Near)
        inst.components.playerprox:SetOnPlayerFar(Player_Far)
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                DropInWater(inst)
            else                                
                DropLanded(inst)
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    
    return inst
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 龙卷风
    --[[
            local function spawntornado(staff, target, pos)
                local tornado = SpawnPrefab("tornado", staff.linked_skinname, staff.skin_id)
                tornado.WINDSTAFF_CASTER = staff.components.inventoryitem.owner
                tornado.WINDSTAFF_CASTER_ISPLAYER = tornado.WINDSTAFF_CASTER ~= nil and tornado.WINDSTAFF_CASTER:HasTag("player")
                tornado.Transform:SetPosition(getspawnlocation(staff, target))
                tornado.components.knownlocations:RememberLocation("target", target:GetPosition())

                if tornado.WINDSTAFF_CASTER_ISPLAYER then
                    tornado.overridepkname = tornado.WINDSTAFF_CASTER:GetDisplayName()
                    tornado.overridepkpet = true
                end

                staff.components.finiteuses:Use(1)
            end
    ]]--
    local brain = require("brains/tornadobrain")
    local function ontornadolifetime(inst)
        inst.task = nil
        inst.sg:GoToState("despawn")
    end

    local function SetDuration(inst, duration)
        if inst.task ~= nil then
            inst.task:Cancel()
        end
        inst.task = inst:DoTaskInTime(duration, ontornadolifetime)
    end
    local function tornado_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.AnimState:SetFinalOffset(2)
        inst.AnimState:SetBank("tornado")
        inst.AnimState:SetBuild("tornado")
        inst.AnimState:PlayAnimation("tornado_pre")
        inst.AnimState:PushAnimation("tornado_loop")

        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")

        MakeInventoryPhysics(inst)
        RemovePhysicsColliders(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("knownlocations")

        inst:AddComponent("locomotor")
        inst.components.locomotor.walkspeed = TUNING.TORNADO_WALK_SPEED * .33
        inst.components.locomotor.runspeed = TUNING.TORNADO_WALK_SPEED

        -- inst:SetStateGraph("SGtornado")
        inst:SetStateGraph("SGsandstorm_core_tornado_tornado")
        inst:SetBrain(brain)

        inst.WINDSTAFF_CASTER = nil
        inst.persists = false
        inst.DAMAGE_PER_HIT = TUNING.TORNADO_DAMAGE -- 单次攻击伤害。SG会调用。

        inst.SetDuration = SetDuration
        inst:SetDuration(TUNING.TORNADO_LIFETIME)

        -- -- 来自SG 的回环 event
        -- inst:ListenForEvent("Tornado_Do_Attack",function(_,_table)
        --     local target = _table and _table.target
        -- end)

        return inst
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_sandstorm_core", fn, assets),
    Prefab("hoshino_equipment_sandstorm_core_tornado", tornado_fn, assets)