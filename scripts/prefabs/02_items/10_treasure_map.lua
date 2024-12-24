----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    镒

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------

local assets = {
    Asset("ANIM", "anim/hoshino_item_treasure_map.zip"), 
    Asset( "IMAGE", "images/inventoryimages/hoshino_item_treasure_map.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/hoshino_item_treasure_map.xml" ),
}
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 随机坐标（复制自 传送法杖）
    local function GetRandomPosition(caster, teleportee, target_in_ocean)
        if teleportee == nil then
            teleportee = caster
        end

        if target_in_ocean then
            local pt = TheWorld.Map:FindRandomPointInOcean(20)
            if pt ~= nil then
                return pt
            end
            local from_pt = teleportee:GetPosition()
            local offset = FindSwimmableOffset(from_pt, math.random() * 2 * PI, 90, 16)
                            or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 60, 16)
                            or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 30, 16)
                            or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 15, 16)
            if offset ~= nil then
                return from_pt + offset
            end
            return teleportee:GetPosition()
        else
            local centers = {}
            for i, node in ipairs(TheWorld.topology.nodes) do
                if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then
                    table.insert(centers, {x = node.x, z = node.y})
                end
            end
            if #centers > 0 then
                local pos = centers[math.random(#centers)]
                return Vector3(pos.x, 0, pos.z)
            else
                return caster:GetPosition()
            end
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
-- workable install
    local function workable_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                if doer and inst.replica.inventoryitem:IsGrandOwner(doer) then
                    return true
                end
            end)
            replica_com:SetText("hoshino_item_treasure_map","查看藏宝图")
            replica_com:SetSGAction("dolongaction")
        end)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_workable")
        inst.components.hoshino_com_workable:SetOnWorkFn(function(inst,doer)
            if inst.components.mapspotrevealer == nil then
                inst:AddComponent("mapspotrevealer")
            end
            local pt = GetRandomPosition(doer)
            if type(pt) == type(Vector3(0,0,0))  then
                inst.components.mapspotrevealer:SetGetTargetFn(function(inst,doer)
                    return pt
                end)

                SpawnPrefab("hoshino_item_treasure_map_marker").Transform:SetPosition(pt.x, 0, pt.z)

                if TUNING.HOSHINO_DEBUGGING_MODE and doer then
                    doer:DoTaskInTime(10,function()
                        doer.Transform:SetPosition(pt.x, 0, pt.z)
                    end)
                end

                inst.components.mapspotrevealer:RevealMap(doer)
                inst:Remove()
                return true
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

    inst.AnimState:SetBank("hoshino_item_treasure_map") -- 地上动画
    inst.AnimState:SetBuild("hoshino_item_treasure_map") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    MakeInventoryFloatable(inst)


    inst.entity:SetPristine()
    workable_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
        inst.components.inventoryitem.imagename = "hoshino_item_treasure_map"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_treasure_map.xml"
        -- inst.components.inventoryitem:SetSinks(true)    -- 掉水里消失
    -------------------------------------------------------------------
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
        -- inst:AddComponent("mapspotrevealer")
        -- -- inst.components.mapspotrevealer:SetGetTargetFn(getrevealtargetpos)
        -- inst.components.mapspotrevealer:SetGetTargetFn(CreateMapTarget)
    -------------------------------------------------------------------
    
    return inst
end
--------------------------------------------------------------------------------------------------------------------------------------
--- 红叉标记
    local function GetRandomNumFromTable(_table,num)
        -- 从 _table 里 返回不重复的 num 个
        local temp_table = deepcopy(_table)
        local result = {}
        for i=1,num do
            local index = math.random(1,#temp_table)
            table.insert(result,temp_table[index])
            table.remove(temp_table,index)
        end
        return result
    end
    local function SpawnTreasureBox(x,y,z)
        --[[
            打开箱子时周围会随机生成一些怪物，
            箱子内含金块【10-20块】， goldnugget
            窥密权柄【70%概率出现】，
            最高神秘【5%概率出现】，
            各色宝石【1-2种，每种3块】， "redgem","orangegem","yellowgem","greengem","bluegem","purplegem","opalpreciousgem"
            各类原版装备【铥矿三件套，影刀影甲等（1-3件）】 ruins_bat ruinshat armorruins armor_sanity nightsword glasscutter
        ]]--
        ----------------------------------------------------------
        --- 生成怪物(1-5只)
            local monster_list = {
                "pigguard","merm","knight","knight_nightmare","bishop_nightmare",
                "bishop","spider","spider_warrior","spider_spitter","spider_dropper",
                "hound","firehound","icehound","mutatedhound","frog","mosquito"
            }
            local monster_num = math.random(1,5)
            for i=1,monster_num do
                local monster = SpawnPrefab(monster_list[math.random(1,#monster_list)])
                monster.Transform:SetPosition(x,y,z)
                monster:DoPeriodicTask(3,function()
                    if monster.components.combat then
                        monster.components.combat:SuggestTarget(monster:GetNearestPlayer(true))
                    end
                end)
            end
        ----------------------------------------------------------
        --- 宝箱，9格子
            local box_prefabs = {"terrariumchest","treasurechest","dragonflychest"}
            local box = SpawnPrefab(box_prefabs[math.random(1,#box_prefabs)])
            box.Transform:SetPosition(x,y,z)
        ----------------------------------------------------------
        --- 金子
            local goldnugget = SpawnPrefab("goldnugget")
            goldnugget.components.stackable.stacksize = math.random(10,20)
            box.components.container:GiveItem(goldnugget)
        ----------------------------------------------------------
        --- 窥秘权柄
            if math.random(10000)/10000 <= 0.7 then
                local item = SpawnPrefab("hoshino_item_cards_pack")
                item:PushEvent("Type","hoshino_item_cards_pack_authority_to_unveil_secrets")
                box.components.container:GiveItem(item)
            end
        ----------------------------------------------------------
        --- 最高神秘
            if math.random(10000)/10000 <= 0.05 then
                local item = SpawnPrefab("hoshino_item_cards_pack")
                item:PushEvent("Type","hoshino_item_cards_pack_supreme_mystery")
                box.components.container:GiveItem(item)
            end
        ----------------------------------------------------------
        --- 宝石
            local gem_list = {"redgem","orangegem","yellowgem","greengem","bluegem","purplegem","opalpreciousgem"}
            local gem_num = math.random(1,2)
            local gem = GetRandomNumFromTable(gem_list,gem_num)
            for i=1,#gem do
                local item = SpawnPrefab(gem[i])
                item.components.stackable.stacksize = 3
                box.components.container:GiveItem(item)
            end
        ----------------------------------------------------------
        --- 装备
            local equip_list = {"ruins_bat","ruinshat","armorruins","armor_sanity","nightsword","glasscutter"}
            local equip_num = math.random(1,3)
            local equip = GetRandomNumFromTable(equip_list,equip_num)
            for i=1,#equip do
                local item = SpawnPrefab(equip[i])
                box.components.container:GiveItem(item)
            end
        ----------------------------------------------------------
    end
    -- local function marker_workable_install(inst)
    --     inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_workable",function(inst,replica_com)
    --         replica_com:SetTestFn(function(inst,doer,right_click)
    --             if not right_click then
    --                 return false
    --             end
    --             local weapon = doer and doer.replica.combat and doer.replica.combat:GetWeapon()
    --             if weapon and weapon:HasTag("DIG_tool") and weapon:HasTag("tool") then
    --                 return true
    --             end
    --             return false
    --         end)
    --         replica_com:SetText("hoshino_item_treasure_map_marker","挖掘")
    --         replica_com:SetSGAction("dig")
    --     end)
    --     if not TheWorld.ismastersim then
    --         return
    --     end
    --     inst:AddComponent("hoshino_com_workable")
    --     inst.components.hoshino_com_workable:SetOnWorkFn(function(inst,doer)
    --         -- print("挖掘宝藏")
    --         local x,y,z = inst.Transform:GetWorldPosition()
    --         local fx = SpawnPrefab("collapse_big")
    --         fx.Transform:SetPosition(x,y,z)
    --         fx:SetMaterial("wood")
    --         SpawnTreasureBox(x,y,z)
    --         inst:Remove()
    --         return true
    --     end)
    -- end
    local function marker_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
        inst.entity:AddAnimState()


        inst.MiniMapEntity:SetIcon("messagebottletreasure_marker.png")
        inst.MiniMapEntity:SetPriority(6)

        inst.AnimState:SetBank("track")
        inst.AnimState:SetBuild("koalefant_tracks")
        inst.AnimState:SetRayTestOnBB(true)
        inst.AnimState:PlayAnimation("idle_pile")

        inst.AnimState:SetScale(2,2,2)

        -- inst:AddTag("NOCLICK")
        -- inst:AddTag("NOBLOCK")
        inst:AddTag("hoshino_item_treasure_map_marker")

        inst.entity:SetPristine()
        -- marker_workable_install(inst)
        if not TheWorld.ismastersim then
            return inst
        end

        -- inst:AddComponent("playerprox")
        -- inst.components.playerprox:SetDist(5, 7)
        -- inst.components.playerprox:SetOnPlayerNear(marker_on_near_fn)
        -- inst.components.playerprox:SetOnPlayerFar(onfar)
        inst:AddComponent("inspectable")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnFinishCallback(function()
            local x,y,z = inst.Transform:GetWorldPosition()
            local fx = SpawnPrefab("collapse_big")
            fx.Transform:SetPosition(x,y,z)
            fx:SetMaterial("wood")
            SpawnTreasureBox(x,y,z)
            inst:Remove()
        end)
        inst.components.workable:SetWorkLeft(1)

        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_item_treasure_map", fn, assets),
    Prefab("hoshino_item_treasure_map_marker", marker_fn, assets)