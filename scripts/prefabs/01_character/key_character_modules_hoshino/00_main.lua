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
        "prefabs/01_character/key_character_modules_hoshino/07_custom_eater",                           ---- 客制化食物组件
        "prefabs/01_character/key_character_modules_hoshino/08_recipe_builder",                         ---- 配方制作和材料返还
        "prefabs/01_character/key_character_modules_hoshino/09_death_snapshot_protector",               ---- 临死瞬间保护器
        "prefabs/01_character/key_character_modules_hoshino/10_shop_sys",                               ---- 商店系统
        "prefabs/01_character/key_character_modules_hoshino/11_builder_blocker",                        ---- 制作栏制作次数
        "prefabs/01_character/key_character_modules_hoshino/12_sleeping_bag_user",                      ---- 帐篷使用者
        "prefabs/01_character/key_character_modules_hoshino/13_amblyopia_sys",                          ---- 弱视系统
        "prefabs/01_character/key_character_modules_hoshino/14_moisture_hook",                          ---- 潮湿度组件HOOK
        "prefabs/01_character/key_character_modules_hoshino/15_rocky",                                  ---- 石虾

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