---
--- dst_gi_nahida_toy_desk.lua
--- Description: 小玩具制造站
--- Author: 没有小钱钱
--- Date: 2025/5/24 12:25
---

-- 定义动画和资源
local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_toy_desk.zip"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_toy_desk.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_toy_desk.tex"),
}

local function OnHammered(inst, digger)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function workmultiplierfn(inst, worker, numworks)
    if worker and worker:HasTag("player") then
        return 1
    end
    return 0
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:AddTag("structure")
    inst:AddTag("tornado_nosucky") --mod兼容：永不妥协。不会被龙卷风刮走

    -- 设置第一个动画
    inst.AnimState:SetBuild("dst_gi_nahida_toy_desk")
    inst.AnimState:SetBank("dst_gi_nahida_toy_desk")
    inst.AnimState:PlayAnimation("idle")
    --inst.Transform:SetScale(0.8, 0.8, 0.8)
    -- 设置部署半径
    inst:SetDeploySmartRadius(0.25) --recipe min_spacing/2
    RemovePhysicsColliders(inst)

    -- 设置实体为原始状态
    inst.entity:SetPristine()

    -- 如果不是主服务器，直接返回实体
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable.workmultiplierfn = workmultiplierfn

    -- 添加掉落物组件
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "boards" })
    -- 添加模组内的动作组件
    inst:AddComponent("dst_gi_nahida_actions_data")

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("dst_gi_nahida_toy_desk", fn, assets),
MakePlacer("dst_gi_nahida_toy_desk_placer", "dst_gi_nahida_toy_desk", "dst_gi_nahida_toy_desk", "idle")