--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

 官方玩家prefab :  

    wilson  willow  wolfgang    wendy   wx78
    wickerbottom
    woodie
    wes
    waxwell
    wathgrithr
    webber
    winona
    warly
    wortox
    wormwood
    wurt
    walter
    wanda
    wonkey

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local NORMAL_STRINGS = {
        ["default"] = " 星野 ",                 ---- 缺省 描述
        ["wilson"] = " 星野 ",                      ---- wilson
        ["hoshino"] = "居然有人和我一模一样",       ---- hoshino
    }
    local GHOST_STRINGS = {
        ["default"] = " 死了的星野 ",                 ---- 缺省 描述
        ["wilson"] = " 死了的星野 ",                      ---- wilson
        ["hoshino"] = " 死的真惨，不像我 ",       ---- hoshino
    }
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("master_postinit_hoshino",function()
        
        if inst.components.inspectable == nil then
            return
        end

        inst.components.inspectable.getspecialdescription = function(inst,viewer)
            if inst:HasTag("playerghost") then
                return GHOST_STRINGS[viewer.prefab] or GHOST_STRINGS["default"]
            else
                return NORMAL_STRINGS[viewer.prefab] or NORMAL_STRINGS["default"]
            end            
        end


    end)

end