---------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
---------------------------------------------------------------------------------------------------------------------------------------------------------------
TUNING.HOSHINO_PARAMS = {}  -- 這裡放hoshino的參數
---------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- 這裡放hoshino的技能參數
    TUNING.HOSHINO_PARAMS.SPELLS = {}
    -- 【普通模式】枪，EX技能
    TUNING.HOSHINO_PARAMS.SPELLS.GUN_EYE_OF_HORUS_EX_CD = 20    -- cd时间
    TUNING.HOSHINO_PARAMS.SPELLS.GUN_EYE_OF_HORUS_EX_COST = 4   -- 消耗
    TUNING.HOSHINO_PARAMS.SPELLS.GUN_EYE_OF_HORUS_EX_MOUSE_OVER_TEXT = "对前方大范围敌人造成多次真伤，并摧毁树木，矿石等（不破坏玩家建筑） 4cost  cd:20s"
    -- 【普通模式】疗愈
    TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_HEAL_CD = 3*60        -- cd时间
    TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_HEAL_COST = 5       -- 消耗
    TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_HEAL_BUFF_REMAIN_TIME = 30  -- buff持续时间
    TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_HEAL_BUFF_HEAL_PERCENT_PRE_SECOND = 0.04 -- 每秒回血百分比
    TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_HEAL_MOUSE_OVER_TEXT = "在30秒内每秒回复自身4%的生命值。5cost  cd 3min"
    -- 【普通模式】隐秘行动
    TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_COVERT_OPERATION_CD = 8*60      -- cd时间
    TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_COVERT_OPERATION_COST = 4       -- 消耗
    TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_COVERT_OPERATION_BUFF_REMAIN_TIME = 1*60  -- buff持续时间
    TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_COVERT_OPERATION_MOUSE_OVER_TEXT = "60s内自身不会被仇恨，即便产生仇恨也会迅速消除 4cost  cd:8min"
    -- 【普通模式】突破
    TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_BREAKTHROUGH_CD = 0 -- cd时间
    TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_BREAKTHROUGH_COST = 1   -- 消耗
    TUNING.HOSHINO_PARAMS.SPELLS.NORMAL_BREAKTHROUGH_MOUSE_OVER_TEXT = "瞬移至指定位置，对一定范围内敌方单位造成正比于生命上限和san上限的伤害 1cost 无cd"
    -- 【游泳模式】EX支援
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_EX_SUPPORT_CD = 60    -- cd时间
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_EX_SUPPORT_COST = 5   -- 消耗
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_EX_SUPPORT_MOUSE_OVER_TEXT = "赋予以自身为中心的圆形范围内友方单位攻击力，移速加成和生命恢复，自身cost恢复速率上升 5cost  cd:60s"
    -- 【游泳模式】高效作业
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_EFFICIENT_WORK_CD = 5*60 -- cd时间
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_EFFICIENT_WORK_COST = 3 -- 消耗
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_EFFICIENT_WORK_BUFF_REMAIN_TIME = 5*60  -- buff持续时间
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_EFFICIENT_WORK_MOUSE_OVER_TEXT = "5min内，获得快速采集，制作的效果，工作效率+100%，3cost cd：5min"
    -- 【游泳模式】紧急支援
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_EMERGENCY_ASSISTANCE_CD = 0   -- cd时间
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_EMERGENCY_ASSISTANCE_COST = 4 -- 消耗
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_EMERGENCY_ASSISTANCE_MOUSE_OVER_TEXT = "使用后选择一个其他玩家，选择后可以瞬移至他的位置。4cost 无cd。"
    -- 【游泳模式】晓之荷鲁斯
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_DAWN_OF_HORUS_CD = 10*60  -- cd时间
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_DAWN_OF_HORUS_COST = 6 -- 消耗
    TUNING.HOSHINO_PARAMS.SPELLS.SWIMMING_DAWN_OF_HORUS_MOUSE_OVER_TEXT = "技能范围内的所有可被雇佣单位被永久雇佣，被雇佣的单位获得永久buff：80%减伤且每秒恢复3生命。6cost  cd:10min"
---------------------------------------------------------------------------------------------------------------------------------------------------------------