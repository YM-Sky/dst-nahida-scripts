---
--- fx_dst_gi_nahida_illusory_heart_fx.lua
--- Description: 四叶草特效
--- Author: 没有小钱钱
--- Date: 2025/3/30 19:27
---
-- 定义动画和资源
local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_illusory_heart_fx.zip")
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
    inst:AddTag("noblock")
    inst:AddTag("dst_gi_nahida_illusory_heart_fx")

    -- 设置第一个动画
    inst.AnimState:SetBuild("dst_gi_nahida_illusory_heart_fx")
    inst.AnimState:SetBank("dst_gi_nahida_illusory_heart_fx")
    inst.AnimState:PlayAnimation("idle",true)


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
    inst.Transform:SetScale(1.8, 1.8, 1.8)

    -- 添加高亮组件，使其可以在高亮时显示
    inst:AddComponent("highlightchild")
    inst:AddComponent("dst_gi_nahida_illusory_heart_data")
    -- 设置实体为原始状态
    inst.entity:SetPristine()

    -- 如果不是主服务器，直接返回实体
    if not TheWorld.ismastersim then
        return inst
    end
    inst.light = nil
    -- 添加颜色附加组件，用于颜色效果
    inst:AddComponent("colouradder")

    return inst
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetRadius(23)
    inst.Light:SetFalloff(.75)
    inst.Light:SetIntensity(.65)
    inst.Light:SetColour(200 / 255, 255 / 255, 200 / 255)  -- 带点点绿光

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("fx_dst_gi_nahida_illusory_heart_fx", fn, assets),
Prefab("dst_gi_nahida_illusory_heart_light", lightfn)