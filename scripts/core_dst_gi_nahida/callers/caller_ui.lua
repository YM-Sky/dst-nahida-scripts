---
--- caller_ui.lua
--- Description: 
--- Author: 没有小钱钱
--- Date: 2025/3/30 3:02
---
local dst_gi_nahida_burst_widgets = require('core_'..TUNING.MOD_ID..'/widgets/dst_gi_nahida_burst_widgets')
local dst_gi_nahida_skill_widgets = require('core_'..TUNING.MOD_ID..'/widgets/dst_gi_nahida_skill_widgets')
local dst_gi_nahida_skill_button = require('core_'..TUNING.MOD_ID..'/widgets/dst_gi_nahida_skill_button')
local dst_gi_nahida_setting_button = require('core_'..TUNING.MOD_ID..'/widgets/dst_gi_nahida_setting_button')
local dst_gi_nahida_teleport_button = require('core_'..TUNING.MOD_ID..'/widgets/dst_gi_nahida_teleport_button')
local dst_gi_nahida_character_card_button = require('core_'..TUNING.MOD_ID..'/widgets/dst_gi_nahida_character_card_button')
local function AddHDHUD(self)
    local dst_gi_nahida_character_card_button_flag = false
    if TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.SKILL_BAR_PERMISSION == "all_players" then
        dst_gi_nahida_character_card_button_flag = true
    elseif TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.SKILL_BAR_PERMISSION == "mod_character_only"
        and self.owner or not self.owner:HasTag(TUNING.AVATAR_NAME)
    then
        dst_gi_nahida_character_card_button_flag = true
    end
    if dst_gi_nahida_character_card_button_flag then
        -- 🔥 角色栏
        self.dst_gi_nahida_character_card_button = self:AddChild(dst_gi_nahida_character_card_button(self.owner))
        self.dst_gi_nahida_character_card_button:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
        self.dst_gi_nahida_character_card_button:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
        self.dst_gi_nahida_character_card_button:SetPosition(330,250)
    end

    -- 🔥 传送按钮
    self.dst_gi_nahida_teleport_button = self:AddChild(dst_gi_nahida_teleport_button(self.owner))
    self.dst_gi_nahida_teleport_button:SetHAnchor(2) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.dst_gi_nahida_teleport_button:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.dst_gi_nahida_teleport_button:SetPosition(-220, 100) -- 原来是80，往下移30像素


    if not self.owner or not self.owner:HasTag(TUNING.AVATAR_NAME) then return end
    self.dst_gi_nahida_burst_widgets = self:AddChild(dst_gi_nahida_burst_widgets(self.owner))
    self.dst_gi_nahida_burst_widgets:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.dst_gi_nahida_burst_widgets:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.dst_gi_nahida_burst_widgets:SetPosition(330,180)

    self.dst_gi_nahida_skill_widgets = self:AddChild(dst_gi_nahida_skill_widgets(self.owner))
    self.dst_gi_nahida_skill_widgets:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.dst_gi_nahida_skill_widgets:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.dst_gi_nahida_skill_widgets:SetPosition(220,180)

    -- 🔥 技能切换按钮 - 放在技能图标下面一点
    self.dst_gi_nahida_skill_button = self:AddChild(dst_gi_nahida_skill_button(self.owner))
    self.dst_gi_nahida_skill_button:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.dst_gi_nahida_skill_button:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.dst_gi_nahida_skill_button:SetPosition(220, 100) -- 原来是80，往下移30像素

    -- 🔥 技能切换按钮 - 放在技能图标下面一点
    self.dst_gi_nahida_setting_button = self:AddChild(dst_gi_nahida_setting_button(self.owner))
    self.dst_gi_nahida_setting_button:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.dst_gi_nahida_setting_button:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.dst_gi_nahida_setting_button:SetPosition(325, 100) -- 原来是80，往下移30像素
end

AddClassPostConstruct("widgets/statusdisplays", AddHDHUD)