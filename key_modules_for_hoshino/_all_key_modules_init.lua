-- -- -- 这个文件是给 modmain.lua 调用的总入口
-- -- -- 本lua 和 modmain.lua 平级
-- -- -- 子分类里有各自的入口
-- -- -- 注意文件路径


modimport("key_modules_for_hoshino/00_others/__all_others_init.lua") 
-- 难以归类的杂乱东西

modimport("key_modules_for_hoshino/01_character/__all_character_modules_init.lua") 
-- 角色模块

modimport("key_modules_for_hoshino/02_theworld/__all_theworld_init.lua") 
-- 世界模块更新

modimport("key_modules_for_hoshino/03_player/__all_player_init.lua") 
-- 所有玩家通用更新

modimport("key_modules_for_hoshino/04_other_prefabs/__all_other_prefabs_init.lua") 
-- 所有玩家通用更新

modimport("key_modules_for_hoshino/05_components/__all_com_init.lua") 
-- 官方组件 更新器

modimport("key_modules_for_hoshino/06_inspect_pad/__inspect_pad_init.lua") 
-- 角色平板电脑

modimport("key_modules_for_hoshino/07_actions/__all_actions_init.lua") 
-- sg 和 com交互集中注册

modimport("key_modules_for_hoshino/08_cards/__all_cards_init.lua") 
-- 所有卡牌

modimport("key_modules_for_hoshino/09_widgets/__all_widget_init.lua") 
-- 界面相关的组件和修改

modimport("key_modules_for_hoshino/10_shop_items_pool/__shop_items_pool_init.lua") 
-- 商品物品数据池。

modimport("key_modules_for_hoshino/11_recipes/__all_recipes_init.lua") 
-- 物品合成配方

modimport("key_modules_for_hoshino/12_active_item_cursor_sight/__all_active_item_cursor_sight_init.lua") 
-- 鼠标物品施法指示器

modimport("key_modules_for_hoshino/23_mission_shop_level_sys_for_other_player/__mission_shop_level_init.lua") 
-- 任务、货币、商店、等级 系统 安装给其他玩家


