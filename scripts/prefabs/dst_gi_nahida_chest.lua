---
--- dst_gi_nahida_chest.lua
--- Description: 纳西妲的箱子
--- Author: 没有小钱钱
--- Date: 2025/4/24 21:53
---

local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_treasure_chest.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_luxurious_chest.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_chest_5x6.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_toy_chest.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_chest_toy_5x6.zip"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_spore_slot.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_spore_slot.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_treasure_chest.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_treasure_chest.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_toy_chest.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_toy_chest.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_luxurious_chest.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_luxurious_chest.xml"),
    Asset("ATLAS", "images/map_icons/dst_gi_nahida_treasure_chest.xml"), -- 椰子树物品栏贴图
    Asset("IMAGE", "images/map_icons/dst_gi_nahida_treasure_chest.tex"), -- 椰子树物品栏图像
    Asset("ATLAS", "images/map_icons/dst_gi_nahida_toy_chest.xml"), -- 玩具箱物品栏贴图
    Asset("IMAGE", "images/map_icons/dst_gi_nahida_toy_chest.tex"), -- 玩具箱物品栏图像
}

local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("close")
        inst.AnimState:PushAnimation("closed", false)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
        if inst.components.container ~= nil then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
    end
end

--V2C: also used for restoredfromcollapsed
local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")
end

local function onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function getstatus(inst, viewer)
    return inst._chestupgrade_stacksize and "UPGRADED_STACKSIZE" or nil
end

local function upgrade_onhit(inst, worker)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything(nil, true)
        inst.components.container:Close()
    end
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", false)
end

local function OnRestoredFromCollapsed(inst)
    inst.AnimState:PlayAnimation("rebuild")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")
end

local function ShouldCollapse(inst)
    if inst.components.container and inst.components.container.infinitestacksize then
        --NOTE: should already have called DropEverything(nil, true) (worked or deconstructed)
        --      so everything remaining counts as an "overstack"
        local overstacks = 0
        for k, v in pairs(inst.components.container.slots) do
            local stackable = v.components.stackable
            if stackable then
                overstacks = overstacks + math.ceil(stackable:StackSize() / (stackable.originalmaxsize or stackable.maxsize))
                if overstacks >= TUNING.COLLAPSED_CHEST_EXCESS_STACKS_THRESHOLD then
                    return true
                end
            end
        end
    end
    return false
end

local function ConvertToCollapsed(inst, droploot)
    local x, y, z = inst.Transform:GetWorldPosition()
    if droploot then
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(x, y, z)
        fx:SetMaterial("wood")
        inst.components.lootdropper.min_speed = 2.25
        inst.components.lootdropper.max_speed = 2.75
        inst.components.lootdropper:DropLoot()
        inst.components.lootdropper.min_speed = nil
        inst.components.lootdropper.max_speed = nil
    end

    inst.components.container:Close()
    inst.components.workable:SetWorkLeft(2)

    local pile = SpawnPrefab("collapsed_dragonflychest")
    pile.Transform:SetPosition(x, y, z)
    pile:SetChest(inst)
end

local function upgrade_onhammered(inst, worker)
    if ShouldCollapse(inst) then
        if TheWorld.Map:IsPassableAtPoint(inst.Transform:GetWorldPosition()) then
            inst.components.container:DropEverythingUpToMaxStacks(TUNING.COLLAPSED_CHEST_MAX_EXCESS_STACKS_DROPS)
            if not inst.components.container:IsEmpty() then
                ConvertToCollapsed(inst, true)
                return
            end
        else
            --sunk, drops more, but will lose the remainder
            inst.components.lootdropper:DropLoot()
            inst.components.container:DropEverythingUpToMaxStacks(TUNING.COLLAPSED_CHEST_EXCESS_STACKS_THRESHOLD)
            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            fx:SetMaterial("wood")
            inst:Remove()
            return
        end
    end

    --fallback to default
    onhammered(inst, worker)
end

local function OnUpgrade(inst, performer, upgraded_from_item)
    local numupgrades = inst.components.upgradeable.numupgrades
    if numupgrades == 1 then
        inst._chestupgrade_stacksize = true
        if inst.components.container ~= nil then
            -- NOTES(JBK): The container component goes away in the burnt load but we still want to apply builds.
            inst.components.container:Close()
            inst.components.container:EnableInfiniteStackSize(true)
            inst.components.inspectable.getstatus = getstatus
        end
    end
    inst.components.upgradeable.upgradetype = nil

    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot({ "alterguardianhatshard" })
    end
    inst.components.workable:SetOnWorkCallback(upgrade_onhit)
    inst.components.workable:SetOnFinishCallback(upgrade_onhammered)
    inst:ListenForEvent("restoredfromcollapsed", OnRestoredFromCollapsed)
end

local function onload(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil then
        inst.components.burnable.onburnt(inst)
    end
    if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
        OnUpgrade(inst)
    end
end

local function workmultiplierfn(inst, worker, numworks)
    if worker and worker:HasTag("player") then
        return 1
    end
    return 0
end

local function MakeChest(name, bank, build, enableInfiniteStackSize)

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        inst.MiniMapEntity:SetIcon(name .. ".tex")

        inst:AddTag("structure")
        inst:AddTag("chest")
        inst:AddTag("nosteal")           --防止被火药猴偷走
        inst:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NO_STEAL) -- 不会被火药猴偷取
        inst:AddTag("NORATCHECK") -- 新增：永不妥协模组专用防偷标签

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("closed")
        -- 设置部署半径
        --MakeObstaclePhysics(inst, 0.1)
        inst:SetDeploySmartRadius(0.25) --recipe min_spacing/2
        RemovePhysicsColliders(inst)

        MakeSnowCoveredPristine(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("container")
        inst.components.container:WidgetSetup(name)
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

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        inst:ListenForEvent("onbuilt", onbuilt)
        MakeSnowCovered(inst)

        if enableInfiniteStackSize then
            inst.components.container:EnableInfiniteStackSize(true)
        else
            local upgradeable = inst:AddComponent("upgradeable")
            upgradeable.upgradetype = UPGRADETYPES.CHEST
            upgradeable:SetOnUpgradeFn(OnUpgrade)
        end

        -- Save / load is extended by some prefab variants
        inst.OnSave = onsave
        inst.OnLoad = onload

        return inst
    end

    return Prefab(name, fn, assets)
end

--DST_GI_NAHIDA_API.MakeItemSkin("dst_gi_nahida_treasure_chest", "dst_gi_nahida_luxurious_chest", {
--    name = STRINGS.NAMES.DST_GI_NAHIDA_TREASURE_CHEST,
--    atlas = "images/inventoryimages/dst_gi_nahida_luxurious_chest.xml",
--    image = "dst_gi_nahida_luxurious_chest",
--    build = "dst_gi_nahida_luxurious_chest",
--    bank = "dst_gi_nahida_luxurious_chest"
--})

return MakeChest("dst_gi_nahida_treasure_chest", "dst_gi_nahida_treasure_chest", "dst_gi_nahida_treasure_chest",false),
MakePlacer("dst_gi_nahida_treasure_chest_placer", "dst_gi_nahida_treasure_chest", "dst_gi_nahida_treasure_chest", "closed"),
-- 玩具箱
MakeChest("dst_gi_nahida_toy_chest", "dst_gi_nahida_toy_chest", "dst_gi_nahida_toy_chest",true),
MakePlacer("dst_gi_nahida_toy_chest_placer", "dst_gi_nahida_toy_chest", "dst_gi_nahida_toy_chest", "closed")