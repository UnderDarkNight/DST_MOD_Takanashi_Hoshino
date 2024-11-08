--------------------------------------------------------------------------------------------
------ 常用函数放 TUNING 里
--------------------------------------------------------------------------------------------
----- RPC 命名空间
TUNING["hoshino.RPC_NAMESPACE"] = "hoshino_RPC"


--------------------------------------------------------------------------------------------

TUNING["hoshino.fn"] = {}
TUNING["hoshino.fn"].GetStringsTable = function(prefab_name)
    -------- 读取文本表
    -------- 如果没有当前语言的问题，调取中文的那个过去
    -------- 节省重复调用运算处理
    if TUNING["hoshino.fn"].GetStringsTable_last_prefab_name == prefab_name then
        return TUNING["hoshino.fn"].GetStringsTable_last_table or {}
    end


    local LANGUAGE = "ch"
    if type(TUNING["hoshino.Language"]) == "function" then
        LANGUAGE = TUNING["hoshino.Language"]()
    elseif type(TUNING["hoshino.Language"]) == "string" then
        LANGUAGE = TUNING["hoshino.Language"]
    end
    local ret_table = prefab_name and TUNING["hoshino.Strings"][LANGUAGE] and TUNING["hoshino.Strings"][LANGUAGE][tostring(prefab_name)] or nil
    if ret_table == nil and prefab_name ~= nil then
        ret_table = TUNING["hoshino.Strings"]["ch"][tostring(prefab_name)]
    end

    ret_table = ret_table or {}
    TUNING["hoshino.fn"].GetStringsTable_last_prefab_name = prefab_name
    TUNING["hoshino.fn"].GetStringsTable_last_table = ret_table

    return ret_table
end
--------------------------------------------------------------------------------------------

TUNING.HOSHINO_FNS = {}
--------------------------------------------------------------------------------------------
--- 文本参数表
    function TUNING.HOSHINO_FNS:GetString(prefab,index)
        local ret_table = TUNING["hoshino.fn"].GetStringsTable(prefab) or {}
        if index then
            return ret_table[index]
        else
            return ret_table
        end
    end
--------------------------------------------------------------------------------------------
---- 给指定数量的物品（用来减少卡顿）
    function TUNING.HOSHINO_FNS:GiveItemByPrefab(inst,prefab,num)
        -- print("main info hoshino_func:GiveItemByPrefab",prefab,num)
        if type(prefab) ~= "string" or not PrefabExists(prefab) then
            return {}
        end

        num = num or 1
        if num == 1 then
            local item = SpawnPrefab(prefab)
            inst.components.inventory:GiveItem(item)
            return {item}
        end

        local base_item_inst = SpawnPrefab(prefab)
        if not base_item_inst.components.stackable then --- 不可叠堆的物品
            local ret_items_table = {}
            for i = 2, num, 1 do
                local item = SpawnPrefab(prefab)
                inst.components.inventory:GiveItem(item)
                table.insert(ret_items_table,item)
            end
            table.insert(ret_items_table,base_item_inst)
            inst.components.inventory:GiveItem(base_item_inst)
            return ret_items_table
        end
        ---------------------------------- 
        -- 叠堆计算
        local ret_items_table = {}
        local max_stack_num = base_item_inst.components.stackable.maxsize
        local rest_num = math.floor( num % max_stack_num )      --- 不够一组的个数
        local stack_groups = math.floor(   (num - rest_num)/max_stack_num    )  --- 够一组的个数
        if rest_num > 0 then
            base_item_inst.components.stackable.stacksize = rest_num
            inst.components.inventory:GiveItem(base_item_inst)
            table.insert(ret_items_table,base_item_inst)
        else
            base_item_inst:Remove()
        end
        if stack_groups > 0 then
            for i = 1, stack_groups, 1 do
                local items = SpawnPrefab(prefab)
                items.components.stackable.stacksize = max_stack_num
                inst.components.inventory:GiveItem(items)
                table.insert(ret_items_table,items)
            end
        end
        return ret_items_table
    end
--------------------------------------------------------------------------------------------
--- 获取一圈坐标
    function TUNING.HOSHINO_FNS:GetSurroundPoints(CMD_TABLE)
        -- local CMD_TABLE = {
        --     target = inst or Vector3(),
        --     range = 8,
        --     num = 8
        -- }
        if CMD_TABLE == nil then
            return
        end
        if CMD_TABLE.pt then
            CMD_TABLE.target = CMD_TABLE.pt
        end
        local theMid = nil
        if CMD_TABLE.target == nil then
            theMid = Vector3( self.inst.Transform:GetWorldPosition() )
        elseif CMD_TABLE.target.x then
            theMid = CMD_TABLE.target
        elseif CMD_TABLE.target.prefab then
            theMid = Vector3( CMD_TABLE.target.Transform:GetWorldPosition() )
        else
            return
        end
        -- --------------------------------------------------------------------------------------------------------------------
        -- -- 8 points
        -- local retPoints = {}
        -- for i = 1, 8, 1 do
        --     local tempDeg = (PI/4)*(i-1)
        --     local tempPoint = theMidPoint + Vector3( Range*math.cos(tempDeg) ,  0  ,  Range*math.sin(tempDeg)    )
        --     table.insert(retPoints,tempPoint)
        -- end
        -- --------------------------------------------------------------------------------------------------------------------
        local num = CMD_TABLE.num or 8
        local range = CMD_TABLE.range or 8
        local retPoints = {}
        for i = 1, num, 1 do
            local tempDeg = (2*PI/num)*(i-1)
            local tempPoint = theMid + Vector3( range*math.cos(tempDeg) ,  0  ,  range*math.sin(tempDeg)    )
            table.insert(retPoints,tempPoint)
        end

        return retPoints


    end
--------------------------------------------------------------------------------------------
-- 热键
    local keys_by_index  = {
        KEY_A = 97,
        KEY_B = 98,
        KEY_C = 99,
        KEY_D = 100,
        KEY_E = 101,
        KEY_F = 102,
        KEY_G = 103,
        KEY_H = 104,
        KEY_I = 105,
        KEY_J = 106,
        KEY_K = 107,
        KEY_L = 108,
        KEY_M = 109,
        KEY_N = 110,
        KEY_O = 111,
        KEY_P = 112,
        KEY_Q = 113,
        KEY_R = 114,
        KEY_S = 115,
        KEY_T = 116,
        KEY_U = 117,
        KEY_V = 118,
        KEY_W = 119,
        KEY_X = 120,
        KEY_Y = 121,
        KEY_Z = 122,
        KEY_F1 = 282,
        KEY_F2 = 283,
        KEY_F3 = 284,
        KEY_F4 = 285,
        KEY_F5 = 286,
        KEY_F6 = 287,
        KEY_F7 = 288,
        KEY_F8 = 289,
        KEY_F9 = 290,
        KEY_F10 = 291,
        KEY_F11 = 292,
        KEY_F12 = 293,
    }
    local function check_is_text_inputting()    
        -- 代码来自  TheFrontEnd:OnTextInput
        local screen = TheFrontEnd and TheFrontEnd:GetActiveScreen()
        if screen ~= nil then
            if TheFrontEnd.forceProcessText and TheFrontEnd.textProcessorWidget ~= nil then
                return true
            else
                return false
            end
        end
        return false
    end
    function TUNING.HOSHINO_FNS:IsKeyPressed(str_index,key)
        if check_is_text_inputting() then
            return false
        end
        if key == keys_by_index[str_index] then
            return true
        end
        return false
    end
--------------------------------------------------------------------------------------------
-- 声音播放
    local sound_inst = nil
    function TUNING.HOSHINO_FNS:Client_PlaySound(sound_name,flag)
        if sound_inst == nil then
            sound_inst = CreateEntity()
            sound_inst.entity:AddSoundEmitter()
            sound_inst.entity:AddTransform()
        end
        if ThePlayer then
            sound_inst.Transform:SetPosition(ThePlayer.Transform:GetWorldPosition())
        end
        sound_inst.SoundEmitter:PlaySound(sound_name,flag)
    end
    function TUNING.HOSHINO_FNS:Client_KillSound(flag)
        if sound_inst ~= nil and flag then
            sound_inst.SoundEmitter:KillSound(flag)
        end
    end
--------------------------------------------------------------------------------------------
