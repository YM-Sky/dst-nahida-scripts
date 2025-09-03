---
--- dst_gi_nahida_setting_infopanel.lua
--- Description: 
--- Author: 旅行者
--- Date: 2025/7/13 1:24
---
local Widget = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NihidaGwidget')
local Text = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NihidaGText')
local Image = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NahidaGimage')
local ImageButton = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NahidaGimagebutton')
local GMultiLayerButton = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NahidaGmultilayerbutton')
require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NahidaGbtnpresets')

local PANEL_W, PANEL_H = 321, 704

local dst_gi_nahida_setting_infopanel = Class(Widget, function(self, owner, screen_w, screen_h)
    Widget._ctor(self, "dst_gi_nahida_setting_infopanel")
    self.owner = owner
    self.container = self:AddChild(Widget("container"))

    -- 缩放和居中
    local scale = math.min(screen_w / PANEL_W, screen_h / PANEL_H) * 0.8
    self:SetScale(scale, scale, scale)
    self:SetPosition((screen_w - PANEL_W * scale) / 2, (screen_h - PANEL_H * scale) / 2, 0)

    -- 只用 teleport_bg 作为背景
    self.bg = self:AddChild(Image("images/ui/teleport_bg.xml", "teleport_bg.tex"))
    self.bg:SetPosition(0, 0, 0)
    --self.bg:ForceImageSize(PANEL_W, PANEL_H)
    self.bg:MoveToBack()

    -- 标题区（头像+标题，靠上）
    -- 标题区（头像+标题，靠上，标题更居中）
    local title_y = PANEL_H/2 - 25
    self.icon = self.container:AddChild(Image("images/inventoryimages/dst_gi_nahida.xml", "dst_gi_nahida.tex"))
    self.icon:SetScale(0.5, 0.5, 0.5)
    self.icon:SetPosition(-110, title_y, 0)

    self.title = self.container:AddChild(Text("spirequal", 40, "纳西妲设置面板", {211/255, 188/255, 142/255, 1}))
    self.title:SetPosition(0, title_y, 0)
    self.title:SetHAlign(ANCHOR_LEFT)
    self.title:SetVAlign(ANCHOR_MIDDLE)

    -- 第一行：成长值（字体更大，颜色黑色）
    self.growth = self.container:AddChild(Text("spirequal", 32, STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.NAHIDA_GROWTH_VALUE.."：0", {0, 0, 0, 1}))
    self.growth:SetPosition(-70, title_y - 50, 0)
    self.growth:SetHAlign(ANCHOR_LEFT)

    -- 第二行：提取命座按钮（更大）
    self.fateseat_btn = self.container:AddChild(ImageButton("images/ui/dst_gi_nahida_fateseat_btn.xml", "dst_gi_nahida_fateseat_btn.tex"))
    self.fateseat_btn:SetText(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.EXTRACTION_FATESEAT)
    self.fateseat_btn.text:SetSize(80)  -- 只改字体大小，不影响图片
    self.fateseat_btn:SetPosition(0, title_y - 100, 0)
    self.fateseat_btn:SetScale(0.3)
    self.fateseat_btn:SetOnClick(function()
        print("打印发送RPC")
        -- 这里写提取命座的逻辑
        SendModRPCToServer(GetModRPC("dst_gi_nahida_skill", "dst_gi_nahida_extraction_fateseat"))
    end)

    -- 第三行：同步传送锚点（更大）
    --self.ahida_sync_btn = self.container:AddChild(ImageButton("images/ui/dst_gi_nahida_sync_tp.xml", "dst_gi_nahida_sync_tp.tex"))
    --self.ahida_sync_btn:SetText(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SYNC_TP)
    --self.ahida_sync_btn.text:SetSize(80)  -- 只改字体大小，不影响图片
    --self.ahida_sync_btn:SetPosition(0, title_y - 150, 0)
    --self.ahida_sync_btn:SetScale(0.3)
    --self.ahida_sync_btn:SetOnClick(function()
    --    -- 这里写提取命座的逻辑
    --    SendModRPCToServer(GetModRPC("dst_gi_nahida_sync_tp", "nahida_sync_tp"))
    --end)

    -- 第四行：恢复数据标题
    --self.restore_data = self.container:AddChild(Text("spirequal", 32, STRINGS.MOD_DST_GI_NAHIDA.RESTORE_DATA, {0, 0, 0, 1}))
    --self.restore_data:SetPosition(-70, title_y - 150, 0)
    --self.restore_data:SetHAlign(ANCHOR_LEFT)
    --
    ---- 第四行 恢复数据
    --self.restore_data_nahida_data_btn = self.container:AddChild(ImageButton("images/ui/dst_gi_nahida_small_button.xml", "dst_gi_nahida_small_button.tex"))
    --self.restore_data_nahida_data_btn:SetText(STRINGS.MOD_DST_GI_NAHIDA.RESTORE_DATA_NAHIDA_DATA)
    --self.restore_data_nahida_data_btn.text:SetSize(80)  -- 只改字体大小，不影响图片
    --self.restore_data_nahida_data_btn:SetPosition(-70, title_y - 190, 0)
    --self.restore_data_nahida_data_btn:SetScale(0.3)
    --self.restore_data_nahida_data_btn:SetOnClick(function()
    --    -- 这里写提取命座的逻辑
    --    SendModRPCToServer(GetModRPC("dst_gi_nahida_restore_data", "nahida_data"))
    --end)
    --self.restore_data_weapon_staff_data_btn = self.container:AddChild(ImageButton("images/ui/dst_gi_nahida_small_button.xml", "dst_gi_nahida_small_button.tex"))
    --self.restore_data_weapon_staff_data_btn:SetText(STRINGS.MOD_DST_GI_NAHIDA.RESTORE_DATA_WEAPON_STAFF_DATA)
    --self.restore_data_weapon_staff_data_btn.text:SetSize(80)  -- 只改字体大小，不影响图片
    --self.restore_data_weapon_staff_data_btn:SetPosition(0, title_y - 190, 0)
    --self.restore_data_weapon_staff_data_btn:SetScale(0.3)
    --self.restore_data_weapon_staff_data_btn:SetOnClick(function()
    --    -- 这里写提取命座的逻辑
    --    SendModRPCToServer(GetModRPC("dst_gi_nahida_restore_data", "nahida_weapon_staff_data"))
    --end)
    --self.restore_data_backpack_btn = self.container:AddChild(ImageButton("images/ui/dst_gi_nahida_small_button.xml", "dst_gi_nahida_small_button.tex"))
    --self.restore_data_backpack_btn:SetText(STRINGS.MOD_DST_GI_NAHIDA.RESTORE_DATA_BACKPACK)
    --self.restore_data_backpack_btn.text:SetSize(80)  -- 只改字体大小，不影响图片
    --self.restore_data_backpack_btn:SetPosition(70, title_y - 190, 0)
    --self.restore_data_backpack_btn:SetScale(0.3)
    --self.restore_data_backpack_btn:SetOnClick(function()
    --    -- 这里写提取命座的逻辑
    --    SendModRPCToServer(GetModRPC("dst_gi_nahida_restore_data", "nahida_backpack_data"))
    --end)

    -- 关闭按钮（右上角）
    self.close = self.container:AddChild(GMultiLayerButton(GetSingleGButtonConfig("light", "images/ui/icon_genshin_button.xml", "icon_close.tex")))
    self.close:SetPosition(PANEL_W/2 - 30, PANEL_H/2 - 20, 0)
    self.close:SetScale(0.7)
    self.close:SetOnClick(function ()
        self:Hide()
    end)

    self.owner:ListenForEvent(TUNING.MOD_ID.."_nahida_growth_value_change_event", function(_owner, data)
        if not data or not data.nahida_growth_value then return end
        self:SetNahidaGrowthValue(data.nahida_growth_value)
    end)
end)

function dst_gi_nahida_setting_infopanel:SetNahidaGrowthValue(nahida_growth_value)
    if nahida_growth_value then
        self.growth:SetString(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.NAHIDA_GROWTH_VALUE.."："..nahida_growth_value)
    end
end

return dst_gi_nahida_setting_infopanel