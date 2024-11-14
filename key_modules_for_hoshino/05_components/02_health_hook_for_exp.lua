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

AddComponentPostInit("health", function(self)

    self.inst:ListenForEvent("minhealth",function()
        -----------------------------------------------------------------------------------
        --- 
            local max_health = self.maxhealth
            local x,y,z = self.inst.Transform:GetWorldPosition()
            local percent = self:GetPercent()
            local prefab = self.inst.prefab
            if check_can_broadcast_exp(self.inst,percent) then
                GetTaskInst():DoTaskInTime(0.3,function()  -- 避免克劳斯 这种 半血复活的怪物.延迟一丢丢
                    local players = TheSim:FindEntities(x,y,z,radius,musthavetags,canthavetags,musthaveoneoftags)
                    for _,player in ipairs(players) do
                        player:PushEvent("hoshino_event.exp_broadcast",{
                            prefab = prefab,
                            max_health = max_health,
                            epic = self.inst:HasTag("epic"),
                            target = self.inst,
                        })
                    end
                end)
                --- 屏蔽重复多次获取经验。
                self.inst:AddTag("hoshino_exp_pass")
                self.inst:DoTaskInTime(10,function()
                    self.inst:RemoveTag("hoshino_exp_pass")                    
                end)
            end
        -----------------------------------------------------------------------------------
    end)


end)