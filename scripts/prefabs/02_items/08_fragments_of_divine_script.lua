----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    神明文字碎片

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------

local assets = {
    Asset("ANIM", "anim/hoshino_item_fragments_of_divine_script.zip"), 
    Asset( "IMAGE", "images/inventoryimages/hoshino_item_fragments_of_divine_script.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/hoshino_item_fragments_of_divine_script.xml" ),
}
----------------------------------------------------------------------------------------------------------------------------------------------------
-- workable install

    local function workable_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                if doer.prefab == "hoshino" and inst.replica.inventoryitem:IsGrandOwner(doer) then
                    return true
                end
            end)
            replica_com:SetText("hoshino_item_fragments_of_divine_script","升级卡池")
            replica_com:SetSGAction("dolongaction")
        end)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_workable")
        inst.components.hoshino_com_workable:SetOnWorkFn(function(inst,doer)
            -- 使用后可以提高1点金卡权重，0.2彩卡权重，至多使用五次。
            -- local num = inst.components.stackable:StackSize() or 0
            -- inst:Remove()
            -------------------------------------------------------------------------------------
            --- 检查是否已经达到上限
                if doer.components.hoshino_cards_sys:Add(inst.prefab,0) >= 5 then
                    return false
                end
            -------------------------------------------------------------------------------------
            --- 计数，单次。
                local num = 1
                doer.components.hoshino_cards_sys:Add(inst.prefab,1)
                inst.components.stackable:Get():Remove()
            -------------------------------------------------------------------------------------
            --- 暂时预留多次使用功能
                local weights_per_time = {
                    ["card_golden"] = 1,
                    ["card_colourful"] = 0.2,
                }
                for i = 1, num, 1 do
                    for card_type, weight in pairs(weights_per_time) do
                        doer.components.hoshino_cards_sys:Card_Pool_Delata(card_type, weight)
                    end
                end
            -------------------------------------------------------------------------------------
            return true
        end)
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_item_fragments_of_divine_script") -- 地上动画
    inst.AnimState:SetBuild("hoshino_item_fragments_of_divine_script") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    -- inst.AnimState:SetScale(1.5,1.5,1.5)
    -- MakeInventoryFloatable(inst)

    -- inst:AddTag("frozen")   --- 给腐烂组件用的
    -- inst:AddTag("preparedfood")

    inst.entity:SetPristine()
    workable_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
        inst.components.inventoryitem.imagename = "hoshino_item_fragments_of_divine_script"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_fragments_of_divine_script.xml"
        inst.components.inventoryitem:SetSinks(true)    -- 掉水里消失
    -------------------------------------------------------------------
        inst:AddComponent("stackable") -- 可堆叠
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    -------------------------------------------------------------------
        MakeHauntableLaunch(inst)
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                -- inst.AnimState:Hide("SHADOW")
                -- inst:Remove()
            else                                
                -- inst.AnimState:Show("SHADOW")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    
    return inst
end

return Prefab("hoshino_item_fragments_of_divine_script", fn, assets)