---
--- dst_gi_nahida_teleport_button.lua.lua
--- Description: 传送按钮
--- Author: 旅行者
--- Date: 2025/7/27 18:47
---
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local skintravelscreen = require('core_'..TUNING.MOD_ID..'/widgets/skintravelscreen')

local INIT_X, INIT_Y = 0, 0

local dst_gi_nahida_teleport_button = Class(Widget, function(self, owner)
    Widget._ctor(self, "dst_gi_nahida_teleport_button")
    self.owner = owner
    self.container = self:AddChild(Widget("container"))

    -- 面板实例，默认隐藏
    self.infopanel = self:AddChild(skintravelscreen(self.owner))
    self.infopanel:Hide()
    self.infopanel:SetPosition(0, 0, 0)

    -- 按钮
    self.dst_gi_nahida_teleport_button = self.container:AddChild(ImageButton("images/ui/teleport_waypoint.xml", "teleport_waypoint.tex"))
    self.dst_gi_nahida_teleport_button:SetText("")
    self.dst_gi_nahida_teleport_button:SetTooltip(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TELEPORT_BUTTON_TIPS)
    self.dst_gi_nahida_teleport_button:SetOnClick(function()
        self.infopanel:LoadDests()
        self.infopanel:Show()
    end)

    -- 拖动相关
    self.drag_button_pt = Vector3(INIT_X, INIT_Y, 0)
    self.dst_gi_nahida_teleport_button:SetPosition(INIT_X, INIT_Y, 0)
    TheSim:GetPersistentString("dst_gi_nahida_teleport_button", function(load_success, str)
        if load_success and str then
            local pt = string.split(str, ",")
            self.drag_button_pt = Vector3(tonumber(pt[1]), tonumber(pt[2]), 0)
            self.dst_gi_nahida_teleport_button:SetPosition(self.drag_button_pt.x, self.drag_button_pt.y, 0)
        end
    end)

    self.dst_gi_nahida_teleport_button.OnMouseButton = function(_, button, down, x, y)
        return self:OnMouseButton(button, down, x, y)
    end
end)

-- 拖动相关方法
function dst_gi_nahida_teleport_button:GetDragPosition(x, y)
    local mouse_pt = TheInput:GetScreenPosition()
    local widget_pt = self.dst_gi_nahida_teleport_button:GetPosition()
    local widget_scale = self.dst_gi_nahida_teleport_button:GetScale()
    local offset = 1.25
    return widget_pt + (Vector3(x, y, 0) - mouse_pt) / (widget_scale.x / offset)
end

function dst_gi_nahida_teleport_button:SaveDragPosition()
    if self.drag_button_pt then
        local pt = self.drag_button_pt
        TheSim:SetPersistentString("dst_gi_nahida_teleport_button", tostring(pt.x) .. "," .. tostring(pt.y))
    end
end

function dst_gi_nahida_teleport_button:StartDrag()
    self:FollowMouse()
end

function dst_gi_nahida_teleport_button:StopDrag(x, y)
    self:StopFollowMouse()
    self.drag_button_pt = self:GetDragPosition(x, y)
    self.dst_gi_nahida_teleport_button:SetPosition(self.drag_button_pt.x, self.drag_button_pt.y)
    self:SaveDragPosition()
end

function dst_gi_nahida_teleport_button:FollowMouse()
    if self.followhandler == nil then
        self.followhandler = TheInput:AddMoveHandler(function(x, y)
            local mouse_pt = Vector3(x, y, 0)
            local new_pos = mouse_pt + (self.drag_offset or Vector3(0, 0, 0))
            self.drag_button_pt = new_pos
            self.dst_gi_nahida_teleport_button:SetPosition(new_pos.x, new_pos.y)
            if not Input:IsMouseDown(MOUSEBUTTON_RIGHT) then
                self:StopDrag(x, y)
            end
        end)
        if self.drag_button_pt then
            self.dst_gi_nahida_teleport_button:SetPosition(self.drag_button_pt.x, self.drag_button_pt.y)
        end
    end
end

function dst_gi_nahida_teleport_button:StopFollowMouse()
    if self.followhandler then
        self.followhandler:Remove()
        self.followhandler = nil
    end
end

function dst_gi_nahida_teleport_button:OnMouseButton(button, down, x, y)
    if not self.focus then
        return false
    end
    if button == MOUSEBUTTON_RIGHT and down then
        local mouse_pt = TheInput:GetScreenPosition()
        local widget_pt = self.dst_gi_nahida_teleport_button:GetPosition()
        self.drag_offset = widget_pt - Vector3(mouse_pt.x, mouse_pt.y, 0)
        self:StartDrag()
    else
        self:StopDrag(x, y)
        self.drag_offset = nil
    end
end

return dst_gi_nahida_teleport_button