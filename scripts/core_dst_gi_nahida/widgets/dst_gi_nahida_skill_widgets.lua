---
--- dst_gi_nahida_skill_widgets.lua
--- Description: 技能图标UI
--- Author: 没有小钱钱
--- Date: 2025/3/29 1:10
---

local  Widget = require "widgets/widget"
local Text = require "widgets/text"
local UIAnim = require "widgets/uianim"

local P1 = {135/255,206/255,235/255,1.0}  --天蓝色
local P2 = {1, 1, 1, 1}

local dst_gi_nahida_skill_widgets = Class(Widget, function(self, owner)
    Widget._ctor(self, "dst_gi_nahida_skill_widgets")
    self.owner = owner
    self:SetScale(0.5, 0.5) -- 将badge放大为三围大小的两倍

    self.root = self:AddChild(Widget())
    self.root:SetPosition(0,0)

    self.title = self.root:AddChild(Text(HEADERFONT, 50, "", P2))
    self.title:SetPosition(0,0)

    self.skill_mod_title = self.root:AddChild(Text(HEADERFONT, 50, "战斗模式", P2))
    self.skill_mod_title:SetPosition(0,-80)

    self.anim = self:AddChild(UIAnim())
    self.anim:GetAnimState():SetBank("nahida_skill")
    self.anim:GetAnimState():PlayAnimation("idle")
    self.anim:GetAnimState():SetBuild("dst_gi_nahida_skill")
    self.anim:GetAnimState():SetScale(0.8, 0.8, 0.8)
    --self.anim:GetAnimState():SetScale(0.2,0.2,0.2)
    self.anim:SetClickable(false)

    self.owner:ListenForEvent(TUNING.MOD_ID.."_nahida_skill_current_cd_change_event", function(_owner, data)
        if not data or not data.nahida_skill_current_cd then return end
        self:SkillCd(data.nahida_skill_current_cd)
    end)

    self.owner:ListenForEvent(TUNING.MOD_ID.."_nahida_current_skill_mode_change_event", function(_owner, data)
        if not data or not data.current_skill_mode then return end
        self:SetSkillMode(data.current_skill_mode)
    end)

end)


function dst_gi_nahida_skill_widgets:SkillCd(cd)
    -- 使用 string.format 保留两位小数
    local formatted_cd = string.format("%.2f", cd)
    if cd == 0 or cd == "0" then
        -- 隐藏标题文本
        self.title:SetString("")
    else
        self.title:SetString(formatted_cd)
        self.title:Show()
    end
end

function dst_gi_nahida_skill_widgets:SetSkillMode(mode)
    -- 使用 string.format 保留两位小数
    self.skill_mod_title:SetString(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE[string.upper(mode)])
end
return dst_gi_nahida_skill_widgets