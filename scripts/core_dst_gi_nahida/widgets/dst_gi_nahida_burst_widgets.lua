---
--- dst_gi_nahida_burst_widgets.lua
--- Description: 技能图标UI
--- Author: 没有小钱钱
--- Date: 2025/3/29 1:10
---

local Widget = require "widgets/widget"
local Text = require "widgets/text"
local UIAnim = require "widgets/uianim"

local P1 = { 135 / 255, 206 / 255, 235 / 255, 1.0 }  --天蓝色
local P2 = { 1, 1, 1, 1 }

local dst_gi_nahida_burst_widgets = Class(Widget, function(self, owner)
    Widget._ctor(self, "dst_gi_nahida_burst_widgets")
    self.owner = owner
    self:SetScale(0.5, 0.5) -- 将badge放大为三围大小的两倍

    self.root = self:AddChild(Widget())
    self.root:SetPosition(0, 0)

    self.title = self.root:AddChild(Text(HEADERFONT, 50, "0", P2))
    self.title:SetPosition(0, 0)

    self.fateseat_level_title = self.root:AddChild(Text(HEADERFONT, 50, STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT .. ":0", P2))
    self.fateseat_level_title:SetPosition(0, -80)

    self.anim = self:AddChild(UIAnim())
    self.anim:GetAnimState():PlayAnimation("idle")
    self.anim:GetAnimState():SetBuild("dst_gi_nahida_skill")
    self.anim:GetAnimState():SetScale(0.8, 0.8, 0.8)
    self.anim:SetClickable(false)

    self.inst:DoTaskInTime(0, function()
        self.owner:ListenForEvent(TUNING.MOD_ID .. "_current_energy_change_event", function(_owner, data)
            if not data or not data.current_energy then
                return
            end
            self:Energy(data.current_energy)
        end)
        if self.owner.replica.dst_gi_nahida_skill then
            self:Energy(self.owner.replica.dst_gi_nahida_skill:GetCurrentEnergy())
        else
            self:Energy(0)
        end
    end)

    self.owner:ListenForEvent(TUNING.MOD_ID .. "_nahida_burst_current_cd_change_event", function(_owner, data)
        if not data or not data.nahida_burst_current_cd then
            return
        end
        self:BurstCd(data.nahida_burst_current_cd)
    end)

    self.owner:ListenForEvent(TUNING.MOD_ID .. "_nahida_current_fateseat_level_change_event", function(_owner, data)
        if not data or not data.current_fateseat_level then
            return
        end
        self:SetFateseatLevel(data.current_fateseat_level)
    end)

end)

function dst_gi_nahida_burst_widgets:Energy(num)
    if not num then
        return
    end
    local aim_num = 0
    if num >= 50 then
        aim_num = 50
    elseif num >= 45 then
        aim_num = 45
    elseif num >= 40 then
        aim_num = 40
    elseif num >= 35 then
        aim_num = 35
    elseif num >= 30 then
        aim_num = 30
    elseif num >= 25 then
        aim_num = 25
    elseif num >= 20 then
        aim_num = 20
    elseif num >= 15 then
        aim_num = 15
    elseif num >= 10 then
        aim_num = 10
    elseif num >= 5 then
        aim_num = 5
    else
        aim_num = 0
    end
    self.anim:GetAnimState():SetBank("nahida_burst_" .. aim_num)
end

function dst_gi_nahida_burst_widgets:BurstCd(cd)
    -- 使用 string.format 保留两位小数
    local formatted_cd = string.format("%.2f", cd)
    if cd == 0 or cd == "0" then
        -- 隐藏标题文本
        self.title:Hide()
    else
        self.title:SetString(formatted_cd)
        self.title:Show()
    end
end

function dst_gi_nahida_burst_widgets:SetFateseatLevel(level)
    -- 使用 string.format 保留两位小数
    self.fateseat_level_title:SetString(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT .. ": " .. level)
end
return dst_gi_nahida_burst_widgets