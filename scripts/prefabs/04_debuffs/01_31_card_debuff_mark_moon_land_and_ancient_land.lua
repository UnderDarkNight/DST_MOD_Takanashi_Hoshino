------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【白】【似曾相识】标记月岛和远古的位置（选择后从卡池移除）

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
-- 
    local function view_pt(player,pt)
        local item = SpawnPrefab("hoshino_item_treasure_map")
        item:AddComponent("mapspotrevealer")
        item.components.mapspotrevealer:SetGetTargetFn(function(inst,doer)
            return pt
        end)
        item.components.mapspotrevealer:RevealMap(player)
        item:Remove()
    end
    local function GetTargetPt()
        ----------------------------------------------------------------------------
            local target = nil
            local target_prefab = "moon_fissure"
            if TheWorld:HasTag("cave") then
                target_prefab = "ancient_altar"
            end
            for k, v in pairs(Ents) do
                if v and v:IsValid() and v.prefab == target_prefab then
                    target = v
                    break
                end
            end
            if target == nil then
                return
            end
            return Vector3(target.Transform:GetWorldPosition())
        ----------------------------------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------
local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(player.entity)
    -- inst.Network:SetClassifiedTarget(player)
    inst.Transform:SetPosition(0,0,0)
    inst.player = player
    -----------------------------------------------------
    --
        inst:ListenForEvent("hoshino_event.inspect_hud_close",function()
            inst:Remove()
            local pt = GetTargetPt()
            if pt then
                view_pt(player,pt)
            end
        end,player)
    -----------------------------------------------------
end
local function ExtendDebuff(inst)
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
    -- inst:AddComponent("hoshino_data")
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    -- inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    inst.components.debuff:SetDetachedFn(inst.Remove)
    return inst
end

return Prefab("hoshino_card_debuff_mark_moon_land_and_ancient_land", fn)
