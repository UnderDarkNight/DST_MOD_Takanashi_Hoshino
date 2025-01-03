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
local ANIM_SCALE = 1.5
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
    local empty_fn = function()    end
    local function hook_container(inst)
        local container = inst.components.container
        container.DropItemBySlot = empty_fn
        container.DropEverythingWithTag = empty_fn
        container.DropEverything = empty_fn
        container.DropEverythingUpToMaxStacks = empty_fn
        container.DropItem = empty_fn
        container.DropItemAt = empty_fn
    end
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
                hook_container(inst)
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
                if doer and doer.replica.hoshino_com_task_sys_for_player then
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
            inst:PushEvent("load_data_from_theworld")
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
    local item_types = {
        ["white"] = true,
        ["golden"] = true,
        ["blue"] = true,
        ["colourful"] = true,
    }
    local function anim_display_update_fn_install(inst)
        inst:ListenForEvent("task_item_update",function()            
            local all_items = inst.components.container.slots or {}
            for i = 1, 6, 1 do
                local item = all_items[i]
                local slot_index = "slot_"..tostring(i)
                if item and item.type and item_types[item.type] then
                    inst.AnimState:ShowSymbol(slot_index)
                    inst.AnimState:OverrideSymbol(slot_index,"hoshino_building_task_board",item.type)
                else
                    inst.AnimState:HideSymbol(slot_index)
                end
            end
        end)
        inst:DoTaskInTime(1,function()
            inst:PushEvent("task_item_update")
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 摧毁
    local function official_workable_install(inst)
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(4)
        inst.components.workable:SetOnFinishCallback(function()
            inst:PushEvent("save_data_to_theworld")
            local fx = SpawnPrefab("collapse_big")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst:Remove()
        end)
        inst.components.workable:SetOnWorkCallback(nil)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 储存任务物品给 世界
    local function data_2_world_fn_install(inst)
        

        inst:ListenForEvent("save_data_to_theworld",function()
        
            local data = {}
            for i = 1, 6, 1 do
                local item = inst.components.container.slots[i]
                if item then
                    data[i] = item:GetSaveRecord()
                else
                    data[i] = nil
                end
            end

            TheWorld.components.hoshino_data:Set("hoshino_building_task_board_data",data)
        end)

        inst:ListenForEvent("load_data_from_theworld",function()
            local data = TheWorld.components.hoshino_data:Get("hoshino_building_task_board_data")
            if data then
                for i = 1, 6, 1 do
                    local item_code = data[i]
                    if item_code then
                        local item = SpawnSaveRecord(item_code)
                        inst.components.container:GiveItem(item,i)
                    end
                end
                TheWorld.components.hoshino_data:Set("hoshino_building_task_board_data",nil)
                inst.components.hoshino_data:Set("inited",true)
            end
        end)

    end
    -- local function OnBuilt(inst,builder)
    --     local old_building = TheSim:FindFirstEntityWithTag("hoshino_building_task_board")
    -- end
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
    inst.AnimState:SetScale(ANIM_SCALE,ANIM_SCALE,ANIM_SCALE)

    inst:AddTag("irreplaceable")
    inst:AddTag("structure")
    inst:AddTag("hoshino_building_task_board")

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
    -- 摧毁
        official_workable_install(inst)
    -------------------------------------------------------------------------------------
    -- 储存任务物品给 世界
        data_2_world_fn_install(inst)
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
local function pre_build_fn()
    
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnBuilt = function(inst,builder)
        local old_building = TheSim:FindFirstEntityWithTag("hoshino_building_task_board")
        if old_building then
            old_building:PushEvent("save_data_to_theworld")
            old_building:Remove()
        end
        local new_building = SpawnPrefab("hoshino_building_task_board")
        new_building.Transform:SetPosition(inst.Transform:GetWorldPosition())
        new_building.components.hoshino_data:Set("Ready",true)
        inst:Remove()
    end
    return inst
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function placer_postinit_fn(inst)
    -- local scale = 1.5
    -- inst.AnimState:SetScale(scale,scale,scale)
    -- inst.AnimState:Hide("SNOW")
    inst.AnimState:SetScale(ANIM_SCALE,ANIM_SCALE,ANIM_SCALE)
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("hoshino_building_task_board", fn, assets),
    Prefab("hoshino_building_task_board_pre", pre_build_fn, assets),
    MakePlacer("hoshino_building_task_board_pre_placer", "hoshino_building_task_board", "hoshino_building_task_board", "idle", nil, nil, nil, nil, nil, nil, placer_postinit_fn, nil, nil)
