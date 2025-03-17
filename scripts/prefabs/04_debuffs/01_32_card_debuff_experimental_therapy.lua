------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【白】【实验性疗法】在血、San、饥饿、移速、攻击、位面防御中，随机增加四项属性，

减少两项属性（血，san，饥饿，变化量：10（三维不低于1），攻击，移速5%，位面防御：3（位面防御不会低于0）


            health ： inst.components.hoshino_com_debuff:Add_Max_Helth(value)
            sanity ： inst.components.hoshino_com_debuff:Add_Max_Sanity(value)
            hunger : inst.components.hoshino_com_debuff:Add_Max_Hunger(value)

            damage : inst.components.hoshino_com_debuff:Add_Damage_Mult(value)
            speed :  inst.components.hoshino_com_debuff:Add_Speed_Mult(value)
            位面防御 ： inst.components.hoshino_com_debuff:Add_Planar_Defense(value)


]]--
------------------------------------------------------------------------------------------------------------------------------------------------
    local assets = {
        Asset("ANIM", "anim/hoshino_card_debuff_experimental_therapy.zip"), 
    }
------------------------------------------------------------------------------------------------------------------------------------------------
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player
        -----------------------------------------------------
        --
            local data  = {
                health = 10,
                sanity = 10,
                hunger = 10,
                damage = 0.05,
                speed = 0.05,
                planar_defense = 3,
            }
            -------------------------------------------------------------
            --- 随机抽取2个，数值变负数。
                local random_keys = {}
                for k in pairs(data) do
                    table.insert(random_keys, k)
                end
                -- 随机抽取2个不同的键，并将它们的值变为负数
                local selected_keys = {}
                for i = 1, 2 do
                    local index = math.random(#random_keys)
                    local random_key = random_keys[index]
                    table.insert(selected_keys, random_key)                    
                    -- 移除已选中的键，防止重复选择
                    table.remove(random_keys, index)
                end
                for _, key in ipairs(selected_keys) do
                    data[key] = -data[key]
                end
            -------------------------------------------------------------
            local anim_cmd_table = {}
            local player_name = player:GetDisplayName()
            local health = data.health
            player.components.hoshino_com_debuff:Add_Max_Helth(health)
            if health > 0 then
                player.components.health:DoDelta(health)
            end
            TheNet:Announce("【实验性疗法】"..player_name.."的最大生命值变更："..health)
            if health > 0 then
                table.insert(anim_cmd_table,"up_health")
            else
                table.insert(anim_cmd_table,"down_health")
            end
            local sanity = data.sanity
            player.components.hoshino_com_debuff:Add_Max_Sanity(sanity)
            TheNet:Announce("【实验性疗法】"..player_name.."的最大精神值变更："..sanity)
            if sanity > 0 then
                table.insert(anim_cmd_table,"up_sanity")
            else
                table.insert(anim_cmd_table,"down_sanity")
            end
            local hunger = data.hunger
            player.components.hoshino_com_debuff:Add_Max_Hunger(hunger)
            TheNet:Announce("【实验性疗法】"..player_name.."的最大饥饿值变更："..hunger)
            if hunger > 0 then
                table.insert(anim_cmd_table,"up_hunger")
            else
                table.insert(anim_cmd_table,"down_hunger")
            end
            local damage = data.damage
            player.components.hoshino_com_debuff:Add_Damage_Mult(damage)
            TheNet:Announce("【实验性疗法】"..player_name.."的伤害倍率变更："..damage)
            if damage > 0 then
                table.insert(anim_cmd_table,"up_damage")
            else
                table.insert(anim_cmd_table,"down_damage")
            end
            local speed = data.speed
            player.components.hoshino_com_debuff:Add_Speed_Mult(speed)
            TheNet:Announce("【实验性疗法】"..player_name.."的速度倍率变更："..speed)
            if speed > 0 then
                table.insert(anim_cmd_table,"up_speed")
            else
                table.insert(anim_cmd_table,"down_speed")
            end
            local planar_defense = data.planar_defense
            player.components.hoshino_com_debuff:Add_Planar_Defense(planar_defense)
            TheNet:Announce("【实验性疗法】"..player_name.."的位面防御变更："..planar_defense)
            if planar_defense > 0 then
                table.insert(anim_cmd_table,"up_planar_defense")
            else
                table.insert(anim_cmd_table,"down_planar_defense")
            end
        -----------------------------------------------------
        ---
            inst:DoTaskInTime(13,inst.Remove)
        -----------------------------------------------------
        --- 下发数据
            local data = {
                anim_cmd_table = anim_cmd_table,
                userid = player.userid,
            }
            local str = json.encode(data)
            inst.__net_string_data:set(str)
        -----------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------
--- 动画
    local Widget = require "widgets/widget"
    local UIAnim = require "widgets/uianim"
    local function CreateHudInfo(inst,anim_data)
        -----------------------------------------------------
        -- 前置根节点
            local front_root = ThePlayer.HUD
        -----------------------------------------------------
        -- 根节点
            local root = front_root:AddChild(Widget())
            root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        -----------------------------------------------------
        --- 跟随玩家
            TheInput:Hoshino_Add_Update_Custom_Fn(root.inst,function()
                local s_pt_x,s_pt_y= TheSim:GetScreenPos(ThePlayer.Transform:GetWorldPosition()) -- 左下角为原点。
                -- print("player in screen",s_pt_x,s_pt_y)
                root:SetPosition(s_pt_x,s_pt_y,0)
            end)
        -----------------------------------------------------
        ----
            local scale = 0.5
            local start_x = -90
            local start_y = 0
            local offset_y = 30
            local time = 0
            local time_offset = 0.4
            -- for _, anim_name in pairs(anim_data) do
            --     local temp = root:AddChild(UIAnim())
            --     temp:SetPosition(start_x,start_y,0)
            --     temp:GetAnimState():SetBank("hoshino_card_debuff_experimental_therapy")
            --     temp:GetAnimState():SetBuild("hoshino_card_debuff_experimental_therapy")
            --     temp:GetAnimState():PlayAnimation(anim_name,true)
            --     temp:GetAnimState():SetTime(time)
            --     temp:SetScale(scale,scale,scale)
            --     start_y = start_y + offset_y
            --     time = time + time_offset
            -- end
            for i ,anim_name  in pairs(anim_data) do
                root.inst:DoTaskInTime((i-1)*time_offset,function()
                    local temp = root:AddChild(UIAnim())
                    temp:SetPosition(start_x,start_y+(i-1)*offset_y,0)
                    temp:GetAnimState():SetBank("hoshino_card_debuff_experimental_therapy")
                    temp:GetAnimState():SetBuild("hoshino_card_debuff_experimental_therapy")
                    temp:GetAnimState():PlayAnimation(anim_name,true)
                    -- temp:GetAnimState():SetTime(0)
                    temp:SetScale(scale,scale,scale)                    
                end)
            end
        -----------------------------------------------------
        --- 
            inst:ListenForEvent("onremove",function()
                root:Kill()
            end)
        -----------------------------------------------------
            return root
        -----------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function net_data_get(inst)
        local str = inst.__net_string_data:value()
        local flag , data = pcall(json.decode,str)
        if not flag then
            return
        end
        local anim_cmd_table = data.anim_cmd_table or {}
        local userid = data.userid or 0
        if not ( ThePlayer and ThePlayer.userid == userid ) then
            return
        end
        CreateHudInfo(inst,anim_cmd_table)
    end
------------------------------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst:AddTag("CLASSIFIED")
    inst.entity:SetPristine()
    inst.__net_string_data = net_string(inst.GUID,"anim_data","anim_data")
    if not TheNet:IsDedicated() then
        inst:ListenForEvent("anim_data",net_data_get)
    end
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)

    return inst
end

return Prefab("hoshino_card_debuff_experimental_therapy", fn,assets)
