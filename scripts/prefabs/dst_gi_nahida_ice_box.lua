---
--- dst_gi_nahida_ice_box.lua
--- Description: 冰箱
--- Author: 没有小钱钱
--- Date: 2025/5/4 20:49
---

require "prefabutil"

local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_ice_box.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_ice_box2.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_chest_ice_5x6.zip"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_ice_box.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_ice_box.tex"),

    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_ice_box2.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_ice_box2.tex"),
    Asset("ATLAS", "images/map_icons/dst_gi_nahida_ice_box.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/map_icons/dst_gi_nahida_ice_box.tex"),
}

local prefabs = {
    "collapse_small",
}

local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("close")
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_close")
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.components.container:DropEverything()
    inst.AnimState:PushAnimation("closed", false)
    inst.components.container:Close()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/icebox_craft")
end

local function OnUpgrade(inst, player, upgraded_from_item)
    if inst.components.dst_gi_nahida_ice_box_data then
        inst.components.dst_gi_nahida_ice_box_data:Upgrade(upgraded_from_item)
    end
end

local function CanUpgrade(inst, player, item)
    if inst.components.dst_gi_nahida_ice_box_data and item then
        return inst.components.dst_gi_nahida_ice_box_data:CanUpgrade(item)
    end
    return false
end

local function OnLoad(inst, data, newents)
    if inst.components.dst_gi_nahida_ice_box_data ~= nil  then
        --inst.components.dst_gi_nahida_ice_box_data:Init()
        inst.net_preserver_upgrade:set(tostring(inst.components.dst_gi_nahida_ice_box_data.preserver_upgrade))
        inst.net_chestupgrade_stacksize:set(tostring(inst.components.dst_gi_nahida_ice_box_data._chestupgrade_stacksize))
    end
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

    --MakeObstaclePhysics(inst, 0.5)
    inst:SetDeploySmartRadius(0.25) --recipe min_spacing/2
    RemovePhysicsColliders(inst)

    inst.MiniMapEntity:SetIcon("dst_gi_nahida_ice_box.tex")

    inst:AddTag("fridge")
    inst:AddTag("structure")
    inst:AddTag("nosteal")           --防止被火药猴偷走
    inst:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NO_STEAL) -- 不会被火药猴偷取
    inst:AddTag("NORATCHECK") -- 新增：永不妥协模组专用防偷标签

    inst.AnimState:SetBank("dst_gi_nahida_ice_box")
    inst.AnimState:SetBuild("dst_gi_nahida_ice_box")
    inst.AnimState:PlayAnimation("closed")

    inst.SoundEmitter:PlaySound("dontstarve/common/ice_box_LP", "idlesound")

    MakeSnowCoveredPristine(inst)

    inst.net_preserver_upgrade = net_string(inst.GUID, "net_preserver_upgrade")
    inst.net_chestupgrade_stacksize = net_string(inst.GUID, "net_chestupgrade_stacksize")

    inst.entity:SetPristine()

    local old_GetDisplayName = inst.GetDisplayName
    inst.GetDisplayName = function(self,...)
        local str = ""
        str = str.."\r\n"..STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_PRESERVER_UPGRADE..":"..tostring(inst.net_preserver_upgrade:value() or "N/A")
        str = str.."\r\n"..STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_STACKSIZE_UPGRADE..":"..tostring(inst.net_chestupgrade_stacksize:value() or "N/A")
        return old_GetDisplayName(self,...)
                ..str
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("dst_gi_nahida_ice_box")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true
    -- 防止永不妥协老鼠偷东西，必须带有容器的实体
    NhidaDropOneItemWithTag(inst)

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
    inst.components.workable.workmultiplierfn = workmultiplierfn

    inst:AddComponent("dst_gi_nahida_ice_box_data")
    inst.components.dst_gi_nahida_ice_box_data:Init() -- 初始化保鲜倍率

    inst:ListenForEvent("onbuilt", onbuilt)
    MakeSnowCovered(inst)

    AddHauntableDropItemOrWork(inst)

    local upgradeable = inst:AddComponent("upgradeable")
    upgradeable.upgradetype = UPGRADETYPES.CHEST
    upgradeable:SetOnUpgradeFn(OnUpgrade)

    -- 重写升级方法，进行判断
    local OldUpgrade = upgradeable.Upgrade
    upgradeable.Upgrade = function(self, obj, upgrade_performer)
        if CanUpgrade(self.inst, upgrade_performer, obj) then
            local upgrade = OldUpgrade(self, obj, upgrade_performer)
            return upgrade
        end
        return false
    end

    -- This chest cannot burn.
    inst.OnLoad = OnLoad

    return inst
end

DST_GI_NAHIDA_API.MakeItemSkin("dst_gi_nahida_ice_box", "dst_gi_nahida_ice_box2", {
    name = STRINGS.NAMES.DST_GI_NAHIDA_ICE_BOX,
    atlas = "images/inventoryimages/dst_gi_nahida_ice_box2.xml",
    image = "dst_gi_nahida_ice_box2",
    build = "dst_gi_nahida_ice_box2",
    bank = "dst_gi_nahida_ice_box"
})

return Prefab("dst_gi_nahida_ice_box", fn, assets, prefabs),
MakePlacer("dst_gi_nahida_ice_box_placer", "dst_gi_nahida_ice_box", "dst_gi_nahida_ice_box", "closed")
