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

end,
nil,
{
    owner = SetOwner,
})
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_item_spell:SetOwner(owner)
        self.owner = owner
        owner.components.playercontroller:Enable(false)  --- 恢复鼠标点击移动
        self.inst:ListenForEvent("onremove",function()
            owner.components.playercontroller:Enable(true)  --- 屏蔽鼠标点击移动            
        end)
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_item_spell







