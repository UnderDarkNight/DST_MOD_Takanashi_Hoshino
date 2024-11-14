------------------------------------------------------------------------------------------------------------------------------------
--[[

    cookable 组件 的 额外hook

]]--
------------------------------------------------------------------------------------------------------------------------------------



AddComponentPostInit("cookable", function(self)

    local old_Cook = self.Cook
    self.Cook = function(self,cooker, chef,...)
        -- cooker 使用的厨具
        -- chef 玩家
        local ret_product = old_Cook(self,cooker, chef,...)
        if type(ret_product) == "table" and ret_product.prefab and chef and chef:HasTag("player") then
            chef:PushEvent("hoshino_event.cookable_cooked",{
                product = ret_product,
                cooker = cooker,
            })
        end
        return ret_product
    end

end)