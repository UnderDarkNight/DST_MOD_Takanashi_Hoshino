--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    hook moisture 潮湿度组件.实现诅咒

    15、【诅咒】【潮湿】【你的潮湿度永远无法降低】【从诅咒池移除】

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function HasCurse(inst)
        local debuff_prefab = "hoshino_card_debuff_moisture_down_blocker"
        local debuff_inst = inst:GetDebuff(debuff_prefab)
        if debuff_inst and debuff_inst:IsValid() then
            return true
        end
        return false
    end
    local function com_hook(inst)
        if inst.components.moisture == nil then
            return
        end
        local old_DoDelta = inst.components.moisture.DoDelta
        inst.components.moisture.DoDelta = function(self,num,...)
            if num < 0 and HasCurse(inst) then
                num = 0
            end
            return old_DoDelta(self,num,...)
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("master_postinit_hoshino",com_hook)

end