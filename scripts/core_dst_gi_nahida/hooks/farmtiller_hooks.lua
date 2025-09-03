---
--- farmtiller_hooks.lua
--- Description: 锄地组件
--- Author: 没有小钱钱
--- Date: 2025/6/8 16:47
---
AddComponentPostInit("farmtiller", function(self)
    local OldTill = self.Till

    function self:Till(pt, doer)
        if not (self.inst and self.inst:HasTag("dst_gi_nahida_weapons") and self.inst:HasTag("dst_gi_nahida_weapons_till_destroy")) then
            return OldTill(self, pt, doer)
        end

        local grid_size = 3
        local spacing = 1.2
        local offset = -(grid_size - 1) * spacing / 2
        local center_x, center_z = pt.x, pt.z
        local center_tile = TheWorld.Map:GetTileAtPoint(center_x, 0, center_z)

        -- 🔥 收集所有有效位置，然后延迟生成
        local valid_positions = {}

        for i = 0, grid_size - 1 do
            for j = 0, grid_size - 1 do
                local target_x = center_x + offset + i * spacing
                local target_z = center_z + offset + j * spacing
                local target_pt = Vector3(target_x, 0, target_z)
                local target_tile = TheWorld.Map:GetTileAtPoint(target_x, 0, target_z)

                if target_tile == center_tile then
                    if TheWorld.Map:CanTillSoilAtPoint(target_x, 0, target_z, false) then
                        table.insert(valid_positions, target_pt)
                    end
                end
            end
        end

        -- 🔥 如果有有效位置，延迟生成农田
        if #valid_positions > 0 then
            -- 先清理所有位置
            for _, pos in ipairs(valid_positions) do
                TheWorld.Map:CollapseSoilAtPoint(pos.x, 0, pos.z)
            end

            -- 🔥 延迟生成农田，避免同帧冲突
            for i, pos in ipairs(valid_positions) do
                doer:DoTaskInTime(i * 0.05, function()  -- 每个农田间隔0.05秒生成
                    if doer and doer:IsValid() then
                        SpawnPrefab("farm_soil").Transform:SetPosition(pos:Get())
                    end
                end)
            end

            if doer ~= nil then
                doer:PushEvent("tilling")
                if doer.components.talker then
                    doer.components.talker:Say(string.format(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TILL_MESSAGE, #valid_positions))
                end
            end
            return true
        end

        return false
    end
end)