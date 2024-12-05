
if Assets == nil then
    Assets = {}
end

local temp_assets = {


	-- Asset("IMAGE", "images/inventoryimages/hoshino_empty_icon.tex"),
	-- Asset("ATLAS", "images/inventoryimages/hoshino_empty_icon.xml"),
	
	-- Asset("SHADER", "shaders/mod_test_shader.ksh"),		--- 测试用的

	---------------------------------------------------------------------------

	-- Asset("ANIM", "anim/hoshino_hud_wellness.zip"),	--- 体质值进度条
	-- Asset("ANIM", "anim/hoshino_item_medical_certificate.zip"),	--- 诊断单 界面
	-- Asset("ANIM", "anim/hoshino_hud_shop_widget.zip"),	--- 商店界面和按钮



	---------------------------------------------------------------------------
		Asset("ANIM", "anim/hoshino_atk.zip"),	--- 独特枪击动作
	---------------------------------------------------------------------------
	-- Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),	--- 单机声音集
	---------------------------------------------------------------------------
	--- 弱视遮罩
		Asset("IMAGE", "images/widgets/hoshino_amblyopia_mask.tex"),
		Asset("ATLAS", "images/widgets/hoshino_amblyopia_mask.xml"),
	---------------------------------------------------------------------------
	--- 平板电脑相关的素材
		Asset("IMAGE", "images/inspect_pad/inspect_pad.tex"),			--- 平板电脑贴图
		Asset("ATLAS", "images/inspect_pad/inspect_pad.xml"),
		Asset("IMAGE", "images/inspect_pad/page_level_up.tex"),			--- 升级界面贴图
		Asset("ATLAS", "images/inspect_pad/page_level_up.xml"),		
		Asset("IMAGE", "images/inspect_pad/page_character.tex"),		--- 玩家信息界面贴图
		Asset("ATLAS", "images/inspect_pad/page_character.xml"),		
		Asset("IMAGE", "images/inspect_pad/hoshino_pad_spells_icon.tex"),		--- 玩家信息界面 技能贴图
		Asset("ATLAS", "images/inspect_pad/hoshino_pad_spells_icon.xml"),		
		Asset("IMAGE", "images/inspect_pad/page_main.tex"),				--- 主页相关贴图
		Asset("ATLAS", "images/inspect_pad/page_main.xml"),		
		Asset("IMAGE", "images/inspect_pad/special_equipment_recipes.tex"),		--- 特殊装备配方
		Asset("ATLAS", "images/inspect_pad/special_equipment_recipes.xml"),		
		Asset("ANIM", "anim/hoshino_exp_bar.zip"),						--- 经验条
		Asset("ANIM", "anim/hoshino_self_inspect_button_warning.zip"),	--- 自检按钮
	---------------------------------------------------------------------------
	--- 给其他角色的智能手机素材
		Asset("IMAGE", "images/inspect_pad/little_smart_phone.tex"),			--- 智能手机素材
		Asset("ATLAS", "images/inspect_pad/little_smart_phone.xml"),
	---------------------------------------------------------------------------
	--- 无人机控制器素材
		Asset("IMAGE", "images/widgets/hoshino_drone_controller.tex"),			
		Asset("ATLAS", "images/widgets/hoshino_drone_controller.xml"),
	---------------------------------------------------------------------------
	--- 能量条
		Asset("ANIM", "anim/hoshino_power_bar_cost.zip"),	--- COST 能量条
	---------------------------------------------------------------------------
	--- 卡牌正面
		Asset("IMAGE", "images/inspect_pad/card_excample_a.tex"),
		Asset("ATLAS", "images/inspect_pad/card_excample_a.xml"),

		Asset("IMAGE", "images/inspect_pad/card_excample_b.tex"),
		Asset("ATLAS", "images/inspect_pad/card_excample_b.xml"),
		
		Asset("IMAGE", "images/inspect_pad/card_excample_c.tex"),
		Asset("ATLAS", "images/inspect_pad/card_excample_c.xml"),

		Asset("IMAGE", "images/inspect_pad/card_excample_d.tex"),
		Asset("ATLAS", "images/inspect_pad/card_excample_d.xml"),
	---------------------------------------------------------------------------
	--- 技能环素材
		Asset("IMAGE", "images/widgets/hoshino_spell_ring.tex"),
		Asset("ATLAS", "images/widgets/hoshino_spell_ring.xml"),
		Asset("IMAGE", "images/widgets/gesture_bg.tex"),
		Asset("ATLAS", "images/widgets/gesture_bg.xml"),
	---------------------------------------------------------------------------


}

for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end

