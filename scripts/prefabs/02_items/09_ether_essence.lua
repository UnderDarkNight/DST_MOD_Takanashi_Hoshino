----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    以太精髓

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------

local assets = {
    Asset("ANIM", "anim/hoshino_item_ether_essence.zip"), 
    Asset( "IMAGE", "images/inventoryimages/hoshino_item_ether_essence.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/hoshino_item_ether_essence.xml" ),
}
----------------------------------------------------------------------------------------------------------------------------------------------------
-- workable install

    local function workable_install(inst)
        -- inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_workable",function(inst,replica_com)
        --     replica_com:SetTestFn(function(inst,doer,right_click)
        --         if doer.prefab == "hoshino" and inst.replica.inventoryitem:IsGrandOwner(doer) then
        --             return true
        --         end
        --     end)
        --     replica_com:SetText("hoshino_item_ether_essence","储蓄")
        --     replica_com:SetSGAction("give")
        -- end)
        -- if not TheWorld.ismastersim then
        --     return
        -- end
        -- inst:AddComponent("hoshino_com_workable")
        -- inst.components.hoshino_com_workable:SetOnWorkFn(function(inst,doer)
        --     local num = inst.components.stackable:StackSize() or 0
        --     inst:Remove()
        --     doer.components.hoshino_com_shop:BlueSchistDelta(num)
        --     return true
        -- end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- deployable_hook
    local function deployable_hook(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.inventoryitem",function(inst,replica_com)
            local old_CanDeploy = replica_com.CanDeploy
            replica_com.CanDeploy = function(self,pt, mouseover, deployer, rot,...)
                if type(pt) == "table" and pt.x and pt.y and pt.z then
                    local ents = TheSim:FindEntities(pt.x,0,pt.z,4.5,{"hoshino_building_ether_pool"})
                    if #ents > 0 then
                        return false
                    end
                end
                return old_CanDeploy(self,pt, mouseover, deployer, rot,...)
            end
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_item_ether_essence") -- 地上动画
    inst.AnimState:SetBuild("hoshino_item_ether_essence") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画

    inst:AddTag("deploykititem")

    inst.entity:SetPristine()
    workable_install(inst)
    deployable_hook(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
        inst.components.inventoryitem.imagename = "hoshino_item_ether_essence"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_ether_essence.xml"
        inst.components.inventoryitem:SetSinks(true)    -- 掉水里消失
    -------------------------------------------------------------------
        inst:AddComponent("stackable") -- 可堆叠
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
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
    ---
        inst:AddComponent("deployable")                
        inst.components.deployable.ondeploy = function(inst, pt, deployer)
            inst.components.stackable:Get():Remove()
            SpawnPrefab("hoshino_building_ether_pool").Transform:SetPosition(pt.x,0,pt.z)
        end
        -- inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
    -------------------------------------------------------------------
    
    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function placer_postinit_fn(inst)
        inst.AnimState:SetBuild("hoshino_building_ether_pool")
        inst.AnimState:SetBank("marsh_tile")
        inst.AnimState:PlayAnimation("idle",true)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("hoshino_item_ether_essence", fn, assets),
    MakePlacer("hoshino_item_ether_essence_placer", "hoshino_building_ether_pool", "hoshino_building_ether_pool", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil)
