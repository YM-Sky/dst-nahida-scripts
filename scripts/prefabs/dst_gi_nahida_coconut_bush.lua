---
--- dst_gi_nahida_coconut.lua
--- Description: 椰子
--- Author: 没有小钱钱
--- Date: 2025/5/1 0:51
---

-- 定义资源
local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_coconut.zip"), -- 动画资源
    Asset("ANIM", "anim/dst_gi_nahida_coconut_build.zip"), -- 动画构建资源
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_coconut.xml"), -- 物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_coconut.tex"), -- 物品栏图像
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_coconut_meat.xml"), -- 椰子肉物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_coconut_meat.tex"), -- 椰子肉物品栏图像
    Asset("ATLAS", "images/map_icons/dst_gi_nahida_coconut_tree.xml"), -- 椰子树物品栏贴图
    Asset("IMAGE", "images/map_icons/dst_gi_nahida_coconut_tree.tex"), -- 椰子树物品栏图像

}

-- 采摘后的回调函数
local function onpickedfn(inst, picker)
    inst.AnimState:PlayAnimation("picked") -- 播放采摘动画
    inst.components.growable:SetStage(1) -- 重置生长阶段
    inst.AnimState:PushAnimation("idle1", false) -- 返回到空闲动画
    inst.components.growable:StartGrowing() -- 重新开始生长计时
end

-- 再生回调函数
local function onregenfn(inst)
    -- 直接设置为可收获阶段，而不调用 SetStage
    if inst.components.growable.stage ~= 2 then
        inst.components.growable:SetStage(2)
    end
end

-- 灌木丛被烧毁的回调函数
local function on_bush_burnt(inst)
    inst.components.lootdropper:SpawnLootPrefab("charcoal") -- 掉落木炭
    inst.components.lootdropper:SpawnLootPrefab("charcoal") -- 掉落木炭
    if inst.components.growable.stage == 2 then
        inst.components.lootdropper:SpawnLootPrefab("dst_gi_nahida_coconut")
        inst.components.lootdropper:SpawnLootPrefab("dst_gi_nahida_coconut")
        inst.components.lootdropper:SpawnLootPrefab("dst_gi_nahida_coconut")
    end
    inst.components.growable:StopGrowing() -- 停止生长
    inst:Remove() -- 移除实体
end

-- 灌木丛被砍伐的回调函数
local function on_chopped(inst, chopper)
    inst.components.lootdropper:SpawnLootPrefab("log") -- 掉落木头
    inst.components.lootdropper:SpawnLootPrefab("log") -- 掉落木头
    if inst.components.growable.stage == 2 then
        inst.components.lootdropper:SpawnLootPrefab("dst_gi_nahida_coconut")
        inst.components.lootdropper:SpawnLootPrefab("dst_gi_nahida_coconut")
        inst.components.lootdropper:SpawnLootPrefab("dst_gi_nahida_coconut")
    end
    inst:Remove() -- 移除实体
end

local function on_save(inst, data)
    -- 保存当前的生长阶段
    data.stage = inst.components.growable:GetStage()
    -- 保存是否被点燃
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        data.burning = true
    end
end

local function on_load(inst, data)
    if data ~= nil then
        -- 恢复生长阶段
        if data.stage ~= nil then
            inst.components.growable:SetStage(data.stage)
        end
        -- 恢复点燃状态
        if data.burning then
            inst.components.burnable:Ignite()
        end
    end
end

-- 定义生长阶段
local growth_stages =
{
    {
        name = "stage_1",
        time = function(inst) return 60*8*2 end, -- 生长时间
        fn = function(inst)
            inst.components.pickable:ChangeProduct(nil)
            inst.components.pickable.canbepicked = false
            inst.AnimState:PlayAnimation("idle1")
        end,
        growfn = function(inst)
            inst.AnimState:PlayAnimation("idle1")
        end
    },
    {
        name = "stage_2",
        time = function(inst) return 60*8*7 end, -- 生长时间
        fn = function(inst)
            inst.components.pickable:ChangeProduct("dst_gi_nahida_coconut")
            inst.components.pickable.canbepicked = true -- 确保可以被采摘
            inst.AnimState:PlayAnimation("idle2")
        end,
        growfn = function(inst)
            inst.AnimState:PlayAnimation("idle2")
        end
    },
}

-- 椰子灌木丛的主函数
local function dst_gi_nahida_coconut_bush()
    local inst = CreateEntity()

    -- 添加基本组件
    inst.entity:AddTransform() -- 位置和旋转
    inst.entity:AddAnimState() -- 动画
    inst.entity:AddMiniMapEntity() -- 小地图图标
    inst.entity:AddNetwork() -- 网络同步

    -- 设置动画资源
    inst.AnimState:SetBank("dst_gi_nahida_coconut")
    inst.AnimState:SetBuild("dst_gi_nahida_coconut_build")
    inst.AnimState:PlayAnimation("idle1") -- 播放初始动画

    -- 设置部署半径
    inst:SetDeploySmartRadius(0.25) --recipe min_spacing/2
    RemovePhysicsColliders(inst)

    -- 设置小地图图标
    inst.MiniMapEntity:SetIcon("dst_gi_nahida_coconut_tree.tex")

    MakeSnowCoveredPristine(inst)

    -- 添加标签
    inst:AddTag("plant")
    inst:AddTag("renewable")
    inst:AddTag("tree") -- 添加树木标签
    inst:AddTag("choppable") -- 添加可砍伐标签
    inst:AddTag("pickable") -- 添加可砍伐标签

    -- 设置实体为原始状态
    inst.entity:SetPristine()

    -- 如果不是主服务器，返回实体
    if not TheWorld.ismastersim then
        return inst
    end

    -- 添加掉落物组件
    inst:AddComponent("lootdropper")

    -- 添加可采摘组件
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries" -- 采摘声音
    inst.components.pickable.onpickedfn = onpickedfn -- 采摘回调
    inst.components.pickable.onregenfn = onregenfn -- 再生回调
    inst.components.pickable.numtoharvest = 3 -- 可采摘数量
    inst.components.pickable.max_cycles = 2 -- 最大采摘周期
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles -- 剩余采摘周期

    -- 添加生长组件
    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages -- 生长阶段
    inst.components.growable:SetStage(1) -- 设置初始阶段
    inst.components.growable.loopstages = true
    inst.components.growable.springgrowth = true
    inst.components.growable.magicgrowable = true
    inst.components.growable:StartGrowing() -- 开始生长


    -- 添加可检查组件
    inst:AddComponent("inspectable")

    -- 添加可工作组件
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP) -- 设置工作动作为砍伐
    inst.components.workable:SetWorkLeft(2) -- 设置工作量为3次
    inst.components.workable:SetOnFinishCallback(on_chopped) -- 设置完成回调

    -- 设置可燃烧和传播火焰
    MakeMediumBurnable(inst)
    inst.components.burnable:SetOnBurntFn(on_bush_burnt) -- 设置烧毁回调

    inst.OnSave = on_save
    inst.OnLoad = on_load

    MakeMediumPropagator(inst)

    return inst
end

-- 返回定义的预制体
return Prefab("dst_gi_nahida_coconut_bush", dst_gi_nahida_coconut_bush, assets)