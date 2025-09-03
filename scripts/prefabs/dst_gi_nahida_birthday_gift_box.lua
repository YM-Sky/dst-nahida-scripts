---
--- dst_gi_nahida_birthday_gift_box.lua
--- Description: 纳西妲的生日礼盒
--- Author: 没有小钱钱
--- Date: 2025/5/5 16:08
---
---
local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_birthday_gift_box.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_chest_birthday_gift_box_5x6.zip"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_birthday_gift_box.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_birthday_gift_box.xml")
}

local canttags = { "INLIMBO", "NOCLICK", "catchable", "fire", "notdevourable", "singingshell" } -- 不该检索的标签列表

-- 定义物品被丢弃时的行为
local function ondropped(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

local function ConvertItemsToGold(inst, data)
    if inst.components.container ~= nil then
        local items = inst.components.container.slots
        local total_gold_value = 0
        local max_stack_size = 4096
        local max_slots = 30  -- 容器有30个格子
        -- 计算总价值并检查容器容量
        for _, item in pairs(items) do
            if item.components.tradable ~= nil then
                local gold_value = item.components.tradable.goldvalue
                local stack_size = item.components.stackable ~= nil and item.components.stackable:StackSize() or 1
                local item_value = gold_value * stack_size
                -- 检查是否超过容器容量
                if total_gold_value + item_value > max_stack_size * max_slots then
                    break
                end
                total_gold_value = total_gold_value + item_value
                if gold_value > 0 then
                    item:Remove()
                end
            end
        end
        -- 关闭容器
        inst.components.container:Close()
        -- 生成多个堆叠的金子
        while total_gold_value > 0 do
            local stack_size = math.min(total_gold_value, max_stack_size)
            local nug = SpawnPrefab("goldnugget")
            if nug.components.stackable ~= nil then
                nug.components.stackable:SetStackSize(stack_size)
            end
            if not inst.components.container:GiveItem(nug) then
                -- 如果容器已满，停止生成
                nug:Remove()
                break
            end
            total_gold_value = total_gold_value - stack_size
        end
    end
end

local function Gather(inst, data)
    if inst.components.container ~= nil and data.doer then
        -- 获取当前实体的位置
        local x, y, z = data.doer.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 15, nil, canttags)
        for i, ent in ipairs(ents) do
            if NahidaIsTrinket(ent) then
                local success = inst.components.container:GiveItem(ent)
                if not success then
                    -- 容器满了，丢地上
                    ent.Transform:SetPosition(x, y, z)
                end
            end
        end
    end
end


local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    -- 设置物理属性，使其可以被拾取
    MakeInventoryPhysics(inst)

    inst:AddTag("chest")
    inst:AddTag("dst_gi_nahida_birthday_gift_box")
    inst:AddTag("shoreonsink")     --不掉深渊
    inst:AddTag("tornado_nosucky") --mod兼容：永不妥协。不会被龙卷风刮走
    inst:AddTag("hide_percentage") -- 隐藏百分比
    inst:AddTag("nosteal")           --防止被火药猴偷走
    inst:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NO_STEAL) -- 不会被火药猴偷取
    inst:AddTag("NORATCHECK") -- 新增：永不妥协模组专用防偷标签

    inst.AnimState:SetBank("dst_gi_nahida_birthday_gift_box")
    inst.AnimState:SetBuild("dst_gi_nahida_birthday_gift_box")
    inst.AnimState:PlayAnimation("idle")
    inst.entity:SetPristine()
    -- 设置浮动属性
    MakeInventoryFloatable(inst)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = true
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dst_gi_nahida_birthday_gift_box.xml"
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)


    inst:AddComponent("container")
    inst.components.container:WidgetSetup("dst_gi_nahida_birthday_gift_box")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true
    inst.components.container:EnableInfiniteStackSize(true)

    inst.components.container.DropItem = function(self,itemtodrop, wholestack)
        local x, y, z = self.inst.Transform:GetWorldPosition()
        if wholestack and itemtodrop.components.stackable then
            -- 丢出整个堆叠
            local item = self:RemoveItem(itemtodrop, true) -- RemoveItem支持wholestack参数
            if item then
                item.Transform:SetPosition(x, y, z)
                if item.components.inventoryitem then
                    item.components.inventoryitem:OnDropped(true)
                end
                item.prevcontainer = nil
                item.prevslot = nil
                self.inst:PushEvent("dropitem", {item = item})
            end
            return item
        else
            -- 原有逻辑
            self:DropItemAt(itemtodrop, x, y, z)
        end
    end
    --
    local function OnItemGet(inst, data)
        if data and data.item then
            local item = data.item
            if item.prefab ~= "goldnugget" and (item.components.tradable == nil or
                    item.components.tradable.goldvalue == nil or
                    item.components.tradable.goldvalue <= 0)
                and not item:HasTag("dst_gi_nahida_weapons")
                and not item:HasTag("dst_gi_nahida_thousand_floating_dreams_follower")
            then
                inst.components.container:DropItem(item, true) -- 丢出整个堆叠
            end
        end
    end

    --🔥 监听容器变化事件来动态更新投射物
    inst:ListenForEvent("itemget", OnItemGet)

    --inst.components.container.CanTakeItemInSlot = function(item, slot)
    --    -- 禁止装进任何有容器组件的物品，防止无限嵌套
    --    print("禁止装进任何有容器组件的物品，防止无限嵌套 8888888888888888888888")
    --    if item.components.container ~= nil then
    --        return false
    --    end
    --    if item.components.tradable == nil then
    --        print("物品无tradable 组件")
    --        return false
    --    end
    --    if item.components.tradable.goldvalue == nil then
    --        print("物品无goldvalue 组件")
    --        return false
    --    end
    --    if item.components.tradable.goldvalue <= 0 then
    --        print("物品goldvalue = 0 组件")
    --        return false
    --    end
    --    return OldCanTakeItemInSlot(item, slot)
    --end
    -- 防止永不妥协老鼠偷东西，必须带有容器的实体
    NhidaDropOneItemWithTag(inst)

    MakeHauntableLaunchAndDropFirstItem(inst)

    inst:ListenForEvent("dst_gi_nahida_birthday_gift_box_one_click_conversion",ConvertItemsToGold)
    inst:ListenForEvent("dst_gi_nahida_birthday_gift_box_nahida_gather",Gather)

    return inst
end

return Prefab("dst_gi_nahida_birthday_gift_box", fn, assets)