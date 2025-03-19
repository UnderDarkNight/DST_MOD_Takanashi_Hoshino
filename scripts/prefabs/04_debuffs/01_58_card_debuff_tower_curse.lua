------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【诅咒】【塔之诅咒】受伤时会随机在半径15码范围内生成6个点燃的火药

]]--
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function combine_tables(...)
        local args = {...}
        local result = {}
        for i,t in ipairs(args) do
            for j,v in ipairs(t) do
                table.insert(result,v)
            end
        end
        return result
    end
------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function OnAttached(inst,player) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
        inst.entity:SetParent(player.entity)
        -- inst.Network:SetClassifiedTarget(player)
        inst.Transform:SetPosition(0,0,0)
        inst.player = player        
        -----------------------------------------------------
        ---
            inst:ListenForEvent("attacked",function()
                local x,y,z = player.Transform:GetWorldPosition()
                local pos_tables = {}
                for i= 3,15,3 do
                    local temp_points = TUNING.HOSHINO_FNS:GetSurroundPoints({
                        target = player,
                        range = i,
                        num = 8*i,
                    })
                    table.insert(pos_tables,temp_points)
                end
                local points = combine_tables(unpack(pos_tables))
                --- 抽取不同的随机6个点
                local ret_points = {}
                for i=1,6 do
                    local index = math.random(1,#points)
                    table.insert(ret_points,points[index])
                    table.remove(points,index)
                    if #points == 0 then
                        break
                    end
                end
                for i,pos in ipairs(ret_points) do
                    local item = SpawnPrefab("gunpowder")
                    item.Transform:SetPosition(pos.x,0,pos.z)
                    item.components.burnable:Ignite()
                end
            end,player)
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
    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = true -- 是否保持debuff 到下次登陆
    inst.components.debuff:SetExtendedFn(ExtendDebuff)
    inst.components.debuff:SetDetachedFn(inst.Remove)

    return inst
end

return Prefab("hoshino_card_debuff_tower_curse", fn)
