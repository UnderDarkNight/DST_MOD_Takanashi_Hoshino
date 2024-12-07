--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    商店

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local assets =
    {
        Asset("ANIM", "anim/hoshino_building_shop24.zip"),

        Asset("ANIM", "anim/hoshino_building_shop24_hud.zip"),
        Asset("IMAGE", "images/widgets/hoshino_shop24_slot_bg.tex"),
		Asset("ATLAS", "images/widgets/hoshino_shop24_slot_bg.xml"),
        
        Asset("IMAGE", "images/widgets/hoshino_shop_widget.tex"),
		Asset("ATLAS", "images/widgets/hoshino_shop_widget.xml"),
    }
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
    local function container_Widget_change(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "hoshino_building_shop24_widget"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")  --- 所有容器的总表
        local params = all_container_widgets.params             ---- 总参数表。 index 为该界面名字。
        if params[container_widget_name] == nil then            ---- 如果该界面不存在总表，则按以下规则注册。
            params[container_widget_name] = {
                widget =
                {
                    slotpos = {},
                    animbank = "hoshino_building_shop24_hud",   --- 格子背景动画
                    animbuild = "hoshino_building_shop24_hud",  --- 格子背景动画
                    pos = Vector3(0, 0, 0),       --- 基点坐标
                    -- side_align_tip = 160,
                },
                type = "chest",
                acceptsstacks = true,               --- 是否允许叠堆
                -- opensound = "meta4/mermery/open",
                -- closesound = "meta4/mermery/close",
            }

            ------ 格子的布局
                local slot_start_x, slot_start_y = -700,-300
                local slot_delta = 70
                for y = 1,4 do
                    for x = 1,4 do
                        table.insert(params[container_widget_name].widget.slotpos, Vector3(slot_start_x + slot_delta * (x), slot_start_y + slot_delta * (y), 0))
                    end
                end
            -------------------------------------------------------------------------------------------
            -- 判断能烧的进来（组件是fuel）
            params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                return true
            end
        -------------------------------------------------------------------------------------------
        end
        ----- 检查、注册完 容器界面后，安装界面给  container 组件。replica 和 component  都是用的相同函数 安装
        theContainer:WidgetSetup(container_widget_name)
        ------------------------------------------------------------------------
        --- 开关声音。如果注释掉，则是默认的开关声音。
            if theContainer.widget then
                theContainer.widget.closesound = "turnoftides/common/together/water/splash/small"
                theContainer.widget.opensound = "turnoftides/common/together/water/splash/small"
            end
        ------------------------------------------------------------------------
    end

    local function add_container_before_not_ismastersim_return(inst)
        -------------------------------------------------------------------------------------------------
        ------ 添加背包container组件    --- 必须在 SetPristine 之后，
            if TheWorld.ismastersim then
                inst:AddComponent("container")
                inst.components.container.openlimit = 1  ---- 限制1个人打开
                inst.components.container.canbeopened = false
                container_Widget_change(inst.components.container)
                inst:ListenForEvent("onclose",function()
                    inst.components.container.canbeopened = false                    
                end)
            else
                ------- 在客户端必须执行容器界面注册。不能像科雷那样只在服务端注册。
                inst.OnEntityReplicated = function(inst)
                    container_Widget_change(inst.replica.container)
                end
            end
        -------------------------------------------------------------------------------------------------
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- widget event组件。同时触发商店相关的数据加载和图形元素显示。
    local function widget_open_event_install(inst)
        inst:ListenForEvent("hoshino_event.container_widget_open",function(inst,front_root)
            ------------------------------------------------------------------------
            -- 修改格子的透明度
                local slot_start_x, slot_start_y = -668,-68
                local slot_delta = 64
                -- local slot_scale = 0.9
                local slot_scale = 1
                local num = 1
                for y = 1, 4, 1 do
                    for x = 1, 4, 1 do
                        local current_itemtile = front_root.inv[num]
                        current_itemtile:SetPosition(slot_start_x + slot_delta*(x-1), slot_start_y - slot_delta*(y-1))
                        current_itemtile:SetScale(slot_scale,slot_scale,slot_scale)
                        if current_itemtile.bgimage then
                            current_itemtile.bgimage:SetTint(1,1,1,0.8)
                            current_itemtile.bgimage:SetTexture("images/widgets/hoshino_shop24_slot_bg.xml", "hoshino_shop24_slot_bg.tex")
                        end
                        current_itemtile:SetOnGainFocus(function()
                            current_itemtile:MoveToFront()
                        end)                    
                        num = num + 1
                    end
                end
            ------------------------------------------------------------------------
            ---- 
                -- if ThePlayer.___test_container_fn then
                --     ThePlayer.___test_container_fn(inst,front_root)
                -- end
		        local fn = require("prefabs/06_buildings/01_02_shop24_widget")
                if type(fn) == "function" then
                    fn(inst,front_root)
                end
            ------------------------------------------------------------------------
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- workable
    local function workable_com_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                if doer.replica.hoshino_com_shop or doer.replica._.hoshino_com_shop then
                    return true
                end
                return false
            end)
            replica_com:SetSGAction("give")
            replica_com:SetText("hoshino_building_shop24",STRINGS.ACTIONS.ACTIVATE.OPEN)

        end)
        
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("hoshino_com_workable")
        inst.components.hoshino_com_workable:SetOnWorkFn(function(inst,doer)
            doer.components.hoshino_com_shop:EnterShop(inst)
            return true
        end)
    end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 回收系统
    local function recycle_sys_install(inst)
        if not TheWorld.ismastersim then
            return
        end
        local fn = require("prefabs/06_buildings/01_03_recycle_sys")
        if type(fn) == "function" then
            fn(inst)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 物品升级系统
    local function shop_level_up_sys_install(inst)
        local fn = require("prefabs/06_buildings/01_04_shop_level_up")
        if type(fn) == "function" then
            fn(inst)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 玩家靠近
    local function playerprox_for_shop_install(inst)
        if not TheWorld.ismastersim then
            return
        end
        local fn = require("prefabs/06_buildings/01_05_playerprox_for_shop")
        if type(fn) == "function" then
            fn(inst)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("hoshino_building_shop24.tex")

    MakeObstaclePhysics(inst, 0.5)---设置一下距离

    inst.AnimState:SetBank("hoshino_building_shop24")
    inst.AnimState:SetBuild("hoshino_building_shop24")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
    inst:AddTag("hoshino_building_shop24")
    -------------------------------------------------------------------------------------
    --- 数据库
        if TheWorld.ismastersim then
            inst:AddComponent("hoshino_data")
        end
    -------------------------------------------------------------------------------------
    add_container_before_not_ismastersim_return(inst)
    widget_open_event_install(inst)
    workable_com_install(inst)
    recycle_sys_install(inst)
    shop_level_up_sys_install(inst)
    playerprox_for_shop_install(inst)
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")
    -------------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------------

    -------------------------------------------------------------------------------------

    -------------------------------------------------------------------------------------
    ---- 积雪检查
        --[[ 
            【注意】 
                官方的   MakeSnowCoveredPristine(inst)  MakeSnowCovered(inst) 
                基本只对官方的东西有效，MOD作者需要自行在动画和代码上做额外处理。
                方式有两种： 
                    基于文件夹的 隐藏/显示。
                    基于标记位的 隐藏显示。（这里示例用的就是这一种）
        ]]------
        local function snow_init(inst)
            if TheWorld.state.issnowcovered then
                inst.AnimState:Show("SNOW")
            else
                inst.AnimState:Hide("SNOW")
            end    
        end
        inst:WatchWorldState("issnowcovered", snow_init)
        snow_init(inst)
    -------------------------------------------------------------------------------------
    ---
        inst:DoTaskInTime(0,function()
            if not inst.components.hoshino_data:Get("Ready") then
                inst:Remove()
            end
        end)
    -------------------------------------------------------------------------------------

    return inst
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function pre_build_fn()
        
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.OnBuilt = function(inst,builder)
            local old_building = TheSim:FindFirstEntityWithTag("hoshino_building_shop24")
            if old_building then
                -- old_building:Remove()
                old_building.Transform:SetPosition(inst.Transform:GetWorldPosition())
                old_building.components.container:Close()
            else
                local new_building = SpawnPrefab("hoshino_building_shop24")
                new_building.Transform:SetPosition(inst.Transform:GetWorldPosition())
                new_building.components.hoshino_data:Set("Ready",true)
            end
            inst:Remove()
        end
        return inst
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function placer_postinit_fn(inst)
        -- local scale = 1.5
        -- inst.AnimState:SetScale(scale,scale,scale)
        -- inst.AnimState:Hide("SNOW")
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("hoshino_building_shop24", fn, assets),
    Prefab("hoshino_building_shop24_pre", pre_build_fn, assets),
    MakePlacer("hoshino_building_shop24_pre_placer", "hoshino_building_shop24", "hoshino_building_shop24", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil)
