--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    商店

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
local assets =
{
    Asset("ANIM", "anim/hoshino_building_task_board.zip"),

    
    Asset("IMAGE", "images/widgets/hoshino_building_task_board_widget.tex"),
    Asset("ATLAS", "images/widgets/hoshino_building_task_board_widget.xml"),
}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
    local function container_Widget_change(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "hoshino_building_task_board_widget"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")  --- 所有容器的总表
        local params = all_container_widgets.params             ---- 总参数表。 index 为该界面名字。
        if params[container_widget_name] == nil then            ---- 如果该界面不存在总表，则按以下规则注册。
            params[container_widget_name] = {
                widget =
                {
                    slotpos = {},
                    animbank  = "ui_icepack_2x3",
                    animbuild = "ui_icepack_2x3",
                    pos = Vector3(0, 0, 0),
                },
                type = "hoshino_building_task_board_widget",
                acceptsstacks = false,               --- 是否允许叠堆
            }

            ------ 格子的布局
                for y = 0, 2 do
                    for x = 0, 1 do
                        table.insert(params[container_widget_name].widget.slotpos, Vector3(-163 + (75 * x),   -75 * y + 73,   0))
                    end
                end
            -------------------------------------------------------------------------------------------
            -- 判断能烧的进来（组件是fuel）
                params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                    return item and item:HasTag("hoshino_task_item")
                end
        -------------------------------------------------------------------------------------------
        end
        ----- 检查、注册完 容器界面后，安装界面给  container 组件。replica 和 component  都是用的相同函数 安装
        theContainer:WidgetSetup(container_widget_name)
        ------------------------------------------------------------------------
        --- 开关声音。如果注释掉，则是默认的开关声音。
            if theContainer.widget then
                -- theContainer.widget.closesound = "turnoftides/common/together/water/splash/small"
                -- theContainer.widget.opensound = "turnoftides/common/together/water/splash/small"
                -- theContainer.widget.closesound = ""
                -- theContainer.widget.opensound = ""
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
                inst.components.container.skipopensnd = false
                inst.components.container.skipclosesnd = false
            else
                ------- 在客户端必须执行容器界面注册。不能像科雷那样只在服务端注册。
                inst.OnEntityReplicated = function(inst)
                    container_Widget_change(inst.replica.container)                    
                end
            end
        -------------------------------------------------------------------------------------------------
        ---
            inst:DoTaskInTime(1,function()
                inst.replica.container.ShouldSkipCloseSnd = function()
                    return true
                end
                inst.replica.container.ShouldSkipOpenSnd = function()
                    return true
                end
            end)
        -------------------------------------------------------------------------------------------------
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- widget event组件。同时触发商店相关的数据加载和图形元素显示。
    local function widget_open_event_install(inst)
        inst:ListenForEvent("hoshino_event.container_widget_open",function(inst,front_root)
            ------------------------------------------------------------------------
            ---
                local fn = require("prefabs/09_hoshino_tasks/00_01_task_board_widget")
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
                if doer.prefab == "hoshino" then
                    return true
                end
                return false
            end)
            replica_com:SetSGAction("give")
            replica_com:SetText("hoshino_building_task_board",STRINGS.ACTIONS.OPEN_CRAFTING.STUDY)

        end)
        
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("hoshino_com_workable")
        inst.components.hoshino_com_workable:SetOnWorkFn(function(inst,doer)
            inst.components.hoshino_com_task_sys_for_building:Open(doer)
            return true
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 任务系统
    local function task_sys_com_install(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_task_sys_for_building")
        -- local fn = require("prefabs/06_buildings/01_03_recycle_sys")
        -- if type(fn) == "function" then
        --     fn(inst)
        -- end
        inst:DoTaskInTime(0,function()
            if not inst.components.hoshino_data:Get("inited") then
                inst.components.hoshino_data:Set("inited",true)
                inst.components.hoshino_com_task_sys_for_building:Refresh_All()
            end
        end)
        inst:WatchWorldState("cycles",function()
            inst.components.hoshino_com_task_sys_for_building:Refresh_All()            
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 外观更新
    local item_type = {
        ["nil"] = 0,
        ["gray"] = 1,
        ["blue"] = 2,
        ["golden"] = 3,
        ["colourful"] = 4,
    }
    local item_type_id = {
        [0] = "gray",
        [1] = "gray",
        [2] = "blue",
        [3] = "golden",
        [4] = "colourful",
    }
    local function anim_display_update_fn_install(inst)
        inst:ListenForEvent("task_item_update",function()
            
            local ret_display_type = 1
            local all_items = inst.components.container:GetAllItems()
            for k, item in pairs(all_items) do
                if item and item.type then
                    local item_type_num = item_type[tostring(item.type)]
                    if item_type_num > ret_display_type then
                        ret_display_type = item_type_num
                    end
                end
            end

            local ret_type_index = item_type_id[ret_display_type] or "gray"
            inst.AnimState:PlayAnimation("idle_"..ret_type_index)
        end)
        inst:DoTaskInTime(1,function()
            inst:PushEvent("task_item_update")
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(5.00, 1.50)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("hoshino_building_task_board.tex")

    MakeObstaclePhysics(inst, 0.5)---设置一下距离

    inst.AnimState:SetBank("hoshino_building_task_board")
    inst.AnimState:SetBuild("hoshino_building_task_board")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")

    add_container_before_not_ismastersim_return(inst)
    widget_open_event_install(inst)
    workable_com_install(inst)
    task_sys_com_install(inst)

    if not TheWorld.ismastersim then
        return inst
    end

    -------------------------------------------------------------------------------------
    -- 检查
        inst:AddComponent("inspectable")
    -------------------------------------------------------------------------------------
    -- 数据
        inst:AddComponent("hoshino_data")
    -------------------------------------------------------------------------------------
    -- 外观更新
        anim_display_update_fn_install(inst)
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

    return inst
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("hoshino_building_task_board", fn, assets)