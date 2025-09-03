--- dst_gi_nahida_element_spearfx.lua
--- Description: 容器
--- Author: 没有小钱钱
--- Date: 2025/3/1 11:36
---

local assets =
{
    Asset("ANIM", "anim/dst_gi_nahida_element_spear.zip")
}

local elementArray = {
    "water",
    "fire",
    "ice",
    "thunder",
    "grass",
    "wind",
    "rock",
}
local element_fx = {}

local function MakeElementFx(element)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("FX")
        inst:AddTag('NOCLICK')
        inst:AddTag('NOBLOCK')

        inst.Transform:SetScale(0.2, 0.2, 0.2)
        inst.Transform:SetNoFaced()

        inst.AnimState:SetBank("dst_gi_nahida_element_spear_"..element)
        inst.AnimState:SetBuild("dst_gi_nahida_element_spear")
        inst.AnimState:PlayAnimation("idle",true)
        --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        -- 设置动画方向为 BillBoard，使其始终面向屏幕
        --inst.AnimState:SetOrientation(ANIM_ORIENTATION.BillBoard)
        -- 根据需要设置层次
        --inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
        inst.entity:SetPristine()
        --inst:ListenForEvent("animover", inst.Remove)
        return inst
    end
    return Prefab("dst_gi_nahida_element_spear_"..element, fn, assets)
end

-- 遍历元素数组并创建特效
for _, element in ipairs(elementArray) do
    table.insert(element_fx, MakeElementFx(element))
end

return unpack(element_fx)