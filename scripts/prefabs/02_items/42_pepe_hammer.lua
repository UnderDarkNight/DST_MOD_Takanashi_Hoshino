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
local function canuse()
	return true
end

local function onequip(inst, owner) --装备
    owner.AnimState:OverrideSymbol("swap_object", "hoshino_weapon_pepe_hammer", "swap_object")
								--替换的动画部件	使用的动画	替换的文件夹（注意这里也是文件夹的名字）
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    --if owner.Transform then
    --    SpawnPrefab("sanity_raise").Transform:SetPosition(owner.Transform:GetWorldPosition())
    --end
end

local function onunequip(inst, owner) --解除装备
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    --if owner.Transform then
    --    SpawnPrefab("sanity_lower").Transform:SetPosition(owner.Transform:GetWorldPosition())
    --end
    inst.isunfolded = false
end

local function can_cast_fn(doer, target, pos)
    return target.components.inventoryitem or target.components.pickable or target.components.harvestable
end

local function pepe_castfn(inst, target)
    if inst:HasTag("HAMMER_tool") then
        return
    end

    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    if not owner then
        return
    end

    if target.components.pickable and target:HasTag("pickable") then
        target.components.pickable:Pick(owner)
        local x, y, z = target.Transform:GetWorldPosition()
        if not (x and y and z and type(x) == "number" and type(y) == "number" and type(z) == "number") then return end
        local ents = TheSim:FindEntities(x, y, z, 15, {"pickable"})
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
        local ents = TheSim:FindEntities(x, y, z, 15, {"harvestable"})
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
        local ents = TheSim:FindEntities(x, y, z, 15, {"_inventoryitem"})
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

local function ShouldAcceptItem(inst, item)
    if item and (
    (item.prefab == "cane" and inst.pepe_SpeedMult == false) or
    (item.prefab == "hoshino_item_blue_schist" and inst.pepe_HasSchist == false) or
    (item.prefab == "multitool_axe_pickaxe" and inst.pepe_HasMax == false) or
    (item.prefab == "goldenaxe" and inst.pepe_HasAxe == false)or
    (item.prefab == "goldenpickaxe" and inst.pepe_HasPickaxe == false)or
    (item.prefab == "goldenshovel" and inst.pepe_HasShovel == false)or
    --(item.prefab == "fishingrod" and inst.pepe_HasRod == false) or
    --(item.prefab == "bugnet" and inst.pepe_HasNet == false) or
    (item.prefab == "hoshino_item_yi")
    ) then
	   return true
	end
    return false
end

local function remove_item(item)
    if item.components.stackable then
        item.components.stackable:Get():Remove()
    else
        item:Remove()
    end
end

local function OnGetItemFromPlayer(inst, giver, item)

    if item and item.prefab == "cane" then
        inst.pepe_SpeedMult = true
        inst.components.equippable.walkspeedmult =  1.25
        remove_item(item)
    elseif item and item.prefab == "hoshino_item_blue_schist" then
        inst.pepe_HasSchist = true
        inst:AddComponent("spellcaster")
        inst.components.spellcaster.canuseonpoint = false
        inst.components.spellcaster.canuseonpoint_water = false
        inst.components.spellcaster.canuseontargets = true
        inst.components.spellcaster.quickcast = true
        inst.components.spellcaster:SetCanCastFn(can_cast_fn)
        inst.components.spellcaster:SetSpellFn(pepe_castfn)
        remove_item(item)
    elseif item and item.prefab == "multitool_axe_pickaxe" then
        inst.pepe_HasMax = true
        inst:AddTag("CHOP_tool")
        inst:AddTag("MINE_tool")
        inst.components.tool:EnableToughWork(true)--更结实的工具，能敲硬的东西
        remove_item(item)
    elseif item and item.prefab == "goldenaxe" then
        inst.pepe_HasAxe = true
        inst:AddTag("CHOP_tool")
        remove_item(item)
    elseif item and item.prefab == "goldenpickaxe" then
        inst.pepe_HasPickaxe = true
        inst:AddTag("MINE_tool")
        remove_item(item)
    elseif item and item.prefab == "goldenshovel" then
        inst.pepe_HasShovel = true
        remove_item(item)
    --elseif item and item.prefab == "fishingrod" then
    --    inst.pepe_HasRod = true
    --    inst:AddComponent("fishingrod")                         --钓鱼功能
    --    inst.components.fishingrod:SetWaitTimes(4, 16)           
    --    inst.components.fishingrod:SetStrainTimes(60, 60)       --钓鱼功能到这里结束
    --    remove_item(item)
    --elseif item and item.prefab == "bugnet" then
    --    inst.pepe_HasNet = true
    --    inst:AddTag("NET_tool")
    --    remove_item(item)
    elseif item and item.prefab == "hoshino_item_yi" then
        inst.pepe_level = (inst.pepe_level or 0) + 1
        inst.components.weapon:SetDamage((34 + ((inst.pepe_level or 0) * 3.4)) * (1 + (0.5*(inst.pepe_attack_times or 0))))
        remove_item(item)
    end

end

local function pepe(inst)
	local owner = inst.components.inventoryitem.owner
	if inst.isunfolded then
		inst:AddTag("HAMMER_tool")
        if inst.pepe_HasShovel then
		    inst:AddTag("DIG_tool")
        end

        owner.components.talker:Say("开启锤铲功能！", 3, false)
        if inst.pepe_HasSchist then
            inst:RemoveComponent("spellcaster")
        end

		 inst.isunfolded = false
	else
		inst:RemoveTag("HAMMER_tool")
		inst:RemoveTag("DIG_tool")
        --inst:RemoveTag("propweapon") 


		owner.components.talker:Say("关闭锤铲功能！", 3, false)
        if inst.pepe_HasSchist then
            inst:AddComponent("spellcaster")
            inst.components.spellcaster.canuseonpoint = false
            inst.components.spellcaster.canuseonpoint_water = false
            inst.components.spellcaster.canuseontargets = true
            inst.components.spellcaster.quickcast = true
            inst.components.spellcaster:SetCanCastFn(can_cast_fn)
            inst.components.spellcaster:SetSpellFn(pepe_castfn)
        end


		inst.isunfolded = true
	end
    return false
end

local function onload(inst, data)
    inst.pepe_HasSchist = data.pepe_HasSchist or false
    inst.pepe_SpeedMult = data.pepe_SpeedMult or false
    inst.pepe_HasMax = data.pepe_HasMax or false
    inst.pepe_HasAxe = data.pepe_HasAxe or false
    inst.pepe_HasPickaxe = data.pepe_HasPickaxe or false
    inst.pepe_HasShovel = data.pepe_HasShovel or false
    inst.pepe_HasRod = data.pepe_HasRod or false
    inst.pepe_HasNet = data.pepe_HasNet or false
    inst.pepe_level = data.pepe_level or 0
    

    if inst.pepe_HasSchist and inst.pepe_HasSchist == true then
        inst:AddComponent("spellcaster")
        inst.components.spellcaster.canuseonpoint = false
        inst.components.spellcaster.canuseonpoint_water = false
        inst.components.spellcaster.canuseontargets = true
        inst.components.spellcaster.quickcast = true
        inst.components.spellcaster:SetCanCastFn(can_cast_fn)
        inst.components.spellcaster:SetSpellFn(pepe_castfn)
    end

    if inst.pepe_SpeedMult and inst.pepe_SpeedMult == true then
        inst.components.equippable.walkspeedmult =  1.25
    end

    if inst.pepe_HasMax and inst.pepe_HasMax == true then
        inst:AddTag("CHOP_tool")
        inst:AddTag("MINE_tool")
        inst.components.tool:EnableToughWork(true)--更结实的工具，能敲硬的东西
    end

    if inst.pepe_HasAxe and inst.pepe_HasAxe == true then
        inst:AddTag("CHOP_tool")
    end

    if inst.pepe_HasPickaxe and inst.pepe_HasPickaxe == true then
        inst:AddTag("MINE_tool")
    end

    if inst.pepe_HasShovel and inst.pepe_HasShovel == true then
        --
    end

    --if inst.pepe_HasRod and inst.pepe_HasRod == true then
    --    inst:AddComponent("fishingrod")
    --    inst.components.fishingrod:SetWaitTimes(4, 16)           
    --    inst.components.fishingrod:SetStrainTimes(60, 60)
    --end

    --if inst.pepe_HasNet and inst.pepe_HasNet == true then
    --    inst:AddTag("NET_tool")
    --end

    if inst.pepe_level then
        inst.components.weapon:SetDamage((34 + ((inst.pepe_level or 0) * 3.4)) * (1 + (0.5*(inst.pepe_attack_times or 0))))
    end
end

local function onsave(inst, data)
    data.pepe_HasSchist = inst.pepe_HasSchist or false
    data.pepe_SpeedMult = inst.pepe_SpeedMult or false
    data.pepe_HasMax = inst.pepe_HasMax or false
    data.pepe_HasAxe = inst.pepe_HasAxe or false
    data.pepe_HasPickaxe = inst.pepe_HasPickaxe or false
    data.pepe_HasShovel = inst.pepe_HasShovel or false
    data.pepe_HasRod = inst.pepe_HasRod or false
    data.pepe_HasNet = inst.pepe_HasNet or false
    data.pepe_level = inst.pepe_level or 0
end

local function onattack(inst, attacker, target)
    target.components.health:DoDelta(0)
    local x, y, z = target.Transform:GetWorldPosition()
    local fx = SpawnPrefab("fx_hoshino_hammer_hit_ground")
    if fx then
        fx.Transform:SetPosition(x,y,z)
        local scale = 1.5 + (.1 * (inst.pepe_attack_times or 0))
        fx.Transform:SetScale(scale, scale, scale)
    end

    local fx1 = SpawnPrefab("fx_hoshino_hammer_hit")
    if fx1 then
        fx1.Transform:SetPosition(x,y,z)
        local scale = 1.5 + (.15 * (inst.pepe_attack_times or 0))
        fx1.Transform:SetScale(scale, scale, scale)
    end
    if (inst.pepe_attack_times or 0) >= 3 then
        attacker.SoundEmitter:PlaySound("hoshino_pepe_hammer/hoshino_pepe_hammer/heavy_hit", nil, 1.5)
    else
        attacker.SoundEmitter:PlaySound("hoshino_pepe_hammer/hoshino_pepe_hammer/hit", nil, 2.1)
    end

    local ents = TheSim:FindEntities(x, y, z, 3 + (inst.pepe_attack_times or 0), {"_combat", "_health"}, {"INLIMBO", "FX", "wall", "smashable", "companion"}, nil)
    for k,v in pairs(ents) do
        if v ~= nil and v ~= attacker and v.components.combat and (TheNet:GetPVPEnabled() or not v:HasTag("player")) then
            local damage = ((17 + ((inst.pepe_level or 0) * 1.7)) * (1 + (0.5*(inst.pepe_attack_times or 0)))) * (attacker.components.combat.damagemultiplier or 1)

            --v.components.health.currenthealth = v.components.health.currenthealth - damage
            v.components.health:SetVal(v.components.health.currenthealth - damage)
            v.components.health:DoDelta(0)
            v:PushEvent("attacked", { attacker = attacker, damage = 0, weapon = inst })
            attacker:PushEvent('onareaattackother', {target = v, weapon = inst, stimuli = nil})
            attacker:PushEvent("onhitother", { target = v, damage = damage, stimuli = nil, weapon = inst})
            if attacker.components.combat ~= nil and attacker.components.combat.onhitotherfn ~= nil then
                attacker.components.combat.onhitotherfn(attacker, v, damage, nil, inst)
            end
            v:PushEvent("attacked", { attacker = attacker, damage = damage, weapon = inst, stimuli = nil })
            if v.components.health:IsDead() then
                --推送死亡事件,击杀者为装备者
                --v:PushEvent("death")
                attacker:PushEvent("killed",{victim = v})
                if v.components.combat ~= nil and v.components.combat.onkilledbyother ~= nil then
                    v.components.combat.onkilledbyother(v,attacker)
                end
            end

        end
    end

    inst.pepe_attack_times = (inst.pepe_attack_times or 0) + 1
    inst.components.weapon:SetDamage((34 + ((inst.pepe_level or 0) * 3.4)) * (1 + (0.5*(inst.pepe_attack_times or 0))))
    if (inst.pepe_attack_times or 0) >= 3 then
        inst.components.hoshino_com_polymorphic_attack_action:SetType(3)
    else
        inst.components.hoshino_com_polymorphic_attack_action:SetType(1)
    end
    if (inst.pepe_attack_times or 0) >= 6 then
        inst.pepe_attack_times = 6
    end
    if inst.pepe_cancel_task then
        inst.pepe_cancel_task:Cancel()
    end
    inst.pepe_cancel_task = inst:DoTaskInTime(10,function()
        inst.pepe_attack_times = nil
        inst.components.weapon:SetDamage((34 + ((inst.pepe_level or 0) * 3.4)) * (1 + (0.5*(inst.pepe_attack_times or 0))))
        inst.components.hoshino_com_polymorphic_attack_action:SetType(1)
    end)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_weapon_pepe_hammer")
    inst.AnimState:SetBuild("hoshino_weapon_pepe_hammer")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hammer")
    inst:AddTag("pepe_hammer")

    --inst:AddTag("magic")
    --inst:AddTag("magical")
    inst:AddTag("sticky_weapon")
    --inst:AddTag("allow_action_on_impassable")
    --inst:AddTag("irreplaceable")
    --inst:AddTag("nonpotatable")
    inst:AddTag("prey")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.pepe_HasSchist = false
    inst.pepe_SpeedMult = false
    inst.pepe_HasMax = false
    inst.pepe_HasAxe = false
    inst.pepe_HasPickaxe = false
    inst.pepe_HasShovel = false
    inst.pepe_HasRod = false
    inst.pepe_HasNet = false
    inst.pepe_level = 0

    --inst.fxcolour = {255/255, 80/255, 173/255}

    inst:AddComponent("weapon") --增加武器组件 有了这个才可以打人
    inst.components.weapon:SetDamage(34) --设置伤害34
    inst.components.weapon:SetRange(2, 2)
    inst.components.weapon:SetOnAttack(onattack)
    inst.isunfolded = false

    inst:AddComponent("useableitem")                        --切换功能
	inst.components.useableitem:SetOnUseFn(pepe)

	inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 5)--砍
	inst.components.tool:SetAction(ACTIONS.MINE, 5)--稿击
	inst.components.tool:SetAction(ACTIONS.HAMMER, 1)--锤子
    inst.components.tool:SetAction(ACTIONS.DIG, 1)--铲子
    inst.components.tool:SetAction(ACTIONS.NET, 1)--捕虫
    --inst.components.tool:EnableToughWork(true)--更结实的工具，能敲硬的东西
    inst:RemoveTag("CHOP_TOOL")
    inst:RemoveTag("MINE_TOOL")
	inst:RemoveTag("HAMMER_tool")
	inst:RemoveTag("DIG_tool")
    --inst:RemoveTag("NET_tool")

	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    inst:AddComponent("hoshino_com_polymorphic_attack_action")

	--inst:AddComponent("shaver")--剃刀

    inst.OnLoad = onload
	inst.OnSave = onsave
    -------

    --inst:AddComponent("finiteuses") --使用次数（叫耐久也可以）
    --inst.components.finiteuses:SetMaxUses(200)
    --inst.components.finiteuses:SetUses(200)

    --inst.components.finiteuses:SetOnFinished(inst.Remove) --没有耐久了移除武器

    inst:AddComponent("inspectable") --可检查组件

    inst:AddComponent("inventoryitem") --物品组件
    --inst.components.inventoryitem.imagename = "hammer"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_weapon_pepe_hammer.xml" --物品贴图

    --inst:AddComponent("stackable")
    --inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM	--可堆叠，上限40
	
    inst:AddComponent("equippable") --可装备组件
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.walkspeedmult = 1

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.acceptnontradable = true --可以交易无交易组件的物品
    inst.components.trader.deleteitemonaccept = false--接受物品时不移除

    inst:AddComponent("fishingrod")                         --钓鱼功能
    inst.components.fishingrod:SetWaitTimes(4, 16)           
    inst.components.fishingrod:SetStrainTimes(60, 60)       --钓鱼功能到这里结束

    return inst
end

return Prefab("hoshino_weapon_pepe_hammer", fn, assets)