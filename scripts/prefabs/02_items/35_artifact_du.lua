----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

Artifact 都
（就是这个发饰）
道具，不可拆解，具有唯一性。鼠标选中此物品之后可用此物品右键一个生物，并消耗20%耐久令其ai完全失效，耐久为零时变回奈因

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------

local assets = {
    Asset("ANIM", "anim/hoshino_item_artifact_du.zip"), 
    Asset( "IMAGE", "images/inventoryimages/hoshino_item_artifact_du.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/hoshino_item_artifact_du.xml" ),
}
----------------------------------------------------------------------------------------------------------------------------------------------------
-- hoshino_com_item_use_to 安装
    local function pause_timer_com(inst)
        if inst.components.timer then
            local names = {}
            for timer_name_index, v in pairs(inst.components.timer.timers) do
                names[timer_name_index] = true
            end
            for timer_name_index, v in pairs(names) do
                inst.components.timer:PauseTimer(timer_name_index)
            end
        end
    end
    local function resume_timer_com(inst)
        if inst.components.timer then
            local names = {}
            for timer_name_index, v in pairs(inst.components.timer.timers) do
                names[timer_name_index] = true
            end
            for timer_name_index, v in pairs(names) do
                inst.components.timer:ResumeTimer(timer_name_index)
            end
        end
    end
    local BOUNCE_NO_TAGS = { "INLIMBO", "wall", "notarget", "player", "companion", "flight", "invisible", "noattack", "hiding" }
    local function item_use_2_com_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_item_use_to",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,target,doer,right_click)
                if right_click and target and target ~= doer and target:HasTag("_combat") and not target:HasTag("hoshino_item_artifact_du_used") then                    
                    return true
                end
                return false
            end)
            replica_com:SetSGAction("hoshino_sg_empty_active")
            replica_com:SetDistance(30)
            replica_com:SetText("hoshino_item_artifact_du","施法")
        end)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("hoshino_com_item_use_to")
        inst.components.hoshino_com_item_use_to:SetActiveFn(function(inst,target,doer)
            if target:HasTag("_combat") and target.components.combat and target.components.health
                    and target.sg and target.brainfn
                    and not target:HasOneOfTags(BOUNCE_NO_TAGS) 
                    and not target:HasTag("hoshino_item_artifact_du_used") then

                target:StopBrain()
                target.sg:Stop()
                target:AddTag("hoshino_item_artifact_du_used")
                pause_timer_com(target)
                local temp_inst = target:SpawnChild("hoshino_item_artifact_du_fx")
                temp_inst:PushEvent("Set",{pt = Vector3(0,1,0)})
                temp_inst:ListenForEvent("minhealth",function()
                    temp_inst:Remove()
                    target.sg:Start()
                    target:RestartBrain()
                    resume_timer_com(target)
                end,target)
                inst.components.finiteuses:Use(20)
                return true
            end
            return false
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- finiteuses
    local function finiteuses_empty_fn(inst)
        local owner = inst.components.inventoryitem:GetGrandOwner()
        if owner and owner:HasTag("player") then
            inst:Remove()
            owner.components.inventory:GiveItem(SpawnPrefab("hoshino_item_accessory_remnants"))
        else
            local x,y,z = inst.Transform:GetWorldPosition()
            inst:Remove()
            SpawnPrefab("hoshino_item_accessory_remnants").Transform:SetPosition(x,1,z)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_item_artifact_du") -- 地上动画
    inst.AnimState:SetBuild("hoshino_item_artifact_du") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    -- inst.AnimState:SetScale(1.5,1.5,1.5)
    MakeInventoryFloatable(inst)

    inst:AddTag("hoshino_tag.cursor_sight")

    inst.entity:SetPristine()
    item_use_2_com_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
        inst.components.inventoryitem.imagename = "hoshino_item_artifact_du"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_artifact_du.xml"
        -- inst.components.inventoryitem:SetSinks(true)    -- 掉水里消失

    -------------------------------------------------------------------
    --- 耐久
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(100)
        inst.components.finiteuses:SetPercent(1)
        inst.components.finiteuses:SetOnFinished(finiteuses_empty_fn)
    -------------------------------------------------------------------
        MakeHauntableLaunch(inst)
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                -- inst.AnimState:Hide("SHADOW")
                -- inst:Remove()
            else                                
                -- inst.AnimState:Show("SHADOW")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    
    return inst
end

local function fx()
    local inst = CreateEntity()

    inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("pocketwatch_warp_marker")
    inst.AnimState:SetBuild("pocketwatch_warp_marker")
    inst.AnimState:PlayAnimation("idle_loop",true)
    inst.AnimState:SetMultColour(1.0, 1.0, 1.0, 0.6)



    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",function(inst,_table)
        _table = _table or {}
        if _table.pt then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)            
        end
        inst.Ready = true
    end)

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)

    return inst
end
return Prefab("hoshino_item_artifact_du", fn, assets),
    Prefab("hoshino_item_artifact_du_fx", fx, assets)