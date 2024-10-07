
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面调试
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"


    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"

    local ScrollableList = require "widgets/scrollablelist"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local flg,error_code = pcall(function()
    print("WARNING:PCALL START +++++++++++++++++++++++++++++++++++++++++++++++++")
    local x,y,z =    ThePlayer.Transform:GetWorldPosition()  
    ----------------------------------------------------------------------------------------------------------------    ----------------------------------------------------------------------------------------------------------------
    --- 卡牌调试
        -- local item = SpawnPrefab("hoshino_item_cards_pack")
        -- item:PushEvent("Set",{
        --         cards = {
        --             -- "card_golden",
        --             -- "card_white",
        --             -- "card_colourful",
        --             -- "card_colourful",
        --             -- "card_golden",
        --             "ruins_sheild_and_vengeance",
        --         },
        --     }
        -- )
        -- ThePlayer.components.inventory:GiveItem(item)
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- ThePlayer:ListenForEvent("newstate",function(inst,_table)
        --     local statename = _table and _table.statename
        --     if statename then
        --         print("newstate:",statename)
        --     end
        -- end)
    ----------------------------------------------------------------------------------------------------------------
    --- 
            -- print( ThePlayer.components.hoshino_com_level_sys:GetExpMult() )

            -- local debuff_prefab = "hoshino_buff_special_equipment_backpack_t9"
            -- while true do
            --     local debuff_inst = ThePlayer:GetDebuff(debuff_prefab)
            --     if debuff_inst and debuff_inst:IsValid() then
            --         debuff_inst:PushEvent("reset_pool")
            --         break
            --     end
            --     ThePlayer:AddDebuff(debuff_prefab,debuff_prefab)
            -- end
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- ThePlayer.AnimState:PlayAnimation("hoshino_ex_walk_loop")
        -- ThePlayer.AnimState:PlayAnimation("hoshino_atk")
        -- ThePlayer.AnimState:PlayAnimation("hoshino_ex_pre")
        -- ThePlayer.AnimState:PushAnimation("hoshino_ex_loop")
    ----------------------------------------------------------------------------------------------------------------
    ---
            local weapon = ThePlayer.components.combat:GetWeapon()
            weapon.components.finiteuses:SetPercent(1)
    ----------------------------------------------------------------------------------------------------------------
    ---
        -- 武器攻击范围
        -- 1级：30度，5距离范围
        -- 2级：45度，7距离范围
        -- 3级：60度，9距离范围
        local function Get_Attack_Angle()
            return 60
        end
        local function Get_Attack_Range()
            return 9
        end


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

        ThePlayer.___eye_of_horus_shoot_fn = function(inst,target,pt)
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
                local doer = inst
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
            --- 简易攻击
                local weapon = doer.components.combat:GetWeapon()

                local musthavetags = {"_combat"}
                local canthavetags = {"companion","player", "playerghost", "INLIMBO","chester","hutch","DECOR", "FX",}
                local musthaveoneoftags = nil
                local ents = TheSim:FindEntities(center_pt.x,0,center_pt.z,15,musthavetags,canthavetags,musthaveoneoftags)
                for k, temp_target in pairs(ents) do
                    print(" ++++ target",temp_target)
                    if temp_target and temp_target:IsValid() and doer.components.combat:CanHitTarget(temp_target) then
                        if Check_In_Area(Vector3(temp_target.Transform:GetWorldPosition()),start_pt,mid_line_max_pt) then
                            -- doer.components.combat:DoAttack(temp_target,weapon)
                            temp_target.components.combat:GetAttacked(doer,34,weapon)
                        else
                            print("ERROR: target is not in area",temp_target)
                        end
                    end
                end
            ------------------------------------------------------------------------------------
        end
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))