----------------------------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local ATTACK_RANGE = 16
    local PROJ_SPEED = 20
    local SHADOW_PROJ_SPEED = 20*1.5
    local HIT_RADIUS = 1.5
    local HIT_RADIUS_SQ = HIT_RADIUS * HIT_RADIUS
    local SHADOW_SEARCH_RADIUS = ATTACK_RANGE*1.5

    local must_have_tags = {"_combat"}
    local cant_have_tags = {"player","companion","INLIMBO", "wall", "notarget","flight", "invisible", "noattack", "hiding"}
    local must_have_one_of_tags = nil
----------------------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function target_can_be_attack(target,weapon,doer)
        if target and target:IsValid() and target.components.combat
            and target.components.health and not target.components.health:IsDead() then

            return true
        end
        return false
    end
    local function do_damage_to_target(target,weapon,doer,damage)
        target.components.combat:GetAttacked(doer,damage or weapon:GetDamage(),weapon)
        weapon:RememberAttackedMonster(target.prefab)
    end
    local function Proj_Do_Damage(inst)
        local weapon = inst.weapon
        local owner = inst.owner

        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, 0, z, HIT_RADIUS, must_have_tags, cant_have_tags, must_have_one_of_tags)
        local ret_target = {}
        for k,temp_monster in pairs(ents) do
            if target_can_be_attack(temp_monster,weapon,owner) and not inst.hit_targets[temp_monster] then
                table.insert(ret_target,temp_monster)
            end
        end
        for k,v in pairs(ret_target) do
            do_damage_to_target(v,weapon,owner, weapon:GetDamage() * 4)
            inst.hit_targets[v] = true
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function Search_Nearest_Target(x,y,z,weapon,doer)
        local ents = TheSim:FindEntities(x, y, z, SHADOW_SEARCH_RADIUS, must_have_tags, cant_have_tags, must_have_one_of_tags)
        local ret_target = ents[1]
        local ret_target_dist_sq = math.huge
        for k,temp_monster in pairs(ents) do
            if target_can_be_attack(temp_monster,weapon,doer) then
                local temp_dis_sq = temp_monster:GetDistanceSqToPoint(x,y,z)
                if temp_dis_sq < ret_target_dist_sq then
                    ret_target = temp_monster
                    ret_target_dist_sq = temp_dis_sq
                end
            end
        end
        return ret_target
    end
    local function CreateShadow(parent)
        local x,y,z = parent.Transform:GetWorldPosition()
        local weapon = parent.weapon
        local owner = parent.owner

        local proj = SpawnPrefab("hoshino_projectile_nanotech_black_reaper_shadow")
        proj.Ready = true
        proj.owner = owner
        proj.weapon = weapon
        proj.components.projectile:SetSpeed(SHADOW_PROJ_SPEED)
        proj.Transform:SetPosition(x,0,z)
        proj:DoTaskInTime(1,function()
            proj._find_target_task = proj:DoPeriodicTask(0.1,function()
                local target = Search_Nearest_Target(x,0,z,weapon,owner)
                if target and target:IsValid() then
                    proj.target = target
                    proj._find_target_task:Cancel()
                    proj:PushEvent("find_target",target)
                end
            end)
        end)
        proj:DoTaskInTime(30,proj.Remove)
        proj:ListenForEvent("entitysleep",proj.Remove)

        proj.hit_cd_checker = nil
        proj:ListenForEvent("find_target",function(_,target)
            proj:DoPeriodicTask(FRAMES,function()
                if target_can_be_attack(target,weapon,owner) then
                    proj.components.projectile:Throw(proj,target,owner)
                else
                    proj:Remove()
                end
            end)
            proj.components.projectile:SetOnHitFn(function()
                if proj.hit_cd_checker == nil then
                    do_damage_to_target(target,weapon,owner,weapon:GetDamage()/2)
                    proj.hit_cd_checker = proj:DoTaskInTime(0.3,function()
                        proj.hit_cd_checker = nil
                    end)
                end
                if proj.__remove_task == nil then
                    proj.__remove_task = proj:DoTaskInTime(2,proj.Remove)
                end
            end)
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------



return function(inst,doer,_target,_pt)
    -------------------------------------------------------------
    --- 获取目标坐标
        local pt = nil
        if _target and _target:IsValid() then
            pt = Vector3(_target.Transform:GetWorldPosition())
            pt.y = 0
        elseif _pt and _pt.x then
            pt = Vector3(_pt.x,0,_pt.z)
        end
        if pt == nil then
            return
        end
        local player_pt = Vector3(doer.Transform:GetWorldPosition())
        player_pt.y = 0
    -------------------------------------------------------------
    --- 归一化后把目标坐标 延申到最远距离
        local dir = (pt - player_pt):GetNormalized()
        local ret_pt = pt + dir * (ATTACK_RANGE+2) -- 2 是为了防止子弹卡在玩家身上
    -- SpawnPrefab("log").Transform:SetPosition(ret_pt.x,0,ret_pt.z)
    -------------------------------------------------------------
    --- 得到最终目标坐标 ret_pt
    -------------------------------------------------------------
    --- 创建mark
        local mark = SpawnPrefab("hoshino_weapon_nanotech_black_reaper_mark")
        mark.Transform:SetPosition(ret_pt.x,0,ret_pt.z)
        mark.Ready = true
        mark:ListenForEvent("entitysleep",mark.Remove)
    -------------------------------------------------------------
    --- 创建弹药
        local proj = SpawnPrefab("hoshino_projectile_nanotech_black_reaper_shadow")
        proj.Ready = true
        proj.owner = doer
        proj.weapon = inst
        proj.components.projectile:SetSpeed(PROJ_SPEED)
        proj.Transform:SetPosition(player_pt.x,0,player_pt.z)
        proj.components.projectile:Throw(proj,mark,doer)        
        proj.hit_targets = {} -- 用来记录被攻击过的目标
        proj.components.projectile:SetOnHitFn(function()
            --- 打中mark 后返回去 打玩家，然后 消失
            proj.hit_targets = {} -- 用来记录被攻击过的目标
            mark:Remove()
            proj:DoPeriodicTask(FRAMES*5,function()
                proj.components.projectile:Throw(proj,doer,doer)                
            end)
            proj.components.projectile:SetOnHitFn(function()
                proj:Remove()
            end)
        end)
        proj:DoPeriodicTask(FRAMES,Proj_Do_Damage)
        proj:ListenForEvent("entitysleep",proj.Remove)
    -------------------------------------------------------------
    --- 创建虚影
        proj:DoPeriodicTask(0.1,CreateShadow)
    -------------------------------------------------------------


end