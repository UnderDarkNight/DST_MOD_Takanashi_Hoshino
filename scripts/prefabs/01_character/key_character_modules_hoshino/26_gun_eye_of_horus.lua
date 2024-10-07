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

    local function Get_Attack_Angle()
        return 60
    end
    local function Get_Attack_Range()
        return 9
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
    inst:ListenForEvent("eye_of_horus_shoot",function(inst,_table)
        local target = _table and _table.target
        local pt = _table and _table.pt
        if inst.___eye_of_horus_shoot_fn then
            inst.___eye_of_horus_shoot_fn(inst,target,pt)
        end
        -- inst:PushEvent("eye_of_horus_shoot_fx",_table)
    end)
    inst:ListenForEvent("hoshino_sg_action_gun_shoot_active",function(inst,target)
        inst:PushEvent("eye_of_horus_shoot_fx",{target = target})
        inst:PushEvent("eye_of_horus_shoot",{target = target})
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