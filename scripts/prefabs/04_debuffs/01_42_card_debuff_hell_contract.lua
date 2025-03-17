------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【金】【地狱契约】击杀生物时，66%的概率双倍掉落，但是如果未触发则不会产生任何掉落物。
解释：拥有【地狱契约】的玩家攻击生物时会给其上debuff，拥有该debuff的生物死亡会双倍掉落

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local actived_list = {}
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached_For_Monster(inst,monster)        
        -- inst:ListenForEvent("entity_droploot",function(_,_table)
        --     if _table and _table.inst and _table.inst == monster and monster.components.lootdropper 
        --         and (math.random(10000)/10000 <= 0.66 or TUNING.HOSHINO_DEBUGGING_MODE ) 
        --         and not actived_list[monster] then
        --         inst:Remove()
        --         monster.components.lootdropper:DropLoot()
        --         print("【地狱契约】掉落物翻倍",monster)
        --     end
        --     actived_list[monster] = true
        -- end,TheWorld)
        -- print("【地狱契约】debuff 添加成功",monster)
        if actived_list[monster] then
            return
        end
        if inst.components.hoshino_data:Get("result") == nil then
            if math.random(10000)/10000 <= 0.66 or TUNING.HOSHINO_DEBUGGING_MODE then
                inst.components.hoshino_data:Set("result","double")
                print("【地狱契约】掉落物翻倍",monster)
            else
                inst.components.hoshino_data:Set("result","block")
                print("【地狱契约】不掉落任何东西",monster)
            end
        end
        actived_list[monster] = true
        if not monster.components.lootdropper then
            return
        end
        if inst.components.hoshino_data:Get("result") == "block" then
            monster.components.lootdropper:Hoshino_Block()
        else
            inst:ListenForEvent("entity_droploot",function(_,_table)
                if _table and _table.inst and _table.inst == monster then
                    inst:Remove()
                    monster.components.lootdropper:DropLoot()
                    print("【地狱契约】掉落物翻倍",monster)
                end
            end,TheWorld)
        end
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached_For_Player(inst,player)
        inst:ListenForEvent("onhitother",function(_,_table)
            local monster = _table and _table.target
            if monster and monster.sg and monster.brainfn and monster.components.lootdropper then
                monster:AddDebuff("hoshino_card_debuff_hell_contract","hoshino_card_debuff_hell_contract")
            end
        end,player)
        inst:ListenForEvent("killed",function(_,_table)
            local monster = _table and _table.victim
            if monster and monster.sg and monster.brainfn and monster.components.lootdropper 
                and not actived_list[monster] then
                    if (math.random(10000)/10000 <= 0.66 or TUNING.HOSHINO_DEBUGGING_MODE ) then
                        monster.components.lootdropper:DropLoot()
                        print("【地狱契约】掉落物翻倍",monster)
                    else
                        monster.components.lootdropper:Hoshino_Block()
                        print("【地狱契约】不掉落任何东西",monster)
                    end
            end
            actived_list[monster] = true
        end,player)
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0,0,0)
        inst.target = target
        -----------------------------------------------------
        -- 
            if target:HasTag("player") then
                OnAttached_For_Player(inst,target)
            else
                OnAttached_For_Monster(inst,target)
            end
        -----------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function ExtendDebuff(inst)

    end
------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst:AddTag("CLASSIFIED")
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("hoshino_data")
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    return inst
end

return Prefab("hoshino_card_debuff_hell_contract", fn)
