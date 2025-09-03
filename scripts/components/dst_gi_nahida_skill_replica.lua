---
--- dst_gi_nahida_skill_replica.lua
--- Description: replica组件
--- Author: 没有小钱钱
--- Date: 2025/3/30 0:03
---
-- 同步，推送数据
local function OnCurrentEnergy(inst)
    local current_energy = inst.replica.dst_gi_nahida_skill:GetCurrentEnergy()
    inst:PushEvent(TUNING.MOD_ID.."_current_energy_change_event", {current_energy = current_energy})
end

local function OnSkillCurrentCd(inst)
    local nahida_skill_current_cd = inst.replica.dst_gi_nahida_skill:GetSkillCurrentCd()
    inst:PushEvent(TUNING.MOD_ID.."_nahida_skill_current_cd_change_event", {nahida_skill_current_cd = nahida_skill_current_cd})
end

local function OnBurstCurrentCd(inst)
    local nahida_burst_current_cd = inst.replica.dst_gi_nahida_skill:GetBurstCurrentCd()
    inst:PushEvent(TUNING.MOD_ID.."_nahida_burst_current_cd_change_event", {nahida_burst_current_cd = nahida_burst_current_cd})
end

local function OnSkillMode(inst)
    local current_skill_mode = inst.replica.dst_gi_nahida_skill:GetCurrentSkillMode()
    inst:PushEvent(TUNING.MOD_ID.."_nahida_current_skill_mode_change_event", {current_skill_mode = current_skill_mode})
end

local function OnFateseatLevel(inst)
    local current_fateseat_level = inst.replica.dst_gi_nahida_skill:GetCurrentFateseatLevel()
    inst:PushEvent(TUNING.MOD_ID.."_nahida_current_fateseat_level_change_event", {current_fateseat_level = current_fateseat_level})
end


local function OnNahidaGrowthValue(inst)
    local nahida_growth_value = inst.replica.dst_gi_nahida_skill:GetNahidaGrowthValue()
    inst:PushEvent(TUNING.MOD_ID.."_nahida_growth_value_change_event", {nahida_growth_value = nahida_growth_value})
end


-- 创建实例
local dst_gi_nahida_skill = Class(function(self, inst)
    self.inst = inst
    self.nahida_skill_cd = 5 -- 元素战技的冷却时间（秒）
    self.nahida_burst_cd = 13.5 -- 元素爆发的冷却时间（秒）
    -- 定义一个字符串的通信变量
    -- 三个参数分别是：当前组件所挂实例的GUID，唯一的一个名字不能重复写什么都行，事件名
    self.current_energy = net_float(inst.GUID, TUNING.MOD_ID.."_current_energy_guid", TUNING.MOD_ID.."_current_energy_guid_change_event")
    self.nahida_skill_current_cd = net_float(inst.GUID, TUNING.MOD_ID.."_nahida_skill_current_cd_guid", TUNING.MOD_ID.."_nahida_skill_current_cd_guid_change_event")
    self.nahida_burst_current_cd = net_float(inst.GUID, TUNING.MOD_ID.."_nahida_burst_current_cd_guid", TUNING.MOD_ID.."_nahida_burst_current_cd_guid_change_event")
    self.current_skill_mode = net_string(inst.GUID, TUNING.MOD_ID.."_nahida_current_skill_mode_guid", TUNING.MOD_ID.."_nahida_current_skill_mode_guid_change_event")
    self.current_fateseat_level = net_string(inst.GUID, TUNING.MOD_ID.."_nahida_current_fateseat_level_guid", TUNING.MOD_ID.."_nahida_current_fateseat_level_guid_change_event")
    self.nahida_growth_value = net_string(inst.GUID, TUNING.MOD_ID.."_nahida_growth_value_guid", TUNING.MOD_ID.."_nahida_growth_value_guid_change_event")
    if not TheWorld.ismastersim then
        -- 这里做个判断，只在客机里监听这个 destdirty 事件，destdirty事件就是上面定义的字符串通信变量的事件名
        inst:ListenForEvent(TUNING.MOD_ID.."_current_energy_guid_change_event", OnCurrentEnergy)
        inst:ListenForEvent(TUNING.MOD_ID.."_nahida_skill_current_cd_guid_change_event", OnSkillCurrentCd)
        inst:ListenForEvent(TUNING.MOD_ID.."_nahida_burst_current_cd_guid_change_event", OnBurstCurrentCd)
        inst:ListenForEvent(TUNING.MOD_ID.."_nahida_current_skill_mode_guid_change_event", OnSkillMode)
        inst:ListenForEvent(TUNING.MOD_ID.."_nahida_current_fateseat_level_guid_change_event", OnFateseatLevel)
        inst:ListenForEvent(TUNING.MOD_ID.."_nahida_growth_value_guid_change_event", OnNahidaGrowthValue)
    end
end)

function dst_gi_nahida_skill:SetCurrentEnergy(value)
    self.current_energy:set(value)
end

function dst_gi_nahida_skill:SetSkillCurrentCd(value)
    self.nahida_skill_current_cd:set(value)
end

function dst_gi_nahida_skill:SetBurstCurrentCd(value)
    self.nahida_burst_current_cd:set(value)
end

function dst_gi_nahida_skill:SetCurrentSkillMode(value)
    self.current_skill_mode:set(value)
end

function dst_gi_nahida_skill:SetCurrentFateseatLevel(value)
    self.current_fateseat_level:set(value)
end

function dst_gi_nahida_skill:SetGrowthValue(value)
    self.nahida_growth_value:set(value)
end

-- 获取技能动态数据
function dst_gi_nahida_skill:GetCurrentEnergy()
    if self.inst.components.dst_gi_nahida_skill then
        return self.inst.components.dst_gi_nahida_skill.current_energy
    elseif self.current_energy:value() then
        return self.current_energy:value()
    end
    return 0
end

function dst_gi_nahida_skill:GetSkillCurrentCd()
    if self.inst.components.dst_gi_nahida_skill then
        return self.inst.components.dst_gi_nahida_skill.nahida_skill_current_cd
    elseif self.nahida_skill_current_cd:value() then
        return self.nahida_skill_current_cd:value()
    end
    return self.nahida_skill_cd
end

function dst_gi_nahida_skill:GetBurstCurrentCd()
    if self.inst.components.dst_gi_nahida_skill then
        return self.inst.components.dst_gi_nahida_skill.nahida_burst_current_cd
    elseif self.nahida_burst_current_cd:value() then
        return self.nahida_burst_current_cd:value()
    end
    return self.nahida_burst_cd
end

function dst_gi_nahida_skill:GetCurrentSkillMode()
    if self.inst.components.dst_gi_nahida_skill then
        return self.inst.components.dst_gi_nahida_skill.current_skill_mode
    elseif self.current_skill_mode:value() then
        return self.current_skill_mode:value()
    end
    return "FIGHT"
end

function dst_gi_nahida_skill:GetCurrentFateseatLevel()
    if self.inst.components.dst_gi_nahida_data then
        return self.inst.components.dst_gi_nahida_data.nahida_fateseat_level
    elseif self.current_fateseat_level:value() then
        return self.current_fateseat_level:value()
    end
    return "0"
end

function dst_gi_nahida_skill:GetNahidaGrowthValue()
    if self.inst.components.dst_gi_nahida_data then
        return self.inst.components.dst_gi_nahida_data:GetDamageData()
    elseif self.nahida_growth_value:value() then
        return self.nahida_growth_value:value()
    end
    return "0"
end

return dst_gi_nahida_skill