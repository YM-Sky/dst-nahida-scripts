---@diagnostic disable: lowercase-global, undefined-global, trailing-space
-- 本地化
local op = { { 'A', 97 }, { 'B', 98 }, { 'C', 99 }, { 'D', 100 }, { 'E', 101 }, { 'F', 102 }, { 'G', 103 }, { 'H', 104 }, { 'I', 105 }, { 'J', 106 }, { 'K', 107 }, { 'L', 108 }, { 'M', 109 }, { 'N', 110 }, { 'O', 111 }, { 'P', 112 }, { 'Q', 113 }, { 'R', 114 }, { 'S', 115 }, { 'T', 116 }, { 'U', 117 }, { 'V', 118 }, { 'W', 119 }, { 'X', 120 }, { 'Y', 121 }, { 'Z', 122 }, { '0', 48 }, { '1', 49 }, { '2', 50 }, { '3', 51 }, { '4', 52 }, { '5', 53 }, { '6', 54 }, { '7', 55 }, { '8', 56 }, { '9', 57 } }
-- rate1: 1.0到3.0，步长0.1
local rate1 = {}
for i = 10, 30 do
    local val = i * 0.1
    rate1[#rate1 + 1] = { val .. "", val }
end

-- rate2: 0.01到1.0，步长0.01
local rate2 = {}
for i = 1, 100 do
    local val = i * 0.01
    rate2[#rate2 + 1] = { val .. "", val }
end

-- boom_rates: 0.8到2.0，步长0.1
local boom_rates = {}
for i = 8, 20 do
    local val = i * 0.1
    boom_rates[#boom_rates + 1] = { val .. "", val }
end

-- crystallize_rates: 0.5到2.0，步长0.1
local crystallize_rates = {}
for i = 5, 20 do
    local val = i * 0.1
    crystallize_rates[#crystallize_rates + 1] = { val .. "", val }
end

-- freeze_rates: 0.5到2.0，步长0.1
local freeze_rates = {}
for i = 5, 20 do
    local val = i * 0.1
    freeze_rates[#freeze_rates + 1] = { val .. "", val }
end

-- electro_rates: 0.8到2.0，步长0.1
local electro_rates = {}
for i = 8, 20 do
    local val = i * 0.1
    electro_rates[#electro_rates + 1] = { val .. "", val }
end

-- bloom_rates: 0.5到1.8，步长0.1
local bloom_rates = {}
for i = 5, 18 do
    local val = i * 0.1
    bloom_rates[#bloom_rates + 1] = { val .. "", val }
end

-- quicken_rates: 0.5到2.0，步长0.1
local quicken_rates = {}
for i = 5, 20 do
    local val = i * 0.1
    quicken_rates[#quicken_rates + 1] = { val .. "", val }
end

-- swirl_rates: 0.3到1.5，步长0.1
local swirl_rates = {}
for i = 3, 15 do
    local val = i * 0.1
    swirl_rates[#swirl_rates + 1] = { val .. "", val }
end

local weapon_cds = {}
for i = 10, 60 do
    weapon_cds[#weapon_cds + 1] = { i .. "", i }
end

local modid = 'dst_gi_nahida'
local LANGS = {
    ['zh'] = {
        name = '[DST][原神]白草净华—纳西妲 Nahida',
        description = [[
            作者/码师/文案：没有小钱钱；
            画师：Fish meat ball（角色/动画等主力画师）、核主角、君瘾
            wiki: https://docs.qq.com/aio/DUUpsWFJNQ0JLS05Y
        ]],
        config = {
            { '语言' },
            { modid .. '_lang', '语言', '语言', 'cn',
              {
                  { '简体中文', 'cn' },
                  { 'English', 'en' }
              }
            },
            { '成长设定' },
            { modid .. '_harvest_growth_mode', '收获成长模式', '难度不同，提升值不同，具体看wiki', 'MEDIUM',
              {
                  { '关闭', 'DISABLED' },
                  { '简易', 'EASY' },
                  { '中等', 'MEDIUM' },
                  { '困难', 'DIFFICULTY' }
              }
            },
            -- 40/80/120/240/480/640/1000/不限
            { modid .. '_growth_value_limit', '成长值限制', '最大成长值', 120,
              {
                  { '40', 40 },
                  { '60', 60 },
                  { '80', 80 },
                  { '120', 120 },
                  { '240', 240 },
                  { '480', 480 },
                  { '640', 640 },
                  { '1000', 1000 },
                  { '不限', 99999999999 },
              }
            },
            { modid .. '_light_emitting', '常驻发光', '常驻发光', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_toy_made_max_count', '小玩具每天制作最大值', '小玩具每天制作最大值', 100,
              {
                  { '10', 10 },
                  { '20', 20 },
                  { '30', 30 },
                  { '40', 40 },
                  { '50', 50 },
                  { '100', 100 },
                  { '120', 120 },
                  { '150', 150 },
                  { '240', 240 },
                  { '480', 480 },
                  { '640', 640 },
                  { '1000', 1000 },
                  { '不限', 99999999999 },
              }
            },
            { '技能' },
            { modid .. '_skill', '「所闻遍计」', '元素战技技能快捷键', 114, op },
            { modid .. '_skill_burst', '「心景幻城」', '元素爆发技能快捷键', 120, op },
            { modid .. '_actions_ability_enable', '技能书快捷键 Ctrl + ', '技能书快捷键', 118, op },
            { modid .. '_right_click_actions_enable', '右键动作开启关闭 Ctrl + ', '右键动作开启关闭', 111, op },
            { '暗影秘典' },
            { modid .. '_enable_shadowprotector', '暗影角斗士', '6个战斗仆人太强了，默认禁用', 'disabled',
              {
                  { '启用', 'enabled' },
                  { '禁用', 'disabled' },
              }
            },
            { '传送锚点' },
            { modid .. '_teleport_enable', '传送锚点配方', '可以选择是否开启传送锚点的配方，注意，关闭后已经建造好的，不会消失', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_teleport_hunger_cost', '传送饱食度消耗', '传送时消耗的饱食度', 20,
              {
                  { '0', 0 },
                  { '10', 10 },
                  { '15', 15 },
                  { '20', 20 },
                  { '25', 25 },
                  { '30', 30 },
                  { '40', 40 },
                  { '50', 50 },
              }
            },
            { modid .. '_teleport_sanity_cost', '传送精神值消耗', '传送时消耗的精神值', 10,
              {
                  { '0', 0 },
                  { '10', 10 },
                  { '15', 15 },
                  { '20', 20 },
                  { '25', 25 },
                  { '30', 30 },
                  { '40', 40 },
                  { '50', 50 },
              }
            },
            { '纳西妲的法杖' },
            { modid .. '_dst_gi_nahida_weapon_staff_ejection', '弹射上限', '弹射上限配置1-5', 5,
              {
                  { '1', 1 },
                  { '2', 2 },
                  { '3', 3 },
                  { '4', 4 },
                  { '5', 5 },
              }
            },
            { '植物移植' },
            { modid .. '_flower_cave_enable', '荧光花', '荧光花，是否可移植', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_reeds_enable', '芦苇', '芦苇，是否可移植', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { '命座能力配置' },
            { modid .. '_constellation_6_health_bonus', '6命生命附加', '6命生命值附加效果，附加目标生命值0.2%的伤害', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { '生存赠送命座' },
            { modid .. '_fateseat_presented_enable', '生存赠送命座', '按照生存天数赠送命座，离线不计入生存天数', 'disabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_fateseat_presented_number', '赠送间隔天数', '按照生存天数赠送命座，离线不计入生存天数，间隔天数是生存到间隔天数赠送命座', 10,
              {
                  { '1', 1 },
                  { '2', 2 },
                  { '3', 3 },
                  { '4', 4 },
                  { '5', 5 },
                  { '10', 10 },
                  { '15', 15 },
                  { '20', 20 },
                  { '25', 25 },
                  { '30', 30 },
                  { '35', 35 },
                  { '40', 40 },
                  { '50', 50 },
              }
            },
            { modid .. '_constellation_master_switch', '命座总开关', '命座能力总开关设置，未学习图纸，种子配方，Boss右键总开关，雕像右键总开关 全开或者全关，单个配置，设置不配置', 'default',
              {
                  { '不配置', 'default' },
                  { '全开', 'all_on' },
                  { '全关', 'all_off' }
              }
            },
            { modid .. '_constellation_unknown_recipes', '未学习图纸', '未学习图纸时的命座效果', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_constellation_seed_recipes', '种子配方（不含枣椰）', '种子配方的命座效果', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_evergreen_right_click', '右键松树', '右键松树召唤树精', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { 'Boss右键功能配置' },
            { modid .. '_boss_right_click_master', 'Boss右键总开关', 'Boss右键功能总开关（全局控制）', 'default',
              {
                  { '不配置', 'default' },
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_boss_dragonfly', '龙蝇', '龙蝇右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_boss_bearger', '熊獾', '熊獾右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_boss_moose_goose', '麋鹿鹅', '麋鹿鹅右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_boss_malbatross', '邪天翁', '邪天翁右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_boss_bee_queen', '蜂王巢', '蜂王巢右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_boss_ancient_guardian', '远古犀牛', '远古犀牛右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            {"雕像右键功能配置"},
            { modid .. '_statue_right_click_master', '雕像右键总开关', '雕像右键功能总开关（全局控制）', 'default',
              {
                  { '不配置', 'default' },
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_statue_dragonfly', '龙蝇', '龙蝇雕像右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_statue_bearger', '熊獾', '熊獾雕像右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_statue_moose_goose', '麋鹿鹅', '麋鹿鹅雕像右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_statue_malbatross', '邪天翁', '邪天翁雕像右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_statue_bee_queen', '蜂王', '蜂王雕像右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_statue_ancient_guardian', '远古犀牛', '远古犀牛雕像右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_statue_toadstool', '毒菌蟾蜍', '毒菌蟾蜍雕像右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_statue_deerclops', '巨鹿', '巨鹿雕像右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_statue_antlion', '蚁狮', '蚁狮雕像右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_statue_nightmare_werepig', '梦魇疯猪', '梦魇疯猪雕像右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_statue_hound', '座狼', '座狼雕像右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            {"生物右键功能配置（不在命座能力里）"},
            { modid .. '_creature_voltgoat', '伏特羊', '伏特羊右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_creature_beehive', '蜂巢', '蜂巢右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_creature_wasphive', '杀人蜂巢', '杀人蜂巢右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_creature_monkey', '穴居猴', '穴居猴右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_creature_fish', '摸鱼', '摸鱼右键功能', 'disabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_creature_beefalo', '皮弗娄牛', '皮弗娄牛右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_creature_walrus_camp', '海象营地', '海象营地右键功能', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { '模组物品配置' },
            { modid .. '_toy_recipe_enable', '小玩具配方', '小玩具配方开关（已建造内容不消失）', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_toy_exchange_permission', '小玩具兑换权限', '小玩具兑换权限设置', 'mod_character_only',
              {
                  { '所有玩家', 'all_players' },
                  { '仅模组人物', 'mod_character_only' },
              }
            },
            { modid .. '_gacha_recipe_enable', '抽卡机配方', '抽卡机配方开关（已建造内容不消失）', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_dst_gi_nahida_lifepen_num', '强化强心针使用次数', '强化强心针使用次数', 5,
              {
                  { '1', 1 },
                  { '2', 2 },
                  { '3', 3 },
                  { '4', 4 },
                  { '5', 5 },
                  { '10', 10 },
                  { '不限', -1 },
              }
            },
            { modid .. '_boat_enable', '净善号(船配方)', '净善号(船配方)开关（已建造内容不消失）', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },

            { modid .. '_boat_builder', '净善号(船配方)制作权限', '船的制作权限，如果已经学习过的净善号2蓝图，不会消失。2级船在寄居蟹兑换，如果开了仅模组人物，那么纳西妲可以兑换蓝图给其他玩家，如果开了所有玩家，那么所有玩家可兑换和制作', 'dst_gi_nahida',
              {
                  { '所有玩家', 'player' },
                  { '仅模组人物', 'dst_gi_nahida' },
              }
            },
            { '角色技能栏' },
            { modid .. '_skill_bar_permission', '角色技能栏权限', '角色技能栏使用权限（关闭后无法使用技能卡）', 'all_players',
              {
                  { '全玩家', 'all_players' },
                  { '仅模组人物', 'mod_character_only' },
                  { '关闭', 'disabled' },
              }
            },
            { '元素武器' },
            { modid .. '_freeze_weapon_enable', '元素武器技能', '元素武器技能是否开启，关闭后，所有元素武器只会是一把普通的武器', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { '元素武器技能cd' },
            { modid .. '_weapon_fire_cd', '元素武器-火', '更改元素武器技能cd', 12, weapon_cds},
            { modid .. '_weapon_grass_cd', '元素武器-草', '更改元素武器技能cd', 12, weapon_cds},
            { modid .. '_weapon_ice_cd', '元素武器-冰', '更改元素武器技能cd', 12, weapon_cds},
            { modid .. '_weapon_rock_cd', '元素武器-岩', '更改元素武器技能cd', 12, weapon_cds},
            { modid .. '_weapon_thunder_cd', '元素武器-雷', '更改元素武器技能cd', 12, weapon_cds},
            { modid .. '_weapon_water_cd', '元素武器-水', '更改元素武器技能cd', 12, weapon_cds},
            { modid .. '_weapon_wind_cd', '元素武器-风', '更改元素武器技能cd', 12, weapon_cds},
            { '元素反应' },
            { modid .. '_freeze_reaction_enable', '冻结反应', '冻结反应开关（仅控制是否冰冻）', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { '元素反应倍率' },
            { modid .. '_vaporize_rate', '蒸发反应倍率', '蒸发反应伤害倍率（1.0~3.0）', 1.5, rate1 },
            { modid .. '_freeze_rate', '冻结反应倍率', '冻结反应伤害倍率（0.5~2.0）', 1.0, freeze_rates },
            { modid .. '_electro_charged_rate', '感电反应倍率', '感电反应伤害倍率（0.8~2.0）', 1.2, electro_rates },
            { modid .. '_bloom_rate', '绽放反应倍率', '绽放反应伤害倍率（0.5~1.8）', 1.0, bloom_rates },
            { modid .. '_burning_rate', '燃烧反应倍率', '燃烧反应伤害倍率（0.1~1.0）', 0.27, rate2 },
            { modid .. '_melt_rate', '融化反应倍率', '融化反应伤害倍率（1.0~3.0）', 1.5, rate1 },
            { modid .. '_quicken_rate', '激化反应倍率', '激化反应伤害倍率（0.5~2.0）', 1.0, quicken_rates },
            { modid .. '_overload_rate', '超载反应倍率', '超载反应伤害倍率（1.0~3.0）', 1.5, rate1 },
            { modid .. '_superconduct_rate', '超导反应倍率', '超导反应伤害倍率（1.0~3.0）', 1.5, rate1 },
            { modid .. '_swirl_rate', '扩散反应倍率', '扩散反应伤害倍率（0.3~1.5）', 0.6, swirl_rates },
            { modid .. '_crystallize_rate', '结晶反应倍率', '结晶反应伤害倍率（0.5~2.0）', 1.0, crystallize_rates },
            { modid .. '_overgrow_rate', '蔓激化反应倍率', '蔓激化反应伤害倍率（1.0~3.0）', 1.5, rate1 },
            { modid .. '_hyperbloom_rate', '超激化反应倍率', '超激化反应伤害倍率（1.0~3.0）', 1.5, rate1 },
            { modid .. '_overload_boom_rate', '超载范围爆炸倍率', '超载范围爆炸伤害倍率（0.8~2.0）', 1.2, boom_rates },
            { modid .. '_shatter_rate', '物理碎冰倍率', '物理碎冰伤害倍率（1.0~3.0）', 1.5, rate1 },
            { modid .. '_rock_shatter_rate', '岩元素碎冰倍率', '岩元素碎冰伤害倍率（1.0~3.0）', 1.5, rate1 },
            { 'UI' },
            { modid .. '_enable_slot_bg', '容器格子UI', '容器的就空白格子', 'enabled',
              {
                  { '启用', 'enabled' },
                  { '禁用', 'disabled' },
              }
            },
        }
    },
    ['en'] = {
        name = '[DST][原神]白草净华—纳西妲 Nahida',
        description = [[
        作者/码师/文案：没有小钱钱；
        画师：Fish meat ball（角色/动画等主力画师）、核主角、君瘾
        wiki: https://docs.qq.com/aio/DUUpsWFJNQ0JLS05Y
    ]],
        config = {
            { 'LANGUAGE' },
            { modid .. '_lang', 'Language', 'Choose language', 'en', {
                { '简体中文', 'cn' },
                { 'English', 'en' }
            } },
            { 'Growth Settings' },
            { modid .. '_harvest_growth_mode', 'Harvest Growth Mode', 'Different difficulties have different improvement values, see wiki for details', 'MEDIUM',
              {
                  { 'Disabled', 'DISABLED' },
                  { 'Easy', 'EASY' },
                  { 'Medium', 'MEDIUM' },
                  { 'Hard', 'DIFFICULTY' }
              }
            },
            { modid .. '_growth_value_limit', 'Growth Value Limit', 'Max Growth Value', 120,
              {
                  { '40', 40 },
                  { '60', 60 },
                  { '80', 80 },
                  { '120', 120 },
                  { '240', 240 },
                  { '480', 480 },
                  { '640', 640 },
                  { '1000', 1000 },
                  { 'Unlimited', 99999999999 },
              }
            },
            { modid .. '_light_emitting', 'Permanent Luminescence', 'Permanent Luminescence', 'enabled',
              {
                  { '开启', 'enabled' },
                  { '关闭', 'disabled' },
              }
            },
            { modid .. '_toy_made_max_count', 'Toy Daily Craft Limit', 'Maximum toys that can be crafted per day', 100,
              {
                  { '10', 10 },
                  { '20', 20 },
                  { '30', 30 },
                  { '40', 40 },
                  { '50', 50 },
                  { '100', 100 },
                  { '120', 120 },
                  { '150', 150 },
                  { '240', 240 },
                  { '480', 480 },
                  { '640', 640 },
                  { '1000', 1000 },
                  { 'Unlimited', 99999999999 },
              }
            },
            { 'Skills' },
            { modid .. '_skill', '「All Schemes To Know」', 'Elemental Skill hotkey', 114, op },
            { modid .. '_skill_burst', '「Illusory Heart」', 'Elemental Burst hotkey', 120, op },
            { modid .. '_actions_ability_enable', 'Skill Book Hotkey Ctrl + ', 'Skill book hotkey', 118, op },
            { modid .. '_right_click_actions_enable', 'Right Click Actions Toggle Ctrl + ', 'Right click actions toggle', 111, op },
            { 'Codex Umbra' },
            { modid .. '_enable_shadowprotector', 'Shadow Gladiator', '6 combat servants are too strong, disabled by default', 'disabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { 'Teleport Anchor' },
            { modid .. '_teleport_enable', 'Teleport Waypoint Recipe', 'Choose whether to enable the recipe for Teleport Waypoints. Note: Existing built waypoints will not disappear if disabled', 'enabled',
              {
                  { 'Enable', 'enabled' },
                  { 'Disable', 'disabled' },
              }
            },
            { modid .. '_teleport_hunger_cost', 'Teleport Hunger Cost', 'Hunger consumed when teleporting', 20,
              {
                  { '0', 0 },
                  { '10', 10 },
                  { '15', 15 },
                  { '20', 20 },
                  { '25', 25 },
                  { '30', 30 },
                  { '40', 40 },
                  { '50', 50 },
              }
            },
            { modid .. '_teleport_sanity_cost', 'Teleport Sanity Cost', 'Sanity consumed when teleporting', 10,
              {
                  { '0', 0 },
                  { '10', 10 },
                  { '15', 15 },
                  { '20', 20 },
                  { '25', 25 },
                  { '30', 30 },
                  { '40', 40 },
                  { '50', 50 },
              }
            },
            { 'Nahida\'s Staff' },
            { modid .. '_dst_gi_nahida_weapon_staff_ejection', 'Bounce Limit', 'Bounce limit configuration 1-5', 5,
              {
                  { '1', 1 },
                  { '2', 2 },
                  { '3', 3 },
                  { '4', 4 },
                  { '5', 5 },
              }
            },
            { 'Plant Transplantation' },
            { modid .. '_flower_cave_enable', 'Light Flower', 'Whether Light Flowers can be transplanted', 'enabled',
              {
                  { 'Enable', 'enabled' },
                  { 'Disable', 'disabled' },
              }
            },
            { modid .. '_reeds_enable', 'Reeds', 'Whether Reeds can be transplanted', 'enabled',
              {
                  { 'Enable', 'enabled' },
                  { 'Disable', 'disabled' },
              }
            },
            { 'Constellation Configuration' },
            { modid .. '_constellation_6_health_bonus', 'C6 Health Bonus', 'Constellation 6 health bonus effect', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { 'Survival Constellation Gift' },
            { modid .. '_fateseat_presented_enable', 'Survival Constellation Gift', 'Gift constellations based on survival days, offline days are not counted', 'disabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_fateseat_presented_number', 'Gift Interval Days', 'Gift constellations based on survival days, offline days are not counted, interval days means gift constellation when survived to interval days', 10,
              {
                  { '1', 1 },
                  { '2', 2 },
                  { '3', 3 },
                  { '4', 4 },
                  { '5', 5 },
                  { '10', 10 },
                  { '15', 15 },
                  { '20', 20 },
                  { '25', 25 },
                  { '30', 30 },
                  { '35', 35 },
                  { '40', 40 },
                  { '50', 50 },
              }
            },
            { modid .. '_constellation_master_switch', 'Constellation Master Switch', 'Constellation master switch settings, unlearned recipes, seed recipes, Boss right-click master switch, statue right-click master switch - all on or all off, individual configuration, set no configuration', 'default',
              {
                  { 'No Config', 'default' },
                  { 'All On', 'all_on' },
                  { 'All Off', 'all_off' }
              }
            },
            { modid .. '_constellation_unknown_recipes', 'Unknown Recipes', 'Constellation effect for unlearned recipes', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_constellation_seed_recipes', 'Seed Recipes (Excluding Dates)', 'Constellation effect for seed recipes', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_evergreen_right_click', 'Right Click Pine Tree', 'Right click pine tree to summon tree spirit', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { 'Boss Right Click Configuration' },
            { modid .. '_boss_right_click_master', 'Boss Right Click Master', 'Boss right click function master switch (global control)', 'default',
              {
                  { 'No Config', 'default' },
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_boss_dragonfly', 'Dragonfly', 'Dragonfly right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_boss_bearger', 'Bearger', 'Bearger right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_boss_moose_goose', 'Moose/Goose', 'Moose/Goose right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_boss_malbatross', 'Malbatross', 'Malbatross right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_boss_bee_queen', 'Bee Queen Hive', 'Bee Queen Hive right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_boss_ancient_guardian', 'Ancient Guardian', 'Ancient Guardian right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { 'Statue Right Click Configuration' },
            { modid .. '_statue_right_click_master', 'Statue Right Click Master', 'Statue right click function master switch (global control)', 'default',
              {
                  { 'No Config', 'default' },
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_statue_dragonfly', 'Dragonfly', 'Dragonfly statue right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_statue_bearger', 'Bearger', 'Bearger statue right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_statue_moose_goose', 'Moose/Goose', 'Moose/Goose statue right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_statue_malbatross', 'Malbatross', 'Malbatross statue right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_statue_bee_queen', 'Bee Queen', 'Bee Queen statue right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_statue_ancient_guardian', 'Ancient Guardian', 'Ancient Guardian statue right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_statue_toadstool', 'Toadstool', 'Toadstool statue right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_statue_deerclops', 'Deerclops', 'Deerclops statue right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_statue_antlion', 'Antlion', 'Antlion statue right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_statue_nightmare_werepig', 'Nightmare Werepig', 'Nightmare Werepig statue right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_statue_hound', 'Hound', 'Hound statue right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { 'Creature Right Click Configuration' },
            { modid .. '_creature_voltgoat', 'Volt Goat', 'Volt Goat right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_creature_beehive', 'Beehive', 'Beehive right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_creature_wasphive', 'Killer Bee Hive', 'Killer Bee Hive right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_creature_monkey', 'Cave Monkey', 'Cave Monkey right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_creature_fish', 'Fish Petting', 'Fish petting right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_creature_beefalo', 'Beefalo', 'Beefalo right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_creature_walrus_camp', 'Walrus Camp', 'Walrus Camp right click function', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { 'Module item configuration' },
            { modid .. '_toy_recipe_enable', 'Toy Recipe', 'Toy recipe switch (built content will not disappear)', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_toy_exchange_permission', 'Toy Exchange Permission', 'Toy exchange permission setting', 'mod_character_only',
              {
                  { 'All Players', 'all_players' },
                  { 'Mod Character Only', 'mod_character_only' },
              }
            },
            { modid .. '_gacha_recipe_enable', 'Gacha Machine Recipe', 'Gacha machine recipe switch (built content will not disappear)', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { modid .. '_dst_gi_nahida_lifepen_num', 'Enhanced Heartboost Needle Usage Count', 'Enhanced Heartboost Needle Usage Count', 5,
              {
                  { '1', 1 },
                  { '2', 2 },
                  { '3', 3 },
                  { '4', 4 },
                  { '5', 5 },
                  { '10', 10 },
                  { 'Unlimited', -1 },
              }
            },
            { modid .. '_boat_enable', 'Aranaka (Boat Recipe)', 'Aranaka (Boat Recipe) Toggle (Existing builds will not disappear)', 'enabled',
              {
                  { 'Enable', 'enabled' },
                  { 'Disable', 'disabled' },
              }
            },
            { modid .. '_boat_builder', 'Aranaka (Boat Recipe) Crafting Permission', 'Crafting permissions for the boat. If the Aranaka Lv.2 blueprint has already been learned, it will not be removed. The Lv.2 boat blueprint is exchanged with the Hermit Crab. If "Mod Characters Only" is selected, Nahida can exchange the blueprint for other players. If "All Players" is selected, all players can exchange and craft it.', 'dst_gi_nahida',
              {
                  { 'All Players', 'player' },
                  { 'Mod Characters Only', 'dst_gi_nahida' },
              }
            },
            { 'Character Skill Bar' },
            { modid .. '_skill_bar_permission', 'Skill Bar Permission', 'Character skill bar usage permission (cannot use skill cards when disabled)', 'all_players',
              {
                  { 'All Players', 'all_players' },
                  { 'Nahida Only', 'nahida_only' },
                  { 'Disabled', 'disabled' },
              }
            },
            { 'Elemental Weapons' },
            { modid .. '_freeze_weapon_enable', 'Elemental Weapon Skills', 'Whether Elemental Weapon skills are enabled. If disabled, all elemental weapons will only function as ordinary weapons', 'enabled',
              {
                  { 'Enable', 'enabled' },
                  { 'Disable', 'disabled' },
              }
            },
            { 'Elemental Weapon Skill Cooldown' },
            { modid .. '_weapon_fire_cd', 'Pyro Elemental Weapon', 'Adjust the skill cooldown for elemental weapons', 12, weapon_cds},
            { modid .. '_weapon_grass_cd', 'Dendro Elemental Weapon', 'Adjust the skill cooldown for elemental weapons', 12, weapon_cds},
            { modid .. '_weapon_ice_cd', 'Cryo Elemental Weapon', 'Adjust the skill cooldown for elemental weapons', 12, weapon_cds},
            { modid .. '_weapon_rock_cd', 'Geo Elemental Weapon', 'Adjust the skill cooldown for elemental weapons', 12, weapon_cds},
            { modid .. '_weapon_thunder_cd', 'Electro Elemental Weapon', 'Adjust the skill cooldown for elemental weapons', 12, weapon_cds},
            { modid .. '_weapon_water_cd', 'Hydro Elemental Weapon', 'Adjust the skill cooldown for elemental weapons', 12, weapon_cds},
            { modid .. '_weapon_wind_cd', 'Anemo Elemental Weapon', 'Adjust the skill cooldown for elemental weapons', 12, weapon_cds},
            { 'Elemental Reactions' },
            { modid .. '_freeze_reaction_enable', 'Freeze Reaction', 'Freeze reaction switch (only controls freezing)', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
            { 'Elemental Reactions Rate' },
            { modid .. '_vaporize_rate', 'Vaporize Rate', 'Vaporize reaction damage multiplier (1.0~3.0)', 1.5, rate1 },
            { modid .. '_freeze_rate', 'Freeze Rate', 'Freeze reaction damage multiplier (0.5~2.0)', 1.0, freeze_rates },
            { modid .. '_electro_charged_rate', 'Electro-Charged Rate', 'Electro-Charged reaction damage multiplier (0.8~2.0)', 1.2, electro_rates },
            { modid .. '_bloom_rate', 'Bloom Rate', 'Bloom reaction damage multiplier (0.5~1.8)', 1.0, bloom_rates },
            { modid .. '_burning_rate', 'Burning Rate', 'Burning reaction damage multiplier (0.1~1.0)', 0.27, rate2 },
            { modid .. '_melt_rate', 'Melt Rate', 'Melt reaction damage multiplier (1.0~3.0)', 1.5, rate1 },
            { modid .. '_quicken_rate', 'Quicken Rate', 'Quicken reaction damage multiplier (0.5~2.0)', 1.0, quicken_rates },
            { modid .. '_overload_rate', 'Overload Rate', 'Overload reaction damage multiplier (1.0~3.0)', 1.5, rate1 },
            { modid .. '_superconduct_rate', 'Superconduct Rate', 'Superconduct reaction damage multiplier (1.0~3.0)', 1.5, rate1 },
            { modid .. '_swirl_rate', 'Swirl Rate', 'Swirl reaction damage multiplier (0.3~1.5)', 0.6, swirl_rates },
            { modid .. '_crystallize_rate', 'Crystallize Rate', 'Crystallize reaction damage multiplier (0.5~2.0)', 1.0,crystallize_rates },
            { modid .. '_overgrow_rate', 'Overgrow Rate', 'Overgrow reaction damage multiplier (1.0~3.0)', 1.5, rate1 },
            { modid .. '_hyperbloom_rate', 'Hyperbloom Rate', 'Hyperbloom reaction damage multiplier (1.0~3.0)', 1.5, rate1 },
            { modid .. '_overload_boom_rate', 'Overload Boom Rate', 'Overload area explosion damage multiplier (0.8~2.0)', 1.2,boom_rates },
            { modid .. '_shatter_rate', 'Physical Shatter Rate', 'Physical shatter damage multiplier (1.0~3.0)', 1.5, rate1 },
            { modid .. '_rock_shatter_rate', 'Geo Shatter Rate', 'Geo shatter damage multiplier (1.0~3.0)', 1.5, rate1 },
            { 'UI' },
            { modid .. '_enable_slot_bg', 'Container Slot UI', 'Container empty slot background UI', 'enabled',
              {
                  { 'Enabled', 'enabled' },
                  { 'Disabled', 'disabled' },
              }
            },
        }
    }
}

-- 决定当前用的语言
local cur = (locale == 'zh' or locale == 'zhr') and 'zh' or 'en'

-- mod相关信息
version = '1.3.1.2'
author = '没有小钱钱'
forumthread = ''
api_version = 10
priority = 0 -- 加载优先级，越低加载越晚，默认为0

dst_compatible = true -- 联机版适配性
dont_starve_compatible = false -- 单机版适配性
reign_of_giants_compatible = false -- 单机版：巨人国适配性
all_clients_require_mod = true -- 服务端/所有端模组
-- server_only_mod = true -- 仅服务端模组
-- client_only_mod = true -- 仅客户端模组
server_filter_tags = {} -- 创意工坊模组分类标签
icon_atlas = 'modicon.xml' -- 图集
icon = 'modicon.tex' -- 图标

-- 以下自动配置
name = LANGS[cur].name
description = version .. '\n' .. LANGS[cur].description

-- local op = {
--     {description='A', data = 97},
--     {description='B', data = 98},
--     {description='C', data = 99},
--     {description='D', data = 100},
--     {description='E', data = 101},
--     {description='F', data = 102},
--     {description='G', data = 103},
--     {description='H', data = 104},
--     {description='I', data = 105},
--     {description='J', data = 106},
--     {description='K', data = 107},
--     {description='L', data = 108},
--     {description='M', data = 109},
--     {description='N', data = 110},
--     {description='O', data = 111},
--     {description='P', data = 112},
--     {description='Q', data = 113},
--     {description='R', data = 114},
--     {description='S', data = 115},
--     {description='T', data = 116},
--     {description='U', data = 117},
--     {description='V', data = 118},
--     {description='W', data = 119},
--     {description='X', data = 120},
--     {description='Y', data = 121},
--     {description='Z', data = 122},

--     {description='0', data = 48},
--     {description='1', data = 49},
--     {description='2', data = 50},
--     {description='3', data = 51},
--     {description='4', data = 52},
--     {description='5', data = 53},
--     {description='6', data = 54},
--     {description='7', data = 55},
--     {description='8', data = 56},
--     {description='9', data = 57},
-- }

local config = LANGS[cur].config or {}
local _configuration_options = {}
for i = 1, #config do
    local options = {}
    if config[i][5] then
        for k = 1, #config[i][5] do
            options[k] = { description = config[i][5][k][1], data = config[i][5][k][2] }
        end
    end
    _configuration_options[i] = {
        name = config[i][1],
        label = config[i][2],
        hover = config[i][3] or '',
        default = config[i][4] or false,
        options = #options > 0 and options or { { description = "", data = false } },
    }
end

configuration_options = _configuration_options