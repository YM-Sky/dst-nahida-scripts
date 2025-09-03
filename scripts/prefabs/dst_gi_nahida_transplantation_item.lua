---
--- dst_gi_nahida_transplantation_item.lua
--- Description: 纳西妲物品
--- Author: 没有小钱钱
--- Date: 2025/3/30 19:27
---

local function onDeployCoconut(inst, pt, deployer)
    local tree = SpawnPrefab(inst.transplantation_item)  -- 暂时使用原版的树作为种植后的物品
    if tree ~= nil then
        tree.Transform:SetPosition(pt:Get())
        -- 设置为空状态，需要重新生长
        if tree.components.pickable then
            tree.components.pickable:MakeEmpty()  -- 设为空状态
        end
        inst:Remove()  -- 移除树苗物品
    end
end

local function CreateCustomPrefab(name,transplantation_item, build, bank, atlasname, stacksize, scale,tags,item_fn,data)
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

        if stacksize then
            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = stacksize
        end

        inst.transplantation_item = transplantation_item

        if item_fn then
            item_fn(inst)
        end

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = onDeployCoconut
        inst.components.deployable:SetDeployMode(data and data.deploy_mode or DEPLOYMODE.PLANT)
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)

        MakeHauntableLaunchAndDropFirstItem(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end

-- 使用封装函数创建Prefab
return CreateCustomPrefab(
        "dst_gi_nahida_flower_cave",  -- name -- 荧光花1
        "flower_cave",  -- name -- 荧光花1
        "dst_gi_nahida_flower_cave",  -- build
        "dst_gi_nahida_flower_cave",  -- bank
        "dst_gi_nahida_flower_cave",  -- atlasname
        TUNING.STACK_SIZE_TINYITEM,        -- stacksize
        nil,
        {"dst_gi_nahida_transplantation"},
        nil
),
MakePlacer("dst_gi_nahida_flower_cave_placer", "bulb_plant_single", "bulb_plant_single","idle"),
CreateCustomPrefab(
        "dst_gi_nahida_flower_cave_double",  -- name -- 荧光花2
        "flower_cave_double",  -- name -- 荧光花2
        "dst_gi_nahida_flower_cave",  -- build
        "dst_gi_nahida_flower_cave_double",  -- bank
        "dst_gi_nahida_flower_cave_double",  -- atlasname
        TUNING.STACK_SIZE_TINYITEM,        -- stacksize
        nil,
        {"dst_gi_nahida_transplantation"},
        nil
),
MakePlacer("dst_gi_nahida_flower_cave_double_placer", "bulb_plant_double", "bulb_plant_double","idle"),
CreateCustomPrefab(
        "dst_gi_nahida_flower_cave_triple",  -- name -- 荧光花3
        "flower_cave_triple",  -- name -- 荧光花3
        "dst_gi_nahida_flower_cave",  -- build
        "dst_gi_nahida_flower_cave_triple",  -- bank
        "dst_gi_nahida_flower_cave_triple",  -- atlasname
        TUNING.STACK_SIZE_TINYITEM,        -- stacksize
        nil,
        {"dst_gi_nahida_transplantation"},
        nil
),
MakePlacer("dst_gi_nahida_flower_cave_triple_placer", "bulb_plant_triple", "bulb_plant_triple","idle"),
CreateCustomPrefab(
        "dst_gi_nahida_reeds",  -- name -- 芦苇
        "reeds",  -- name -- 芦苇
        "dst_gi_nahida_reeds",  -- build
        "dst_gi_nahida_reeds",  -- bank
        "dst_gi_nahida_reeds",  -- atlasname
        TUNING.STACK_SIZE_TINYITEM,        -- stacksize
        nil,
        {"dst_gi_nahida_transplantation"},
        nil
),
MakePlacer("dst_gi_nahida_reeds_placer", "grass", "reeds","idle"),
CreateCustomPrefab(
        "dst_nahida_oceantreenut_item",  -- name -- 疙瘩木
        "oceantreenut",  -- name -- 疙瘩木
        "dst_nahida_oceantreenut_item",  -- build
        "dst_nahida_oceantreenut_item",  -- bank
        "dst_nahida_oceantreenut_item",  -- atlasname
        nil,        -- stacksize
        nil,
        {"dst_gi_nahida_transplantation"},
        nil,
        {deploy_mode = DEPLOYMODE.WATER }
),
MakePlacer("dst_nahida_oceantreenut_item_placer", "oceantreenut", "oceantreenut","idle")
