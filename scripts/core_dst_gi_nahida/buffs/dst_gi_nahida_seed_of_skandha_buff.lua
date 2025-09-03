---
--- dst_gi_nahida_illusory_heart_buff.lua
--- Description: 大招buff
--- Author: 没有小钱钱
--- Date: 2025/4/25 1:41
---
local function removeSeedOfSkandhaFx(target)
    -- 检查特效是否存在
    if target.seed_of_skandha_fx ~= nil then
        -- 移除特效
        target.seed_of_skandha_fx:Remove()
        -- 清除引用
        target.seed_of_skandha_fx = nil
        if target.components.dst_gi_nahida_four_leaf_clover_data then
            target:RemoveComponent("dst_gi_nahida_four_leaf_clover_data")
        end
    end
end

local function restBuff(inst, target,id,duration)
    if target.components.debuffable and target.components.debuffable:HasDebuff(id) then
        inst.components.timer:StopTimer(id)
        inst.components.timer:StartTimer(id, duration)
        return true
    end
    return false
end
-- 蕴种印OnTick
local function seedOfSkandhaOnTick(inst, target)
    if target.components.dst_gi_nahida_elemental_reaction == nil then
        -- 检查特效是否存在
        removeSeedOfSkandhaFx(target)
        inst.components.debuff:Stop()
    end
    local dst_gi_nahida_elemental_reaction = target.components.dst_gi_nahida_elemental_reaction
    if dst_gi_nahida_elemental_reaction then
        -- 先元素附着
        dst_gi_nahida_elemental_reaction:AttachElement(TUNING.ELEMENTAL_TYPE.GRASS, TUNING.ELEMENTAL_STRENGTH.STRONG)
        -- 然后消耗元素并攻击物体造成伤害
        dst_gi_nahida_elemental_reaction:ConsumeAndReactDoDelta(TUNING.ELEMENTAL_TYPE.GRASS, target, {
            weapon_damage = dst_gi_nahida_elemental_reaction:GetAttachDamage(),
            is_skill = true
        })
    end
end

local function addNahidaSeedOfSkandhaTag(target)
    -- 初始化定时任务表
    if target._nahida_seed_task == nil then
        target._nahida_seed_task = {}
    end
    -- 如果已有定时任务，取消它
    if target._nahida_seed_task[TUNING.MOD_DST_GI_NAHIDA.NAHIDA_SEED_OF_SKANDHA_TAG] ~= nil then
        target._nahida_seed_task[TUNING.MOD_DST_GI_NAHIDA.NAHIDA_SEED_OF_SKANDHA_TAG]:Cancel()
    end

    -- 添加标签
    if not target:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_SEED_OF_SKANDHA_TAG) then
        target:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_SEED_OF_SKANDHA_TAG)
    end
    -- 6命效果的次数，6命才会用得上
    if target.components.dst_gi_nahida_four_leaf_clover_data == nil then
        target:AddComponent("dst_gi_nahida_four_leaf_clover_data")
    end
    if target.components.dst_gi_nahida_four_leaf_clover_data then
        target.components.dst_gi_nahida_four_leaf_clover_data:SetSeedOfSkandhaCount()
    end

    -- 设置新的定时任务，持续25秒
    target._nahida_seed_task[TUNING.MOD_DST_GI_NAHIDA.NAHIDA_SEED_OF_SKANDHA_TAG] = target:DoTaskInTime(25, function()
        if target:IsValid() then
            target:RemoveTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_SEED_OF_SKANDHA_TAG)
            target._nahida_seed_task[TUNING.MOD_DST_GI_NAHIDA.NAHIDA_SEED_OF_SKANDHA_TAG] = nil
        end
    end)
end

return {
    id = TUNING.MOD_ID.."_seed_of_skandha",  -- 唯一标识符，用于标识蕴种印增益效果
    onattachedfn = function(inst, target, id)
        inst:AddTag("noblock")
        inst.level = 2
        target.seed_of_skandha_fx = SpawnPrefab("fx_dst_gi_nahida_four_leaf_clover")
        target.seed_of_skandha_fx.entity:SetParent(target.entity) -- 设置成跟随玩家
        -- 获取实体的位置
        local x, y, z = target.Transform:GetWorldPosition()
        target.seed_of_skandha_fx.Transform:SetPosition(0, y + 3.2, 0) -- 确保位置正确
        inst.entity:SetParent(target.entity)

        -- 如果已经存在相同的buff，重置持续时间
        if restBuff(inst,target,id,25) then
            inst.grass_element_count = 3
            return
        end
        addNahidaSeedOfSkandhaTag(target)
        inst[TUNING.MOD_ID.."_seed_of_skandha_task"] = inst:DoPeriodicTask(1, seedOfSkandhaOnTick, nil, target)
    end,
    onextendedfn = function(inst, target, id)
        -- 当增益效果被延长时调用的函数
        restBuff(inst,target,id,25)
        -- 检查task是否存在
        if inst[TUNING.MOD_ID.."_seed_of_skandha_task"] ~= nil then
            inst[TUNING.MOD_ID.."_seed_of_skandha_task"]:Cancel()
        end
        addNahidaSeedOfSkandhaTag(target)
        -- 重新启动任务
        inst[TUNING.MOD_ID.."_seed_of_skandha_task"] = inst:DoPeriodicTask(1, seedOfSkandhaOnTick, nil, target)
    end,
    ondetachedfn = function(inst, target, id)
        -- 当蕴种印增益效果从目标分离时调用
        -- 处理蕴种印buff结束的逻辑
        -- 检查特效是否存在
        removeSeedOfSkandhaFx(target)
    end,
    duration = 25,  -- 增益效果的持续时间（秒）
    priority = nil,  -- 增益效果的优先级（此处未使用）
    prefabs = nil,  -- 增益效果依赖的前置预制件（此处未使用）
    attached_string = "",  -- 增益效果附加时的提示字符串
    detached_string = "",  -- 增益效果结束时的提示字符串
    buff_string = STRINGS.MOD_DST_GI_NAHIDA.SEED_OF_SKANDHA  -- 增益效果的名称
}