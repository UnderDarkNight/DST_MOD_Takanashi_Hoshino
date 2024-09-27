----------------------------------------------------------------------------------------------------------------------------------
--[[

    官方的debuff 屏蔽器。

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_offical_debuff_blocker = Class(function(self, inst)
    self.inst = inst

    self.block_list = {}

end,
nil,
{

})
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
    function hoshino_com_offical_debuff_blocker:IsBlocking(debuff_name,debuff_prefab)
        if debuff_name and debuff_prefab then
            if self.block_list[debuff_name] == debuff_prefab then
                if TUNING.HOSHINO_DEBUGGING_MODE then
                    print("debuff is blocked by hoshino_com_offical_debuff_blocker", debuff_name,debuff_prefab)
                end
                return true
            end            
        end
        return false
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_offical_debuff_blocker







