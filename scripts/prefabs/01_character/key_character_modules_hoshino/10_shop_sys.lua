--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    商店系统安装

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddComponent("hoshino_com_shop")

    ---- 加载的时候初始化下发全部数据。
    inst:DoTaskInTime(0,function()
        inst.components.hoshino_com_shop:CreditCoinDelta(0)
    end)

    ---------------------------------------------------------------------------
    --- 【诅咒】【依神紫苑】【你每天至多获得300信用点】【从诅咒池移除】
        local coins_daily_max = 300
        local test_fn = function(com,delta_num)
            if com:Get("card_black_active.max_daily_earn") then
                --- 获取当前的累计量
                local current = com:Add("card_black_active.max_daily_earn.current",0)
                --- 剩余可增加量
                local remain = coins_daily_max - current
                --- 如果剩余可增加量小于0，则返回0
                if remain < 0 then
                    return 0
                end
                --- 如果剩余可增加量小于delta_num，则返回剩余可增加量
                if remain <= delta_num then
                    com:Set("card_black_active.max_daily_earn.current",coins_daily_max)
                    return remain
                end
                --- 否则，返回delta_num
                com:Set("card_black_active.max_daily_earn.current",current + delta_num)
                return delta_num
            end
            return delta_num
        end
        inst:ListenForEvent("card_black_active.max_daily_earn",function(inst)
            inst.components.hoshino_com_shop:SetCreditCoinDeltaFn(test_fn)
            inst.components.hoshino_com_shop:Set("card_black_active.max_daily_earn",true)
        end)
        inst.components.hoshino_com_shop:AddOnLoadFn(function()
            if inst.components.hoshino_com_shop:Get("card_black_active.max_daily_earn") then
                inst.components.hoshino_com_shop:SetCreditCoinDeltaFn(test_fn)
            end
        end)
    ---------------------------------------------------------------------------
end