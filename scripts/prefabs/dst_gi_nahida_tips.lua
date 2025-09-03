---
--- dst_gi_nahida_tips.lua
--- Description: 
--- Author: 没有小钱钱
--- Date: 2025/4/22 23:44
---
-- 定义一个函数来提取键值对
local tipsTypes = {
    -- 水元素：深蓝色调
    WATER = {
        color = {r = 0.0, g = 0.75, b = 1.0}, -- 深蓝色
    },
    -- 火元素：橙红色调
    FIRE = {
        color = {r = 1.0, g = 0.41, b = 0.0}, -- 橙红色
    },
    -- 冰元素：浅蓝色调
    ICE = {
        color = {r = 0.53, g = 0.81, b = 0.92}, -- 浅蓝色
    },
    -- 雷元素：紫色调
    THUNDER = {
        color = {r = 0.60, g = 0.20, b = 0.80}, -- 紫色
    },
    -- 草元素：鲜绿色调
    GRASS = {
        color = {r = 0.20, g = 0.80, b = 0.20}, -- 鲜绿色
    },
    -- 风元素：青绿色调
    WIND = {
        color = {r = 0.25, g = 0.88, b = 0.82}, -- 青绿色
    },
    -- 岩元素：金黄色调
    ROCK = {
        color = {r = 1.0, g = 0.84, b = 0.0}, -- 金黄色
    },
    -- 物理：银白色调
    PHYSICAL = {
        color = {r = 0.75, g = 0.75, b = 0.75}, -- 银白色
    },
}

local function SetNahidaTips(inst)
    -- 获取字符串值
    local jsonData = inst.guid_tips_value:value()
    if jsonData then
        local data = json.decode(jsonData)
        -- 使用模式匹配提取类型和具体消耗
        if not data.type or not data.text then
            return -- 如果匹配失败，直接返回
        end
        local label = inst.Label
        if tipsTypes[string.upper(data.type)] then
            label:SetText(data.text)
            label:SetColour(tipsTypes[string.upper(data.type)].color.r, tipsTypes[string.upper(data.type)].color.g, tipsTypes[string.upper(data.type)].color.b)
            label:Enable(true)
            -- 应用垂直偏移
            local offset_y = data.offset_y or 0
            label:SetWorldOffset(3, 4 + offset_y, 0)
        end
    end
end
local function UpdatePing(inst, t0, duration)
    local t = GetTime() - t0
    local k = 1 - math.max(0, t - 0.1) / duration
    k = 1 - k * k
    local s = Lerp(65, 70, k)--字体从15到30
    local y = Lerp(4, 5, k)--高度从4到5
    local label = inst.Label
    if label then
        label:SetFontSize(s)
        label:SetWorldOffset(3, y, 0)
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst.entity:SetCanSleep(false)
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    local label = inst.entity:AddLabel()
    label:SetFont(NUMBERFONT)
    label:SetFontSize(65)
    label:SetWorldOffset(3, 4, 0)
    label:SetColour(255 / 255, 204 / 255, 51 / 255)
    label:SetText("+0")
    label:Enable(false)

    inst.guid_tips_value = net_string(inst.GUID, TUNING.MOD_ID .. "_tips", TUNING.MOD_ID .. "_tips_event")
    inst:ListenForEvent(TUNING.MOD_ID .. "_tips_event", SetNahidaTips)
    inst.entity:SetPristine()
    inst.persists = false
    local duration = 0.8--持续时间
    inst:DoPeriodicTask(0, UpdatePing, nil, GetTime(), duration)
    inst:DoTaskInTime(duration, inst.Remove)

    return inst
end

return Prefab("dst_gi_nahida_tips", fn)