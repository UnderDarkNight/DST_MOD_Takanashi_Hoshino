-- -- -- 这个文件是给 modmain.lua 调用的总入口
-- -- -- 本lua 和 modmain.lua 平级
-- -- -- 子分类里有各自的入口
-- -- -- 注意文件路径


modimport("key_modules_for_hoshino/00_others/__all_others_init.lua") 
-- 难以归类的杂乱东西

modimport("key_modules_for_hoshino/01_character/__all_character_modules_init.lua") 
-- 角色模块

modimport("key_modules_for_hoshino/06_inspect_pad/__inspect_pad_init.lua") 
-- 角色平板电脑

modimport("key_modules_for_hoshino/07_actions/__all_actions_init.lua") 
-- sg 和 com交互集中注册

modimport("key_modules_for_hoshino/08_cards/__all_cards_init.lua") 
-- 所有卡牌


