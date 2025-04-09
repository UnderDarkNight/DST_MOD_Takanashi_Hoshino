------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    尼卢火
    彩蛋建筑
    材料 ：1唤月者魔杖 1神名文字碎片 1反熵水晶殖轮
    仅星野可制作，制作栏位于建筑
    无碰撞体积，只能被锤子敲毁，无法被摧毁
    为周围提供等同于矮星范围大小的光照。
    【半径30码内亮茄不会寄生】
    【半径30码内不会发生自燃（或者说自燃被扑灭）】
    【半径15码】内，每当建造该【尼卢火】的玩家攻击一次，则对【半径】7距离以内的所有敌方单位造成150点真实伤害
    建造尼卢火的玩家永久获得buff：受到的伤害*0.8（此效果最多乘算叠加三次）

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local ACITVE_RADIUS = 30    -- 作用半径
    
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local assets =
    {
        Asset("ANIM", "anim/hoshino_building_nilou_fire.zip"),
    }
------------------------------------------------------------------------------------------------------------------------------------------------
--- 灯光创建
    local function CreateLight(inst)
        inst.entity:AddLight()
        inst.Light:SetFalloff(0.2)
        inst.Light:SetIntensity(.8)
        inst.Light:SetRadius(3)
        inst.Light:SetColour(223 / 255, 208 / 255, 69 / 255)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- OnBuild
    local function on_build_event(inst,_table)
        -- print("onbuild",inst,_table.builder)
        if _table and _table.builder then
            inst.components.hoshino_data:Set("userid",_table.builder.userid)
            _table.builder.components.hoshino_com_debuff:Add_Buff_Memory("hoshino_building_nilou_fire_debuff","hoshino_building_nilou_fire_debuff",true)
        end
        inst.AnimState:PlayAnimation("place")
        inst.AnimState:PushAnimation("idle")
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- workable
    local function onhammered(inst)
        local fx = SpawnPrefab("collapse_big")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("wood")
        inst:Remove()
    end
    local function onhit(inst)
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
    local function workable_install(inst)
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(4)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)        
        local old_WorkedBy_Internal = inst.components.workable.WorkedBy_Internal
        inst.components.workable.WorkedBy_Internal = function(inst, worker, ...)
            if worker and worker:HasTag("player") then
                return old_WorkedBy_Internal(inst, worker, ...)
            end
        end
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- combat
    local BOUNCE_MUST_TAGS = { "_combat" }
    local BOUNCE_NO_TAGS = { "INLIMBO", "wall", "notarget", "player", "companion", "flight", "invisible", "noattack", "hiding" }
    local function GetPlayer(inst)  --- 范围内寻找玩家
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, 0,z ,15,{"player"})
        for k, v in pairs(ents) do
            if v and v:IsValid() and ( v.userid == inst.components.hoshino_data:Get("userid") or TUNING.HOSHINO_DEBUGGING_MODE ) then
                return v
            end
        end
        return nil
    end
    local function player_on_hit_event(player) -- 玩家攻击事件
        local x,y,z = player.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z,7,BOUNCE_MUST_TAGS,BOUNCE_NO_TAGS)
        for k, temp_monster in pairs(ents) do
            if temp_monster and temp_monster:IsValid()
                and temp_monster.components.health and not temp_monster.components.health:IsDead() then
                local damage = 150
                player.components.hoshino_com_real_damage:DoRealDamage(temp_monster,damage)
                temp_monster:PushEvent("attacked", {attacker = player, damage = damage})
            end
        end
    end
    local function search_player_task(inst) --- 周期性扫描
        local player = GetPlayer(inst)
        if player and not inst.linked_player then --- 玩家入圈，但是没安装事件
            inst:ListenForEvent("onhitother",player_on_hit_event,player)
            inst.linked_player = player            
        elseif inst.linked_player and player == nil then
            inst:RemoveEventCallback("onhitother",player_on_hit_event,player)
            inst.linked_player = nil
        end
    end
    local function combat_install(inst)
        inst:DoPeriodicTask(1,search_player_task)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 扫描事件，杀掉目标
    local one_of_tags = {"lunar_aligned","lunarthrall_plant","brightmare"}
    local lunarthrall_plant_killer =  {
        ["lunarthrall_plant"] = function(target)
            target.components.lootdropper:Hoshino_Block()
            target.components.health:Kill()
        end,
        ["lunarthrall_plant_gestalt"] = function(target)
            target:Remove()
        end,
    }
    local function Scan_And_Active(inst)
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z,ACITVE_RADIUS,nil,nil,one_of_tags)
        for k, tempInst in pairs(ents) do
            if lunarthrall_plant_killer[tempInst.prefab] then
                lunarthrall_plant_killer[tempInst.prefab](tempInst)
                return
            end
        end
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 建筑本体
    local function building_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        inst.entity:AddMiniMapEntity()


        inst.AnimState:SetBank("hoshino_building_nilou_fire")
        inst.AnimState:SetBuild("hoshino_building_nilou_fire")
        inst.AnimState:PlayAnimation("idle")

        inst.MiniMapEntity:SetIcon("hoshino_building_nilou_fire.tex")
        inst.MiniMapEntity:SetPriority(6)
        inst:AddTag("structure")
        inst:AddTag("shadecanopy") -- 半径28内无法自然
        inst:AddTag("hoshino_building_nilou_fire")
        ----------------------------------------------------
        --- 创建灯光
            CreateLight(inst)
        ----------------------------------------------------
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
        ----------------------------------------------------
        --- 
            inst:AddComponent("hoshino_data")
        ----------------------------------------------------
        --- 
            inst:AddComponent("inspectable")
            MakeHauntableLaunch(inst)
            inst:ListenForEvent("onbuilt",on_build_event)
        ----------------------------------------------------
        ---
            workable_install(inst)
            combat_install(inst)
            inst:DoPeriodicTask(1,Scan_And_Active)
        ----------------------------------------------------
        return inst
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- debuff
    local function debuff_OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        inst.Transform:SetPosition(0,0,0)
        -----------------------------------------------------
        --- 初始化
            if inst.components.hoshino_data:Get("level") == nil then
                inst.components.hoshino_data:Set("level",1)
            end
        -----------------------------------------------------
        --- 刷新. 0.8的N次方
            inst:ListenForEvent("refresh",function(inst)
                local level = inst.components.hoshino_data:Add("level",0,0,3)
                local mult = math.pow(0.8,level) 
                player.components.combat.externaldamagetakenmultipliers:SetModifier(inst,mult)
            end,player)
        -----------------------------------------------------
        ---
            inst:PushEvent("refresh")
        -----------------------------------------------------
    end
    local function debuff_ExtendDebuff(inst)
        inst.components.hoshino_data:Add("level",1)
        inst:PushEvent("refresh")
    end

    local function debuff_fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddNetwork()
        inst.entity:AddTransform()
        inst:AddTag("CLASSIFIED")
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("hoshino_data")
        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(debuff_OnAttached)
        inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
        inst.components.debuff:SetExtendedFn(debuff_ExtendDebuff)
        return inst
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- Placer Fn
    local function placer_postinit_fn(inst)
        
    end
------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_building_nilou_fire_debuff", debuff_fn, assets),
    Prefab("hoshino_building_nilou_fire", building_fn, assets),
    MakePlacer("hoshino_building_nilou_fire_placer", "hoshino_building_nilou_fire", "hoshino_building_nilou_fire", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil)

