---
--- dst_gi_nahida_date_sweet_buff.lua
--- Description: 枣椰蜜糖buff
--- Author: 没有小钱钱
--- Date: 2025/5/4 18:05
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
    if target.components.health then
        -- 相当于一个大蒜粉
        target.components.health.externalabsorbmodifiers:SetModifier(target, 0.33, "dst_gi_nahida_date_sweet_buff") -- 受到伤害减少33%
    end

end

local function removeBuff(target)
    -- 提升防御
    if target.components.health then
        target.components.health.externalabsorbmodifiers:RemoveModifier(target,"dst_gi_nahida_date_sweet_buff")
    end
end

return {
    id = TUNING.MOD_ID .. "_date_sweet_buff", -- 唯一标识符，哈瓦玛玛兹buff
    onattachedfn = function(inst, target, id)
        inst:AddTag("noblock")
        -- 如果已经存在相同的buff，重置持续时间
        if restBuff(inst, target, id, 300) then
            return
        end

    end,
    onextendedfn = function(inst, target, id)
        -- 当增益效果被延长时调用的函数
        restBuff(inst, target, id, 300)
        addBuff(target)
    end,
    ondetachedfn = function(inst, target, id)
        removeBuff(target)
    end,
    duration = 300, -- 增益效果的持续时间（秒）
    priority = nil, -- 增益效果的优先级（此处未使用）
    prefabs = nil, -- 增益效果依赖的前置预制件（此处未使用）
    attached_string = "", -- 增益效果附加时的提示字符串
    detached_string = "", -- 增益效果结束时的提示字符串
    buff_string = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_DATE_SWEET_BUFF  -- 增益效果的名称
}