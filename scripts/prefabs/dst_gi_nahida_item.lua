---
--- dst_gi_nahida_item.lua
--- Description: 纳西妲物品
--- Author: 没有小钱钱
--- Date: 2025/3/30 19:27
---

local function CreateCustomPrefab(name, build, bank, atlasname, stacksize, scale,tags,item_fn)
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

        inst:AddTag("shoreonsink")
        inst:AddTag("tornado_nosucky")
        inst:AddTag("hide_percentage")
        inst:AddTag("nosteal")
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

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = stacksize or TUNING.STACK_SIZE_TINYITEM

        if item_fn then
            item_fn(inst)
        end

        MakeHauntableLaunchAndDropFirstItem(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end

-- 使用封装函数创建Prefab
return CreateCustomPrefab(
        "dst_gi_nahida_intertwined_fate",  -- name -- 纠缠之缘
        "dst_gi_nahida_intertwined_fate",  -- build
        "dst_gi_nahida_intertwined_fate",  -- bank
        "dst_gi_nahida_intertwined_fate",  -- atlasname
        TUNING.STACK_SIZE_TINYITEM,        -- stacksize
        nil,
        {"dst_gi_nahida_fate"},
        function(inst)
            inst:AddComponent("tradable")
            inst.components.tradable.goldvalue = 8
        end
),
CreateCustomPrefab(
        "dst_gi_nahida_acquaint_fate",  -- name 相遇之缘
        "dst_gi_nahida_acquaint_fate",  -- build
        "dst_gi_nahida_acquaint_fate",  -- bank
        "dst_gi_nahida_acquaint_fate",  -- atlasname
        TUNING.STACK_SIZE_TINYITEM,        -- stacksize
        nil,
        {"dst_gi_nahida_fate"},
        function(inst)
            inst:AddComponent("tradable")
            inst.components.tradable.goldvalue = 8
        end
),
CreateCustomPrefab(
        "dst_gi_nahida_tool_knife",  -- name 纳西妲的工具刀
        "dst_gi_nahida_tool_knife",  -- build
        "dst_gi_nahida_tool_knife",  -- bank
        "dst_gi_nahida_tool_knife",  -- atlasname
        TUNING.STACK_SIZE_TINYITEM,        -- stacksize
        nil,
        {"dst_gi_nahida_tool_knife"},
        nil
),
CreateCustomPrefab(
        "dst_gi_nahida_growth_value",  -- name 纳西妲的成长值
        "dst_gi_nahida_growth_value",  -- build
        "dst_gi_nahida_growth_value",  -- bank
        "dst_gi_nahida_growth_value",  -- atlasname
        TUNING.STACK_SIZE_TINYITEM,        -- stacksize
        nil,
        {"dst_gi_nahida_growth_value"},
        function(inst)
            inst:AddComponent("tradable")
            inst.components.tradable.goldvalue = 1
        end
)

