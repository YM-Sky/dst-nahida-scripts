local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local Text = require "widgets/text"

local TEMPLATES = require "widgets/redux/templates"
local ScrollableList = require "widgets/scrollablelist"

local SkinTravelScreen = Class(Screen, function(self, owner)
    Screen._ctor(self, "SkinTravelSelector")

    self.owner = owner

    self.isopen = false

    self._scrnw, self._scrnh = TheSim:GetScreenSize()

    self:SetScaleMode(SCALEMODE_PROPORTIONAL)
    self:SetMaxPropUpscale(MAX_HUD_SCALE)
    self:SetPosition(0, 0, 0)
    self:SetVAnchor(ANCHOR_MIDDLE)
    self:SetHAnchor(ANCHOR_MIDDLE)

    self.scalingroot = self:AddChild(Widget("skintravelablewidgetscalingroot"))
    self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())

    self.inst:ListenForEvent("continuefrompause", function()
        if self.isopen then
            self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
        end
    end, TheWorld)
    self.inst:ListenForEvent("refreshhudsize", function(hud, scale)
        if self.isopen then self.scalingroot:SetScale(scale) end
    end, owner.HUD.inst)

    self.root = self.scalingroot:AddChild(TEMPLATES.ScreenRoot("root"))

    -- secretly this thing is a modal Screen, it just LOOKS like a widget
    self.black = self.root:AddChild(Image("images/global.xml", "square.tex"))
    self.black:SetVRegPoint(ANCHOR_MIDDLE)
    self.black:SetHRegPoint(ANCHOR_MIDDLE)
    self.black:SetVAnchor(ANCHOR_MIDDLE)
    self.black:SetHAnchor(ANCHOR_MIDDLE)
    self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
    self.black:SetTint(0, 1, 1, 0)
    self.black.OnMouseButton = function() self:OnCancel() end

    self.destspanel = self.root:AddChild(TEMPLATES.RectangleWindow(600, 550))
    self.destspanel:SetPosition(0, 25)

	-- 顶上选择传送站点
    self.current = self.destspanel:AddChild(Text(BODYTEXTFONT, 35))
    self.current:SetPosition(0, 250, 0)
    self.current:SetRegionSize(600, 50)
    self.current:SetHAlign(ANCHOR_MIDDLE)
    self.current:SetString(STRINGS.NAMES.DST_GI_NAHIDA_TELEPORT_WAYPOINT)--默认文字内容(暂无目标)
    self.current:SetColour(1, 1, 0, 1)--默认颜色
	
	-- 取消按钮
    self.cancelbutton = self.destspanel:AddChild(
        TEMPLATES.StandardButton(
            function() self:OnCancel() end, STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CLOSE,
            { 120, 40 }))
    self.cancelbutton:SetPosition(0, -250)

    self:LoadDests()
    self:Show()
    self.default_focus = self.dests_scroll_list
    self.isopen = true
end)

function SkinTravelScreen:LoadDests()
    print("重新加载锚点")
    local info_pack = TheWorld.net.replica.dst_gi_nahida_registered_waypoint and TheWorld.net.replica.dst_gi_nahida_registered_waypoint:GetRegisteredWaypointData()
    if info_pack == nil or not info_pack then
        return
    end
    self.dest_infos = {}
    local i = 0
    for k, v in pairs(info_pack) do
        if v ~= nil then
            local info = {}
            info.index = i
            info.name = v.info
            info.x = v.pos.x
            info.y = v.pos.y
            info.z = v.pos.z
            --if info.name == "~nil" then info.name = nil end
            info.cost_hunger = 0
            info.cost_sanity = 0
            print("重新加载锚点.."..v.waypoint_id.."  "..tostring(info.name))
            table.insert(self.dest_infos, info)
            i = i+1
        end
    end

    self:RefreshDests()
end

function SkinTravelScreen:RefreshDests()
    self.destwidgets = {}
    for i, v in ipairs(self.dest_infos) do
        local data = { index = i, info = v }

        table.insert(self.destwidgets, data)
    end

    local function ScrollWidgetsCtor(context, index)
        local widget = Widget("widget-" .. index)

        widget:SetOnGainFocus(function()
            self.dests_scroll_list:OnWidgetFocus(widget)
        end)

        widget.destitem = widget:AddChild(self:DestListItem())
        local dest = widget.destitem

        widget.focus_forward = dest

        return widget
    end

    local function ApplyDataToWidget(context, widget, data, index)
        widget.data = data
        widget.destitem:Hide()
        if not data then
            widget.focus_forward = nil
            return
        end
        widget.focus_forward = widget.destitem
        widget.destitem:Show()

        local dest = widget.destitem
        dest:SetInfo(data.info)
    end

    if not self.dests_scroll_list then
        self.dests_scroll_list = self.destspanel:AddChild(
                TEMPLATES.ScrollingGrid(self.destwidgets, {
                    context = {},
                    widget_width = 200,
                    widget_height = 75,
                    num_visible_rows = 6,
                    num_columns = 3,
                    item_ctor_fn = ScrollWidgetsCtor,
                    apply_fn = ApplyDataToWidget,
                    scrollbar_offset = 5,
                    scrollbar_height_offset = -60,
                    peek_percent = 0,             -- may init with few clientmods, but have many servermods.
                    allow_bottom_empty_row = true -- it's hidden anyway
                }))

        self.dests_scroll_list:SetPosition(0, 0)
        self.destspanel.focus_forward = self.dests_scroll_list--设置焦点

        self.dests_scroll_list:SetFocusChangeDir(MOVE_DOWN, self.cancelbutton)
        self.cancelbutton:SetFocusChangeDir(MOVE_UP, self.dests_scroll_list)
    else
        -- 关键：刷新数据
        self.dests_scroll_list:SetItemsData(self.destwidgets)
    end
end

function SkinTravelScreen:DestListItem()
    local dest = Widget("destination")

    local item_width, item_height = 200, 75
    dest.backing = dest:AddChild(TEMPLATES.ListItemBackground(item_width, item_height, function() end))
    dest.backing.move_on_click = true

    dest.name = dest:AddChild(Text(BODYTEXTFONT, 28))
    dest.name:SetVAlign(ANCHOR_MIDDLE)
    dest.name:SetHAlign(ANCHOR_MIDDLE)
    dest.name:SetPosition(0, 18, 0)
    dest.name:SetRegionSize(190, 40)

    local cost_py = -10
    local cost_font = UIFONT
    local cost_fontsize = 20

    dest.cost_hunger = dest:AddChild(Text(cost_font, cost_fontsize))
    dest.cost_hunger:SetVAlign(ANCHOR_MIDDLE)
    dest.cost_hunger:SetHAlign(ANCHOR_MIDDLE)
    dest.cost_hunger:SetPosition(0, -10, 0)
    dest.cost_hunger:SetRegionSize(190, 30)


    dest.SetInfo = function(_, info)
        if info.name and info.name ~= "" then
            dest.name:SetString(info.name)
            dest.name:SetColour(1, 1, 1, 1)
        else
            dest.name:SetString(STRINGS.NANA_TELEPORT_UNKNOWN_DESTINATION)
            dest.name:SetColour(1, 1, 0, 0.6)
        end
        dest.backing:SetOnClick(function()
            self:SkinTravel(info.index,info)
        end)
        dest.cost_hunger:Show()
        dest.cost_hunger:SetString(string.format("%.2f, %.2f, %.2f", info.x, info.y, info.z))
        dest.cost_hunger:SetColour(1, 1, 1, 0.8)
    end

    dest.focus_forward = dest.backing
    return dest
end

function SkinTravelScreen:SkinTravel(index,info)
    self:Close()
    if info.x and info.y and info.z then
        --传送
        SendModRPCToServer(GetModRPC("dst_gi_nahida_tp", "tptowaypoint"), info.x, info.y, info.z)
    end
end

function SkinTravelScreen:OnCancel()
    self:Close()
end

function SkinTravelScreen:OnControl(control, down)
    if SkinTravelScreen._base.OnControl(self, control, down) then return true end

    if not down then
        if control == CONTROL_OPEN_DEBUG_CONSOLE then
            return true
        elseif control == CONTROL_CANCEL then
            self:OnCancel()
        end
    end
end

function SkinTravelScreen:Close()
    self:Hide()
    self.inst:DoTaskInTime(.2, function() TheFrontEnd:PopScreen(self) end)
end

return SkinTravelScreen
