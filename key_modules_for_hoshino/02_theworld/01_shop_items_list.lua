-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 初始化添加特定组件
---- 添加一些Event
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddPrefabPostInit(
    "world",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:AddComponent("hoshino_com_shop_items_pool")


    end
)

