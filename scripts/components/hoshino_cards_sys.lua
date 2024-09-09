----------------------------------------------------------------------------------------------------------------------------------
--[[

    卡牌选择系统.
    
    数据从 inst.PAD_DATA.cards 获取。靠index返回。
    
    只有4种卡牌: card_black , card_colourful , card_golden , card_white

    界面模块的数据table。 使用RPC下发数据

                数据结构: 
                {
                    [1] = {atlas,image,card_name},
                    [2] = {atlas,image,card_name},
                    [3] = {atlas,image,card_name},
                    [4] = {atlas,image,card_name},
                    [5] = {atlas,image,card_name}, -- 卡牌正面。
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
        self.need_to_send_to_client_data = nil
        self:AddOnSaveFn(function()
            self:Set("cards_data",self.cards_data)
            self:Set("need_to_send_to_client_data",self.need_to_send_to_client_data)
        end)
        self:AddOnLoadFn(function()
            local cards_data = self:Get("cards_data")
            local need_to_send_to_client_data = self:Get("need_to_send_to_client_data")
            if cards_data then
                self.cards_data = cards_data
                self.need_to_send_to_client_data = need_to_send_to_client_data
                inst:DoTaskInTime(1,function() -- onload 的时候，加载上一次已经开过的卡牌数据
                    self:SetClientSideData("cards", self.need_to_send_to_client_data)
                    self:SetClientSideData("cards_selectting",self.selectting)
                    self:SetClientSideData("refresh_num",self.refresh_num)  --- 下发刷新次数
                    if self.selectting then
                        self:SetClientSideData("default_page","level_up") -- 下发默认界面
                        self:SendInspectWarning() -- 发送警告
                    end
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
    --- 卡牌概率池子。初始化白色权重100，金色权重10，彩色权重1，黑色权重1
        self.CardPools = {
            ["card_white"] = 100,
            ["card_colourful"] = 1,
            ["card_golden"] = 10,
            ["card_black"] = 1,
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
        self.default_card_num = 3
        self:AddOnSaveFn(function()
            self:Set("default_card_num",self.default_card_num)
        end)
        self:AddOnLoadFn(function()
            local default_card_num = self:Get("default_card_num")
            if default_card_num then
                self.default_card_num = default_card_num
            end
        end)
    ---------------------------------------------------------------------
    --- 刷新次数。
        self.refresh_num = 10 -- 初始化送10次
        self:AddOnSaveFn(function()
            self:Set("refresh_num",self.refresh_num)
        end)
        self:AddOnLoadFn(function()
            local refresh_num = self:Get("refresh_num")
            if refresh_num then
                self.refresh_num = refresh_num
            end
        end)
        local temp_refresh_cd_flag = true
        inst:ListenForEvent("hoshino_event.card_refresh_button_clicked",function()
            if temp_refresh_cd_flag then
                self:Refresh_Clicked()
                temp_refresh_cd_flag = false
                inst:DoTaskInTime(1,function() -- 刷新冷却1秒
                    temp_refresh_cd_flag = true
                end)
            end
        end)
    ---------------------------------------------------------------------
    --- selectting
        self.selectting = false
        self:AddOnSaveFn(function()
            self:Set("selectting",self.selectting)
        end)
        self:AddOnLoadFn(function()
            local selectting = self:Get("selectting")
            if selectting then
                self.selectting = selectting
            end
        end)
    ---------------------------------------------------------------------
    --- 激活过的卡牌记录池
        self.ActivatedCards = {}
        self:AddOnSaveFn(function()
            self:Set("activated_cards",self.ActivatedCards)
        end)
        self:AddOnLoadFn(function()
            local activated_cards = self:Get("activated_cards")
            if activated_cards then
                self.ActivatedCards = activated_cards
            end
        end)
    ---------------------------------------------------------------------
    --- 卡牌回收
        inst:ListenForEvent("hoshino_event.card_recycle_button_clicked",function()
            self:Card_Recycle_Clicked()
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
        return self.selectting
    end
------------------------------------------------------------------------------------------------------------------------------
-- 默认卡包里的卡牌数量
    function hoshino_cards_sys:GetDefaultCardsNum()
        return self.default_card_num
    end
    function hoshino_cards_sys:DefultCardsNum_Delta(value)
        self.default_card_num = math.clamp(self.default_card_num + value,1,5)
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
    function hoshino_cards_sys:SendInspectWarning()
        self:GetRPC():PushEvent("hoshino_event.inspect_hud_warning",true)  -- 下发HUD警告        
    end
    function hoshino_cards_sys:SendPageRedDot() -- 下发红点
        -- self:GetRPC():PushEvent("hoshino_event.pad_data_update",{   --- 
        --     button_level_up_red_dot = true,
        -- })
        self:SetClientSideData("button_level_up_red_dot",true)
    end
    function hoshino_cards_sys:SetClientSideData(index,data)
        if self.SetClientSideData_Task then
        
        else
            self.SetClientSideData_Task = self.inst:DoTaskInTime(0,function()
                self:GetRPC():PushEvent("hoshino_event.pad_data_update",self.__temp_client_side_data)
                self.__temp_client_side_data = nil
                self.SetClientSideData_Task = nil
            end)
        end
        self.__temp_client_side_data =  self.__temp_client_side_data or {}
        self.__temp_client_side_data[index] = data
    end
------------------------------------------------------------------------------------------------------------------------------
-- 创建卡牌
    function hoshino_cards_sys:Excluding_Duplicate_Options_And_Adding_New_Ones(cards_front)  -- 排除重复选项并添加新选项
        --- 本段代码来自AI生成，用于排除重复选项并替换成同类型新选项
        local seen_cards = {}  -- 用于存储已经出现过的卡片名称

        for i, card_data in ipairs(cards_front) do
            local card_name = card_data.card_name
            local card_type = self:GetCardBackByIndex(card_name)

            -- 检查这张卡片是否已经存在于 seen_cards 表中
            if seen_cards[card_name] then
                -- print("发现卡组里存在相同选项")
                -- 生成新的同类型卡牌，确保新卡牌不是已经存在的卡牌
                local new_card_found = false
                while not new_card_found do
                    local new_card_name_index = self:SelectRandomCardFromPoolByType(card_type)
                    if not seen_cards[new_card_name_index] then
                        new_card_found = true
                        local new_card_data = self:GetCardFrontByIndex(new_card_name_index)
                        new_card_data.card_name = new_card_name_index
                        -- 替换掉重复的卡片
                        cards_front[i] = new_card_data
                        -- 记录新卡片
                        seen_cards[new_card_name_index] = true
                    end
                end
            else
                -- 如果没有重复，记录下这张卡片
                seen_cards[card_name] = true
            end
        end
    end
    function hoshino_cards_sys:CreateCardsByPool(num) --- 从概率池中随机抽取卡牌
        num = num or 1
        num = math.clamp(num,1,5)
        local cards = {}
        for i = 1,num do
            cards[i] = self:Get_Card_From_Pool()
        end
        return cards
    end
    function hoshino_cards_sys:CreateCardsByPool_Default(temp_card_num)  --- 默认开卡包
        if self:IsCardsSelectting() then
            return
        end
        local cards_num = nil
        if temp_card_num then
            cards_num = math.clamp(temp_card_num,1,5)
        else
            cards_num = self:GetDefaultCardsNum()
        end

        local cards_back = self:CreateCardsByPool(cards_num or self:GetDefaultCardsNum())  --- 生成背面
        --- 有诅咒卡的时候，全都显示卡牌背面
        local has_curse_card = false
        --- 生成正面
        local cards_front = {}         
        for i,card_type in ipairs(cards_back) do
            local current_card_name_index = self:SelectRandomCardFromPoolByType(card_type)
            cards_front[i] = self:GetCardFrontByIndex(current_card_name_index)  --- 获取卡牌正面数据
            cards_front[i].card_name = current_card_name_index  -- 往数据里填卡牌名字
            -- 当前数据结构 cards_front[i] = {atlas,image,card_name}
            if card_type == "card_black" then
                has_curse_card = true
            end
        end

        self:Excluding_Duplicate_Options_And_Adding_New_Ones(cards_front)  -- 排除重复选项并添加新选项

        self.cards_data = cards_front

        local need_to_send_to_client_data = nil
        if not has_curse_card then
            need_to_send_to_client_data = cards_front
        else
            need_to_send_to_client_data = {}
            for i, v in ipairs(cards_back) do
                need_to_send_to_client_data[i] = {atlas = "images/inspect_pad/page_level_up.xml",image = "card_black.tex"}
                need_to_send_to_client_data[i].card_name = "card_black"
            end
        end

        self.need_to_send_to_client_data = need_to_send_to_client_data

        self.selectting = true
        self:SetClientSideData("cards",need_to_send_to_client_data)  --- 下发卡牌数据
        self:SetClientSideData("refresh_num",self.refresh_num)  --- 下发刷新次数
        self:SetClientSideData("cards_selectting",self.selectting) -- 下发正在选择标记
        self:SetClientSideData("default_page","level_up") -- 下发默认界面
        self:SendPageRedDot() -- 下发红点
    end
    function hoshino_cards_sys:CreateCardsByForceCMD(temp_cards_data)  --- 靠卡背 和 卡牌名字，强制生成卡组
        --[[  自动识别卡牌背面和正面。如果是正面，则强制结果。如果是背面，则随机抽取
            temp_cards_data = {
                "card_golden" or card_name_index,
                "card_white",
                "card_colourful",
                "card_colourful",
            }
        ]]--
        -------------------------------------------------------------------------------------------
        -- 
            if self:IsCardsSelectting() then
                return
            end
        -------------------------------------------------------------------------------------------
        --[[ AI 生成代码：
                要在Lua中打乱两个表（cards_back和cards_front），
                同时保持它们之间的一一对应关系，你可以使用Fisher-Yates洗牌算法（也称为Knuth shuffle）。
                这个算法可以有效地随机化数组中的元素顺序，并且保证每个元素有均等的机会出现在任何位置上。
            ]]--
            local function shuffleCorrespondingPairs(cardsBack, cardsFront)
                if #cardsBack == #cardsFront and #cardsBack == 1 then
                    return
                end
                -- 确保两个表长度相同并且都多于一个元素
                local n = #cardsBack
                -- assert(n == #cardsFront and n > 1, "Both tables must have the same length and more than one element.")                
                for i = n - 1, 1, -1 do
                    local j = math.random(i)                    
                    -- 交换cardsBack[i+1]和cardsBack[j+1]
                    cardsBack[i+1], cardsBack[j+1] = cardsBack[j+1], cardsBack[i+1]                    
                    -- 同样交换cardsFront[i+1]和cardsFront[j+1]
                    cardsFront[i+1], cardsFront[j+1] = cardsFront[j+1], cardsFront[i+1]
                end
            end            
            -- -- 示例使用
            -- local cardsBack = {"back1"}
            -- local cardsFront = {"front1"}
            
            -- shuffleCorrespondingPairs(cardsBack, cardsFront)
            
            -- -- 输出结果
            -- print("Shuffled Cards Back:", unpack(cardsBack))
            -- print("Shuffled Cards Front:", unpack(cardsFront))
        -------------------------------------------------------------------------------------------
        ---
            local IsBack = {
                ["card_black"] = true,
                ["card_golden"] = true,
                ["card_white"] = true,
                ["card_colourful"] = true,
            }
            --- 有诅咒卡的时候，全都显示卡牌背面
            local has_curse_card = false
            local cards_num = math.clamp(#temp_cards_data or {},1,5)
            local cards_back = {} -- 卡组背面
            local cards_front = {} -- 卡组正面
            for i = 1,cards_num do
                local temp_cmd = temp_cards_data[i]
                if IsBack[temp_cmd] then -- 背面则随机从卡池获取一张卡
                    local card_type = temp_cmd
                    cards_back[i] = card_type
                    local current_card_name_index = self:SelectRandomCardFromPoolByType(card_type) -- 按类型从卡池抽一张
                    cards_front[i] = self:GetCardFrontByIndex(current_card_name_index)  --- 获取卡牌正面数据
                    cards_front[i].card_name = current_card_name_index  -- 往数据里填卡牌名字
                else
                    local current_card_name_index = temp_cmd
                    local test_fn = self:GetTestFnByCardName(current_card_name_index)
                    if test_fn and test_fn(self.inst) then --- 卡牌测试通过
                        cards_front[i] = self:GetCardFrontByIndex(current_card_name_index)  --- 获取卡牌正面数据
                        cards_front[i].card_name = current_card_name_index  -- 往数据里填卡牌名字
                        cards_back[i] = self:GetCardBackByIndex(current_card_name_index)  --- 获取卡牌背面数据
                    else    --- 卡牌测试不通过，选一张同类型卡牌
                        local card_type = self:GetCardTypeByIndex(current_card_name_index)
                        cards_back[i] = card_type
                        current_card_name_index = self:SelectRandomCardFromPoolByType(card_type) -- 按类型从卡池抽一张
                        cards_front[i] = self:GetCardFrontByIndex(current_card_name_index)  --- 获取卡牌正面数据
                        cards_front[i].card_name = current_card_name_index  -- 往数据里填卡牌名字
                    end
                end
            end

            shuffleCorrespondingPairs(cards_back, cards_front) -- 洗牌。强制命令下的牌组必须洗牌保证随机性。

            --- 检查黑卡
            for k, v in pairs(cards_back) do
                if v == "card_black" then
                    has_curse_card = true
                    break
                end
            end
        -------------------------------------------------------------------------------------------
        self:Excluding_Duplicate_Options_And_Adding_New_Ones(cards_front)  -- 排除重复选项并添加新选项

        self.cards_data = cards_front

        local need_to_send_to_client_data = nil
        if not has_curse_card then
            need_to_send_to_client_data = cards_front
        else
            need_to_send_to_client_data = {}
            for i, v in ipairs(cards_back) do
                need_to_send_to_client_data[i] = {atlas = "images/inspect_pad/page_level_up.xml",image = "card_black.tex"}
                need_to_send_to_client_data[i].card_name = "card_black"
            end
        end
        self.need_to_send_to_client_data = need_to_send_to_client_data
        self.selectting = true
        self:SetClientSideData("cards",need_to_send_to_client_data)  --- 下发卡牌数据
        self:SetClientSideData("refresh_num",self.refresh_num)  --- 下发刷新次数
        self:SetClientSideData("cards_selectting",self.selectting) -- 下发正在选择标记
        self:SetClientSideData("default_page","level_up") -- 下发默认界面
        -- self:SendPageRedDot() -- 下发红点
    end

------------------------------------------------------------------------------------------------------------------------------
--- refresh 按钮点击后
    function hoshino_cards_sys:Refresh_Clicked()
        if not self:IsCardsSelectting() or self.refresh_num <= 0 then
            return
        end
        self.selectting = false
        self:AddRefreshNum(-1)
        local cards_num = #self.cards_data --- 获取当前卡牌数量
        self:CreateCardsByPool_Default(cards_num)
        self:SetClientSideData("default_page",nil) -- 下发默认界面
        self:SetClientSideData("refresh_num",self.refresh_num)  --- 下发刷新次数
        self.inst:DoTaskInTime(0.5,function()
            self:GetRPC():PushEvent("hoshino_event.pad_data_update_by_refresh")            
        end)
    end
    function hoshino_cards_sys:AddRefreshNum(num)
        self.refresh_num = self.refresh_num + num
        self:SetClientSideData("refresh_num",self.refresh_num)  --- 下发刷新次数
    end
------------------------------------------------------------------------------------------------------------------------------
--- 记忆激活过的卡牌和次数
    function hoshino_cards_sys:RememberActivedCard(card_name_index,num)
        local card_type = self:GetCardTypeByIndex(card_name_index)
        self.ActivatedCards[card_type] = self.ActivatedCards[card_type] or {}
        self.ActivatedCards[card_type][card_name_index] = self.ActivatedCards[card_type][card_name_index] or 0
        self.ActivatedCards[card_type][card_name_index] = self.ActivatedCards[card_type][card_name_index] + (num or 1)
    end
    function hoshino_cards_sys:GetActivatedCards(card_type)
        --[[
            得到返回 {
                ["card_name_index"] = actived_times
            }
        ]]
        if card_type == nil then -- 如果是空参数，返回列表
            local ret = {}
            for temp_card_type, single_type_data in pairs(self.ActivatedCards) do
                for temp_card_name_index, actived_times in pairs(single_type_data) do
                    ret[temp_card_name_index] = actived_times or 0
                end
            end
            return ret
        else    --- 根据类型返回内部
            return self.ActivatedCards[card_type] or {}
        end
    end
    function hoshino_cards_sys:TryToDeactiveCardByName(card_name_index)
        --- 先检查激活次数是否超过 1 或者nil
        local card_type = self:GetCardTypeByIndex(card_name_index)
        local actived_times = self:GetActivatedCards(card_type)[card_name_index] or 0
        if actived_times <= 0 then
            return
        end
        --- 检查控制表里是否有 deactive_fn 函数
        local deactive_fn = self:GetDeactiveFnByCardName(card_name_index)
        if type(deactive_fn) == "function" then
            deactive_fn(self.inst)
            self:RememberActivedCard(card_name_index,-1)
        end
    end
    function hoshino_cards_sys:HasBlackCard()
        local cards_data = self.cards_data or {}
        for _,single_card_data in pairs(cards_data) do
            local card_name_index = single_card_data.card_name
            if self:GetCardTypeByName(card_name_index) == "card_black" then
                return true
            end
        end
        return false
    end
------------------------------------------------------------------------------------------------------------------------------
-- 卡牌回收。 黑卡+0。白+1。金+2。彩色+3
    function hoshino_cards_sys:Card_Recycle_Clicked()

        ------------------------------------------------------------------
        --- 
            if self.cards_data == nil then
                return
            end
            if self:HasBlackCard() then
                return
            end
        ------------------------------------------------------------------
        --- 卡牌回收、按最高类型回收次数。最高的是金卡则+2 。最高是白卡则 +1
            local cards_data = self.cards_data
            local num = 0
            local type_with_num = {
                ["card_black"] = 0,
                ["card_white"] = 1,
                ["card_golden"] = 2,
                ["card_colourful"] = 3,
            }
            local ret_num = 0
            for _,single_card_data in pairs(cards_data) do
                local card_name_index = single_card_data.card_name
                local card_type = self:GetCardTypeByName(card_name_index)
                local temp_num =  (type_with_num[card_type] or 0)
                if temp_num > 0 then
                    ret_num = temp_num
                end
            end
            self:AddRefreshNum(ret_num)
        ------------------------------------------------------------------
        ---
            self.cards_data = nil
            self.need_to_send_to_client_data = nil
            self.selectting = false
        ------------------------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------------------
-- 卡牌数据库加载、提取
    function hoshino_cards_sys:CardsInit(force)  -- 初始化函数
        if self.all_cards_data_and_fn and not force then
            return
        end
        self.all_cards_data_and_fn = {}
        for card_name_index, temp_data in pairs(TUNING.HOSHINO_CARDS_DATA_AND_FNS or {}) do
            local card_type = temp_data.back
            self.all_cards_data_and_fn[card_type] = self.all_cards_data_and_fn[card_type] or {}
            self.all_cards_data_and_fn[card_type][card_name_index] = temp_data
        end
    end
    function hoshino_cards_sys:GetCardsIndexByType(card_type)   --- 获取通过test函数的卡牌
        self:CardsInit()
        if self.all_cards_data_and_fn[card_type] then
            local ret_indexs = {}
            for card_name_index, single_card_data in pairs(self.all_cards_data_and_fn[card_type]) do
                local test_fn = single_card_data.test
                if test_fn and test_fn(self.inst) then
                    table.insert(ret_indexs,card_name_index)
                end
            end
            return ret_indexs
        end
    end
    function hoshino_cards_sys:GetCardFrontByIndex(card_name_index)  --- 获取卡牌的正面数据
        local all_data = TUNING.HOSHINO_CARDS_DATA_AND_FNS or {}
        if all_data[card_name_index] then
            return all_data[card_name_index].front
        end
        return nil
    end
    function hoshino_cards_sys:GetCardBackByIndex(card_name_index)  --- 获取卡牌的背面数据
        local all_data = TUNING.HOSHINO_CARDS_DATA_AND_FNS or {}
        if all_data[card_name_index] then
            return all_data[card_name_index].back
        end
        return nil
    end
    function hoshino_cards_sys:AcitveCardFnByIndex(card_name_index)  --- 获取卡牌的激活函数
        local all_data = TUNING.HOSHINO_CARDS_DATA_AND_FNS or {}
        if all_data[card_name_index] and all_data[card_name_index].fn then
            all_data[card_name_index].fn(self.inst)
            print("+++ 成功激活卡牌",card_name_index)
        end
    end
    function hoshino_cards_sys:SelectRandomCardFromPoolByType(card_type)  --- 从卡池中随机抽取一张卡牌
        local all_cards_index = self:GetCardsIndexByType(card_type)
        if all_cards_index == nil then
            return
        end
        local ret_card_index = all_cards_index[math.random(#all_cards_index)]
        return ret_card_index
    end
    function hoshino_cards_sys:GetTestFnByCardName(card_name_index)  --- 获取卡牌的test函数
        local all_data = TUNING.HOSHINO_CARDS_DATA_AND_FNS or {}
        if all_data[card_name_index] and all_data[card_name_index].test then
            return all_data[card_name_index].test
        end
        return nil
    end
    function hoshino_cards_sys:GetDeactiveFnByCardName(card_name_index)  --- 获取卡牌的deactive_fn函数
        local all_data = TUNING.HOSHINO_CARDS_DATA_AND_FNS or {}
        if all_data[card_name_index] and all_data[card_name_index].deactive_fn then
            return all_data[card_name_index].deactive_fn
        end
        return nil
    end
    function hoshino_cards_sys:GetCardTypeByName(card_name_index)  --- 获取卡牌类型
        local all_data = TUNING.HOSHINO_CARDS_DATA_AND_FNS or {}
        if all_data[card_name_index] and all_data[card_name_index].back then
            return all_data[card_name_index].back
        end
        return "card_white"
    end
------------------------------------------------------------------------------------------------------------------------------
-- 卡牌点击后
    function hoshino_cards_sys:Card_Clicked(index)
        -- print("card clicked")
        if not self:IsCardsSelectting() then
            -- print("card not IsCardsSelectting")
            return
        end
        self.selectting = false
        -- print("crads selet index",index)

        local data = self.cards_data or {[1] = "card_white"}
        index = index or 1
        index = math.clamp(index,1,5)

        -----------------------------------------------------------------------------------------
        --- 有诅咒卡
            local has_black_card = false
            for k,v in pairs(self.cards_data) do
                if self:GetCardTypeByName(v.card_name) then
                    has_black_card = true
                    break
                end
            end
        -----------------------------------------------------------------------------------------
        --- 抽取卡牌
            local selected_card_data = self.cards_data[index]
            local selected_card_name_index = selected_card_data.card_name
            local selected_card_type = self:GetCardTypeByName(selected_card_name_index)
            local selected_atlas = selected_card_data.atlas
            local selected_image = selected_card_data.image

            print("+++ 玩家激活了卡牌",selected_card_type,selected_card_name_index)
        -----------------------------------------------------------------------------------------
        --- 
            self:AcitveCardFnByIndex(selected_card_name_index) -- 激活卡牌
            self:RememberActivedCard(selected_card_name_index) -- 记忆卡牌
            self.inst:PushEvent("hoshino_cards_sys.card_activated",{
                index = index,
                card_name = selected_card_name_index,
                card_type = selected_card_type,
            })
            self.cards_data = nil
            self.need_to_send_to_client_data = nil
        -----------------------------------------------------------------------------------------
        --- 
            self:SetClientSideData("cards_selectting",self.selectting) -- 下发正在选择标记
        -----------------------------------------------------------------------------------------
        --- 如果是诅咒卡下发展示命令
            if has_black_card then
                self.inst:DoTaskInTime(0.2,function()
                    self:GetRPC():PushEvent("hoshino_event.card_display",{
                        index = index,
                        atlas = selected_atlas,
                        image = selected_image,
                        card_name = selected_card_name_index
                    })
                end)
            end
        -----------------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------------
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







