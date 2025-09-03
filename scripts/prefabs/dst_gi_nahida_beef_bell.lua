---
--- dst_gi_nahida_beef_bell.lua
--- Description: 纳西妲的牛铃
--- Author: 没有小钱钱
--- Date: 2025/5/12 0:08
---
local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_beef_bell.zip"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_beef_bell.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_beef_bell.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_beef_bell_bind.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_beef_bell_bind.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_beef_bell2.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_beef_bell2.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_beef_bell_bind2.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_beef_bell_bind2.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_beef_bell3.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_beef_bell3.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_beef_bell_bind3.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_beef_bell_bind3.xml")
}


local function CreateBeefBell(name)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddLight()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("shoreonsink")     --不掉深渊
        inst:AddTag("tornado_nosucky") --mod兼容：永不妥协。不会被龙卷风刮走
        inst:AddTag("bell")
        inst:AddTag("donotautopick")
        inst:AddTag("dst_gi_nahida_beef_bell")

        -- 设置第一个动画
        inst.AnimState:SetBuild("dst_gi_nahida_beef_bell")
        inst.AnimState:SetBank("dst_gi_nahida_beef_bell")
        inst.AnimState:PlayAnimation("idle")


        -- 设置实体为原始状态
        inst.entity:SetPristine()

        -- 如果不是主服务器，直接返回实体
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("dst_gi_nahida_actions_data") -- 加入纳西妲的动作组件
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        MakeHauntableLaunchAndDropFirstItem(inst)

        return inst
    end
    return Prefab(name, fn, assets)
end

local function CreateBeefBellBind(name)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddLight()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("shoreonsink")     --不掉深渊
        inst:AddTag("tornado_nosucky") --mod兼容：永不妥协。不会被龙卷风刮走
        inst:AddTag("bell")
        inst:AddTag("donotautopick")

        -- 设置第一个动画
        inst.AnimState:SetBuild("dst_gi_nahida_beef_bell")
        inst.AnimState:SetBank("dst_gi_nahida_beef_bell")
        inst.AnimState:PlayAnimation("idle_bind")


        -- 设置实体为原始状态
        inst.entity:SetPristine()

        -- 如果不是主服务器，直接返回实体
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("dst_gi_nahida_actions_data")
        inst:AddComponent("dst_gi_nahida_beef_bell_data")
        inst:AddComponent("dst_gi_nahida_bind_data")
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        MakeHauntableLaunchAndDropFirstItem(inst)

        return inst
    end
    return Prefab(name, fn, assets)
end
return CreateBeefBell("dst_gi_nahida_beef_bell"), -- 普通牛铃
CreateBeefBellBind("dst_gi_nahida_beef_bell_bind"),
CreateBeefBell("dst_gi_nahida_beef_bell2"), -- 战牛牛铃
CreateBeefBellBind("dst_gi_nahida_beef_bell_bind2"),
CreateBeefBell("dst_gi_nahida_beef_bell3"), -- 行牛牛铃
CreateBeefBellBind("dst_gi_nahida_beef_bell_bind3")