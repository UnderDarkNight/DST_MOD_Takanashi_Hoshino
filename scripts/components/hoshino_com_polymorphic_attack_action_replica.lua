----------------------------------------------------------------------------------------------------------------------------------
--[[

    多态攻击动作

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

    self.index = 1


    inst:ListenForEvent("SetType",function(inst,_type)
        self.index = _type
    end)

end)
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_polymorphic_attack_action:GetTypeIndex()
        if TheWorld.ismastersim then
            return self.inst.components.hoshino_com_polymorphic_attack_action:GetTypeIndex()
        end
        return self.index
    end
    function hoshino_com_polymorphic_attack_action:GetTypeSG()        
        return attack_sg_type[self:GetTypeIndex()]
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_polymorphic_attack_action







