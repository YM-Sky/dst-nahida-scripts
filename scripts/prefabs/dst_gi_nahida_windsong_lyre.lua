---
--- dst_gi_nahida_windsong_lyre.lua
--- Description: 风物之诗琴
--- Author: 没有小钱钱
--- Date: 2025/5/24 16:28
---
local function OnEquip(inst, owner)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:OverrideSymbol("swap_object", "dst_gi_nahida_swap_windsong_lyre", "swap_wuqi")
    --if inst.components.aoetargeting then
    --    inst.components.aoetargeting:SetEnabled(false)
    --end
end
local function OnUnequip(inst, owner)
    -- 重新启用 aoetargeting
    --if inst.components.aoetargeting then
    --    inst.components.aoetargeting:SetEnabled(true)
    --end
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if owner.try_growth_for_entities_task ~= nil then
        owner.try_growth_for_entities_task:Cancel()
        owner.try_growth_for_entities_task = nil
    end
end

local function CreateCustomPrefab(name, build, bank,assets, atlasname, scale, tags)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddLight()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        --inst:AddTag("hide_percentage")
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

        inst.net_nahida_active_music_score = net_string(inst.GUID, "net_nahida_active_music_score")
        local old_GetDisplayName = inst.GetDisplayName
        inst.GetDisplayName = function(self, ...)
            local active_music_score = inst.net_nahida_active_music_score:value() or "nil"
            local str = ""
            if active_music_score ~= "nil" then
                local active_music_score_name = STRINGS.NAMES[string.upper(active_music_score)]
                if active_music_score_name then
                    str = str .."\r\n" .. string.format(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_MUSIC_SCORE_CURRENT_ACTIVATE, active_music_score_name)
                end
            end
            return old_GetDisplayName(self, ...)
                    .. str
        end

        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("aoespell")
        inst:AddComponent("dst_gi_nahida_actions_data")
        inst:AddComponent("dst_gi_nahida_windsong_lyre_data")
        inst:AddComponent("finiteuses")
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. atlasname .. ".xml"

        inst:AddComponent("equippable")                                                                               --可装备组件
        inst.components.equippable:SetOnEquip(OnEquip)
        inst.components.equippable:SetOnUnequip(OnUnequip)
        -- inst.components.equippable.walkspeedmult =  1.25
        inst.components.equippable.restrictedtag = TUNING.AVATAR_NAME

        inst.components.finiteuses:SetMaxUses(100)
        inst.components.finiteuses:SetUses(0)
        inst.components.finiteuses:SetIgnoreCombatDurabilityLoss(true)

        MakeHauntableLaunchAndDropFirstItem(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end

return CreateCustomPrefab(
        "dst_gi_nahida_windsong_lyre", -- name -- 风物之诗琴
        "dst_gi_nahida_windsong_lyre", -- build
        "dst_gi_nahida_windsong_lyre", -- bank
        {
            Asset("ANIM", "anim/dst_gi_nahida_swap_windsong_lyre.zip"),
            Asset("ANIM", "anim/dst_gi_nahida_windsong_lyre.zip"),
            Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_windsong_lyre.xml"),
            Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_windsong_lyre.tex"),
        },
        "dst_gi_nahida_windsong_lyre", -- atlasname
        nil,
        nil
)