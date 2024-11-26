--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    柴关拉面店

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 素材
    local assets =
    {
        Asset("ANIM", "anim/hoshino_building_shiba_seki_ramen_cart.zip"),
    }
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 聊天泡泡安装
    local function client_side_bubble_install(inst)
        if TheNet:IsDedicated() then
            return
        end
        local fn = require("prefabs/06_buildings/02_02_shiba_seki_ramen_cart_bubble_install")
        if type(fn) == "function" then
            fn(inst)
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 物品刷新器
    local function item_spawner_install(inst)
        local fn = require("prefabs/06_buildings/02_03_shiba_seki_ramen_cart_item_spawner")
        if type(fn) == "function" then
            fn(inst)
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 价格获取
    local function GetPrice(inst,item)
        local food_list = TUNING.HOSHINO_SHIBA_SEKI_RAMEN_CART_ITEM_POOL or {}
        if item and item.prefab and food_list[item.prefab] then
            local price = food_list[item.prefab]
            if item:HasTag("on_sale") then
                price = math.ceil(price * 0.8) -- 向上取整
            end
            return price
        end
        return 9999999
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(2, .6)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("hoshino_building_shiba_seki_ramen_cart.tex")

    MakeObstaclePhysics(inst, 1.5)---设置一下距离

    inst.AnimState:SetBank("hoshino_building_shiba_seki_ramen_cart")
    inst.AnimState:SetBuild("hoshino_building_shiba_seki_ramen_cart")
    inst.AnimState:PlayAnimation("idle")
    -- local scale = 1.5
    -- inst.AnimState:SetScale(scale,scale,scale)

    inst.__item_left = net_entity(inst.GUID,"hoshino_building_shiba_seki_ramen_cart.left","item_update")
    inst.__item_mid = net_entity(inst.GUID,"hoshino_building_shiba_seki_ramen_cart.mid","item_update")
    inst.__item_right = net_entity(inst.GUID,"hoshino_building_shiba_seki_ramen_cart.right","item_update")

    inst:AddTag("hoshino_building_shiba_seki_ramen_cart")

    inst.entity:SetPristine()


    -----------------------------------------------------------------
    ---
        client_side_bubble_install(inst)
    -----------------------------------------------------------------
    ---
        inst.GetPrice = GetPrice
    -----------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end
    -----------------------------------------------------------------
    --- 
        inst:AddComponent("hoshino_data")
    -----------------------------------------------------------------
    --- 清空演示用的图层
        inst.AnimState:OverrideSymbol("left","hoshino_building_shiba_seki_ramen_cart","empty")
        inst.AnimState:OverrideSymbol("mid","hoshino_building_shiba_seki_ramen_cart","empty")
        inst.AnimState:OverrideSymbol("right","hoshino_building_shiba_seki_ramen_cart","empty")
    -----------------------------------------------------------------
    --- 设置API
        local slots = {["left"] = true,["mid"] = true,["right"] = true,}
        function inst:SetItem(item,slot,on_sale)
            slot = slot or "left"
            if not slots[slot] then
                return
            end            
            if inst["item_"..slot] then
                inst["item_"..slot]:Remove()
                inst["item_"..slot] = nil
            end
            if not ( item and item:IsValid() )then
                inst["__item_"..slot]:set(inst)
                return
            end
            if on_sale then
                item:AddTag("on_sale")
            end
            inst["item_"..slot] = item
            item.entity:SetParent(inst.entity)
            if item.components.perishable ~= nil then
                item.components.perishable:StopPerishing()
            end
            item:AddTag("NOCLICK")
            item:ReturnToScene()
            if item.Follower == nil then
                item.entity:AddFollower()
            end
            item.Follower:FollowSymbol(inst.GUID,string.upper(tostring(slot) or "MID"), 0, 0, 0, true)
            inst["__item_"..slot]:set(item)
        end
        function inst:ClearItem(slot)
            self:SetItem(nil,slot)
        end
        function inst:GetItem(slot)
            slot = slot or "left"
            local item = inst["item_"..slot]
            if item and item:IsValid() then
                return item
            end
            return nil
        end
        inst.components.hoshino_data:AddOnSaveFn(function()
            for slot,flag in pairs(slots) do
                local temp_item = inst["item_"..slot]
                if temp_item then
                    inst.components.hoshino_data:Set(slot,temp_item:GetSaveRecord())
                    inst.components.hoshino_data:Set(slot.."_on_sale",temp_item:HasTag("on_sale"))
                else
                    inst.components.hoshino_data:Set(slot,nil)
                    inst.components.hoshino_data:Set(slot.."_on_sale",false)
                end
            end
        end)
        inst.components.hoshino_data:AddOnLoadFn(function()
            for slot,flag in pairs(slots) do
                local saved_record = inst.components.hoshino_data:Get(slot)
                local on_sale = inst.components.hoshino_data:Get(slot.."_on_sale")
                if saved_record then
                    local temp_item = SpawnSaveRecord(saved_record)
                    if on_sale then
                        temp_item:AddTag("on_sale")
                    end
                    inst:SetItem(temp_item,slot)
                end
            end
        end)
    -----------------------------------------------------------------
    --- 物品刷新器
        item_spawner_install(inst)
    -----------------------------------------------------------------

    inst:AddComponent("inspectable")
    return inst
end

return Prefab("hoshino_building_shiba_seki_ramen_cart", fn, assets)
