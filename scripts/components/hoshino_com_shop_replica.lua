----------------------------------------------------------------------------------------------------------------------------------
--[[

 

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_shop = Class(function(self, inst)
    self.inst = inst

    inst.HOSHINO_SHOP = inst.HOSHINO_SHOP or {}

    self.__coins = net_uint(inst.GUID,"hoshino_com_shop.coins","hoshino_com_shop_net_update")
    if not TheNet:IsDedicated() then
        -----------------------------------------------------------------------------
        --- net_vars 更新。
            inst:ListenForEvent("hoshino_com_shop_net_update",function()
                inst.HOSHINO_SHOP.coins = self.__coins:value()
            end)
        -----------------------------------------------------------------------------
        ---- RPC 瞬时批量更新数据。
            inst:ListenForEvent("hoshino_com_shop_rpc_update",function(_,_table)
                _table = _table or {}
                for index, data in pairs(_table) do
                    inst.HOSHINO_SHOP[index] = data
                end
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
---
    function hoshino_com_shop:SetCoins(value)
        self.__coins:set(value)
    end
    function hoshino_com_shop:GetCoins()
        return self.__coins:value()
    end
    function hoshino_com_shop:GetRefreshCount()
        return self.inst.HOSHINO_SHOP.refresh_count or 0
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_shop







