---
--- dst_gi_nahida_coconut.lua
--- Description: 椰子
--- Author: 没有小钱钱
--- Date: 2025/5/1 0:51
---

local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_coconut.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_coconut_build.zip"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_coconut.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_coconut.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_coconut_meat.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_coconut_meat.tex"),
    Asset("ATLAS", "images/map_icons/dst_gi_nahida_coconut_tree.xml"), -- 椰子树物品栏贴图
    Asset("IMAGE", "images/map_icons/dst_gi_nahida_coconut_tree.tex"), -- 椰子树物品栏图像

}

local function dig_sprout(inst, digger)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function onDeployCoconut(inst, pt, deployer)
    local tree = SpawnPrefab("dst_gi_nahida_coconut_spring")  -- 暂时使用原版的树作为种植后的物品
    if tree ~= nil then
        tree.Transform:SetPosition(pt:Get())
        inst:Remove()  -- 移除树苗物品
    end
end

local function grow_anim_over(inst)
    -- Spawn a bush where the seed grew, and remove the seed prefab.
    local seedx, seedy, seedz = inst.Transform:GetWorldPosition()
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    inst:Remove()

    local bush = SpawnPrefab("dst_gi_nahida_coconut_bush")
    bush.Transform:SetPosition(seedx, seedy, seedz)
end

local function on_grow_timer_done(inst, data)
    if data.name ~= "grow" then
        return
    end
    inst:ListenForEvent("animover", grow_anim_over)
    inst.AnimState:PlayAnimation("seed_grow")
end

local function stop_sprout_growing(inst)
    if inst.components.timer ~= nil then
        inst.components.timer:StopTimer("grow")
    end
end

local function start_sprout_growing(inst)
    if inst.components.timer ~= nil and not inst.components.timer:TimerExists("grow") then
        --inst.components.timer:StartTimer("grow", 60*8) -- 使用石果树成长时间，5天
        inst.components.timer:StartTimer("grow", TUNING.ROCK_FRUIT_SPROUT_GROWTIME) -- 使用石果树成长时间，5天
    end
end

-- 椰子
local function coconutFn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)                   --漂浮

    inst.AnimState:SetBank("dst_gi_nahida_coconut") --地上动画
    inst.AnimState:SetBuild("dst_gi_nahida_coconut")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(0.8, 0.8, 0.8)

    inst:AddTag("shoreonsink")     --不掉深渊
    inst:AddTag("tornado_nosucky") --mod兼容：永不妥协。不会被龙卷风刮走
    inst:AddTag("hide_percentage") -- 隐藏百分比
    inst:AddTag("nosteal")         -- 防偷取

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dst_gi_nahida_coconut.xml"

    -- 添加堆叠组件
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM -- 你可以根据需要调整堆叠大小

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = onDeployCoconut
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)

    MakeHauntableLaunchAndDropFirstItem(inst)


    return inst
end

-- 椰子树苗
local function coconutSpringFn()
    local inst = CreateEntity()

    -- 添加实体的基本组件
    inst.entity:AddTransform() -- 位置和旋转
    inst.entity:AddSoundEmitter() -- 声音
    inst.entity:AddAnimState() -- 动画
    inst.entity:AddMiniMapEntity() -- 小地图图标
    inst.entity:AddNetwork() -- 网络同步

    -- 设置动画资源
    inst.AnimState:SetBank("dst_gi_nahida_coconut_spring") -- 动画银行
    inst.AnimState:SetBuild("dst_gi_nahida_coconut_build") -- 动画构建
    inst.AnimState:PlayAnimation("idle") -- 播放初始动画

    -- 设置部署半径
    inst:SetDeploySmartRadius(0.25) --recipe min_spacing/2
    RemovePhysicsColliders(inst)

    -- 设置预制体名称覆盖
    inst:SetPrefabNameOverride("DST_GI_NAHIDA_COCONUT_SPRING")

    -- 设置小地图图标
    inst.MiniMapEntity:SetIcon("dst_gi_nahida_coconut_tree.tex")

    -- 设置 Scrapbook 动画和依赖
    inst.scrapbook_anim = "idle"
    inst.scrapbook_adddeps = { "dst_gi_nahida_coconut_bush" }

    -- 设置实体为原始状态
    inst.entity:SetPristine()

    -- 如果不是主服务器，返回实体
    if not TheWorld.ismastersim then
        return inst
    end

    -- 添加可检查组件
    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "dst_gi_nahida_coconut_spring"

    -- 添加掉落物组件
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"dst_gi_nahida_coconut"})

    -- 添加可工作组件
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG) -- 设置工作动作为挖掘
    inst.components.workable:SetOnFinishCallback(dig_sprout) -- 设置完成回调
    inst.components.workable:SetWorkLeft(1) -- 设置工作量

    -- 添加计时器组件
    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", on_grow_timer_done) -- 监听计时器完成事件

    -- 设置可燃烧和传播火焰
    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    inst.components.burnable:SetOnIgniteFn(stop_sprout_growing) -- 设置点燃时的回调
    inst.components.burnable:SetOnExtinguishFn(start_sprout_growing) -- 设置熄灭时的回调
    MakeSmallPropagator(inst)

    -- 设置可被鬼魂影响
    MakeHauntableIgnite(inst)

    -- 开始生长计时
    start_sprout_growing(inst)

    return inst
end


return Prefab("dst_gi_nahida_coconut", coconutFn, assets),
Prefab("dst_gi_nahida_coconut_spring", coconutSpringFn, assets),
MakePlacer("dst_gi_nahida_coconut_placer", "dst_gi_nahida_coconut_spring", "dst_gi_nahida_coconut_build","idle")
