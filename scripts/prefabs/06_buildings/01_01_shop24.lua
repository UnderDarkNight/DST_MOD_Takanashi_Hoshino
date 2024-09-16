--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    商店

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local assets =
    {
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
                container_Widget_change(inst.components.container)
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



local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    -- inst.MiniMapEntity:SetIcon("fwd_in_pdt_firewood_container.tex")

    MakeObstaclePhysics(inst, 0.5)---设置一下距离

    inst.AnimState:SetBank("madscience_lab")
    inst.AnimState:SetBuild("madscience_lab")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")

    add_container_before_not_ismastersim_return(inst)
    widget_open_event_install(inst)
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

    return inst
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Prefab("hoshino_building_shop24", fn, assets)