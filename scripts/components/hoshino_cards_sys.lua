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
                    [5] = {atlas,image}, -- 卡牌正面。
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
---
    local function GetReplicaCom(self)
        return self.inst.replica.hoshino_cards_sys or self.inst.replica._.hoshino_cards_sys
    end
----------------------------------------------------------------------------------------------------------------------------------
local hoshino_cards_sys = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}

    ---------------------------------------------------------------------
    --- 卡牌数据
        self.cards_data = nil
        self:AddOnSaveFn(function()
            self:Set("cards_data",self.cards_data)
        end)
        self:AddOnLoadFn(function()
            local cards_data = self:Get("cards_data")
            if cards_data then
                self.cards_data = cards_data
                inst:DoTaskInTime(1,function() -- onload 的时候，加载上一次已经开过的卡牌数据
                    self:SendCardsToClient(self.cards_data)
                end)
            end
        end)
    ---------------------------------------------------------------------
    ---
        inst:ListenForEvent("hoshino_event.card_click",function(_,card_index)
            self:Card_Clicked(card_index or 1)
        end)
    ---------------------------------------------------------------------
    --- 
    ---------------------------------------------------------------------
    --- 卡牌概率池子。初始化白色能力权重100，金色能力权重10，彩色能力权重1
        self.CardPools = {
            ["card_white"] = 100,
            ["card_colourful"] = 1,
            ["card_golden"] = 10,
        }
        self:AddOnSaveFn(function()
            self:Set("card_pools",self.CardPools)
        end)
        self:AddOnLoadFn(function()
            local card_pools = self:Get("card_pools")
            if card_pools then
                self.CardPools = card_pools
            end
        end)
    ---------------------------------------------------------------------
    --- 默认卡包数量
        self.defult_card_num = 3
        self:AddOnSaveFn(function()
            self:Set("defult_card_num",self.defult_card_num)
        end)
        self:AddOnLoadFn(function()
            local defult_card_num = self:Get("defult_card_num")
            if defult_card_num then
                self.defult_card_num = defult_card_num
            end
        end)
    ---------------------------------------------------------------------
    --- 刷新次数。
        self.refresh_num = 10
        self:AddOnSaveFn(function()
            self:Set("refresh_num",self.refresh_num)
        end)
        self:AddOnLoadFn(function()
            local refresh_num = self:Get("refresh_num")
            if refresh_num then
                self.refresh_num = refresh_num
            end
        end)
        inst:ListenForEvent("hoshino_event.card_refresh_button_clicked",function()
            self:Refresh_Clicked()
        end)
    ---------------------------------------------------------------------
end,
nil,
{
    -----------------------------------------------------
    --- 刷新次数。
        refresh_num = function(self,value)
            local replica_com = GetReplicaCom(self)
            if replica_com then
                replica_com:Set_refresh_num(value)
            end
        end,
    -----------------------------------------------------
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
-- 判断是正在选择，还是已经打开
    function hoshino_cards_sys:IsCardsSelectting()
        local cards_data = self.cards_data
        if type(cards_data) ~= "table" then
            return false
        end
        for index_num, current_card_data in pairs(cards_data) do
            if type(current_card_data) == "table" then
                return false
            end
        end
        return true
    end
------------------------------------------------------------------------------------------------------------------------------
-- 默认卡包里的卡牌数量
    function hoshino_cards_sys:GetDefaultCardsNum()
        return self.defult_card_num
    end
    function hoshino_cards_sys:DefultCardsNum_Delta(value)
        self.defult_card_num = math.clamp(self.defult_card_num + value,1,5)
    end
------------------------------------------------------------------------------------------------------------------------------
-- 概率池修改
    function hoshino_cards_sys:Card_Pool_Delata(index,value)
        if self.CardPools[tostring(index)] then
            self.CardPools[index] = self.CardPools[index] + value
        end
    end
    function hoshino_cards_sys:Get_Card_From_Pool()  --- 从概率池获取一个卡牌
        local total = 0
        for k,v in pairs(self.CardPools) do
            total = total + v
        end
        local rand = math.random(total*100)/100
        for k,v in pairs(self.CardPools) do
            rand = rand - v
            if rand <= 0 then
                return k
            end
        end
        return "card_white"        
    end
------------------------------------------------------------------------------------------------------------------------------
-- 下发卡牌数据
    function hoshino_cards_sys:GetRPC()
        return self.inst.components.hoshino_com_rpc_event
    end
    function hoshino_cards_sys:SendCardsToClient(data) --- 界面未打卡的情况下，用这个下发。
        self:GetRPC():PushEvent("hoshino_event.pad_data_update",{   --- 下发卡牌数据
            cards = data,
            refresh_num = self.refresh_num,
        })
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
    function hoshino_cards_sys:CreateCardsByPool(num)
        num = num or 1
        num = math.clamp(num,1,5)
        local cards = {}
        for i = 1,num do
            cards[i] = self:Get_Card_From_Pool()
        end
        return cards
    end
    function hoshino_cards_sys:CreateCardsByPool_Default()  --- 默认开卡包
        local cards = self:CreateCardsByPool(self:GetDefaultCardsNum())
        self.cards_data = cards
        self:SendCardsToClient(cards)
        self:SendInspectWarning()
        self:SendPageRedDot()
    end
------------------------------------------------------------------------------------------------------------------------------
--- refresh 按钮点击后
    function hoshino_cards_sys:Refresh_Clicked()
        print("refresh clicked")
        if not self:IsCardsSelectting() then
            return
        end
        if self.refresh_num <= 0 then
            return
        end
        self.refresh_num = self.refresh_num - 1        
        local cards_data = self:CreateCardsByPool(self:GetDefaultCardsNum())

        self:SendCardsToClient(cards_data)
        self.inst:DoTaskInTime(0.2,function()
            self:GetRPC():PushEvent("hoshino_event.pad_data_update_by_refresh",{
                cards = cards_data,
                refresh_num = self.refresh_num
            })
        end)
        self.cards_data = cards_data
    end
    function hoshino_cards_sys:AddRefreshNum(num)
        self.refresh_num = self.refresh_num + num
    end
------------------------------------------------------------------------------------------------------------------------------
-- 卡牌点击后
    function hoshino_cards_sys:Card_Clicked(index)
        -- print("card clicked")
        if not self:IsCardsSelectting() then
            print("card not IsCardsSelectting")
            return
        end
        print("crads selet index",index)

        local data = self.cards_data or {[1] = "card_white"}
        index = index or 1
        index = math.clamp(index,1,5)

        -----------------------------------------------------------------------------------------
        --- 抽取卡牌
            local temp_cards_front = {
                [1] = {atlas = "images/inspect_pad/card_excample_a.xml" ,image = "card_excample_a.tex"},
                [2] = {atlas = "images/inspect_pad/card_excample_b.xml" ,image = "card_excample_b.tex"},
                [3] = {atlas = "images/inspect_pad/card_excample_c.xml" ,image = "card_excample_c.tex"},
                [4] = {atlas = "images/inspect_pad/card_excample_d.xml" ,image = "card_excample_d.tex"},
            }
            local ret_data = temp_cards_front[math.random(#temp_cards_front)]
        -----------------------------------------------------------------------------------------
        data[index] = ret_data
        self:SendCardsToClient(data)  --- 下发卡牌数据
        self.cards_data = data  --- 储存开卡数据
        -----------------------------------------------------------------------------------------
        --- 激活卡牌功能函数。
        -----------------------------------------------------------------------------------------
        self.inst:DoTaskInTime(0.2,function()
            self:GetRPC():PushEvent("hoshino_event.card_display",{ --- 下发展示命令
                index = index,
                atlas = ret_data.atlas,
                image = ret_data.image,
            })
        end)
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







