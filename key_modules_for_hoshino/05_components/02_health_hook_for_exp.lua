------------------------------------------------------------------------------------------------------------------------------------
--[[

    经验广播事件。

]]--
------------------------------------------------------------------------------------------------------------------------------------

local temp_inst = nil
local function GetTaskInst()
    if temp_inst == nil then
        temp_inst = CreateEntity()
    end
    return temp_inst
end

local musthavetags = {"player","hoshino_com_level_sys"}
local canthavetags = {"playerghost"}
local musthaveoneoftags = nil
local radius = 20
local radius_sq = radius*radius

---------------------------------------------------------------------------------------------------------
local prefab_black_list = {
    ["killerbee"] = true, -- 杀人蜂
    ["abigail"] = true, -- 阿比盖尔
}
local function check_can_broadcast_exp(inst,percent)
    if inst.sg == nil then
        return false
    end
    if inst:HasOneOfTags({"player","hoshino_exp_pass"}) then
        return false
    end
    if prefab_black_list[inst.prefab] then
        return false
    end
    if percent > 0.1 then
        return false
    end
    return true
end
---------------------------------------------------------------------------------------------------------
-- 延迟广播经验
local exp_broadcast_delay = {
    ["klaus"] = 10, -- 克劳斯
}
---------------------------------------------------------------------------------------------------------

AddComponentPostInit("health", function(self)

    self.inst:ListenForEvent("minhealth",function(_,_table)
        local x,y,z = self.inst.Transform:GetWorldPosition()
        local players = TheSim:FindEntities(x,y,z,radius,musthavetags,canthavetags,musthaveoneoftags)
        GetTaskInst():DoTaskInTime(exp_broadcast_delay[self.inst.prefab] or 0.3,function()  -- 避免克劳斯 这种 半血复活的怪物.延迟一丢丢
        -----------------------------------------------------------------------------------
        --- 
            local max_health = self.maxhealth
            local percent = self:GetPercent()
            local prefab = self.inst.prefab
            if check_can_broadcast_exp(self.inst,percent) then
                    for _,player in ipairs(players) do
                        player:PushEvent("hoshino_event.exp_broadcast",{
                            prefab = prefab,
                            max_health = max_health,
                            epic = self.inst:HasTag("epic"),
                            target = self.inst,
                            cause = _table and _table.cause,
                        })
                    end
                --- 屏蔽重复多次获取经验。
                self.inst:AddTag("hoshino_exp_pass")
                self.inst:DoTaskInTime(100,function()
                    self.inst:RemoveTag("hoshino_exp_pass")                    
                end)
            end
        -----------------------------------------------------------------------------------
        end)
    end)


end)


-- AddPrefabPostInit(
--     "world",
--     function(inst)
--         if not TheWorld.ismastersim then
--             return
--         end


--         TheWorld:ListenForEvent("entity_droploot",function(_,_table)
        
--             pcall(function()
                
--                         local monster = _table and _table.inst

--                         local health_com = monster.components.health

--                         local max_health = health_com.maxhealth
--                         local percent = health_com:GetPercent()
--                         local prefab = monster.prefab
--                         print("percent",percent,check_can_broadcast_exp(monster,percent))
--                         if check_can_broadcast_exp(monster,percent) then
--                             for k, player in pairs(AllPlayers) do
--                                 if player and monster:GetDistanceSqToInst(player) <= radius_sq then
--                                         player:PushEvent("hoshino_event.exp_broadcast",{
--                                             prefab = prefab,
--                                             max_health = max_health,
--                                             epic = self.inst:HasTag("epic"),
--                                             target = self.inst,
--                                         })

--                                 end
--                             end
--                             --- 屏蔽重复多次获取经验。
--                             monster:AddTag("hoshino_exp_pass")
--                             monster:DoTaskInTime(10,function()
--                                 monster:RemoveTag("hoshino_exp_pass")                    
--                             end)

--                         end
--             end)        
--         end)

--     end
-- )
