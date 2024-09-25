--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    鞋子 T1 - T9 

    每一级都有上一级的功能。




    相关API:

        owner.components.locomotor:SetExternalSpeedMultiplier(inst,"hoshino_special_equipment_shoes_t1",1.05)
        owner.components.locomotor:RemoveExternalSpeedMultiplier(inst,"hoshino_special_equipment_shoes_t1")

    1：移动速度+5%

    2：保暖+120，san+6，移动速度+10%

    3：免疫雷电，免疫麻痹，基础攻击伤害+15%

    4：免疫火焰伤害，移动速度+10%

    5：受到攻击时令攻击来源减少70%的移动速度，持续10s。

    6：无视地形，并且可以在水面和虚空行走，移动速度+10%

    7：这个无视碰撞体积意思为无视各种建筑的碰撞体积（比如可以穿过石墙），也无视织影者骨牢这种

    8：100%防水，移动速度+10%，免疫滑倒

    9：移动速度+20%，免疫地洞减速，免疫虚弱（吃月亮蘑菇引起那个）。

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)
    inst.level = math.clamp(inst.level or 1,1,9)


end