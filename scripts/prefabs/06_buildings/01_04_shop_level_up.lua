--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_acceptable",function(inst,replica_com)
        replica_com:SetSGAction("give")
        replica_com:SetText("hoshino_building_shop24",STRINGS.ACTIONS.UPGRADE.GENERIC)
        replica_com:SetTestFn(function(inst,item,doer,right_click)
            if item:HasTag("shop_level_setting_item") then
                return true
            end
            return false            
        end)
    end)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("hoshino_com_acceptable")
    inst.components.hoshino_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
        if item:HasTag("shop_level_up_item") then
            TheWorld.components.hoshino_com_shop_items_pool:LevelDoDelta(1)
        else
            TheWorld.components.hoshino_com_shop_items_pool:LevelSet(0)
        end
        item:Remove()
        return true
    end)

end
