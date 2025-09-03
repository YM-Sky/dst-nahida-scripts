---
--- dst_gi_nahida_setting_button.lua
--- Description: 
--- Author: 旅行者
--- Date: 2025/7/13 1:24
---
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local dst_gi_nahida_setting_infopanel = require('core_'..TUNING.MOD_ID..'/widgets/dst_gi_nahida_setting_infopanel')

local dst_gi_nahida_setting_button = Class(Widget, function(self, owner)
    Widget._ctor(self, "dst_gi_nahida_setting_button")
    self.owner = owner
    self.container = self:AddChild(Widget("container"))

    local w, h = TheSim:GetScreenSize()

    -- 设置面板实例，默认隐藏
    self.infopanel = self:AddChild(dst_gi_nahida_setting_infopanel(self.owner,w, h))
    self.infopanel:Hide()
    self.infopanel:SetPosition(0.5 * w, 0.5 * h, 0)

    -- 设置按钮
    self.dst_gi_nahida_setting_button = self.container:AddChild(ImageButton("images/ui/dst_nahida_setting_icon.xml", "dst_nahida_setting_icon.tex"))
    self.dst_gi_nahida_setting_button:SetText("")
    self.dst_gi_nahida_setting_button:SetOnClick(function()
        self.infopanel:Show()
    end)
end)

return dst_gi_nahida_setting_button