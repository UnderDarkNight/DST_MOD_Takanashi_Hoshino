--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    本文件和 modmain.lua 平级。
    本文件集中注册  components 及其 replica 组件

    特别说明: components 组件不必注册，放到  /script/components 文件夹里就行了。但是这个组件只能 服务器调用（包括带洞穴的存档）
    组件对应的客户端组件 为 replica ，命名方式为：组件原名后面加上“_replica”
    replica 组件必须用 函数 AddReplicableComponent 注册，参数为 组件原名（不带“_replica")
    示例：  inst.components.abcd  组件， 放置  abcd.lua 文件在   components 文件夹里，使用 inst:AddComponent("abcd") 添加。
            对应的replica 文件为   abcd_replica.lua，同样放在   components 文件夹里，必须使用 AddReplicableComponent("abcd") 在 modmain 注册
            客户端使用  inst.replica.abcd 调用 ，相关参数匹配同步 参照官方 已有组件。
        注意： replica 参数传送有一定的延迟，即便是在本机洞穴存档（开启延迟补偿），低延迟方案则必须走 RPC通道

    AddReplicableComponent("npc_base_lib")  --- 示例

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddReplicableComponent("hoshino_com_rpc_event")  --- RPC通道
AddReplicableComponent("hoshino_com_workable")  --- 通用workable组件
AddReplicableComponent("hoshino_com_acceptable")  --- 通用acceptable组件
AddReplicableComponent("hoshino_com_item_use_to")  --- 通用给予组件

AddReplicableComponent("hoshino_com_level_sys")  --- 等级系统组件
AddReplicableComponent("hoshino_cards_sys")  --- 卡牌系统
AddReplicableComponent("hoshino_com_shop")  --- 商店系统

AddReplicableComponent("hoshino_com_builder_blocker")  --- 制作栏屏蔽组件
AddReplicableComponent("hoshino_com_tag_sys")  --- 自制tag系统

AddReplicableComponent("hoshino_com_power_cost")  --- 能量条系统

AddReplicableComponent("hoshino_com_point_and_target_spell_caster")  --- 通用 点/目标 施法器

AddReplicableComponent("hoshino_com_spell_cd_timer")  --- 统一技能CD计时器

AddReplicableComponent("hoshino_com_item_spell")  --- 物品技能控制器

AddReplicableComponent("hoshino_com_task_sys_for_player")  --- 任务系统
AddReplicableComponent("hoshino_com_task_sys_for_building")  --- 任务系统

AddReplicableComponent("hoshino_com_polymorphic_attack_action")  --- 多态攻击动作



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---

    if EntityScript.ReplicateComponent_hoshino_old_fn == nil then

        -- EntityScript.ReplicateComponent
        EntityScript.ReplicateComponent_hoshino_old_fn = EntityScript.ReplicateComponent
        EntityScript.ReplicateComponent = function(self,name)
            self.ReplicateComponent_hoshino_old_fn(self,name)
            local replica_com = self.replica[name] or self.replica._[name]
            if replica_com then
                self:PushEvent("HOSHINO_OnEntityReplicated."..tostring(name),replica_com)
                self.replica[name] = replica_com
            end
        end

    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------