---
--- fx_dst_gi_nahida_four_leaf_clover.lua
--- Description: 四叶草特效
--- Author: 没有小钱钱
--- Date: 2025/3/30 19:27
---
-- 定义动画和资源
local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_skill.zip")
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag('NOCLICK')
    inst:AddTag('NOBLOCK')

    -- 设置第一个动画
    inst.AnimState:SetBuild("dst_gi_nahida_skill")
    inst.AnimState:SetBank("nahida_four_leaf_clover")
    inst.AnimState:PlayAnimation("idle",true)
    inst.Transform:SetScale(0.8, 0.8, 0.8)

    -- 设置动画的开花效果和光照覆盖
    inst.AnimState:SetSymbolBloom("pb_energy_loop")
    inst.AnimState:SetSymbolBloom("stone")
    inst.AnimState:SetSymbolLightOverride("pb_energy_loop01", .5)
    inst.AnimState:SetSymbolLightOverride("pb_ray", .5)
    inst.AnimState:SetSymbolLightOverride("stone", .5)
    inst.AnimState:SetSymbolLightOverride("glow", .25)
    inst.AnimState:SetLightOverride(.1)

    -- 添加高亮组件，使其可以在高亮时显示
    inst:AddComponent("highlightchild")

    -- 设置实体为原始状态
    inst.entity:SetPristine()

    -- 如果不是主服务器，直接返回实体
    if not TheWorld.ismastersim then
        return inst
    end

    -- 添加颜色附加组件，用于颜色效果
    inst:AddComponent("colouradder")

    return inst
end

return Prefab("fx_dst_gi_nahida_four_leaf_clover", fn, assets)