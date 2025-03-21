------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【诅咒】【霹雳大腿】你碰撞的所有建筑会被摧毁，移动速度-25%

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
   local ACTIVING_RADIUS = 1.8
   local one_of_tags = {"DIG_workable","HAMMER_workable","MINE_workable","CHOP_workable"}
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player        
        -----------------------------------------------------
        ---
            inst:DoPeriodicTask(0.2,function()
                local x,y,z = player.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x,0,z, ACTIVING_RADIUS,nil,nil,one_of_tags)
                for k,temp_target in pairs(ents) do
                    if temp_target and temp_target:IsValid() and temp_target.components.workable and temp_target.components.workable:CanBeWorked() then
                        SpawnPrefab("collapse_small").Transform:SetPosition(temp_target.Transform:GetWorldPosition())
                        temp_target.components.workable:Destroy(player)
                    end
                end
            end)
        -----------------------------------------------------
        ---
	        player.components.locomotor:SetExternalSpeedMultiplier(inst, "hoshino_card_debuff_thunder_thighs",1-0.25)            
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
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    inst.components.debuff:SetDetachedFn(inst.Remove)

    return inst
end

return Prefab("hoshino_card_debuff_thunder_thighs", fn)
