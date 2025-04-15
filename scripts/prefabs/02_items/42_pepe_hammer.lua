--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    通过  tag  HAMMER_tool 来判定 工具 当前是什么状态。


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数表
    local DEFAULT_BASE_DAMAGE = 34  --- 缺省基础伤害
    local DAMAGE_FOR_EACH_ITEM = 3.4 --- 每个物品的伤害加成

    local DAMAGE_PERCENT_FOR_LEVEL = 0.5 -- 升级等级与伤害的倍率

    local MAX_ON_HIT_LEVEL = 6      --- 打击等级-最大等级
    local BASE_HIT_RANGE = 2        --- 武器基础攻击距离
    local BASE_AOE_RADIUS = 3       --- 基础 AOE 半径
    local AOE_RADIUS_DELTA_PER_LEVEL = 1    --- AOE 半径的倍率

    local SPELL_ACITVE_RADIUS = 15      --- 技能范围
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材引用
    local assets =
    {
        Asset("ANIM", "anim/hoshino_weapon_pepe_hammer.zip"),
        Asset("ANIM", "anim/fx_hoshino_hammer_hit_ground.zip"),
        Asset("ANIM", "anim/fx_hoshino_hammer_hit.zip"),
        Asset( "IMAGE", "images/inventoryimages/hoshino_weapon_pepe_hammer.tex" ),
        Asset( "ATLAS", "images/inventoryimages/hoshino_weapon_pepe_hammer.xml" ),
        Asset( "SOUND", "sound/hoshino_pepe_hammer.fsb" ),
        Asset( "SOUNDPACKAGE", "sound/hoshino_pepe_hammer.fev" ),
    }
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 穿戴
    local function onequip(inst, owner) --装备
        owner.AnimState:OverrideSymbol("swap_object", "hoshino_weapon_pepe_hammer", "swap_object")
                                    --替换的动画部件	使用的动画	替换的文件夹（注意这里也是文件夹的名字）
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end

    local function onunequip(inst, owner) --解除装备
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 动态伤害模块
    local function GetHitLevel(inst,delta)
        inst.hit_level = (inst.hit_level or 0 )
        delta = delta or 0
        inst.hit_level = math.clamp(inst.hit_level + delta,0,MAX_ON_HIT_LEVEL)
        return inst.hit_level
    end
    local BOUNCE_MUST_TAGS = { "_combat" }
    local BOUNCE_NO_TAGS = { "INLIMBO", "wall", "notarget", "player", "companion", "flight", "invisible", "noattack", "hiding" }
    local function do_aoe(inst,attacker,target,x,z)
        local aoe_radius = BASE_AOE_RADIUS + GetHitLevel(inst)*AOE_RADIUS_DELTA_PER_LEVEL
        local ents = TheSim:FindEntities(x,0, z,aoe_radius, BOUNCE_MUST_TAGS, BOUNCE_NO_TAGS)
        for i, temp_target in ipairs(ents) do
            if temp_target.components.combat
                and temp_target.components.health and not temp_target.components.health:IsDead() then
                    local tx,ty,tz = temp_target.Transform:GetWorldPosition()
                    local damage,spdamage = inst.components.weapon:GetDamage(attacker,target)
                    -- temp_target.components.combat:GetAttacked(attacker,damage,inst,nil,spdamage)
                     temp_target.components.health:SetVal(temp_target.components.health.currenthealth - (damage / 2))
                     temp_target.components.health:DoDelta(0)
                    temp_target.components.combat:SuggestTarget(attacker)
                    temp_target:PushEvent("attacked", { attacker = attacker, damage = damage / 2 }) --减半的伤害推送给事件
                end
        end
    end
    local function onattack_fn(inst,attacker, target)
        --------------------------------------------------------
        --- 初始化参数
            GetHitLevel(inst)
            local x,y,z = (target or inst).Transform:GetWorldPosition()
        --------------------------------------------------------
        --- 特效
        local fx = SpawnPrefab("fx_hoshino_hammer_hit_ground")
        if fx then
            fx.Transform:SetPosition(x,y,z)
            local scale = 1.5 + (.1 * (inst.hit_level or 0))
            fx.Transform:SetScale(scale, scale, scale)
        end
    
        local fx1 = SpawnPrefab("fx_hoshino_hammer_hit")
        if fx1 then
            fx1.Transform:SetPosition(x,y,z)
            local scale = 1.5 + (.15 * (inst.hit_level or 0))
            fx1.Transform:SetScale(scale, scale, scale)
        end
        --------------------------------------------------------
        --- AOE 函数
            do_aoe(inst,attacker,target,x,z)
        --------------------------------------------------------
        --- 攻击动作切换
            if GetHitLevel(inst) >= 3 then
                inst.components.hoshino_com_polymorphic_attack_action:SetType(3)    --- 配置动作
            end
        --------------------------------------------------------
        --- 等级击杀等级提升
            GetHitLevel(inst,1)
            if inst.__reset_level_task then
                inst.__reset_level_task:Cancel()
            end
            inst.__reset_level_task = inst:DoTaskInTime(10, function()
                GetHitLevel(inst,-10)
                inst.components.hoshino_com_polymorphic_attack_action:SetType(1)    --- 重置动作
            end)
        --------------------------------------------------------
    end
    ---- 替换掉伤害生成函数
    local function Replace_GetDamage(self,attacker,target)
        local inst = self.inst
        if inst.components.hoshino_data:Get("damage") == nil then
            inst.components.hoshino_data:Set("damage", DEFAULT_BASE_DAMAGE)
        end
        inst.hit_level = inst.hit_level or 0
        local damage = inst.components.hoshino_data:Add("damage",0)
        local damage_per_level = damage * DAMAGE_PERCENT_FOR_LEVEL
        local ret_damage = damage + damage_per_level * inst.hit_level
        return ret_damage,nil
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- type unlocker 功能解锁
    local function type_unlocker_install(inst)
        ---- 类型统一解锁
        inst:ListenForEvent("init_tool_types",function(inst)
            -----------------------------------------------------------------------------
            --- 速度
                if inst.components.hoshino_data:Get("cane") then
                    inst.components.equippable.walkspeedmult =  1.25
                    inst:AddTag("accpeted_cane")
                end
            -----------------------------------------------------------------------------
            --砍
                if inst.components.hoshino_data:Get("goldenaxe") then
                    inst.components.tool:SetAction(ACTIONS.CHOP, 5)
                    inst:AddTag("accpeted_goldenaxe")
                end
            -----------------------------------------------------------------------------
            --挖
                if inst.components.hoshino_data:Get("goldenpickaxe") then
                    inst.components.tool:SetAction(ACTIONS.MINE, 5)
                    inst:AddTag("accpeted_goldenpickaxe")
                end
            -----------------------------------------------------------------------------
            --铲子
                if inst.components.hoshino_data:Get("goldenshovel") then
                    inst.components.tool:SetAction(ACTIONS.DIG, 5)
                    inst:AddTag("accpeted_goldenshovel")
                end
            -----------------------------------------------------------------------------
            --捕虫
                if inst.components.hoshino_data:Get("bugnet") then
                    inst.components.tool:SetAction(ACTIONS.NET, 1)
                    inst:AddTag("accpeted_bugnet")
                end
            -----------------------------------------------------------------------------
            --- 锤子功能是默认的，所以这里不设置
                inst.components.tool:SetAction(ACTIONS.HAMMER, 1)       --锤子
            -----------------------------------------------------------------------------
            --- 钓鱼
                if inst.components.hoshino_data:Get("fishingrod") then --- 钓鱼功能
                    if inst.components.fishingrod == nil then
                        inst:AddComponent("fishingrod")                         --钓鱼功能组件
                    end
                    inst.components.fishingrod:SetWaitTimes(4, 16)          
                    inst.components.fishingrod:SetStrainTimes(60, 60)       --钓鱼功能到这里结束
                    inst:AddTag("accpeted_fishingrod")
                end
            -----------------------------------------------------------------------------
            --- 多用斧头镐子
                if inst.components.hoshino_data:Get("multitool_axe_pickaxe") then
                    inst.components.tool:SetAction(ACTIONS.CHOP, 5)     --砍
                    inst.components.tool:SetAction(ACTIONS.MINE, 5)     --挖
                    inst.components.tool:EnableToughWork(true)--更结实的工具，能敲硬的东西
                    inst:AddTag("accpeted_multitool_axe_pickaxe")
                end
            -----------------------------------------------------------------------------
            --- 初始化 tag
                inst:RemoveTag("HAMMER_tool")
                inst:RemoveTag("DIG_tool")
            -----------------------------------------------------------------------------
            --- 
                if inst.components.hoshino_data:Get("pick_helper") then
                    inst:AddTag("pick_helper")
                end
            -----------------------------------------------------------------------------
        end)
        ---- 外部调用用来解锁特定功能
            inst:ListenForEvent("type_unlock",function(inst,_type)
                inst.components.hoshino_data:Set(_type,true)
                inst:PushEvent("init_tool_types")
            end)
        ---- 加载的时候初始化类型
            inst.components.hoshino_data:AddOnLoadFn(function()
                inst:PushEvent("init_tool_types")            
            end)
    end    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 通用物品接受
    --- 函数表
    local _on_accept_fns = {
        -------------------------------------------------------------------
        --- 手杖
            ["cane"] = {
                test = function(inst,item,doer,right_click)
                    return not inst:HasTag("accpeted_cane")
                end,
                on_accept = function(inst,item,doer)
                    item:Remove()
                    inst:PushEvent("type_unlock","cane")
                    return true
                end,
            },
        -------------------------------------------------------------------
        --- 斧头
            ["goldenaxe"] = {
                test = function(inst,item,doer,right_click)
                    return not inst:HasTag("accpeted_goldenaxe")
                end,
                on_accept = function(inst,item,doer)
                    item:Remove()
                    inst:PushEvent("type_unlock","goldenaxe")
                    return true
                end,
            },
        -------------------------------------------------------------------
        --- 镐子
            ["goldenpickaxe"] = {
                test = function(inst,item,doer,right_click)
                    return not inst:HasTag("accpeted_goldenpickaxe")
                end,
                on_accept = function(inst,item,doer)
                    item:Remove()
                    inst:PushEvent("type_unlock","goldenpickaxe")
                    return true
                end,
            },
        -------------------------------------------------------------------
        --- 铲子
            ["goldenshovel"] = {
                test = function(inst,item,doer,right_click)
                    return not inst:HasTag("accpeted_goldenshovel")
                end,
                on_accept = function(inst,item,doer)
                    item:Remove()
                    inst:PushEvent("type_unlock","goldenshovel")
                    return true
                end,
            },
        -------------------------------------------------------------------
        --- 捕虫网
            ["bugnet"] = {
                test = function(inst,item,doer,right_click)
                    return not inst:HasTag("accpeted_bugnet")
                end,
                on_accept = function(inst,item,doer)
                    item:Remove()
                    inst:PushEvent("type_unlock","bugnet")
                    return true
                end,
            },
        -------------------------------------------------------------------
        --- 钓鱼竿
            ["fishingrod"] = {
                test = function(inst,item,doer,right_click)
                    return not inst:HasTag("accpeted_fishingrod")
                end,
                on_accept = function(inst,item,doer)
                    item:Remove()
                    inst:PushEvent("type_unlock","fishingrod")
                    return true
                end,
            },
        -------------------------------------------------------------------
        --- 多用斧头镐子
            ["multitool_axe_pickaxe"] = {
                test = function(inst,item,doer,right_click)
                    return not inst:HasTag("accpeted_multitool_axe_pickaxe")
                end,
                on_accept = function(inst,item,doer)
                    item:Remove()
                    inst:PushEvent("type_unlock","multitool_axe_pickaxe")
                    return true
                end,
            },
        -------------------------------------------------------------------
        --- yi
            ["hoshino_item_yi"] = {
                test = function(inst,item,doer,right_click)
                    return true
                end,
                on_accept = function(inst,item,doer)
                    item.components.stackable:Get():Remove()
                    inst.components.hoshino_data:Add("damage",DAMAGE_FOR_EACH_ITEM)
                    return true
                end,
            },            
        -------------------------------------------------------------------
        --- hoshino_item_blue_schist
            ["hoshino_item_blue_schist"] = {
                test = function(inst,item,doer,right_click)
                    return not inst:HasTag("pick_helper")
                end,
                on_accept = function(inst,item,doer)
                    item.components.stackable:Get():Remove()
                    inst.components.hoshino_data:Set("pick_helper",true)
                    inst:PushEvent("init_tool_types")
                    return true
                end,
            },            
        -------------------------------------------------------------------
    }    
    local function acceptable_test_fn(inst,item,doer,right_click)
        if item and item.prefab and _on_accept_fns[item.prefab] then
            return _on_accept_fns[item.prefab].test(inst,item,doer,right_click)
        end
        return false
    end
    local function acceptable_on_accept_fn(inst,item,doer)
        return _on_accept_fns[item.prefab].on_accept(inst,item,doer)
    end
    local function acceptable_replica_init(inst,replica_com)
        replica_com:SetTestFn(acceptable_test_fn)   --- 配置可接受
        replica_com:SetSGAction("dolongaction")     --- 配置sg动作
        replica_com:SetText("hoshino_weapon_pepe_hammer","升级")
    end
    local function custom_acceptable_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_acceptable",acceptable_replica_init)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_acceptable")
        inst.components.hoshino_com_acceptable:SetOnAcceptFn(acceptable_on_accept_fn)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 通用右键功能
    local function workable_test_fn(inst,doer,right_click)
        return inst.replica.equippable:IsEquipped() --- 穿戴的时候才能右键切换
    end
    local function workable_replica_init(inst,replica_com)
        replica_com:SetTestFn(workable_test_fn)                         --- 添加 可 右键 test
        replica_com:SetSGAction("doshortaction")                        --- 右键时候的sg动作
        replica_com:SetText("hoshino_weapon_pepe_hammer","切换")        -- 右键文本
    end
    local function custom_workable_on_work(inst,doer)
        if inst:HasTag("HAMMER_tool") then
            inst:RemoveTag("HAMMER_tool")
            inst:RemoveTag("DIG_tool")
            doer.components.talker:Say("关闭锤子模式")
        else
            doer.components.talker:Say("开启锤子模式")
            inst:AddTag("HAMMER_tool")
            if inst.components.hoshino_data:Get("goldenshovel") then
                inst:AddTag("DIG_tool")                
            end
        end
        return true
    end
    local function custom_workable_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_workable",workable_replica_init)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_workable")
        inst.components.hoshino_com_workable:SetOnWorkFn(custom_workable_on_work)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 通用施法组件（点、目标）
    local function custom_spell_caster_test_fn(inst,doer,target,pt,right_click)
        if not right_click then --- 施法用右键
            return false
        end
        if not inst:HasTag("pick_helper") then
            return false
        end
        if inst:HasTag("HAMMER_tool") then  --- 锤子功能激活的时候，不允许施法
            return false
        elseif target and not inst:HasTag("HAMMER_tool") then   --- 必须对目标施法
            return true
        end
        return false
    end
    local function pepe_castfn(inst, target)    
        local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
        if not owner then
            return
        end    
        if target.components.pickable and target:HasTag("pickable") then
            target.components.pickable:Pick(owner)
            local x, y, z = target.Transform:GetWorldPosition()
            if not (x and y and z and type(x) == "number" and type(y) == "number" and type(z) == "number") then return end
            local ents = TheSim:FindEntities(x, y, z, SPELL_ACITVE_RADIUS, {"pickable"})
            --print("x:"..x)
            --print("y:"..y)
            --print("z:"..z)
            --print("Found pickable entities:", #ents)
            for k, v in pairs(ents) do
                if v.components.pickable and v:HasTag("pickable") and v.components.pickable.Pick and v.prefab == target.prefab and v ~= target then
                    v.components.pickable:Pick(owner)
                end
            end
    
        elseif target.components.harvestable and target:HasTag("harvestable") then
            target.components.harvestable:Harvest(owner)
            local x, y, z = target.Transform:GetWorldPosition()
            if not (x and y and z and type(x) == "number" and type(y) == "number" and type(z) == "number") then return end
            local ents = TheSim:FindEntities(x, y, z, SPELL_ACITVE_RADIUS, {"harvestable"})
            --print("x:"..x)
            --print("y:"..y)
            --print("z:"..z)
            --print("Found harvestable entities:", #ents)
            for k, v in pairs(ents) do
                if v.components.harvestable and v:HasTag("harvestable") and v.prefab == target.prefab and v ~= target  then
                    v.components.harvestable:Harvest(owner)
                end
            end
    
        elseif target.components.inventoryitem and target.components.inventoryitem.owner == nil then
            owner.components.inventory:GiveItem(target, nil, owner:GetPosition())
            local x, y, z = target.Transform:GetWorldPosition()
            if not (x and y and z and type(x) == "number" and type(y) == "number" and type(z) == "number") then return end
            local ents = TheSim:FindEntities(x, y, z, SPELL_ACITVE_RADIUS, {"_inventoryitem"})
            --print("x:"..x)
            --print("y:"..y)
            --print("z:"..z)
            --print("Found inventory items:", #ents)
            for k, v in pairs(ents) do
                if v.components.inventoryitem and v.components.inventoryitem.owner == nil and v.prefab == target.prefab and v ~= target  then
                    owner.components.inventory:GiveItem(v, nil, owner:GetPosition())
                end
            end
        else
            --print("Target has no valid components:", target.prefab)
        end
    end
    local function custom_spell_caster_on_cast(inst,doer,target,pt)
        if target then
            pcall(pepe_castfn,inst,target)  --- 做防止崩溃处理
        end
        return true
    end
    local function custom_spell_caster_replica_init(inst,replica_com)
        replica_com:SetDistance(SPELL_ACITVE_RADIUS)
        replica_com:SetTestFn(custom_spell_caster_test_fn)
        replica_com:SetText("hoshino_weapon_pepe_hammer","施法")
        replica_com:SetSGAction("cointosscastspell")
    end
    local function custom_spell_caster_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_point_and_target_spell_caster",custom_spell_caster_replica_init)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_point_and_target_spell_caster")
        inst.components.hoshino_com_point_and_target_spell_caster:SetSpellFn(custom_spell_caster_on_cast)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 武器本体
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("hoshino_weapon_pepe_hammer")
        inst.AnimState:SetBuild("hoshino_weapon_pepe_hammer")
        inst.AnimState:PlayAnimation("idle")

        inst.entity:SetPristine()
        ----------------------------------------------------------------------------------------------------------
        --- 模块安装
            if TheWorld.ismastersim then
                inst:AddComponent("hoshino_data")                
            end
            custom_workable_install(inst)
            custom_acceptable_install(inst)
            custom_spell_caster_install(inst)
        ----------------------------------------------------------------------------------------------------------
            if not TheWorld.ismastersim then
                return inst
            end
        ----------------------------------------------------------------------------------------------------------
        --- 武器
            inst:AddComponent("weapon") --增加武器组件 有了这个才可以打人
            inst.components.weapon:SetDamage(DEFAULT_BASE_DAMAGE) --设置伤害34
            inst.components.weapon:SetRange(BASE_HIT_RANGE, BASE_HIT_RANGE)
            inst.components.weapon:SetOnAttack(onattack_fn)
            inst.components.weapon.GetDamage = Replace_GetDamage
        ----------------------------------------------------------------------------------------------------------
        --- 工具
            inst:AddComponent("tool")
            type_unlocker_install(inst)
        ----------------------------------------------------------------------------------------------------------
        --- 防水
            inst:AddComponent("waterproofer")
            inst.components.waterproofer:SetEffectiveness(0)
        ----------------------------------------------------------------------------------------------------------
        --- 招式、数据库
            inst:AddComponent("hoshino_com_polymorphic_attack_action")
        ----------------------------------------------------------------------------------------------------------
        --- 
            inst:AddComponent("inspectable") --可检查组件
            inst:AddComponent("inventoryitem") --物品组件
            inst.components.inventoryitem.imagename = "hoshino_weapon_pepe_hammer"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_weapon_pepe_hammer.xml" --物品贴图
        ----------------------------------------------------------------------------------------------------------
        --- 穿戴
            inst:AddComponent("equippable") --可装备组件
            inst.components.equippable:SetOnEquip(onequip)
            inst.components.equippable:SetOnUnequip(onunequip)
            inst.components.equippable.walkspeedmult = 1
        ----------------------------------------------------------------------------------------------------------
        --- 钓鱼功能
            inst:AddComponent("fishingrod")                         --钓鱼功能
            inst.components.fishingrod:SetWaitTimes(4, 16)           
            inst.components.fishingrod:SetStrainTimes(60, 60)       --钓鱼功能到这里结束
        ----------------------------------------------------------------------------------------------------------
        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_weapon_pepe_hammer", fn, assets)