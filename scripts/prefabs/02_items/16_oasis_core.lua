----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

绿洲核心：
饰品 amulet 无耐久
合成材料： 多肉植物*18 起皱的包裹*10 
你几乎可以瞬间钓到淡水鱼，你可以一次钓上很多鱼（1次钓鱼=3次）

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_equipment_oasis_core.zip"),
        Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_oasis_core.tex" ),
        Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_oasis_core.xml" ),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
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

local function onequip(inst, owner)
    inst:DoTaskInTime(1,function()
        inst:ListenForEvent("fishingcollect",player_fishingcollect_event,owner)
    end)
end

local function onunequip(inst, owner)
    inst:RemoveEventCallback("fishingcollect",player_fishingcollect_event,owner)
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
    local function core_anim_controller_install(inst)
        inst:AddComponent("playerprox")
        inst.components.playerprox:SetDist(2, 3)
        inst.components.playerprox:SetOnPlayerNear(Player_Near)
        inst.components.playerprox:SetOnPlayerFar(Player_Far)
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
    end
----------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("moonrock_seed")
    inst.AnimState:SetBuild("hoshino_equipment_oasis_core")
    inst.AnimState:PlayAnimation("idle",true)


    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_equipment_oasis_core"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_oasis_core.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)


    core_anim_controller_install(inst)

    MakeHauntableLaunch(inst)
    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_oasis_core", fn, assets)
