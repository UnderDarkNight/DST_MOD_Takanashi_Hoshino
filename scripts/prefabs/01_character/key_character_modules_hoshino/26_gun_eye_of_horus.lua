--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

武器攻击范围
    1级：30度，5距离范围
    2级：45度，7距离范围
    3级：60度，9距离范围

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    ----------------------------------------------------------------------------------------
    --- 等级切换。
        local function GetGunLevel()
            return 3
        end
    ----------------------------------------------------------------------------------------
    --- 攻击距离+攻击角度 动态返回 预留的接口
        local function Get_Attack_Angle()
            local level = GetGunLevel()
            if level == 1 then
                return 30
            elseif level == 2 then
                return 45
            elseif level == 3 then
                return 60
            end
            return 60
        end
        local function Get_Attack_Range()
            local level = GetGunLevel()
            if level == 1 then
                return 5
            elseif level == 2 then
                return 7
            elseif level == 3 then
                return 9
            end
            return 9
        end
    ----------------------------------------------------------------------------------------
    --- 伤害执行函数
        local function GetDMG()
            if GetGunLevel() < 3 then
                return 34/2
            end
            return 34
        end
        local function DoRealDamage(target,weapon,value) -- 真实伤害
            if target.components.health == nil then
                return
            end
            local damage, spdamage = inst.components.combat:CalcReflectedDamage(target, GetDMG(), weapon)
            ---- 其他伤害直接结算为真实伤害。
            spdamage = spdamage or {}
            for k, v in pairs(spdamage) do
                if type(v) == "number" then
                    damage = damage + v
                elseif type(k) == "number" then
                    damage = damage + k
                end                        
            end
            --- 直接扣血
            target.components.health:DoDelta(-damage)
        end
        local function SetWeaponParam(weapon) --- 配置攻击距离 和 伤害。
            weapon.components.weapon:SetDamage(GetDMG())
            weapon.components.weapon:SetRange(Get_Attack_Range())
        end
        local function DoGunDamage(target,weapon)            
            inst.components.combat:DoAttack(target,weapon)
            -- target.components.combat:GetAttacked(inst,GetDMG(),weapon)
            if GetGunLevel() >= 3 then --- 三级的伤害直接造成部分真实伤害。
                DoRealDamage(target,weapon,GetDMG())
            end
        end
        local function ResetWeaponParam(weapon) --- 重置攻击距离和伤害。
            weapon.components.weapon:SetRange(Get_Attack_Range())
            weapon.components.weapon:SetDamage(0)
            weapon.components.finiteuses:Use_Hoshino(1)
        end
    ----------------------------------------------------------------------------------------
    --- 检查是否在扇形攻击区域内
        local function Check_In_Area(target_pt, start_pt, mid_line_max_pt)
            -- 检查是否在扇形攻击区域内。start_pt: 起始点，mid_line_max_pt: 扇形中线最远点。target: 目标实体。
            local angle = Get_Attack_Angle()    -- 扇形角度. 单位：角度
            local range = Get_Attack_Range()    -- 扇形最远距离。
        
            -- 先判定距离
            local dst_sq = target_pt:DistSq(start_pt)
            if dst_sq > range * range then
                return false
            end
        
            -- 中线向量并归一化
            local mid_line_vec = (mid_line_max_pt - start_pt):GetNormalized()
        
            -- 目标向量并归一化
            local target_vec = (target_pt - start_pt):GetNormalized()
        
            -- 两个向量的点积
            local cos_theta = mid_line_vec:Dot(target_vec)
        
            -- 计算半角的余弦值
            local angle_in_radians = math.rad(angle / 2)
            local cos_half_angle = math.cos(angle_in_radians)
        
            -- 判断是否在扇形范围内
            if cos_theta < cos_half_angle then
                return false
            end
        
            return true
        end
    ----------------------------------------------------------------------------------------
    --- 扇形特效
        inst:ListenForEvent("eye_of_horus_shoot_fx",function(inst,_table)
            local target = _table and _table.target
            local pt = _table and _table.pt
            local doer = inst
            ------------------------------------------------------------------------------------
            --- 目标坐标。
                local x,y,z
                if target and target.Transform then
                    x,y,z = target.Transform:GetWorldPosition()
                end
                if pt then
                    x,y,z = pt.x,pt.y,pt.z
                end
                if not x or not y or not z then
                    return
                end                
            ------------------------------------------------------------------------------------
            --- 坐标和角度函数
                doer:ForceFacePoint(x, y, z)

                local start_pt = Vector3(doer.Transform:GetWorldPosition()) --- 起点坐标。
                ------------------------------------------------------------------------------
                --- 起点坐标归一化后偏移距离1
                    start_pt = start_pt + (Vector3(x,y,z) - start_pt):GetNormalized() * 1
                ------------------------------------------------------------------------------
                local delta_x,delata_y,delta_z = x-start_pt.x, 0 ,z-start_pt.z
                local angle = math.deg(math.atan2(delta_z, delta_x))
                -- local distance = 4

                local function get_offset_pt_by_angle(angle,distance)
                    return Vector3(math.cos(math.rad(angle))*distance,0,math.sin(math.rad(angle))*distance )                    
                end
            ------------------------------------------------------------------------------------
            ---- 扇形火焰特效。
                local delta_range = 1
                for i = 1, Get_Attack_Range(), 1 do
                    -- local color = Vector3(255,0,0)
                    local color = Vector3(90/255, 66/255, 41/255)
                    local scale = ((0.5/3)*i+0.5)*0.5
                    local MultColour_Flag = true
                    -- inst:DoTaskInTime((i-1)*0.05/2,function()
                    inst:DoTaskInTime(0,function()
                        local offset_pt = get_offset_pt_by_angle(angle,i*delta_range)
                        inst:DoTaskInTime(math.random(0,5)/30,function()                            
                            SpawnPrefab("hoshino_sfx_explode2"):PushEvent("Set",{
                                pt = start_pt+offset_pt,
                                -- time = 5,
                                color = color,
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                                -- nosound = true,
                            })
                        end)
                        inst:DoTaskInTime(math.random(0,5)/30,function()
                            local offset_pt2 = get_offset_pt_by_angle(angle+Get_Attack_Angle()/2,i*delta_range)
                            SpawnPrefab("hoshino_sfx_explode2"):PushEvent("Set",{
                                pt = start_pt+offset_pt2,
                                -- time = 5,
                                color = color,
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                                nosound = true,
                            })
                        end)
                        inst:DoTaskInTime(math.random(0,5)/30,function()
                            local offset_pt3 = get_offset_pt_by_angle(angle-Get_Attack_Angle()/2,i*delta_range)
                            SpawnPrefab("hoshino_sfx_explode2"):PushEvent("Set",{
                                pt = start_pt+offset_pt3,
                                -- time = 5,
                                color = color,
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                                nosound = true,
                            })
                        end)
                        inst:DoTaskInTime(math.random(0,5)/30,function()
                            local offset_pt2 = get_offset_pt_by_angle(angle+Get_Attack_Angle()/3,i*delta_range)
                            SpawnPrefab("hoshino_sfx_explode2"):PushEvent("Set",{
                                pt = start_pt+offset_pt2,
                                -- time = 5,
                                color = color,
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                                nosound = true,
                            })
                        end)
                        inst:DoTaskInTime(math.random(0,5)/30,function()
                            local offset_pt3 = get_offset_pt_by_angle(angle-Get_Attack_Angle()/3,i*delta_range)
                            SpawnPrefab("hoshino_sfx_explode2"):PushEvent("Set",{
                                pt = start_pt+offset_pt3,
                                -- time = 5,
                                color = color,
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                                nosound = true,
                            })
                        end)
                    end)

                end
            ------------------------------------------------------------------------------------
            --- 音效
                doer.SoundEmitter:PlaySound("rifts3/mutated_varg/blast_pre_f17")
            ------------------------------------------------------------------------------------
        end)
    ----------------------------------------------------------------------------------------
    --- 造成扇形伤害
        inst:ListenForEvent("eye_of_horus_shoot_damage",function(inst,_table)
            local target = _table and _table.target
            local pt = _table and _table.pt
            local weapon = inst.components.combat:GetWeapon()
            local doer = inst
            ------------------------------------------------------------------------------------
            --- 预检查
                if weapon == nil or not weapon:HasTag("hoshino_weapon_gun_eye_of_horus") then
                    return
                end
            ------------------------------------------------------------------------------------
            --- 目标坐标。
                local x,y,z
                if target and target.Transform then
                    x,y,z = target.Transform:GetWorldPosition()
                end
                if pt then
                    x,y,z = pt.x,pt.y,pt.z
                end
                if not x or not y or not z then
                    return
                end
            ------------------------------------------------------------------------------------
            ---
            ------------------------------------------------------------------------------------
            --- 坐标和角度函数
                doer:ForceFacePoint(x, y, z)
                local start_pt = Vector3(doer.Transform:GetWorldPosition()) --- 起点坐标。
                ------------------------------------------------------------------------------
                --- 起点坐标归一化后偏移距离1
                    start_pt = start_pt + (Vector3(x,y,z) - start_pt):GetNormalized() * 1
                ------------------------------------------------------------------------------
                local delta_x,delata_y,delta_z = x-start_pt.x, 0 ,z-start_pt.z
                local angle = math.deg(math.atan2(delta_z, delta_x))
                -- local distance = 4
            ------------------------------------------------------------------------------------
            --- 搜索范围内合适的目标。 扇形目标
                --- 计算扫描中点
                    local mid_line_max_pt = (start_pt + (Vector3(x,y,z) - start_pt):GetNormalized() * Get_Attack_Range())

                    local center_pt = Vector3((mid_line_max_pt.x+start_pt.x)/2,0,(mid_line_max_pt.z+start_pt.z)/2)

                    -- SpawnPrefab("log").Transform:SetPosition(center_pt.x,0,center_pt.z)
            ------------------------------------------------------------------------------------
            --- 预设值武器参数
                SetWeaponParam(weapon)
            ------------------------------------------------------------------------------------
            --- 简易攻击
                local musthavetags = {"_combat"}
                local canthavetags = {"companion","player", "playerghost", "INLIMBO","chester","hutch","DECOR", "FX",}
                local musthaveoneoftags = nil
                local ents = TheSim:FindEntities(center_pt.x,0,center_pt.z,15,musthavetags,canthavetags,musthaveoneoftags)
                for k, temp_target in pairs(ents) do
                    -- print(" ++++ target",temp_target)
                    if temp_target and temp_target:IsValid() and doer.components.combat:CanHitTarget(temp_target) then
                        if Check_In_Area(Vector3(temp_target.Transform:GetWorldPosition()),start_pt,mid_line_max_pt) then
                            doer.components.combat:DoAttack(temp_target,weapon)
                            -- temp_target.components.combat:GetAttacked(doer,34,weapon)
                            DoGunDamage(temp_target,weapon)
                        else
                            -- print("ERROR: target is not in area",temp_target)
                        end
                    end
                end
            ------------------------------------------------------------------------------------
            --- 重置武器参数
                ResetWeaponParam(weapon)
            ------------------------------------------------------------------------------------
        end)
    ----------------------------------------------------------------------------------------
    inst:ListenForEvent("hoshino_sg_action_gun_shoot_active",function(inst,target)
        inst:PushEvent("eye_of_horus_shoot_fx",{target = target})
        inst:PushEvent("eye_of_horus_shoot_damage",{target = target})
    end)

    ----------------------------------------------------------------------------------------
    --- 穿戴武器的时候触发
        inst:ListenForEvent("hoshino_weapon_gun_eye_of_horus_equipped",function(inst,weapon)
            -- weapon.components.weapon:SetRange(Get_Attack_Range())
        end)
        inst:ListenForEvent("hoshino_weapon_gun_eye_of_horus_attack_range_update",function(inst,weapon)
            weapon.components.weapon:SetRange(Get_Attack_Range())
        end)
    ----------------------------------------------------------------------------------------

end