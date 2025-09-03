---
--- dst_gi_nahida_weapon_bounce_data.lua
--- Description: 武器弹射等级管理组件
---

local function OnBounceLevel(self,value)
    self.inst.net_dst_gi_nahida_weapon_staff_bounce_level:set(value)
end

local dst_gi_nahida_weapon_bounce_data = Class(function(self, inst)
    self.inst = inst
    self.bounce_level = 1  -- 默认等级1
    self.max_level = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.DST_GI_NAHIDA_WEAPON_STAFF_EJECTION + 1     -- 最大等级6
end,nil,{
    bounce_level = OnBounceLevel
})

function dst_gi_nahida_weapon_bounce_data:SetLevel(level)
    self.bounce_level = math.max(1, math.min(level, self.max_level))
    -- 同步到武器实体
    self.inst.nahida_bounce_level = self.bounce_level
    self.inst.net_dst_gi_nahida_weapon_staff_bounce_level:set(self.bounce_level)
    return self.bounce_level
end

function dst_gi_nahida_weapon_bounce_data:GetLevel()
    return self.bounce_level
end

function dst_gi_nahida_weapon_bounce_data:Upgrade()
    return self:SetLevel(self.bounce_level + 1)
end

function dst_gi_nahida_weapon_bounce_data:CanUpgrade()
    return self.bounce_level < self.max_level
end

function dst_gi_nahida_weapon_bounce_data:GetBounceCount()
    return math.max(0, self.bounce_level - 1)
end

function dst_gi_nahida_weapon_bounce_data:OnSave()
    return {
        bounce_level = self.bounce_level,
    }
end

function dst_gi_nahida_weapon_bounce_data:OnLoad(data)
    if data and data.bounce_level then
        self:SetLevel(data.bounce_level)
    end
end

return dst_gi_nahida_weapon_bounce_data