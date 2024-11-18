----------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    反熵水晶殖轮

    材料，向一个有储存空间的容器使用，可以使其变为100%效率反鲜

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------

local assets = {
    Asset("ANIM", "anim/hoshino_item_yi.zip"), 
    Asset( "IMAGE", "images/inventoryimages/hoshino_item_yi.tex" ),  -- 背包贴图
    Asset( "ATLAS", "images/inventoryimages/hoshino_item_yi.xml" ),
}
----------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------
--- item use to
    local function item_use_to_com_install(inst)
        inst:ListenForEvent("HOSHINO_OnEntityReplicated.hoshino_com_item_use_to",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,target,doer,right_click)
                if right_click and target and target.replica.container and not target:HasTag("anti_entropy_crystal_wheel") then
                    return true
                end
                return false
            end)
            replica_com:SetSGAction("dolongaction")
            replica_com:SetText("hoshino_item_anti_entropy_crystal_wheel","升级返鲜")
        end)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("hoshino_com_item_use_to")
        inst.components.hoshino_com_item_use_to:SetActiveFn(function(inst,target,doer)
            inst.components.stackable:Get():Remove()
            print("info start adding debuff hoshino_debuff_anti_entropy_crystal_wheel")
            local test_num = 1000
            local debuff_prefab = "hoshino_debuff_anti_entropy_crystal_wheel"
            while test_num > 0 do
                local debuff_inst = target:GetDebuff(debuff_prefab)
                if debuff_inst and debuff_inst:IsValid() then
                    break
                end
                target:AddDebuff(debuff_prefab,debuff_prefab)
                test_num = test_num - 1
            end
            return true
        end)

    end
----------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity() -- 创建实体
    inst.entity:AddTransform() -- 添加xyz形变对象
    inst.entity:AddAnimState() -- 添加动画状态
    inst.entity:AddNetwork() -- 添加这一行才能让所有客户端都能看到这个实体

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hoshino_item_yi") -- 地上动画
    inst.AnimState:SetBuild("hoshino_item_yi") -- 材质包，就是anim里的zip包
    inst.AnimState:PlayAnimation("idle",true) -- 默认播放哪个动画
    -- inst.AnimState:SetScale(1.5,1.5,1.5)
    -- MakeInventoryFloatable(inst)

    -- inst:AddTag("frozen")   --- 给腐烂组件用的
    -- inst:AddTag("preparedfood")

    inst.entity:SetPristine()
    item_use_to_com_install(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    ------ 物品名 和检查文本
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("leafymeatburger")
        inst.components.inventoryitem.imagename = "hoshino_item_yi"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hoshino_item_yi.xml"
        inst.components.inventoryitem:SetSinks(true)    -- 掉水里消失
    -------------------------------------------------------------------
        inst:AddComponent("stackable") -- 可堆叠
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    -------------------------------------------------------------------
        MakeHauntableLaunch(inst)
    -------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                -- inst.AnimState:Hide("SHADOW")
                -- inst:Remove()
            else                                
                -- inst.AnimState:Show("SHADOW")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    -------------------------------------------------------------------
    
    return inst
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
--- debuff
    local function Attached_Fn(inst,target)  -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(target.entity)
        inst.Network:SetClassifiedTarget(target)
        -----------------------------------------------------
        --- 上tag，避免重复升级
            target:AddTag("anti_entropy_crystal_wheel")
        -----------------------------------------------------
        ---
            inst:DoTaskInTime(3,function()
                if target.components.preserver == nil then
                    target:AddComponent("preserver")
                end
                if target.components.preserver.perish_rate_multiplier == nil then
                    target.components.preserver.perish_rate_multiplier = 1
                end
                --- 直接hook 调取API ，尝试兼容其他MOD。
                local old_GetPerishRateMultiplier = target.components.preserver.GetPerishRateMultiplier
                target.components.preserver.GetPerishRateMultiplier = function(self,...)
                    local old_ret = old_GetPerishRateMultiplier(self,...)
                    if old_ret >= 0 then
                        return -1
                    end
                    --- 尝试兼容其他MOD的 超高 返鲜。
                    if old_ret > -1 then
                        return -1
                    else
                        return old_ret
                    end
                end
            end)
        -----------------------------------------------------
    end
    local function debuff_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        inst:AddTag("CLASSIFIED")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(Attached_Fn)
        inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆

        return inst
    end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
return Prefab("hoshino_item_anti_entropy_crystal_wheel", fn, assets),
    Prefab("hoshino_debuff_anti_entropy_crystal_wheel", debuff_fn, assets)