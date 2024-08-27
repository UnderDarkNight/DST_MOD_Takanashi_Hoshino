--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 强制修一些 componentactions.lua 里 崩溃。至于为什么崩溃，不知道。
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




-- local old_UnregisterComponentActions = EntityScript.UnregisterComponentActions
-- EntityScript.UnregisterComponentActions = function(...)
--     -- print("hoshino_test UnregisterComponentActions",...)
--     local crash_flg = pcall(old_UnregisterComponentActions,...)
--     if not crash_flg then
--         print("hoshino error : UnregisterComponentActions",...)
--     end
-- end

if GLOBAL.EntityScript.UnregisterComponentActions_hoshino_old == nil then


    -------------------------------------------------------------------------------------------
    ---- UnregisterComponentActions
        rawset(GLOBAL.EntityScript,"UnregisterComponentActions_hoshino_old",rawget(GLOBAL.EntityScript,"UnregisterComponentActions"))
        rawset(GLOBAL.EntityScript, "UnregisterComponentActions", function(self,...)
                -- print("hoshino_test UnregisterComponentActions",self,...)
            local crash_flg = pcall(self.UnregisterComponentActions_hoshino_old,self,...)
            if not crash_flg then
                print("hoshino error : UnregisterComponentActions",self,...)
            end
        end)
    -------------------------------------------------------------------------------------------
    ---- CollectActions
        rawset(GLOBAL.EntityScript,"CollectActions_hoshino_old",rawget(GLOBAL.EntityScript,"CollectActions"))
        rawset(GLOBAL.EntityScript, "CollectActions", function(self,...)
                -- print("hoshino_test CollectActions",self,...)
            local crash_flg,crash_reason = pcall(self.CollectActions_hoshino_old,self,...)
            if not crash_flg then
                print("hoshino error : CollectActions",self,...)
                print(crash_reason)
            end
        end)







end