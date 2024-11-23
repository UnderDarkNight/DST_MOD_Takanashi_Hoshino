-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --[[



-- ]]--
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- return function(inst)

--     inst:DoTaskInTime(0,function()
--         -- print("+++++ start hook hoshino_com_tag_sys")
--         local old_HasTag = inst.HasTag
--         inst.HasTag = function(inst, tag)
--             local ret = old_HasTag(inst, tag)
--             if not ret and inst.replica.hoshino_com_tag_sys then            
--                 ret = inst.replica.hoshino_com_tag_sys:HasTag(tag)
--             end
--             return ret
--         end
--         -- print("+++++ finish hook hoshino_com_tag_sys")
--     end)

--     if not TheWorld.ismastersim then
--         return
--     end
--     if inst.components.hoshino_com_tag_sys == nil then
--         inst:AddComponent("hoshino_com_tag_sys")
--     end
-- end

