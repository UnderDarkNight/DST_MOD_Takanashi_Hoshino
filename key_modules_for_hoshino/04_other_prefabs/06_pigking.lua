-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    猪王。

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "pigking",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:ListenForEvent("trade",function(inst,_table)
            local giver = _table and _table.giver
            local item = _table and _table.item
            -- print("pigking trade", giver,item)
            if giver then
                giver:PushEvent("hoshino_event.pigking_accepted",item)
            end
        end)


    end
)


