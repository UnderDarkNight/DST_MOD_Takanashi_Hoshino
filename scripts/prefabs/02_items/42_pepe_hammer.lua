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
local function acceptable_com_inst(inst)
    inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_acceptable",function(inst,replica_com)
        replica_com:SetTestFn(function(inst,item,doer,right_click)
            if item and item.prefab == "goldenaxe" then
                return true
            end
            return false
        end)
        replica_com:SetText("hoshino_weapon_pepe_hammer","升级")
        replica_com:SetSGAction("dolongaction")
    end)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("hoshino_com_acceptable")
    inst.components.hoshino_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
        
        return true
    end)

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
    inst:AddTag("sticky_weapon")
    inst:AddTag("prey")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    acceptable_com_inst(inst)

    inst:AddComponent("weapon") --增加武器组件 有了这个才可以打人
    inst.components.weapon:SetDamage(34) --设置伤害34
    inst.components.weapon:SetRange(2, 2)
    inst.components.weapon:SetOnAttack(onattack)
    inst.isunfolded = false


	inst:AddComponent("tool")
    -- inst.components.tool:SetAction(ACTIONS.CHOP, 5)--砍
	-- inst.components.tool:SetAction(ACTIONS.MINE, 5)--稿击
	-- inst.components.tool:SetAction(ACTIONS.HAMMER, 1)--锤子
    -- inst.components.tool:SetAction(ACTIONS.DIG, 1)--铲子
    -- inst.components.tool:SetAction(ACTIONS.NET, 1)--捕虫
    --inst.components.tool:EnableToughWork(true)--更结实的工具，能敲硬的东西
    -- inst:RemoveTag("CHOP_TOOL")
    -- inst:RemoveTag("MINE_TOOL")
	-- inst:RemoveTag("HAMMER_tool")
	-- inst:RemoveTag("DIG_tool")
    --inst:RemoveTag("NET_tool")

	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    inst:AddComponent("hoshino_com_polymorphic_attack_action")
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

    inst:AddComponent("fishingrod")                         --钓鱼功能
    inst.components.fishingrod:SetWaitTimes(4, 16)           
    inst.components.fishingrod:SetStrainTimes(60, 60)       --钓鱼功能到这里结束

    return inst
end

return Prefab("hoshino_weapon_pepe_hammer", fn, assets)