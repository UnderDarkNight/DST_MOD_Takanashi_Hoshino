----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 美术素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_building_white_drone.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数表
    local ANIM_SCALE = 3
    local START_HEIGHT = 3.2    --- 起始时候的 高度
    local END_HEIGHT = 0.7      --- 末端击中时候的高度
    local HEIGHT_DWON_PER_FRAME = 0.05    --- 每帧下降的高度
    local HIDE_FRAMES = 3       --- 初始化时候隐藏的帧数
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnHit(inst, attacker, target)
        if inst.___onhit_fn then
            inst.___onhit_fn()
        end
        inst:Remove()
        if target then
            target:PushEvent("hoshino_projectile_missile.onhit",attacker)
        end
    end

    local function OnAnimOver(inst)
        -- inst:DoTaskInTime(.3, inst.Remove)
    end

    local function OnThrown(inst)
        -- inst:ListenForEvent("animover", OnAnimOver)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 客户端动画
    local function CreateAnim(parent)
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        parent:AddChild(inst)
        inst.AnimState:SetBank("hoshino_building_white_drone")
        inst.AnimState:SetBuild("hoshino_building_white_drone")
        -- inst:Hide()
        inst.AnimState:PlayAnimation("missile",true)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetDeltaTimeMultiplier(3)
        inst.AnimState:SetScale(ANIM_SCALE,ANIM_SCALE,ANIM_SCALE)
        inst.frames = 0

        inst.current_height = START_HEIGHT
        inst.Transform:SetPosition(0,START_HEIGHT,0)

        parent:DoPeriodicTask(FRAMES,function()
            --- 越靠近高度越低，START_HEIGHT 到 END_HEIGHT           
            inst.current_height = math.clamp(inst.current_height - HEIGHT_DWON_PER_FRAME,END_HEIGHT,START_HEIGHT)
            inst.Transform:SetPosition(0,inst.current_height,0)
            -- inst.frames = inst.frames + 1
            -- if not inst._show_flag and inst.frames > HIDE_FRAMES  then
            --     inst:Show()
            --     inst._show_flag = true
            -- end
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 配置导弹参数
    local function Set_Param_Event(inst,_table)
        -- _table = _table or {
        --     pt = Vector3(0,0,0),
        --     target = nil,
        --     onhit = function() end,
        --     speed = 20,
        --     doer = nil,
        -- }
        local pt = _table.pt
        local target = _table.target
        local onhit = _table.onhit
        local speed = _table.speed
        local doer = _table.doer

        if pt then
            inst.Transform:SetPosition(pt.x,0,pt.z)
        end
        if onhit then
            inst.___onhit_fn = onhit
        end
        if speed then
            inst.components.projectile:SetSpeed(speed or 20)
        end
        if target then
            inst.__target_from_param = target
            if inst.__running_task == nil then
                inst.__running_task = inst:DoPeriodicTask(FRAMES*2,function()
                    -- if target and target:IsValid() then
                    --     inst.components.projectile:Throw(inst,target,doer)
                    -- else
                    --     inst:Remove()
                    -- end
                    if inst.__target_from_param then
                        if inst.__target_from_param:IsValid() then
                            inst.components.projectile:Throw(inst,inst.__target_from_param,doer)
                        else
                            --- 目标被删除的时候，创建标记并继续飞行
                            local x,y,z = inst.__target_from_param.Transform:GetWorldPosition()
                            local mark = SpawnPrefab("hoshino_projectile_missile_mark")
                            mark:PushEvent("Set",{pt = Vector3(x,y,z)})
                            inst.__target_from_param = mark
                            inst.components.projectile:Throw(inst,inst.__target_from_param,doer)
                        end
                    else
                        inst:Remove()
                    end
                end)
            end
        end
        -- inst._net_target:set(target)
        inst.Ready = true
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    -- inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    if not TheNet:IsDedicated() then
        -- inst:DoTaskInTime(0,CreateAnim)
        CreateAnim(inst)
    end
    -- inst.Transform:SetFourFaced()

    -- inst._net_target = net_entity(inst.GUID,"hoshino_projectile_missile_target","hoshino_projectile_missile_target")

    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("weapon")

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(1.5)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(inst.Remove)
    -- inst.components.projectile:SetOnThrownFn(OnThrown)
    inst:DoTaskInTime(0,function()
        if not inst.Ready and not TUNING.HOSHINO_DEBUGGING_MODE then
            inst:Remove()
        end
    end)

    inst:ListenForEvent("Set",Set_Param_Event)
    inst:ListenForEvent("entitysleep",inst.Remove)
    return inst
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 标记位
    local function ParamSetFn(inst,_table)
        local pt = _table.pt
        inst.Transform:SetPosition(pt.x,0,pt.z)
        inst.Ready = true
    end
    local function OnLoadCheckFn(inst)
        if not inst.Ready then
            inst:Remove()
        end
    end
    local function mark_fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        -- inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst:AddTag("hoshino_projectile_missile_mark")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:ListenForEvent("Set",ParamSetFn)
        inst:DoTaskInTime(0,OnLoadCheckFn)
        inst:ListenForEvent("hoshino_projectile_missile.onhit",inst.Remove)
        inst:ListenForEvent("entitysleep",inst.Remove)
        return inst
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_projectile_missile", fn, assets),
    Prefab("hoshino_projectile_missile_mark", mark_fn, assets)