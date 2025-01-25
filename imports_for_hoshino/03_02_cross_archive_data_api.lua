--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    跨存档数据储存


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    -- local function IsClientSide()
    --     if TheNet:IsDedicated() then
    --         return false
    --     end
    --     return true
    -- end

    -- --- 基础的文件读写函数
    -- local fileName = "hoshino_data.text" -- 文件名缓存

    -- -- 文件句柄缓存
    -- local fileHandle = nil

    -- local function OpenFile(mode)
    --     if fileHandle == nil then
    --         fileHandle = io.open(fileName, mode)
    --     end
    --     return fileHandle
    -- end

    -- local function CloseFile()
    --     if fileHandle ~= nil then
    --         fileHandle:close()
    --         fileHandle = nil
    --     end
    -- end

    -- local function Read_All_Json_Data()
    --     local file = OpenFile("r")
    --     if file then
    --         local text = file:read('*a') -- 读取全部内容而不是单行
    --         CloseFile()
    --         return text and json.decode(text) or {}
    --     else
    --         print("Failed to open file for reading.")
    --         return {}
    --     end
    -- end

    -- local function Write_All_Json_Data(json_data)
    --     if IsClientSide() then
    --         local file = OpenFile("w")
    --         if file then
    --             local w_data = json.encode(json_data)
    --             file:write(w_data)
    --             CloseFile()
    --         else
    --             print("Failed to open file for writing.")
    --         end
    --     end
    -- end

    -- local function Get_Cross_Archived_Data_By_userid(userid)
    --     local crash_flag , all_data_table = pcall(Read_All_Json_Data)
    --     if crash_flag then
    --         local temp_json_data = all_data_table
    --         return temp_json_data[userid] or {}
    --     else
    --         print("error : Read_All_Json_Data fn crash")
    --         return {}
    --     end
    -- end

    -- local function Set_Cross_Archived_Data_By_userid(userid,_table)
    --     if not IsClientSide() then  --- 只在客户端这一侧执行数据写入
    --         return
    --     end

    --     local temp_json_data = Read_All_Json_Data() or {}
    --     -- temp_json_data[userid] = _table
    --     temp_json_data[userid] = temp_json_data[userid] or {}
    --     for index, value in pairs(_table) do
    --         temp_json_data[userid][index] = value
    --     end
    --     temp_json_data = deepcopy(temp_json_data)
    --     -- Write_All_Json_Data(temp_json_data)
    --     pcall(Write_All_Json_Data,temp_json_data)
    -- end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local data_sheet_index = "hoshino_client_side_data_sheet" -- 存档数据表索引
    local function GetData(index,default)
        local data = {}
        TheSim:GetPersistentString(data_sheet_index, function(load_success, str_data)
            if load_success and str_data then
                local crash_flag,temp_data = pcall(json.decode,str_data)
                if crash_flag then
                    data = temp_data
                end
            end
        end)
        return data[index] or default
    end
    local function SetData(index,value)
        local data = {}
        TheSim:GetPersistentString(data_sheet_index, function(load_success, str_data)
            if load_success and str_data then
                local crash_flag,temp_data = pcall(json.decode,str_data)
                if crash_flag then
                    data = temp_data
                end
            end
        end)
        data[index] = value
        local str = json.encode(data)
        TheSim:SetPersistentString(data_sheet_index, str, false, function()
            print("info hoshino_client_side_data_sheet SAVED!")
        end)
    end
    local function Get_Cross_Archived_Data_By_userid(userid)
        return GetData(userid) or {}
    end

    local function Set_Cross_Archived_Data_By_userid(userid,_table)
        SetData(userid,_table)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TUNING.HOSHINO_FNS = TUNING.HOSHINO_FNS or {}

function TUNING.HOSHINO_FNS:Get_Cross_Archived_Data_By_userid(userid)
    return Get_Cross_Archived_Data_By_userid(userid) or {}
end
function TUNING.HOSHINO_FNS:Set_Cross_Archived_Data_By_userid(userid,_table) 
    Set_Cross_Archived_Data_By_userid(userid,_table) 
end
function TUNING.HOSHINO_FNS:Set_ThePlayer_Cross_Archived_Data(index,value)
    if ThePlayer and ThePlayer.userid then
        local all_data = TUNING.HOSHINO_FNS:Get_Cross_Archived_Data_By_userid(ThePlayer.userid) or {}
        all_data[index] = value
        TUNING.HOSHINO_FNS:Set_Cross_Archived_Data_By_userid(ThePlayer.userid,all_data)
    end
end
function TUNING.HOSHINO_FNS:Get_ThePlayer_Cross_Archived_Data(index)
    if ThePlayer and ThePlayer.userid then
        local all_data = TUNING.HOSHINO_FNS:Get_Cross_Archived_Data_By_userid(ThePlayer.userid)
        return all_data[index] or {}
    end
    return {}
end
