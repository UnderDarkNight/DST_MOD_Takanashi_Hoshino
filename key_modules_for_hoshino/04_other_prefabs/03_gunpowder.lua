-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    火药 gunpowder

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "gunpowder",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.explosive == nil then
            return
        end
        --- 记录点火的人
        inst.____hoshino__onignite_doer = nil
        local old_onignite = inst.components.burnable.onignite
        inst.components.burnable.onignite = function(inst, source, doer)
            -- print("onignite",inst,source,doer)
            -- 火魔杖的时候，source是玩家，doer是nil
            -- 火把的时候，source是火把，doer是玩家
            if type(source) == "table" and source.HasTag and source:HasTag("player") then
                inst.____hoshino__onignite_doer = source
            end
            if type(doer) == "table" and doer.HasTag and doer:HasTag("player") then
                inst.____hoshino__onignite_doer = doer
            end
            if type(old_onignite) == "function" then
                old_onignite(inst, source, doer)
            end
        end
        --- 熄灭时清除记录
        inst:ListenForEvent("onextinguish",function()
            inst.____hoshino__onignite_doer = nil
            -- print("onextinguish",inst)
        end)


        local old_onexplodefn = inst.components.explosive.onexplodefn
        inst.components.explosive.onexplodefn = function(inst,...)
            -- local x,y,z = inst.Transform:GetWorldPosition()
            -- local ents = TheSim:FindEntities(x, 0, z, 15 ,{"player"})
            -- for k, player in pairs(ents) do
            --     player:PushEvent("hoshino_event.gunpowder_explode",inst)
            -- end
            -- print("onexplodefn",inst,inst.____hoshino__onignite_doer)
            if inst.____hoshino__onignite_doer then
                inst.____hoshino__onignite_doer:PushEvent("hoshino_event.gunpowder_explode",inst)
            end
            return old_onexplodefn(inst,...)
        end

    end
)


