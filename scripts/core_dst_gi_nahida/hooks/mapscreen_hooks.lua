---
--- mapscreen_hooks.lua
--- Description: 地图hooks
--- Author: 没有小钱钱
--- Date: 2025/7/8 17:28
---
local Teleport_Waypoint_Button = require('core_'..TUNING.MOD_ID..'/widgets/dst_gi_nahida_teleport_waypoint_button')
local Teleport_Infopanel = require('core_'..TUNING.MOD_ID..'/widgets/dst_gi_nahida_teleport_infopanel')
local writeables = require "writeables"

--------------------------------------------------------------------------
--修改Map 复制于 元素反应 模组
--AddClassPostConstruct("screens/mapscreen", function(self)  -- 给小地图添加传送锚点按钮，这个过程会
--    local registered_waypoint = TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT
--    if self.owner.registered_waypoint == nil then
--        return
--    end
--    self.wp_btns = {}
--    for k, v in pairs(self.owner.registered_waypoint) do
--        if v ~= nil then
--            self.wp_btns[k] = self:AddChild(Teleport_Waypoint_Button(self.owner, k, v.pos, v.info))
--            self.wp_btns[k]:SetOnClick(function ()
--                self:ShowInfo(k)
--            end)
--        end
--    end
--    self.tp_panel_open = false
--
--    local w, h = TheSim:GetScreenSize()
--    -- local scale = h / origin_size.y
--    self.TP_Panel = self:AddChild(Teleport_Infopanel(self.owner, w, h))
--    -- self.TP_Panel:SetScale(scale, scale, scale)
--    self.TP_Panel:SetPosition(0.5 * w, 0.5 * h, 0)
--    self.TP_Panel:Hide(-1)
--
--    function self:ShowInfo(wp_id)
--        for k, v in pairs(self.wp_btns) do
--            if k ~= wp_id then
--                v:Unselect()
--            else
--                v:Select()
--                self.TP_Panel:ShowInfo(v.world_pos, v.custom_info)
--            end
--        end
--        self.tp_panel_open = true
--    end
--
--    function self:HideInfo()
--        for k, v in pairs(self.wp_btns) do
--            v:Unselect()
--            v:StartUpdating()
--        end
--        -- self.TP_Panel:Hide() 已经在那一边做了
--        self.tp_panel_open = false
--    end
--
--    --禁止在打开状态点击其它东西比如转视角
--    local old_OnControl = self.OnControl
--    function self:OnControl(control, down)
--        if self.tp_panel_open then
--            for k, v in pairs(self.wp_btns) do
--                if v:OnControl(control, down) then
--                    return true
--                end
--            end
--            return self.TP_Panel:OnControl(control, down)
--        end
--
--        return old_OnControl(self, control, down)
--    end
--    --禁止在打开状态缩放
--    local old_DoZoomIn = self.DoZoomIn
--    local old_DoZoomOut = self.DoZoomOut
--    function self:DoZoomIn(...)
--        if self.tp_panel_open then
--            return
--        end
--        return old_DoZoomIn(self, ...)
--    end
--    function self:DoZoomOut(...)
--        if self.tp_panel_open then
--            return
--        end
--        return old_DoZoomOut(self, ...)
--    end
--    --禁止在打开状态拖动
--    local old_MapWidget_Update = self.minimap.OnUpdate
--    local function MapWidget_OnUpdate(self, ...)
--        if self.parent.tp_panel_open then
--            return
--        end
--        old_MapWidget_Update(self, ...)
--    end
--    self.minimap.OnUpdate = MapWidget_OnUpdate
--end)

AddClassPostConstruct("screens/mapscreen", function(self)
    if not (TheWorld and TheWorld.net) then
        return ;
    end
    
    local registered_waypoint = nil
    
    -- 主机：直接从TheWorld.net.components获取
    print("TheWorld.net存在，检查组件...")
    print("TheWorld.net.components存在："..tostring(TheWorld.net.components ~= nil))
    print("TheWorld.net.components.dst_gi_nahida_registered_waypoint存在："..tostring(TheWorld.net.components.dst_gi_nahida_registered_waypoint ~= nil))
    if TheWorld.net.components and TheWorld.net.components.dst_gi_nahida_registered_waypoint then
        print("主机拿数据")
        registered_waypoint = TheWorld.net.components.dst_gi_nahida_registered_waypoint:GetRegisteredWaypointData()
    else
        print("主机没有数据")
    end

    print("TheWorld.net.replica存在，检查组件...")
    print("TheWorld.net.replica 存在："..tostring(TheWorld.net.replica ~= nil))
    print("TheWorld.net.replica.dst_gi_nahida_registered_waypoint存在："..tostring(TheWorld.net.replica and TheWorld.net.replica.dst_gi_nahida_registered_waypoint ~= nil))
    -- 客机：从replica获取
    if registered_waypoint == nil and TheWorld.net.replica and TheWorld.net.replica.dst_gi_nahida_registered_waypoint then
        print("客机拿数据")
        registered_waypoint = TheWorld.net.replica.dst_gi_nahida_registered_waypoint:GetRegisteredWaypointData()
    else
        print("客机没有数据")
    end
    
    -- 给小地图添加传送锚点按钮
    if registered_waypoint == nil or next(registered_waypoint) == nil then
        print("没有找到传送锚点数据")
        return
    end

    --print("找到传送锚点数据："..json.encode(registered_waypoint))

    self.wp_btns = {}
    for k, v in pairs(registered_waypoint) do
        if v ~= nil and v.pos then
            -- 适配数据结构：v.pos包含x,y,z，v.info是标题
            self.wp_btns[k] = self:AddChild(Teleport_Waypoint_Button(self.owner, k, Vector3(v.pos.x, v.pos.y, v.pos.z), v.info))
            self.wp_btns[k]:SetOnClick(function ()
                self:ShowInfo(k)
            end)
        end
    end
    self.tp_panel_open = false

    local w, h = TheSim:GetScreenSize()
    -- local scale = h / origin_size.y
    self.TP_Panel = self:AddChild(Teleport_Infopanel(self.owner, w, h))
    -- self.TP_Panel:SetScale(scale, scale, scale)
    self.TP_Panel:SetPosition(0.5 * w, 0.5 * h, 0)
    self.TP_Panel:Hide(-1)

    function self:ShowInfo(wp_id)
        for k, v in pairs(self.wp_btns) do
            if k ~= wp_id then
                v:Unselect()
            else
                v:Select()
                self.TP_Panel:ShowInfo(v.world_pos, v.custom_info)
            end
        end
        self.tp_panel_open = true
    end

    function self:HideInfo()
        for k, v in pairs(self.wp_btns) do
            v:Unselect()
            v:StartUpdating()
        end
        -- self.TP_Panel:Hide() 已经在那一边做了
        self.tp_panel_open = false
    end

    --禁止在打开状态点击其它东西比如转视角
    local old_OnControl = self.OnControl
    function self:OnControl(control, down)
        if self.tp_panel_open then
            for k, v in pairs(self.wp_btns) do
                if v:OnControl(control, down) then
                    return true
                end
            end
            return self.TP_Panel:OnControl(control, down)
        end

        return old_OnControl(self, control, down)
    end
    --禁止在打开状态缩放
    local old_DoZoomIn = self.DoZoomIn
    local old_DoZoomOut = self.DoZoomOut
    function self:DoZoomIn(...)
        if self.tp_panel_open then
            return
        end
        return old_DoZoomIn(self, ...)
    end
    function self:DoZoomOut(...)
        if self.tp_panel_open then
            return
        end
        return old_DoZoomOut(self, ...)
    end
    --禁止在打开状态拖动
    local old_MapWidget_Update = self.minimap.OnUpdate
    local function MapWidget_OnUpdate(self, ...)
        if self.tp_panel_open then
            return
        end
        old_MapWidget_Update(self, ...)
    end
    self.minimap.OnUpdate = MapWidget_OnUpdate
end)

--添加新的writeables布局
local SignGenerator = require "signgenerator"
local dst_gi_nahida_tp_wp_layout = {
    prompt = STRINGS.SIGNS.MENU.PROMPT,
    animbank = "ui_board_5x3",
    animbuild = "ui_board_5x3",
    menuoffset = Vector3(6, -70, 0),

    cancelbtn = { text = STRINGS.SIGNS.MENU.CANCEL, cb = nil, control = CONTROL_CANCEL },
    middlebtn = { text = STRINGS.SIGNS.MENU.RANDOM, cb = function(inst, doer, widget)
        widget:OverrideText(SignGenerator(inst, doer))
    end, control = CONTROL_MENU_MISC_2 },
    acceptbtn = { text = STRINGS.SIGNS.MENU.ACCEPT, cb = nil, control = CONTROL_ACCEPT },
}
writeables.AddLayout("dst_gi_nahida_teleport_waypoint", dst_gi_nahida_tp_wp_layout)

-- 修复上下洞穴时传送锚点消失的问题
--AddPrefabPostInit("world", function(world)
--    -- 监听玩家重生 - 使用更可靠的事件
--    world:ListenForEvent("ms_playerjoined", function(world, data)
--        local player = data.player
--        if player then
--            print("玩家加入，同步锚点数据")
--            NahidaSyncWaypointsForPlayer(player)
--        end
--    end)
--end)