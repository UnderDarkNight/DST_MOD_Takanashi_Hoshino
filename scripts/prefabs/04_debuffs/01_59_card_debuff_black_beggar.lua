------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    【金】【黑暗乞丐】选择后生成一个跟随玩家的黑暗乞丐【选择之后移出卡池】
    黑暗乞丐效果：玩家可以给它喂食，当给予食物的生命回复量达到100时，随机获得以下效果
    10%生成一只攻击为2倍的穴居悬蛛
    10%生成一只攻击为2倍的友好穴居悬蛛
    20%的概率增加一层爆炸护盾
    10%的概率移除一个诅咒
    40%的概率治疗玩家25%生命值
    10%的概率治疗玩家25%黑血（如果没有黑血则重新roll一次效果）

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
--- 开始roll 点
    local function start_reward_fn(inst,player)
        local percent = math.random(1000)/1000
        if percent <= 0.2 then
            --- 随机蜘蛛
            local spider_list = {"spider_dropper"}
            local ret_spider = spider_list[math.random(1,#spider_list)]
            local monster = SpawnPrefab(ret_spider)
            local x,y,z = player.Transform:GetWorldPosition()
            monster.Transform:SetPosition(x+math.random(-20,20)/10,0,z+math.random(-20,20)/10)
            if math.random() < 0.5 then
                player:PushEvent("makefriend")
                player.components.leader:AddFollower(monster)
            else
                monster.components.combat:SuggestTarget(player)
            end
            SpawnPrefab("crab_king_shine").Transform:SetPosition(monster.Transform:GetWorldPosition())
            monster:AddDebuff(inst.prefab,inst.prefab)
            print("【黑暗乞丐】 蜘蛛")
        elseif percent <= 0.4 then
            --- 增加爆炸护盾
            player:AddDebuff("hoshino_debuff_bomb_shield","hoshino_debuff_bomb_shield")
            print("【黑暗乞丐】 爆炸护盾")
        elseif percent <= 0.5 then
            --- 移除诅咒
            local actived_black_cards_data = player.components.hoshino_cards_sys:GetActivatedCards("card_black") or {}
            local actived_cards = {}
            for card_name, actived_num in pairs(actived_black_cards_data) do
                if actived_num > 0 then
                    table.insert(actived_cards,card_name)
                end
            end
            if #actived_cards == 0 then
                print("【黑暗乞丐】 移除卡牌：没有可移除的诅咒卡牌")
                player.components.talker:Say("没有可移除的诅咒卡牌")
                return
            end
            local ret_remove_card_name = actived_cards[math.random(1,#actived_cards)]
            player.components.hoshino_cards_sys:TryToDeactiveCardByName(ret_remove_card_name)
            print("【黑暗乞丐】 移除卡牌：",ret_remove_card_name)
        elseif percent <= 0.9 then
            --- 治疗玩家25%生命值
            if player.components.health:GetPercent() == 1 then
                inst:PushEvent("start_reward_full",player)
                print("【黑暗乞丐】 满血重新ROLL")
            else
                local max_health = player.components.health.maxhealth
                player.components.health:DoDelta(max_health*0.25)
                print("【黑暗乞丐】 恢复血量")
            end
        else
            --- 10%的概率治疗玩家25%黑血（如果没有黑血则重新roll一次效果）
            if player.components.health.penalty > 0 then
                player.components.health:DeltaPenalty(-0.25)
            else
                print("【黑暗乞丐】 重新ROLL")
                inst:PushEvent("start_reward_full",player)                
            end
        end
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 创建随从
   local function SpawnBeggar(inst,player)
        ---------------------------------------------------
        --- 创建实体
            local beggar = SpawnPrefab("hoshino_spell_black_beggar")
            beggar:PushEvent("link",player)
            beggar:PushEvent("force_close_2_player")
            inst:DoTaskInTime(1,function()
                beggar:PushEvent("force_close_2_player")                
            end)
        ---------------------------------------------------
        ---- 初始化饥饿值
            beggar:SetHunger(inst.components.hoshino_data:Add("hunger",0))
            beggar.components.hoshino_com_acceptable:SetOnAcceptFn(function(beggar,item,doer)
                if item.components.edible == nil then
                    return false
                end
                if beggar:IsBusy() then
                    return false
                end
                local healthvalue = item.components.edible.healthvalue or 0
                if item.components.stackable then
                    item.components.stackable:Get():Remove()
                else
                    item:Remove()
                end
                beggar:SetBusy("eating")
                --- 基于动画控制器，动画播放完才执行动作。
                beggar:PlayAnimAndCallBack("on_eat",function()
                    healthvalue = math.max(0,healthvalue)
                    local ret_value = inst.components.hoshino_data:Add("hunger",healthvalue)
                    local reward_times = 0
                    while ret_value >= 100 do
                        -- inst:PushEvent("start_reward_full",player)
                        reward_times = reward_times + 1
                        ret_value = inst.components.hoshino_data:Add("hunger",-100)
                    end
                    beggar:SetHunger(ret_value)
                    beggar:RemoveBusy("eating")                    
                    if reward_times == 0 then
                        beggar:PlayAnimAndCallBack("idle")
                    else
                        beggar:SetBusy("giving_reward")
                        beggar:PlayAnimAndCallBack("give_reward",function()
                            beggar:RemoveBusy("giving_reward")
                            for i = 1, reward_times, 1 do
                                inst:PushEvent("start_reward_full",player)
                            end
                            beggar:PlayAnimAndCallBack("idle")
                        end)
                    end
                end)
                
                return true
            end)
        ---------------------------------------------------
        ---- 玩家离开
            beggar:ListenForEvent("player_despawn",function()
                inst.components.hoshino_data:Set("hunger",beggar:GetHunger())
            end,player)
        ---------------------------------------------------
        ---- 随机跑路
            beggar:ListenForEvent("OnHit",function(_,target)
                if target == player then
                    local points = TUNING.HOSHINO_FNS:GetSurroundPoints({
                        target = Vector3(0,0,0),
                        range = 5.5,
                        num = 8,
                    })
                    local pos = points[math.random(1,#points)]
                    inst.Transform:SetPosition(pos.x,0,pos.z)
                    beggar.components.projectile:Throw(beggar,inst,player)
                end
            end)
            beggar:ListenForEvent("start_following_player",function()
                inst.Transform:SetPosition(0,0,0)            
            end)
        ---------------------------------------------------
        --- 
            inst:ListenForEvent("onremove",function()
                beggar:Remove()
            end)
        ---------------------------------------------------
   end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 玩家专属
   local function OnAttached_for_player(inst,player)
        -----------------------------------------------------
        ---
            SpawnBeggar(inst,player)
            inst:ListenForEvent("start_reward_full",start_reward_fn)
        -----------------------------------------------------
   end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 怪物专属
    local function OnAttached_for_monster(inst,monster)
        if monster.components.combat then
            monster.components.combat.externaldamagemultipliers:SetModifier(inst,2)
        end
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0,0,0)
        inst.target = target        
        -----------------------------------------------------
        ---
            if target:HasTag("player") then
                OnAttached_for_player(inst,target)
            else
                OnAttached_for_monster(inst,target)
            end
        -----------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function ExtendDebuff(inst)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst:AddTag("CLASSIFIED")
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("hoshino_data")
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    inst.components.debuff:SetDetachedFn(inst.Remove)

    return inst
end

return Prefab("hoshino_card_debuff_black_beggar", fn)
