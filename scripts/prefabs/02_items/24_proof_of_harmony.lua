----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

和谐之证
饰品，无耐久
雇佣猪人/兔人/鱼人的时候1%获得

猪人，兔人，鱼人不会主动攻击你，

你雇佣一个猪人/鱼人/兔人的时候会永久雇佣其和其周围8码内同类单位，

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_equipment_proof_of_harmony.zip"),
        Asset( "IMAGE", "images/inventoryimages/hoshino_equipment_proof_of_harmony.tex" ),
        Asset( "ATLAS", "images/inventoryimages/hoshino_equipment_proof_of_harmony.xml" ),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
--- make frend event
    local function Get_New_Added_Follower(old_list,new_list)
        --- 找出两个列表里多出的 那个
        for temp_folloer ,flag in pairs(new_list) do
            if old_list[temp_folloer] == nil then
                return temp_folloer
            end
        end
        return nil
    end
    local function make_frend_event(player)
        if player.hoshino_equipment_proof_of_harmony_flag then
            return
        end

        --- 先记录当前跟随者
        local remember_1_followers = {}
        for temp_folloer ,flag in pairs(player.components.leader.followers) do
            if flag and temp_folloer and temp_folloer:IsValid() then
                remember_1_followers[temp_folloer] = true
            end
        end
        --- 1秒后再次记录跟随者
        player:DoTaskInTime(0.1,function()
            local remember_2_followers = {}
            for temp_folloer ,flag in pairs(player.components.leader.followers) do
                if flag and temp_folloer and temp_folloer:IsValid() then
                    remember_2_followers[temp_folloer] = true
                end
            end

            ---- 对比 remember_1_followers 和 remember_2_followers，找出2里多出的那个
            local new_added_follower = Get_New_Added_Follower(remember_1_followers,remember_2_followers)
            if not (new_added_follower and new_added_follower:IsValid() and new_added_follower.prefab) then
                return
            end
            ---- 寻找同类prefab
            local new_added_follower_prefab = new_added_follower.prefab
            local x,y,z = player.Transform:GetWorldPosition()
            local radius = TUNING.HOSHINO_DEBUGGING_MODE and 20 or 14
            local ents = TheSim:FindEntities(x,0, z, radius or 4)
            local need_to_add_follower_list = {}
            for k, v in pairs(ents) do
                if v and v.prefab == new_added_follower_prefab then
                    table.insert(need_to_add_follower_list,v)
                end
            end
            ---- 添加跟随玩家
            player.hoshino_equipment_proof_of_harmony_flag = true
                for k, v in pairs(need_to_add_follower_list) do
                            pcall(function()
                                    player:PushEvent("makefriend")
                                    player.components.leader:AddFollower(v)
                            end)

                end
                --- 解除最初那个，重新设置永久跟随。
                new_added_follower.components.follower:CancelLoyaltyTask()
                -- player.components.leader:RemoveFollower(new_added_follower,new_added_follower:IsValid())
                -- player:PushEvent("makefriend")
                -- player.components.leader:AddFollower(new_added_follower)

            player.hoshino_equipment_proof_of_harmony_flag = nil
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local monster_block_list = {
        ["pigman"] = true,
        ["merm"] = true,
        ["bunnyman"] = true,
    }
    local function on_set_target_event_for_player(player,monster)
        -- print("on_set_target_event_for_player",monster)
        if monster and monster_block_list[monster.prefab] then
            monster.components.combat:DropTarget()
        end
    end

    local function onequip(inst, owner)
        inst:ListenForEvent("hoshino_event.combat_set_target",on_set_target_event_for_player,owner)
        inst:ListenForEvent("makefriend",make_frend_event,owner)
    end

    local function onunequip(inst, owner)
        inst:RemoveEventCallback("hoshino_event.combat_set_target",on_set_target_event_for_player,owner)
        inst:RemoveEventCallback("makefriend",make_frend_event,owner)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
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
    -- inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)


    inst.AnimState:SetBank("moonrock_seed")
    inst.AnimState:SetBuild("hoshino_equipment_proof_of_harmony")
    inst.AnimState:PlayAnimation("idle",true)


    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_equipment_proof_of_harmony"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_equipment_proof_of_harmony.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =  TUNING.HOSHINO_FNS:CopyEquipmentSlotFrom("amulet") or EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL*6
    -- inst.components.equippable.is_magic_dapperness = true

    MakeHauntableLaunch(inst)
    core_anim_controller_install(inst)

    return inst
end
----------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_equipment_proof_of_harmony", fn, assets)
