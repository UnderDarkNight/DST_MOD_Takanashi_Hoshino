--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    等级系统

    注意处理诅咒：11、【诅咒】【斗争之心】【你只能从BOSS生物中获取经验值】【从诅咒池移除】

    注意处理：10、【白】【透支】【根据当前剩余未打开的卡组数量，给玩家N张 1选1卡包，包括颜色对应，下三次升级不再赠送升级卡包。如果当前未翻开的剩余卡牌数量为0，则重新赠送一包1选1卡包】

    注意处理：54、【彩】【我已膨胀】【三维+300/300/300，基础攻击力倍增器2（2倍原始基础伤害，不算卡牌加成），受伤倍增器0.2（80%减伤）】【此后无法再获取经验】【选择之后从卡池移除】

    经验额外增加量： + inst.components.hoshino_com_debuff:GetExpMult()

    --- 为了保证显示数据的初始化成功，初始等级为0，升级经验为10.


    最大经验函数曲线：
        E(n)=50+60×(n−1)     n∈[0,10)
        E(n)=590+20×(n−10)   n∈[11,40)
        E(n)=1100+10×(n−40 )  n∈[41,200)
        E(n)=2100+5×(n−200）   n∈[201,400)
        E(n)=3100+10×(n−400)  n≥401
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
    ----------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 为了保证显示数据的初始化成功，初始等级为0，升级经验为10.
        inst:DoTaskInTime(0,function()
            if not inst.components.hoshino_com_level_sys:Get("0_level_inited") then
                inst.components.hoshino_com_level_sys:Set("0_level_inited",true)
                inst.components.hoshino_com_level_sys:Exp_DoDelta(10)                
            end
        end)
    ----------------------------------------------------------------------------------------------------------------------------------------------------------
    ---
        inst:ListenForEvent("hoshino_com_level_sys.level_up",function(inst,level)
            if level <= 1 then
                return
            end
            --- 送玩家升级卡包(注意屏蔽器)
                if inst.components.hoshino_com_debuff:Add("level_up_card_pack_gift_blocker",0) == 0 then
                    local item = SpawnPrefab("hoshino_item_cards_pack")
                    inst.components.inventory:GiveItem(item)
                else
                    print("当前升级卡包被屏蔽")
                end
                local num = inst.components.hoshino_com_debuff:Add("level_up_card_pack_gift_blocker",-1)
                if num < 0 then
                    inst.components.hoshino_com_debuff:Set("level_up_card_pack_gift_blocker",0)
                end
            --- 系统广播
                TheNet:Announce("恭喜玩家【"..inst:GetDisplayName().."】升级到"..level.."级")
        end)
    ----------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 经验值上限更新函数。模块初始化的时候也会执行一次。
        inst.components.hoshino_com_level_sys:SetMaxExpUpdateFn(function(self)
            local level = self:GetLevel()
            --- 更新经验曲线（修改max_exp）
                if level < 10 then
                    self:SetMaxExp(50+60*(level-1))
                elseif level < 40 then
                    self:SetMaxExp(590+20*(level-10))
                elseif level < 200 then
                    self:SetMaxExp(1100+10*(level-40))
                elseif level < 400 then
                    self:SetMaxExp(2100+5*(level-200))
                else
                    self:SetMaxExp(3100+10*(level-400))
                end
        end)
    ----------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 经验倍增器更新
        inst:ListenForEvent("hoshino_event.exp_mult_update",function(inst)
            -------------------------------------------------------------------------------
            --- 来自 hoshino_com_debuff 模块的倍增器
                local mult_from_debuff = inst.components.hoshino_com_debuff:GetExpMult() + 1

            -------------------------------------------------------------------------------
            ---
                inst.components.hoshino_com_level_sys:EXP_SetModifier(inst,mult_from_debuff)
            -------------------------------------------------------------------------------
        end)
        inst:DoTaskInTime(1,function()
            inst:PushEvent("hoshino_event.exp_mult_update")
        end)
    ----------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 经验广播触发监听
        inst:ListenForEvent("hoshino_event.exp_broadcast",function(inst,_table)
            inst:PushEvent("hoshino_event.exp_mult_update")
            local max_health = _table.max_health
            local prefab = _table.prefab -- 暂时预留，给某些特殊经验爆表的怪。
            local exp = max_health/10
            if max_health >= 100 then
                inst.components.hoshino_com_level_sys:Exp_DoDelta(exp)
                if TUNING.HOSHINO_DEBUGGING_MODE then
                    print("获得经验",exp,prefab)
                end
            end
        end)
    ----------------------------------------------------------------------------------------------------------------------------------------------------------
    --- 砍树，制作，采集，挖矿，吃东西等
        -----------------------------------------------------------------------------------------
        --- 砍树、挖矿
            inst:ListenForEvent("finishedwork",function(inst,_table)
                inst:PushEvent("hoshino_event.exp_mult_update")
                local action = _table and _table.action
                if action == ACTIONS.CHOP or action == ACTIONS.MINE then
                    inst.components.hoshino_com_level_sys:Exp_DoDelta(1)
                end
            end)
        -----------------------------------------------------------------------------------------
        --- 采集
            inst:ListenForEvent("picksomething",function(inst,_table)
                inst:PushEvent("hoshino_event.exp_mult_update")
                inst.components.hoshino_com_level_sys:Exp_DoDelta(1)
            end)
        -----------------------------------------------------------------------------------------
        --- 吃东西
            inst:ListenForEvent("oneat",function(inst,_table)
                inst:PushEvent("hoshino_event.exp_mult_update")
                inst.components.hoshino_com_level_sys:Exp_DoDelta(1)
            end)
        -----------------------------------------------------------------------------------------
        --- 制作东西(消耗物品的才算数)
            local function check_recipe_can_create_exp(recipe) -- 消耗材料的配方才给经验
                local final_cost = 0
                for k,single_cmd in pairs(recipe.ingredients) do
                    local material = single_cmd and single_cmd.type
                    local cost = single_cmd and single_cmd.amount or 0
                    if material ~= nil then
                        final_cost = final_cost + cost
                    end
                end
                return final_cost > 0
            end
            local build_fn = function(inst,_table) --- 预留一些API ，可以实现建造指定的东西得到更多经验。
                local item = _table.item
                local recipe = _table.recipe or {}
                -- inst.components.hoshino_com_level_sys:Exp_DoDelta(1)
                -- print("build",item)
                -- for k,single_cmd in pairs(recipe.ingredients) do
                --     local material = single_cmd.type
                --     local cost = single_cmd.amount
                -- end
                if check_recipe_can_create_exp(recipe) then
                    inst:PushEvent("hoshino_event.exp_mult_update")
                    inst.components.hoshino_com_level_sys:Exp_DoDelta(1)
                end
            end
            inst:ListenForEvent("builditem",build_fn)
            inst:ListenForEvent("buildstructure",build_fn)
        -----------------------------------------------------------------------------------------

    ----------------------------------------------------------------------------------------------------------------------------------------------------------
end