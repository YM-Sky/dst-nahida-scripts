---
--- dst_gi_nahida_fateseat.lua
--- Description: 纳西妲的命座
--- Author: 没有小钱钱
--- Date: 2025/3/30 19:27
---
-- 定义动画和资源
local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_fateseat.zip"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_fateseat.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_fateseat.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("shoreonsink")     --不掉深渊
    inst:AddTag("tornado_nosucky") --mod兼容：永不妥协。不会被龙卷风刮走
    inst:AddTag("hide_percentage") -- 隐藏百分比
    inst:AddTag("nosteal")         -- 防偷取

    -- 设置第一个动画
    inst.AnimState:SetBuild("dst_gi_nahida_fateseat")
    inst.AnimState:SetBank("dst_gi_nahida_fateseat")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(0.8, 0.8, 0.8)


    -- 设置实体为原始状态
    inst.entity:SetPristine()

    -- 如果不是主服务器，直接返回实体
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dst_gi_nahida_fateseat.xml"

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = 100

    -- 添加堆叠组件
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM -- 你可以根据需要调整堆叠大小

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("dst_gi_nahida_fateseat", fn, assets)