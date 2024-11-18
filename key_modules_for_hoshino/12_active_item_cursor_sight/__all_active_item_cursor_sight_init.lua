

if Assets == nil then
    Assets = {}
end

table.insert (Assets,  Asset("ANIM", "anim/hoshino_active_item_cursor_sight.zip")  )


modimport("key_modules_for_hoshino/12_active_item_cursor_sight/01_inventory_classified_hook.lua") 
--- hook inventory_classified
