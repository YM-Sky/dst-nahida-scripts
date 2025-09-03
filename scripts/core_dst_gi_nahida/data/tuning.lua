local modid = 'dst_gi_nahida'

local current_config = "DEFAULT"
-- 元素武器
local _freeze_weapon_enable = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_freeze_weapon_enable") -- 元素武器技能
local _weapon_fire_cd = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_weapon_fire_cd") -- 元素武器-火
local _weapon_grass_cd = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_weapon_grass_cd") -- 元素武器-草
local _weapon_ice_cd = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_weapon_ice_cd") -- 元素武器-冰
local _weapon_rock_cd = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_weapon_rock_cd") -- 元素武器-岩
local _weapon_thunder_cd = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_weapon_thunder_cd") -- 元素武器-雷
local _weapon_water_cd = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_weapon_water_cd") -- 元素武器-水
local _weapon_wind_cd = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_weapon_wind_cd") -- 元素武器-风
-- 其他功能开关
local _light_emitting = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_light_emitting") -- 常驻发光
local _boat_enable = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_boat_enable") -- 船配方开个
local _boat_builder = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_boat_builder") -- 船制作权限
-- 元素反应倍率配置
local _vaporize_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_vaporize_rate")
local _freeze_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_freeze_rate")
local _electro_charged_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_electro_charged_rate")
local _bloom_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_bloom_rate")
local _burning_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_burning_rate")
local _melt_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_melt_rate")
local _quicken_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_quicken_rate")
local _overload_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_overload_rate")
local _superconduct_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_superconduct_rate")
local _swirl_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_swirl_rate")
local _crystallize_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_crystallize_rate")
local _overgrow_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_overgrow_rate")
local _hyperbloom_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_hyperbloom_rate")
local _overload_boom_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_overload_boom_rate")
local _shatter_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_shatter_rate")
local _rock_shatter_rate = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_rock_shatter_rate")
-- 移植    '_flower_cave_enable', -- 荧光花移植
--    '_reeds_enable', -- 芦苇移植
local _flower_cave_enable = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_flower_cave_enable")
local _reeds_enable = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_reeds_enable")
-- 强心针使用次数
local _dst_gi_nahida_lifepen_num = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_dst_gi_nahida_lifepen_num")
-- 元素反应 冻结反应
local _freeze_reaction_enable = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_freeze_reaction_enable")
-- 传送锚点配方
local _teleport_enable = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_teleport_enable")
-- 纳西妲的法杖弹射上限
local _dst_gi_nahida_weapon_staff_ejection = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_dst_gi_nahida_weapon_staff_ejection")
-- 技能栏开放权限
local _skill_bar_permission = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_skill_bar_permission")
-- 小玩具制作站
local _toy_recipe_enable = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_toy_recipe_enable")
-- 小玩具兑换权限
local _toy_exchange_permission = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_toy_exchange_permission")
-- 抽卡机配方
local _gacha_recipe_enable = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_gacha_recipe_enable")
-- 命座能力总开关
local _constellation_master_switch = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_constellation_master_switch")
-- Boss右键总开关
local _boss_right_click_master = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_boss_right_click_master")
-- 雕像右键总开关
local _statue_right_click_master = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_statue_right_click_master")

-- 获取各项配置
local _constellation_unknown_recipes = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_constellation_unknown_recipes")
local _constellation_seed_recipes = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_constellation_seed_recipes")
local _evergreen_right_click = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_evergreen_right_click")
local _constellation_6_health_bonus = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_constellation_6_health_bonus")

-- Boss右键配置
local _boss_dragonfly = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_boss_dragonfly")
local _boss_bearger = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_boss_bearger")
local _boss_moose_goose = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_boss_moose_goose")
local _boss_malbatross = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_boss_malbatross")
local _boss_bee_queen = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_boss_bee_queen")
local _boss_ancient_guardian = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_boss_ancient_guardian")

-- 雕像右键配置
local _statue_dragonfly = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_statue_dragonfly")
local _statue_bearger = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_statue_bearger")
local _statue_moose_goose = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_statue_moose_goose")
local _statue_malbatross = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_statue_malbatross")
local _statue_bee_queen = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_statue_bee_queen")
local _statue_ancient_guardian = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_statue_ancient_guardian")
local _statue_toadstool = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_statue_toadstool")
local _statue_deerclops = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_statue_deerclops")
local _statue_antlion = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_statue_antlion")
local _statue_nightmare_werepig = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_statue_nightmare_werepig")
local _statue_hound = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_statue_hound")

-- 生物右键配置
local _creature_voltgoat = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_creature_voltgoat")
local _creature_beehive = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_creature_beehive")
local _creature_wasphive = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_creature_wasphive")
local _creature_monkey = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_creature_monkey")
local _creature_fish = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_creature_fish")
local _creature_beefalo = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_creature_beefalo")
local _creature_walrus_camp = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_creature_walrus_camp")

TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CONFIG = {
    ["DEFAULT"] = {
        -------------------------移植内容-----------------------
        FLOWER_CAVE_ENABLE = _flower_cave_enable == "enabled",
        REEDS_ENABLE = _reeds_enable == "enabled",
        -- --------------------元素武器-------------------
        FREEZE_WEAPON_ENABLE = _freeze_weapon_enable == "enabled",
        WEAPON_FIRE_CD = _weapon_fire_cd or 12,
        WEAPON_GRASS_CD = _weapon_grass_cd or 12,
        WEAPON_ICE_CD = _weapon_ice_cd or 12,
        WEAPON_ROCK_CD = _weapon_rock_cd or 12,
        WEAPON_THUNDER_CD = _weapon_thunder_cd or 12,
        WEAPON_WATER_CD = _weapon_water_cd or 12,
        WEAPON_WIND_CD = _weapon_wind_cd or 12,
        -- --------------------其他能力-------------------
        -- 船配方是否开启
        BOAT_ENABLE = _boat_enable == "enabled",
        BOAT_BUILDER = _boat_builder or  "dst_gi_nahida",
        -- 常驻发光是否开启
        LIGHT_EMITTING = _light_emitting == "enabled",
        -- 传送锚点配方
        DST_GI_NAHIDA_LIFEPEN_NUM = _dst_gi_nahida_lifepen_num,
        -- 传送锚点配方
        TELEPORT_ENABLE = _teleport_enable == "enabled",
        -- 纳西妲的法杖弹射上限
        DST_GI_NAHIDA_WEAPON_STAFF_EJECTION = _dst_gi_nahida_weapon_staff_ejection or 5,
        -- 抽卡机
        GACHA_RECIPE_ENABLE = _gacha_recipe_enable == "enabled",
        -- 小玩具制作站
        TOY_RECIPE_ENABLE = _toy_recipe_enable == "enabled",
        TOY_EXCHANGE_PERMISSION = _toy_exchange_permission or "mod_character_only",
        -- 角色技能栏权限
        SKILL_BAR_PERMISSION = _skill_bar_permission or "all_players",
        -- 冻结反应开关
        FREEZE_REACTION_ENABLE = _freeze_reaction_enable == "enabled",
        -- 元素反应倍率配置
        VAPORIZE_RATE = _vaporize_rate or 1.5,
        FREEZE_RATE = _freeze_rate or 1.0,
        ELECTRO_CHARGED_RATE = _electro_charged_rate or 1.2,
        BLOOM_RATE = _bloom_rate or 1.0,
        BURNING_RATE = _burning_rate or 0.27,
        MELT_RATE = _melt_rate or 1.5,
        QUICKEN_RATE = _quicken_rate or 1.0,
        OVERLOAD_RATE = _overload_rate or 1.5,
        SUPERCONDUCT_RATE = _superconduct_rate or 1.5,
        SWIRL_RATE = _swirl_rate or 0.6,
        CRYSTALLIZE_RATE = _crystallize_rate or 1.0,
        OVERGROW_RATE = _overgrow_rate or 1.5,
        HYPERBLOOM_RATE = _hyperbloom_rate or 1.5,
        OVERLOAD_BOOM_RATE = _overload_boom_rate or 1.2,
        SHATTER_RATE = _shatter_rate or 1.5,
        ROCK_SHATTER_RATE = _rock_shatter_rate or 1.5,
        -- 基础命座能力
        CONSTELLATION_UNKNOWN_RECIPES = (_constellation_master_switch == "default" and _constellation_unknown_recipes == "enabled") or _constellation_master_switch == "all_on" or false, -- 未学习图纸时的命座效果
        CONSTELLATION_SEED_RECIPES = (_constellation_master_switch == "default" and _constellation_seed_recipes == "enabled") or _constellation_master_switch == "all_on" or false, -- 种子配方的命座效果
        EVERGREEN_RIGHT_CLICK = (_constellation_master_switch == "default" and _evergreen_right_click == "enabled") or _constellation_master_switch == "all_on" or false, -- 右键松树召唤树精
        CONSTELLATION_6_HEALTH_BONUS = _constellation_6_health_bonus == "enabled" or false, -- 6命座生命值附加效果

        -- Boss右键功能（需要命座总开关、Boss右键总开关、具体Boss开关都开启）
        BOSS_DRAGONFLY = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _boss_right_click_master == "enabled") or (_constellation_master_switch == "default" and _boss_right_click_master == "default" and _boss_dragonfly == "enabled") or false, -- 龙蝇Boss右键功能
        BOSS_BEARGER = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _boss_right_click_master == "enabled") or (_constellation_master_switch == "default" and _boss_right_click_master == "default" and _boss_bearger == "enabled") or false, -- 熊獾Boss右键功能
        BOSS_MOOSE_GOOSE = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _boss_right_click_master == "enabled") or (_constellation_master_switch == "default" and _boss_right_click_master == "default" and _boss_moose_goose == "enabled") or false, -- 麋鹿鹅Boss右键功能
        BOSS_MALBATROSS = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _boss_right_click_master == "enabled") or (_constellation_master_switch == "default" and _boss_right_click_master == "default" and _boss_malbatross == "enabled") or false, -- 邪天翁Boss右键功能
        BOSS_BEE_QUEEN = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _boss_right_click_master == "enabled") or (_constellation_master_switch == "default" and _boss_right_click_master == "default" and _boss_bee_queen == "enabled") or false, -- 蜂王Boss右键功能
        BOSS_ANCIENT_GUARDIAN = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _boss_right_click_master == "enabled") or (_constellation_master_switch == "default" and _boss_right_click_master == "default" and _boss_ancient_guardian == "enabled") or false, -- 远古守护者Boss右键功能

        -- 雕像右键功能（需要命座总开关、雕像右键总开关、具体雕像开关都开启）
        STATUE_DRAGONFLY = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _statue_right_click_master == "enabled") or (_constellation_master_switch == "default" and _statue_right_click_master == "default" and _statue_dragonfly == "enabled") or false, -- 龙蝇雕像右键召唤
        STATUE_BEARGER = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _statue_right_click_master == "enabled") or (_constellation_master_switch == "default" and _statue_right_click_master == "default" and _statue_bearger == "enabled") or false, -- 熊獾雕像右键召唤
        STATUE_MOOSE_GOOSE = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _statue_right_click_master == "enabled") or (_constellation_master_switch == "default" and _statue_right_click_master == "default" and _statue_moose_goose == "enabled") or false, -- 麋鹿鹅雕像右键召唤
        STATUE_MALBATROSS = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _statue_right_click_master == "enabled") or (_constellation_master_switch == "default" and _statue_right_click_master == "default" and _statue_malbatross == "enabled") or false, -- 邪天翁雕像右键召唤
        STATUE_BEE_QUEEN = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _statue_right_click_master == "enabled") or (_constellation_master_switch == "default" and _statue_right_click_master == "default" and _statue_bee_queen == "enabled") or false, -- 蜂王雕像右键召唤
        STATUE_ANCIENT_GUARDIAN = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _statue_right_click_master == "enabled") or (_constellation_master_switch == "default" and _statue_right_click_master == "default" and _statue_ancient_guardian == "enabled") or false, -- 远古守护者雕像右键召唤
        STATUE_TOADSTOOL = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _statue_right_click_master == "enabled") or (_constellation_master_switch == "default" and _statue_right_click_master == "default" and _statue_toadstool == "enabled") or false, -- 毒菌蟾蜍雕像右键召唤
        STATUE_DEERCLOPS = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _statue_right_click_master == "enabled") or (_constellation_master_switch == "default" and _statue_right_click_master == "default" and _statue_deerclops == "enabled") or false, -- 独眼巨鹿雕像右键召唤
        STATUE_ANTLION = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _statue_right_click_master == "enabled") or (_constellation_master_switch == "default" and _statue_right_click_master == "default" and _statue_antlion == "enabled") or false, -- 蚁狮雕像右键召唤
        STATUE_NIGHTMARE_WEREPIG = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _statue_right_click_master == "enabled") or (_constellation_master_switch == "default" and _statue_right_click_master == "default" and _statue_nightmare_werepig == "enabled") or false, -- 梦魇疯猪雕像右键召唤
        STATUE_HOUND = _constellation_master_switch == "all_on" or (_constellation_master_switch == "default" and _statue_right_click_master == "enabled") or (_constellation_master_switch == "default" and _statue_right_click_master == "default" and _statue_hound == "enabled") or false, -- 座狼雕像右键召唤

        -- 生物右键功能（只需要命座总开关和对应生物开关）
        CREATURE_VOLTGOAT = (_constellation_master_switch == "default" and _creature_voltgoat == "enabled") or _constellation_master_switch == "all_on" or false, -- 伏特羊右键功能
        CREATURE_BEEHIVE = (_constellation_master_switch == "default" and _creature_beehive == "enabled") or _constellation_master_switch == "all_on" or false, -- 蜂巢右键功能
        CREATURE_WASPHIVE = (_constellation_master_switch == "default" and _creature_wasphive == "enabled") or _constellation_master_switch == "all_on" or false, -- 杀人蜂巢右键功能
        CREATURE_MONKEY = (_constellation_master_switch == "default" and _creature_monkey == "enabled") or _constellation_master_switch == "all_on" or false, -- 猴子右键功能
        CREATURE_FISH = (_constellation_master_switch == "default" and _creature_fish == "enabled") or _constellation_master_switch == "all_on" or false, -- 鱼类右键功能
        CREATURE_BEEFALO = (_constellation_master_switch == "default" and _creature_beefalo == "enabled") or _constellation_master_switch == "all_on" or false, -- 皮弗娄牛右键功能
        CREATURE_WALRUS_CAMP = (_constellation_master_switch == "default" and _creature_walrus_camp == "enabled") or _constellation_master_switch == "all_on" or false, -- 海象营地右键功能}
    },
}

TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CONFIG[current_config]

TUNING.MOD_DST_GI_NAHIDA = {
    ---@type table<PrefabID,{type: 'finiteuses'|'armor'|'fueled', repair_percent: table<PrefabID,number>, cantequip_whennodurability: boolean|nil, autounequip_whennodurability: boolean|nil}>
    REPAIR_COMMON = { -- 官方的三个组件的修理, finiteuses armor fueled, 给一堆物品时, 尽可能多的消耗物品来修理
        -- spear = {
        --     type = 'finiteuses', -- 组件ID
        --     repair_percent = { -- 键为物品prefabID, 值为修理百分比
        --         flint = .2,
        --     },
        --     cantequip_whennodurability = false, -- 是否在耐久用尽时不允许装备,如果你得物品在耐久耗尽时,就直接被移除了,这个就不用填了,只有在耐久用尽,要保留物品时才填这个
        --     autounequip_whennodurability = false, -- 是否在耐久用尽时自动卸下到库存中
        -- },
    },
    ATK_SPEED_ALT = 1, -- alt写的加攻速模块所用的参数,默认1,更改这个参数,来改变攻速
    NAHIDA_NOT_HATRED = "nahida_not_hatred", -- 无仇恨标签
    NAHIDA_NO_STEAL = "dst_gi_nahida_no_steal", -- 防偷标签
    NAHIDA_RIGHT_CLICK_ACTION_TAG = "dst_gi_nahida_right_click_action", -- 右键属性标签
    NAHIDA_CHESSPIECE_TAG = "dst_gi_nahida_chesspiece", -- 雕像标签
    NAHIDA_FISH_TAG = "dst_gi_nahida_fish", -- 鱼类标签
    NAHIDA_SEED_OF_SKANDHA_TAG = "dst_gi_nahida_seed_of_skandha", -- 蕴种印标签
    NAHIDA_ILLUSORY_HEART_TAG_LEVEL = {
        BUFF0 = "dst_gi_nahida_illusory_heart_buff0",
        BUFF1 = "dst_gi_nahida_illusory_heart_buff1",
        BUFF2 = "dst_gi_nahida_illusory_heart_buff2",
        BUFF3 = "dst_gi_nahida_illusory_heart_buff3",
        BUFF4 = "dst_gi_nahida_illusory_heart_buff4",
        BUFF5 = "dst_gi_nahida_illusory_heart_buff5",
        BUFF6 = "dst_gi_nahida_illusory_heart_buff6",
    },
    --0命：元素爆发，角色伤害提升10% 伤害减免35%，移速加成20%
    --1命：强化元素爆发，角色伤害提升至20%
    --2命：燃烧，草原核20%几率，造成2倍伤害
    --3命：元素战技范围提升战技范围+5，催熟范围+4
    --4命：附近处于所闻遍计的蕴种印状态下的敌人数量为1/2/3/4或更多时，纳西姐的伤害提升20/30/40/50点。
    --5命：心景幻成强化，受到伤害减少65%，30%移速
    --6命：心景幻成范围内，强化蕴种印，普攻攻击敌人时，范围内携带蕴种印的怪物造成一次灭净三叶*业障除伤害，0.2秒最多触发一次，持续10秒，最多触发6次，
    -- 给玩家添加的标签 有0命，1命，5命的标签
    NAHIDA_FATESEAT_NUMERICAL = {
        FATESEAT0 = { -- 元素爆发，角色伤害提升10%
            MULTIPLIERS = 0.1,
            EXTERNALABSORBMODIFIERS = 0.35, -- 伤害减免
            EXTERNAL_SPEED_MULTIPLIER = 1.2, -- 移速加成
        },
        FATESEAT1 = {  -- 强化元素爆发，角色伤害提升至20%
            MULTIPLIERS = 0.2
        },
        FATESEAT2 = { -- 燃烧，草原核20%几率，造成2倍伤害
            PROBABILITY = 0.2,
            MULTIPLIERS = 2
        },
        FATESEAT3 = { -- 元素战技范围提升
            SKILL_RADIUS = 5, -- 元素战技范围提升 基础范围15 + SKILL_RADIUS
            TRY_GROWTH_RADIUS = 2 -- 元素战技催熟范围提升 实际乘以2的，实际是4 (基础范围15 + TRY_GROWTH_RADIUS) * 2
        },
        FATESEAT4 = { -- 附近处于所闻遍计的蕴种印状态下的敌人数量为1/2/3/4或更多时，纳西姐的伤害提升100/120/140/160点。
            NUM1 = 20, -- 对应敌人数量
            NUM2 = 30, -- 对应敌人数量
            NUM3 = 40, -- 对应敌人数量
            NUM4 = 50, -- 对应敌人数量
        },
        FATESEAT5 = { -- 心景幻成强化，受到伤害减少60%，30%移速
            EXTERNALABSORBMODIFIERS = 0.65, -- 伤害减免
            EXTERNAL_SPEED_MULTIPLIER = 1.3, -- 移速加成
        }
    },
    -- 元素反应倍率
    NAHIDA_REACTION_MULTIPLIERS = {
        Evaporate = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.VAPORIZE_RATE, -- 蒸发反应倍率，通常用于水与火的反应
        Frozen = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.FREEZE_RATE, -- 冻结反应倍率，通常用于水与冰的反应
        ElectroCharged = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.ELECTRO_CHARGED_RATE, -- 感电反应倍率，通常用于水与雷的反应
        Bloom = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BLOOM_RATE, -- 绽放反应倍率，通常用于水与草的反应
        Burn = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BURNING_RATE, -- 燃烧反应倍率，通常用于火与草的反应
        Melt = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.MELT_RATE, -- 融化反应倍率，通常用于火与冰的反应
        Quicken = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.QUICKEN_RATE, -- 激化反应倍率，通常用于草与雷的反应
        Crystallize = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CRYSTALLIZE_RATE, -- 结晶反应倍率，通常用于岩与其他元素的反应
        Swirl = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.SWIRL_RATE, -- 扩散反应倍率，通常用于风与其他元素的反应
        Overgrow = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.OVERGROW_RATE, -- 蔓激化反应倍率，通常用于草与雷的特殊反应
        Hyperbloom = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.HYPERBLOOM_RATE, -- 超激化反应倍率，通常用于草与雷的特殊反应
        Overload = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.OVERLOAD_RATE, -- 超载反应倍率
        OverloadBoom = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.OVERLOAD_BOOM_RATE, -- 超载范围爆炸倍率
        Superconduct = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.SUPERCONDUCT_RATE, -- 超导反应倍率
        Shatter = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.SHATTER_RATE, -- 物理碎冰
        RockShatter = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.ROCK_SHATTER_RATE   -- 岩元素碎冰
    },
    DAMAGE_TYPE = {
        PHYSICAL = "physical",
        ELEMENTAL = "elemental"
    },
    SKILL_MODE = {
        FIGHT = "FIGHT",
        HARVEST = "HARVEST",
        PICK_UP = "PICK_UP",
        GROWTH = "GROWTH",
    },
    UPGRADE_PRESERVER_ITEM = {
        "dst_gi_nahida_everfrost_ice_crystal", -- 本模组内的极寒之核
        --"kq_coldcore", -- 刻晴的极寒之核
        --"immortal_gem", -- 勋章的不朽宝石
    },
    WEAPON_STAFF_MODE = {
        [1] = "NORMAL",
        [2] = "DESTROY"
    }
}

TOOLACTIONS.NAHIDA_CHOP_BAMBOO = true
TOOLACTIONS.NAHIDA_SCYTHE = true

GLOBAL.MOD_DST_GI_NAHIDA = {
    NAHIDA_PLAYER = {},
    NAHIDA_BACKPACK = {},
    NAHIDA_SEFF = {},
}

TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT = {
    --test_guid = {
    --    guid = "",
    --    pos = Vector3(0, 0, 0),
    --    info = ""
    --}
}

-- 元素强度
TUNING.ELEMENTAL_STRENGTH = {
    WEAK = "weak", -- 弱
    MEDIUM = "medium", -- 中
    STRONG = "strong", -- 强
    VERY_STRONG = "very_strong", -- 强强
}

TUNING.ATTACK_ELEMENTAL_TYPE = {
    GrassAttack = "GrassAttack", -- 草元素攻击方法
    RockAttack = "RockAttack", -- 岩元素攻击方法
    WindAttack = "WindAttack", -- 风元素攻击方法
    ThunderAttack = "ThunderAttack", -- 雷元素攻击方法
    IceAttack = "IceAttack", -- 冰元素攻击方法
    FireAttack = "FireAttack", -- 火元素攻击方法
    WaterAttack = "WaterAttack", -- 水元素攻击方法
    PhysicalAttack = "PhysicalAttack", -- 物理攻击方法
}

TUNING.ELEMENTAL_TYPE = {
    -- 水元素：用于触发感电、冻结等反应
    WATER = "water",
    -- 火元素：用于触发蒸发、超载、燃烧等反应
    FIRE = "fire",
    -- 冰元素：用于触发冻结、融化、超导等反应
    ICE = "ice",
    -- 雷元素：用于触发感电、超载、超导等反应
    THUNDER = "thunder",
    -- 草元素：用于触发燃烧、绽放、激化等反应
    GRASS = "grass",
    -- 风元素
    WIND = "wind",
    -- 岩元素
    ROCK = "rock",
    -- 燃元素
    BURN = "burn",
    -- 激元素
    EXCITE = "excite",
    -- 冻元素
    FREEZE = "freeze",
    -- 物理攻击类型
    PHYSICAL = "physical",
}

-- 定义一个映射表，将类型代码映射到字符串类型
TUNING.TIP_TYPE = {
    NUM = 10000, -- 用于编码的基数
    NUM_TO_KEY = {
        [1] = "WATER", -- 水元素
        [2] = "FIRE", -- 火元素
        [3] = "ICE", -- 冰元素
        [4] = "THUNDER", -- 雷元素
        [5] = "GRASS", -- 草元素
        [6] = "WIND", -- 风元素
        [7] = "ROCK", -- 岩元素
        [8] = "PHYSICAL", -- 岩元素
    },
    KEY_TO_NUM = {
        WATER = 1, -- 水元素
        FIRE = 2, -- 火元素
        ICE = 3, -- 冰元素
        THUNDER = 4, -- 雷元素
        GRASS = 5, -- 草元素
        WIND = 6, -- 风元素
        ROCK = 7, -- 岩元素
        PHYSICAL = 8     -- 岩元素
    }
}

TUNING.NAHIDA_RECIPE_INGREDIENTMOD = {}
-- 命座解锁配方
TUNING.NAHIDA_RECIPES = {}
--
TUNING.SANITY_1 = 10
TUNING.SANITY_2 = 40
TUNING.SANITY_3 = 60
TUNING.NAHIDA_BOSS = {

}
TUNING.DST_GI_NAHIDA_CONTAINER_ACTIONS = {}

--收获模式成长数值
TUNING.HARVEST_GROWTH_DATA = {
    DISABLED = {
        OVERSIZED_PICK_NUM_DELTA = 0, --巨型收获成长数值
        FARM_PLANT_NUM_DELTA = 0 -- 普通收获成长数值
    },
    EASY = { -- 简易
        OVERSIZED_PICK_NUM_DELTA = 1, --巨型收获成长数值
        FARM_PLANT_NUM_DELTA = 0.1 -- 普通收获成长数值
    },
    MEDIUM = {
        OVERSIZED_PICK_NUM_DELTA = 1, --巨型收获成长数值
        FARM_PLANT_NUM_DELTA = 0 -- 普通收获成长数值
    },
    DIFFICULTY = {
        OVERSIZED_PICK_NUM_DELTA = 0.1, --巨型收获成长数值
        FARM_PLANT_NUM_DELTA = 0 -- 普通收获成长数值
    }
}

TUNING.ELEMENTAL_WEAPON = {
    dst_gi_nahida_weapon_fire = {
        fn = function(target, ...)
            if target.components.dst_gi_nahida_elemental_reaction then
                target.components.dst_gi_nahida_elemental_reaction:FireAttack(...)
            end
        end
    },
    dst_gi_nahida_weapon_water = {
        fn = function(target, ...)
            if target.components.dst_gi_nahida_elemental_reaction then
                target.components.dst_gi_nahida_elemental_reaction:WaterAttack(...)
            end
        end
    },
    dst_gi_nahida_splendor_of_tranquil_waters = {
        fn = function(target, ...)
            if target.components.dst_gi_nahida_elemental_reaction then
                target.components.dst_gi_nahida_elemental_reaction:PhysicalAttack(...)
            end
        end
    },
    dst_gi_nahida_weapon_grass = {
        fn = function(target, ...)
            if target.components.dst_gi_nahida_elemental_reaction then
                target.components.dst_gi_nahida_elemental_reaction:GrassAttack(...)
            end
        end
    },
    dst_gi_nahida_weapon_ice = {
        fn = function(target, ...)
            if target.components.dst_gi_nahida_elemental_reaction then
                target.components.dst_gi_nahida_elemental_reaction:IceAttack(...)
            end
        end
    },
    dst_gi_nahida_weapon_rock = {
        fn = function(target, ...)
            if target.components.dst_gi_nahida_elemental_reaction then
                target.components.dst_gi_nahida_elemental_reaction:RockAttack(...)
            end
        end
    },
    dst_gi_nahida_weapon_thunder = {
        fn = function(target, ...)
            if target.components.dst_gi_nahida_elemental_reaction then
                target.components.dst_gi_nahida_elemental_reaction:ThunderAttack(...)
            end
        end
    },
    dst_gi_nahida_weapon_wind = {
        fn = function(target, ...)
            if target.components.dst_gi_nahida_elemental_reaction then
                target.components.dst_gi_nahida_elemental_reaction:WindAttack(...)
            end
        end
    },
    dst_gi_nahida_weapon_staff = {
        fn = function(target, ...)
            if target.components.dst_gi_nahida_elemental_reaction then
                target.components.dst_gi_nahida_elemental_reaction:GrassAttack(...)
            end
        end
    },
}

-- 8分钟为一天
TUNING.ONE_DAY_TIME = 480

TUNING.DST_GI_NAHIDA_WEAPONS_BUILD_TAG = "dst_gi_nahida_weapons"

TUNING.NAHIDA_FOODS_CRIT_ITEM = {
    dst_gi_nahida_date_sweet = "dst_gi_nahida_halvamazd"
}

TUNING.CHESSPIECE_ARRAY = {
    -- 独眼巨鹿雕塑 - deerclops 独眼巨鹿
    chesspiece_deerclops = "deerclops",
    -- 熊獾雕塑 - bearger 熊獾
    chesspiece_bearger = "bearger",
    -- 麋鹿鹅雕塑 - moose 麋鹿鹅
    chesspiece_moosegoose = "moose",
    -- 龙蝇雕塑 - dragonfly 龙蝇
    chesspiece_dragonfly = "dragonfly",
    -- 远古守护者雕塑 - minotaur 远古守护者
    chesspiece_minotaur = "minotaur",
    -- 毒菌蟾蜍雕塑 - toadstool 毒菌蟾蜍
    chesspiece_toadstool = "toadstool",
    -- 蜂王雕塑 - beequeen 蜂王
    chesspiece_beequeen = "beequeen",
    -- 蚁狮雕塑 - antlion 蚁狮
    chesspiece_antlion = "antlion",
    -- 邪天翁雕塑 - malbatross 邪天翁
    chesspiece_malbatross = "malbatross",
    -- 梦魇疯猪雕塑 - daywalker 梦魇疯猪
    chesspiece_daywalker = "daywalker",
    -- 附身座狼雕塑 - warg 座狼
    chesspiece_warg_mutated = "warg",
}

TUNING.OVERSIZED_PICKLIST = { --巨型作物列表
    "asparagus_oversized",
    "garlic_oversized",
    "pumpkin_oversized",
    "corn_oversized",
    "onion_oversized",
    "potato_oversized",
    "dragonfruit_oversized",
    "pomegranate_oversized",
    "eggplant_oversized",
    "tomato_oversized",
    "watermelon_oversized",
    "pepper_oversized",
    "durian_oversized",
    "carrot_oversized",
    "immortal_fruit_oversized",
    "medal_gift_fruit_oversized",
}
