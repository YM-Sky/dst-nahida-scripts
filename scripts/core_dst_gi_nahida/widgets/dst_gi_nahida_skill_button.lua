---
--- dst_gi_nahida_skill_button.lua
--- Description: 战技切换按钮
--- Author: 旅行者
--- Date: 2025/7/12 23:04
---
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

local dst_gi_nahida_skill_button = Class(Widget, function(self, owner)
    Widget._ctor(self, "dst_gi_nahida_skill_button")
    self.owner = owner

    self.current_mode = "FIGHT"

    self.container = self:AddChild(Widget("container"))
    self:CreateModeButtons()
    self:UpdateButtonLayout()
    self:UpdateButtonStates()

    -- 监听技能模式切换事件，动态刷新按钮状态
    self.owner:ListenForEvent(TUNING.MOD_ID.."_nahida_current_skill_mode_change_event", function(_owner, data)
        if not data or not data.current_skill_mode then return end
        self:SetCurrentMode(data.current_skill_mode)
    end)
end)

function dst_gi_nahida_skill_button:CreateModeButtons()
    self.mode_buttons = {}

    -- 战斗模式按钮
    self.mode_buttons.FIGHT = self.container:AddChild(ImageButton("images/ui/skill_button.xml", "skill_button.tex"))
    self.mode_buttons.FIGHT:SetText(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.FIGHT_2)
    self.mode_buttons.FIGHT:SetOnClick(function()
        self:OnModeButtonClick("FIGHT")
    end)

    -- 收获模式按钮
    self.mode_buttons.HARVEST = self.container:AddChild(ImageButton("images/ui/skill_button.xml", "skill_button.tex"))
    self.mode_buttons.HARVEST:SetText(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.HARVEST_2)
    self.mode_buttons.HARVEST:SetOnClick(function()
        self:OnModeButtonClick("HARVEST")
    end)

    -- 拾取模式按钮
    self.mode_buttons.PICK_UP = self.container:AddChild(ImageButton("images/ui/skill_button.xml", "skill_button.tex"))
    self.mode_buttons.PICK_UP:SetText(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.PICK_UP_2)
    self.mode_buttons.PICK_UP:SetOnClick(function()
        self:OnModeButtonClick("PICK_UP")
    end)
end

function dst_gi_nahida_skill_button:OnModeButtonClick(mode)
    if self.current_mode == mode then return end
    self.current_mode = mode
    self:UpdateButtonStates()
    -- 这里可以发送RPC
    if mode then
        SendModRPCToServer(GetModRPC("dst_gi_nahida_skill", "send_skill_mode"), mode)
    end
end

function dst_gi_nahida_skill_button:UpdateButtonLayout()
    local button_spacing = 38
    local start_x = -button_spacing
    self.mode_buttons.FIGHT:SetPosition(start_x, 0, 0)
    self.mode_buttons.HARVEST:SetPosition(0, 0, 0)
    self.mode_buttons.PICK_UP:SetPosition(button_spacing, 0, 0)
    for _, button in pairs(self.mode_buttons) do
        button:SetScale(0.9) -- 默认大小整体上调
        if button.text then
            button.text:SetSize(32)
        end
    end
end

function dst_gi_nahida_skill_button:UpdateButtonStates()
    for mode, button in pairs(self.mode_buttons) do
        if mode == self.current_mode then
            button:SetTextColour(1, 0, 0, 1) -- 红色
            button:SetScale(1)              -- 选中更大
        else
            button:SetTextColour(0, 0, 0, 1) -- 黑色
            button:SetScale(0.9)              -- 默认大小
        end
    end
end

-- ... 你的其他代码 ...
function dst_gi_nahida_skill_button:SetCurrentMode(mode)
    if self.current_mode ~= mode then
        self.current_mode = mode
        self:UpdateButtonStates()
    end
end

return dst_gi_nahida_skill_button
