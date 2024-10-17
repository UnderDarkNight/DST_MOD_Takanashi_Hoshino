----------------------------------------------------------------------------------------------------------------------------------
--[[

    任务系统。给建筑

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_task_sys_for_building = Class(function(self, inst)
    self.inst = inst


    ------------------------------------------------
    --- 刷新次数
        self.refresh_num = 0
        inst:ListenForEvent("refresh_num_update",function(inst,num)
            self.refresh_num = num
        end)
    ------------------------------------------------


end)
------------------------------------------------------------------------------------------------------------------------------
-- RPC + owner
    function hoshino_com_task_sys_for_building:GetContainer()
        return self.inst.replica.container or self.inst.replica._.container
    end
    function hoshino_com_task_sys_for_building:GetOwner()
        local container = self:GetContainer()
        if container and ThePlayer and container:IsOpenedBy(ThePlayer) then
            return ThePlayer
        end
        return nil
    end
    function hoshino_com_task_sys_for_building:GetRPC()
        local owner = self:GetOwner()
        if owner then
            return owner.replica.hoshino_com_rpc_event or owner.replica._.hoshino_com_rpc_event
        end
    end
------------------------------------------------------------------------------------------------------------------------------
-- 刷新 相关
    function hoshino_com_task_sys_for_building:Get_Refresh_Num()
        return self.refresh_num or 0
    end
    function hoshino_com_task_sys_for_building:Refresh_Button_Click(index)
        local rpc = self:GetRPC()
        if rpc then
            rpc:PushEvent("refresh_button_click",index,self.inst)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_task_sys_for_building







