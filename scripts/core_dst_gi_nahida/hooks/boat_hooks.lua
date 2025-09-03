---
--- boat_hooks2.lua
--- Description:
--- Author: 没有小钱钱
--- Date: 2025/8/29 16:15
---
local function SetPlayerCenter(inst, platform)
    if platform:IsValid() then
        --这两个停止是考虑到玩家跳船上时会因为物理导致玩家飞来飞去的，让玩家停下来
        inst.Physics:Stop()
        inst.components.locomotor:Stop()
        inst.Transform:SetPosition(platform.Transform:GetWorldPosition()) --把玩家固定到船中心
    end
end

local function GetOnPlatformBefore(self, platform)
    if platform and platform:HasTag("dst_gi_nahida_shipwrecked_boat")  then
        self.inst:AddTag("dst_gi_nahida_add_distance") --增加玩家动作距离
        if TheWorld.ismastersim then
            self.inst:DoTaskInTime(0.5, SetPlayerCenter, platform)
            --虽然FollowSymbol挺方便的，但是船动人也会动，人动又导致船动，最后人和船一直移动
            -- platform.Follower:FollowSymbol(self.inst.GUID, "foot")
        else
            if Profile:GetMovementPredictionEnabled() then --如果开启了延迟补偿，强制关闭
                Profile:SetMovementPredictionEnabled(false)
                self.inst:EnableMovementPrediction(false)
            end
        end
    end
end

local function GetOffPlatformBefore(self, platform)
    if self.inst:HasTag("dst_gi_nahida_add_distance")  then
        self.inst:RemoveTag("dst_gi_nahida_add_distance")
    end
end

AddClassPostConstruct("components/walkableplatformplayer", function(self)
    Utils.FnDecorator(self, "GetOnPlatform", GetOnPlatformBefore)
    Utils.FnDecorator(self, "GetOffPlatform", GetOffPlatformBefore)
end)

local function SetMotorSpeedBefore(self, speed)
    local boat = self.inst:GetCurrentPlatform()
    if not (boat and boat:HasTag("dst_gi_nahida_shipwrecked_boat")) then
        return -- 如果不是目标船只，直接返回
    end
    -- 检查玩家状态：死亡或幽灵状态不能控制
    if self.inst:HasTag("playerghost") or (self.inst.components.health and self.inst.components.health:IsDead()) then
        return
    end
    local currentUserId = self.inst.userid -- 获取当前玩家的实际userid
    -- 检查控制权：如果已有控制者且不是当前玩家，则拒绝操作
    if boat.controller_user_id ~= nil and boat.controller_user_id ~= currentUserId then
        return
    end
    -- 取消之前可能存在的控制权释放任务，避免多个任务叠加
    if boat.controller_clear_task ~= nil then
        boat.controller_clear_task:Cancel()
        boat.controller_clear_task = nil
    end
    -- 设置当前玩家为控制者
    boat.controller_user_id = currentUserId
    -- 安排一个5秒后释放控制权的任务，并记录这个任务引用
    boat.controller_clear_task = boat:DoTaskInTime(5, function()
        boat.controller_user_id = nil
        boat.controller_clear_task = nil -- 任务执行完毕，清除引用
    end)
    -- 以下为你的船只控制逻辑（示例）
    boat.Transform:SetRotation(self.inst:GetRotation())
    boat.Physics:SetMotorVel(10, 0, 0)
    return nil, true
end

-- 一般情况上岸是玩家在船体边缘并且靠近岸边，GetPlatformAtPoint不会返回船体，但是小船是玩家在小船中间，原方法往前一段距离还是在小船范围，改成如果在岸上则不属于小船范围
local function CheckEdgeBefore(self, my_platform, map, my_x, my_z, dir_x, dir_z, radius)
    local boat = self.inst:GetCurrentPlatform()
    if not boat or not boat:HasTag("dst_gi_nahida_shipwrecked_boat") then return end

    local pt_x, pt_z = my_x + dir_x * radius, my_z + dir_z * radius
    local is_water = not map:IsVisualGroundAtPoint(pt_x, 0, pt_z)
    if not is_water then return end --目的地必须是有效地面，不然会跳进水里

    local old_platform_radius = boat.components.walkableplatform.platform_radius
    --因为GetPlatformAtPoint方法会获取这个值判断距离，这里缩小船的范围，使其platform为空
    boat.components.walkableplatform.platform_radius = 0.2
    local platform = map:GetPlatformAtPoint(pt_x, pt_z)
    boat.components.walkableplatform.platform_radius = old_platform_radius

    return { (is_water and platform == nil) or platform ~= my_platform }, true
end

local function OnUpdateBefore(self)
    if self.inst.Physics:GetMotorSpeed() <= 0 then
        local boat = self.inst:GetCurrentPlatform()
        if boat and boat:HasTag("dst_gi_nahida_shipwrecked_boat") then
            self.inst.Physics:SetMotorVel(0.001, 0, 0) --给玩家一丁点速度，让方法可以判断是否需要跨平台
        end
    end
end

AddComponentPostInit("locomotor", function(self)
    if self.inst:HasTag("player") and TheWorld.ismastersim then
        Utils.FnDecorator(self, "SetMotorSpeed", SetMotorSpeedBefore)
        Utils.FnDecorator(self, "CheckEdge", CheckEdgeBefore)
        Utils.FnDecorator(self, "OnUpdate", OnUpdateBefore)
    end
end)


-- 直接让玩家跳到海难小船中心位置
local function GetEmbarkPositionBefore(self)
    local boat = self.embarkable
    if boat ~= nil and boat:IsValid() and boat:HasTag("dst_gi_nahida_shipwrecked_boat") then
        local x, _, z = self.inst.Transform:GetWorldPosition()
        local embarkable_radius = 0.1
        local embarkable_x, embarkable_y, embarkable_z = boat.Transform:GetWorldPosition()
        local embark_x, embark_z = VecUtil_Normalize(x - embarkable_x, z - embarkable_z)
        return { embarkable_x + embark_x * embarkable_radius, embarkable_z + embark_z * embarkable_radius }, true
    end
end

AddComponentPostInit("embarker", function(self)
    Utils.FnDecorator(self, "GetEmbarkPosition", GetEmbarkPositionBefore)
end)

Utils.FnDecorator(GLOBAL, "PlayFootstep", function(inst)
    local boat = inst:GetCurrentPlatform()
    return nil, boat and boat:HasTag("dst_gi_nahida_shipwrecked_boat")
end)

AddComponentPostInit("playeractionpicker", function(self)
    local old_SortActionList = self.SortActionList
    function self:SortActionList(actions, target, useitem)
        -- 先调用原始方法生成动作列表
        local sorted_actions = old_SortActionList(self, actions, target, useitem)
        -- 检查玩家标签
        if self.inst:HasTag("dst_gi_nahida_add_distance") then
            for _, action in ipairs(sorted_actions) do
                -- 如果动作没有距离属性，使用默认值0
                --local default_distance = action.action and action.action.distance or 0
                if action.distance == nil or (action.distance and action.distance < 3.5) then
                    action.distance = 3.5  -- 增加固定距离
                end
            end
        end
        return sorted_actions
    end
end)

