---
--- dst_gi_nahida_toy_desk_data.lua
--- Description: 小玩具兑换数量缓存
--- Author: 没有小钱钱
--- Date: 2025/6/7 16:47
---
local dst_gi_nahida_toy_desk_data = Class(function(self, inst)
    self.inst = inst
    self.toy_count = 0
end)

function dst_gi_nahida_toy_desk_data:GetCurrentToyCount()
    return self.inst.components.dst_gi_nahida_toy_desk_data.toy_count
end

function dst_gi_nahida_toy_desk_data:addToyCount(count)
    self.inst.components.dst_gi_nahida_toy_desk_data.toy_count = self.inst.components.dst_gi_nahida_toy_desk_data.toy_count + count
end

function dst_gi_nahida_toy_desk_data:GetMaxToyCount()
    return TUNING.MOD_DST_GI_NAHIDA_CONFIG("_toy_made_max_count") or 99999999999
end

-- 保存数据
function dst_gi_nahida_toy_desk_data:OnSave()
    return {
        toy_count = self.toy_count
    }
end

-- 加载数据
function dst_gi_nahida_toy_desk_data:OnLoad(data)
    if data then
        self.toy_count = data.toy_count
    end
end
return dst_gi_nahida_toy_desk_data