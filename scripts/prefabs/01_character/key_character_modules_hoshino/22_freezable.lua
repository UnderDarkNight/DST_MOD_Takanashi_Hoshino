--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:ListenForEvent("master_postinit_hoshino",function()
        

        if inst.components.freezable == nil then
            return
        end

        inst:AddComponent("hoshino_com_freezable_hooker")

        local old_AddColdness = inst.components.freezable.AddColdness
        inst.components.freezable.AddColdness = function(self,coldness, freezetime, nofreeze,...)
            coldness, freezetime, nofreeze = self.inst.components.hoshino_com_freezable_hooker:AddColdness_Pre_Active(coldness, freezetime, nofreeze)
            return old_AddColdness(self,coldness, freezetime, nofreeze,...)
        end

    end)
end