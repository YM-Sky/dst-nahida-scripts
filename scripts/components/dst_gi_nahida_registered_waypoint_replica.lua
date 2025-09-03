---
--- dst_gi_nahida_registered_waypoint_replica.lua
--- Description: 
--- Author: 旅行者
--- Date: 2025/7/27 0:52
---
local json = require("json")

local function OnRegisteredWaypointData(inst)
    local registered_waypoint_data = inst.replica.dst_gi_nahida_registered_waypoint:GetRegisteredWaypointData()
    inst:PushEvent(TUNING.MOD_ID.."_nahida_registered_waypoint_data_change_event", {registered_waypoint_data = registered_waypoint_data})
end

local dst_gi_nahida_registered_waypoint = Class(function(self, inst)
    self.inst = inst
    self.registered_waypoint_data = net_string(inst.GUID, TUNING.MOD_ID.."_registered_waypoint_data_guid", TUNING.MOD_ID.."_registered_waypoint_data_guid_change_event")
    if not TheWorld.ismastersim then
        inst:ListenForEvent(TUNING.MOD_ID.."_registered_waypoint_data_guid_change_event", OnRegisteredWaypointData)
    end
end)

function dst_gi_nahida_registered_waypoint:SetRegisteredWaypointData(value)
    self.registered_waypoint_data:set(value)
end

function dst_gi_nahida_registered_waypoint:GetRegisteredWaypointData()
    if self.inst.components.dst_gi_nahida_registered_waypoint then
        -- 主机：直接从组件获取
        return self.inst.components.dst_gi_nahida_registered_waypoint:GetRegisteredWaypointData()
    elseif self.registered_waypoint_data:value() then
        -- 客机：从网络数据解码
        local registered_waypoint_data_json = self.registered_waypoint_data:value()
        --print("客机获取传送锚点数据JSON："..tostring(registered_waypoint_data_json))
        
        if registered_waypoint_data_json == nil or registered_waypoint_data_json == "" or registered_waypoint_data_json == "[]" then
            print("传送锚点数据为空")
            return {}
        end
        
        local success, result = pcall(json.decode, registered_waypoint_data_json)
        if success then
            --print("客机解码传送锚点数据成功："..json.encode(result))
            return result
        else
            --print("客机解码传送锚点数据失败："..tostring(result))
            return {}
        end
    end
    print("没有找到传送锚点数据")
    return {}
end

return dst_gi_nahida_registered_waypoint