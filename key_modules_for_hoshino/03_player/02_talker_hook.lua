-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPlayerPostInit(function(inst)

    if not TheWorld.ismastersim then
        return
    end

    inst:DoTaskInTime(math.random(20)/10,function()        
        if inst.components.talker then

            local old_Say = inst.components.talker.Say
            inst.components.talker.Say = function(self,str,...)
                self.inst:PushEvent("hoshino_event.talker_say",{
                    str = str,
                })
                return old_Say(self,str,...)
            end
        end
    end)

end)
