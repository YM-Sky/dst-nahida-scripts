---
--- nahida_card_pool.lua
--- Description: 抽奖卡池
--- Author: 没有小钱钱
--- Date: 2025/5/10 1:47
---

TUNING.MOD_DST_GI_NAHIDA_CARD_POOL = {
    NAHIDA_CARD_POOL = {
        -- 蓝色卡池
        BLUE = {
            -- 基础资源
            { name = "seeds", count = 10 }, -- 种子（可种植）
            { name = "twigs", count = 10 }, -- 树枝
            { name = "cutgrass", count = 10 }, -- 草
            { name = "rocks", count = 10 }, -- 石头
            { name = "log", count = 10 }, -- 木头
            { name = "cutreeds", count = 10 }, -- 采下的芦苇

            -- 可种植资源（需用铲子移植）
            { name = "dug_grass", count = 10 }, -- 草簇（可种植）
            { name = "dug_berrybush", count = 3 }, -- 浆果丛（可种植）
            { name = "dug_sapling", count = 5 }, -- 树苗（可种植）
            { name = "rock_avocado_fruit_sprout", count = 1 }, -- 发芽的石果（可种植）
            { name = "dug_monkeytail", count = 5 }, -- 猴尾草（可种植）
            { name = "dug_trap_starfish", count = 3 }, -- 海星陷阱

            -- 魔法资源
            { name = "redgem", count = 1 }, -- 红宝石
            { name = "bluegem", count = 1 }, -- 蓝宝石
            { name = "purplegem", count = 1 }, -- 紫宝石
            { name = "nightmarefuel", count = 1 }, -- 噩梦燃料
            { name = "livinglog", count = 5 }, -- 活木头
            { name = "moonglass_charged", count = 5 }, -- 注能月亮碎片
            { name = "transistor", count = 2 }, -- 电子元件

            -- 矿物
            { name = "nitre", count = 10 }, -- 硝石
            { name = "goldnugget", count = 10 }, -- 金子
            { name = "marble", count = 5 }, -- 大理石
            { name = "moonglass", count = 10 }, -- 月亮碎片
            { name = "moonrocknugget", count = 10 }, -- 月岩

            -- 食物
            { name = "meat", count = 5 }, -- 大肉
            { name = "monstermeat", count = 5 }, -- 怪物肉
            { name = "smallmeat", count = 5 }, -- 小肉
            { name = "dustmeringue", count = 3 }, -- 琥珀美食（烹饪食物）

            -- 防具与武器
            { name = "footballhat", count = 1 }, -- 猪皮头盔
            { name = "hambat", count = 1 }, -- 火腿棒
            { name = "whip", count = 1 }, -- 三尾猫鞭
            { name = "icestaff", count = 1 }, -- 冰魔杖
            { name = "orangestaff", count = 1 }, -- 懒人法杖
            { name = "yellowstaff", count = 1 }, -- 唤星法杖

            -- 特殊掉落
            { name = "malbatross_feather", count = 1 }, -- 邪天翁羽毛（BOSS掉落）
            { name = "feather_robin_winter", count = 1 }, -- 蓝色羽毛（冬季鸟掉落）
            { name = "horn", count = 1 }, -- 鹿角（麋鹿鹅掉落）
            { name = "tentaclespots", count = 3 }, -- 触手皮（触手掉落）
            { name = "manrabbit_tail", count = 3 }, -- 兔绒（兔人掉落）
            { name = "furtuft", count = 5 }, -- 毛丛（熊獾掉落）
            { name = "pigskin", count = 3 }, -- 猪皮（猪人掉落）
            { name = "beefalowool", count = 3 }, -- 牛毛（皮弗娄牛掉落）

            -- 海洋资源
            { name = "bullkelp_root", count = 3 }, -- 公牛海带茎
            { name = "driftwood_log", count = 10 }, -- 浮木桩
            { name = "saltrock", count = 10 }, -- 盐晶
            { name = "messagebottleempty", count = 1 }, -- 空瓶子
            { name = "messagebottle", count = 1 }, -- 瓶中信


            -- 工具与照明
            { name = "goldenaxe", count = 1 }, -- 黄金斧头
            { name = "moonglassaxe", count = 1 }, -- 月光玻璃斧
            { name = "oar_monkey", count = 1 }, -- 战桨
            { name = "lantern", count = 1 }, -- 提灯

            -- 特殊物品
            { name = "dragonflyfurnace_blueprint", count = 1 }, -- 龙鳞火炉蓝图
            { name = "honeycomb", count = 3 }, -- 蜜脾（蜂巢掉落）
            { name = "beeswax", count = 2 }, -- 蜂蜡（蜜蜂掉落）
            { name = "goatmilk", count = 3 }, -- 带电的羊奶（伏特羊掉落）

            -- 鱼饵
            { name = "oceanfishinglure_hermit_heavy", count = 1 }, -- 重量级鱼饵
            { name = "oceanfishinglure_hermit_snow", count = 1 }, -- 雪天鱼饵
            { name = "oceanfishinglure_hermit_rain", count = 1 }, -- 雨天鱼饵
            { name = "oceanfishinglure_hermit_drowsy", count = 1 }, -- 麻醉鱼饵

            -- 其他
            { name = "spoiled_food", count = 10 }, -- 腐烂物
            { name = "poop", count = 10 }, -- 便便
            { name = "gears", count = 5 }, -- 齿轮
            { name = "wagpunk_bits", count = 5 }, -- Wagpunk废料（WX-78升级用）
            { name = "trinket_6", count = 5 }, -- 烂电线（垃圾）
            { name = "townportaltalisman", count = 3 }, -- 沙之石
            { name = "cactus_flower", count = 3 }, -- 仙人掌花（夏季资源）
            -- 生物
            { name = "hound", count = 3 }, -- 野狗
            { name = "spider", count = 3 }, -- 蜘蛛
        },
        -- 紫色卡池
        PURPLE = {
            -- 宝石类
            { name = "yellowgem", count = 1 }, -- 黄宝石（天体科技）
            { name = "greengem", count = 1 }, -- 绿宝石（远古科技）
            { name = "orangegem", count = 1 }, -- 橙宝石（天体科技）

            -- 暗影/魔法物品
            { name = "horrorfuel", count = 2 }, -- 纯粹恐惧
            { name = "purebrilliance", count = 2 }, -- 纯粹辉煌（天体英雄掉落）
            { name = "purpleamulet", count = 1 }, -- 梦魇护符（紫宝石制作）
            --{ name = "shadowheart", count = 1 }, -- 暗影心房（暗影编织者掉落）
            { name = "nightsword", count = 1 }, -- 暗夜剑
            { name = "armor_sanity", count = 1 }, -- 暗夜甲
            { name = "voidcloth", count = 2 }, -- 暗影碎布（暗影生物掉落）

            -- 高级武器/工具
            { name = "trident", count = 1 }, -- 刺耳三叉戟（海难DLC）
            { name = "telestaff", count = 1 }, -- 传送魔杖（紫宝石制作）
            { name = "staff_tornado", count = 1 }, -- 拆解魔杖（天体科技）
            { name = "multitool_axe_pickaxe", count = 1 }, -- 多用斧镐（远古科技）

            -- 稀有生物掉落
            { name = "malbatross_beak", count = 1 }, -- 邪天翁的喙
            { name = "deerclops_eyeball", count = 1 }, -- 独眼巨鹿眼球
            { name = "bearger_fur", count = 1 }, -- 熊皮
            { name = "minotaurhorn", count = 1 }, -- 守护者之角（远古守护者掉落）

            -- 特殊材料
            { name = "lunarplant_husk", count = 1 }, -- 亮茄壳（亮茄世界掉落）
            { name = "gnarwail_horn", count = 1 }, -- 一角鲸的角
            { name = "royal_jelly", count = 5 }, -- 蜂王浆
            { name = "dragon_scales", count = 2 }, -- 鳞片（龙蝇掉落）

            -- 蓝图类
            { name = "trident_blueprint", count = 1 }, -- 三叉戟蓝图
            { name = "deserthat_blueprint", count = 1 }, -- 护目镜图纸（海难DLC）

            -- 其他稀有物品
            { name = "mandrake", count = 1 }, -- 曼德拉草（稀有植物）
            { name = "glommerwings", count = 2 }, -- 格罗姆翅膀
            { name = "cotl_trinket", count = 1 }, -- 红眼冠（帝王蟹掉落）

            { name = "dug_monkeytail", count = 10 }, -- 猴尾草（可种植）

            -- 坎普斯
            { name = "krampus", count = 5 }, -- 坎普斯
            -- 卡片
            { name = "dst_gi_nahida_keqing_burst_card", count = 1 }, -- 刻晴卡片
        },
        -- 金色卡池
        GOLD = {
            -- 特殊角色物品
            { name = "dst_gi_nahida_fateseat", count = 1 }, -- 纳西妲命座（原神联动角色特殊物品）
            ---- 天体科技系列
            { name = "moonrockseed", count = 1 }, -- 天体宝球（解锁天体科技的核心物品）[5,6](@ref)
            --{ name = "hermit_pearl", count = 1 }, -- 珍珠的珍珠（寄居蟹隐士任务最终奖励）[8,9](@ref)
            { name = "security_pulse_cage_full", count = 1 }, -- 充能火花柜（完成瓦格斯塔夫变异生物任务获得）[11,12](@ref)
            { name = "opalpreciousgem", count = 1 }, -- 彩虹宝石（分解唤月者魔杖获得）[14,15](@ref)
            { name = "lunar_forge_kit", count = 1 }, -- 辉煌铁匠铺（天体科技制造站）[16,17](@ref)
            { name = "chestupgrade_stacksize", count = 1 }, -- 弹性空间制造器（升级箱子堆叠上限）[19,20](@ref)
            { name = "alterguardianhat", count = 1 }, -- 启迪之冠（升级箱子堆叠上限）[19,20](@ref)

            -- 亮茄装备系列（2025年最新ID）
            { name = "lunarplanthat", count = 1 }, -- 亮茄头盔（免疫风暴+80%防御）
            { name = "armor_lunarplant", count = 1 }, -- 亮茄盔甲（85%防御+伤害反弹）
            { name = "pickaxe_lunarplant", count = 1 }, -- 亮茄粉碎者（采矿/战斗多功能）
            { name = "shovel_lunarplant", count = 1 }, -- 亮茄锄铲（耕作效率+300%）
            { name = "staff_lunarplant", count = 1 }, -- 亮茄魔杖（群体治疗+照明）

            -- 魔法/暗影装备
            { name = "alterguardianhatshard", count = 5 }, -- 启迪碎片（天体英雄掉落）[26,28](@ref)
            { name = "opalstaff", count = 1 }, -- 唤月者魔杖（月圆升级唤星者魔杖获得）[29](@ref)
            { name = "voidcloth_scythe", count = 1 }, -- 暗影收割者（暗影术基座制作）[32](@ref)
            { name = "shadow_forge_kit", count = 1 }, -- 暗影术基座套装（制作暗影装备的工作站）[33,34](@ref)
            { name = "shadow_battleaxe", count = 1 }, -- 暗影槌（可升级的暗影武器）[36](@ref)
            --{ name = "shadowheart_infused", count = 1 }, -- 附身暗影心房（击败暗影三基佬获得）[39,40](@ref)

            -- 远古/铥矿装备
            { name = "atrium_key", count = 1 }, -- 远古钥匙（击败远古犀牛获得）[42,43](@ref)
            { name = "armorruins", count = 1 }, -- 铥矿盔甲（90%防御）[35,46](@ref)
            { name = "ruinshat", count = 1 }, -- 铥矿皇冠（90%防御+力场护盾）[35](@ref)
            { name = "skeletonhat", count = 1 }, -- 骨头头盔（70%防御+特殊疯狂效果）[52,53](@ref)
            { name = "armorskeleton", count = 1 }, -- 骨头盔甲（远古织影者掉落）[54,55](@ref)

            -- 其他稀有物品
            { name = "krampus_sack", count = 1 }, -- 坎普斯背包（击杀小偷1%概率掉落）[22,23](@ref)
            { name = "ancienttree_seed", count = 2 }, -- 惊喜种子（特殊植物种子）[49,50](@ref)
            -- 卡片
            { name = "dst_gi_nahida_keqing_burst_card", count = 1 }, -- 刻晴卡片
            -- 作物
            { name = "dug_monkeytail", count = 30 }, -- 猴尾草（可种植）
        },
        -- 定轨物品
        EPITOMIZED_PATH = {
            "dst_gi_nahida_fateseat", -- 纳西妲的命座
            "ancienttree_seed", -- 惊喜种子
            "dst_gi_nahida_keqing_burst_card", -- 刻晴卡片
            "dug_monkeytail", -- 猴尾草
        }
    }
}

TUNING.MOD_DST_GI_NAHIDA_LINKED_CARD_POOL = {
    FUNCTIONAL_MEDAL = {
        -- 蓝色卡池
        BLUE = {
            { name = "medal_gift_fruit_seed", count = 1 }, -- 包果种子
            { name = "immortal_fruit_seed", count = 1 }, -- 不朽种子
            { name = "mandrakeberry", count = 5 }, -- 曼德拉果
            { name = "medal_weed_seeds", count = 10 }, -- 杂草种子
            { name = "blank_certificate", count = 1 }, -- 空白勋章
            { name = "toil_money", count = 10 }, -- 血汗钱
        },
        -- 紫色卡池
        PURPLE = {
            { name = "medal_obsidian", count = 10 }, -- 红晶
            { name = "medal_blue_obsidian", count = 10 }, -- 蓝晶
            { name = "blank_certificate", count = 1 }, -- 空白勋章
            { name = "handy_certificate", count = 1 }, -- 巧手勋章
            { name = "wisdom_certificate", count = 1 }, -- 智慧勋章
            { name = "valkyrie_certificate", count = 1 }, -- 女武神勋章
            { name = "lureplant_rod", count = 1 }, -- 食人花法杖
            { name = "bottled_moonlight", count = 1 }, -- 瓶装月光
            { name = "medal_losswetpouch1", count = 1 }, -- 遗失塑料袋·池塘
            { name = "medal_losswetpouch2", count = 1 }, -- 遗失塑料袋·沼泽
            { name = "medal_losswetpouch3", count = 1 }, -- 遗失塑料袋·洞穴
            { name = "medal_losswetpouch4", count = 1 }, -- 遗失塑料袋·海洋
            { name = "medal_losswetpouch5", count = 1 }, -- 遗失塑料袋·岩浆
            { name = "medal_losswetpouch6", count = 1 }, -- 遗失塑料袋·湖泊
            { name = "inherit_certificate", count = 1 }, -- 传承勋章
        },
        -- 金色卡池
        GOLD = {
            { name = "medal_losswetpouch7", count = 1 }, -- 遗失塑料袋·空间
            { name = "large_multivariate_certificate", count = 1 }, -- 高级融合勋章
            { name = "devour_staff", count = 1 }, -- 吞噬法杖
            { name = "medal_time_slider", count = 3 }, -- 时空碎片
            { name = "medal_spacetime_snacks", count = 5 }, -- 时空零食
            { name = "origin_certificate", count = 1 }, -- 本源勋章
        },
        -- 定轨物品
        EPITOMIZED_PATH = {
            "medal_spacetime_snacks", -- 时空零食
            "large_multivariate_certificate", -- 高级融合勋章
            "origin_certificate", -- 本源勋章
        }
    }
}

-- 合并所有启用的联动模组内容到主卡池
local function merge_all_linked_card_pools()
    for mod_name, linked_pool in pairs(TUNING.MOD_DST_GI_NAHIDA_LINKED_CARD_POOL) do
        if TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD[mod_name] then
            for rarity, cards in pairs(linked_pool) do
                for _, card in ipairs(cards) do
                    table.insert(TUNING.MOD_DST_GI_NAHIDA_CARD_POOL.NAHIDA_CARD_POOL[rarity], card)
                end
            end
        end
    end
end
---- 执行合并
merge_all_linked_card_pools()
--
---- 打印合并后的卡池内容（用于调试）
for rarity, cards in pairs(TUNING.MOD_DST_GI_NAHIDA_CARD_POOL.NAHIDA_CARD_POOL) do
    print(rarity .. " 卡池:")
    if rarity ~= "EPITOMIZED_PATH" then
        for _, card in ipairs(cards) do
            print("  - " .. card.name .. " x" .. card.count .. "-" .. tostring(STRINGS.NAMES[string.upper(card.name)]))
        end
    end
end