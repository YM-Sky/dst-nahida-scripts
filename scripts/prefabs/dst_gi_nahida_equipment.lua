---@diagnostic disable: undefined-global
---
--- dst_gi_nahida_equipment.lua
--- Description: 装备
--- Author: 没有小钱钱
--- Date: 2025/4/15 2:13
---
local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_equipment.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_dress_backpack.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_dress_backpack2.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_dress_backpack3.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_backpack_none1.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_backpack_none1_2.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_backpack_none1_3.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_backpack.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_backpack2.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_backpack3.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_dress_swap.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_dress_swap2.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_dress_swap3.zip"),
    Asset("ANIM", "anim/dst_gi_nahida_hairpin_swap.zip"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_spore_slot.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_spore_slot.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_hairpin.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_hairpin.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_dress.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_dress.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_dress2.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_dress2.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_dress3.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_dress3.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_backpack_none1.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_backpack_none1.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_backpack_none1_2.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_backpack_none1_2.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_backpack_none1_3.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_backpack_none1_3.xml"),
}

local function InitIndestructible(inst, damageData)
    if inst.components.armor then
        inst:RemoveComponent("armor")
    end
    inst:AddComponent("armor") -- 护甲
    if damageData then
        inst.components.armor:InitIndestructible((0.2 + damageData / 100))
    else
        inst.components.armor:InitIndestructible(0.2)
    end
end

-- 穿上装备
local function onequip_hairpin(inst, owner)
    if not owner:HasTag(TUNING.AVATAR_NAME) then
        owner:DoTaskInTime(0, function()
            owner.components.inventory:DropItem(inst)
            if inst.components.talker then
                inst.components.talker:Say("这不属于你")
            end
        end)
        return
    end
    owner.AnimState:OverrideSymbol("swap_hat", "dst_gi_nahida_hairpin", "swap_hat")
    -- 覆盖玩家的动画符号，使其显示为插件的外观
    if owner.components.dst_gi_nahida_data then
        local damageData = owner.components.dst_gi_nahida_data:GetDamageData()
        if damageData >= 70 then
            damageData = 70
        end
        InitIndestructible(inst,damageData)
    end
end

local function onunequip_hairpin(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    InitIndestructible(inst,nil)
end

-- 定义物品被丢弃时的行为
local function ondropped_hairpin(inst)
    InitIndestructible(inst,nil)
end

-- 定义装备到模型时的行为（通常用于展示）
local function onequiptomodel_hairpin(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    InitIndestructible(inst,nil)
end

local MakeDressFn = {
    dst_gi_nahida_dress = {
        fn = function(inst)
        end,
        onequip = function(inst,owner)
        end,
        onunequip = function(inst,owner)
        end,
    },
    dst_gi_nahida_dress2 = {
        fn = function(inst)
            inst:AddComponent("planardefense") -- 位面防御
            if inst.components.planardefense then
                inst.components.planardefense:SetBaseDefense(5) -- 位面防御
            end
        end,
        onequip = function(inst,owner)
            -- 装备时添加冰冻免疫
            if owner.components.freezable then
                -- 设置极高的冰冻抗性
                owner.components.freezable:SetResistance(999999)
            end
        end,
        onunequip = function(inst,owner)
            -- 卸下时恢复默认冰冻抗性
            if owner and owner.components.freezable then
                owner.components.freezable:SetResistance(1)
            end
        end,
    },
    dst_gi_nahida_dress3 = {
        fn = function(inst)
            inst:AddComponent("planardefense") -- 位面防御
            if inst.components.planardefense then
                inst.components.planardefense:SetBaseDefense(10) -- 位面防御
            end
        end,
        onequip = function(inst,owner)
            -- 装备时添加火焰免疫和冰冻免疫
            if owner.components.health then
                -- 设置火焰伤害倍数为0（完全免疫）
                owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 0)
            end
            if owner.components.freezable then
                -- 设置极高的冰冻抗性
                owner.components.freezable:SetResistance(999999)
            end
        end,
        onunequip = function(inst,owner)
            -- 卸下时移除火焰免疫和冰冻免疫
            if owner and owner.components.health then
                owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
            end
            if owner and owner.components.freezable then
                owner.components.freezable:SetResistance(1)
            end
        end,
    }
}

local function MakeDress(prefab, animstate, overridesymbol, container_size)
    -- 穿上装备
    local function onequip_dress(inst, owner)
        -- 覆盖玩家的动画符号，使其显示外观
        --owner.AnimState:OverrideSymbol("swap_body", overridesymbol, "swap_body")
        local skin_build = inst:GetSkinBuild()
        if skin_build ~= nil then
            owner:PushEvent("equipskinneditem", inst:GetSkinName())
            owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build,"swap_body", inst.GUID, "swap_body" )
        else
            owner.AnimState:OverrideSymbol("swap_body", overridesymbol, "swap_body")
        end
        if inst.components.container ~= nil then
            inst.components.container:Open(owner)
        end
        inst._nahida_owner = owner

        if MakeDressFn[prefab] and MakeDressFn[prefab].onequip then
            MakeDressFn[prefab].onequip(inst,owner)
        end
    end

    local function onunequip_dress(inst, owner)
        if owner then
            local skin_build = inst:GetSkinBuild()
            if skin_build ~= nil then
                owner:PushEvent("unequipskinneditem", inst:GetSkinName())
            end
            owner.AnimState:ClearOverrideSymbol("swap_body")
            -- 清除玩家的动画符号覆盖
            if inst.components.container ~= nil then
                inst.components.container:Close(owner)
            end
        end
        inst._nahida_owner = nil

        if MakeDressFn[prefab] and MakeDressFn[prefab].onunequip then
            MakeDressFn[prefab].onunequip(inst,owner)
        end
    end

    -- 定义物品被丢弃时的行为
    local function ondropped_dress(inst)
        if inst.components.container ~= nil then
            inst.components.container:Close()
        end
        inst.AnimState:SetBank(animstate.bank)
        inst.AnimState:SetBuild(animstate.build)
        inst.AnimState:PlayAnimation(animstate.anim)
        inst._nahida_owner = nil

        if MakeDressFn[prefab] and MakeDressFn[prefab].onunequip then
            MakeDressFn[prefab].onunequip(inst)
        end
    end

    -- 定义装备到模型时的行为（通常用于展示）
    local function onequiptomodel_dress(inst, owner)
        if inst.components.container ~= nil then
            inst.components.container:Close(owner)
        end
        inst._nahida_owner = nil
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

    local function fakeGetInsulation(self)
        local inst = self.inst
        local owner = inst._nahida_owner
        if owner == nil then
            return self.insulation, self:GetType()
        end
        local temperature = owner and owner.components.temperature
        local playertemp = temperature:GetCurrent()
        self.insulation = 0
        if playertemp <= 27 then
            self:SetWinter()
            if inst.components.dst_gi_nahida_backpack_data then
                self.insulation = inst.components.dst_gi_nahida_backpack_data.backpack_data.redgem.count * 20
                if playertemp <= 15 and inst.components.dst_gi_nahida_backpack_data.backpack_data.redgem.count >= 25 then
                    temperature:SetTemperature(30)
                end
            end
            return self.insulation, self:GetType()
        end
        self:SetSummer()
        if inst.components.dst_gi_nahida_backpack_data then
            self.insulation = inst.components.dst_gi_nahida_backpack_data.backpack_data.bluegem.count * 20
            if playertemp >= 40 and inst.components.dst_gi_nahida_backpack_data.backpack_data.bluegem.count >= 25 then
                temperature:SetTemperature(25)
            end
        end
        return self.insulation, self:GetType()
    end

    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        -- 设置物理属性，使其可以被拾取
        MakeInventoryPhysics(inst)

        inst:AddTag("backpack")
        inst:AddTag("waterproofer")
        inst:AddTag("dst_gi_nahida_dress")
        inst:AddTag(prefab)
        inst:AddTag("shoreonsink")     --不掉深渊
        inst:AddTag("tornado_nosucky") --mod兼容：永不妥协。不会被龙卷风刮走
        inst:AddTag("hide_percentage") -- 隐藏百分比
        inst:AddTag("nosteal")           --防止被火药猴偷走
        inst:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NO_STEAL) -- 不会被火药猴偷取
        inst:AddTag("fridge") -- 保鲜
        inst:AddTag("NORATCHECK") -- 新增：永不妥协模组专用防偷标签

        inst.AnimState:SetBank(animstate.bank)
        inst.AnimState:SetBuild(animstate.build)
        inst.AnimState:PlayAnimation(animstate.anim)
        inst.entity:SetPristine()
        -- 设置浮动属性
        MakeInventoryFloatable(inst)

        inst.net_preserver_upgrade = net_string(inst.GUID, "net_preserver_upgrade")
        inst.net_chestupgrade_stacksize = net_string(inst.GUID, "net_chestupgrade_stacksize")
        inst.net_dst_gi_nahida_backpack_data_furtuft = net_string(inst.GUID, "net_dst_gi_nahida_backpack_data_furtuft")
        inst.net_dst_gi_nahida_backpack_data_purplegem = net_string(inst.GUID, "net_dst_gi_nahida_backpack_data_purplegem")
        inst.net_dst_gi_nahida_backpack_data_bluegem = net_string(inst.GUID, "net_dst_gi_nahida_backpack_data_bluegem")
        inst.net_dst_gi_nahida_backpack_data_redgem = net_string(inst.GUID, "net_dst_gi_nahida_backpack_data_redgem")

        local old_GetDisplayName = inst.GetDisplayName
        inst.GetDisplayName = function(self,...)
            local str = ""
            str = str.."\r\n"..STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_PRESERVER_UPGRADE..":"..tostring(inst.net_preserver_upgrade:value() or "N/A")
            str = str.."\r\n"..STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_STACKSIZE_UPGRADE..":"..tostring(inst.net_chestupgrade_stacksize:value() or "N/A")
            str = str.."\r\n"..STRINGS.NAMES.FURTUFT..":"..tostring(inst.net_dst_gi_nahida_backpack_data_furtuft:value() or "N/A")
            str = str.."\r\n"..STRINGS.NAMES.PURPLEGEM..":"..tostring(inst.net_dst_gi_nahida_backpack_data_purplegem:value() or "N/A")
            str = str.."\r\n"..STRINGS.NAMES.BLUEGEM..":"..tostring(inst.net_dst_gi_nahida_backpack_data_bluegem:value() or "N/A")
            str = str.."\r\n"..STRINGS.NAMES.REDGEM..":"..tostring(inst.net_dst_gi_nahida_backpack_data_redgem:value() or "N/A")
            return old_GetDisplayName(self,...)
                    ..str
        end

        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("dst_gi_nahida_backpack_data") -- 背包data
        inst:AddComponent("dst_gi_nahida_actions_data") -- 背包data
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.cangoincontainer = true
        inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. prefab .. ".xml"
        inst.components.inventoryitem:SetOnDroppedFn(ondropped_dress)

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
        inst.components.equippable:SetOnEquip(onequip_dress)
        inst.components.equippable:SetOnUnequip(onunequip_dress)
        inst.components.equippable:SetOnEquipToModel(onequiptomodel_dress)
        inst.components.equippable.walkspeedmult = 1.1

        inst:AddComponent("container")
        inst.components.container:WidgetSetup(container_size)
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true
        -- 防止永不妥协老鼠偷东西，必须带有容器的实体
        NhidaDropOneItemWithTag(inst)

        inst:AddComponent("dst_gi_nahida_ice_box_data")
        inst.components.dst_gi_nahida_ice_box_data:Init() -- 初始化保鲜倍率

        inst:AddComponent("insulator")
        inst.components.insulator:SetInsulation(0)
        inst.components.insulator.GetInsulation = fakeGetInsulation

        MakeHauntableLaunchAndDropFirstItem(inst)

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

        if MakeDressFn[prefab] and MakeDressFn[prefab].fn then
            MakeDressFn[prefab].fn(inst)
        end

        inst.OnLoad = OnLoad

        return inst
    end
    return Prefab(prefab, fn, assets)
end

local function dst_gi_nahida_hairpin_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    -- 设置物理属性，使其可以被拾取
    MakeInventoryPhysics(inst)

    inst:AddTag("waterproofer")
    inst:AddTag("dst_gi_nahida_hairpin")
    inst:AddTag("shoreonsink")     --不掉深渊
    inst:AddTag("tornado_nosucky") --mod兼容：永不妥协。不会被龙卷风刮走
    inst:AddTag("hide_percentage") -- 隐藏百分比
    inst:AddTag("nosteal")         -- 防偷取

    inst.AnimState:SetBank("dst_gi_nahida_hairpin")
    inst.AnimState:SetBuild("dst_gi_nahida_equipment")
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
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dst_gi_nahida_hairpin.xml"
    inst.components.inventoryitem:SetOnDroppedFn(ondropped_hairpin)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequip_hairpin)
    inst.components.equippable:SetOnUnequip(onunequip_hairpin)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel_hairpin)

    inst:AddComponent("waterproofer") -- 防水
    inst.components.waterproofer:SetEffectiveness(.5)

    inst:AddComponent("armor") -- 护甲
    inst.components.armor:InitIndestructible(.2)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

DST_GI_NAHIDA_API.MakeItemSkin("dst_gi_nahida_dress", "dst_gi_nahida_backpack_none1", {
    name = STRINGS.NAMES.DST_GI_NAHIDA_DRESS,
    atlas = "images/inventoryimages/dst_gi_nahida_backpack_none1.xml",
    image = "dst_gi_nahida_backpack_none1",
    build = "dst_gi_nahida_backpack_none1",
    bank = "dst_gi_nahida_backpack_none1",
    anim = "anim",
    basebuild = "dst_gi_nahida_backpack",
    basebank =  "dst_gi_nahida_backpack",
    baseanim = "anim",
})
DST_GI_NAHIDA_API.MakeItemSkin("dst_gi_nahida_dress2", "dst_gi_nahida_backpack_none1_2", {
    name = STRINGS.NAMES.DST_GI_NAHIDA_DRESS2,
    atlas = "images/inventoryimages/dst_gi_nahida_backpack_none1_2.xml",
    image = "dst_gi_nahida_backpack_none1_2",
    build = "dst_gi_nahida_backpack_none1_2",
    bank = "dst_gi_nahida_backpack_none1_2",
    anim = "anim",
    animcircle = true,
    basebuild = "dst_gi_nahida_backpack2",
    basebank =  "dst_gi_nahida_backpack2",
    baseanim = "anim",
    baseanimcircle = true
})
DST_GI_NAHIDA_API.MakeItemSkin("dst_gi_nahida_dress3", "dst_gi_nahida_backpack_none1_3", {
    name = STRINGS.NAMES.DST_GI_NAHIDA_DRESS3,
    atlas = "images/inventoryimages/dst_gi_nahida_backpack_none1_3.xml",
    image = "dst_gi_nahida_backpack_none1_3",
    build = "dst_gi_nahida_backpack_none1_3",
    bank = "dst_gi_nahida_backpack_none1_3",
    anim = "anim",
    basebuild = "dst_gi_nahida_backpack3",
    basebank =  "dst_gi_nahida_backpack3",
    baseanim = "anim",
})


local dress = {
    MakeDress("dst_gi_nahida_dress", { bank = "dst_gi_nahida_backpack", build = "dst_gi_nahida_backpack", anim = "anim" },
            "dst_gi_nahida_backpack", "dst_gi_nahida_dress"),
    MakeDress("dst_gi_nahida_dress2", { bank = "dst_gi_nahida_backpack2", build = "dst_gi_nahida_backpack2", anim = "anim" },
            "dst_gi_nahida_backpack2", "dst_gi_nahida_dress2"),
    MakeDress("dst_gi_nahida_dress3", { bank = "dst_gi_nahida_backpack3", build = "dst_gi_nahida_backpack3", anim = "anim" },
            "dst_gi_nahida_backpack3", "dst_gi_nahida_dress3"),
    Prefab(TUNING.MOD_ID .. "_hairpin", dst_gi_nahida_hairpin_fn, assets)
}

return unpack(dress)
