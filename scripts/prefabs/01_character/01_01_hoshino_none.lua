local assets =
{
	Asset( "ANIM", "anim/hoshino.zip" ),
	-- Asset( "ANIM", "anim/hoshino_run.zip" ),
	Asset( "ANIM", "anim/ghost_hoshino_build.zip" ),
	Asset( "ANIM", "anim/hoshino_swimsuit.zip" ),
	Asset( "ANIM", "anim/hoshino_empty_halo.zip" ),
}
local skin_fns = {

	-----------------------------------------------------
		CreatePrefabSkin("hoshino_none",{
			base_prefab = "hoshino",			---- 角色prefab
			skins = {
					normal_skin = "hoshino",					--- 正常外观
					ghost_skin = "ghost_hoshino_build",			--- 幽灵外观
			}, 								
			assets = assets,
			skin_tags = {"BASE" ,"HOSHINO", "CHARACTER"},		--- 皮肤对应的tag
			
			build_name_override = "hoshino",
			rarity = "Character",
		}),
	-----------------------------------------------------
	-----------------------------------------------------
		CreatePrefabSkin("hoshino_swimsuit",{
			base_prefab = "hoshino",			---- 角色prefab
			skins = {
					normal_skin = "hoshino_swimsuit",					--- 正常外观
					ghost_skin = "ghost_hoshino_build",			--- 幽灵外观
			}, 								
			assets = assets,
			skin_tags = {"SWIMSUIT" ,"HOSHINO", "CHARACTER"},		--- 皮肤对应的tag
			
			build_name_override = "hoshino_swimsuit",
			rarity = "Character",
		}),
	-----------------------------------------------------
	-----------------------------------------------------
		-- CreatePrefabSkin("hoshino_skin_flame",{
		-- 	base_prefab = "hoshino",			---- 角色prefab
		-- 	skins = {
		-- 			normal_skin = "hoshino_skin_flame", 		--- 正常外观
		-- 			ghost_skin = "ghost_hoshino_build",			--- 幽灵外观
		-- 	}, 								
		-- 	assets = assets,
		-- 	skin_tags = {"BASE" ,"hoshino_CARL", "CHARACTER"},		--- 皮肤对应的tag
			
		-- 	build_name_override = "hoshino",
		-- 	rarity = "Character",
		-- }),
	-----------------------------------------------------

}

return unpack(skin_fns)