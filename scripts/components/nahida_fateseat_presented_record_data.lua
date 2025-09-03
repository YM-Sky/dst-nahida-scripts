---
--- nahida_fateseat_presented_record_data.lua
--- Description: 
--- Author: 旅行者
--- Date: 2025/8/20 22:46
---
local nahida_fateseat_presented_record_data = Class(function(self, inst)
    self.inst = inst
    self.nahida_survival_days = 0
    self.nahida_fateseat_count = 0
end)

function nahida_fateseat_presented_record_data:OnSave()
    return {
        nahida_survival_days = self.nahida_survival_days or 0,
        nahida_fateseat_count = self.nahida_fateseat_count or 0,
    }
end

-- 加载能量和冷却时间的状态
function nahida_fateseat_presented_record_data:OnLoad(data)
    if data.nahida_survival_days then
        self.nahida_survival_days = data.nahida_survival_days
    end
    if data.nahida_fateseat_count then
        self.nahida_fateseat_count = data.nahida_fateseat_count
    end
end

return nahida_fateseat_presented_record_data