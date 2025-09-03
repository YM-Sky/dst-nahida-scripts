---
--- dst_gi_nahida_registered_waypoint.lua
--- Description: 
--- Author: 旅行者
--- Date: 2025/7/27 0:52
---
local dst_gi_nahida_registered_waypoint = Class(function(self, inst)
    self.inst = inst
end)

function dst_gi_nahida_registered_waypoint:registered(waypoint,x,y,z,title)
    TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT[tostring(waypoint.waypoint_id)] = {
        guid = waypoint.GUID,
        waypoint_id = waypoint.waypoint_id,
        pos = {
            x = x,
            y = y,
            z = z,
        },
        info = title
    }
    -- 只打印当前注册的锚点数据，而不是整个TUNING表
    --local current_waypoint = TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT[tostring(waypoint.waypoint_id)]
    --print("注册传送锚点9999："..waypoint.GUID.." 数据："..json.encode(current_waypoint))
    self:SyncWaypointData(TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT)
    --for k, v in pairs(TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT) do
    --    if v ~= nil then
    --        print("重新加载锚点后注册传送锚点.."..v.waypoint_id.."  "..tostring(v.info))
    --    end
    --end
end

function dst_gi_nahida_registered_waypoint:UnRegisterWaypoint(waypoint)
    print("注销传送锚点："..waypoint.prefab..";waypoint_id: "..tostring(waypoint.waypoint_id))
    for k, v in pairs(TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT) do
        if v ~= nil then
            print("重新加载锚点后注销传送锚点.."..v.waypoint_id.."  "..tostring(v.info))
        end
    end
    if TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT[tostring(waypoint.waypoint_id)] then
        print("注销传送锚点："..waypoint.waypoint_id)
        TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT[tostring(waypoint.waypoint_id)] = nil
        self:SyncWaypointData(TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT)
    end
end

function dst_gi_nahida_registered_waypoint:SyncWaypointData(nahida_registered_waypoint_data)
    --print("开始同步锚点数据SyncWaypointData："..self.inst.prefab)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_registered_waypoint then
        --print("同步锚点数据SyncWaypointData："..self.inst.prefab)
        self.inst.replica.dst_gi_nahida_registered_waypoint:SetRegisteredWaypointData(json.encode(nahida_registered_waypoint_data))
    end
end

function dst_gi_nahida_registered_waypoint:GetRegisteredWaypointData()
    -- 过滤掉nil值，只返回有效的锚点数据
    local valid_waypoints = {}
    for guid, waypoint_data in pairs(TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT) do
        if waypoint_data and waypoint_data.guid then
            valid_waypoints[guid] = waypoint_data
        end
    end
    return valid_waypoints
end

-- 保存数据
function dst_gi_nahida_registered_waypoint:OnSave()
    local _nahida_registered_waypoint = self:GetRegisteredWaypointData()
    return {
        nahida_registered_waypoint = _nahida_registered_waypoint
    }
end

-- 加载数据
function dst_gi_nahida_registered_waypoint:OnLoad(data)
    --if data and data.nahida_registered_waypoint then
    --    -- 将保存的数据合并到TUNING表中
    --    for guid, waypoint_data in pairs(data.nahida_registered_waypoint) do
    --        TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT[guid] = waypoint_data
    --    end
    --    --print("加载传送锚点数据："..json.encode(data.nahida_registered_waypoint))
    --    -- 同步到客户端
    --
    --end
    self:SyncWaypointData(self:GetRegisteredWaypointData())
end

return dst_gi_nahida_registered_waypoint