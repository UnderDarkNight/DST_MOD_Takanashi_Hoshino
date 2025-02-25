

local function fxfn(name, bank, build, anim, fn)
	return Prefab(name, function()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.AnimState:SetBank(bank)
		inst.AnimState:SetBuild(build)
		inst.AnimState:PlayAnimation(anim)
		
		if fn then
			fn(inst)
		end
		inst:ListenForEvent("animover", inst.Remove)
		return inst
	end)
end

return fxfn("fx_hoshino_hammer_hit_ground","fx_hoshino_hammer_hit_ground","fx_hoshino_hammer_hit_ground", "0", nil),

fxfn("fx_hoshino_hammer_hit","fx_hoshino_hammer_hit","fx_hoshino_hammer_hit", "0",nil)

