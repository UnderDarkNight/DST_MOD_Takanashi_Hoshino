----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

Artifact 天
（这个是个手环）
不可拆解，具有唯一性。装备于武器栏位，

装备该武器时隐身，

右键此饰品可以消耗20%耐久选定半径为6的圆形区域内的所有的 敌对 怪物 和可被工作的建筑【被锤，被斧子砍，被镐子敲】的实体被删除，

耐久为零时变回奈因。

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材
    local assets = {
        Asset("ANIM", "anim/hoshino_item_artifact_sky.zip"), 
        Asset( "IMAGE", "images/inventoryimages/hoshino_item_artifact_sky.tex" ),  -- 背包贴图
        Asset( "ATLAS", "images/inventoryimages/hoshino_item_artifact_sky.xml" ),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 参数
    local SPELL_ACTIVE_RADIUS = 6  --- 施法范围

    --- 怪物扫描的tag ，复制自 亮茄魔杖
    local BOUNCE_MUST_TAGS = { "_combat" }
    local BOUNCE_NO_TAGS = { "INLIMBO", "wall", "notarget", "player", "companion", "flight", "invisible", "noattack", "hiding" }
----------------------------------------------------------------------------------------------------------------------------------------------------
-- point target spell caster
    local function create_dotted_circle(inst)  -- 创建指示圈，仅限 client
        if inst.dotted_circle and inst.dotted_circle:IsValid() or ThePlayer == nil or TheInput == nil then
            return
        end
        local dotted_circle = SpawnPrefab("hoshino_sfx_dotted_circle_client")
        inst.dotted_circle = dotted_circle
        dotted_circle:PushEvent("Set",{ range = SPELL_ACTIVE_RADIUS })
        TheInput:Hoshino_Add_Update_Modify_Fn(dotted_circle,function()
            local pt = TheInput:GetWorldPosition()
            dotted_circle.Transform:SetPosition(pt.x,0,pt.z)
        end)
        dotted_circle:DoPeriodicTask(FRAMES*10,function()
            local weapon = ThePlayer.replica.combat:GetWeapon()
            if weapon ~= inst then
                dotted_circle:Remove()
                return
            end
            -- local pt = TheInput:GetWorldPosition()
            -- dotted_circle.Transform:SetPosition(pt.x,0,pt.z)
        end)

    end
    local function replica_fn(inst,replica_com)
        replica_com:SetAllowCanCastOnImpassable(true)
        replica_com:SetDistance(30)
        replica_com:SetAllowCastWhenRiding(true)
        replica_com:SetTestFn(function(inst,doer,target,pt,right_click)
            create_dotted_circle(inst)
            if right_click then
                return true
            end
        end)
        replica_com:SetText("hoshino_item_artifact_sky","施法")
        replica_com:SetSGAction("hoshino_sg_empty_active")
    end
    local function GetPT(target,pt)
        if pt then
            return pt
        end
        if target then
            return Vector3(target.Transform:GetWorldPosition())
        end
        return Vector3(0,0,0)
    end
    local function spell_active_fn(inst,doer,_target,_pt)
        local pt = GetPT(_target,_pt)
        --------------------------------------------------------------------------------------------
        --- 
            if inst.spell_working then
                return false
            end
        --------------------------------------------------------------------------------------------
        --- 

        --------------------------------------------------------------------------------------------
        --- 怪物扫描
            local ents = TheSim:FindEntities(pt.x,0,pt.z, SPELL_ACTIVE_RADIUS, BOUNCE_MUST_TAGS, BOUNCE_NO_TAGS)
            for k, temp_target in pairs(ents) do
                if temp_target and temp_target:IsValid() and temp_target.components.health then
                    if temp_target.components.lootdropper then
                        temp_target.components.lootdropper:Hoshino_Block()
                    end
                    temp_target.components.health.currenthealth = 0.1
                    temp_target.components.combat:GetAttacked(doer,1000000,inst)
                    inst.spell_working = true
                end
            end
        --------------------------------------------------------------------------------------------
        ---
            local ents = TheSim:FindEntities(pt.x,0,pt.z, SPELL_ACTIVE_RADIUS,nil,nil,{"HAMMER_workable","MINE_workable","CHOP_workable"})
            for k, temp_target in pairs(ents) do
                if temp_target and temp_target:IsValid() and temp_target.components.workable and temp_target.components.workable:CanBeWorked() then
                    if temp_target.components.lootdropper then
                        temp_target.components.lootdropper:Hoshino_Block()
                    end
                    temp_target.components.workable:Destroy(doer)
                    inst.spell_working = true
                end
            end
        --------------------------------------------------------------------------------------------
        --- 延时挖
            local tempInst = CreateEntity()
            tempInst:DoTaskInTime(0.5,function()
                local ents = TheSim:FindEntities(pt.x,0,pt.z, SPELL_ACTIVE_RADIUS,nil,nil,{"DIG_workable","HAMMER_workable","MINE_workable","CHOP_workable"})
                for k, temp_target in pairs(ents) do
                    if temp_target and temp_target:IsValid() and temp_target.components.workable and temp_target.components.workable:CanBeWorked() then
                        if temp_target.components.lootdropper then
                            temp_target.components.lootdropper:Hoshino_Block()
                        end
                        temp_target.components.workable:Destroy(doer)
                        inst.spell_working = true
                    end
                end
                if inst.spell_working then
                    inst.components.finiteuses:Use(20)
                    inst.spell_working = false
                end
                tempInst:Remove()
            end)
        --------------------------------------------------------------------------------------------
        ---消耗耐久
            -- if actived_flag then
            --     inst.components.finiteuses:Use(20)
            -- end
        --------------------------------------------------------------------------------------------
        return true
    end
    local function com_point_and_target_spell_caster_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_point_and_target_spell_caster",replica_fn)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_point_and_target_spell_caster")
        inst.components.hoshino_com_point_and_target_spell_caster:SetSpellFn(spell_active_fn)
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
-- 穿戴
    local function onequip(inst, owner)
        owner:AddTag("debugnoattack")
    end

    local function onunequip(inst, owner)
        owner:RemoveTag("debugnoattack")
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_item_artifact_sky")
    inst.AnimState:SetBuild("hoshino_item_artifact_sky")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("weapon")
    inst:AddTag("punch")

    MakeInventoryFloatable(inst)


    inst.entity:SetPristine()
    com_point_and_target_spell_caster_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    -------------------------------------------------------------------
    --- 武器
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(0)
        inst.components.weapon.GetDamage = function(self,attacker,target)
            attacker = attacker or self.inst.components.inventoryitem:GetGrandOwner()
            if target and attacker and attacker:HasTag("player") and attacker.components.combat then
                return attacker.components.combat:CalcDamage(target,nil)
            end
            return 0,nil
        end
    -------------------------------------------------------------------
    --- 物品和检查
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
        inst.components.inventoryitem.imagename = "hoshino_item_artifact_sky"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_artifact_sky.xml"
    -------------------------------------------------------------------
    -- 装备
        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
    -------------------------------------------------------------------
    --- 耐久
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(100)
        inst.components.finiteuses:SetPercent(1)
        inst.components.finiteuses:SetOnFinished(finiteuses_empty_fn)
    -------------------------------------------------------------------
        MakeHauntableLaunch(inst)
    -------------------------------------------------------------------

    return inst
end

return Prefab("hoshino_item_artifact_sky", fn, assets)
