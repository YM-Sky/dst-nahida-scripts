---
--- dst_gi_nahida_bind_data.lua
--- Description: 数据绑定data
--- Author: 没有小钱钱
--- Date: 2025/5/13 23:25
---
local dst_gi_nahida_bind_data = Class(function(self, inst)
    self.inst = inst
    self.uuid = nil
end)

function dst_gi_nahida_bind_data:SetUuid(uuid)
    self.uuid = uuid
end

function dst_gi_nahida_bind_data:GetUuid()
    return self.uuid
end

function dst_gi_nahida_bind_data:OnSave()
    return {
        uuid = self.uuid,
    }
end

-- 保存UUID
function dst_gi_nahida_bind_data:OnLoad(data)
    if data.uuid then
        self.uuid = data.uuid
    end
end


return dst_gi_nahida_bind_data