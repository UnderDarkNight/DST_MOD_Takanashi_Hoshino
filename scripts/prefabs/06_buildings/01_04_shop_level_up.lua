--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function level_tag_update(inst)
        local current_level = TheWorld.components.hoshino_com_shop_items_pool:GetLevel()
        for i = 0, 10, 1 do
            if current_level == i then
                inst:AddTag("level_"..i)
            else
                inst:RemoveTag("level_"..i)
            end
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_acceptable",function(inst,replica_com)
        replica_com:SetSGAction("give")
        replica_com:SetText("hoshino_building_shop24",STRINGS.ACTIONS.UPGRADE.GENERIC)
        replica_com:SetTestFn(function(inst,item,doer,right_click)
            if item:HasTag("shop_level_setting_item") then
                if inst:HasTag("level_0") and item:HasTag("level_1") then
                    return true
                elseif inst:HasTag("level_1") and item:HasTag("level_2") then
                    return true
                elseif inst:HasTag("level_2") and item:HasTag("level_3") then
                    return true
                end                        
            end
            return false
        end)
    end)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddComponent("hoshino_com_acceptable")
    inst.components.hoshino_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
        inst.components.container:Close()
        if item:HasTag("shop_level_up_item") then
            local current_level = TheWorld.components.hoshino_com_shop_items_pool:GetLevel()
            if inst:HasTag("level_0") and item:HasTag("level_1") then
                TheWorld.components.hoshino_com_shop_items_pool:LevelDoDelta(1)
            elseif inst:HasTag("level_1") and item:HasTag("level_2") then
                TheWorld.components.hoshino_com_shop_items_pool:LevelDoDelta(1)
            elseif inst:HasTag("level_2") and item:HasTag("level_3") then
                TheWorld.components.hoshino_com_shop_items_pool:LevelDoDelta(1)
            end            
        else
            TheWorld.components.hoshino_com_shop_items_pool:LevelSet(0)
        end
        inst:PushEvent("shop24_level_update")
        item:Remove()
        level_tag_update(inst)
        return true
    end)
    inst:DoTaskInTime(0,level_tag_update)

end
