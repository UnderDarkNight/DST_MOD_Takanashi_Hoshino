--------------------------------------------------------------------------------------------------------------------------------------------------
---- 模块总入口，使用 common_postinit 进行嵌入初始化，注意 mastersim 区分
--------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)

    if TheWorld.ismastersim then
        if inst.components.hoshino_data == nil then
            inst:AddComponent("hoshino_data")
        end
        if inst.components.hoshino_com_rpc_event == nil then
            inst:AddComponent("hoshino_com_rpc_event")
        end
        -- if inst.components.hoshino_cards_sys == nil then
        --     inst:AddComponent("hoshino_cards_sys")
        -- end
    end

    local modules = {
        "prefabs/01_character/key_character_modules_hoshino/01_inventorybar",                           ---- hud修改
        "prefabs/01_character/key_character_modules_hoshino/02_pad_equip_slot",                         ---- 平板相关装备槽
        "prefabs/01_character/key_character_modules_hoshino/03_cards_sys",                              ---- 卡牌相关系统
        "prefabs/01_character/key_character_modules_hoshino/04_level_sys",                              ---- 等级系统
        "prefabs/01_character/key_character_modules_hoshino/05_cards_debuff_sys",                       ---- 卡组debuff系统
        "prefabs/01_character/key_character_modules_hoshino/06_armor_item",                             ---- 盔甲物品（用于卡牌的一些护甲参数赋予）

    }
    for k, lua_addr in pairs(modules) do
        local temp_fn = require(lua_addr)
        if type(temp_fn) == "function" then
            temp_fn(inst)
        end
    end


    inst.customidleanim = "idle_wendy"  -- 闲置站立动画
    inst.soundsname = "wendy"           -- 角色声音

    inst:AddTag("hoshino")
    -- inst:AddTag("stronggrip")      --- 不被打掉武器


    if not TheWorld.ismastersim then
        return
    end

    inst.AnimState:AddOverrideBuild("wendy_channel")
    inst.AnimState:AddOverrideBuild("player_idles_wendy")


end