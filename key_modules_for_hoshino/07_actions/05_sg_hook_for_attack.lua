


local function check_weapon_can_shoot(weapon)
    if TheWorld.ismastersim then
        if weapon.components.finiteuses and weapon.components.finiteuses:GetPercent() > 0 then
            return true
        else            
            return false
        end
    else
        local value = weapon.replica.inventoryitem.classified and weapon.replica.inventoryitem.classified.percentused:value() or 0
        return value > 0
    end    
end

local attack_bamboo_cane_change = function(self)    ----- 修改 wilson 和 wilson_client 的动作返回捕捉
    local old_ATTACK = self.actionhandlers[ACTIONS.ATTACK].deststate
    self.actionhandlers[ACTIONS.ATTACK].deststate = function(inst,action)
        if inst:HasTag("hoshino") then
            local weapon = inst.replica.combat:GetWeapon()
            if weapon and weapon:HasTag("hoshino_weapon_gun_eye_of_horus") and check_weapon_can_shoot(weapon) then
                return "hoshino_sg_action_gun_shoot"
            end
        end
        return old_ATTACK(inst, action)
    end
end
AddStategraphPostInit("wilson", attack_bamboo_cane_change)  ----------- 加给 主机 （成功）
AddStategraphPostInit("wilson_client", attack_bamboo_cane_change)    -------- 注意 inst.replica 检测，用于客机

