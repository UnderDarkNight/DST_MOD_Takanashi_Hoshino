--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

武器攻击范围


    1级：范围7，角度45，攻击45
    2级：范围9，角度60，攻击45*2
    3级：范围11，角度60，攻击45*3，此时增加效果：专武范围攻击会追加等额直伤

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    ----------------------------------------------------------------------------------------
    --- 制作配方和相关tag。用来激活制作栏 图标
        local level_index = "weapon_gun_eye_of_horus_level"
        inst:DoTaskInTime(0,function()
            local level = inst.components.hoshino_data:Get(level_index) or 1
            inst:PushEvent("weapon_gun_eye_of_horus_level_set",level)
        end)
        inst:ListenForEvent("weapon_gun_eye_of_horus_level_set",function(inst,level)
            inst.components.hoshino_data:Set(level_index,level)
            for i = 1, 10, 1 do
                if i == level then
                    inst.components.hoshino_com_tag_sys:AddTag("weapon_gun_eye_of_horus_level_"..i)
                else
                    inst.components.hoshino_com_tag_sys:RemoveTag("weapon_gun_eye_of_horus_level_"..i)
                end
            end
        end)
    ----------------------------------------------------------------------------------------
    --- 等级切换。
        local function GetGunLevel()
            local level = inst.components.hoshino_data and inst.components.hoshino_data:Get(level_index) or 1
            return level
            -- return 1
        end
    ----------------------------------------------------------------------------------------
    --- 攻击距离+攻击角度 动态返回 预留的接口
        local attack_angle = {
            [1] = 45,
            [2] = 60,
            [3] = 60
        }
        local attack_range = {
            [1] = 7,
            [2] = 9,
            [3] = 11,
        }
        local function Get_Attack_Angle()
            return attack_angle[GetGunLevel()] or 60
        end
        local function Get_Attack_Range()
            return (attack_range[GetGunLevel()] or 9) + 1
        end
    ----------------------------------------------------------------------------------------
    --- 上笨怪debuff
        local debuff_prefab = "hoshino_debuff_gun_eye_of_horus_spell_monster_brain_stop"
        local function Add_Debuff_To_Monster(monster)
            local i = 10
            while i > 0 do
                local debuff_inst = monster:GetDebuff(debuff_prefab)
                if debuff_inst and debuff_inst:IsValid() then
                    debuff_inst:PushEvent("reset")
                    break
                end
                monster:AddDebuff(debuff_prefab,debuff_prefab)
                i = i - 1
            end
        end
        local function Remove_Debuff_From_Monster(monster)
            for i = 1, 3, 1 do
                monster:RemoveDebuff(debuff_prefab)
            end
        end
    ----------------------------------------------------------------------------------------
    --- 伤害执行函数 。 lv3 的情况下，一半普通伤害一半真实伤害。
        local function GetDMG(is_real_damage) 
            if not is_real_damage then
                --- 普通伤害
                if GetGunLevel() >= 3 then
                    return 45/2*GetGunLevel()
                else
                    return 45*GetGunLevel()
                end
            else
                --- 真实伤害
                return 45/2*GetGunLevel()
            end
        end
        local function DoRealDamage(target,weapon,value) -- 真实伤害
            if target.components.health == nil then
                return
            end
            target.components.health:DoDelta(-value)
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
        local function ResetWeaponParam(weapon,ignore_finiteuses_use) --- 重置攻击距离和伤害。
            weapon.components.weapon:SetRange(Get_Attack_Range())
            weapon.components.weapon:SetDamage(0)
            if not ignore_finiteuses_use then
                weapon.components.finiteuses:Use_Hoshino(1)
            end
        end
    ----------------------------------------------------------------------------------------
    --- 技能射击伤害. 1-4 为 mult * 100 + 10*level 。 5 为 mult * 200 + 20*level
        local function DoSpellDamage(target,weapon,spell)
            -- print("DoSpellDamage",target,spell)
            local mult = inst.components.combat.externaldamagemultipliers:Get()
            local ret_damage = 100*mult
            if spell >= 5 then
                ret_damage = 2*ret_damage
            end
            DoRealDamage(target,weapon,ret_damage-1)
            if target.components.combat then
                target.components.combat:GetAttacked(inst,1,weapon)
            end
            if spell < 5 then
                Add_Debuff_To_Monster(target)
            else
                Remove_Debuff_From_Monster(target)
            end
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
        
            -----------------------------------------------------------------------------------
            --- 尝试包含玩家近距离正面区域
                if dst_sq <= 1.2*1.2 then
                    return true
                end
            -----------------------------------------------------------------------------------
            --- 扇形区域判定
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
            -----------------------------------------------------------------------------------
            
            return true
        end
    ----------------------------------------------------------------------------------------
    --- 扇形特效
        local function get_offset_pt_by_angle(angle,distance) -- 为了节省解析计算量，放外面。
            return Vector3(math.cos(math.rad(angle))*distance,0,math.sin(math.rad(angle))*distance )                    
        end
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

                -- local function get_offset_pt_by_angle(angle,distance)
                --     return Vector3(math.cos(math.rad(angle))*distance,0,math.sin(math.rad(angle))*distance )                    
                -- end
            ------------------------------------------------------------------------------------
            ---- 扇形火焰特效。
                local delta_range = 1
                local function GetFxTime(i)
                    -- if doer.__time_fn then
                    --     return doer.__time_fn(i)
                    -- end
                end
                -- local function GetFxColor(i)
                --     if i < Get_Attack_Range()*2/3 then
                --         return Vector3(90/255, 66/255, 41/255)
                --     else
                --         return Vector3(255/255, 128/255, 0/255)
                --     end
                -- end
                -- 定义两个颜色端点
                -- local startColor = Vector3(90/255, 66/255, 41/255) -- 深棕色
                -- local endColor = Vector3(255/255, 128/255, 0/255) -- 橙色

                local startColor = Vector3(90/255, 66/255, 41/255) -- 深棕色
                local midColor = Vector3(255/255,125/255, 0/255)  -- 中点颜色
                local endColor = Vector3(255/255, 255/255, 255/255) -- 尽头颜色
                local function LerpColor(colorA, colorB, t)
                    return Vector3(
                        colorA.x + t * (colorB.x - colorA.x),
                        colorA.y + t * (colorB.y - colorA.y),
                        colorA.z + t * (colorB.z - colorA.z)
                    )
                end
                
                local function GetFxColor(i)
                    -- 计算从 0 到 1 的插值比例
                    local t = i / Get_Attack_Angle()
                    local midPoint = 0.5 -- 可以根据需要调整这个值
                    
                    if t < midPoint then
                        -- 当 t 小于 midPoint 时，在 startColor 和 midColor 之间插值
                        return LerpColor(startColor, midColor, t / midPoint)
                        -- return LerpColor(inst.startColor or startColor, inst.midColor or midColor, t / (midPoint))
                    else
                        -- 当 t 大于或等于 midPoint 时，在 midColor 和 endColor 之间插值
                        -- 注意这里的 (t - midPoint) / (1 - midPoint)，它确保了 t 在 midPoint 和 1 之间的变化映射到 0 和 1 之间
                        return LerpColor(midColor, endColor, (t - midPoint) / (1 - midPoint))
                        -- return LerpColor(inst.midColor or midColor, inst.endColor or endColor, (t - midPoint) / (1 - midPoint))
                    end
                end
                local function GetFxPrefab(i)
                     -- hoshino_sfx_explode2  可以设置棕色的爆炸
                     -- hoshino_sfx_explode  可以设置橙色的爆炸
                     -- hoshino_fx_spell_flame 火焰特效。
                    if i <= Get_Attack_Range()*1/3 then
                        return "hoshino_sfx_explode2"
                    elseif i <= Get_Attack_Range()*2/3 then
                        return "hoshino_sfx_explode"
                    else
                        return "hoshino_fx_spell_flame"
                    end
                end
                for i = 1, Get_Attack_Range(), 1 do
                    -- local color = Vector3(255,0,0)
                    local color = doer.__test_color or Vector3(90/255, 66/255, 41/255)
                    local scale = ((0.5/3)*i+0.5)*0.5
                    local MultColour_Flag = true
                    local remain_time = 0.2
                    -- inst:DoTaskInTime((i-1)*0.05/2,function()
                    inst:DoTaskInTime(0,function()
                        local offset_pt = get_offset_pt_by_angle(angle,i*delta_range)
                        inst:DoTaskInTime(GetFxTime(i) or math.random(0,5)/30,function()                            
                            SpawnPrefab(GetFxPrefab(i) or "hoshino_sfx_explode2"):PushEvent("Set",{
                                pt = start_pt+offset_pt,
                                -- time = 5,
                                color = GetFxColor(i),
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                                -- nosound = true,
                                remain_time = remain_time,
                            })
                        end)
                        inst:DoTaskInTime(GetFxTime(i) or math.random(0,5)/30,function()
                            local offset_pt2 = get_offset_pt_by_angle(angle+Get_Attack_Angle()/2,i*delta_range)
                            SpawnPrefab(GetFxPrefab(i) or "hoshino_sfx_explode2"):PushEvent("Set",{
                                pt = start_pt+offset_pt2,
                                -- time = 5,
                                color = GetFxColor(i),
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                                nosound = true,
                                remain_time = remain_time,
                            })
                        end)
                        inst:DoTaskInTime(GetFxTime(i) or math.random(0,5)/30,function()
                            local offset_pt3 = get_offset_pt_by_angle(angle-Get_Attack_Angle()/2,i*delta_range)
                            SpawnPrefab(GetFxPrefab(i) or "hoshino_sfx_explode2"):PushEvent("Set",{
                                pt = start_pt+offset_pt3,
                                -- time = 5,
                                color = GetFxColor(i),
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                                nosound = true,
                                remain_time = remain_time,
                            })
                        end)
                        inst:DoTaskInTime(GetFxTime(i) or math.random(0,5)/30,function()
                            local offset_pt2 = get_offset_pt_by_angle(angle+Get_Attack_Angle()/3,i*delta_range)
                            SpawnPrefab(GetFxPrefab(i) or "hoshino_sfx_explode2"):PushEvent("Set",{
                                pt = start_pt+offset_pt2,
                                -- time = 5,
                                color = GetFxColor(i),
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                                nosound = true,
                                remain_time = remain_time,
                            })
                        end)
                        inst:DoTaskInTime(GetFxTime(i) or math.random(0,5)/30,function()
                            local offset_pt3 = get_offset_pt_by_angle(angle-Get_Attack_Angle()/3,i*delta_range)
                            SpawnPrefab(GetFxPrefab(i) or "hoshino_sfx_explode2"):PushEvent("Set",{
                                pt = start_pt+offset_pt3,
                                -- time = 5,
                                color = GetFxColor(i),
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                                nosound = true,
                                remain_time = remain_time,
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
            local spell_flag = _table and _table.spell
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
                -- print(math.floor(x),math.floor(y),math.floor(z))
                y = 0 -- 使用技能的伤害，y轴坐标出现了奇怪的偏差
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
                    -- SpawnPrefab("lightbulb").Transform:SetPosition(mid_line_max_pt.x,0,mid_line_max_pt.z)
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
                    if temp_target and temp_target:IsValid() and Check_In_Area(Vector3(temp_target.Transform:GetWorldPosition()),start_pt,mid_line_max_pt) then                        
                        if temp_target.components.combat and doer.components.combat:CanHitTarget(temp_target) then
                            -- doer.components.combat:DoAttack(temp_target,weapon)
                            -- temp_target.components.combat:GetAttacked(doer,34,weapon)
                            if spell_flag == nil then
                                DoGunDamage(temp_target,weapon)
                            else
                                DoSpellDamage(temp_target,weapon,spell_flag)
                            end
                        elseif temp_target.components.workable then

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
    --- 外部攻击调用。
        inst:ListenForEvent("hoshino_sg_action_gun_shoot_active",function(inst,target)
            inst:PushEvent("eye_of_horus_shoot_fx",{target = target})
            inst:PushEvent("eye_of_horus_shoot_damage",{target = target})
        end)
        inst:ListenForEvent("hoshino_sg_action_gun_shoot_active_spell",function(inst,_table)
            inst:PushEvent("eye_of_horus_shoot_fx",{pt = _table.pt})
            inst:PushEvent("eye_of_horus_shoot_damage",{pt = _table.pt,spell = _table.num})
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