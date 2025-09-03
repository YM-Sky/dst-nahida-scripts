---
--- dst_gi_nahida_character_card.lua
--- Description: 原神角色卡片
--- Author: 旅行者
--- Date: 2025/8/3 19:32
---

local function CreateCharacterCardPrefab(name, character, build, bank, atlasname, scale, tags, item_fn)
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

        inst:AddTag("shoreonsink") -- 不掉深渊
        inst:AddTag("tornado_nosucky") -- 不会被龙卷风刮走
        inst:AddTag("hide_percentage") -- 隐藏耐久值
        inst:AddTag("nosteal")
        inst:AddTag("character_card")
        inst:AddTag(name)
        inst:AddTag("dst_gi_nahida_item")

        if tags ~= nil then
            for i, v in ipairs(tags) do
                inst:AddTag(v)
            end
        end
        inst.character = character
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

        if item_fn then
            item_fn(inst)
        end

        MakeHauntableLaunchAndDropFirstItem(inst)

        return inst
    end
    return Prefab(name, fn, assets)
end

local character_cards = {
    {
        name = "dst_gi_nahida_keqing_burst_card",
        character = "keqing",
        build = "dst_gi_nahida_keqing_burst_card",
        bank = "dst_gi_nahida_keqing_burst_card",
        atlasname = "dst_gi_nahida_keqing_burst_card",
        scale = nil,
        tags = nil,
        item_fn = nil,
    }
}

local cards = {}

for i, card in ipairs(character_cards) do
    local prefab_card = CreateCharacterCardPrefab(
            card.name,
            card.character,
            card.build,
            card.bank,
            card.atlasname,
            card.scale,
            card.tags,
            card.item_fn
    )
    table.insert(cards,prefab_card)
end

return unpack(cards)