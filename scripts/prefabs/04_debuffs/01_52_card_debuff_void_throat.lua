------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【彩】【虚空之喉】每当玩家进行一次攻击动作，获得一个围绕在玩家周围（半径为4.5-5.5）的，持续3s的黑圈，

触碰到黑圈的敌人每0.05s受到15真实伤害（受攻击倍率影响，无伤害来源），

且被黑圈杀死的敌人有3%的概率给予玩家一层【爆炸护盾】【重复选择伤害和概率叠加，概率最高不超过100%】

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local SEARCH_RADIUS = 4.5               -- 检测范围
    local REMAIN_TIME = 3                   -- 持续时间
    local DAMAGE_UPDATE_TIME = 0.05         -- 伤害更新时间
    local DAMAGE_PER_LEVEL = 15             -- 每级伤害
    local SHIELD_PERCENT_PER_LEVEL = 0.03   --- 每级护盾概率
    local BOUNCE_MUST_TAGS = { "_combat" }
    local BOUNCE_NO_TAGS = { "INLIMBO", "wall", "notarget", "player", "companion", "flight", "invisible", "noattack", "hiding" }
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function StartFxTask(inst,player)
        if inst.fx_task then
            inst.timer = REMAIN_TIME
            return
        end
        inst.timer = REMAIN_TIME
        local fx = player:SpawnChild("hoshino_sfx_dotted_circle")
        fx:PushEvent("Set",{
            pt = Vector3(0,0,0),
            radius = SEARCH_RADIUS,
            color = Vector3(50/255,50/255,50/255),
        })
        local tested_monsters = {}
        inst.fx_task = inst:DoPeriodicTask(DAMAGE_UPDATE_TIME,function()
            ----------------------------------------------------------------------------------------------------------
            --- 计时器
                inst.timer = inst.timer - DAMAGE_UPDATE_TIME
                if inst.timer <= 0 then
                    inst.fx_task:Cancel()
                    inst.fx_task = nil
                    fx:Remove()
                end
            ----------------------------------------------------------------------------------------------------------
            --- 造成伤害
                local level = inst.components.hoshino_data:Get("level") or 1
                local damage = DAMAGE_PER_LEVEL * level
                local x,y,z = player.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x,0,z,SEARCH_RADIUS,BOUNCE_MUST_TAGS,BOUNCE_NO_TAGS)
                for k, temp_monster in pairs(ents) do
                    if temp_monster and temp_monster:IsValid() and temp_monster.components.health and not temp_monster.components.health:IsDead() then
                        local current_health = temp_monster.components.health.currenthealth
                        player.components.hoshino_com_real_damage:DoRealDamage(temp_monster,damage)
                        local new_health_value = temp_monster.components.health.currenthealth
                            if current_health > 0 and new_health_value <= 0 and tested_monsters[temp_monster] == nil then
                                tested_monsters[temp_monster] = true
                                if math.random() <= SHIELD_PERCENT_PER_LEVEL * level then
                                    player:AddDebuff("hoshino_debuff_bomb_shield","hoshino_debuff_bomb_shield")
                                end
                            end 
                    end
                end
            ----------------------------------------------------------------------------------------------------------
        end)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player        
        -----------------------------------------------------
        --- 初始化level
            if inst.components.hoshino_data:Get("level") == nil then
                inst.components.hoshino_data:Set("level",1)
            end
        -----------------------------------------------------
        --- 打到 带脑子的生物才算数。
            inst:ListenForEvent("onhitother",function(_,_table)
                local target = _table and _table.target
                if target and target.sg and target.brainfn then
                    StartFxTask(inst,player)
                end
            end,player)
        -----------------------------------------------------
        --- 给玩家挂特效
            local fx = SpawnPrefab("hoshino_fx_mawofthevoid")
            fx:PushEvent("Set",{target = player,scale = 3})
            inst:ListenForEvent("onremove",function()
                fx:Remove()
            end)
        -----------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function ExtendDebuff(inst)
        inst.components.hoshino_data:Add("level",1)
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

return Prefab("hoshino_card_debuff_void_throat", fn)
