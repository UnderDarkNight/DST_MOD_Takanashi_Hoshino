-------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
-------------------------------------------------------------------------------------------------------------------------------

local assets =
{

}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
local function container_Widget_change(theContainer)
    -----------------------------------------------------------------------------------
    ----- 容器界面名 --- 要独特一点，避免冲突
    local container_widget_name = "hoshino_other_task_backpack_widget"

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
            -- type = "chest",
            type = "pack_hoshino_task",
            -- acceptsstacks = true,
        }

        for y = 2.5, -0.5, -1 do
            for x = -1, 3 do
                table.insert(params[container_widget_name].widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
            end
        end
        ------------------------------------------------------------------------------------------
        ---- item test
            params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                return item and item:HasTag("hoshino_task_item")
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
        if TheWorld.ismastersim then
            inst:AddComponent("container")
            -- inst.components.container.openlimit = 1  ---- 限制1个人打开
            inst.components.container.canbeopened = true
            -- inst.components.container:WidgetSetup(container_WidgetSetup)
            container_Widget_change(inst.components.container)
        else
            inst.OnEntityReplicated = function(inst)
                container_Widget_change(inst.replica.container)
            end
        end
    -------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local function onequip(inst, owner)
    inst:DoTaskInTime(1,function()
        inst.components.container:Open(owner)
    end)
    --- 定时检查任务包的打开状态，避免客户端 看不见任务内容
    inst:DoPeriodicTask(5,function()
        if not inst.components.container:IsOpen() and not owner.components.hoshino_com_shop:IsShopOpening() then
            inst.components.container:Open(owner)
        end
    end)
end

local function onunequip(inst, owner)

end



local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    -- inst.MiniMapEntity:SetIcon("krampus_sack.png")

    inst.AnimState:SetBank("cane")
    inst.AnimState:SetBuild("swap_cane")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hoshino_special_equipment")
    inst:AddTag("nosteal")

    inst.entity:SetPristine()

    
    --------------------------------------------------------------------
    --- 
        inst:ListenForEvent("hoshino_event.container_widget_open",function(inst,container_widget)
            if container_widget then
                container_widget:Hide()
            end
        end)
    --------------------------------------------------------------------
    --- 容器安装
        add_container_before_not_ismastersim_return(inst)
    --------------------------------------------------------------------
    if not TheWorld.ismastersim then

        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem:ChangeImageName("cane")
    inst.components.inventoryitem.keepondeath = true



    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HOSHINO_TASK_BACKPACK
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.restrictedtag = "hoshino"

    --------------------------------------------------------------------
    ---
        inst:DoTaskInTime(0,function()
            local return_nil_fn = function(...) return nil end
            inst.components.container.DropItemBySlot = return_nil_fn
            inst.components.container.DropEverythingWithTag = return_nil_fn
            inst.components.container.DropEverything = return_nil_fn
            inst.components.container.DropItem = return_nil_fn
            inst.components.container.DropOverstackedExcess = return_nil_fn
            inst.components.container.DropItemAt = return_nil_fn
            inst.components.container.ignoresound = true
            -- inst.components.container.CanTakeItemInSlot = function() return false end
        end)
    --------------------------------------------------------------------

    return inst
end

return Prefab("hoshino_other_task_backpack", fn, assets)
