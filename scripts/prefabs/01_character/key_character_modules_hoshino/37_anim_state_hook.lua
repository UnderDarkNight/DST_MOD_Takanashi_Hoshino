--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 切换 userdata 成 table
    local function Hook_Player_AnimState(inst)

        if type(inst.AnimState) == "userdata" then            ----- 只能转变一次，重复的操作 会导致  __index 函数错误
            --------------------------------------------------------------------------------------------------------------------------------
                inst.__AnimState_userdata_hoshino = inst.AnimState      ----- 转移复制原有 userdata
                inst.AnimState = {inst = inst , name = "AnimState"}   ----- name 是必须的，用于 从 _G  里 得到目标, 玩家 inst 也是从这里进入
                ------ 逻辑上复现棱镜模组的代码：

                setmetatable( inst.AnimState , {
                    __index = function(_table,fn_name)
                                if _table and _table.inst and _table.name then

                                        if _G[_table.name][fn_name] then    ---- 从_G全局里得到原函数？？这句并不好理解。   ---- lua 会往_G 里自动挂载所有要运行的 userdata ？？
                                            local _table_name = _table.name
                                            local fn = function(temp_table,...)
                                                return _G[_table_name][fn_name](temp_table.inst.__AnimState_userdata_hoshino,...)
                                            end
                                            rawset(_table,fn_name,fn)
                                            return fn
                                        end

                                end
                    end,
                })
            --------------------------------------------------------------------------------------------------------------------------------
        else
            print("warning : ThePlayer.AnimState is already a table ")    
        end

        ------- 成功把  inst.AnimState 从  userdata 变成 table
        --------------------- 挂载函数
        if inst.AnimState.inst ~= inst then
            inst.AnimState.inst = inst
        end
        ---------------------
        print("hoshino hook player AnimState finish")
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function hat_body_hide_api(inst)
                --- 隐藏帽子/衣服
        -------------------------------------------------
        --- 清除帽子的API
            if TUNING["hoshino.Config"].HIDE_HAT then

                            local function ClearHat(hat_inst)
                                local owner = inst
                                if hat_inst then
                                    -- local skin_build = hat_inst:GetSkinBuild()
                                    -- if skin_build ~= nil then
                                    --     owner:PushEvent("unequipskinneditem", hat_inst:GetSkinName())
                                    -- end

                                    owner.AnimState:ClearOverrideSymbol("headbase_hat") --it might have been overriden by _onequip
                                    if owner.components.skinner ~= nil then
                                        owner.components.skinner.base_change_cb = owner.old_base_change_cb
                                    end


                                    owner.AnimState:ClearOverrideSymbol("swap_hat")
                                    owner.AnimState:Hide("HAT")
                                    owner.AnimState:Hide("HAIR_HAT")
                                    owner.AnimState:Show("HAIR_NOHAT")
                                    owner.AnimState:Show("HAIR")

                                    if owner:HasTag("player") then
                                        owner.AnimState:Show("HEAD")
                                        owner.AnimState:Hide("HEAD_HAT")
                                        owner.AnimState:Hide("HEAD_HAT_NOHELM")
                                        owner.AnimState:Hide("HEAD_HAT_HELM")
                                    end
                                    
                                end
                            end
                            inst:ListenForEvent("hoshino_event.clear_hat",function()
                                local hat_inst = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                                ClearHat(hat_inst)
                            end)

                            inst:ListenForEvent("equip",function()
                                inst:PushEvent("hoshino_event.clear_hat")
                            end)
                            inst:PushEvent("hoshino_event.clear_hat")   --- 初始化的时候

            end
        -------------------------------------------------
        ---- 衣服  OverrideSymbol OverrideItemSkinSymbol
            if TUNING["hoshino.Config"].HIDE_CLOTHS then
                            ---- 屏蔽穿脱盔甲、项链
                            local function need_2_clear_body_layer(tar_layer,build,the_layer)
                                if  tar_layer == "swap_body" or tar_layer == "swap_body_tall" or (tar_layer==nil and  build == nil and the_layer == nil) then
                                        -------------------------------------------------------
                
                                        -------------------------------------------------------
                                        ----- 背重物
                                            if inst.replica.inventory:IsHeavyLifting() then
                                                -- print("heavylifting",build)
                                                return false
                                            end
                                        ------------------------------------------------------- 
                                        -------------------------------------------------------
                                        --- 蜗牛壳
                                            if inst.replica.inventory:EquipHasTag("shell") then
                                                return false
                                            end
                                        -------------------------------------------------------
                                        --- 鼓
                                            if inst.replica.inventory:EquipHasTag("band") then
                                                return false
                                            end
                                        -------------------------------------------------------
                                        -------------------------------------------------------
                                        return true
                
                                end
                                return false
                            end

                                local old_OverrideSymbol = inst.AnimState.OverrideSymbol
                                inst.AnimState.OverrideSymbol = function(self,tar_layer,build,the_layer)                            
                                    old_OverrideSymbol(self,tar_layer,build,the_layer)
                                    inst:DoTaskInTime(0,function()
                                        if need_2_clear_body_layer(tar_layer,build,the_layer) then
                                            inst:PushEvent("hoshino_event.clear_body")
                                        end
                                    end)
                                end

                                local old_OverrideItemSkinSymbol = inst.AnimState.OverrideItemSkinSymbol
                                inst.AnimState.OverrideItemSkinSymbol = function(self,tar_layer,skin_build,...)                            
                                    old_OverrideItemSkinSymbol(self,tar_layer,skin_build,...)
                                    inst:DoTaskInTime(0,function()
                                        if need_2_clear_body_layer(tar_layer,skin_build) then
                                            inst:PushEvent("hoshino_event.clear_body")
                                        end
                                    end)
                                end
                            ----- 监听事件和清除
                                inst:ListenForEvent("hoshino_event.clear_body",function()
                                        inst.AnimState:ClearOverrideSymbol("swap_body")
                                        inst.AnimState:ClearOverrideSymbol("swap_body_tall")
                                end)
                            ----- 初始化的时候检查 
                                if need_2_clear_body_layer() then
                                    inst:PushEvent("hoshino_event.clear_body")
                                end
            end
        -------------------------------------------------
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:DoTaskInTime(0,function()
        Hook_Player_AnimState(inst)
        hat_body_hide_api(inst)
    end)
end