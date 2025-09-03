---
--- dst_gi_nahida_dendro_core.lua
--- Description: 草原核
--- Author: 没有小钱钱
--- Date: 2025/5/5 18:41
---
-- 定义动画和资源
local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_dendro_core.zip")
}
local COLOUR_R, COLOUR_G, COLOUR_B = 227/255, 227/255, 227/255
local ZERO_VEC = Vector3(0,0,0)

local function onworked(inst, worker)
    inst:PushEvent("pop")
    inst:RemoveTag("spore")
end

-- 动画完全结束，开始爆炸
local function onpopped(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
    if inst.components.dst_gi_nahida_dendro_core_data then
        inst.components.dst_gi_nahida_dendro_core_data:BalloonPop()
    end
end

local function onload(inst)
    -- If we loaded, then just turn the light on
    inst.Light:Enable(true)
    inst.DynamicShadow:Enable(true)
end

local function fn()
    local inst = CreateEntity()

    -- 添加实体的基本组件
    inst.entity:AddTransform() -- 位置和旋转
    inst.entity:AddAnimState() -- 动画状态
    inst.entity:AddSoundEmitter() -- 声音发射器
    inst.entity:AddDynamicShadow() -- 动态阴影
    inst.entity:AddLight() -- 光源
    inst.entity:AddNetwork() -- 网络同步
    MakeInventoryPhysics(inst)

    -- 设置动画和外观
    inst.AnimState:SetBuild("dst_gi_nahida_dendro_core") -- 设置动画构建
    inst.AnimState:SetBank("dst_gi_nahida_dendro_core") -- 设置动画银行
    --inst.AnimState:PlayAnimation("idle_flight_loop", true) -- 播放动画
    inst.DynamicShadow:Enable(false) -- 禁用动态阴影

    -- 设置光源属性
    inst.Light:SetColour(COLOUR_R, COLOUR_G, COLOUR_B) -- 设置光的颜色
    inst.Light:SetIntensity(0.5) -- 设置光的强度
    inst.Light:SetFalloff(0.75) -- 设置光的衰减
    inst.Light:SetRadius(0.5) -- 设置光的半径
    inst.Light:Enable(false) -- 禁用光源

    inst.DynamicShadow:SetSize(.8, .5) -- 设置动态阴影的大小

    inst:AddTag("spore") -- 添加标签
    inst:AddTag("dst_gi_nahida_dendro_core") -- 添加标签

    inst.entity:SetPristine() -- 设置实体为原始状态
    if not TheWorld.ismastersim then
        return inst -- 如果不是主模拟器，返回实体
    end

    inst.light = nil

    -- 设置 Scrapbook 动画属性
    inst.scrapbook_anim = "idle_flight_loop"
    inst.scrapbook_animoffsety = 65
    inst.scrapbook_animpercent = 0.36

    -- 添加可检查组件
    inst:AddComponent("inspectable")

    -- 添加可工作组件
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET) -- 设置工作动作为网捕
    inst.components.workable:SetWorkLeft(1) -- 设置剩余工作量
    inst.components.workable:SetOnFinishCallback(onworked) -- 设置完成回调

    -- 添加可燃烧组件
    inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(1) -- 设置燃烧效果等级
    inst.components.burnable:SetBurnTime(1) -- 设置燃烧时间
    inst.components.burnable:AddBurnFX("fire", ZERO_VEC, "spore_body") -- 添加燃烧效果
    inst.components.burnable:SetOnIgniteFn(DefaultBurnFn)
    inst.components.burnable:SetOnBurntFn(DefaultBurntFn)
    inst.components.burnable:SetOnExtinguishFn(DefaultExtinguishFn)

    -- 添加传播器组件
    inst:AddComponent("propagator")
    inst.components.propagator.acceptsheat = true -- 接受热量
    inst.components.propagator:SetOnFlashPoint(DefaultIgniteFn) -- 设置闪点回调
    inst.components.propagator.flashpoint = 1 -- 设置闪点
    inst.components.propagator.decayrate = 0.5 -- 设置衰减率
    inst.components.propagator.damages = false -- 不造成伤害

    inst:AddComponent("dst_gi_nahida_dendro_core_data")

    -- 设置为可被鬼魂影响
    MakeHauntablePerish(inst, .5)
    -- 监听事件
    inst:ListenForEvent("popped", onpopped)
    -- 设置状态图
    inst:SetStateGraph("SGDstGiNahidaDendroCore")
    if inst.sg ~= nil then
        inst.sg:GoToState("takeoff")
    end

    inst.OnLoad = onload -- 设置加载回调

    return inst
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetRadius(1)
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

return Prefab("dst_gi_nahida_dendro_core", fn, assets),
Prefab("dst_gi_nahida_dendro_core_light", lightfn)