----------------------------------------------------------------------------------------------------------------------------------
--[[

 

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_shop = Class(function(self, inst)
    self.inst = inst

    inst.HOSHINO_SHOP = inst.HOSHINO_SHOP or {}

    if not TheNet:IsDedicated() then
        -----------------------------------------------------------------------------

        -----------------------------------------------------------------------------
        ---- RPC 瞬时批量更新数据。
            inst:ListenForEvent("hoshino_com_shop_rpc_update",function(_,_table)
                _table = _table or {}
                for index, data in pairs(_table) do
                    inst.HOSHINO_SHOP[index] = data
                end
                inst:PushEvent("hoshino_com_shop_client_side_data_updated_for_widget")  --- 给界面数据刷新用
                inst.replica.hoshino_com_rpc_event:PushEvent("hoshino_com_shop_client_side_data_updated") -- 通知服务端、客户端数据已经更新。
            end)
        -----------------------------------------------------------------------------
        ---- 
            
        -----------------------------------------------------------------------------
    end

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
--- 信用点
    function hoshino_com_shop:GetCreditCoins()
        return self.inst.HOSHINO_SHOP.credit_coins or 0
    end
------------------------------------------------------------------------------------------------------------------------------
--- 青辉石
    function hoshino_com_shop:GetBlueSchist()
        return self.inst.HOSHINO_SHOP.blue_schist or 0
    end
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_shop:GetRefreshCount()
        return self.inst.HOSHINO_SHOP.refresh_count or 0
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_shop







