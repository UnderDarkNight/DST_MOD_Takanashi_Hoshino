-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    物品掉落控制器

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local active_fns = {
    -------------------------------------------------------
    --- 远古守护者
        ["minotaur"] = function(inst)
            inst.components.lootdropper:SpawnLootPrefab("hoshino_equipment_guardian_core")
        end,
    -------------------------------------------------------
    --- 树精
        ["leif"] = function(inst)
            if math.random() <= 0.1 then
                inst.components.lootdropper:SpawnLootPrefab("hoshino_equipment_tree_core")
            end
        end,
        ["leif_sparse"] = function(inst)
            if math.random() <= 0.1 then
                inst.components.lootdropper:SpawnLootPrefab("hoshino_equipment_tree_core")
            end
        end,
    -------------------------------------------------------
    --- 蛛后
        ["spiderqueen"] = function(inst)
            if math.random() <= 0.1 then
                inst.components.lootdropper:SpawnLootPrefab("hoshino_equipment_spider_core")
            end
        end,
    -------------------------------------------------------
    --- 帝王蟹
        ["crabking"] = function(inst)
            inst.components.lootdropper:SpawnLootPrefab("hoshino_equipment_giant_crab_claw")
        end,
    -------------------------------------------------------
    --- 蠕虫BOSS
        ["worm_boss"] = function(inst)
            inst.components.lootdropper:SpawnLootPrefab("hoshino_equipment_worm_core")
        end,
    -------------------------------------------------------

    }
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "world",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        TheWorld:ListenForEvent("entity_droploot",function(_,_table)
            local target = _table.inst
            local prefab = tostring(target and target.prefab)
            if target and active_fns[prefab] and target.components.lootdropper then
                active_fns[prefab](target)
            end
        end)

    end
)


