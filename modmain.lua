---@diagnostic disable: lowercase-global, undefined-global, trailing-space

GLOBAL.setmetatable(env, { __index = function(t, k)
    return GLOBAL.rawget(GLOBAL, k)
end })

---- 修复loadstring
--local env = {
--    loadstring = GLOBAL.loadstring
--    --[[  loadstring = function(...)
--        return function()
--            print("somemode are loadstring,and execute it , please fix me!")
--        end
--    end ]]
--}
--function GLOBAL.RunInSandbox(untrusted_code)
--    if untrusted_code:byte(1) == 27 then return nil, "binary bytecode prohibited" end
--    local untrusted_function, message = loadstring(untrusted_code)
--    if not untrusted_function then return nil, message end
--    return RunInEnvironment(untrusted_function, env)
--end

---@type string
local modid = 'dst_gi_nahida' -- 定义唯一modid

---@type LAN_TOOL_COORDS
COORDS_dst_gi_nahida = require('core_' .. modid .. '/utils/coords')
---@type LAN_TOOL_SUGARS
SUGAR_dst_gi_nahida = require('core_' .. modid .. '/utils/sugar')
GetPrefab = require("dst_gi_nahida_utils/getprefab")
Utils = require("dst_gi_nahida_utils/utils")
Shapes = require("dst_gi_nahida_utils/shapes")

rawset(GLOBAL, 'COORDS_dst_gi_nahida', COORDS_dst_gi_nahida)
rawset(GLOBAL, 'SUGAR_dst_gi_nahida', SUGAR_dst_gi_nahida)
rawset(GLOBAL, 'GetPrefab', GetPrefab)
rawset(GLOBAL, 'Utils', Utils)
rawset(GLOBAL, 'Shapes', Shapes)


PrefabFiles = {
    'dst_gi_nahida_thousand_floating_dreams', -- 千叶浮梦
    'dst_gi_nahida_books', -- 纳西妲的书
    'dst_gi_nahida_fateseat', -- 纳西妲的命座
    'fx_dst_gi_nahida_normal_attack',
    'fx_dst_gi_nahida_four_leaf_clover', -- 四叶草特效
    'fx_dst_gi_nahida_illusory_heart_fx', -- 大招地板上的圆特效
    'fx_dst_gi_nahida_wormwood_plant', -- 纳西妲植物人开花效果
    'fx_dst_gi_nahida_weapon_staff', -- 武器拖尾特效
    'dst_gi_nahida_element_spearfx', -- 元素标记特效
    'dst_gi_nahida_module_buffs', -- buff 蕴种印之类的
    'dst_gi_nahida_equipment', -- 纳西妲的装备
    'dst_gi_nahida_tips', -- tips
    'dst_gi_nahida_chest', -- 纳西妲的箱子
    'dst_gi_nahida_coconut', -- 枣椰
    'dst_gi_nahida_coconut_bush', -- 枣椰树
    'dst_gi_nahida_foods', -- 纳西妲的食物
    'dst_gi_nahida_module_dishes', -- 料理
    'dst_gi_nahida_ice_box', -- 冰箱
    'dst_gi_nahida_everfrost_ice_crystal', -- 极寒之核
    'dst_gi_nahida_birthday_gift_box', -- 纳西妲的生日礼盒
    'dst_gi_nahida_dendro_core', -- 草原核
    'dst_gi_nahida_item', -- 通用物品
    'dst_gi_nahida_gacha_machine', -- 抽卡机
    'dst_gi_nahida_beef_bell', -- 纳西妲的牛铃
    'dst_gi_nahida_toy_desk', -- 小玩具制作站
    'dst_gi_nahida_windsong_lyre', -- 风物之诗琴
    'dst_gi_nahida_music_score', -- 琴谱
    'dst_gi_nahida_melee_weapons', -- 武器
    'fx_nahida_weapon_light', -- 武器光源
    'dst_gi_nahida_lifepen', -- 强化强心针
    'brilliance_projectile_fx', -- 🔥 添加亮茄魔杖弹幕特效
    'dst_gi_nahida_brilliance_projectile_fx', -- 🔥 添加亮茄魔杖弹幕特效
    'dst_gi_nahida_teleport_waypoint', -- 🔥 传送锚点
    'fx_dst_gi_nahida_magic_circles', -- 🔥 魔法阵
    'dst_gi_nahida_wave', -- 🔥 浪花
    'dst_gi_nahida_transplantation_item', -- 🔥 可移植物品
    'fx_dst_gi_nahida_round', -- 🔥 圆
    'dst_gi_nahida_shadowmeteor', -- 🔥 陨石
    'dst_gi_nahida_sporecloud', -- 🔥 孢子云
    'dst_gi_nahida_shipwrecked_boat', -- 🔥 船
    'dst_gi_nahida_sunkenchest_item', -- 🔥 打捞的沉底宝箱
    -------------------------------------------------------
    'dst_gi_nahida_character_card', -- 🔥 技能卡
    'dst_gi_nahida_kq_burst_fx', -- 🔥 刻晴技能
    -------------------------------------------------------
}

---@type asset[]
Assets = {
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida.xml"), --头像
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida.tex"),
    Asset("ATLAS", "images/fx/weapon_trail.xml"), --武器拖尾特效
    Asset("IMAGE", "images/fx/weapon_trail.tex"), -- 武器拖尾特效
    Asset("ANIM", "anim/dst_gi_nahida_skill.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_none1.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_none2.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_furina.zip"), -- 芙宁娜皮肤
    Asset("ANIM", "anim/dst_gi_nahida_furina_none1.zip"), -- 芙宁娜皮肤
    Asset("ANIM", "anim/dst_gi_nahida_barbara.zip"), -- 芭芭拉皮肤
    Asset("ANIM", "anim/dst_gi_nahida_playguitar.zip"), -- 演奏动作
    Asset("ANIM", "anim/dst_gi_nahida_illusory_heart.zip"), -- 大招动画+动作
    --Asset("ANIM", "anim/dst_gi_nahida_attack.zip"), -- 普攻动画+动作
    Asset("ANIM", "anim/dst_gi_nahida_attack_v2.zip"), -- 普攻动画+动作
    Asset("ATLAS", "images/inventoryimages/medal_weed_seeds.xml"),
    Asset("ATLAS", "images/inventoryimages/mandrakeberry.xml"),
    Asset("ATLAS", "images/inventoryimages/immortal_fruit_seed.xml"),
    Asset("ATLAS", "images/inventoryimages/medal_gift_fruit_seed.xml"),
    Asset("ATLAS", "images/inventoryimages/blueprint.xml"),
    Asset("ATLAS", "images/map_icons/dst_gi_nahida_ice_box.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/map_icons/dst_gi_nahida_ice_box.tex"),
    Asset("ATLAS", "images/map_icons/dst_gi_nahida_coconut_tree.xml"), -- 椰子树物品栏贴图
    Asset("IMAGE", "images/map_icons/dst_gi_nahida_coconut_tree.tex"), -- 椰子树物品栏图像
    Asset("ATLAS", "images/map_icons/dst_gi_nahida_treasure_chest.xml"), -- 椰子树物品栏贴图
    Asset("IMAGE", "images/map_icons/dst_gi_nahida_treasure_chest.tex"), -- 椰子树物品栏图像
    Asset("ATLAS", "images/map_icons/dst_gi_nahida_toy_chest.xml"), -- 玩具箱物品栏贴图
    Asset("IMAGE", "images/map_icons/dst_gi_nahida_toy_chest.tex"), -- 玩具箱物品栏图像
    Asset("ATLAS", "images/map_icons/dst_gi_nahida_gacha_machine.xml"), -- 抽卡机
    Asset("IMAGE", "images/map_icons/dst_gi_nahida_gacha_machine.tex"), -- 抽卡机
    Asset("IMAGE", "images/map_icons/dst_gi_nahida_shipwrecked_boat.tex"),
    Asset("ATLAS", "images/map_icons/dst_gi_nahida_shipwrecked_boat.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_save_spore_slot.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_save_spore_slot.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_del_spore_slot.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_del_spore_slot.xml"),

    Asset("SOUNDPACKAGE","sound/nahida_attack_1_sound.fev"),
    Asset("SOUND","sound/nahida_attack_1_sound.fsb"),
    Asset("SOUNDPACKAGE","sound/nahida_attack_2_sound.fev"),
    Asset("SOUND","sound/nahida_attack_2_sound.fsb"),
    Asset("SOUNDPACKAGE","sound/nahida_attack_3_sound.fev"),
    Asset("SOUND","sound/nahida_attack_3_sound.fsb"),
    Asset("SOUNDPACKAGE","sound/nahida_attack_4_sound.fev"),
    Asset("SOUND","sound/nahida_attack_4_sound.fsb"),
    Asset("SOUNDPACKAGE","sound/nahida_skill.fev"),
    Asset("SOUND","sound/nahida_skill_sound.fsb"),

    Asset("SOUNDPACKAGE","sound/nahida_music_sound.fev"),
    Asset("SOUND","sound/nahida_music_sound.fsb"),
    --------------------------------------------------------------------------------------
    ---Melody of Young Leaves 幼叶绽生的曲调  melody_of_young_leaves
    ---Melody of Sprouting Flowers 颠倒梦想的曲调 melody_of_sprouting_flowers
    ---Melody of Hidden Seeds 生命之谷的曲调 melody_of_hidden_seeds
    ---Melody of Fresh Dewdrops 晨曦初露的曲调 melody_of_fresh_dewdrops
    ---Melody of Dream Home 染绿乡园的曲调 melody_of_dream_home
    ---Melody of Distant Green Fields 绿野纤绵的曲调  melody_of_distant_green_fields
    ---Melody of Bright New Buds 沃土新芽的曲调 melody_of_bright_new_buds
    --------------------------------------------------------------------------------------
    --------------------------------角色------------------------------------------------------
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_keqing_burst_card.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_keqing_burst_card.xml"),
    --------------------------------------------------------------------------------------
    -----------------------------------联动技能资源动画---------------------------------------------------
    Asset("ANIM", "anim/kq_burst_fx.zip"),
    --------------------------------------------------------------------------------------
    -----------------------------------传送锚点资源包---------------------------------------------------
    -- 动画
    Asset("ANIM", "anim/teleport_waypoint.zip"),
    -- 物品栏图片
    Asset("IMAGE", "images/inventoryimages/teleport_waypoint.tex"),
    Asset("ATLAS", "images/inventoryimages/teleport_waypoint.xml"),
    -- UI图片
    Asset("IMAGE", "images/ui/button_talentupgrade_confirm.tex"),
    Asset("ATLAS", "images/ui/button_talentupgrade_confirm.xml"),
    Asset("IMAGE", "images/ui/teleport_waypoint_button.tex"),
    Asset("ATLAS", "images/ui/teleport_waypoint_button.xml"),
    Asset("IMAGE", "images/ui/teleport_loc_bg.tex"),
    Asset("ATLAS", "images/ui/teleport_loc_bg.xml"),
    Asset("IMAGE", "images/ui/teleport_bg.tex"),
    Asset("ATLAS", "images/ui/teleport_bg.xml"),
    Asset("IMAGE", "images/ui/tp_select_ring.tex"),
    Asset("ATLAS", "images/ui/tp_select_ring.xml"),
    Asset("IMAGE", "images/ui/default_genshin_button.tex"),
    Asset("ATLAS", "images/ui/default_genshin_button.xml"),
    Asset("IMAGE", "images/ui/icon_genshin_button.tex"),
    Asset("ATLAS", "images/ui/icon_genshin_button.xml"),
    Asset("IMAGE", "images/ui/noicon_genshin_button.tex"),
    Asset("ATLAS", "images/ui/noicon_genshin_button.xml"),
    Asset("IMAGE", "images/ui/skill_button.tex"),
    Asset("ATLAS", "images/ui/skill_button.xml"),
    Asset("IMAGE", "images/ui/dst_gi_nahida_fateseat_btn.tex"),
    Asset("ATLAS", "images/ui/dst_gi_nahida_fateseat_btn.xml"),
    Asset("IMAGE", "images/ui/button2.tex"),
    Asset("ATLAS", "images/ui/button2.xml"),
    Asset("IMAGE", "images/ui/dst_gi_nahida_sync_tp.tex"),
    Asset("ATLAS", "images/ui/dst_gi_nahida_sync_tp.xml"),
    Asset("IMAGE", "images/ui/dst_gi_nahida_button.tex"),
    Asset("ATLAS", "images/ui/dst_gi_nahida_button.xml"),
    Asset("IMAGE", "images/ui/dst_gi_nahida_small_button.tex"),
    Asset("ATLAS", "images/ui/dst_gi_nahida_small_button.xml"),
    Asset("IMAGE", "images/ui/teleport_waypoint.tex"),
    Asset("ATLAS", "images/ui/teleport_waypoint.xml"),
    Asset("IMAGE", "images/ui/dst_gi_character_ui.tex"),
    Asset("ATLAS", "images/ui/dst_gi_character_ui.xml"),
    Asset("IMAGE", "images/ui/dst_gi_nahida_character_card_panel.tex"),
    Asset("ATLAS", "images/ui/dst_gi_nahida_character_card_panel.xml"),
    Asset("IMAGE", "images/ui/dst_gi_nahida_character_bg.tex"),
    Asset("ATLAS", "images/ui/dst_gi_nahida_character_bg.xml"),
    Asset("IMAGE", "images/ui/dst_nahida_setting_icon.tex"),
    Asset("ATLAS", "images/ui/dst_nahida_setting_icon.xml")
}

-- 导入mod配置
for _, v in ipairs({
    '_lang', -- 语言设置
    '_harvest_growth_mode', -- 收获成长模式
    '_skill', -- 元素战技快捷键
    '_skill_burst', -- 元素爆发快捷键
    '_actions_ability_enable', -- 技能书快捷键
    '_right_click_actions_enable', -- 右键动作开启关闭快捷键
    '_enable_shadowprotector', -- 暗影角斗士开关
    '_growth_value_limit', -- 成长值限制
    '_toy_made_max_count', -- 小玩具每天制作最大值
    '_teleport_enable', -- 传送锚点配方
    '_teleport_hunger_cost', -- 传送饱食度消耗
    '_teleport_sanity_cost', -- 传送精神值消耗
    '_dst_gi_nahida_weapon_staff_ejection', -- 纳西妲的法杖，弹射上限
    '_constellation_6_health_bonus', -- 6命生命附加
    '_fateseat_presented_enable', -- 开启赠送命座
    '_fateseat_presented_number', -- 间隔天数
    '_constellation_master_switch', -- 命座总开关
    '_constellation_unknown_recipes', -- 未学习图纸命座效果
    '_constellation_seed_recipes', -- 种子配方命座效果
    '_evergreen_right_click', -- 右键松树
    '_boss_right_click_master', -- Boss右键总开关
    '_boss_dragonfly', -- Boss右键-龙蝇
    '_boss_bearger', -- Boss右键-熊獾
    '_boss_moose_goose', -- Boss右键-麋鹿鹅
    '_boss_malbatross', -- Boss右键-邪天翁
    '_boss_bee_queen', -- Boss右键-蜂王巢
    '_boss_ancient_guardian', -- Boss右键-远古守护者
    '_statue_right_click_master', -- 雕像右键总开关
    '_statue_dragonfly', -- 雕像右键-龙蝇
    '_statue_bearger', -- 雕像右键-熊獾
    '_statue_moose_goose', -- 雕像右键-麋鹿鹅
    '_statue_malbatross', -- 雕像右键-邪天翁
    '_statue_bee_queen', -- 雕像右键-蜂王
    '_statue_ancient_guardian', -- 雕像右键-远古守护者
    '_statue_toadstool', -- 雕像右键-毒菌蟾蜍
    '_statue_deerclops', -- 雕像右键-独眼巨鹿
    '_statue_antlion', -- 雕像右键-蚁狮
    '_statue_nightmare_werepig', -- 雕像右键-梦魇疯猪
    '_statue_hound', -- 雕像右键-座狼
    '_creature_voltgoat', -- 生物右键-伏特羊
    '_creature_beehive', -- 生物右键-蜂巢
    '_creature_wasphive', -- 生物右键-杀人蜂巢
    '_creature_monkey', -- 生物右键-洞穴猴
    '_creature_fish', -- 生物右键-鱼类抚摸
    '_creature_beefalo', -- 生物右键-皮弗娄牛
    '_creature_walrus_camp', -- 生物右键-海象营地
    '_toy_recipe_enable', -- 小玩具配方开关
    '_toy_exchange_permission', -- 小玩具兑换权限
    '_gacha_recipe_enable', -- 抽卡机配方开关
    '_skill_bar_permission', -- 角色技能栏权限
    '_freeze_reaction_enable', -- 冻结反应开关
    '_vaporize_rate', -- 蒸发反应倍率
    '_freeze_rate', -- 冻结反应倍率
    '_electro_charged_rate', -- 感电反应倍率
    '_bloom_rate', -- 绽放反应倍率
    '_burning_rate', -- 燃烧反应倍率
    '_melt_rate', -- 融化反应倍率
    '_quicken_rate', -- 激化反应倍率
    '_overload_rate', -- 超载反应倍率
    '_superconduct_rate', -- 超导反应倍率
    '_swirl_rate', -- 扩散反应倍率
    '_crystallize_rate', -- 结晶反应倍率
    '_overgrow_rate', -- 蔓激化反应倍率
    '_hyperbloom_rate', -- 超激化反应倍率
    '_overload_boom_rate', -- 超载范围爆炸倍率
    '_shatter_rate', -- 物理碎冰倍率
    '_rock_shatter_rate', -- 岩元素碎冰倍率
    '_enable_slot_bg', -- 容器格子UI开关
    '_flower_cave_enable', -- 荧光花移植
    '_reeds_enable', -- 芦苇移植
    '_dst_gi_nahida_lifepen_num', -- 强心针使用次数
    '_light_emitting', -- 常驻发光配置
    '_freeze_weapon_enable', -- 元素武器技能
    '_weapon_fire_cd', -- 元素武器-火 cd
    '_weapon_grass_cd', -- 元素武器-草 cd
    '_weapon_ice_cd', -- 元素武器-冰 cd
    '_weapon_rock_cd', -- 元素武器-岩 cd
    '_weapon_thunder_cd', -- 元素武器-雷 cd
    '_weapon_water_cd', -- 元素武器-水 cd
    '_weapon_wind_cd', -- 元素武器-风 cd
    '_boat_enable', -- 船配方
    '_boat_builder', -- 船制作权限
}) do
    TUNING[string.upper('CONFIG_' .. modid .. v)] = GetModConfigData(modid .. v)
end

TUNING.MOD_DST_GI_NAHIDA_CONFIG = function(config_suffix)
    return TUNING[string.upper('CONFIG_' .. modid .. config_suffix)]
end

-- 导入常量表
modimport('scripts/core_' .. modid .. '/data/tuning.lua')

-- 判断某个mod有没有开启
modimport('scripts/core_' .. modid .. '/managers/is_mod_enabled.lua') -- 功能(无需修改): 判断某个mod有没有开启 的前置

-- 导入全局函数
modimport('scripts/core_' .. modid .. '/data/nahida_globalfn.lua')

-- 导入工具
modimport('scripts/core_' .. modid .. '/utils/_register.lua')

-- 导入功能API
modimport('scripts/core_' .. modid .. '/api/_register.lua')

-- 导入语言文件
modimport('scripts/core_' .. modid .. '/languages/' .. TUNING[string.upper('CONFIG_' .. modid .. '_LANG')] .. '.lua')

-- 导入人物
modimport('scripts/data_avatar/data_avatar_dst_gi_nahida.lua')

-- 导入调用器
modimport('scripts/core_' .. modid .. '/callers/caller_attackperiod.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_badge.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_ca.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_changeactionsg.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_container.lua')
modimport('scripts/core_' .. modid .. '/callers/caller_dish.lua')
modimport('scripts/core_' .. modid .. '/callers/caller_keyhandler.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_onlyusedby.lua')
modimport('scripts/core_' .. modid .. '/callers/caller_recipes.lua')
-- modimport('scripts/core_'..modid..'/callers/caller_stack.lua')

-- 导入抽卡池常量
modimport('scripts/core_' .. modid .. '/data/nahida_card_pool.lua')
modimport('scripts/core_' .. modid .. '/genshin_character_kill/genshin_character_tuning.lua')

-- 导入零散功能模块 (自用 可以无视)
-- modimport('scripts/core_'..modid..'/managers/atk_speed_from_alt.lua') -- 功能(无需修改): alt写的修改攻速模块
-- modimport('scripts/core_'..modid..'/managers/bugfix_aoetargeting.lua') -- 当你使用官方组件来写技能时,貌似会因为没有正确移除 reticule 组件,导致玩家的轮盘施法放不出来,本文件就是用来修复这个bug的
-- modimport('scripts/core_'..modid..'/managers/bugfix_souljump.lua') -- 当你使用官方组件来写武器技能时, 会导致和 小恶魔的灵魂跳跃 冲突, 具体我忘了, 总之这个文件就是用来修复这个bug的
-- modimport('scripts/core_'..modid..'/managers/build_data_transfer.lua') -- 功能(需要填写): 制作物品过程涉及数据传输
-- modimport('scripts/core_'..modid..'/managers/cantequip_whennodurability.lua') -- 功能(无需修改): 本文件用来管理,装备耐久用尽时的逻辑
-- modimport('scripts/core_'..modid..'/managers/cd_in_itemtile.lua') -- 功能(无需修改): 在物品栏以数字形式显示的cd
-- modimport('scripts/core_'..modid..'/managers/dmg_sys.lua') -- 管理: 用这个文件管理伤害处理吧
-- modimport('scripts/core_'..modid..'/managers/event_hook.lua') -- 功能(需要填写): 勾 event
-- modimport('scripts/core_'..modid..'/managers/invincible.lua') -- 功能(无需修改): 设置无敌的
-- modimport('scripts/core_'..modid..'/managers/last_atk_weapon.lua') -- 功能(无需修改): 获取攻击者上次使用的武器
-- modimport('scripts/core_'..modid..'/managers/participate_kill.lua') -- 功能(无需修改): 联合击杀(参与击杀), 判断生物死亡时, 某个玩家有没有贡献伤害(参与战斗)
-- modimport('scripts/core_'..modid..'/managers/quick_announce.lua') -- 功能(需要填写): alt + 左键点击库存物品宣告
-- modimport('scripts/core_'..modid..'/managers/sort_recipes.lua') -- 功能(需要填写): 给配方排序

-- 导入纳西妲备份系统
--modimport('scripts/core_' .. modid .. '/managers/dst_gi_nahida_backup_system')

-- 导入UI
modimport('scripts/core_' .. modid .. '/callers/caller_ui.lua')

-- 声明RPC组件
AddReplicableComponent("dst_gi_nahida_skill")
AddReplicableComponent("dst_gi_nahida_character_window_data")
-- 暂时无法跨世界
AddReplicableComponent("dst_gi_nahida_registered_waypoint")
for _, v in ipairs({ "forest_network", "cave_network", "shipwrecked_network", "volcanoworld_network", "porkland_network"}) do
    AddPrefabPostInit(v, function(inst)
        print("给世界添加组件...")
        if not TheWorld.ismastersim then
            print("给世界添加组件，没有ismastersim...")
            return inst;
        end
        if inst.components.dst_gi_nahida_registered_waypoint == nil then
            print("给世界添加组件，dst_gi_nahida_registered_waypoint...")
            inst:AddComponent("dst_gi_nahida_registered_waypoint");
        end
        inst:DoPeriodicTask(60,function()
            TUNING.MOD_DST_GI_NAHIDA_REGISTERED_WAYPOINT = {}
        end)
    end)
end
-- 注册客机组件

-- 导入钩子 It's my勾
---@type string[]
local files_hook = {
    "dst_gi_nahida_moretags",
    "player_hooks",
    "animal_hooks",
    "combat_hooks",
    "actions",
    "cooking_hooks",
    "nahida_wilson_sg_hooks",
    "fish_hooks",
    "dst_gi_nahida_cooking",
    "dst_gi_nahida_windsong_lyre_hooks",
    "builder_hooks",
    "farmtiller_hooks",
    "medal_hooks",
    "modrpc",
    "mapscreen_hooks",
    "other_player_hooks",
    "sunkenchest_hooks",
    "rocks_hooks",
    "boat_hooks",
    --"nahida_spellbook_hooks",
}
for _, v in ipairs(files_hook) do
    modimport('scripts/core_' .. modid .. '/hooks/' .. v .. '.lua')
end

-- widgets
---@type string[]
local files_widgets = {
    "dst_gi_nahida_containers_widgetcreation"
}
for _, v in ipairs(files_widgets) do
    modimport('scripts/core_' .. modid .. '/widgets/' .. v .. '.lua')
end

-- SG
---@type string[]
local sgArray = {
    "SGDstGiNahidaDendroCore",
    "SGDstGiNahidaGachaMachine",
    "SGDstGiNahidaTornado",
}
for _, v in ipairs(sgArray) do
    modimport('scripts/stategraphs/' .. v .. '.lua')
end