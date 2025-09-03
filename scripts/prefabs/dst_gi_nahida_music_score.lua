---
--- dst_gi_nahida_music_score.lua
--- Description: 风物之诗琴
--- Author: 没有小钱钱
--- Date: 2025/5/24 16:28
---
local function CreateCustomPrefab(name, build, bank, atlasname, scale,tags)
    local assets = {
        Asset("ANIM", "anim/" .. build .. ".zip"),
        Asset("ATLAS", "images/inventoryimages/" .. atlasname .. ".xml"),
        Asset("IMAGE", "images/inventoryimages/" .. atlasname .. ".tex"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddLight()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("hide_percentage")
        inst:AddTag(name)
        inst:AddTag("dst_gi_nahida_item")

        if tags ~= nil then
            for i, v in ipairs(tags) do
                inst:AddTag(v)
            end
        end

        inst.AnimState:SetBuild(build)
        inst.AnimState:SetBank(bank)
        inst.AnimState:PlayAnimation("idle")

        if scale then
            inst.Transform:SetScale(scale.x, scale.y, scale.z)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("dst_gi_nahida_actions_data")
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. atlasname .. ".xml"

        MakeHauntableLaunchAndDropFirstItem(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end

return CreateCustomPrefab(
        "dst_gi_nahida_melody_of_the_great_dream",  -- name -- 大梦的曲调
        "dst_gi_nahida_music_score",  -- build
        "dst_gi_nahida_music_score",  -- bank
        "dst_gi_nahida_melody_of_the_great_dream",  -- atlasname
        nil,
        {"dst_gi_nahida_music_score"}
),
CreateCustomPrefab(
        "dst_gi_nahida_huanmo_chant",  -- name -- 桓摩的曲调
        "dst_gi_nahida_music_score",  -- build
        "dst_gi_nahida_music_score",  -- bank
        "dst_gi_nahida_huanmo_chant",  -- atlasname
        nil,
        {"dst_gi_nahida_music_score"}
),
CreateCustomPrefab(
        "dst_gi_nahida_path_of_shadows_tune",  -- name -- 黯道的曲调
        "dst_gi_nahida_music_score",  -- build
        "dst_gi_nahida_music_score",  -- bank
        "dst_gi_nahida_path_of_shadows_tune",  -- atlasname
        nil,
        {"dst_gi_nahida_music_score"}
),
CreateCustomPrefab(
        "dst_gi_nahida_beast_trail_melody",  -- name -- 兽径的曲调
        "dst_gi_nahida_music_score",  -- build
        "dst_gi_nahida_music_score",  -- bank
        "dst_gi_nahida_beast_trail_melody",  -- atlasname
        nil,
        {"dst_gi_nahida_music_score"}
),
CreateCustomPrefab(
        "dst_gi_nahida_sprout_song",  -- name -- 新芽的曲调
        "dst_gi_nahida_music_score",  -- build
        "dst_gi_nahida_music_score",  -- bank
        "dst_gi_nahida_sprout_song",  -- atlasname
        nil,
        {"dst_gi_nahida_music_score"}
),
CreateCustomPrefab(
        "dst_gi_nahida_sourcewater_hymn",  -- name -- 源水的曲调
        "dst_gi_nahida_music_score",  -- build
        "dst_gi_nahida_music_score",  -- bank
        "dst_gi_nahida_sourcewater_hymn",  -- atlasname
        nil,
        {"dst_gi_nahida_music_score"}
),
CreateCustomPrefab(
        "dst_gi_nahida_revival_chant",  -- name -- 苏生的曲调
        "dst_gi_nahida_music_score",  -- build
        "dst_gi_nahida_music_score",  -- bank
        "dst_gi_nahida_revival_chant",  -- atlasname
        nil,
        {"dst_gi_nahida_music_score"}
)