----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local containers = require("containers")
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, 22)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function container_Widget_change(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "hoshino_building_white_drone_widget"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")
        local params = all_container_widgets.params
        if params[container_widget_name] == nil then
            params[container_widget_name] = {
                widget =
                {
                    slotpos = {},
                    animbank = "ui_fish_box_5x4",
                    animbuild = "ui_fish_box_5x4",
                    pos = Vector3(0, 220, 0),
                    side_align_tip = 160,
                },
                type = "chest",
                acceptsstacks = true,                
            }

            for y = 2.5, -0.5, -1 do
                for x = -1, 3 do
                    table.insert(params[container_widget_name].widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
                end
            end
            ------------------------------------------------------------------------------------------
            ----
                table.insert(params[container_widget_name].widget.slotpos, Vector3(300,40,0))
                table.insert(params[container_widget_name].widget.slotpos, Vector3(300,-40,0))
            ------------------------------------------------------------------------------------------
            ---- item test
                params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                    if item and item:HasOneOfTags({"irreplaceable","nonpotatable","chester_eyebone","hutch_fishbowl"}) then
                        return false
                    end
                    if slot == 21 then
                        if item and item.prefab == "eyeturret_item" then
                            return true
                        else
                            return false
                        end
                    end
                    if slot == 22 then
                        if item and item.prefab == "orangeamulet" then
                            return true
                        else
                            return false
                        end
                    end
                    return true
                end
            ------------------------------------------------------------------------------------------

            ------------------------------------------------------------------------------------------
        end
        
        theContainer:WidgetSetup(container_widget_name)
        ------------------------------------------------------------------------
        --- 开关声音
            -- if theContainer.widget then
            --     theContainer.widget.closesound = "turnoftides/common/together/water/splash/small"
            --     theContainer.widget.opensound = "turnoftides/common/together/water/splash/small"
            -- end
        ------------------------------------------------------------------------
    end

    local function add_container_before_not_ismastersim_return(inst)
        -------------------------------------------------------------------------------------------------
        ------ 添加背包container组件    --- 必须在 SetPristine 之后，
        -- local container_WidgetSetup = "wobysmall"
        if TheWorld.ismastersim then
            inst:AddComponent("container")
            inst.components.container.openlimit = 1  ---- 限制1个人打开
            -- inst.components.container:WidgetSetup(container_WidgetSetup)
            container_Widget_change(inst.components.container)
            inst.components.container:EnableInfiniteStackSize(true)-- 无限叠堆

        end
        inst.OnEntityReplicated = function(inst)
            container_Widget_change(inst.replica.container)
        end
        
        -------------------------------------------------------------------------------------------------
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 界面修改
    local function container_Widget_change(inst, front_root)
        -- pcall(function()
            local new_bg = front_root:AddChild(UIAnim())
            new_bg:GetAnimState():SetBank("ui_chest_1x2")
            new_bg:GetAnimState():SetBuild("ui_chest_1x2")
            new_bg:GetAnimState():PlayAnimation("open")
            new_bg:SetPosition(300,0,0)
            new_bg:MoveToBack()
            if type(front_root.inv) == "table" and front_root.inv[21] and front_root.inv[22] then
                front_root.inv[21].bgimage:SetTexture("images/widgets/hoshino_building_white_drone_widget.xml", "eyeturret_item.tex")
                front_root.inv[22].bgimage:SetTexture("images/widgets/hoshino_building_white_drone_widget.xml", "orangeamulet.tex")
            end
            front_root.inst:ListenForEvent("onremove",function()
                new_bg:Kill()
            end)
            new_bg.inst:DoPeriodicTask(FRAMES*10,function()
                if not front_root.inst:IsValid() then
                    new_bg:Kill()
                end
            end)
        -- end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function HasEquipment(inst,prefab)
        for i = 21, inst.components.container:GetNumSlots(), 1 do
            local tempItem = inst.components.container:GetItemInSlot(i)
            if tempItem and tempItem.prefab == prefab then
                return true
            end
        end
        return false
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    add_container_before_not_ismastersim_return(inst)
    inst:ListenForEvent("hoshino_event.container_widget_open",container_Widget_change)
    if not TheWorld.ismastersim then
        return
    end
    inst.HasEquipment = HasEquipment

    inst:ListenForEvent("trans_2_item",function()
        inst.components.container:Close()
    end)
end
