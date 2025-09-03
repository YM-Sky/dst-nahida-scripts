---
--- sunkenchest_hooks.lua
--- Description: 宝藏hooks
--- Author: 旅行者
--- Date: 2025/8/17 20:18
---

-- 沉底宝箱战利品池
local SUNKENCHEST_LOOT_POOL = {
    -- 必掉物品
    --guaranteed = {
    --    "dst_gi_nahida_fateseat",
    --},
    -- 概率掉落物品 {prefab, chance}
    chance_loot = {
        { "dst_gi_nahida_fateseat", 0.15 },
        { "dst_gi_nahida_keqing_burst_card", 0.15 },
        { "opalpreciousgem", 0.1 },
        { "dst_gi_nahida_growth_value", 0.5 },
        { "goldnugget", 1 },
        { "goldnugget", 1 },
        { "goldnugget", 1 },
        { "goldnugget", 1 },
        { "goldnugget", 1 },
        { "goldnugget", 1 },
        { "goldnugget", 1 },
        { "goldnugget", 1 },
        { "dug_monkeytail", 0.25 },
        { "dug_monkeytail", 0.25 },
        { "dug_monkeytail", 0.25 },
        { "dug_monkeytail", 0.25 },
        { "dug_monkeytail", 0.25 },
        { "gears", 0.5 },
        { "bluegem", 0.25 },
        { "bluegem", 0.25 },
        { "redgem", 0.25 },
        { "redgem", 0.25 },
        { "yellowgem", 0.25}, -- 黄宝石（天体科技）
        { "yellowgem", 0.25}, -- 黄宝石（天体科技）
        {  "greengem", 0.25 }, -- 绿宝石（远古科技）
        {  "greengem", 0.25 }, -- 绿宝石（远古科技）
        {  "orangegem", 0.25 }, -- 橙宝石（天体科技）
        {  "orangegem", 0.25 }, -- 橙宝石（天体科技）
        {  "thulecite", 0.25 }, -- 铥矿（天体科技）
        {  "thulecite", 0.25 }, -- 铥矿（天体科技）
        {  "purplegem", 0.25 }, -- 紫宝石（天体科技）
        {  "purplegem", 0.25 }, -- 紫宝石（天体科技）
    }
}

-- 给沉底宝箱添加lootdropper组件和战利品
AddPrefabPostInit("sunkenchest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddTag("dst_gi_nahida_sunkenchest")
    if inst.components.lootdropper == nil then
        -- 添加lootdropper组件
        inst:AddComponent("lootdropper")
    end

    -- 添加概率掉落物品
    if SUNKENCHEST_LOOT_POOL.chance_loot then
        for _, loot in ipairs(SUNKENCHEST_LOOT_POOL.chance_loot) do
            inst.components.lootdropper:AddChanceLoot(loot[1], loot[2])
        end
    end
end)

AddPrefabPostInit("shell_cluster", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddTag("nahida_salvage_item")
end)

AddPrefabPostInit("oceanfishableflotsam_water", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddTag("nahida_salvage_item")
end)
AddPrefabPostInit("oceanfishableflotsam", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddTag("nahida_salvage_item")
end)

AddPrefabPostInit("moon_altar_crown", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddTag("nahida_salvage_item")
end)

AddPrefabPostInit("oceantreenut", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:AddTag("dst_gi_nahida_oceantreenut")
end)

-- 永不妥协的皇家宝箱
local sunken_treasurechest_list = {
"sunkenchest_royal_random",
"sunkenchest_royal_red",
"sunkenchest_royal_blue",
"sunkenchest_royal_purple",
"sunkenchest_royal_green",
"sunkenchest_royal_orange",
"sunkenchest_royal_yellow",
"sunkenchest_royal_rainbow",
}
if TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.UNCOMPROMISING_MODE then
    for i, prefab in ipairs(sunken_treasurechest_list) do
        AddPrefabPostInit(prefab, function(inst)
            if not TheWorld.ismastersim then
                return
            end
            inst:AddTag("nahida_salvage_item")
        end)
    end
end

AddPrefabPostInit("buriedtreasure", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    if inst.components.lootdropper == nil then
        -- 添加lootdropper组件
        inst:AddComponent("lootdropper")
    end

    -- 添加概率掉落物品
    if SUNKENCHEST_LOOT_POOL.chance_loot then
        for _, loot in ipairs(SUNKENCHEST_LOOT_POOL.chance_loot) do
            inst.components.lootdropper:AddChanceLoot(loot[1], loot[2])
        end
    end
    if TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.SHIPWRECKED then
        inst.components.lootdropper:AddChanceLoot("multitool_axe_pickaxe", 0.15)
        inst.components.lootdropper:AddChanceLoot("opalpreciousgem", 0.1)
        inst.components.lootdropper:AddChanceLoot("yellowstaff", 0.15)
        inst.components.lootdropper:AddChanceLoot("opalstaff", 0.1)
        inst.components.lootdropper:AddChanceLoot("walrus_tusk", 0.15)
        inst.components.lootdropper:AddChanceLoot("ancienttree_seed", 0.1)

    end
end)