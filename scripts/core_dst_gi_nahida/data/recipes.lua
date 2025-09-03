---@diagnostic disable: lowercase-global, undefined-global, trailing-space

---@type data_recipe[]
---
local RECIPES = {
    {
        enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BOAT_ENABLE,
        recipe_name = "dst_gi_nahida_shipwrecked_boat_item", -- 船
        ingredients = { { name = "boards", amount = 4 } },
        tech = TECH.SEAFARING_ONE,
        config = {
            atlas = "images/inventoryimages/dst_gi_nahida_shipwrecked_boat_item.xml",
            image = "dst_gi_nahida_shipwrecked_boat_item.tex",
            builder_tag = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BOAT_BUILDER,
        },
        filters = { 'CHARACTER', "DST_GI_NAHIDA", "SEAFARING" }
    },
    {
        enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BOAT_ENABLE,
        recipe_name = "dst_gi_nahida_shipwrecked_boat2_item", -- 船
        ingredients = { { name = "boards", amount = 6 },{ name = "cutstone", amount = 1 },{ name = "rope", amount = 2 } },
        tech = TECH.LOST,
        config = {
            atlas = "images/inventoryimages/dst_gi_nahida_shipwrecked_boat2.xml",
            image = "dst_gi_nahida_shipwrecked_boat2.tex",
        },
        filters = { 'CHARACTER', "DST_GI_NAHIDA" , "SEAFARING" }
    },
    {
        enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BOAT_ENABLE,
        recipe_name = "hermitshop_dst_gi_nahida_shipwrecked_boat2_item_blueprint", -- 蓝图
        ingredients = { { name = "messagebottleempty", amount = 1 } },
        tech = TECH.HERMITCRABSHOP_ONE,
        config = {
            nounlock = true,
            sg_state="give",
            product="dst_gi_nahida_shipwrecked_boat2_item_blueprint",
            atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex",
            builder_tag = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BOAT_BUILDER,
        },
        filters = {}
    },
    {
        enable = (not TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.SHIPWRECKED) and TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.TELEPORT_ENABLE,
        recipe_name = "dst_gi_nahida_teleport_waypoint", -- 传送锚点
        ingredients = { { name = "boards", amount = 1 }, { name = "goldnugget", amount = 1 }, { name = "rocks", amount = 1 } },
        tech = TECH.SCIENCE_ONE,
        config = { atlas = "images/inventoryimages/teleport_waypoint.xml", image = "teleport_waypoint.tex",
                   placer = "dst_gi_nahida_teleport_waypoint_placer",
                   min_spacing = 1
        },
        filters = { 'CHARACTER', "DST_GI_NAHIDA" }
    },
    {
        enable = TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.SHIPWRECKED and TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.TELEPORT_ENABLE,
        recipe_name = "dst_gi_nahida_teleport_waypoint", -- 传送锚点
        ingredients = { { name = "boards", amount = 1 } },
        tech = TECH.SCIENCE_ONE,
        config = { atlas = "images/inventoryimages/teleport_waypoint.xml", image = "teleport_waypoint.tex",
                   placer = "dst_gi_nahida_teleport_waypoint_placer",
                   min_spacing = 1
        },
        filters = { 'CHARACTER', "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_tool_knife",
        ingredients = { { name = "twigs", amount = 1 }, { name = "goldnugget", amount = 1 }, { name = "rocks", amount = 1 } },
        tech = TECH.SCIENCE_TWO,
        config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/dst_gi_nahida_tool_knife.xml", image = "dst_gi_nahida_tool_knife.tex" },
        filters = { 'CHARACTER', "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_weapon_staff",
        ingredients = { { name = "spear", amount = 1 }, { name = "goldnugget", amount = 20 }, { name = "thulecite", amount = 3 } }, -- spear 长矛 thulecite 铥矿
        tech = TECH.SCIENCE_TWO,
        ingredientmod = 1,
        config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/dst_gi_nahida_weapon_staff.xml", image = "dst_gi_nahida_weapon_staff.tex" },
        filters = { 'CHARACTER', "WEAPONS", "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_lifepen",
        ingredients = { { name = "reviver", amount = 1 }, { name = "spoiled_food", amount = 8 }, { name = "nitre", amount = 2 }, { name = "stinger", amount = 1 } },
        tech = TECH.SCIENCE_TWO,
        config = { atlas = "images/inventoryimages/dst_gi_nahida_lifepen.xml", image = "dst_gi_nahida_lifepen.tex" },
        filters = { 'CHARACTER', "RESTORATION", "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_beef_bell",
        ingredients = { { name = "goldnugget", amount = 6 }, { name = "flint", amount = 1 }, { name = "opalpreciousgem", amount = 1 } },
        tech = TECH.MAGIC_THREE,
        config = { atlas = "images/inventoryimages/dst_gi_nahida_beef_bell.xml", image = "dst_gi_nahida_beef_bell.tex" },
        filters = { 'CHARACTER', 'TOOLS', 'RIDING', "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_beef_bell2",
        ingredients = { { name = "goldnugget", amount = 6 }, { name = "flint", amount = 1 }, { name = "opalpreciousgem", amount = 1 } },
        tech = TECH.MAGIC_THREE,
        config = { atlas = "images/inventoryimages/dst_gi_nahida_beef_bell2.xml", image = "dst_gi_nahida_beef_bell2.tex" },
        filters = { 'CHARACTER', 'TOOLS', 'RIDING', "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_beef_bell3",
        ingredients = { { name = "goldnugget", amount = 6 }, { name = "flint", amount = 1 }, { name = "opalpreciousgem", amount = 1 } },
        tech = TECH.MAGIC_THREE,
        config = { atlas = "images/inventoryimages/dst_gi_nahida_beef_bell3.xml", image = "dst_gi_nahida_beef_bell3.tex" },
        filters = { 'CHARACTER', 'TOOLS', 'RIDING', "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_weapon_fire",
        ingredients = { { name = "goldnugget", amount = 10 }, { name = "log", amount = 1 }, { name = "rocks", amount = 10 } },
        tech = TECH.SCIENCE_TWO,
        config = { atlas = "images/inventoryimages/dst_gi_nahida_weapon_fire.xml", image = "dst_gi_nahida_weapon_fire.tex" },
        filters = { 'CHARACTER', "WEAPONS", "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_splendor_of_tranquil_waters",
        ingredients = { { name = "goldnugget", amount = 10 }, { name = "log", amount = 1 }, { name = "rocks", amount = 10 } },
        tech = TECH.SCIENCE_TWO,
        config = { atlas = "images/inventoryimages/dst_gi_nahida_splendor_of_tranquil_waters.xml", image = "dst_gi_nahida_splendor_of_tranquil_waters.tex" },
        filters = { 'CHARACTER', "WEAPONS", "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_weapon_water",
        ingredients = { { name = "goldnugget", amount = 10 }, { name = "log", amount = 1 }, { name = "rocks", amount = 10 } },
        tech = TECH.SCIENCE_TWO,
        config = { atlas = "images/inventoryimages/dst_gi_nahida_weapon_water.xml", image = "dst_gi_nahida_weapon_water.tex" },
        filters = { 'CHARACTER', "WEAPONS", "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_weapon_grass",
        ingredients = { { name = "goldnugget", amount = 10 }, { name = "log", amount = 1 }, { name = "rocks", amount = 10 } },
        tech = TECH.SCIENCE_TWO,
        config = { atlas = "images/inventoryimages/dst_gi_nahida_weapon_grass.xml", image = "dst_gi_nahida_weapon_grass.tex" },
        filters = { 'CHARACTER', "WEAPONS", "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_weapon_ice",
        ingredients = { { name = "goldnugget", amount = 10 }, { name = "log", amount = 1 }, { name = "rocks", amount = 10 } },
        tech = TECH.SCIENCE_TWO,
        config = { atlas = "images/inventoryimages/dst_gi_nahida_weapon_ice.xml", image = "dst_gi_nahida_weapon_ice.tex" },
        filters = { 'CHARACTER', "WEAPONS", "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_weapon_rock",
        ingredients = { { name = "goldnugget", amount = 10 }, { name = "log", amount = 1 }, { name = "rocks", amount = 10 } },
        tech = TECH.SCIENCE_TWO,
        config = { atlas = "images/inventoryimages/dst_gi_nahida_weapon_rock.xml", image = "dst_gi_nahida_weapon_rock.tex" },
        filters = { 'CHARACTER', "WEAPONS", "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_weapon_thunder",
        ingredients = { { name = "goldnugget", amount = 10 }, { name = "log", amount = 1 }, { name = "rocks", amount = 10 } },
        tech = TECH.SCIENCE_TWO,
        config = { atlas = "images/inventoryimages/dst_gi_nahida_weapon_thunder.xml", image = "dst_gi_nahida_weapon_thunder.tex" },
        filters = { 'CHARACTER', "WEAPONS", "DST_GI_NAHIDA" }
    },
    {
        recipe_name = "dst_gi_nahida_weapon_wind",
        ingredients = { { name = "goldnugget", amount = 10 }, { name = "log", amount = 1 }, { name = "rocks", amount = 10 } },
        tech = TECH.SCIENCE_TWO,
        config = { atlas = "images/inventoryimages/dst_gi_nahida_weapon_wind.xml", image = "dst_gi_nahida_weapon_wind.tex" },
        filters = { 'CHARACTER', "WEAPONS", "DST_GI_NAHIDA" }
    },
    {
        enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.TOY_RECIPE_ENABLE,
        recipe_name = "dst_gi_nahida_toy_desk", -- 小玩具制作站
        ingredients = {
            { name = "goldnugget", amount = 10 }, -- 金子
            { name = "transistor", amount = 4 }, -- 电子元件
            { name = "boards", amount = 10 }, -- 木板
            { name = "gears", amount = 1 }, -- 齿轮
        },
        tech = TECH.SCIENCE_TWO,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_toy_desk.xml",
            image = "dst_gi_nahida_toy_desk.tex",
            placer = "dst_gi_nahida_toy_desk_placer",
            min_spacing = 1
        },
        filters = {
            'CHARACTER', "REFINE", "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_windsong_lyre", -- 风物之诗琴
        fateseat_level = 1,
        ingredients = {
            { name = "silk", amount = 10 }, -- 蜘蛛丝
            { name = "log", amount = 10 }, -- 木头
        },
        tech = TECH.NONE,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_windsong_lyre.xml",
            image = "dst_gi_nahida_windsong_lyre.tex",
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_melody_of_the_great_dream", -- 大梦的曲调
        fateseat_level = 1,
        ingredients = {
            { name = "papyrus", amount = 1 }, -- 莎草纸
            { name = "featherpencil", amount = 1 }, -- 羽毛笔
        },
        tech = TECH.NONE,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_melody_of_the_great_dream.xml",
            image = "dst_gi_nahida_melody_of_the_great_dream.tex",
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_huanmo_chant", -- 桓摩的曲调
        fateseat_level = 1,
        ingredients = {
            { name = "papyrus", amount = 1 }, -- 莎草纸
            { name = "featherpencil", amount = 1 }, -- 羽毛笔
        },
        tech = TECH.NONE,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_huanmo_chant.xml",
            image = "dst_gi_nahida_huanmo_chant.tex",
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_path_of_shadows_tune", -- 黯道的曲调
        fateseat_level = 1,
        ingredients = {
            { name = "papyrus", amount = 1 }, -- 莎草纸
            { name = "featherpencil", amount = 1 }, -- 羽毛笔
        },
        tech = TECH.NONE,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_path_of_shadows_tune.xml",
            image = "dst_gi_nahida_path_of_shadows_tune.tex",
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_beast_trail_melody", -- 兽径的曲调
        fateseat_level = 1,
        ingredients = {
            { name = "papyrus", amount = 1 }, -- 莎草纸
            { name = "featherpencil", amount = 1 }, -- 羽毛笔
        },
        tech = TECH.NONE,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_beast_trail_melody.xml",
            image = "dst_gi_nahida_beast_trail_melody.tex",
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_sprout_song", -- 新芽的曲调
        fateseat_level = 1,
        ingredients = {
            { name = "papyrus", amount = 1 }, -- 莎草纸
            { name = "featherpencil", amount = 1 }, -- 羽毛笔
        },
        tech = TECH.NONE,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_sprout_song.xml",
            image = "dst_gi_nahida_sprout_song.tex",
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_sourcewater_hymn", -- 源水的曲调
        fateseat_level = 1,
        ingredients = {
            { name = "papyrus", amount = 1 }, -- 莎草纸
            { name = "featherpencil", amount = 1 }, -- 羽毛笔
        },
        tech = TECH.NONE,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_sourcewater_hymn.xml",
            image = "dst_gi_nahida_sourcewater_hymn.tex",
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_revival_chant", -- 苏生的曲调
        fateseat_level = 1,
        ingredients = {
            { name = "papyrus", amount = 1 }, -- 莎草纸
            { name = "featherpencil", amount = 1 }, -- 羽毛笔
        },
        tech = TECH.NONE,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_revival_chant.xml",
            image = "dst_gi_nahida_revival_chant.tex",
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.GACHA_RECIPE_ENABLE,
        recipe_name = "dst_gi_nahida_gacha_machine",
        ingredients = {
            { name = "goldnugget", amount = 10 }, -- 金子
            { name = "transistor", amount = 4 }, -- 电子元件
            { name = "boards", amount = 10 }, -- 木板
            { name = "gears", amount = 1 }, -- 齿轮
        },
        tech = TECH.NONE,
        config = {
            --builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_gacha_machine.xml",
            image = "dst_gi_nahida_gacha_machine.tex",
            placer = "dst_gi_nahida_gacha_machine_placer",
            min_spacing = 1
        },
        filters = {
            'CHARACTER', "REFINE", "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_intertwined_fate", -- 纠缠之缘
        ingredients = {
            { name = "dst_gi_nahida_acquaint_fate", amount = 1, atlas = "images/inventoryimages/dst_gi_nahida_acquaint_fate.xml", imageoverride = "dst_gi_nahida_acquaint_fate.tex" }
        },
        tech = TECH.NONE,
        config = {
            --builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_intertwined_fate.xml",
            image = "dst_gi_nahida_intertwined_fate.tex"
        },
        filters = {
            'CHARACTER', "REFINE", "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_intertwined_fate", -- 纠缠之缘
        ingredients = {
            { name = "goldnugget", amount = 10 }
        },
        tech = TECH.NONE,
        ingredientmod = 1,
        config = {
            --builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_intertwined_fate.xml",
            image = "dst_gi_nahida_intertwined_fate.tex"
        },
        filters = {
            'CHARACTER', "REFINE", "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_intertwined_fate_10_v2", -- 纠缠之缘
        ingredients = {
            { name = "goldnugget", amount = 100 }
        },
        tech = TECH.NONE,
        ingredientmod = 1,
        config = {
            --builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_intertwined_fate.xml",
            image = "dst_gi_nahida_intertwined_fate.tex",
            product = "dst_gi_nahida_intertwined_fate",
            numtogive = 10
        },
        filters = {
            'CHARACTER', "REFINE", "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_intertwined_fate_10", -- 纠缠之缘 x10
        ingredients = {
            { name = "dst_gi_nahida_acquaint_fate", amount = 10, atlas = "images/inventoryimages/dst_gi_nahida_acquaint_fate.xml", imageoverride = "dst_gi_nahida_acquaint_fate.tex" }
        },
        tech = TECH.NONE,
        ingredientmod = 1,
        config = {
            --builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_intertwined_fate.xml",
            image = "dst_gi_nahida_intertwined_fate.tex",
            product = "dst_gi_nahida_intertwined_fate",
            numtogive = 10
        },
        filters = {
            'CHARACTER', "REFINE", "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_acquaint_fate", -- 相遇之缘
        ingredients = {
            { name = "dst_gi_nahida_intertwined_fate", amount = 1, atlas = "images/inventoryimages/dst_gi_nahida_intertwined_fate.xml", imageoverride = "dst_gi_nahida_intertwined_fate.tex" }
        },
        tech = TECH.NONE,
        config = {
            --builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_acquaint_fate.xml",
            image = "dst_gi_nahida_acquaint_fate.tex"
        },
        filters = {
            'CHARACTER', "REFINE", "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_acquaint_fate", -- 相遇之缘
        ingredients = {
            { name = "goldnugget", amount = 10 }
        },
        tech = TECH.NONE,
        ingredientmod = 1,
        config = {
            --builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_acquaint_fate.xml",
            image = "dst_gi_nahida_acquaint_fate.tex"
        },
        filters = {
            'CHARACTER', "REFINE", "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_acquaint_fate_10_v2", -- 相遇之缘
        ingredients = {
            { name = "goldnugget", amount = 100 }
        },
        tech = TECH.NONE,
        ingredientmod = 1,
        config = {
            --builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_acquaint_fate.xml",
            image = "dst_gi_nahida_acquaint_fate.tex",
            product = "dst_gi_nahida_acquaint_fate",
            numtogive = 10
        },
        filters = {
            'CHARACTER', "REFINE", "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_acquaint_fate_10", -- 相遇之缘x10
        ingredients = {
            { name = "dst_gi_nahida_intertwined_fate", amount = 10, atlas = "images/inventoryimages/dst_gi_nahida_intertwined_fate.xml", imageoverride = "dst_gi_nahida_intertwined_fate.tex" }
        },
        tech = TECH.NONE,
        ingredientmod = 1,
        config = {
            --builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_acquaint_fate.xml",
            image = "dst_gi_nahida_acquaint_fate.tex",
            product = "dst_gi_nahida_acquaint_fate",
            numtogive = 10
        },
        filters = {
            'CHARACTER', "REFINE", "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_ice_box", -- 冰箱
        ingredients = {
            { name = "goldnugget", amount = 8 },
            { name = "gears", amount = 1 },
            { name = "cutstone", amount = 1 },
        },
        tech = TECH.NONE,
        config = {
            atlas = "images/inventoryimages/dst_gi_nahida_ice_box.xml",
            image = "dst_gi_nahida_ice_box.tex",
            placer = "dst_gi_nahida_ice_box_placer",
            min_spacing = 1
        },
        filters = {
            'CHARACTER', "STRUCTURES", "CONTAINERS", "COOKING", "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_treasure_chest", -- 箱子
        ingredients = {
            { name = "boards", amount = 5 }
        },
        tech = TECH.NONE,
        config = {
            atlas = "images/inventoryimages/dst_gi_nahida_treasure_chest.xml",
            image = "dst_gi_nahida_treasure_chest.tex",
            placer = "dst_gi_nahida_treasure_chest_placer",
            min_spacing = 1
        },
        filters = {
            'CHARACTER', "DECOR", "STRUCTURES", "CONTAINERS", "DST_GI_NAHIDA"
        }
    },
    --{
    --    recipe_name = "dst_gi_nahida_toy_chest", -- 纳西妲的玩具箱
    --    ingredients = {
    --        { name = "boards", amount = 5 }
    --    },
    --    tech = TECH.NONE,
    --    config = {
    --        builder_tag = TUNING.MOD_ID,
    --        atlas = "images/inventoryimages/dst_gi_nahida_toy_chest.xml",
    --        image = "dst_gi_nahida_toy_chest.tex",
    --        placer = "dst_gi_nahida_toy_chest_placer",
    --        min_spacing=1
    --    },
    --    filters = {
    --        'CHARACTER', "DECOR", "STRUCTURES", "CONTAINERS", "DST_GI_NAHIDA"
    --    }
    --},
    {
        recipe_name = "dst_gi_nahida_birthday_gift_box", -- 生日礼盒
        ingredients = {
            { name = "papyrus", amount = 4 }, -- 莎草纸
            { name = "rope", amount = 5 }, -- 绳子
            { name = "petals", amount = 10 }, -- 花瓣
            --{ name = "pigskin", amount = 5 }, -- 猪皮
        },
        tech = TECH.NONE,
        config = {
            atlas = "images/inventoryimages/dst_gi_nahida_birthday_gift_box.xml",
            image = "dst_gi_nahida_birthday_gift_box.tex",
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "dst_gi_nahida_thousand_floating_dreams", --千夜浮梦
        ingredients = {
            { name = "twigs", amount = 3 },
            { name = "goldnugget", amount = 10 },
            { name = "rocks", amount = 10 }
        },
        tech = TECH.SCIENCE_TWO,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_thousand_floating_dreams.xml",
            image = "dst_gi_nahida_thousand_floating_dreams.tex"
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    --{
    --    recipe_name = "dst_gi_nahida_spellbook", -- 轮盘法术书
    --    ingredients = {
    --        { name = "papyrus", amount = 1 },
    --    },
    --    tech = TECH.NONE,
    --    config = {
    --        builder_tag = TUNING.MOD_ID,
    --        atlas = "images/inventoryimages/dst_gi_nahida_spellbook.xml",
    --        image = "dst_gi_nahida_spellbook.tex"
    --    },
    --    filters = {
    --        'CHARACTER', "DST_GI_NAHIDA"
    --    }
    --},
    {
        enable = (not TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.SHIPWRECKED),
        recipe_name = "dst_gi_nahida_book_fullmoon", -- 月圆书
        ingredients = {
            { name = "papyrus", amount = 4 }, -- 莎草纸
            { name = "opalpreciousgem", amount = 1 }, -- 彩虹宝石
            { name = "moonbutterflywings", amount = 2 } -- 月蛾
        },
        tech = TECH.MAGIC_THREE,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_book_fullmoon.xml",
            image = "dst_gi_nahida_book_fullmoon.tex"
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        enable = (not TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.SHIPWRECKED),
        recipe_name = "dst_gi_nahida_book_newmoon", -- 月黑书
        ingredients = {
            { name = "papyrus", amount = 4 }, -- 莎草纸
            { name = "opalpreciousgem", amount = 1 }, -- 彩虹宝石
            { name = "nightmarefuel", amount = 2 }    -- 噩梦燃料
        },
        tech = TECH.MAGIC_THREE,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_book_newmoon.xml",
            image = "dst_gi_nahida_book_newmoon.tex"
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        enable = (not TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.SHIPWRECKED),
        recipe_name = "dst_gi_nahida_book_fish", -- 鱼书
        ingredients = {
            { name = "papyrus", amount = 4 }, -- 莎草纸
            { name = "opalpreciousgem", amount = 1 }, -- 彩虹宝石
            { name = "oceanfishingbobber_ball", amount = 2 }
        },
        tech = TECH.MAGIC_THREE,
        config = {
            builder_tag = TUNING.MOD_ID,
            atlas = "images/inventoryimages/dst_gi_nahida_book_fish.xml",
            image = "dst_gi_nahida_book_fish.tex"
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        enable = (not TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.SHIPWRECKED),
        recipe_name = "dst_gi_nahida_dress", -- 纳西妲的背包
        ingredients = {
            { name = "rope", amount = 4 }, -- 绳子
            { name = "sewing_kit", amount = 1 }, -- 缝纫包
            { name = "beefalowool", amount = 8 }, -- 牛毛
            { name = "petals", amount = 10 }, -- 花瓣
        },
        ingredientmod = 1,
        tech = TECH.SCIENCE_TWO,
        config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/dst_gi_nahida_dress.xml", image = "dst_gi_nahida_dress.tex" },
        filters = { 'CHARACTER', "DST_GI_NAHIDA" }
    },
    {
        enable = TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.SHIPWRECKED,
        recipe_name = "dst_gi_nahida_dress", -- 纳西妲的背包
        ingredients = {
            { name = "rope", amount = 4 }, -- 绳子
            { name = "sewing_kit", amount = 1 }, -- 缝纫包
            { name = "fabric", amount = 8 }, -- 牛毛
            { name = "petals", amount = 10 }, -- 花瓣
        },
        ingredientmod = 1,
        tech = TECH.SCIENCE_TWO,
        config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/dst_gi_nahida_dress.xml", image = "dst_gi_nahida_dress.tex" },
        filters = { 'CHARACTER', "DST_GI_NAHIDA" }
    },
    {
        enable = (not TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.SHIPWRECKED),
        recipe_name = "dst_gi_nahida_dress2", -- 纳西妲的背包2
        ingredients = {
            { name = "dst_gi_nahida_dress", amount = 1, atlas = "images/inventoryimages/dst_gi_nahida_dress.xml", imageoverride = "dst_gi_nahida_dress.tex" }, -- 1级纳西妲的背包
            { name = "deerclops_eyeball", amount = 2 }   -- 巨鹿眼球 算是建造减半效果，应该是2
        },
        ingredientmod = 1,
        tech = TECH.MAGIC_THREE,
        config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/dst_gi_nahida_dress2.xml", image = "dst_gi_nahida_dress2.tex" },
        filters = { 'CHARACTER', "DST_GI_NAHIDA" }
    },
    {
        enable = TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.SHIPWRECKED,
        recipe_name = "dst_gi_nahida_dress2", -- 纳西妲的背包2
        ingredients = {
            { name = "dst_gi_nahida_dress", amount = 1, atlas = "images/inventoryimages/dst_gi_nahida_dress.xml", imageoverride = "dst_gi_nahida_dress.tex" }, -- 1级纳西妲的背包
            { name = "magic_seal", amount = 1 }   -- 魔法豹印 算是建造减半效果，应该是2
        },
        ingredientmod = 1,
        tech = TECH.MAGIC_THREE,
        config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/dst_gi_nahida_dress2.xml", image = "dst_gi_nahida_dress2.tex" },
        filters = { 'CHARACTER', "DST_GI_NAHIDA" }
    },
    {
        enable = (not TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.SHIPWRECKED),
        recipe_name = "dst_gi_nahida_dress3", -- 纳西妲的背包3
        ingredients = {
            { name = "dst_gi_nahida_dress2", amount = 1, atlas = "images/inventoryimages/dst_gi_nahida_dress2.xml", imageoverride = "dst_gi_nahida_dress2.tex" }, -- 2级纳西妲的背包
            { name = "goose_feather", amount = 10 }, -- 麋鹿鹅羽毛 算是建造减半效果，应该是20
            { name = "dragon_scales", amount = 4 }, -- 龙鳞
        },
        ingredientmod = 1,
        tech = TECH.ANCIENT_THREE,
        config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/dst_gi_nahida_dress3.xml", image = "dst_gi_nahida_dress3.tex" },
        filters = { 'CHARACTER', "DST_GI_NAHIDA" }
    },
    {
        enable = TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.SHIPWRECKED,
        recipe_name = "dst_gi_nahida_dress3", -- 纳西妲的背包3
        ingredients = {
            { name = "dst_gi_nahida_dress2", amount = 1, atlas = "images/inventoryimages/dst_gi_nahida_dress2.xml", imageoverride = "dst_gi_nahida_dress2.tex" }, -- 2级纳西妲的背包
            { name = "tigereye", amount = 1 }, -- 虎鲨之眼 算是建造减半效果，应该是20
            { name = "shark_gills", amount = 2 }, -- 鲨鱼腮
        },
        ingredientmod = 1,
        tech = TECH.ANCIENT_THREE,
        config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/dst_gi_nahida_dress3.xml", image = "dst_gi_nahida_dress3.tex" },
        filters = { 'CHARACTER', "DST_GI_NAHIDA" }
    },
    --{
    --    recipe_name = "dst_gi_nahida_hairpin", -- 纳西妲的发卡
    --    ingredients = {
    --        { name = "rope", amount = 2 }, -- 绳子
    --        { name = "beefalowool", amount = 8 }, -- 牛毛
    --        { name = "petals", amount = 30 }, -- 花瓣
    --    },
    --    tech = TECH.NONE,
    --    config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/dst_gi_nahida_hairpin.xml", image = "dst_gi_nahida_hairpin.tex" },
    --    filters = { 'CHARACTER', "DST_GI_NAHIDA" }
    --},
    {
        recipe_name = "dst_gi_nahida_opalpreciousgem", -- 彩虹宝石
        fateseat_level = 2,
        ingredients = {
            { name = "redgem", amount = 1 },
            { name = "bluegem", amount = 1 },
            { name = "greengem", amount = 1 },
            { name = "yellowgem", amount = 1 },
            { name = "orangegem", amount = 1 },
            { name = "purplegem", amount = 1 },
        },
        tech = TECH.SCIENCE_TWO,
        isOriginalItem = true,
        config = {
            builder_tag = TUNING.MOD_ID,
            product = "opalpreciousgem",
            numtogive = 1,
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    {
        recipe_name = "waxwelljournal", -- 暗影秘典
        fateseat_level = 1,
        ingredients = {
            { name = "papyrus", amount = 2 },
            { name = "nightmarefuel", amount = 2 },
            { name = CHARACTER_INGREDIENT.HEALTH, amount = 50 },
        },
        tech = TECH.SCIENCE_TWO,
        isOriginalItem = true,
        config = {
            builder_tag = TUNING.MOD_ID,
            product = "waxwelljournal",
            numtogive = 1,
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    --{
    --    recipe_name = "ancienttree_seed", -- 惊喜种子
    --    ingredients = {
    --        { name = "papyrus",       amount = 5 },
    --        { name = "seeds",         amount = 5 },
    --        { name = "messagebottle", amount = 2 },
    --    },
    --    tech = TECH.SCIENCE_TWO,
    --    isOriginalItem = true,
    --    config = {
    --        builder_tag = TUNING.MOD_ID,
    --    },
    --    filters = {
    --        'CHARACTER'
    --    }
    --},
    {
        recipe_name = "messagebottleempty", -- 空瓶子
        ingredients = {
            { name = "moonglass", amount = 3 }
        },
        tech = TECH.SCIENCE_TWO,
        isOriginalItem = true,
        config = {
            builder_tag = TUNING.MOD_ID,
        },
        filters = {
            'CHARACTER', "DST_GI_NAHIDA"
        }
    },
    -- 原版物品
    -- 纯粹辉煌
    { recipe_name = "purebrilliance", fateseat_level = 4, ingredientmod = 1, ingredients = { { name = "moonglass_charged", amount = 3 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "DST_GI_NAHIDA" } },
    -- 纯粹恐惧
    { recipe_name = "horrorfuel", fateseat_level = 5, ingredientmod = 1, ingredients = { { name = "dreadstone", amount = 1 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "DST_GI_NAHIDA" } },
    -- 黄宝石
    { recipe_name = "yellowgem", fateseat_level = 2, ingredients = { { name = "orangegem", amount = 3 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "DST_GI_NAHIDA" } },
    -- 绿宝石
    { recipe_name = "greengem", fateseat_level = 2, ingredients = { { name = "yellowgem", amount = 3 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "DST_GI_NAHIDA" } },
    -- 橙宝石
    { recipe_name = "orangegem", fateseat_level = 2, ingredients = { { name = "purplegem", amount = 3 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "DST_GI_NAHIDA" } },
    -- 种子
    { recipe_name = "dst_gi_nahida_coconut", ingredientmod = 1, ingredients = { { name = "seeds", amount = 40 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/dst_gi_nahida_coconut.xml", image = "dst_gi_nahida_coconut.tex" }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "seeds", fateseat_level = 1, ingredients = { { name = "goldnugget", amount = 1 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "carrot_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "asparagus_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "corn_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "dragonfruit_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "durian_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "eggplant_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "garlic_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "onion_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "pepper_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "pomegranate_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "potato_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "pumpkin_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "tomato_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES, recipe_name = "watermelon_seeds", fateseat_level = 1, ingredients = { { name = "seeds", amount = 4 } }, tech = TECH.NONE, isOriginalItem = true, config = { builder_tag = TUNING.MOD_ID }, filters = { 'CHARACTER', "GARDENING" } },
    -- 蓝图
    -- 火花炬蓝图
    { recipe_name = "security_pulse_cage", ingredients = { { name = "purebrilliance", amount = 2 }, { name = "goldnugget", amount = 5 }, { name = "log", amount = 5 } }, isOriginalItem = true, tech = TECH.LOST, filters = { 'CHARACTER' } },
    -- 约束静电蓝图
    { recipe_name = "moonstorm_static_item", ingredients = { { name = "transistor", amount = 2 }, { name = "moonglass", amount = 5 }, { name = "log", amount = 5 } }, isOriginalItem = true, tech = TECH.LOST, filters = { 'CHARACTER' } },
    -- 遗物蓝图
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "ruinsrelic_table_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "ruinsrelic_chair_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "ruinsrelic_vase_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "ruinsrelic_chipbowl_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "ruinsrelic_bowl_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "ruinsrelic_plate_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 沙漠护目镜蓝图
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "deserthat_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 茶几蓝图
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "endtable_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 蘑菇钉
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "mushroom_light_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "mushroom_light2_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 红蘑菇帽
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "red_mushroomhat_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 绿蘑菇帽
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "green_mushroomhat_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 蓝蘑菇帽
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "blue_mushroomhat_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 睡袋 悲怨蟾蜍掉落
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "sleepbomb_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 捆绑包装袋
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "bundlewrap_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 龙鳞火炉
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "dragonflyfurnace_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 刺耳三叉戟
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "trident_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 懒人传送塔
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "townportal_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 刮地皮头盔
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "antlionhat_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    --低微咩咩雕像，砖地板，黄金地板 蚁狮兑换
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "cotl_tabernacle_level1_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "turf_cotl_brick_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "turf_cotl_gold_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 贝壳海滩地皮，夹夹绞盘，锯马
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "turf_shellbeach_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "winch_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "carpentry_station_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 月亮码头：大炮套装，炮弹，码头套装，码头桩，月亮码头地皮
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "boat_cannon_kit_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "cannonball_rock_item_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "dock_kit_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "dock_woodposts_item_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "turf_monkey_ground_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 波莉·罗杰的帽子，月亮码头海盗旗
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "polly_rogershat_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "pirate_flag_pole_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 土地夯实器，远古石刻，星象探测仪，尘土块
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "turfcraftingstation_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "turf_archive_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "archive_resonator_item_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "refined_dust_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 星象护目镜，未完成的实验
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "moonstorm_goggleshat_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "moon_device_construction1_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 废墟地皮蓝图，仿废墟地皮蓝图
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "blueprint_craftingset_ruins_builder", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "blueprint_craftingset_ruinsglow_builder", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 绝望头盔，绝望盔甲，绝望石墙
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "dreadstonehat_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "armordreadstone_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "wall_dreadstone_item_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- 支柱脚手架
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "support_pillar_scaffold_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    -- W.A.R.B.I.S.头戴齿轮，W.A.R.B.I.S.盔甲，自动修理机，弹性空间制造器
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "wagpunkhat_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "armorwagpunk_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "wagpunkbits_kit_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "chestupgrade_stacksize_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
}

--TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.FUNCTIONAL_MEDAL
local LINK_RECIPE = {
    FUNCTIONAL_MEDAL = {
        {
            enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES,
            recipe_name = "medal_gift_fruit_seed",
            fateseat_level = 1,
            ingredients = {
                { name = "seeds", amount = 4 }
            },
            tech = TECH.NONE,
            config = {
                builder_tag = TUNING.MOD_ID,
                atlas = "images/inventoryimages/medal_gift_fruit_seed.xml",
                image = "medal_gift_fruit_seed.tex"
            },
            filters = {
                'CHARACTER'
            }
        },
        {
            enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES,
            recipe_name = "mandrakeberry",
            fateseat_level = 1,
            ingredients = {
                { name = "seeds", amount = 4 }
            },
            tech = TECH.NONE,
            config = {
                builder_tag = TUNING.MOD_ID,
                atlas = "images/inventoryimages/mandrakeberry.xml",
                image = "mandrakeberry.tex"
            },
            filters = {
                'CHARACTER'
            }
        },
        {
            enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES,
            recipe_name = "immortal_fruit_seed",
            fateseat_level = 1,
            ingredients = {
                { name = "seeds", amount = 4 }
            },
            tech = TECH.NONE,
            config = {
                builder_tag = TUNING.MOD_ID,
                atlas = "images/inventoryimages/immortal_fruit_seed.xml",
                image = "immortal_fruit_seed.tex"
            },
            filters = {
                'CHARACTER'
            }
        },
        {
            enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_SEED_RECIPES,
            recipe_name = "medal_weed_seeds",
            fateseat_level = 1,
            ingredients = {
                { name = "seeds", amount = 1 }
            },
            tech = TECH.NONE,
            config = {
                builder_tag = TUNING.MOD_ID,
                atlas = "images/inventoryimages/medal_weed_seeds.xml",
                image = "medal_weed_seeds.tex"
            },
            filters = {
                'CHARACTER'
            }
        },
        -- 船上钓鱼池
        { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "medal_seapond_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
        -- 蓝晶甲
        { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "armor_blue_crystal_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
        -- 红晶甲
        { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "armor_medal_obsidian_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
        -- 蓝晶火坑
        { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "medal_coldfirepit_obsidian_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
        --  红晶火坑
        { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "medal_firepit_obsidian_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
        -- 羊角帽
        { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "medal_goathat_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
        -- 蓝晶制冰机
        { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "medal_ice_machine_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
        -- 怪物精华
        { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "medal_monster_essence_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
        -- 不朽宝石
        { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "immortal_gem_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
        -- 熊皮宝箱
        { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "bearger_chest_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
        -- 红晶锅
        { enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_UNKNOWN_RECIPES, recipe_name = "medal_cookpot_blueprint", fateseat_level = 3, ingredients = { { name = "papyrus", amount = 6 }, { name = "featherpencil", amount = 1 } }, tech = TECH.NONE, config = { builder_tag = TUNING.MOD_ID, atlas = "images/inventoryimages/blueprint.xml", image = "blueprint.tex" }, filters = { 'CHARACTER' } },
    }
}

local data = {
    -- {
    -- 	recipe_name = 'choleknife_recipe_1', --食谱ID
    -- 	ingredients = { --配方
    -- 		Injectatlas('pack_gold',1),
    -- 		Ingredient('rope',2),
    -- 		Ingredient('log',2),
    -- 	},
    -- 	tech = TECH.SCIENCE_ONE, --所需科技 ,TECH.LOST 表示需要蓝图才能解锁
    -- 	isOriginalItem = true, --是官方物品(官方物品严禁写atlas和image路径,因为是自动获取的),不写则为自定义物品
    -- 	config ={ --其他的一些配置,可不写
    -- 		--制作出来的物品,不写则默认制作出来的预制物为食谱ID
    -- 		product = 'choleknife',
    -- 		--xml路径,不写则默认路径为,'images/inventoryimages/'..product..'.xml' 或 'images/inventoryimages/'..recipe_name..'.xml'
    -- 		atlas = 'images/choleknife.xml',
    -- 		--图片名称,不写则默认名称为 product..'.tex' 或 recipe_name..'.tex'
    -- 		image = 'choleknife.tex',
    -- 		--制作出的物品数量,不写则为1
    -- 		numtogive = 40,
    -- 		--不需要解锁
    -- 		nounlock = false,
    -- 	},
    -- 	filters = {'CHARACTER'} --将物品添加到这些分类中
    -- },
}

---@type data_destruction_recipes[]
local destruction_recipes = {
}

for _, recipe in ipairs(RECIPES) do
    local new_recipe = {
        recipe_name = recipe.recipe_name,
        ingredients = {}, -- Initialize an empty table for ingredients
        tech = recipe.tech,
        config = recipe.config,
        filters = recipe.filters,
        isOriginalItem = recipe.isOriginalItem
    }
    -- Convert ingredients
    for _, ingredient in ipairs(recipe.ingredients) do
        table.insert(new_recipe.ingredients,
                Ingredient(ingredient.name, ingredient.amount, ingredient.atlas, nil, ingredient.imageoverride))
    end

    if recipe.fateseat_level and recipe.fateseat_level > 0 then
        new_recipe.config.builder_tag = TUNING.MOD_ID .. "_fateseat_level_" .. recipe.fateseat_level
    end
    if recipe.recipe_name == "dst_gi_nahida_toy_desk" then
        print("recipe.enable: " .. tostring(recipe.enable))
        print("recipe.enable: " .. tostring(TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.TOY_RECIPE_ENABLE))
        print("recipe.enable: " .. tostring(TUNING.MOD_DST_GI_NAHIDA_CONFIG("_toy_recipe_enable")))
    end
    if recipe.enable == nil or (recipe.enable ~= nil and recipe.enable) then
        table.insert(data, new_recipe)
        if recipe.recipe_name == "dst_gi_nahida_toy_desk" then
            print("recipe.enable2: " .. tostring(recipe.enable))
            print("recipe.enable2: " .. tostring(TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.TOY_RECIPE_ENABLE))
            print("recipe.enable2: " .. tostring(TUNING.MOD_DST_GI_NAHIDA_CONFIG("_toy_recipe_enable")))
        end
        if recipe.ingredientmod then
            TUNING.NAHIDA_RECIPE_INGREDIENTMOD[recipe.recipe_name] = {
                ingredientmod = recipe.ingredientmod
            }
        end
    end
end

-- 检查模组是否启用并添加相应的配方
for mod_name, recipes in pairs(LINK_RECIPE) do
    if TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD[mod_name] then
        for _, recipe in ipairs(recipes) do
            local new_recipe = {
                recipe_name = recipe.recipe_name,
                ingredients = {}, -- 初始化一个空的配方表
                tech = recipe.tech,
                config = recipe.config,
                filters = recipe.filters
            }
            -- 转换配方材料
            for _, ingredient in ipairs(recipe.ingredients) do
                table.insert(new_recipe.ingredients,
                        Ingredient(ingredient.name, ingredient.amount, ingredient.atlas, nil, ingredient.imageoverride))
            end
            if recipe.fateseat_level and recipe.fateseat_level > 0 then
                new_recipe.config.builder_tag = TUNING.MOD_ID .. "_fateseat_level_" .. recipe.fateseat_level
            end
            if recipe.enable == nil or (recipe.enable ~= nil and recipe.enable) then
                table.insert(data, new_recipe)
                if recipe.ingredientmod then
                    TUNING.NAHIDA_RECIPE_INGREDIENTMOD[recipe.recipe_name] = {
                        ingredientmod = recipe.ingredientmod
                    }
                end
            end

        end
    end
end

return data, destruction_recipes
