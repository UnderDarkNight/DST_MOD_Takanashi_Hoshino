----------------------------------------------------------------------------------------------------------------------------------
--[[

    多态攻击动作

    1 - 普通攻击
    2 - 连刺
    3 - 跳劈
    4 - 划

]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local attack_sg_type = {
        [1] = nil,
        [2] = "hoshino_com_polymorphic_attack_action_multithrust",
        [3] = "hoshino_com_polymorphic_attack_action_hop",
        [4] = "hoshino_com_polymorphic_attack_action_lunge",
    }
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_polymorphic_attack_action = Class(function(self, inst)
    self.inst = inst
    inst:AddTag("hoshino_tag.polymorphic_attack_action")

    self.max_index = 4
    self.index = 1
end)
------------------------------------------------------------------------------------------------------------------------------
--- 通过RPC进行切换，减少延迟响应
    function hoshino_com_polymorphic_attack_action:GetRPC()
        local owner = self.inst.components.inventoryitem.owner
        if owner and owner:HasTag("player") and owner.userid then
            return owner.components.hoshino_com_rpc_event
        end
    end
    function hoshino_com_polymorphic_attack_action:PushEvent(event_name,cmd)
        local player_rpc = self:GetRPC()
        if player_rpc then
            player_rpc:PushEvent(event_name,cmd,self.inst)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_polymorphic_attack_action:SetType(index)
        self.index = math.clamp(index,1,self.max_index)
        self:PushEvent("SetType",self.index)
    end
    function hoshino_com_polymorphic_attack_action:SetNextType()
        local current = self.index
        local ret = current + 1
        if ret > self.max_index then
            ret = 1
        end
        self:SetType(ret)
    end
    function hoshino_com_polymorphic_attack_action:SetRandomType()
        self:SetType(math.random(1,self.max_index))
    end
    function hoshino_com_polymorphic_attack_action:GetTypeIndex()
        return self.index
    end
    function hoshino_com_polymorphic_attack_action:GetTypeSG()
        return attack_sg_type[self:GetTypeIndex()]
    end
------------------------------------------------------------------------------------------------------------------------------
---
return hoshino_com_polymorphic_attack_action







