----------------------------------------------------------------------------------------------------------------------------------
--[[

    

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_com_item_spell = Class(function(self, inst)
    self.inst = inst
    

    self._owner = net_entity(inst.GUID,"hoshino_com_item_spell.owner","hoshino_com_item_spell.owner")
    self.owner = nil

    if not TheNet:IsDedicated() then       
        inst:ListenForEvent("hoshino_com_item_spell.owner",function(inst)
            local temp_owner = self._owner:value()
            if temp_owner and self.owner == nil and temp_owner ~= inst and temp_owner == ThePlayer and TheInput then
                self.owner = temp_owner
                self:Client_Create_Mouse_Event_Listener()
                self:Client_Create_Dotted_Circle()
            end
        end)
        inst:ListenForEvent("owner_rpc_set_by_userid",function(inst,userid)
            if userid and userid == ThePlayer.userid and self.owner == nil then
                self.owner = inst
                self:Client_Create_Mouse_Event_Listener()
                self:Client_Create_Dotted_Circle()
            end
        end)
    end


end)
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_item_spell:SetOwner(owner)
        if TheWorld.ismastersim then
            self._owner:set(owner)
        end
        self.owner = owner
    end
------------------------------------------------------------------------------------------------------------------------------
---
    function hoshino_com_item_spell:Client_Create_Mouse_Event_Listener()  --- 添加鼠标监听器。
        if self.special_mouse_control ~= nil then
            return
        end
        self.special_mouse_control = TheInput:AddMouseButtonHandler(function(button, down, x, y)
            if down then
                -- print("mouse click hoshino_com_item_spell",button)
                if button == MOUSEBUTTON_LEFT then
                    self:Active_Mouse_Left_Fn()
                    ThePlayer.components.playercontroller:Enable(true)
                elseif button == MOUSEBUTTON_RIGHT then
                    self:Active_Mouse_Right_Fn()
                end
            end
        end)
        self.inst:ListenForEvent("onremove",function()
            self.special_mouse_control:Remove()
            self.special_mouse_control = nil
            -- ThePlayer.components.playercontroller:Enable(true)  --- 恢复鼠标点击移动
        end)
        -- ThePlayer.components.playercontroller:Enable(false) --- 避免鼠标点击移动
    end
    function hoshino_com_item_spell:Set_Dotted_Circle_Radius(radius)
        self.radius = radius
    end
    function hoshino_com_item_spell:Client_Create_Dotted_Circle(range)
        if self.fx then
            return
        end
        range = range or self.radius or 8
        self.fx = SpawnPrefab("hoshino_sfx_dotted_circle_client")
        self.fx:PushEvent("Set",{
            range = range
        })
        self.inst:DoPeriodicTask(FRAMES,function()
            local pt = TheInput:GetWorldPosition()
            if pt and self.inst:IsValid() then
                self.fx.Transform:SetPosition(pt.x,0,pt.z)
            else
                self.fx:Remove()
            end
        end)
        self.inst:ListenForEvent("onremove",function()
            self.fx:Remove()
        end)
    end
------------------------------------------------------------------------------------------------------------------------------
--- 鼠标左右键盘函数
    function hoshino_com_item_spell:Set_Mouse_Left_Click_Fn(fn)
        self._mouse_left_click_fn = fn
    end
    function hoshino_com_item_spell:Active_Mouse_Left_Fn()
        if self._mouse_left_click_fn then
            self._mouse_left_click_fn(self.inst,self.owner,TheInput:GetWorldPosition(),TheInput:GetWorldEntityUnderMouse())
        end        
    end
    function hoshino_com_item_spell:Set_Mouse_Right_Click_Fn(fn)
        self._mouse_right_click_fn = fn        
    end
    function hoshino_com_item_spell:Active_Mouse_Right_Fn()
        if self._mouse_right_click_fn then
            self._mouse_right_click_fn(self.inst,self.owner,TheInput:GetWorldPosition(),TheInput:GetWorldEntityUnderMouse())
        end
    end
------------------------------------------------------------------------------------------------------------------------------
---    
------------------------------------------------------------------------------------------------------------------------------
return hoshino_com_item_spell







