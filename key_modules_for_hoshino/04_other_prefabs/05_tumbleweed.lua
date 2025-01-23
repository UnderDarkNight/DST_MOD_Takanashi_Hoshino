-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    风滚草

    风滚草里0.4%出藏宝图

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local loot_pick_spawn_event = function(inst)
    if inst:HasTag("hoshino_item_treasure_map_spawned") then        
        return
    end
    inst:AddTag("hoshino_item_treasure_map_spawned")

    inst.loot = inst.loot or {}
    if math.random(1000) <= 4 then
        table.insert(inst.loot,"hoshino_item_treasure_map")
    end
end

AddPrefabPostInit(
    "tumbleweed",
    function(inst)
        if not TheWorld.ismastersim then            
            return
        end


        if inst.components.pickable == nil then            
            return
        end

        -- local old_onpickup_fn = inst.components.pickable.onpickedfn
        -- inst.components.pickable.onpickedfn = function(inst,picker)

        -- end

        inst:ListenForEvent("detachchild",loot_pick_spawn_event)

    end
)


