---------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

        专属枪械的 独特技能攻击 。


]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------
----


    local function Push_DMG_Blocker_Start_Event(inst)   --- 启动伤害屏蔽器
        inst:PushEvent("hoshino_sg_action_gun_shoot_with_walking_dmg_blocker_start")
    end
    local function Push_DMG_Blocker_End_Event(inst) --- 关闭伤害屏蔽器
        inst:PushEvent("hoshino_sg_action_gun_shoot_with_walking_dmg_blocker_end")
    end
    local function CommonEquip()
        return EventHandler("equip", function(inst)
            inst.sg:GoToState("idle")
            Push_DMG_Blocker_End_Event(inst)
        end) 
    end
    local function CommonUnequip()
        return EventHandler("unequip", function(inst)
            inst.sg:GoToState("idle")
            Push_DMG_Blocker_End_Event(inst)
        end)
    end

        
    local function Shoot(inst,num)
        -- inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/explode")
        -- local fx = SpawnPrefab("balloon_pop_head")
        local rot = inst.Transform:GetRotation()* DEGREES
        local pos = inst:GetPosition() + Vector3(math.cos(rot), -0.5, -math.sin(rot))* 4
        -- fx.Transform:SetPosition(pos:Get())
        inst:PushEvent("hoshino_sg_action_gun_shoot_active_spell",{pt = pos,num = num})
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------
--- server side
    AddStategraphState("wilson", State{
        name = "hoshino_gun_ex_skill_pre",
        tags = {"notalking", "abouttoattack", "busy"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            local action = inst:GetBufferedAction()
            local weapon = inst.components.combat:GetWeapon()
            local point = action:GetActionPoint()
            -- print("hoshino_gun_ex_skill_pre",point)
            if not (weapon and weapon:HasTag("hoshino_weapon_gun_eye_of_horus")) then
                inst.sg:RemoveStateTag("abouttoattack")
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("notalking")
                inst.sg:AddStateTag("idle")
                if action ~= nil then
                    inst:PerformBufferedAction()
                else
                    inst.sg:GoToState("idle")
                end
                return
            end
            inst.sg.statemem.weapon = weapon
            inst.AnimState:PlayAnimation("hoshino_ex_pre")
            Push_DMG_Blocker_Start_Event(inst)
        end,

        events = 
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("hoshino_gun_ex_skill")
            end),
            CommonEquip(),
            CommonUnequip(),
        },    

        onexit = function(inst)
            
        end,
    })

    AddStategraphState("wilson", State{
        name = "hoshino_gun_ex_skill",
        tags = {"notalking", "attack", "busy"},

        onenter = function(inst)
            inst.components.locomotor:Stop()

            local weapon = inst.components.combat:GetWeapon()
            local action = inst:GetBufferedAction()
            local point = action:GetActionPoint() -- nil?

            inst.sg.statemem.point = point
            inst.AnimState:PlayAnimation("hoshino_ex_walk_loop", true)
            inst.Physics:SetMotorVel(1, 0, 0)
            -- inst.sg:AddStateTag("busy")
        end,

        timeline = {
            TimeEvent(20*FRAMES, function(inst)
                Shoot(inst,1)
            end),
            TimeEvent(40*FRAMES, function(inst)
                Shoot(inst,2)
            end),
            TimeEvent(55*FRAMES, function(inst)
                Shoot(inst,3)
            end),
            TimeEvent(70*FRAMES, function(inst)
                Shoot(inst,4)
            end),
            TimeEvent(72*FRAMES, function(inst)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("hoshino_ex_loop")
                -- inst.AnimState:Pause()
            end),
            TimeEvent(90*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("summerevent2022/carnivalgame_puckdrop/hit_bumper")
            end),
            TimeEvent(120*FRAMES, function(inst)
                Shoot(inst,5)
            end),
            TimeEvent(130*FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.AnimState:Resume()
                inst.sg:GoToState("idle")
            end),
        },

        onupdate = function(inst)
            
        end,

        events = {
            CommonEquip(),
            CommonUnequip(),
        },

        onexit = function(inst)
            inst.AnimState:Resume()
            Push_DMG_Blocker_End_Event(inst)
        end,
    })

---------------------------------------------------------------------------------------------------------------------------------------------------------
--- client side
    AddStategraphState('wilson_client', State{
        name = "hoshino_gun_ex_skill_pre",
        tags = {"notalking", "abouttoattack", "busy"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            local action = inst:GetBufferedAction()
            local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

            if action ~= nil then
                inst:PerformPreviewBufferedAction()
            end

            inst.sg.statemem.weapon = weapon

            if not (weapon and weapon:HasTag("hoshino_weapon_gun_eye_of_horus")) then
                inst.sg:RemoveStateTag("abouttoattack")
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("notalking")
                inst.sg:AddStateTag("idle")
                inst.sg:GoToState("idle")
                return
            end

            inst.sg:SetTimeout(2)
        end,

        onupdate = function(inst)
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            elseif inst.bufferedaction == nil then
                inst.sg:GoToState("idle")
            end
        end,
        onexit = function(inst)

        end,
    })
---------------------------------------------------------------------------------------------------------------------------------------------------------