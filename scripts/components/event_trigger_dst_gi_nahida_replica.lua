---@class replica_components
---@field event_trigger_dst_gi_nahida replica_event_trigger_dst_gi_nahida

---@class replica_event_trigger_dst_gi_nahida
---@field inst ent
---@field event_name netvar
---@field type netvar
---@field trigger netvar
local event_trigger_dst_gi_nahida = Class(
---@param self replica_event_trigger_dst_gi_nahida
---@param inst ent
function(self, inst)
    self.inst = inst
    self.event_name = net_string(inst.GUID, "event_trigger_dst_gi_nahida.event_name")
    self.type = net_string(inst.GUID, "event_trigger_dst_gi_nahida.type")
    self.trigger = net_bool(inst.GUID, "event_trigger_dst_gi_nahida.trigger",'event_trigger_dst_gi_nahida_triggered')
end)

function event_trigger_dst_gi_nahida:SetEventName(event_name)
    self.event_name:set(event_name)
end

function event_trigger_dst_gi_nahida:GetEventName()
    return self.event_name:value()
end

function event_trigger_dst_gi_nahida:SetType(type)
    self.type:set(type)
end

function event_trigger_dst_gi_nahida:GetType()
    return self.type:value()
end

function event_trigger_dst_gi_nahida:Trigger(value)
    return self.trigger:set(value)
end

return event_trigger_dst_gi_nahida