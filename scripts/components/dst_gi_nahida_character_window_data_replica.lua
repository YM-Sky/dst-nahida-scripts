---
--- dst_gi_nahida_character_window_data_replica.lua
--- Description: 人物栏
--- Author: 旅行者
--- Date: 2025/8/16 16:16
---

local function OnCharacter1(inst)
    local character1 = inst.replica.dst_gi_nahida_character_window_data:GetCharacter1()
    inst:PushEvent(TUNING.MOD_ID.."_character1_change_event", {character1 = character1})
end
local function OnCharacter2(inst)
    local character2 = inst.replica.dst_gi_nahida_character_window_data:GetCharacter2()
    inst:PushEvent(TUNING.MOD_ID.."_character2_change_event", {character2 = character2})
end
local function OnCharacter3(inst)
    local character3 = inst.replica.dst_gi_nahida_character_window_data:GetCharacter3()
    inst:PushEvent(TUNING.MOD_ID.."_character3_change_event", {character3 = character3})
end

local function OnCharacter1CD(inst)
    local character1_cd = inst.replica.dst_gi_nahida_character_window_data:GetCharacter1CD()
    inst:PushEvent(TUNING.MOD_ID.."_character1_cd_change_event", {character1_cd = character1_cd})
end
local function OnCharacter2CD(inst)
    local character2_cd = inst.replica.dst_gi_nahida_character_window_data:GetCharacter2CD()
    inst:PushEvent(TUNING.MOD_ID.."_character2_cd_change_event", {character2_cd = character2_cd})
end
local function OnCharacter3CD(inst)
    local character3_cd = inst.replica.dst_gi_nahida_character_window_data:GetCharacter3CD()
    inst:PushEvent(TUNING.MOD_ID.."_character3_cd_change_event", {character3_cd = character3_cd})
end

local dst_gi_nahida_character_window_data = Class(function(self, inst)
    self.inst = inst
    -- 先创建网络变量
    self.replica_character1 = net_string(inst.GUID, TUNING.MOD_ID.."_replica_character1_guid", TUNING.MOD_ID.."_replica_character1_guid_change_event")
    self.replica_character2 = net_string(inst.GUID, TUNING.MOD_ID.."_replica_character2_guid", TUNING.MOD_ID.."_replica_character2_guid_change_event")
    self.replica_character3 = net_string(inst.GUID, TUNING.MOD_ID.."_replica_character3_guid", TUNING.MOD_ID.."_replica_character3_guid_change_event")
    self.replica_character1_cd = net_float(inst.GUID, TUNING.MOD_ID.."_replica_character1_cd_guid", TUNING.MOD_ID.."_replica_character1_cd_guid_change_event")
    self.replica_character2_cd = net_float(inst.GUID, TUNING.MOD_ID.."_replica_character2_cd_guid", TUNING.MOD_ID.."_replica_character2_cd_guid_change_event")
    self.replica_character3_cd = net_float(inst.GUID, TUNING.MOD_ID.."_replica_character3_cd_guid", TUNING.MOD_ID.."_replica_character3_cd_guid_change_event")

    -- 在客户端监听事件
    if not TheWorld.ismastersim then
        inst:ListenForEvent(TUNING.MOD_ID.."_replica_character1_guid_change_event", OnCharacter1)
        inst:ListenForEvent(TUNING.MOD_ID.."_replica_character2_guid_change_event", OnCharacter2)
        inst:ListenForEvent(TUNING.MOD_ID.."_replica_character3_guid_change_event", OnCharacter3)
        inst:ListenForEvent(TUNING.MOD_ID.."_replica_character1_cd_guid_change_event", OnCharacter1CD)
        inst:ListenForEvent(TUNING.MOD_ID.."_replica_character2_cd_guid_change_event", OnCharacter2CD)
        inst:ListenForEvent(TUNING.MOD_ID.."_replica_character3_cd_guid_change_event", OnCharacter3CD)
    end
end)

function dst_gi_nahida_character_window_data:SetCharacter1(value)
    self.replica_character1:set(value)
end

function dst_gi_nahida_character_window_data:SetCharacter2(value)
    self.replica_character2:set(value)
end

function dst_gi_nahida_character_window_data:SetCharacter3(value)
    self.replica_character3:set(value)
end

function dst_gi_nahida_character_window_data:SetCharacter1CD(value)
    self.replica_character1_cd:set(value)
end

function dst_gi_nahida_character_window_data:SetCharacter2CD(value)
    self.replica_character2_cd:set(value)
end

function dst_gi_nahida_character_window_data:SetCharacter3CD(value)
    self.replica_character3_cd:set(value)
end

function dst_gi_nahida_character_window_data:GetCharacter1()
    if self.replica_character1:value() then
        return self.replica_character1:value()
    end
    return ""
end

function dst_gi_nahida_character_window_data:GetCharacter2()
    if self.replica_character2:value() then
        return self.replica_character2:value()
    end
    return ""
end

function dst_gi_nahida_character_window_data:GetCharacter3()
    if self.replica_character3:value() then
        return self.replica_character3:value()
    end
    return ""
end

function dst_gi_nahida_character_window_data:GetCharacter1CD()
    if self.replica_character1_cd:value() then
        return self.replica_character1_cd:value()
    end
    return 0
end

function dst_gi_nahida_character_window_data:GetCharacter2CD()
    if self.replica_character2_cd:value() then
        return self.replica_character2_cd:value()
    end
    return 0
end

function dst_gi_nahida_character_window_data:GetCharacter3CD()
    if self.replica_character3_cd:value() then
        return self.replica_character3_cd:value()
    end
    return 0
end


return dst_gi_nahida_character_window_data