---
--- modrpc.lua
--- Description:
--- Author: 没有小钱钱
--- Date: 2025/7/8 0:13
---
local function tptowaypoint(inst, x, y, z)
    local angle = math.random() * 2 * 3.1415926
    local range = 1.5
    local x_offset = math.cos(angle) * range
    local z_offset = math.sin(angle) * range
    while not TheWorld.Map:IsPassableAtPoint(x + x_offset, y, z + z_offset) do
        angle = math.random() * 2 * 3.1415926
        x_offset = math.cos(angle) * range
        z_offset = math.sin(angle) * range
    end
    --'_teleport_hunger_cost', -- 传送饱食度消耗
    --'_teleport_sanity_cost', -- 传送精神值消耗
    local _teleport_hunger_cost =  TUNING.MOD_DST_GI_NAHIDA_CONFIG("_teleport_hunger_cost") or 20
    if _teleport_hunger_cost then
        inst.components.hunger:DoDelta(-_teleport_hunger_cost)
    end
    local _teleport_sanity_cost =  TUNING.MOD_DST_GI_NAHIDA_CONFIG("_teleport_sanity_cost") or 10
    if _teleport_sanity_cost then
        inst.components.sanity:DoDelta(-_teleport_sanity_cost)
    end

    if inst.Physics ~= nil then
        inst.Physics:Teleport(x + x_offset, y, z + z_offset)
    else
        inst.Transform:SetPosition(x + x_offset, y, z + z_offset)
    end

    -- follow
    if inst.components.leader and
            inst.components.leader.followers then
        for kf, vf in pairs(inst.components.leader.followers) do
            if kf.Physics ~= nil then
                kf.Physics:Teleport(x + x_offset, y, z + z_offset + 1)
            else
                kf.Transform:SetPosition(x + x_offset, y, z + z_offset  + 1)
            end
        end
    end

    local inventory = inst.components.inventory
    if inventory then
        for ki, vi in pairs(inventory.itemslots) do
            if vi.components.leader and
                    vi.components.leader.followers then
                for kif, vif in pairs(vi.components.leader.followers) do
                    if kif.Physics ~= nil then
                        kif.Physics:Teleport(x + x_offset + 1 , y, z + z_offset)
                    else
                        kif.Transform:SetPosition(x + x_offset + 1, y, z + z_offset)
                    end
                end
            end
        end
    end

    local container = inventory:GetOverflowContainer()
    if container then
        for kb, vb in pairs(container.slots) do
            if vb.components.leader and
                    vb.components.leader.followers then
                for kbf, vbf in pairs(vb.components.leader.followers) do
                    if kbf.Physics ~= nil then
                        kbf.Physics:Teleport(x + x_offset, y, z + z_offset - 1)
                    else
                        kbf.Transform:SetPosition(x + x_offset, y, z + z_offset - 1)
                    end
                end
            end
        end
    end
end

local function registerwaypoint(x, y, z, waypoint_id, custom_info)
    if not ThePlayer then
        print("ThePlayer is nil, cannot register waypoint")
        return
    end
    if ThePlayer.registered_waypoint == nil then
        ThePlayer.registered_waypoint = {}
    end
    ThePlayer.registered_waypoint[waypoint_id] = {pos = Vector3(x, y, z), info = custom_info}
    print("注册锚点成功:", waypoint_id, custom_info)
end

local function unregisterwaypoint(waypoint_id)
    if not ThePlayer then
        print("ThePlayer is nil, cannot unregister waypoint")
        return
    end
    if ThePlayer.registered_waypoint == nil or ThePlayer.registered_waypoint[waypoint_id] == nil then
        print("锚点不存在，无法取消注册:", waypoint_id)
        return
    end
    ThePlayer.registered_waypoint[waypoint_id] = nil
    print("取消注册锚点:", waypoint_id)
end

local function changeSkillMode(inst,mode)
    if inst and mode and inst:HasTag(TUNING.AVATAR_NAME) and inst.components.dst_gi_nahida_skill then
        if TUNING.MOD_DST_GI_NAHIDA.SKILL_MODE[mode] then
            inst.components.dst_gi_nahida_skill:SetSkillMode(inst, mode)
        end
    end
end
-- 提取命座
local function extractionFateseat(inst)
    --inst = inst or ConsoleCommandPlayer() or ThePlayer
    --if inst and inst.entity then
    --    local str = inst.entity:GetDebugString()
    --    local tags_str = str:match("Tags: (.+)\nPrefab:")
    --    if tags_str == nil then return end
    --    local tags = string.split(tags_str," ")
    --    print("玩家身上的标签："..json.encode(tags))
    --    TheNet:Announce("玩家身上的标签："..json.encode(tags))
    --end
    if inst and inst:HasTag(TUNING.AVATAR_NAME) and inst.components.dst_gi_nahida_data then
        inst.components.dst_gi_nahida_data:ExtractionFateseat()
    end
end

AddModRPCHandler("dst_gi_nahida_tp", "tptowaypoint", tptowaypoint)
AddModRPCHandler("dst_gi_nahida_skill", "send_skill_mode", changeSkillMode)
AddModRPCHandler("dst_gi_nahida_skill", "dst_gi_nahida_extraction_fateseat", extractionFateseat)
AddModRPCHandler("dst_gi_nahida_container", "dst_gi_nahida_container_fn", function(player, action, container)
    -- 分发表
    if container and container.prefab and TUNING.DST_GI_NAHIDA_CONTAINER_ACTIONS[container.prefab] then
        local fn = TUNING.DST_GI_NAHIDA_CONTAINER_ACTIONS[container.prefab][action]
        if fn then
            fn(container, player)
        end
    end
end)
--AddModRPCHandler("dst_gi_nahida_sync_tp", "nahida_sync_tp", function(player)
--    NahidaSyncWaypointsForPlayer(player)
--end)
-- 恢复纳西妲全局数据
AddModRPCHandler("dst_gi_nahida_restore_data", "nahida_data", function(inst)
    if inst and inst:HasTag(TUNING.AVATAR_NAME) then
        OnLoadGlobalNahidaData(inst)
    end
end)
-- 恢复纳西妲全局法杖数据
AddModRPCHandler("dst_gi_nahida_restore_data", "nahida_weapon_staff_data", function(inst)
    if inst and inst:HasTag(TUNING.AVATAR_NAME) then
        OnLoadGlobalWeaponStaffData(inst)
    end
end)

AddModRPCHandler("dst_gi_nahida_restore_data", "nahida_backpack_data", function(inst)
    if inst and inst:HasTag(TUNING.AVATAR_NAME) then
        OnLoadGlobalBackpackData(inst)
    end
end)

AddModRPCHandler("dst_gi_nahida_character_window", "character_window_kill", function(inst,index)
    if inst.components.dst_gi_nahida_character_window_data then
        inst.components.dst_gi_nahida_character_window_data:StartSkill(inst,index)
    end
end)

AddModRPCHandler("dst_gi_nahida_character_window", "character_window_right_click", function(inst,index)
    if inst.components.dst_gi_nahida_character_window_data then
        inst.components.dst_gi_nahida_character_window_data:RemoveCharacter(inst,index)
    end
end)

AddModRPCHandler("dst_gi_nahida_worked_by", "worked_by", function(inst,other)
    if other and other.components.workable and other.components.workable:CanBeWorked() then
        other.components.workable:WorkedBy(inst, 20) -- 每次撞击减少1点耐久
    end
end)


--Client
AddClientModRPCHandler("dst_gi_nahida_tp_core", "registerwaypoint", registerwaypoint)
AddClientModRPCHandler("dst_gi_nahida_tp_core", "unregisterwaypoint", unregisterwaypoint)