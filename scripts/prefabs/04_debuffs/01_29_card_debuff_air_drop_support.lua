------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    【空投支援】 接下来3天内获得物资支援，
    每到新的一天时在从空中落下一个物资支援包 其内从以下四种物品中随机出现一种(土豆手雷*4 12号霰弹*10 神名文字碎片*1 能量药水*3 )

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
--- 参数
    local SUPPORT_DAYS = 3 -- 支援天数
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local gift_list = {
        ["potato"] = 4,
        ["hoshino_item_12mm_shotgun_shells"] = 10,
        ["hoshino_item_fragments_of_divine_script"] = 1,
        ["hoshino_food_energy_drink"] = 3,
    }
    local function SpawnGift(x,y,z)
        local gift_pack = SpawnPrefab("hoshino_item_special_gift_pack")
        gift_pack:PushEvent("Set",{
            num = math.random(6),
            name = "空投支援",
            desc = "空投支援",
        })
        local prefab,num = GetRandomItemWithIndex(gift_list)
        print("【空投支援】 ",prefab,num)
        local item = SpawnPrefab(prefab)
        if item.components.stackable then
            item.components.stackable:SetStackSize(num or 1)
            gift_pack:PushEvent("AddItemRecord",item)
        else
            num = num - 1
            for i=1,num do
                gift_pack:PushEvent("AddItemRecord",SpawnPrefab(prefab))
            end
        end
        gift_pack.Transform:SetPosition(x,y,z)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(player.entity)
    -- inst.Network:SetClassifiedTarget(player)
    inst.Transform:SetPosition(0,0,0)
    inst.player = player
    -----------------------------------------------------
    --- 初始化层数
        if inst.components.hoshino_data:Get("num") == nil then
            inst.components.hoshino_data:Set("num", SUPPORT_DAYS)
        end
    -----------------------------------------------------
    --- 
        inst:WatchWorldState("cycles",function()
            local pt = Vector3(player.Transform:GetWorldPosition())
            SpawnPrefab("hoshino_sfx_colorful_sky_door"):PushEvent("Set",{
                pt = Vector3(pt.x,pt.y+1,pt.z),
                scale = Vector3(2.5,1,2.5)
            })
            inst:DoTaskInTime(3,function()
                SpawnGift(pt.x,8,pt.z)
                if inst.components.hoshino_data:Add("num", -1) <= 0 then
                    inst:Remove()
                end
            end)
        end)
    -----------------------------------------------------
end
local function ExtendDebuff(inst)
    inst.components.hoshino_data:Add("num", SUPPORT_DAYS)
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst:AddTag("CLASSIFIED")
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("hoshino_data")
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    return inst
end

return Prefab("hoshino_card_debuff_air_drop_support", fn)
