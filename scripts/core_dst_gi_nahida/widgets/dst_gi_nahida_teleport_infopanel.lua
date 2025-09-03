local Widget = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NihidaGwidget')
local Text = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NihidaGText')
local Image = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NahidaGimage')
local ImageButton = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NahidaGimagebutton')
local GMultiLayerButton = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NahidaGmultilayerbutton')
require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NahidaGbtnpresets')

local origin_size = {x = 321, y = 704}  -- 右侧原始大小

local dst_gi_nahida_teleport_infopanel = Class(Widget, function(self, owner, w, h)
    Widget._ctor(self, "DST_GI_NAHIDA_TELEPORT_INFOPANEL")
    self.owner = owner

    local scale = h / origin_size.y  --整体缩放倍率
    local local_y = origin_size.y
    local local_x = (w / h) * local_y
    local widget_x_offset = 0.5 * local_x - 0.5 * origin_size.x
    self:SetScale(scale, scale, scale)

	self.backbg = self:AddChild(ImageButton("images/ui.xml", "blank.tex"))
	self.backbg:ForceImageSize(local_x, local_y)  --(2048, 1024) * 0.8
	self.backbg.scale_on_focus = false  --禁止缩放
	self.backbg.clickoffset = Vector3(0, 0, 0)   --禁止按下移动
	self.backbg:SetOnClick(function()
	    self.parent:HideInfo()
        self:Hide()
	end)
    self.backbg:MoveToBack()

    -------------------------------------------------
    --变量
    self.world_pos = Vector3(0, 0, 0)
    -------------------------------------------------

    self.bg = self:AddChild(Image("images/ui/teleport_bg.xml", "teleport_bg.tex"))
    self.bg:SetPosition(widget_x_offset, 0, 0)

    self.icon = self:AddChild(Image("images/ui/teleport_waypoint_button.xml", "teleport_waypoint_button.tex"))
    self.icon:SetScale(0.5, 0.5, 0.5)
    self.icon:SetPosition(widget_x_offset - 135, 330, 0)

    self.title = self:AddChild(Text("spirequal", 27, STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TELEPORT_WAYPOINT
    , {211/255, 188/255, 142/255, 1}))
    self.title:SetPosition(widget_x_offset - 8, 328, 0)
    self.title:SetHAlign(ANCHOR_LEFT)
    self.title:SetVAlign(ANCHOR_MIDDLE)
    self.title:SetRegionSize(225, 100)
    self.title:EnableWordWrap(true)
    
    self.custom_text_bg = self:AddChild(Image("images/ui/teleport_loc_bg.xml", "teleport_loc_bg.tex"))
    self.custom_text_bg:SetScale(0.49, 0.49, 0.49)
    self.custom_text_bg:SetPosition(widget_x_offset + 0, 276, 0)

    self.custom_text = self:AddChild(Text("spirequal", 20, STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_ETERNAL_LANDS
    , {103/255, 107/255, 116/255, 1}))
    self.custom_text:SetPosition(widget_x_offset + 20, 275, 0)
    self.custom_text:SetHAlign(ANCHOR_LEFT)
    self.custom_text:SetVAlign(ANCHOR_MIDDLE)
    self.custom_text:SetRegionSize(280, 100)
    self.custom_text:EnableWordWrap(true)

    self.detail_text = self:AddChild(Text("spirequal", 23, STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TELEPORT_WAYPOINT_DETAIL, {104/255, 110/255, 123/255, 1}))
    self.detail_text:SetPosition(widget_x_offset + 2, 0, 0)
    self.detail_text:SetHAlign(ANCHOR_LEFT)
    self.detail_text:SetVAlign(ANCHOR_TOP)
    self.detail_text:SetRegionSize(290, 512)
    self.detail_text:EnableWordWrap(true)

    self.confirm_btn = self:AddChild(GMultiLayerButton(GetDefaultGButtonConfig("dark", "medlong", "teleport")))
    self.confirm_btn:SetScale(0.642)
    self.confirm_btn:SetPosition(widget_x_offset + 0, -306, 0)
    self.confirm_btn:SetText(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TELEPORT)
    self.confirm_btn:SetOnClick(function ()
        local x, y, z = self.world_pos:Get()
        -- 关闭地图界面：
        if self.owner ~= nil and self.owner.HUD ~= nil and self.owner.HUD:IsMapScreenOpen() then
            TheFrontEnd:PopScreen()
        end
        --传送
        SendModRPCToServer(GetModRPC("dst_gi_nahida_tp", "tptowaypoint"), x, y, z)
    end)

    self.close = self:AddChild(GMultiLayerButton(GetSingleGButtonConfig("light", "images/ui/icon_genshin_button.xml", "icon_close.tex")))
    self.close:SetPosition(widget_x_offset + 130, 329, 0)
    self.close:SetScale(0.66, 0.66, 0.66)
    self.close:SetOnClick(function ()
        self.parent:HideInfo()
        self:Hide()
    end)
end)

function dst_gi_nahida_teleport_infopanel:ShowInfo(world_pos, custom_info)
    self.world_pos = world_pos
    if custom_info ~= nil then
        self.custom_text:SetString(custom_info)
    else

    end
    self:Show()
end

return dst_gi_nahida_teleport_infopanel