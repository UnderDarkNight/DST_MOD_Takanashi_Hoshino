----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    多态攻击动作

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local attack_bamboo_cane_change = function(self)    ----- 修改 wilson 和 wilson_client 的动作返回捕捉
    local old_ATTACK = self.actionhandlers[ACTIONS.ATTACK].deststate
    self.actionhandlers[ACTIONS.ATTACK].deststate = function(inst,action,...)
        local weapon = inst.replica.combat:GetWeapon()
        local riding = inst.replica.rider and inst.replica.rider:IsRiding() or false
        if weapon and weapon:HasTag("hoshino_tag.polymorphic_attack_action") and riding == false then
            local switched_sg = weapon.replica.hoshino_com_polymorphic_attack_action:GetTypeSG()
            -- print("info switched_sg: ",switched_sg)
            if switched_sg then
                return switched_sg
            end
        end
        return old_ATTACK(inst, action,...)
    end
end
AddStategraphPostInit("wilson", attack_bamboo_cane_change)  ----------- 加给 主机 （成功）
AddStategraphPostInit("wilson_client", attack_bamboo_cane_change)    -------- 注意 inst.replica 检测，用于客机

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function DoThrust(inst, nosound)
        local weapon = inst.components.combat:GetWeapon()
        if weapon then            
            inst.components.combat:DoAttack(inst.sg.statemem.target, inst.components.combat:GetWeapon(), nil, nil, 0.66)
            if not nosound then
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
            end
        end
    end
    local function ToggleOffPhysics(inst)
        inst.sg.statemem.isphysicstoggle = true
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.GROUND)
    end

    local function ToggleOnPhysics(inst)
        inst.sg.statemem.isphysicstoggle = nil
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:CollidesWith(COLLISION.OBSTACLES)
        inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
        inst.Physics:CollidesWith(COLLISION.CHARACTERS)
        inst.Physics:CollidesWith(COLLISION.GIANTS)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--连刺
AddStategraphState("wilson", 
 State{
		name = "hoshino_com_polymorphic_attack_action_multithrust",
        tags = { "attack", "notalking", "abouttoattack", "autopredict", "nointerrupt","lianci" },
		onenter = function(inst)
			local target = nil 
			inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("multithrust")
            inst.Transform:SetEightFaced()
			
			if inst.bufferedaction ~= nil and inst.bufferedaction.target ~= nil and inst.bufferedaction.target:IsValid() then
                inst.sg.statemem.target = inst.bufferedaction.target
                inst.components.combat:SetTarget(inst.sg.statemem.target)
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
				target = inst.sg.statemem.target
            end

            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end

            local weapon = inst.components.combat:GetWeapon()
            if weapon ~= nil then
                weapon:PushEvent("enter_multithrust")
            end

            inst.sg:SetTimeout(20 * FRAMES)
		end,
		timeline =
		{
			TimeEvent(7 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
				inst:PerformBufferedAction()
            end),
            TimeEvent(9 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
				-- if inst.components.combat.target then 
				-- 	inst.components.combat:DoAreaAttack(inst.components.combat.target,1.5, 
				-- 		inst.components.combat:GetWeapon(), nil, nil, { "INLIMBO" ,"companion"})
				-- end 
            end),
            -- TimeEvent(10 * FRAMES, function(inst)
			-- 	inst.sg.statemem.weapon = inst.components.combat:GetWeapon()
			-- 	inst.components.combat:DoAttack(inst.components.combat.target,inst.sg.statemem.weapon,nil,nil,0.66)
            -- end),
            TimeEvent(11 * FRAMES, function(inst)
				inst.sg.statemem.weapon = inst.components.combat:GetWeapon()
                inst:PerformBufferedAction()
                DoThrust(inst)
            end),
            TimeEvent(13 * FRAMES, DoThrust),
            TimeEvent(15 * FRAMES, DoThrust),
            TimeEvent(17 * FRAMES, function(inst)
                DoThrust(inst, true)
            end),
            TimeEvent(19 * FRAMES, function(inst)
                DoThrust(inst, true)
            end),
		},

    ontimeout = function(inst)
        inst.sg:GoToState("idle", true)
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.components.combat:SetTarget(nil)
        inst.Transform:SetFourFaced()

        local weapon = inst.components.combat:GetWeapon()
        if weapon ~= nil then
            weapon:PushEvent("exit_multithrust")
        end
    end,
		
}
)


--跳劈

AddStategraphState("wilson", 
 State{
		name = "hoshino_com_polymorphic_attack_action_hop",
        tags = { "attack", "notalking", "abouttoattack", "autopredict","nointerrupt","tiaopi"},
		onenter = function(inst,nohopattack)
			local target = nil 
			inst.sg.statemem.nohopattack = nohopattack
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("atk_leap")
            inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
			
			if inst.bufferedaction ~= nil and inst.bufferedaction.target ~= nil and inst.bufferedaction.target:IsValid() then
                inst.sg.statemem.target = inst.bufferedaction.target
                inst.components.combat:SetTarget(inst.sg.statemem.target)
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
				target = inst.sg.statemem.target
            end

            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
				inst.sg.statemem.targetpos = target:GetPosition()
            end
            inst.sg:SetTimeout(20 * FRAMES)
		end,
		
		onupdate = function(inst)
            if inst.sg.statemem.flash and inst.sg.statemem.flash > 0 then
                inst.sg.statemem.flash = math.max(0, inst.sg.statemem.flash - .1)
                local c = math.min(1, inst.sg.statemem.flash)
                -- inst.components.colouradder:PushColour("leap", 0,c,c, 0)
            end
        end,
		
		timeline =
		{
			TimeEvent(4 * FRAMES, function(inst)
                if inst.sg.statemem.targetfx ~= nil and inst.sg.statemem.targetfx:IsValid() then
                    (inst.sg.statemem.targetfx.KillFX or inst.sg.statemem.targetfx.Remove)(inst.sg.statemem.targetfx)
                    inst.sg.statemem.targetfx = nil
                end
            end),
            TimeEvent(9 * FRAMES, function(inst)
                --rgb(250,209,100)
                -- inst.sg.statemem.fx_random = math.random() < 0.66
                inst.sg.statemem.add_color = {0/255, 0/255, 0/255}
                local weapon = inst.components.combat:GetWeapon()
                    if  weapon:HasTag("mcw_es_skill_fire") then --火焰
                        inst.sg.statemem.add_color = {250/255, 156/255, 25/255}
                    elseif weapon:HasTag("mcw_es_skill_ice") then
                        inst.sg.statemem.add_color = {0, 88/255, 189/255}
                    elseif weapon:HasTag("mcw_es_skill_wind") then
                        inst.sg.statemem.add_color = {0, 24/255, 34/255}
                    end
                local r,g,b = unpack(inst.sg.statemem.add_color)
                inst.components.colouradder:PushColour("leap", r,g,b, 0)
            end),
            TimeEvent(11 * FRAMES, function(inst)
                -- inst.components.colouradder:PushColour("leap", 1, 0.5, 0., 0)
            end),
            TimeEvent(12 * FRAMES, function(inst)
                -- inst.components.colouradder:PushColour("leap", 1, 0.6, 0, 0)
                ToggleOnPhysics(inst)
                inst.Physics:Stop()
                inst.Physics:SetMotorVel(0, 0, 0)
				inst.sg.statemem.flash = 1.3
                inst.sg:AddStateTag("busy")
                if not inst.sg.statemem.nohopattack then 
					inst:PerformBufferedAction()
                    ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .015, .8, inst, 20)
                    inst.components.bloomer:PushBloom("leap", "shaders/anim.ksh", -2)
                    --inst.sg:RemoveStateTag("nointerrupt")
                    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_smoke",nil,nil,true)
					if  inst.components.combat.target then
                        local weapon = inst.components.combat:GetWeapon()
                        local target = inst.components.combat.target
						inst.components.combat:DoAreaAttack(target,1.5,weapon, nil, nil, { "INLIMBO","companion","wall" })
                        inst.components.combat:DoAttack(target, weapon, nil, nil, 0.66)
                        if  weapon and (weapon.prefab == "mcw_elementspear" or weapon.prefab == "mcw_elementsword") then
                            weapon:SpawnFx(inst,target)
                        end
					end
				end
            end),
            -- TimeEvent(20 * FRAMES, function(inst)
            --     inst.sg:RemoveStateTag("busy")
                
            -- end),

            TimeEvent(19 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.components.bloomer:PopBloom("leap")
                
            end),
		},

    ontimeout = function(inst)
        inst.sg:GoToState("idle", true)
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
		inst.sg.statemem.nohopattack = nil 
        inst.components.combat:SetTarget(nil)
		if inst.sg.statemem.isphysicstoggle then
            ToggleOnPhysics(inst)
            inst.Physics:Stop()
            inst.Physics:SetMotorVel(0, 0, 0)
        end
        inst.components.bloomer:PopBloom("leap")
        inst.components.colouradder:PopColour("leap")
        if inst.sg.statemem.targetfx ~= nil and inst.sg.statemem.targetfx:IsValid() then
            (inst.sg.statemem.targetfx.KillFX or inst.sg.statemem.targetfx.Remove)(inst.sg.statemem.targetfx)
        end
    end,
		
}
)



--划

AddStategraphState("wilson", 
 State{
		name = "hoshino_com_polymorphic_attack_action_lunge",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" ,"nointerrupt"},
		onenter = function(inst,data)
			local target = nil  
			inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("lunge_pst")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon",nil,nil,true)
			
			
			if inst.bufferedaction ~= nil and inst.bufferedaction.target ~= nil and inst.bufferedaction.target:IsValid() then
                inst.sg.statemem.target = inst.bufferedaction.target
                inst.components.combat:SetTarget(inst.sg.statemem.target)
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
				target = inst.sg.statemem.target
            end
			if data and data.target then 
				target = data.target
			end 
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
				inst.components.combat:SetTarget(target)
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
			
			inst.SoundEmitter:PlaySound("dontstarve/common/lava_arena/fireball",nil,nil,true)
			inst.components.bloomer:PushBloom("lunge", "shaders/anim.ksh", -2)
            --inst.components.colouradder:PushColour("lunge", 1, 1, 0.2, 0)
            inst.components.colouradder:PushColour("lunge", 0, 88/255, 189/255, 0) --蓝色
			inst.sg.statemem.flash = 0.8
            inst.sg:SetTimeout(8 * FRAMES)

		end,
		
		onupdate = function(inst)
            if inst.sg.statemem.flash and inst.sg.statemem.flash > 0 then
                inst.sg.statemem.flash = math.max(0, inst.sg.statemem.flash - .1)
                --inst.components.colouradder:PushColour("lunge", inst.sg.statemem.flash, inst.sg.statemem.flash,0, 0)
                inst.components.colouradder:PushColour("lunge", 0, 88/255, 189/255, inst.sg.statemem.flash) -- 修改颜色滤镜的透明度
            end
        end,
		
		timeline =
		{
			TimeEvent(2 * FRAMES, function(inst)
				
                inst:PerformBufferedAction()
				
				if inst.components.combat.target then 
					inst.components.combat:DoAreaAttack(inst.components.combat.target,1.5, 
						inst.components.combat:GetWeapon(), nil, nil, { "INLIMBO","companion" })
				end 
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            end),
			
			TimeEvent(7 * FRAMES, function(inst)
                inst.components.bloomer:PopBloom("lunge")
            end),
		},

    ontimeout = function(inst)
        inst.sg:GoToState("idle", true)
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
        
    },

    onexit = function(inst)
        inst.components.combat:SetTarget(nil)
		inst.components.bloomer:PopBloom("lunge")
        inst.components.colouradder:PopColour("lunge")
    end,
		
}
)
----------客机部分---------
--前刺

AddStategraphState("wilson_client", 
 State{
		name = "hoshino_com_polymorphic_attack_action_multithrust",
        tags = { "attack", "notalking", "abouttoattack", "autopredict","lianci" },
		onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
			local target = buffaction ~= nil and buffaction.target or nil
			if inst.replica.combat ~= nil then
				inst.replica.combat:StartAttack()
			end
			inst.components.locomotor:Stop()
			inst.Transform:SetEightFaced()
			if target ~= nil then
				inst.AnimState:PlayAnimation("multithrust")
				if buffaction ~= nil then
					inst:PerformPreviewBufferedAction()
					if buffaction.target ~= nil and buffaction.target:IsValid() then
						inst:FacePoint(buffaction.target:GetPosition())
						inst.sg.statemem.attacktarget = buffaction.target
					end
				end
				inst.sg:SetTimeout(20 * FRAMES)
			end 
		end,
		timeline =
		{
			TimeEvent(7 * FRAMES, function(inst)
				inst:ClearBufferedAction()
				 inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
            end),
            TimeEvent(9 * FRAMES, function(inst)
				inst:ClearBufferedAction()
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
            end),
            TimeEvent(11 * FRAMES, function(inst)
                inst:ClearBufferedAction()
				inst.sg:RemoveStateTag("abouttoattack")
            end),
            TimeEvent(19 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("nointerrupt")
            end),
		},

    ontimeout = function(inst)
		inst.sg:RemoveStateTag("abouttoattack")
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        inst.sg:GoToState("idle", true)
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.Transform:SetFourFaced()
		if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
            inst.replica.combat:CancelAttack()
        end
    end,
		
}
)

--跳劈

AddStategraphState("wilson_client", 
 State{
		name = "hoshino_com_polymorphic_attack_action_hop",
        tags = { "attack", "notalking", "abouttoattack", "autopredict","tiaopi"},
		onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
		local target = buffaction ~= nil and buffaction.target or nil
        if inst.replica.combat ~= nil then
            inst.replica.combat:StartAttack()
        end
        inst.components.locomotor:Stop()
        
		if target ~= nil then
			inst.AnimState:PlayAnimation("atk_leap")
            inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
			
			if buffaction ~= nil then
				inst:PerformPreviewBufferedAction()
				if buffaction.target ~= nil and buffaction.target:IsValid() then
					inst:FacePoint(buffaction.target:GetPosition())
					inst.sg.statemem.attacktarget = buffaction.target
				end
			end
			inst.sg:SetTimeout(20 * FRAMES)
		end 
			

            
		end,
		timeline =
		{
			TimeEvent(10 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/destroy_smoke",nil,nil,true)
            end),
			
			TimeEvent(12 * FRAMES, function(inst)
                inst:ClearBufferedAction()
				inst.sg:RemoveStateTag("abouttoattack")
            end),
		},

    ontimeout = function(inst)
		inst.sg:RemoveStateTag("abouttoattack")
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        inst.sg:GoToState("idle", true)
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

	onexit = function(inst)
        if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
            inst.replica.combat:CancelAttack()
        end
    end,
}
)

--划

AddStategraphState("wilson_client", 
 State{
		name ="hoshino_com_polymorphic_attack_action_lunge",
        tags = { "attack", "notalking", "abouttoattack", "autopredict","nointerrupt" },
		onenter = function(inst,data)
        local buffaction = inst:GetBufferedAction()
		local target = (buffaction ~= nil and buffaction.target) or (data and data.target) or nil 
        if inst.replica.combat ~= nil then
            inst.replica.combat:StartAttack()
        end
        inst.components.locomotor:Stop()
        
		if target ~= nil then
			inst:ForceFacePoint(target:GetPosition():Get())
			inst.AnimState:PlayAnimation("lunge_pst")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon",nil,nil,true)
			inst.SoundEmitter:PlaySound("dontstarve/common/lava_arena/fireball",nil,nil,true)
			if buffaction ~= nil then
				inst:PerformPreviewBufferedAction()
				if buffaction.target ~= nil and buffaction.target:IsValid() then
					inst.sg.statemem.attacktarget = buffaction.target
				end
			end
			inst.sg:SetTimeout(8 * FRAMES)
		end 

		end,
		timeline =
		{
			TimeEvent(2 * FRAMES, function(inst)
                inst:ClearBufferedAction()
				inst.sg:RemoveStateTag("abouttoattack")
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            end),
		},

    ontimeout = function(inst)
		inst.sg:RemoveStateTag("abouttoattack")
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        inst.sg:GoToState("idle", true)
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

	onexit = function(inst)
        if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
            inst.replica.combat:CancelAttack()
        end
    end,
}
)

