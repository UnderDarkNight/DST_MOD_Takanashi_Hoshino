-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --[[

--     官方的debuff 屏蔽器。

    

-- ]]--
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- return function(inst)
--     if not TheWorld.ismastersim then
--         return
--     end
--     inst:ListenForEvent("master_postinit_hoshino",function()

--         inst:AddComponent("hoshino_com_offical_debuff_blocker")
--         local old_AddDebuff = inst.AddDebuff
--         inst.AddDebuff = function(self,debuff_name,debuff_prefab,...)
--             if self.components.hoshino_com_offical_debuff_blocker and self.components.hoshino_com_offical_debuff_blocker:IsBlocking(debuff_name,debuff_prefab) then
--                 return false
--             end
--             return old_AddDebuff(self,debuff_name,debuff_prefab,...)
--         end
        
--     end)
-- end