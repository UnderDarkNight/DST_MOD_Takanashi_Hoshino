--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    等级系统

    注意处理诅咒：11、【诅咒】【斗争之心】【你只能从BOSS生物中获取经验值】【从诅咒池移除】

    注意处理：10、【白】【透支】【根据当前剩余未打开的卡组数量，给玩家N张 1选1卡包，包括颜色对应，下三次升级不再赠送升级卡包。如果当前未翻开的剩余卡牌数量为0，则重新赠送一包1选1卡包】

    注意处理：54、【彩】【我已膨胀】【三维+300/300/300，基础攻击力倍增器2（2倍原始基础伤害，不算卡牌加成），受伤倍增器0.2（80%减伤）】【此后无法再获取经验】【选择之后从卡池移除】

    经验额外增加量： + inst.components.hoshino_com_debuff:GetExpMult()
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

        -----------------------------------------------------------------------------
        --- 清空经验并等级+1
            inst.components.hoshino_com_level_sys:SetExp(0)
            inst.components.hoshino_com_level_sys:Level_DoDelta(1)
            inst:PushEvent("hoshino_event.level_up")
        -----------------------------------------------------------------------------
        --- 送玩家升级卡包(注意屏蔽器)
            if inst.components.hoshino_com_debuff:Add("level_up_card_pack_gift_blocker",0) == 0 then
                local item = SpawnPrefab("hoshino_item_cards_pack")
                inst.components.inventory:GiveItem(item)
            else
                -- print("当前升级卡包被屏蔽")    
            end
            local num = inst.components.hoshino_com_debuff:Add("level_up_card_pack_gift_blocker",-1)
            if num < 0 then
                inst.components.hoshino_com_debuff:Set("level_up_card_pack_gift_blocker",0)
            end
        -----------------------------------------------------------------------------
        --- 更新经验曲线（修改max_exp）
        -----------------------------------------------------------------------------

    end)

end