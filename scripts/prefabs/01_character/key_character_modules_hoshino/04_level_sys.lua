--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    等级系统

    注意处理诅咒：11、【诅咒】【斗争之心】【你只能从BOSS生物中获取经验值】【从诅咒池移除】

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function Exp_Only_From_Epic(inst)
        local debuff_inst = inst:GetDebuff("hoshino_card_debuff_exp_and_epic")
        if debuff_inst and debuff_inst:IsValid() then
            return true
        end
        return false
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("hoshino_com_level_sys")

    inst:ListenForEvent("hoshino_com_level_sys.exp_full",function()
        local current_level = inst.components.hoshino_com_level_sys:GetLevel()
    end)

end