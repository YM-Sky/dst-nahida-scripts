---
--- dst_gi_nahida_character_card_button.lua
--- Description: 地图上的传送按钮
--- Author: 没有小钱钱
--- Date: 2025/7/8 15:05
---
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local dst_gi_nahida_character_card_panel = require('core_'..TUNING.MOD_ID..'/widgets/dst_gi_nahida_character_card_panel')

local INIT_X, INIT_Y = 0, 0
local infopanel_offset = 150

local dst_gi_nahida_character_card_button = Class(Widget, function(self, owner)
    Widget._ctor(self, "dst_gi_nahida_character_card_button")
    self.owner = owner

    self.container = self:AddChild(Widget("container"))

    -- 面板实例，默认隐藏
    self.infopanel = self:AddChild(dst_gi_nahida_character_card_panel(self.owner))
    self.infopanel:Hide()
    self.infopanel_open = false

    -- 按钮
    self.dst_gi_nahida_character_card_button = self.container:AddChild(ImageButton("images/ui/dst_gi_character_ui.xml", "dst_gi_character_ui.tex"))
    self.dst_gi_nahida_character_card_button:SetText("")
    self.dst_gi_nahida_character_card_button:SetScale(0.8,0.8,0.8)
    self.dst_gi_nahida_character_card_button:SetTooltip(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CHARACTER_CARD_TIPS)

    self.dst_gi_nahida_character_card_button:SetOnClick(function()
        if self.infopanel_open then
            self.infopanel:Hide()
            self.infopanel_open = false
            self.dst_gi_nahida_character_card_button:SetTooltip(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CHARACTER_CARD_TIPS)
        else
            self.infopanel:Show()
            self.infopanel_open = true
            -- 添加这行：显示面板时设置正确位置
            self.infopanel:SetPosition(self.drag_button_pt.x + infopanel_offset, self.drag_button_pt.y, 0)
            self.dst_gi_nahida_character_card_button:SetTooltip(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CHARACTER_CARD_CLOSE_TIPS)
        end
    end)

    -- 拖动相关
    self.drag_button_pt = Vector3(INIT_X, INIT_Y, 0)
    self.dst_gi_nahida_character_card_button:SetPosition(INIT_X, INIT_Y, 0)
    TheSim:GetPersistentString("dst_gi_nahida_character_card_button", function(load_success, str)
        if load_success and str then
            local pt = string.split(str, ",")
            self.drag_button_pt = Vector3(tonumber(pt[1]), tonumber(pt[2]), 0)
            self.dst_gi_nahida_character_card_button:SetPosition(self.drag_button_pt.x, self.drag_button_pt.y, 0)
            self.infopanel:SetPosition(self.drag_button_pt.x + infopanel_offset, self.drag_button_pt.y, 0)
        end
    end)

    self.dst_gi_nahida_character_card_button.OnMouseButton = function(_, button, down, x, y)
        return self:OnMouseButton(button, down, x, y)
    end
end)

-- 拖动相关方法
function dst_gi_nahida_character_card_button:GetDragPosition(x, y)
    local mouse_pt = TheInput:GetScreenPosition()
    local widget_pt = self.dst_gi_nahida_character_card_button:GetPosition()
    local widget_scale = self.dst_gi_nahida_character_card_button:GetScale()
    local offset = 1.25
    return widget_pt + (Vector3(x, y, 0) - mouse_pt) / (widget_scale.x / offset)
end

function dst_gi_nahida_character_card_button:SaveDragPosition()
    if self.drag_button_pt then
        local pt = self.drag_button_pt
        TheSim:SetPersistentString("dst_gi_nahida_character_card_button", tostring(pt.x) .. "," .. tostring(pt.y))
    end
end

function dst_gi_nahida_character_card_button:StartDrag()
    self:FollowMouse()
end

function dst_gi_nahida_character_card_button:StopDrag(x, y)
    self:StopFollowMouse()
    self.drag_button_pt = self:GetDragPosition(x, y)
    self.dst_gi_nahida_character_card_button:SetPosition(self.drag_button_pt.x, self.drag_button_pt.y)

    -- 添加这行：拖动结束时更新面板位置
    if self.infopanel_open then
        self.infopanel:SetPosition(self.drag_button_pt.x + infopanel_offset, self.drag_button_pt.y, 0)
    end

    self:SaveDragPosition()
end

function dst_gi_nahida_character_card_button:FollowMouse()
    if self.followhandler == nil then
        self.followhandler = TheInput:AddMoveHandler(function(x, y)
            local mouse_pt = Vector3(x, y, 0)
            local new_pos = mouse_pt + (self.drag_offset or Vector3(0, 0, 0))
            self.drag_button_pt = new_pos
            self.dst_gi_nahida_character_card_button:SetPosition(new_pos.x, new_pos.y)

            -- 添加这行：实时更新面板位置
            if self.infopanel_open then
                self.infopanel:SetPosition(new_pos.x + infopanel_offset, new_pos.y, 0)
            end

            if not Input:IsMouseDown(MOUSEBUTTON_RIGHT) then
                self:StopDrag(x, y)
            end
        end)
        if self.drag_button_pt then
            self.dst_gi_nahida_character_card_button:SetPosition(self.drag_button_pt.x, self.drag_button_pt.y)
        end
    end
end

function dst_gi_nahida_character_card_button:StopFollowMouse()
    if self.followhandler then
        self.followhandler:Remove()
        self.followhandler = nil
    end
end

function dst_gi_nahida_character_card_button:OnMouseButton(button, down, x, y)
    if not self.focus then
        return false
    end
    if button == MOUSEBUTTON_RIGHT and down then
        local mouse_pt = TheInput:GetScreenPosition()
        local widget_pt = self.dst_gi_nahida_character_card_button:GetPosition()
        self.drag_offset = widget_pt - Vector3(mouse_pt.x, mouse_pt.y, 0)
        self:StartDrag()
    else
        self:StopDrag(x, y)
        self.drag_offset = nil
    end
end

function dst_gi_nahida_character_card_button:ResetPosition()
    self.drag_button_pt = Vector3(INIT_X, INIT_Y, 0)
    self.dst_gi_nahida_character_card_button:SetPosition(INIT_X, INIT_Y, 0)
    self.infopanel:SetPosition(INIT_X + infopanel_offset, INIT_Y, 0)
    self:SaveDragPosition()
end

return dst_gi_nahida_character_card_button