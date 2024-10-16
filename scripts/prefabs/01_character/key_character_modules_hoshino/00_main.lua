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
        "prefabs/01_character/key_character_modules_hoshino/16_health_hook",                            ---- health组件HOOK
        "prefabs/01_character/key_character_modules_hoshino/17_combat_hook",                            ---- combat组件HOOK
        "prefabs/01_character/key_character_modules_hoshino/18_the_camera",                             ---- TheCamera HOOK
        "prefabs/01_character/key_character_modules_hoshino/19_special_equipment_hotkey_listener",      ---- 特殊装备快捷键
        "prefabs/01_character/key_character_modules_hoshino/20_custom_tag_sys",                         ---- 客制化tag组件
        "prefabs/01_character/key_character_modules_hoshino/21_special_equipment_tag_sys",              ---- 特殊装备tag系统
        "prefabs/01_character/key_character_modules_hoshino/22_freezable",                              ---- 冰冻控制器
        "prefabs/01_character/key_character_modules_hoshino/23_debuff_blocker",                         ---- 官方的debuff 屏蔽器
        "prefabs/01_character/key_character_modules_hoshino/24_power_bar_cost_hud_install",             ---- cost 能量条 HUD
        "prefabs/01_character/key_character_modules_hoshino/25_cost_power_module_install",              ---- cost 能量条 模块安装等
        "prefabs/01_character/key_character_modules_hoshino/26_gun_eye_of_horus",                       ---- 枪械的范围攻击
        "prefabs/01_character/key_character_modules_hoshino/27_gun_eye_of_horus_ex_spell",              ---- 枪械的范围攻击（ex技能）
        "prefabs/01_character/key_character_modules_hoshino/28_player_reroll_data_save",                ---- 重选玩家保存数据。
        "prefabs/01_character/key_character_modules_hoshino/29_preserver",                              ---- 食物保鲜器
        "prefabs/01_character/key_character_modules_hoshino/30_spell_cd_com_installer",                 ---- 统一CD计时器 安装器
        "prefabs/01_character/key_character_modules_hoshino/31_spell_type_swticher",                    ---- 玩家技能类型切换器（pad 切换那个）
        "prefabs/01_character/key_character_modules_hoshino/32_spell_ring_hud_install",                 ---- 技能环的UI安装器(监听+布局)
        "prefabs/01_character/key_character_modules_hoshino/33_spell_ring_spells_code",                 ---- 技能环的技能。
        "prefabs/01_character/key_character_modules_hoshino/34_task_sys_install",                       ---- 任务系统安装器

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