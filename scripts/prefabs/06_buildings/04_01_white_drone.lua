----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_building_white_drone.zip"),
        Asset("IMAGE", "images/inventoryimages/hoshino_building_white_drone_item.tex"),
		Asset("ATLAS", "images/inventoryimages/hoshino_building_white_drone_item.xml"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local ANIM_SCALE = 1.5
    local MAX_FUELED_TIME = TUNING.HOSHINO_DEBUGGING_MODE and 60*60 or 18*60
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
    local function StartFly(inst,call_back_fn)
        if inst.components.fueled:IsEmpty() then
            return
        end
        inst.components.fueled:StartConsuming()

        inst.AnimState:PlayAnimation("fly",false)
        inst.AnimState:PushAnimation("fly_loop",true)
        inst:AddTag("flying")
        inst.__call_back_fn = function()
            if call_back_fn then
                call_back_fn(inst)
            end
            inst:RemoveEventCallback("animqueueover",inst.__call_back_fn)
        end
        inst:ListenForEvent("animqueueover",inst.__call_back_fn)
    end
    local function StopFly(inst,call_back_fn)
        inst.Physics:SetMotorVel(0,0,0)
        inst.Physics:Stop()
        inst.AnimState:PlayAnimation("fly_pst",false)
        inst:RemoveTag("flying")
        inst.__call_back_fn = function()
            if call_back_fn then
                call_back_fn(inst)
            end
            inst:RemoveEventCallback("animover",inst.__call_back_fn)
        end
        inst:ListenForEvent("animover",inst.__call_back_fn)
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
        return not inst.components.fueled:IsEmpty()
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 跟随玩家系统 
    local function Follow_Player_Sys_Install(inst)
        local fn = require("prefabs/06_buildings/04_02_white_drone_follow_player")
        if type(fn) == "function" then
            fn(inst)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 玩家保护模块 
    local function Player_Protecter_Sys_Install(inst)
        local fn = require("prefabs/06_buildings/04_03_player_protecter")
        if type(fn) == "function" then
            fn(inst)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 燃料
    local function trans_2_item(inst)

        local rot = inst.Transform:GetRotation()
        local pt = Vector3(inst.Transform:GetWorldPosition())
        local item = SpawnPrefab("hoshino_building_white_drone_item")
        item:Hide()
        item.Transform:SetRotation(rot)
        item.Transform:SetPosition(pt.x,5,pt.z)
        item.components.hoshino_data:Set("save_record",inst:GetSaveRecord())
        ------------------------------------------------------------
        --- 储存燃料数据
            local save_fueled = inst.components.fueled:OnSave() or {}
            item.components.fueled:OnLoad(save_fueled)
        ------------------------------------------------------------
        inst:PushEvent("trans_2_item",item)
        inst:Remove()
        item.Transform:SetPosition(pt.x,0,pt.z)
        item:Show()
    end
    local function OnFuelEmpty(inst)
        inst:StopFly(trans_2_item)
    end
    local function OnAddFuel(inst)
        if not inst:HasTag("flying") then
            inst:StartFly()
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- building
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

        inst:AddTag("projectile")
        inst:AddTag("hoshino_building_white_drone")
        -- inst:AddTag("flying")
        inst.AnimState:SetScale(ANIM_SCALE,ANIM_SCALE,ANIM_SCALE)

        inst.AnimState:SetBank("hoshino_building_white_drone")
        inst.AnimState:SetBuild("hoshino_building_white_drone")
        inst.AnimState:PlayAnimation("ground")

        inst.Transform:SetFourFaced()

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
        -----------------------------------------------------------------
        --- 检查
            inst:AddComponent("inspectable")
            inst:AddComponent("hoshino_data")
            -- MakeHauntableLaunch(inst)
        -----------------------------------------------------------------
        --- 弹药系统
            inst:AddComponent("weapon")
            inst.components.weapon:SetDamage(68)
            inst:AddComponent("projectile")
            inst.components.projectile:SetSpeed(20)
            inst.components.projectile:SetHoming(false)
            inst.components.projectile:SetHitDist(1.5)
            inst.components.projectile:SetOnHitFn(OnHit)
            inst.components.projectile:SetOnMissFn(inst.Remove)
        -----------------------------------------------------------------
        --- API
            inst.FaceTo = FaceTo
            inst.StartFly = StartFly
            inst.StopFly = StopFly
            inst.SetSpeed = SetSpeed
            inst.SetBusy = SetBusy
            inst.RemoveBusy = RemoveBusy
            inst.IsBusy = IsBusy
            inst.IsWorking = IsWorking
            inst.StopMoving = StopMoving
        -----------------------------------------------------------------
        --- 各种系统安装
            Follow_Player_Sys_Install(inst)
            Player_Protecter_Sys_Install(inst)
        -----------------------------------------------------------------
        --- 燃料
            inst:AddComponent("fueled")
            inst.components.fueled:SetDepletedFn(OnFuelEmpty)
            inst.components.fueled:SetTakeFuelFn(OnAddFuel)
            inst.components.fueled.accepting = true
            inst.components.fueled:InitializeFuelLevel(MAX_FUELED_TIME)
            inst:DoTaskInTime(0,function()
                if not inst:IsWorking() then
                    -- inst:StopFly()
                    -- inst.components.fueled:StopConsuming()
                    inst.AnimState:PlayAnimation("ground")
                    inst:RemoveTag("flying")
                else
                    -- inst.components.fueled:StartConsuming()
                end
            end)
            inst:ListenForEvent("takefuel",function()
                if not inst:HasTag("flying") then
                    inst:StartFly()
                    inst.components.fueled:StartConsuming()
                end
            end)
        -----------------------------------------------------------------



        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 物品
    --- deployable_hook
    local function deployable_hook(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.inventoryitem",function(inst,replica_com)
            local old_CanDeploy = replica_com.CanDeploy
            replica_com.CanDeploy = function(self,pt, mouseover, deployer, rot,...)
                if self.inst:HasTag("fueldepleted") then
                    return false
                end
                return true
            end
        end)
    end
    ---- 转换
    local function trans_2_drone(inst,pt,player)
        local saved_record = inst.components.hoshino_data:Get("save_record")
        local drone = nil
        if saved_record then
            drone = SpawnSaveRecord(saved_record)
        else
            drone = SpawnPrefab("hoshino_building_white_drone")
        end
        drone.Transform:SetPosition(pt.x,0,pt.z)
        -----------------------------------------------------------
        --- 覆盖燃料
            local data_fueled = inst.components.fueled:OnSave() or {fuel = inst.components.fueled.currentfuel}
            print("trans_2_drone data_fueled",data_fueled.fuel)
            drone.components.fueled:OnLoad(data_fueled)
        -----------------------------------------------------------
        drone:PushEvent("link",player)
        drone:StartFly()
        inst:Remove()
    end

    local function item_fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
    
        MakeInventoryPhysics(inst)
        inst.Transform:SetFourFaced()
    
        inst.AnimState:SetBank("hoshino_building_white_drone")
        inst.AnimState:SetBuild("hoshino_building_white_drone")
        inst.AnimState:PlayAnimation("ground")
        inst.AnimState:SetScale(ANIM_SCALE,ANIM_SCALE,ANIM_SCALE)

        inst:AddTag("deploykititem")
    
        inst.entity:SetPristine()
        deployable_hook(inst)
        if not TheWorld.ismastersim then
            return inst
        end
        --------------------------------------------------------------------------
        ---
            inst:AddComponent("hoshino_data")
        --------------------------------------------------------------------------
        ------ 物品名 和检查文本
            inst:AddComponent("inspectable")
            inst:AddComponent("inventoryitem")
            -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
            inst.components.inventoryitem.imagename = "hoshino_building_white_drone_item"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_building_white_drone_item.xml"
        -------------------------------------------------------------------
            MakeHauntableLaunch(inst)
        -------------------------------------------------------------------
        --- 落水影子
            local function shadow_init(inst)
                if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                    -- inst.AnimState:Hide("SHADOW")
                    inst.AnimState:HideSymbol("shadow")
                else                                
                    -- inst.AnimState:Show("SHADOW")
                    inst.AnimState:ShowSymbol("shadow")
                end
            end
            inst:ListenForEvent("on_landed",shadow_init)
            shadow_init(inst)
        -------------------------------------------------------------------
        --- 燃料
            inst:AddComponent("fueled")
            inst.components.fueled.accepting = true
            inst.components.fueled:InitializeFuelLevel(MAX_FUELED_TIME)
            inst.components.fueled:SetSectionCallback(function(newsection, oldsection,inst, doer)
                if inst.components.inventoryitem.owner then
                    return
                end
                if doer and doer:HasTag("player") then
                    -- print("onfueldsectionchanged",doer)
                    inst:DoTaskInTime(0,function()
                        trans_2_drone(inst,Vector3(inst.Transform:GetWorldPosition()),doer)                        
                    end)
                end
            end)
        -------------------------------------------------------------------
        ---
            inst:AddComponent("deployable")
            inst.components.deployable.ondeploy = trans_2_drone
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
        -------------------------------------------------------------------

        -------------------------------------------------------------------
        
        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function placer_postinit_fn(inst)
        inst.AnimState:SetScale(ANIM_SCALE,ANIM_SCALE,ANIM_SCALE)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_building_white_drone", fn, assets),
    Prefab("hoshino_building_white_drone_item", item_fn, assets),
    MakePlacer("hoshino_building_white_drone_item_placer", "hoshino_building_white_drone", "hoshino_building_white_drone", "ground", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil)

