--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    暂时用不上的声音
        hoshino_sound/hoshino_sound/drown_in_water
        hoshino_sound/hoshino_sound/feel_sleepy
        hoshino_sound/hoshino_sound/pose
        hoshino_sound/hoshino_sound/ghost_1
        hoshino_sound/hoshino_sound/ghost_2
        hoshino_sound/hoshino_sound/ghost_3
        hoshino_sound/hoshino_sound/ghost_4
        hoshino_sound/hoshino_sound/ghost_5

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- PlaySound PlaySoundWithParams
    local replace_list = {
        ["dontstarve/characters/wendy/carol"]   =   "hoshino_sound/hoshino_sound/christmas_carol",  --- 表情 圣诞曲
        ["dontstarve/characters/wendy/hurt"]    =   function() -- 被攻击
                                                        return "hoshino_sound/hoshino_sound/attacked_"..math.random(1,3)
                                                    end,

        ["dontstarve/characters/wendy/death_voice"] = "hoshino_sound/hoshino_sound/death",  --- 死亡音效
        ["dontstarve/wilson/death"]                 = "hoshino_sound/hoshino_sound/death",  --- 死亡音效

        ["dontstarve/characters/wendy/emote"]       = "hoshino_sound/hoshino_sound/do_emote",  --- 做表情的音效
        ["dontstarve/characters/wendy/yawn"]        = "hoshino_sound/hoshino_sound/yawn",  --- 打哈欠

        ["dontstarve/characters/wendy/talk_LP"] =   function()
                                                        return "hoshino_sound/hoshino_sound/talk_"..math.random(1,5)            
                                                    end,
    }
    local function ReplaceSound(origin_addr)
        -- print("sound:",origin_addr)
        local ret = replace_list[origin_addr]
        if type(ret) == "string" then
            return ret
        end
        if type(ret) == "function" then
            return ret()
        end
        if type(ret) == "table" then
            return ret[math.random(#ret)]
        end
        return origin_addr
    end
    local function Hook_PlaySound(inst)
        local old_PlaySound = inst.SoundEmitter.PlaySound
        inst.SoundEmitter.PlaySound = function(self,addr,...)
            addr = ReplaceSound(addr) or addr
            return old_PlaySound(self,addr,...)
        end

        local old_PlaySoundWithParams = inst.SoundEmitter.PlaySoundWithParams
        inst.SoundEmitter.PlaySoundWithParams = function(self,addr,...)
            addr = ReplaceSound(addr)
            return old_PlaySoundWithParams(self,addr,...)
        end
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function Hook_Player_SoundEmitter(inst)

        if type(inst.SoundEmitter) == "userdata" then            ----- 只能转变一次，重复的操作 会导致  __index 函数错误
            --------------------------------------------------------------------------------------------------------------------------------
                inst.__SoundEmitter_userdata_hoshino = inst.SoundEmitter      ----- 转移复制原有 userdata
                inst.SoundEmitter = {inst = inst , name = "SoundEmitter"}   ----- name 是必须的，用于 从 _G  里 得到目标, 玩家 inst 也是从这里进入
                ------ 逻辑上复现棱镜模组的代码：

                setmetatable( inst.SoundEmitter , {
                    __index = function(_table,fn_name)
                                if _table and _table.inst and _table.name then

                                        if _G[_table.name][fn_name] then    ---- 从_G全局里得到原函数？？这句并不好理解。   ---- lua 会往_G 里自动挂载所有要运行的 userdata ？？
                                            local _table_name = _table.name
                                            local fn = function(temp_table,...)
                                                return _G[_table_name][fn_name](temp_table.inst.__SoundEmitter_userdata_hoshino,...)
                                            end
                                            rawset(_table,fn_name,fn)
                                            return fn
                                        end

                                end
                    end,
                })
            --------------------------------------------------------------------------------------------------------------------------------
        else
            print("warning : ThePlayer.SoundEmitter is already a table ")    
        end

        ------- 成功把  inst.SoundEmitter 从  userdata 变成 table
        --------------------- 挂载函数
        if inst.SoundEmitter.inst ~= inst then
            inst.SoundEmitter.inst = inst
        end
        ---------------------
        print("hoshino hook player SoundEmitter finish")
        Hook_PlaySound(inst)
    end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:DoTaskInTime(1,Hook_Player_SoundEmitter)
end