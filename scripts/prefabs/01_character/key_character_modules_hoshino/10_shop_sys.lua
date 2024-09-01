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
        inst.components.hoshino_com_shop:CoinDelta(0)
    end)

end