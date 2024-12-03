-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    猴子诅咒物品修改
]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "cursed_monkey_token",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.curseditem == nil then
            return
        end

        local old_checkplayersinventoryforspace = inst.components.curseditem.checkplayersinventoryforspace
        inst.components.curseditem.checkplayersinventoryforspace = function(self, player,...)
            if player and player.prefab == "hoshino" then
                return false
            end
            return old_checkplayersinventoryforspace(self, player,...)
        end

    end
)


