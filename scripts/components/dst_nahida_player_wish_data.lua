---
--- dst_nahida_player_wish_data.lua
--- Description: 玩家祈愿数据组件
--- Author: 没有小钱钱
--- Date: 2025/5/10 10:51
---

local dst_nahida_player_wish_data = Class(function(self, inst)
    self.inst = inst
    self.base_probabilities = { -- 卡池概率
        BLUE = 0.943,
        PURPLE = 0.051,
        GOLD = 0.006
    }
    -- 保底机制
    self.pity_counter = 0
    -- 紫色保底计数器
    self.purple_pity_counter = 0
    self.soft_pity = 90 -- 小保底
    self.hard_pity = 180 -- 大保底
    self.gold_probability_increment = 0.0006 -- 每次未出金色时增加的概率
    self.current_gold_probability = self.base_probabilities.GOLD

    -- 定轨机制 默认定轨物品为纳西妲命座
    self.epitomized_path_default_item = "dst_gi_nahida_fateseat"
    self.epitomized_path_item = "dst_gi_nahida_fateseat"
    self.epitomized_path_item_index = 1
    -- up次数
    self.up_counter = 0

end)

-- 定轨物品
function dst_nahida_player_wish_data:EpitomizedPath()
    local epitomizedPathPools = TUNING.MOD_DST_GI_NAHIDA_CARD_POOL.NAHIDA_CARD_POOL.EPITOMIZED_PATH

    -- 检查定轨物品池的长度
    if #epitomizedPathPools > 1 then
        -- 更新定轨物品索引
        self.epitomized_path_item_index = self.epitomized_path_item_index + 1
        if self.epitomized_path_item_index > #epitomizedPathPools then
            self.epitomized_path_item_index = 1 -- 循环回到第一个物品
        end
    else
        -- 如果只有一个物品，确保索引为1
        self.epitomized_path_item_index = 1
    end
    -- 设置当前定轨物品
    local item_name = epitomizedPathPools[self.epitomized_path_item_index] or self.epitomized_path_default_item
    self:SetEpitomizedPath(item_name)
    -- 显示当前定轨物品
    if self.inst.components.talker then
        local name = STRINGS.NAMES[string.upper(item_name)] or item_name
        self.inst.components.talker:Say(string.format(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SETTING_EPITOMIZED_PATH, name))
    end
    return true
end

function dst_nahida_player_wish_data:SetEpitomizedPath(item_name)
    self.epitomized_path_item = item_name
end

-- 抽卡函数
function dst_nahida_player_wish_data:DrawCard(item)
    self.pity_counter = self.pity_counter + 1
    self.purple_pity_counter = self.purple_pity_counter + 1

    -- 调整概率以实现保底机制
    if self.pity_counter >= self.soft_pity then
        self.current_gold_probability = 1
    else
        self.current_gold_probability = self.base_probabilities.GOLD + (self.pity_counter - 1) * self.gold_probability_increment
        -- 确保概率不超过1
        if self.current_gold_probability > 1 then
            self.current_gold_probability = 1
        end
    end

    -- 确保概率总和为1
    local total_probability = self.base_probabilities.BLUE + self.base_probabilities.PURPLE + self.current_gold_probability
    local probabilities = {
        BLUE = self.base_probabilities.BLUE / total_probability,
        PURPLE = self.base_probabilities.PURPLE / total_probability,
        GOLD = self.current_gold_probability / total_probability
    }

    local rand = math.random()
    local cumulative_probability = 0

    for rarity, probability in pairs(probabilities) do
        cumulative_probability = cumulative_probability + probability
        if rand <= cumulative_probability then
            local pool = TUNING.MOD_DST_GI_NAHIDA_CARD_POOL.NAHIDA_CARD_POOL[rarity]
            local card = pool[math.random(#pool)]

            if rarity == "GOLD" then
                -- 纠缠之缘才会有定轨次数
                if item and item.prefab == "dst_gi_nahida_intertwined_fate" then
                    if card.name == self.epitomized_path_item then
                        self.up_counter = 0 -- 重置up计数器
                    else
                        self.up_counter = self.up_counter + 1
                        if self.up_counter >= 2 then
                            card.name = self.epitomized_path_item -- 强制出定轨物品
                            self.up_counter = 0 -- 重置up计数器
                        end
                    end
                end
                self.pity_counter = 0 -- 重置保底计数器
                self.current_gold_probability = self.base_probabilities.GOLD -- 重置金色概率
            end

            -- 检查紫色保底
            if self.purple_pity_counter >= 10 then
                rarity = "PURPLE"
                pool = TUNING.MOD_DST_GI_NAHIDA_CARD_POOL.NAHIDA_CARD_POOL[rarity]
                card = pool[math.random(#pool)]
                self.purple_pity_counter = 0 -- 重置紫色保底计数器
            end

            return card.name, card.count, rarity
        end
    end
end

-- 保存数据
function dst_nahida_player_wish_data:OnSave()
    return {
        pity_counter = self.pity_counter,
        current_gold_probability = self.current_gold_probability,
        epitomized_path_item = self.epitomized_path_item,
        epitomized_path_item_index = self.epitomized_path_item_index,
        up_counter = self.up_counter,
        purple_pity_counter = self.purple_pity_counter
    }
end

-- 加载数据
function dst_nahida_player_wish_data:OnLoad(data)
    if data then
        self.pity_counter = data.pity_counter or 0
        self.current_gold_probability = data.current_gold_probability or self.base_probabilities.GOLD
        self.epitomized_path_item = data.epitomized_path_item or self.epitomized_path_default_item
        self.epitomized_path_item_index = data.epitomized_path_item_index or 1
        self.up_counter = data.up_counter or 0
        self.purple_pity_counter = data.purple_pity_counter or 0
    end
end

return dst_nahida_player_wish_data