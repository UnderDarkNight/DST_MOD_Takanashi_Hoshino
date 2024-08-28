----------------------------------------------------------------------------------------------------------------------------------
--[[

    卡牌选择系统.
    
    数据从 inst.PAD_DATA.cards 获取。靠index返回。
    
    界面模块的数据table。 使用RPC下发数据

                数据结构: 只有4种卡牌: card_black , card_colourful , card_golden , card_white
                {
                    [1] = "card_black",
                    [2] = "card_colourful",
                    [3] = "card_golden",
                    [4] = "card_white",
                    [5] = {atlas,image}, -- 卡牌正面
                }


    卡牌池子 ： 
        · 白色卡池
        · 彩色卡池
        · 金色卡池
        · 黑色卡池【诅咒】

    下发池子：
        从上面池子里，按照以下规则 提取出指定数量的卡牌

]]--
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_cards_sys = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}

    ---------------------------------------------------------------------
    ---
        inst:ListenForEvent("hoshino_event.card_click",function(_,card_index)
            self:Card_Clicked(card_index or 1)
        end)
    ---------------------------------------------------------------------
    --- onload
        inst:DoTaskInTime(1,function()
            local card_data = self:Get("card_data")
            if card_data then
                self:SendCardsToClient(card_data)
            end
        end)
    ---------------------------------------------------------------------
end,
nil,
{

})
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function hoshino_cards_sys:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function hoshino_cards_sys:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function hoshino_cards_sys:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function hoshino_cards_sys:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function hoshino_cards_sys:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function hoshino_cards_sys:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function hoshino_cards_sys:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
-- 下发卡牌数据
    function hoshino_cards_sys:GetRPC()
        return self.inst.components.hoshino_com_rpc_event
    end
    function hoshino_cards_sys:SendCardsToClient(data)
        self:GetRPC():PushEvent("hoshino_event.pad_data_update",{   --- 下发卡牌数据
            cards = data,
        })
        self:Set("card_data",data)
    end
    function hoshino_cards_sys:SendInspectWarning()
        self:GetRPC():PushEvent("hoshino_event.inspect_hud_warning",true)  -- 下发HUD警告        
    end
    function hoshino_cards_sys:SendPageRedDot() -- 下发红点
        self:GetRPC():PushEvent("hoshino_event.pad_data_update",{   --- 
            button_level_up_red_dot = true,
        })    
    end
------------------------------------------------------------------------------------------------------------------------------
-- 创建卡牌
    function hoshino_cards_sys:CreateWhiteCards(num)
        num = num or 1
        num = math.clamp(num,1,5)
        local cards = {}
        for i = 1,num do
            cards[i] = "card_white"
        end
        self:SendCardsToClient(cards)
        self:SendInspectWarning()
        self:SendPageRedDot()
    end
------------------------------------------------------------------------------------------------------------------------------
-- 卡牌点击后
    function hoshino_cards_sys:Card_Clicked(index)
        local data = self:Get("card_data") or {[1] = "card_white"}
        index = index or 1
        index = math.clamp(index,1,5)

        local temp_cards_front = {
            [1] = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
            [2] = {atlas = "images/inspect_pad/card_excample_b.xml" ,image = "card_excample_b.tex"},
            [3] = {atlas = "images/inspect_pad/card_excample_c.xml" ,image = "card_excample_c.tex"},
            [4] = {atlas = "images/inspect_pad/card_excample_d.xml" ,image = "card_excample_d.tex"},
        }
        local ret_data = temp_cards_front[math.random(#temp_cards_front)]
        data[index] = ret_data
        self:SendCardsToClient(data)
        self:GetRPC():PushEvent("hoshino_event.card_display",{ --- 下发展示命令
            index = index,
            atlas = ret_data.atlas,
            image = ret_data.image,
        })
    end
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
    function hoshino_cards_sys:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable
        }
        return next(data) ~= nil and data or nil
    end

    function hoshino_cards_sys:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        self:ActiveOnLoadFns()
    end
------------------------------------------------------------------------------------------------------------------------------
return hoshino_cards_sys







