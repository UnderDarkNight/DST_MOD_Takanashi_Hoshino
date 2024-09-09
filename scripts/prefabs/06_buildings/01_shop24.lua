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
                    animbank = "ui_fish_box_7x5",   --- 格子背景动画
                    animbuild = "ui_fish_box_7x5",  --- 格子背景动画
                    pos = Vector3(0, 220, 0),       --- 基点坐标
                    side_align_tip = 160,
                },
                slotbg =
                {
                    { image = "hoshino_shop24_slot_bg.tex", atlas = "images/widgets/hoshino_shop24_slot_bg.xml" },
                    { image = "hoshino_shop24_slot_bg.tex", atlas = "images/widgets/hoshino_shop24_slot_bg.xml" },
                    { image = "hoshino_shop24_slot_bg.tex", atlas = "images/widgets/hoshino_shop24_slot_bg.xml" },
                },
                type = "chest",
                acceptsstacks = true,               --- 是否允许叠堆 
            }

            ------ 格子的布局
            for y = 2.5, -0.5, -1 do
                for x = -1, 3 do
                    table.insert(params[container_widget_name].widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
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
            -- if theContainer.widget then
            --     theContainer.widget.closesound = "turnoftides/common/together/water/splash/small"
            --     theContainer.widget.opensound = "turnoftides/common/together/water/splash/small"
            -- end
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



local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst.entity:AddMiniMapEntity()
    -- inst.MiniMapEntity:SetIcon("fwd_in_pdt_firewood_container.tex")

    MakeObstaclePhysics(inst, 0.5)---设置一下距离

    inst.AnimState:SetBank("cane")
    inst.AnimState:SetBuild("swap_cane")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")

    add_container_before_not_ismastersim_return(inst)

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