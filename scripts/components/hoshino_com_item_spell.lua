----------------------------------------------------------------------------------------------------------------------------------
--[[

    物品技能控制器，用来 给玩家释放  鼠标指示圈圈技能。

    给玩家 穿戴 这件装备。装备里激活 指示圈圈，以及鼠标监听器。

    鼠标监听 左键施法，右键取消，通过RPC回传数据。


]]--
----------------------------------------------------------------------------------------------------------------------------------
--- 
    local function GetReplicaCom(self)
        return self.inst.replica.hoshino_com_item_spell or self.inst.replica._.hoshino_com_item_spell
    end
    local function SetOwner(self,owner)
        local replica_com = GetReplicaCom(self)
        if replica_com then
            replica_com:SetOwner(owner)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_item_spell = Class(function(self, inst)
    self.inst = inst
    
    self.owner = nil

    inst:DoTaskInTime(0,function()
        if self.owner == nil then
            inst:Remove()
        end
    end)

    self.need_to_close_controller = true

end,
nil,
{
    owner = SetOwner,
})
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_item_spell:SetOwner(owner)
        self.owner = owner
        -- owner.components.playercontroller:Enable(false)  --- 屏蔽鼠标点击移动
        self:TurnOffController()
        self.inst:ListenForEvent("onremove",function()
            -- owner.components.playercontroller:Enable(true)  --- 恢复鼠标点击移动
            self:TurnOnController()
        end)
        owner:AddChild(self.inst)
        owner.components.hoshino_com_rpc_event:PushEvent("owner_rpc_set_by_userid",owner.userid,self.inst) --- 走RPC管道做备用，避免NET延迟造成 技能放不出来。
    end
    function hoshino_com_item_spell:GetOwner()
        return self.owner
    end
    --- 保留两套。
    function hoshino_com_item_spell:SetCaster(doer)
        self:SetOwner(doer)
    end
    function hoshino_com_item_spell:GetCaster()
        return self:GetOwner()
    end
------------------------------------------------------------------------------------------------------------------------------
--- 设置是否关闭控制器
    function hoshino_com_item_spell:SetNeed2CloseController(flag)
        self.need_to_close_controller = flag
    end
    function hoshino_com_item_spell:TurnOnController()
        if self.need_to_close_controller then
            self.owner.components.playercontroller:Enable(true)  --- 恢复鼠标点击移动
        end
    end
    function hoshino_com_item_spell:TurnOffController()
        if self.need_to_close_controller then
            self.owner.components.playercontroller:Enable(false)  --- 屏蔽鼠标点击移动
        end
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_item_spell







