-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddPlayerPostInit(function(inst)
    ------------------------------------------------------------------------
    --- tag 系统
        inst:DoTaskInTime(0,function()
            -- print("+++++ start hook hoshino_com_tag_sys")
            local old_HasTag = inst.HasTag
            inst.HasTag = function(inst, tag)
                local ret = old_HasTag(inst, tag)
                if not ret and inst.replica.hoshino_com_tag_sys then            
                    ret = inst.replica.hoshino_com_tag_sys:HasTag(tag)
                end
                return ret
            end
            -- print("+++++ finish hook hoshino_com_tag_sys")
        end)
        if TheWorld.ismastersim then
            if inst.components.hoshino_com_tag_sys == nil then
                inst:AddComponent("hoshino_com_tag_sys")
            end
        end
    ------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return
    end
    ------------------------------------------------------------------------
    --- 通用数据库
        if inst.components.hoshino_data == nil then
            inst:AddComponent("hoshino_data")
        end
    ------------------------------------------------------------------------
    --- RPC信道
        if inst.components.hoshino_com_rpc_event == nil then
            inst:AddComponent("hoshino_com_rpc_event")
        end
    ------------------------------------------------------------------------
    --- 任务系统
        if inst.components.hoshino_com_task_sys_for_player == nil then
            inst:AddComponent("hoshino_com_task_sys_for_player")
        end
    ------------------------------------------------------------------------
    --- 商店系统+货币系统
        if inst.components.hoshino_com_shop == nil then
            inst:AddComponent("hoshino_com_shop")
        end
        ---- 加载的时候初始化下发全部数据。
        inst:DoTaskInTime(0,function()
            inst.components.hoshino_com_shop:CreditCoinDelta(0)
        end)
    ------------------------------------------------------------------------
    --- 等级系统
        if inst.components.hoshino_com_level_sys == nil then
            inst:AddComponent("hoshino_com_level_sys")
        end
        if inst.prefab ~= "hoshino" then
            inst.components.hoshino_com_level_sys:EXP_SetModifier(inst,0)
        end
    ------------------------------------------------------------------------
    --- 屏蔽掉落、避免意外
        if inst.components.inventory and not inst.components.inventory.__hoshino_DropItem_hooked then
            local old_DropItem = inst.components.inventory.DropItem
            inst.components.inventory.DropItem = function(self,item,...)
                if item and item:HasOneOfTags({"hoshino_special_equipment","hoshino_spell_item","hoshino_drop_block"}) then
                    return
                end
                return old_DropItem(self,item,...)
            end
            inst.components.inventory.__hoshino_DropItem_hooked = true
        end
    ------------------------------------------------------------------------


end)