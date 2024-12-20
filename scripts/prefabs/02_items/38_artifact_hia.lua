----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

Artifact 希亚
（这是个戒指）
饰品
不可拆解，具有唯一性。装备于饰品栏位。当一个生物杀死过玩家之后，可对其右键，直接秒杀它（代码杀），消耗1/3耐久，耐久归零时变回奈因。

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------

local assets = {
    Asset("ANIM", "anim/hoshino_item_artifact_hia.zip"), 
    Asset( "IMAGE", "images/inventoryimages/hoshino_item_artifact_hia.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/hoshino_item_artifact_hia.xml" ),
}
----------------------------------------------------------------------------------------------------------------------------------------------------
-- hoshino_com_item_use_to 安装

    local function item_use_2_com_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_item_use_to",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,target,doer,right_click)
                if right_click and target ~= doer
                    and target:HasTag("_combat")
                    and (target:HasTag("hoshino_tag.artifact_hia_debuff") or TUNING.HOSHINO_DEBUGGING_MODE)
                    then
                    return true
                end
                return false
            end)
            replica_com:SetSGAction("hoshino_sg_empty_active")
            replica_com:SetDistance(30)
            replica_com:SetText("hoshino_item_artifact_hia","施法")
        end)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("hoshino_com_item_use_to")
        inst.components.hoshino_com_item_use_to:SetActiveFn(function(inst,target,doer)
            if target and target.components.combat and target.components.health then
                target.components.health.currenthealth = 0.1
                target.components.combat:GetAttacked(doer,1000000)
                inst.components.finiteuses:Use(1)
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

    inst.AnimState:SetBank("hoshino_item_artifact_hia") -- 地上动画
    inst.AnimState:SetBuild("hoshino_item_artifact_hia") -- 材质包，就是anim里的zip包
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
        inst.components.inventoryitem.imagename = "hoshino_item_artifact_hia"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_artifact_hia.xml"
        -- inst.components.inventoryitem:SetSinks(true)    -- 掉水里消失

    -------------------------------------------------------------------
    --- 耐久
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(3)
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
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 标记debuff
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

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(function(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。重复添加不会执行。
            inst.entity:SetParent(target.entity)
            -- inst.Network:SetClassifiedTarget(target)
            inst.Transform:SetPosition(0, 0, 0)
            inst.target = target
            -----------------------------------------------------
            --- 
                print("info artifact_hia_debuff mark to ",target)
            -----------------------------------------------------
            --- 
                target:AddTag("hoshino_tag.artifact_hia_debuff")
            -----------------------------------------------------
        end)
        -- inst.components.debuff:SetExtendedFn(function(inst) -- 重复添加debuff 的时候执行。
        --     local target = inst.target
        --     -----------------------------------------------------
        --     --- 
        --         -- inst.time = (inst.time or 0 ) + 20
        --     -----------------------------------------------------
        -- end)
        inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆

        return inst
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_item_artifact_hia", fn, assets),
    Prefab("hoshino_item_artifact_hia_debuff", debuff_fn, assets)