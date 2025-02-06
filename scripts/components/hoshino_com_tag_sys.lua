----------------------------------------------------------------------------------------------------------------------------------
--[[

     

]]--
----------------------------------------------------------------------------------------------------------------------------------
---
    local function GetReplica(self)
        return self.inst.replica.hoshino_com_tag_sys or self.inst.replica._.hoshino_com_tag_sys
    end
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_tag_sys = Class(function(self, inst)
    self.inst = inst

    self.tags = {}

end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
---- 发送数据
    function hoshino_com_tag_sys:SentData2Client()       
        local replica_com = GetReplica(self)
        if replica_com then
            replica_com:SendData2Client(self.tags)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
---- 添加/删除
    function hoshino_com_tag_sys:AddTag(tag_name)
        self.tags[tag_name] = true
        self:SentData2Client()
    end
    function hoshino_com_tag_sys:RemoveTag(tag_name)
        self.tags[tag_name] = false
        self:SentData2Client()
    end
------------------------------------------------------------------------------------------------------------------------------
---- HasTag
    function hoshino_com_tag_sys:HasTag(tag_name)
        return self.tags[tag_name] or false
    end
    function hoshino_com_tag_sys:HasOneOfTags(temp,...)
        local _temp_tags = nil
        if type(temp) == "table" then
            _temp_tags = temp
        else
            _temp_tags = {temp,...}
        end

        for _,tag_name in pairs(_temp_tags) do
            if self.tags[tag_name] then
                return true
            end
        end
        return false
    end
------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_tag_sys







