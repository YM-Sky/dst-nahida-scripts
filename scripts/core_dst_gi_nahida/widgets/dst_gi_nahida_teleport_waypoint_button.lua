---
--- dst_gi_nahida_teleport_waypoint_button.lua
--- Description: 地图上的传送按钮
--- Author: 没有小钱钱
--- Date: 2025/7/8 15:05
---
local GWidget = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NihidaGwidget')
local Image = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NahidaGimage')
local ImageButton = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NahidaGimagebutton')

local dst_gi_nahida_teleport_waypoint_button = Class(GWidget, function(self, owner, waypoint_id, world_pos, custom_info)
    GWidget._ctor(self, "DST_GI_NAHIDA_TELEPORT_WAYPOINT_BUTTON")

    self.owner = owner
    self.waypoint_id = waypoint_id
    self.world_pos = world_pos
    self.custom_info = custom_info

    self.ring = self:AddChild(Image("images/ui/tp_select_ring.xml", "tp_select_ring.tex"))
    self.ring:Hide(-1)
    self.ring:SetPosition(-2.5, 0, 0)

    self.btn = self:AddChild(ImageButton("images/ui/teleport_waypoint_button.xml", "teleport_waypoint_button.tex"))
    self.btn:SetPosition(0, 0, 0)
    self.btn.focus_scale = {1.15, 1.15, 1.15}
    self.btn.normal_scale = {1, 1, 1}
    self.btn:SetOnSelect(function()
        self.btn.image:TransitScale(self.btn.focus_scale[1], self.btn.focus_scale[2], self.btn.focus_scale[3])
        self.ring:Show()
    end)
    self.btn:SetOnUnSelect(function()
        self.btn.image:TransitScale(self.btn.normal_scale[1], self.btn.normal_scale[2], self.btn.normal_scale[3])
        self.ring:Hide()
    end)

    self:SetScale(1, 1, 1)
    self:StartUpdating()
end)

function dst_gi_nahida_teleport_waypoint_button:Select()
    self.btn:Select()
end

function dst_gi_nahida_teleport_waypoint_button:Unselect()
    self.btn:Unselect()
end

function dst_gi_nahida_teleport_waypoint_button:SetOnClick(fn)
    self.btn:SetOnClick(fn)
end

function dst_gi_nahida_teleport_waypoint_button:OnUpdate()
    if not self.parent or not self.parent.minimap or not self.world_pos then
        return
    end

    local scale_multiple = self.parent.minimap:GetZoom()
    if scale_multiple > 5 then
        self:Hide()
    else
        self:Show()
    end

    local x, y, z = self.world_pos:Get()
    local map_x, map_y = self.parent.minimap:WorldPosToMapPos(x, z, 0)
    local screen_width, screen_height = TheSim:GetScreenSize()
    local screen_x = (map_x + 1) * screen_width / 2
    local screen_y = (map_y + 1) * screen_height / 2
    self:SetPosition(screen_x, screen_y)
end

return dst_gi_nahida_teleport_waypoint_button