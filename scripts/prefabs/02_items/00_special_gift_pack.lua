------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    初始化外观参数和名字：
    inst:PushEvent("Set",{    
            num = math.random(6),
            name = "test gift pack",
            desc = "test gift pack 666",
            -- bank = "gift",
            -- build = "gift",
            -- anim = "idle_large2",
            -- atlas = "gift",
            -- imagename = "gift_large2",
            items_record = {},

    })
    inst:PushEvent("AddItemRecord",item_inst_or_record)

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材
    local assets =
    {
        Asset("ANIM", "anim/cane.zip"),
        Asset("ANIM", "anim/swap_cane.zip"),
    }
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function unwrapped_Fn(inst,pos,doer)
        local x,y,z = inst.Transform:GetWorldPosition()
        local launcher = doer
        if inst.components.inventoryitem.owner then
            x,y,z = doer.Transform:GetWorldPosition()
        else
            launcher = inst
        end
        local items_record = inst.data_com:Get("data",{ items_record = {} }).items_record
        for k, temp_record in pairs(items_record or {}) do
            local item = SpawnSaveRecord(temp_record)
            item.Transform:SetPosition(x,0,z)
            if item.components.inventoryitem then
                LaunchAt(item,launcher, nil, 0.2, 0.1)
            end
        end
        inst:Remove()
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 设置外观
    local Skin_table = {
        [1] = {"idle_small1","gift_small1"},
        [2] = {"idle_small2","gift_small2"},
        [3] = {"idle_medium1","gift_medium1"},
        [4] = {"idle_medium2","gift_medium2"},
        [5] = {"idle_large1","gift_large1"},
        [6] = {"idle_large2","gift_large2"},
    }
    local function SetSkin(inst,num_or_bank,build,anim,atlas,imagename)
        if type(num_or_bank) == "number" or type(num_or_bank) == nil then            
            num_or_bank = math.clamp(num_or_bank or math.random(6),1,#Skin_table)
            local bank = "gift"
            local build = "gift"
            local anim = Skin_table[num_or_bank][1]
            inst.AnimState:SetBank(bank)
            inst.AnimState:SetBuild(build)
            inst.AnimState:PlayAnimation(anim,true)
            inst.components.inventoryitem:ChangeImageName(Skin_table[num_or_bank][2])
        elseif num_or_bank and build and anim and atlas and imagename then
            inst.AnimState:SetBank(num_or_bank)
            inst.AnimState:SetBuild(build)
            inst.AnimState:PlayAnimation(anim,true)
            inst.components.inventoryitem.imagename = imagename
            inst.components.inventoryitem.atlasname = atlas
            inst:PushEvent("imagechange")
        end
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function set_data_fn(inst,_table)
        local _table = _table or inst.data_com:Get("data",{
            num = math.random(6),
            name = "test gift pack",
            desc = "test gift pack 666",
            -- bank = "gift",
            -- build = "gift",
            -- anim = "idle_large2",
            -- atlas = "gift",
            -- imagename = "gift_large2",
            items_record = {},
        })
        SetSkin(inst,_table.num or _table.bank,_table.build,_table.anim,_table.atlas,_table.imagename)
        inst.components.inspectable:SetDescription(_table.desc)
        inst.components.named:SetName(_table.name)
        inst.data_com:Set("data",_table)
    end
    local function AddItemRecord(inst,record_or_item)
        local data = inst.data_com:Get("data")
        if data == nil then
            return
        end
        data.items_record = data.items_record or {}
        local record = record_or_item
        if type(record_or_item) == "table" and record_or_item.Transform then
            record = record_or_item:GetSaveRecord()
            record_or_item:Remove()
        end
        table.insert(data.items_record,record)
        inst.data_com:Set("data",data)
    end
    local function data_com_init(inst)
        inst.data_com = inst:AddComponent("hoshino_data")
        inst:ListenForEvent("Set",set_data_fn)
        inst:ListenForEvent("AddItemRecord",AddItemRecord)
        inst.data_com:AddOnLoadFn(set_data_fn)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        MakeInventoryPhysics(inst)
        inst.AnimState:SetBank("gift")
        inst.AnimState:SetBuild("gift")
        inst.AnimState:PlayAnimation("idle_large2")
        MakeInventoryFloatable(inst)
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end
        --------------------------------------------------------------------------------------
        ---
            inst:AddComponent("named")
            inst:AddComponent("inspectable")
            inst:AddComponent("inventoryitem")
        --------------------------------------------------------------------------------------
        ---- 拆包相关组件     
            inst:AddComponent("unwrappable")
            -- inst.components.unwrappable:SetOnWrappedFn(OnWrapped)
            inst.components.unwrappable:SetOnUnwrappedFn(unwrapped_Fn)
        --------------------------------------------------------------------------------------
            MakeHauntableLaunch(inst)
        --------------------------------------------------------------------------------------
        --- 
            data_com_init(inst)
        --------------------------------------------------------------------------------------
        return inst
    end
------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_item_special_gift_pack", fn, assets)
