----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    曼德拉草浓缩液

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------
----
    local assets = {
        Asset("ANIM", "anim/hoshino_food_mandrake_concentrate.zip"), 
        Asset( "IMAGE", "images/inventoryimages/hoshino_food_mandrake_concentrate.tex" ),  -- 背包贴图
        Asset( "ATLAS", "images/inventoryimages/hoshino_food_mandrake_concentrate.xml" ),
    }
----------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnEateFn(inst,eater)
        if not (eater and eater.components.hoshino_cards_sys) then
            return
        end

        local black_cards_data = eater.components.hoshino_cards_sys:GetActivatedCards("card_black")
        --[[
            得到返回 {
                ["card_name_index"] = actived_times
            }
        ]]
        local cards_list = {}
        for card_name_index, times in pairs(black_cards_data) do
            if card_name_index and times and type(times) == "number" and times > 0 then
                table.insert(cards_list, card_name_index)
            end
        end
        if #cards_list == 0 then
            return
        end

        local card_name_index = cards_list[math.random(#cards_list)]
        eater.components.hoshino_cards_sys:TryToDeactiveCardByName(card_name_index) -- 尝试取消激活
    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_food_mandrake_concentrate") -- 地上动画
    inst.AnimState:SetBuild("hoshino_food_mandrake_concentrate") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle") -- 默认播放哪个动画

    MakeInventoryFloatable(inst)
    inst:AddTag("preparedfood")

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
    inst.components.inventoryitem.imagename = "hoshino_food_mandrake_concentrate"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_food_mandrake_concentrate.xml"

    --------------------------------------------------------------------------


    inst:AddComponent("edible") -- 可食物组件
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible:SetOnEatenFn(OnEateFn) -- 吃完后的回调函数

    inst:AddComponent("perishable") -- 可腐烂的组件
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY*80)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物

    inst.components.edible.hungervalue = 150
    inst.components.edible.sanityvalue = 150
    inst.components.edible.healthvalue = 150

    inst:AddComponent("stackable") -- 可堆叠
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)
    -------------------------------------------------------------------
    --- 落水影子
        -- local function shadow_init(inst)
        --     if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
        --         inst.AnimState:Hide("SHADOW")
        --     else                                
        --         inst.AnimState:Show("SHADOW")
        --     end
        -- end
        -- inst:ListenForEvent("on_landed",shadow_init)
        -- shadow_init(inst)
    -------------------------------------------------------------------
    
    return inst
end

return Prefab("hoshino_food_mandrake_concentrate", fn, assets)