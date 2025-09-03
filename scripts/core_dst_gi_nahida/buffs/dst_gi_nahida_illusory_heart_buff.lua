---
--- dst_gi_nahida_illusory_heart_buff.lua
--- Description: 大招buff
--- Author: 没有小钱钱
--- Date: 2025/4/25 1:41
---
local function restBuff(inst, target, id, duration)
    if target.components.debuffable and target.components.debuffable:HasDebuff(id) then
        inst.components.timer:StopTimer(id)
        inst.components.timer:StartTimer(id, duration)
        return true
    end
    return false
end

local function addBuff(target)
    if target:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF1) then
        -- 1命提升攻击伤害
        if target.components.combat ~= nil then
            target.components.combat.externaldamagemultipliers:SetModifier(target, 1+TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT1.MULTIPLIERS,"buff_damagemultipliers_illusory_heart_def")
        end
    else
        -- 0命提升攻击伤害
        if target.components.combat ~= nil then
            target.components.combat.externaldamagemultipliers:SetModifier(target, 1+TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT0.MULTIPLIERS,"buff_damagemultipliers_illusory_heart_def")
        end
    end
    if target:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF5) then
        -- 提升防御
        if target.components.health then
            target.components.health.externalabsorbmodifiers:SetModifier(target, TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT5.EXTERNALABSORBMODIFIERS, "illusory_heart_def") -- 受到伤害减少60%
        end
        -- 增加移动速度
        if target.components.locomotor then
            target.components.locomotor:SetExternalSpeedMultiplier(target, "buff_speed_illusory_heart_def", TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT5.EXTERNAL_SPEED_MULTIPLIER) -- 移速增加30%
        end
    else
        -- 提升防御
        if target.components.health then
            target.components.health.externalabsorbmodifiers:SetModifier(target, TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT0.EXTERNALABSORBMODIFIERS, "illusory_heart_def") -- 受到伤害减少15%%
        end
        -- 增加移动速度
        if target.components.locomotor then
            target.components.locomotor:SetExternalSpeedMultiplier(target, "buff_speed_illusory_heart_def", TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT0.EXTERNAL_SPEED_MULTIPLIER) -- 移速增加20%
        end
    end

end

local function removeBuff(target)
    -- 提升防御
    if target.components.health then
        target.components.health.externalabsorbmodifiers:RemoveModifier(target,"illusory_heart_def")
    end
    -- 恢复正常移动速度
    if target.components.locomotor then
        target.components.locomotor:RemoveExternalSpeedMultiplier(target, "buff_speed_illusory_heart_def")
    end
    -- 0命提升攻击伤害
    if target.components.combat ~= nil then
        target.components.combat.externaldamagemultipliers:RemoveModifier(target,"buff_damagemultipliers_illusory_heart_def")
    end
end

return {
    id = TUNING.MOD_ID .. "_illusory_heart_buff", -- 唯一标识符，用于标识蕴种印增益效果
    onattachedfn = function(inst, target, id)
        inst:AddTag("noblock")
        -- 如果已经存在相同的buff，重置持续时间
        if restBuff(inst, target, id, 2) then
            return
        end
    end,
    onextendedfn = function(inst, target, id)
        -- 当增益效果被延长时调用的函数
        restBuff(inst, target, id, 2)
        addBuff(target)
    end,
    ondetachedfn = function(inst, target, id)
        removeBuff(target)
    end,
    duration = 2, -- 增益效果的持续时间（秒）
    priority = nil, -- 增益效果的优先级（此处未使用）
    prefabs = nil, -- 增益效果依赖的前置预制件（此处未使用）
    attached_string = "", -- 增益效果附加时的提示字符串
    detached_string = "", -- 增益效果结束时的提示字符串
    buff_string = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_BUFF  -- 增益效果的名称
}