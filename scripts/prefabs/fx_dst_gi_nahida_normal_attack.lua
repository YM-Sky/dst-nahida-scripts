---
--- fx_dst_gi_nahida_normal_attack.lua
--- Description: 普通攻击特效
--- Author: 没有小钱钱
--- Date: 2025/3/27 1:00
---

-- 定义动画和资源
local ground_assets = {
    Asset("ANIM", "anim/dst_gi_nahida_attack_ground.zip")
}

local function attack_ground_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag('NOCLICK')
    inst:AddTag('NOBLOCK')
    inst:AddTag("noblock")
    inst:AddTag("dst_gi_nahida_attack_ground")

    -- 设置第一个动画
    inst.AnimState:SetBuild("dst_gi_nahida_attack_ground")
    inst.AnimState:SetBank("dst_gi_nahida_attack_ground")
    inst.AnimState:PlayAnimation("idle")

    -- 设置动画的开花效果和光照覆盖
    inst.AnimState:SetSymbolBloom("pb_energy_loop")
    inst.AnimState:SetSymbolBloom("stone")
    inst.AnimState:SetSymbolLightOverride("pb_energy_loop01", .5)
    inst.AnimState:SetSymbolLightOverride("pb_ray", .5)
    inst.AnimState:SetSymbolLightOverride("stone", .5)
    inst.AnimState:SetSymbolLightOverride("glow", .25)
    inst.AnimState:SetLightOverride(.1)
    -- 设置固定朝向
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    -- 设置渲染层和排序顺序
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(0)  -- 数字越小，越靠近地面
    -- 可选：调整缩放以适应地面
    inst.Transform:SetScale(1.3, 1.3, 1.3)

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

    --inst:ListenForEvent("animover", function() inst:Remove() end)

    return inst -- 返回实体
end

return Prefab("dst_gi_nahida_attack_ground", attack_ground_fn, ground_assets)