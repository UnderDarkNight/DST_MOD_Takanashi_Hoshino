--------------------------------------------------------------------------------------------------------------------------------------------------
---- 模块总入口，使用 common_postinit 进行嵌入初始化，注意 mastersim 区分
--------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)

    if TheWorld.ismastersim then
        if inst.components.hoshino_data == nil then
            inst:AddComponent("hoshino_data")
        end
        if inst.components.hoshino_com_rpc_event == nil then
            inst:AddComponent("hoshino_com_rpc_event")
        end
        if inst.components.hoshino_cards_sys == nil and TUNING.HOSHINO_DEBUGGING_MODE then
            inst:AddComponent("hoshino_cards_sys")
        end
    end

    local modules = {
        "prefabs/01_character/key_character_modules_hoshino/01_inventorybar",                           ---- hud修改
        "prefabs/01_character/key_character_modules_hoshino/02_pad_equip_slot",                         ---- 平板相关装备槽

    }
    for k, lua_addr in pairs(modules) do
        local temp_fn = require(lua_addr)
        if type(temp_fn) == "function" then
            temp_fn(inst)
        end
    end


    inst.customidleanim = "idle_wendy"  -- 闲置站立动画
    inst.soundsname = "wendy"           -- 角色声音

    inst:AddTag("hoshino")
    -- inst:AddTag("stronggrip")      --- 不被打掉武器


    if not TheWorld.ismastersim then
        return
    end

    inst.AnimState:AddOverrideBuild("wendy_channel")
    inst.AnimState:AddOverrideBuild("player_idles_wendy")


end