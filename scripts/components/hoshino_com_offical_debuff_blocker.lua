----------------------------------------------------------------------------------------------------------------------------------
--[[

    官方的debuff 屏蔽器。

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_offical_debuff_blocker = Class(function(self, inst)
    self.inst = inst

    self.block_list = {}


    ---------------------------------------------
    --- 
        self.modify_blocker_list = {}
        self.modify_blocker_remove_event = function(temp_inst)
            self:Remove_Modify_Blocker(temp_inst)
        end
    ---------------------------------------------

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_offical_debuff_blocker:Add_Modify_Blocker(temp_inst,debuff_name,debuff_prefab)
        self.modify_blocker_list[temp_inst] = {debuff_name,debuff_prefab}
        temp_inst:ListenForEvent("onremove",self.modify_blocker_remove_event)
    end
    
    function hoshino_com_offical_debuff_blocker:Remove_Modify_Blocker(temp_inst,debuff_name,debuff_prefab)
        if debuff_name and debuff_prefab then
                local new_table = {}
                for temp_inst,temp_data in pairs(self.modify_blocker_list) do
                    if temp_inst ~= temp_inst and temp_data[1] ~= debuff_name and temp_data[2] ~= debuff_prefab then
                        new_table[temp_inst] = temp_data
                    end
                end
                self.modify_blocker_list = new_table
                temp_inst:RemoveEventCallback("onremove",self.modify_blocker_remove_event)
        else
                local new_table = {}
                for temp_inst,temp_data in pairs(self.modify_blocker_list) do
                    if temp_inst ~= temp_inst then
                        new_table[temp_inst] = temp_data
                    end
                end
                self.modify_blocker_list = new_table
                temp_inst:RemoveEventCallback("onremove",self.modify_blocker_remove_event)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_offical_debuff_blocker:Add_Blocker(debuff_name,debuff_prefab)
        self.block_list[debuff_name] = debuff_prefab
    end
    function hoshino_com_offical_debuff_blocker:Remove_Blocker(debuff_name,debuff_prefab)
        local new_table = {}
        for temp_name,temp_prefab in pairs(self.block_list) do
            if temp_name ~= debuff_name and temp_prefab ~= debuff_prefab then
                new_table[temp_name] = temp_prefab
            end
        end
        self.block_list = new_table
    end
------------------------------------------------------------------------------------------------------------------------------
--
    function hoshino_com_offical_debuff_blocker:IsBlocking(debuff_name,debuff_prefab)
        if debuff_name and debuff_prefab then
            if self.block_list[debuff_name] == debuff_prefab then
                if TUNING.HOSHINO_DEBUGGING_MODE then
                    print("debuff is blocked by hoshino_com_offical_debuff_blocker", debuff_name,debuff_prefab)
                end
                return true
            end
            for temp_inst,temp_data in pairs(self.modify_blocker_list) do
                if temp_data and temp_data[1] == debuff_name and temp_data[2] == debuff_prefab then
                    if TUNING.HOSHINO_DEBUGGING_MODE then
                        print("debuff is blocked by hoshino_com_offical_debuff_blocker", debuff_name,debuff_prefab)
                    end
                    return true
                end
            end
        end
        return false
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_offical_debuff_blocker







