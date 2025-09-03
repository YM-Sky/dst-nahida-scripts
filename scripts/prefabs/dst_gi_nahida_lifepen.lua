---
--- dst_gi_nahida_lifepen.lua
--- Description: 强化强心针
--- Author: 没有小钱钱
--- Date: 2025/6/7 22:57
---

local assets =
{
    Asset("ANIM", "anim/dst_gi_nahida_lifepen.zip"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_lifepen.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_lifepen.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("dst_gi_nahida_lifepen")
    inst.AnimState:SetBuild("dst_gi_nahida_lifepen")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --inst:AddComponent("stackable")
    --inst.components.stackable.maxsize = 1
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dst_gi_nahida_lifepen.xml"
    inst:AddComponent("dst_gi_nahida_actions_data")

    if TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.DST_GI_NAHIDA_LIFEPEN_NUM and TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.DST_GI_NAHIDA_LIFEPEN_NUM >= 1  then
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetOnFinished(inst.Remove)
        inst.components.finiteuses:SetMaxUses(TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.DST_GI_NAHIDA_LIFEPEN_NUM)
        inst.components.finiteuses:SetUses(TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.DST_GI_NAHIDA_LIFEPEN_NUM)
    end



    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("dst_gi_nahida_lifepen", fn, assets)