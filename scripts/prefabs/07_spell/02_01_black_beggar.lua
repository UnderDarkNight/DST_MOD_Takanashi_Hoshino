----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材
    local assets =
    {
        -- Asset("ANIM", "anim/hoshino_building_white_drone.zip"),

    }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local ANIM_SCALE = 1.5
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- API
    local function FaceTo(inst,target_or_v3_or_x,_y,_z) --- 做多模态自适应
        if type(target_or_v3_or_x) == "table" then
            if target_or_v3_or_x.Transform then
                inst:ForceFacePoint(target_or_v3_or_x.Transform:GetWorldPosition())
                return
            end
            if target_or_v3_or_x.x and target_or_v3_or_x.y and target_or_v3_or_x.z then
                inst:ForceFacePoint(target_or_v3_or_x.x,target_or_v3_or_x.y,target_or_v3_or_x.z)
                return
            end
        end
        if type(target_or_v3_or_x) == "number"  and type(_y) == "number"  and  type(_z) == "number" then
            inst:ForceFacePoint(target_or_v3_or_x,_y,_z)
            return
        end
    end
    local function StopMoving(inst)
        inst.Physics:SetMotorVel(0,0,0)
        inst.Physics:Stop()
    end
    local function OnHit(inst, attacker, target)
        inst:PushEvent("OnHit",target)
    end
    local function SetSpeed(inst,speed)
        inst.components.projectile:SetSpeed(speed)        
    end

    local function SetBusy(inst,index)
        inst._busy = inst._busy or {}
        inst._busy[index] = true
    end
    local function RemoveBusy(inst,index)
        inst._busy = inst._busy or {}
        inst._busy[index] = false
    end
    local function IsBusy(inst)
        inst._busy = inst._busy or {}
        for k, flag in pairs(inst._busy) do
            if flag then
                return true
            end
        end
    end
    local function IsWorking(inst)
        return true
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 跟随玩家系统 
    local function Follow_Player_Sys_Install(inst)
        local fn = require("prefabs/07_spell/02_02_black_beggar_follow_player")
        if type(fn) == "function" then
            fn(inst)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 饥饿值 
    local function hunger_Sys_Install(inst)
        local fn = require("prefabs/07_spell/02_03_black_beggar_hunger")
        if type(fn) == "function" then
            fn(inst)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 物品接受
    local food_tags = nil
    local function IsFood(item)
        if food_tags == nil then
            food_tags = {}
            for index, v in pairs(FOODTYPE) do
                table.insert(food_tags,"edible_"..index)
            end
        end
        return item:HasOneOfTags(food_tags)
    end
    local function acceptable_com_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_acceptable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,item,doer,right_click)
                return IsFood(item) == true
            end)
            replica_com:SetText("hoshino_spell_black_beggar","喂食")
            replica_com:SetSGAction("give")
        end)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_acceptable")
        inst.components.hoshino_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
            return true
        end)    
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.entity:AddDynamicShadow()
        inst.DynamicShadow:SetSize(1*ANIM_SCALE,1*ANIM_SCALE)

        MakeInventoryPhysics(inst)
        RemovePhysicsColliders(inst)

        inst:AddTag("hoshino_spell_black_beggar")
        inst:AddTag("flying")
        inst:AddTag("projectile")
        inst:AddTag("NOBLOCK")      -- 不会影响种植和放置

        -- inst:AddTag("flying")
        inst.AnimState:SetScale(ANIM_SCALE,ANIM_SCALE,ANIM_SCALE)

        inst.AnimState:SetBank("hoshino_building_white_drone")
        inst.AnimState:SetBuild("hoshino_building_white_drone")
        inst.AnimState:PlayAnimation("ground")

        inst.Transform:SetFourFaced()
        -----------------------------------------------------------------
        --- 
            inst._linked_player = net_entity(inst.GUID,"_linked_player","_linked_player")
        -----------------------------------------------------------------
        inst.entity:SetPristine()
        -----------------------------------------------------------------
        --- 
            if TheWorld.ismastersim then
                inst:AddComponent("hoshino_data")
            end
        -----------------------------------------------------------------
        ---
            acceptable_com_install(inst)
            hunger_Sys_Install(inst)
        -----------------------------------------------------------------

        if not TheWorld.ismastersim then
            return inst
        end
        -----------------------------------------------------------------
        --- 检查
            inst:AddComponent("inspectable")
        -----------------------------------------------------------------
        --- 弹药系统
            inst:AddComponent("weapon")
            inst.components.weapon:SetDamage(0)
            inst:AddComponent("projectile")
            inst.components.projectile:SetSpeed(20)
            inst.components.projectile:SetHoming(false)
            inst.components.projectile:SetHitDist(1.5)
            inst.components.projectile:SetOnHitFn(OnHit)
            inst.components.projectile:SetOnMissFn(inst.Remove)
        -----------------------------------------------------------------
        --- API
            inst.FaceTo = FaceTo
            inst.SetSpeed = SetSpeed
            inst.SetBusy = SetBusy
            inst.RemoveBusy = RemoveBusy
            inst.IsBusy = IsBusy
            inst.IsWorking = IsWorking
            inst.StopMoving = StopMoving
        -----------------------------------------------------------------
        --- 各种系统安装
            Follow_Player_Sys_Install(inst)
        -----------------------------------------------------------------
        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_spell_black_beggar", fn, assets)