----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    以太池子

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 美术素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_building_ether_pool.zip"),
        Asset("ANIM", "anim/hoshino_building_ether_pool_item.zip"),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---  acceptable_install
    local CD_TIME = 60
    local CD_TAG = "cd_ing"
    local PrefabBlackList = {
        ["turf_dragonfly"]=true,
        ["turf_checkerfloor"]=true,
        ["turf_cotl_gold"]=true,
        ["turf_carpetfloor"]=true,
        ["turf_mosaic_red"] = true,
    }
    local function Test_Item(inst,item,doer,right_click)
        if inst:HasTag(CD_TAG) then
            return false
        end
        if PrefabBlackList[item.prefab] then
            return false
        end
        return true
    end
    local function replica_com_fn(inst,replica_com)
        replica_com:SetTestFn(Test_Item)
        replica_com:SetText("hoshino_building_ether_pool","投入")
    end
    local empty_fn = function()    end
    local function ReturnSanity(doer)
        if doer and doer.components.sanity then
            doer.components.sanity:DoDelta(TUNING.SANITY_MEDLARGE,true)
        end
    end
    local function OnAcceptFn(inst,item,doer)
        if inst:HasTag(CD_TAG) then
            return false
        end
        local greenstaff = SpawnPrefab("greenstaff")
        greenstaff.components.inventoryitem.owner = doer
        greenstaff.components.finiteuses.Use = empty_fn
        local destroystructure_fn = greenstaff.components.spellcaster.spell
        
        if item.components.stackable == nil then
            destroystructure_fn(greenstaff,item)
            ReturnSanity(doer)
        else
            local stack_size = item.components.stackable:StackSize()
            for i = 1, stack_size, 1 do
                destroystructure_fn(greenstaff,item.components.stackable:Get())
                ReturnSanity(doer)
            end
        end
        inst:AddTag(CD_TAG)
        inst:DoTaskInTime(CD_TIME,function()
            inst:RemoveTag(CD_TAG)
        end)
        greenstaff:Remove()
        return true
    end
    local function acceptable_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_acceptable",replica_com_fn)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_acceptable")
        inst.components.hoshino_com_acceptable:SetOnAcceptFn(OnAcceptFn)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 钓鱼
    local ocean_fish = {
        "oceanfish_medium_1_inv","oceanfish_medium_2_inv",
        "oceanfish_medium_3_inv","oceanfish_medium_4_inv",
        "oceanfish_medium_5_inv","oceanfish_medium_6_inv",
        "oceanfish_medium_7_inv","oceanfish_medium_8_inv",
        "oceanfish_small_1_inv","oceanfish_small_2_inv",
        "oceanfish_small_3_inv","oceanfish_small_4_inv",
        "oceanfish_small_5_inv","oceanfish_small_6_inv",
        "oceanfish_small_7_inv","oceanfish_small_8_inv",
        "oceanfish_small_9_inv","wobster_sheller_land"
    }
    local items_with_probabilities = {
        --[[
            “随地入场券”： 3%  hoshino_item_pillow
            反熵水晶殖轮：3%  hoshino_item_anti_entropy_crystal_wheel
            镒：5%  hoshino_item_yi
            窥密权柄3%  hoshino_item_cards_pack_authority_to_unveil_secrets
            神明文字碎片：2%  hoshino_item_fragments_of_divine_script
            剩余概率随机海鱼                
        ]]--
        {"hoshino_item_pillow", 0.03},
        {"hoshino_item_anti_entropy_crystal_wheel", 0.03},
        {"hoshino_item_yi", 0.05},
        {"hoshino_item_cards_pack_authority_to_unveil_secrets", 0.03},
        {"hoshino_item_fragments_of_divine_script", 0.02}
    }
    
    local function GetFishFn(inst)
        local rare_mult = TUNING.HOSHINO_DEBUGGING_MODE and 2 or 1
        local rand = math.random(10000) / 10000 * rare_mult
    
        local cumulative_probability = 0
        for _, item_data in ipairs(items_with_probabilities) do
            cumulative_probability = cumulative_probability + item_data[2]
            if rand < cumulative_probability then
                return item_data[1]
            end
        end    
        return ocean_fish[math.random(#ocean_fish)]
    end
    
    
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    ----------------------------------------------------------------------
    --- 地图图标
        inst.entity:AddMiniMapEntity()
        inst.MiniMapEntity:SetIcon("hoshino_building_ether_pool.tex")
    ----------------------------------------------------------------------
    --- 物理引擎
        MakePondPhysics(inst, 1.95)
        RemovePhysicsColliders(inst)
    ----------------------------------------------------------------------
    --- 动画
        inst.AnimState:SetBuild("hoshino_building_ether_pool")
        inst.AnimState:SetBank("marsh_tile")
        inst.AnimState:PlayAnimation("idle",true)
        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
    ----------------------------------------------------------------------
    --- 放置屏蔽
        inst:SetDeploySmartRadius(2)
    ----------------------------------------------------------------------
    ---
        inst:AddTag("hoshino_building_ether_pool")
    ----------------------------------------------------------------------
    --- 泡泡特效
        if not TheNet:IsDedicated() then
            inst:DoPeriodicTask(2,function()
                inst:SpawnChild("crab_king_bubble"..math.random(3))
            end,3)
        end
    ----------------------------------------------------------------------
        inst.entity:SetPristine()
    ----------------------------------------------------------------------
    --- 
        acceptable_install(inst)
    ----------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end



    inst:AddComponent("inspectable")
    ----------------------------------------------------------------------
    --- 钓鱼
        inst:AddComponent("fishable")
        inst.components.fishable:SetRespawnTime(1)
        -- inst.components.fishable:AddFish("pondfish")
        inst.components.fishable:AddFish("wetpouch")
        inst.components.fishable:SetGetFishFn(GetFishFn)
        local old_HookFish = inst.components.fishable.HookFish
        inst.components.fishable.HookFish = function(self, player,...)
            local old_ret = old_HookFish(self, player,...)
            if old_ret then
                -- 必须有贴图，不然会崩溃。
                old_ret.build = old_ret.build or "hoshino_building_ether_pool_item" or "wetpouch"
                -- print("hooked fish",old_ret, old_ret.build)
            end
            return old_ret
        end
    ----------------------------------------------------------------------
    ---
        -- inst:AddComponent("finiteuses")
        -- inst.components.finiteuses.Use = function() end
    ----------------------------------------------------------------------
    ---
        inst:AddComponent("lootdropper")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function(inst,worker)
            --- 只有玩家可以挖
            if worker and worker:HasTag("player") then
                inst:Remove()
            else
                inst.components.workable:SetWorkLeft(1)
            end
        end)
        -- inst.components.workable:SetOnWorkCallback(onhit)
    ----------------------------------------------------------------------

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("hoshino_building_ether_pool", fn, assets)