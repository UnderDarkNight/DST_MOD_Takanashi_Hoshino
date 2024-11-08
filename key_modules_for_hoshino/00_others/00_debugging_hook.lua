
if not TUNING.HOSHINO_DEBUGGING_MODE then
    return
end
local temp_DebugSpawn = rawget(_G,"DebugSpawn")
local function new_debug_fn(str,...)
    print("DebugSpawn: ",str)
    local other_args = {...}
    if type(other_args[1]) == "number" then
        for i = 1, other_args[1], 1 do
            local ret = temp_DebugSpawn(str,...)
            if i == other_args[1] then
                return ret
            end
        end
    else        
        return temp_DebugSpawn(str,...)
    end
end
rawset(_G,"D",new_debug_fn)
rawset(_G,"d",new_debug_fn)
rawset(_G,"reload",rawget(_G,"c_reset"))