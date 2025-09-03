---
--- dst_gi_nahida_toy_desk_data.lua
--- Description: 抽卡机
--- Author: 没有小钱钱
--- Date: 2025/5/10 16:37
---
-- 定义动画和资源
local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_gacha_machine.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_gacha_machine_8x9.zip"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_gacha_machine.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_gacha_machine.tex"),
    Asset("ATLAS", "images/map_icons/dst_gi_nahida_gacha_machine.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/map_icons/dst_gi_nahida_gacha_machine.tex"),
}

local function OnHammered(inst, digger)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function workmultiplierfn(inst, worker, numworks)
    if worker and worker:HasTag("player") then
        return 1
    end
    return 0
end


local function onopen(inst)
    if not inst:HasTag("burnt") then
        --inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        --inst.AnimState:PlayAnimation("close")
        --inst.AnimState:PushAnimation("closed", false)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end
end

local function GachaMachineWish(inst, data)
    if data.doer and inst.components.dst_gi_nahida_actions_data then
        local inventory = data.doer.components and data.doer.components.inventory
        if inventory then
            local item = inventory:FindItem(function(item)
                return item.prefab == "dst_gi_nahida_intertwined_fate" or item.prefab == "dst_gi_nahida_acquaint_fate"
            end)
            if item then
                -- 这里可以做消耗、奖励等操作
                inst.components.dst_gi_nahida_actions_data:DrawCard(data.doer, inst, item)
            end
        end
    end
end

local function PrintContainerItems(inst)
    if inst.components.container ~= nil then
        local items = inst.components.container.slots
        print("==== 容器物品分布 ====")
        for idx = 1, inst.components.container.numslots do
            local item = items[idx]
            if item then
                print(string.format("格子%d: %s x%d", idx, item.prefab, item.components.stackable and item.components.stackable:StackSize() or 1))
            end
        end
        print("==== 结束 ====")
    end
end


local SAVE_SLOTS = {9, 18, 27, 36}   -- 保存区slot索引
local DEL_SLOTS  = {45, 54, 63, 72}  -- 删除区slot索引

-- 统计指定格子的物品类型
local function get_types_in_slots(slots, items)
    local types = {}
    for _, idx in ipairs(slots) do
        local item = items[idx]
        if item then
            types[item.prefab] = true
        end
    end
    return types
end

local function has_item_in_slots(slots, items)
    for _, idx in ipairs(slots) do
        if items[idx] then
            return true
        end
    end
    return false
end

-- 返回重叠的物品类型集合
local function get_type_overlap(types1, types2)
    local overlap = {}
    for k in pairs(types1) do
        if types2[k] then
            overlap[k] = true
        end
    end
    return overlap
end

local function GachaMachineDrop(inst, data)
    if inst.components.container ~= nil then
        local items = inst.components.container.slots

        local has_save = has_item_in_slots(SAVE_SLOTS, items)
        local has_del  = has_item_in_slots(DEL_SLOTS, items)

        local save_types = get_types_in_slots(SAVE_SLOTS, items)
        local del_types  = get_types_in_slots(DEL_SLOTS, items)
        local overlap_types = get_type_overlap(save_types, del_types) -- 需要跳过的类型

        if has_del then
            -- 删除区有物品，只删除“删除区同类型”的物品，且跳过重叠类型
            local to_remove = {}
            for idx, item in pairs(items) do
                if item and del_types[item.prefab] and not overlap_types[item.prefab] then
                    table.insert(to_remove, item)
                end
            end
            for _, item in ipairs(to_remove) do
                item:Remove()
            end
        elseif has_save then
            -- 保存区有物品，只保留“保存区同类型”的物品，其余全部删除，且跳过重叠类型
            local to_remove = {}
            for idx, item in pairs(items) do
                if item and not save_types[item.prefab] and not overlap_types[item.prefab] then
                    table.insert(to_remove, item)
                end
            end
            for _, item in ipairs(to_remove) do
                item:Remove()
            end
        else
            -- 默认全部删除
            for _, item in pairs(items) do
                if item then
                    item:Remove()
                end
            end
        end
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:AddTag("structure")
    inst:AddTag("shoreonsink")     --不掉深渊
    inst:AddTag("tornado_nosucky") --mod兼容：永不妥协。不会被龙卷风刮走
    inst:AddTag("hide_percentage") -- 隐藏百分比
    inst:AddTag("nosteal")         -- 防偷取

    -- 设置第一个动画
    inst.AnimState:SetBuild("dst_gi_nahida_gacha_machine")
    inst.AnimState:SetBank("dst_gi_nahida_gacha_machine")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(0.8, 0.8, 0.8)
    -- 设置部署半径
    inst:SetDeploySmartRadius(0.25) --recipe min_spacing/2
    RemovePhysicsColliders(inst)

    inst.MiniMapEntity:SetIcon("dst_gi_nahida_gacha_machine.tex")

    -- 设置实体为原始状态
    inst.entity:SetPristine()

    -- 如果不是主服务器，直接返回实体
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable.workmultiplierfn = workmultiplierfn

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("dst_gi_nahida_gacha_machine")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst:ListenForEvent("dst_gi_nahida_gacha_machine_wish",GachaMachineWish)
    inst:ListenForEvent("dst_gi_nahida_gacha_machine_drop",GachaMachineDrop)

    -- 添加掉落物组件
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "boards", "goldnugget", "transistor" })

    MakeHauntableLaunchAndDropFirstItem(inst)

    inst:SetStateGraph("SGDstGiNahidaGachaMachine")
    if inst.sg ~= nil then
        inst.sg:GoToState("dst_gi_nahida_gacha_machine_idle")
    end

    return inst
end

return Prefab("dst_gi_nahida_gacha_machine", fn, assets),
MakePlacer("dst_gi_nahida_gacha_machine_placer", "dst_gi_nahida_gacha_machine", "dst_gi_nahida_gacha_machine", "idle")