


local assets =
{
    Asset("ANIM", "anim/hoshino_item_special_packer.zip"),
    Asset( "IMAGE", "images/inventoryimages/hoshino_item_special_packer.tex" ),
    Asset( "ATLAS", "images/inventoryimages/hoshino_item_special_packer.xml" ),
    --- 纸盒子
    Asset("ANIM", "anim/hoshino_item_special_wraped_box.zip"),
    Asset( "IMAGE", "images/inventoryimages/hoshino_item_special_wraped_box.tex" ),
    Asset( "ATLAS", "images/inventoryimages/hoshino_item_special_wraped_box.xml" ),
}
local function wrap_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("hoshino_item_special_packer")
    inst.AnimState:SetBuild("hoshino_item_special_packer")
    inst.AnimState:PlayAnimation("idle")



	MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.77)
    inst.entity:SetPristine()


    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("giftwrap")
    inst.components.inventoryitem.imagename = "hoshino_item_special_packer"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_special_packer.xml"
    inst:AddComponent("hoshino_com_special_packer")
    inst.components.hoshino_com_special_packer:SetTestFn(function(target)
        -- 检查顺序：prefab白名单、prefab黑名单、tags黑名单、组件黑名单、头脑、生物

        local check_list_table = require("prefabs/02_items/06_special_packer_list")
        if check_list_table.prefab_whitelist[target.prefab] then
            return true
        end
        if check_list_table.prefab_blacklist[target.prefab] then
            return false
        end
        if target:HasOneOfTags(check_list_table.tags_blacklist or {}) then
            return false
        end

        for com_name, v in pairs(target.components) do
            if check_list_table.components_blacklist[com_name] then
                return false
            end
        end

        if target.brainfn then
            return false
        end

        return true
    end)
    inst.components.hoshino_com_special_packer:SetPackFn(function(target)
        local debugstring = target.entity:GetDebugString()
        -----------------------------------------------------------------------------------------------------
        --- 这段逻辑大部分来自【小穹MOD】，自己修改了一部分
            local bank,build,anim = nil,nil,nil
            if target.AnimState then

                bank, build, anim = debugstring:match("bank: (.+) build: (.+) anim: .+:(.+) Frame")
                if (not bank) or (bank:find("FROMNUM")) and target.AnimState.GetBank then
                    -- bank = target.prefab -- 抢救一下吧
                    bank = target.AnimState:GetBank()
                end
                if (not build) or (build:find("FROMNUM")) then
                    -- build = target.prefab -- 抢救一下吧
                    build = target.AnimState:GetBuild()
                end

                if target.skinname and not Prefabs[target.prefab .. "_placer"] then
                    local temp_inst = SpawnPrefab(target.prefab)
                    debugstring = temp_inst.entity:GetDebugString()
                    bank, build, anim = debugstring:match("bank: (.+) build: (.+) anim: .+:(.+) Frame")
                    temp_inst:Remove()
                end
            end
        -----------------------------------------------------------------------------------------------------
            if target and target.components.container and target.components.container:IsOpen() then
                target.components.container:Close()
            end
        -----------------------------------------------------------------------------------------------------
            -- print(bank,build,anim)
            local x,y,z = target.Transform:GetWorldPosition()
            local save_record = target:GetSaveRecord()
            local name = target:GetDisplayName()
            local box = SpawnPrefab("hoshino_item_special_wraped_box")
            box:PushEvent("Set",{
                save_record = save_record,
                bank = bank,
                build = build,
                anim = anim,
                name = name,
            })
            box.Transform:SetPosition(x, y, z)
            target:Remove()
            -- inst:Remove()
            inst.components.stackable:Get():Remove()
        -----------------------------------------------------------------------------------------------------
        return true
    end)

    MakeHauntableLaunch(inst)
    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)   -- 可被其他物品引燃
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    return inst
end

local function box_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("hoshino_item_special_wraped_box")
    inst.AnimState:SetBuild("hoshino_item_special_wraped_box")
    inst.AnimState:PlayAnimation("idle")

    inst.AnimState:SetScale(2,2,2)

	MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.77)
    inst.entity:SetPristine()
    ----------------------------------------------------------------------
    --- 给放置时候用的数据调取。
        inst.__net_string_json = net_string(inst.GUID,"hoshino_item_special_wraped_box","hoshino_item_special_wraped_box")
        inst:ListenForEvent("hoshino_item_special_wraped_box",function() --- 得到下发的数据
            inst.deploy_placer_data = {}
            pcall(function()
                local str = inst.__net_string_json:value()
                local temp_table = json.decode(str)
                if temp_table.bank and temp_table.build and temp_table.anim then
                    inst.deploy_placer_data = temp_table
                end
            end)
        end)
    ----------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("named")
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("gift_large2")
    inst.components.inventoryitem.imagename = "hoshino_item_special_wraped_box"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_special_wraped_box.xml"

    MakeHauntableLaunch(inst)
    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)   -- 可被其他物品引燃
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    ------------------------------------------------------------------------------------------
    ---- 参数设置
        inst:AddComponent("hoshino_data")
        inst:ListenForEvent("Set",function(_,_table)
            -- _table = {
            --     bank = "",  --- 
            --     build = "", ---
            --     anim = "",  ---
            --     name = "",  --- 显示名字
            --     save_record = "",  --- 储存代码
            -- }
            if _table.save_record == nil then
                inst:Remove()
                return
            end

            ------------------------------------------------------
                local deploy_placer_data = {
                    bank = _table.bank,
                    build = _table.build,
                    anim = _table.anim,
                }
                -- inst.__net_string_json:set(json.encode(deploy_placer_data)) --- 下发placer 用的数据
                inst.components.hoshino_data:Set("deploy_placer_data",deploy_placer_data)
            ------------------------------------------------------


            inst.components.hoshino_data:Set("save_record",_table.save_record)

            if _table.name then
                inst.components.named:SetName("Pack : ".._table.name)
            end
        end)
    ------------------------------------------------------------------------------------------
    ---- 重载的时候下发数据
        inst:DoTaskInTime(0,function()
            local deploy_placer_data = inst.components.hoshino_data:Get("deploy_placer_data") 
            if deploy_placer_data then
                inst.__net_string_json:set(json.encode(deploy_placer_data)) --- 下发placer 用的数据
            end
        end)
    ------------------------------------------------------------------------------------------
    --- 种植组件
        inst:AddComponent("deployable")                
        inst.components.deployable.ondeploy = function(inst, pt, deployer)
            local save_record = inst.components.hoshino_data:Get("save_record")
            
            if save_record then
                SpawnSaveRecord(save_record).Transform:SetPosition(pt.x, pt.y, pt.z)
            end

            inst:Remove()            
        end
        -- inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
    ------------------------------------------------------------------------------------------
    return inst
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- placer 相关的 hook
    local function placer_postinit_fn(inst)

            local old_SetBuilder_fn = inst.components.placer.SetBuilder
            inst.components.placer.SetBuilder = function(self,builder, recipe, invobject) --- 玩家准备放置预览的时候，会执行这个
                if invobject and invobject.deploy_placer_data then
                    local temp_table = invobject.deploy_placer_data
                    if temp_table.bank and temp_table.build and temp_table.anim then
                        inst.AnimState:SetBank(temp_table.bank)
                        inst.AnimState:SetBuild(temp_table.build)
                        inst.AnimState:PlayAnimation(temp_table.anim,true)
                        if TheWorld.state.issnowcovered then
                            inst.AnimState:Show("snow")
                        else
                            inst.AnimState:Hide("snow")
                        end
                    end
                end
                return old_SetBuilder_fn(self,builder, recipe, invobject)
            end
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_item_special_packer", wrap_fn, assets),
        Prefab("hoshino_item_special_wraped_box", box_fn, assets),
        MakePlacer("hoshino_item_special_wraped_box_placer", "hoshino_item_special_wraped_box", "hoshino_item_special_wraped_box", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil)
