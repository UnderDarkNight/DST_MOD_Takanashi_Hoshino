------------------------------------------------------------------------------------------------------------------------------------
--[[

    lootdropper 掉落屏蔽器

]]--
------------------------------------------------------------------------------------------------------------------------------------



AddComponentPostInit("lootdropper", function(self)


    function self:Hoshino_Block()
        self.___hoshino_block = true
    end

    local old_SpawnLootPrefab = self.SpawnLootPrefab
    function self:SpawnLootPrefab(...)
        if self.___hoshino_block then
            return
        end
        return old_SpawnLootPrefab(self, ...)
    end

    local old_DropLoot = self.DropLoot
    function self:DropLoot(...)
        if self.___hoshino_block then
            return
        end
        return old_DropLoot(self, ...)
    end

end)