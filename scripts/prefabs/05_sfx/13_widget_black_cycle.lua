------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
------------------------------------------------------------------------------------------------------------------------------------
---
    local Widget = require "widgets/widget"
    local Image = require "widgets/image"
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
------------------------------------------------------------------------------------------------------------------------------------
---
    local assets = {
        Asset("IMAGE", "images/widgets/hoshino_sfx_widget_black_cycle.tex"),
        Asset("ATLAS", "images/widgets/hoshino_sfx_widget_black_cycle.xml"),
    }
------------------------------------------------------------------------------------------------------------------------------------
---
    local function create_fx(inst)
        --------------------------------------------------------------
        -- 前置根节点
            local front_root = ThePlayer.HUD
        --------------------------------------------------------------
        --- 根节点
            local root = front_root:AddChild(Widget())
            root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)   --- 缩放模式
        --------------------------------------------------------------
        --- 
            local offset_y = 50
            TheInput:Hoshino_Add_Update_Custom_Fn(root.inst,function()
                local s_pt_x,s_pt_y= TheSim:GetScreenPos(ThePlayer.Transform:GetWorldPosition()) -- 左下角为原点。
                -- print("player in screen",s_pt_x,s_pt_y)
                root:SetPosition(s_pt_x,s_pt_y+offset_y,0)
            end)
        --------------------------------------------------------------
        --- 
            local ring = root:AddChild(Widget())                
            local function create_image(x,y,radius)
                local img = ring:AddChild(Image("images/widgets/hoshino_sfx_widget_black_cycle.xml","hoshino_sfx_widget_black_cycle.tex"))
                img:SetPosition(x,y)
                img:SetScale(0.5,0.5)
                img:SetTint(1,1,1,0.2)
                img.radius = radius
                return img
            end
        --------------------------------------------------------------
        --- 参数
            local MIN_RADIUS = 80              -- 最小半径
            local MAX_RADIUS = 150              -- 最大半径
            local BASE_RADIUS_OFFSET = 5       -- 随机偏移量
            local BASE_ANGLE_DELTA = 0.5        -- 角度
        --------------------------------------------------------------
        --- 以 0，0 为原点，按照0.5度 ，半径100 ，创建一圈
            local function create_points(radius,random_delta)
                random_delta = random_delta or 0
                local ret_points = {}
                for i=0,360,BASE_ANGLE_DELTA do
                    local temp_radius = radius + math.random(-random_delta,random_delta)
                    local x = temp_radius * math.cos(math.rad(i))
                    local y = temp_radius * math.sin(math.rad(i))
                    table.insert(ret_points,{x=x,y=y,radius = temp_radius})
                end
                return ret_points
            end
            local all_imgs = {}
            for i,v in ipairs(create_points(MIN_RADIUS,BASE_RADIUS_OFFSET)) do
                table.insert(all_imgs,create_image(v.x,v.y))
            end
        --------------------------------------------------------------
        ---
            local current_radius = MIN_RADIUS
            local up = true
            local delta_radius = 1/2
            local current_angle = math.random(0,360)
            local delta_angle = 1
            local function get_angle()
                current_angle = current_angle + delta_angle
                if current_angle > 360 then
                    current_angle = current_angle - 360
                end
                return current_angle
            end
            TheInput:Hoshino_Add_Update_Custom_Fn(ring.inst,function()
                if up then
                    current_radius = current_radius + delta_radius
                    if current_radius > MAX_RADIUS then
                        up = false
                    end
                else
                    current_radius = current_radius - delta_radius
                    if current_radius < MIN_RADIUS then
                        up = true
                    end
                end
                local points = create_points(current_radius,BASE_RADIUS_OFFSET)
                for i,img in ipairs(all_imgs) do
                    img:SetPosition(points[i].x,points[i].y)
                end
                ring:SetRotation(get_angle())
            end)
        --------------------------------------------------------------
        --- 
            inst:ListenForEvent("onremove",function()
                root:Kill()
            end)
        --------------------------------------------------------------
        --- 
            return root
        --------------------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------
--- target event
    local function set_target_fn(inst)
        local target = inst.__net_target:value()
        if target and target == ThePlayer and ThePlayer.HUD and inst.fx == nil then
            inst.fx = create_fx(inst)
        end
    end
------------------------------------------------------------------------------------------------------------------------------------
--- 
    local function fx()
        local inst = CreateEntity()
        inst.entity:AddSoundEmitter()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("INLIMBO")
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")


        inst.entity:SetPristine()

        inst.__net_target = net_entity(inst.GUID, "__net_target","set_target")
        if not TheNet:IsDedicated() then
            inst:ListenForEvent("set_target",set_target_fn)
        end
        if not TheWorld.ismastersim then
            return inst
        end
        -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
        inst:ListenForEvent("Set",function(inst,_table)
            -- _table = {
            --     target = inst,
            -- }

            if _table == nil or _table.target == nil then
                return
            end
            ------------------------------------------------------------------------------------------------------------------------------------
            ---
                _table.target:AddChild(inst)
                inst.__net_target:set(_table.target)
                inst:DoPeriodicTask(1,function()
                    if inst.__net_target:value() == _table.target then
                        inst.__net_target:set(inst)
                    else
                        inst.__net_target:set(_table.target)
                    end
                end)
            ------------------------------------------------------------------------------------------------------------------------------------

            inst.Ready = true
        end)

        inst:DoTaskInTime(0,function()
            if inst.Ready ~= true then
                inst:Remove()
            end
        end)

        return inst
    end
------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_sfx_widget_black_cycle", fx, assets)