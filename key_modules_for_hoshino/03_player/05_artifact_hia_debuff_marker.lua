-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

		Artifact HIA Debuff Marker

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- AddPlayerPostInit(function(inst)
--     if not TheWorld.ismastersim then
--         return
--     end

-- end)

-- attacker:PushEvent("killed", { victim = self.inst, attacker = attacker })
local killed_event = function(inst,data)
    local target = data and data.victim
    if target and target:HasTag("player") then
        inst:AddDebuff("hoshino_item_artifact_hia_debuff","hoshino_item_artifact_hia_debuff")
    end
end
AddComponentPostInit("combat", function(self)
    self.inst:ListenForEvent("killed",killed_event)
end)