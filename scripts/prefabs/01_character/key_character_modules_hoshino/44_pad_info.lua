--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function GetInfo(inst)
        local combat = inst.components.combat
        local speed = inst.components.locomotor
        local health = inst.components.health

        return {
            damage = string.format("%.2f%%", (combat.damagemultiplier or 1)* combat.externaldamagemultipliers:Get()* 100) .." + ".. string.format("%.2f", (combat.damagebonus or 0) ),
            defence = string.format("%.2f%% * %.2f%%",combat.externaldamagetakenmultipliers:Get()* 100, math.clamp(1 - health.absorb, 0, 1) * math.clamp(1 - health.externalabsorbmodifiers:Get(), 0, 1)*100) ,
            speed = string.format("%.2f - %.2f",speed:GetWalkSpeed(), speed:GetRunSpeed() ),
        }
    end
    local function UPDATE_FN(inst)
        inst.components.hoshino_com_rpc_event:PushEvent("hoshino_event.pad_data_update",{
            info = GetInfo(inst)
        })
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    -- inst.HOSHINO_INFO_CLIENT_SIDE_DATA = {}
    -- inst:ListenForEvent("HOSHINO_INFO_CLIENT_SIDE_UPDATE",function(inst,_table)
    --     _table = _table or {}
    --     for k, v in pairs(_table) do
    --         inst.HOSHINO_INFO_CLIENT_SIDE_DATA[k] = v
    --     end
    -- end)
    if not TheWorld.ismastersim then
        return
    end

    inst:DoPeriodicTask(5,UPDATE_FN)
    inst:ListenForEvent("unequip",UPDATE_FN)
    inst:ListenForEvent("equip",UPDATE_FN)
    inst:ListenForEvent("hoshino_cards_sys.card_activated",UPDATE_FN)
end