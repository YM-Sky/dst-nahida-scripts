---
--- rocks_hooks.lua
--- Description: 岩石hooks
--- Author: 旅行者
--- Date: 2025/8/24 5:47
---

local rock_table = {
    "rock1",
    "rock2",
    "rock_flintless",
    "rock_flintless_med",
    "rock_flintless_low",
    "rock_moon",
    "rock_moon_shell",
    "moonglass_rock",
    "rock_petrified_tree",
    "rock_petrified_tree_med",
    "rock_petrified_tree_tall",
    "rock_petrified_tree_short",
    "rock_petrified_tree_old",
    "ruins_statue_mage",
    "ruins_statue_mage_nogem",
    "ruins_statue_head",
    "ruins_statue_head_nogem",
    "cave_entrance",
    "saltstack",
    "spiderhole",
    "spiderhole_rock",
    "stalagmite",
    "stalagmite_full",
    "stalagmite_med",
    "stalagmite_low",
    "stalagmite_tall",
    "stalagmite_tall_full",
    "stalagmite_tall_med",
    "stalagmite_tall_low",
    "archive_moon_statue",
    "seastack",
    "rock_avocado_fruit",
}

for i, prefab in ipairs(rock_table) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddTag("dst_gi_nahida_rocks")
    end)
end