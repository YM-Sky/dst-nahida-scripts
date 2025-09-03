---
--- dst_gi_nahida_illusory_heart_data.lua
--- Description: 草神大招核心数据
--- Author: 没有小钱钱
--- Date: 2025/4/19 22:37
---
local GARDENING_CANT_TAGS = { "INLIMBO", "stump", "barren" }
local exclude_tags = { "INLIMBO", "companion", "wall", "abigail", "player", "chester", "zhijiang_hound" }

local function RemoveBuff(inst)
    -- 移除防御提升
    if inst.components.health then
        inst.components.health.externalabsorbmodifiers:RemoveModifier(inst)
    end
    -- 恢复正常移动速度
    if inst.components.locomotor then
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "buff_speed")
    end
    -- 移除防御提升标签
    inst:RemoveTag("defense_buff")
end

local function ApplyBuff(inst, duration)
end

-- 定义一个类，用于管理角色的元素能量和技能冷却时间
local dst_gi_nahida_illusory_heart_data = Class(function(self, inst)
    self.inst = inst
    self.nahida_burst_duration = 15 -- 元素爆发的持续时间（秒）
    self.nahida_current_burst_duration = 15 -- 当前元素爆发持续时间
    self.nahida_burst_radius = 23 -- 元素爆发范围
    self.nahida_fateseat_level = 0
    self.nahida_burst_task = nil
    -- 启动组件的更新，以便在游戏循环中定期调用 OnUpdate 方法
    self.inst:StartUpdatingComponent(self)
end)

function dst_gi_nahida_illusory_heart_data:SetFateseatLevel(level)
    self.nahida_fateseat_level = level
end


function dst_gi_nahida_illusory_heart_data:AddBuff()
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local players = TheSim:FindEntities(x, y, z, self.nahida_burst_radius, { "player" }, GARDENING_CANT_TAGS)
    if players and #players > 0 then
        for i, player in ipairs(players) do
            if player ~= nil then
                --0命：元素爆发，角色伤害提升20%
                --1命：强化元素爆发，角色伤害提升至35%
                --2命：燃烧，草原核20%几率，造成2倍伤害
                --3命：元素战技范围提升
                --4命：附近处于所闻遍计的蕴种印状态下的敌人数量为1/2/3/4或更多时，纳西姐的伤害提升100/120/140/160点。
                --5命：心景幻成强化，范围内防御提升80%，受到伤害减少60%，30%移速
                --6命：心景幻成范围内，强化蕴种印，普攻攻击敌人时，范围内携带蕴种印的怪物造成一次灭净三叶*业障除伤害，0.2秒最多触发一次，持续10秒，最多触发6次，
                -- 给玩家添加的标签 有0命，1命，5命的标签
                if self.nahida_fateseat_level == 6 then
                    self:AddTemporaryTag(player, TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF6, 2)
                    self:AddTemporaryTag(player, TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF5, 2)
                    self:AddTemporaryTag(player, TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF1, 2)
                    self:AddTemporaryTag(player, TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF0, 2)
                elseif self.nahida_fateseat_level == 5  then
                    self:AddTemporaryTag(player, TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF5, 2)
                    self:AddTemporaryTag(player, TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF1, 2)
                    self:AddTemporaryTag(player, TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF0, 2)
                elseif self.nahida_fateseat_level >= 1 and self.nahida_fateseat_level < 5 then
                    self:AddTemporaryTag(player, TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF1, 2)
                    self:AddTemporaryTag(player, TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF0, 2)
                else
                    self:AddTemporaryTag(player, TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF0, 2)
                end
                if player.components.debuffable == nil then
                    player:AddComponent("debuffable")
                end
                if player.components.debuffable then
                    player.components.debuffable:AddDebuff("buff_" .. TUNING.MOD_ID .. "_illusory_heart_buff", "buff_" .. TUNING.MOD_ID .. "_illusory_heart_buff")
                end
            end
        end
    end

end

function dst_gi_nahida_illusory_heart_data:AddTemporaryTag(inst, tag, duration)
    -- 初始化定时任务表
    if inst._nahida_tag_tasks == nil then
        inst._nahida_tag_tasks = {}
    end

    -- 如果已有定时任务，取消它
    if inst._nahida_tag_tasks[tag] ~= nil then
        inst._nahida_tag_tasks[tag]:Cancel()
    end

    -- 添加标签
    if not inst:HasTag(tag) then
        inst:AddTag(tag)
    end

    -- 设置新的定时任务
    inst._nahida_tag_tasks[tag] = inst:DoTaskInTime(duration, function()
        if inst:IsValid() then
            inst:RemoveTag(tag)
            inst._nahida_tag_tasks[tag] = nil
        end
    end)
end

function dst_gi_nahida_illusory_heart_data:Init()
    if self.nahida_burst_task ~= nil then
        self.nahida_burst_task:Cancel()
    end
    self.nahida_burst_task = self.inst:DoPeriodicTask(1, function()
        self:AddBuff()
    end)

    self.inst.light = SpawnPrefab("dst_gi_nahida_illusory_heart_light")
    self.inst.light.entity:SetParent(self.inst.entity)
end


-- 更新方法，每帧调用一次，用于更新技能和爆发的冷却时间
function dst_gi_nahida_illusory_heart_data:OnUpdate(dt)
    -- 更新元素战技的持续时间
    if self.nahida_current_burst_duration > 0 then
        self.nahida_current_burst_duration = self.nahida_current_burst_duration - dt
        if self.nahida_current_burst_duration < 0 then
            self.nahida_current_burst_duration = 0 -- 确保冷却时间不为负
            if self.inst:IsValid() then
                if self.nahida_burst_task ~= nil then
                    self.nahida_burst_task:Cancel()
                end
                if self.inst.light ~= nil then
                    self.inst.light:Remove()
                end
                self.nahida_burst_task = nil
                self.inst:Remove()
            end
        end
    end
end

function dst_gi_nahida_illusory_heart_data:Remove()
    if self.nahida_burst_task ~= nil then
        self.nahida_burst_task:Cancel()
    end
    self.nahida_burst_task = nil
    self.inst:Remove()
    if self.inst.light ~= nil then
        self.inst.light:Remove()
    end
end

function dst_gi_nahida_illusory_heart_data:OnSave()
    return {
        nahida_current_burst_duration = self.nahida_current_burst_duration,
        nahida_fateseat_level = self.nahida_fateseat_level
    }
end

-- 加载持续时间状态
function dst_gi_nahida_illusory_heart_data:OnLoad(data)
    if data.nahida_current_burst_duration then
        self.nahida_current_burst_duration = data.nahida_current_burst_duration
    end
    if data.nahida_fateseat_level then
        self.nahida_fateseat_level = data.nahida_fateseat_level
    end
end

return dst_gi_nahida_illusory_heart_data