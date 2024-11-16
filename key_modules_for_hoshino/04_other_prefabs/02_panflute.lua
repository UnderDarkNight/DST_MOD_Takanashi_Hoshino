-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    排箫

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "panflute",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.instrument == nil then
            return
        end

        local old_onheard = inst.components.instrument.onheard

        inst.components.instrument.onheard = function(inst, musician, instrument)
            -- print("panflute",inst, musician, instrument)
            -- instrument 排箫的prefab
            -- musician 玩家
            -- inst 目标
            if musician and musician:HasTag("player") then
                if inst and inst.components.health and inst.sg then
                    musician:PushEvent("hoshino_event.panflute",{
                        target = inst,
                        item = instrument,
                    })
                end
            end
            return old_onheard(inst, musician, instrument)
        end

    end
)


