---
--- dst_gi_nahida_sunkenchest_item.lua
--- Description: 打捞的箱子
--- Author: 旅行者
--- Date: 2025/8/30 18:03
---

local assets =
{
    Asset("ANIM", "anim/dst_gi_nahida_sunkenchest_item.zip"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_sunkenchest_item.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_sunkenchest_item.tex"),
}

local function onDeployCoconut(inst, pt, deployer)
    local sunkenchest = SpawnPrefab("sunkenchest")  -- 暂时使用原版的树作为种植后的物品
    if sunkenchest ~= nil then
        sunkenchest.Transform:SetPosition(pt:Get())
        if inst.components.dst_gi_nahida_sunkenchest_item_data then
            print("保存打捞的箱子")
            inst.components.dst_gi_nahida_sunkenchest_item_data:SunkenChestLoadItems(sunkenchest)
        end
        print("种下打捞的箱子")
        PrintContainerItems(sunkenchest)
        inst:Remove()  -- 移除树苗物品
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("dst_gi_nahida_sunkenchest_item")
    inst.AnimState:SetBuild("dst_gi_nahida_sunkenchest_item")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("dst_gi_nahida_sunkenchest_item_data")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dst_gi_nahida_sunkenchest_item.xml"

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = onDeployCoconut
    inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("dst_gi_nahida_sunkenchest_item", fn, assets),
MakePlacer("dst_gi_nahida_sunkenchest_item_placer", "sunken_treasurechest", "sunken_treasurechest","closed")