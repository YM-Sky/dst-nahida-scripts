---
--- dst_gi_nahida_backpack_data.lua
--- Description: 
--- Author: 没有小钱钱
--- Date: 2025/7/2 16:47
---
local dst_gi_nahida_backpack_data = Class(function(self, inst)
    self.inst = inst

    self.backpack_init_data = {
        furtuft = { -- 毛丛
            max_count = 4,
        },
        purplegem = { -- 紫宝石
            max_count = 18,
        },
        bluegem = { -- 蓝宝石
            max_count = 25,
        },
        redgem = { -- 红宝石
            max_count = 25,
        },
    }
    self.backpack_data = {
        furtuft = { -- 毛丛
            count = 0,
        },
        purplegem = { -- 紫宝石
            count = 0,
        },
        bluegem = { -- 蓝宝石
            count = 0,
        },
        redgem = { -- 红宝石
            count = 0,
        },
    }
end)

function dst_gi_nahida_backpack_data:stopTask(inst, player)
    if inst.temperature_task ~= nil then
        inst.temperature_task:Cancel()
        inst.temperature_task = nil
    end
end

function dst_gi_nahida_backpack_data:onequip(inst, player)
    if inst.components.dst_gi_nahida_backpack_data == nil then return end
    -- 初始化数据
    inst.components.dst_gi_nahida_backpack_data:Init()
end

function dst_gi_nahida_backpack_data:onunequip(inst, player)
    if inst.components.dst_gi_nahida_backpack_data == nil then return end
    -- 初始化数据
    inst.components.dst_gi_nahida_backpack_data:Init()
end



function dst_gi_nahida_backpack_data:Init()
    if self.inst.components.dst_gi_nahida_backpack_data ~= nil then
        local backpack_data = self.inst.components.dst_gi_nahida_backpack_data.backpack_data
        if self.inst.components.waterproofer and backpack_data.furtuft and backpack_data.furtuft.count == 0 then
            self.inst:RemoveComponent("waterproofer")
        end
        if self.inst.components.armor and backpack_data.purplegem and backpack_data.purplegem.count == 0 then
            self.inst:RemoveComponent("armor")
            if self.inst.components.damagetyperesist == nil then
                self.inst:AddComponent("damagetyperesist") -- 位面防御
            end
            self.inst.components.damagetyperesist:RemoveResist("shadow_aligned", self.inst, "nahida_shadow_aligned")
            self.inst.components.damagetyperesist:RemoveResist("lunar_aligned", self.inst, "nahida_lunar_aligned")
        end
        -- 毛丛
        if backpack_data.furtuft and backpack_data.furtuft.count > 0 then
            if self.inst.components.waterproofer and backpack_data.furtuft and backpack_data.furtuft.count == 0 then
                self.inst:RemoveComponent("waterproofer")
            end
            self.inst:AddComponent("waterproofer") -- 防水
            self.inst.components.waterproofer:SetEffectiveness(backpack_data.furtuft.count * 0.25)
            self.inst.components.equippable.insulated = true --设为true，就能防电
        end
        -- 紫宝石
        if backpack_data.purplegem and backpack_data.purplegem.count > 0 then
            if self.inst.components.armor and backpack_data.purplegem and backpack_data.purplegem.count == 0 then
                self.inst:RemoveComponent("armor")
            end
            self.inst:AddComponent("armor") -- 护甲
            self.inst.components.armor:InitIndestructible(backpack_data.purplegem.count * 0.05)

            if self.inst.components.damagetyperesist == nil then
                self.inst:AddComponent("damagetyperesist") -- 位面防御
            end
            self.inst.components.damagetyperesist:AddResist("shadow_aligned", self.inst, 1-backpack_data.purplegem.count * 0.04,"nahida_shadow_aligned")
            self.inst.components.damagetyperesist:AddResist("lunar_aligned", self.inst, 1-backpack_data.purplegem.count * 0.04,"nahida_lunar_aligned")
        end
    end
end

function dst_gi_nahida_backpack_data:Give(player, target, item)
    if target.components.dst_gi_nahida_backpack_data == nil then
        return false
    end
    if not (target:HasTag("dst_gi_nahida_dress")) then
        return false
    end
    if self.backpack_init_data[item.prefab] == nil and item.prefab ~= 'dst_gi_nahida_tool_knife' then
        return false
    end
    local backpack_data = target.components.dst_gi_nahida_backpack_data.backpack_data
    -- 工具刀，移除已经塞入的物品
    if item.prefab == 'dst_gi_nahida_tool_knife' then
        for prefab, data in pairs(backpack_data) do
            if data.count > 0 then
                local give_item = SpawnPrefab(prefab)
                if give_item.components.stackable then
                    give_item.components.stackable:SetStackSize(data.count)
                end
                if player.components.inventory then
                    player.components.inventory:GiveItem(give_item)
                end
                backpack_data[prefab].count = 0
            end
        end
        -- 初始化数据
        target.components.dst_gi_nahida_backpack_data:Init()
        -- 初始化数据
        self:net_data(backpack_data)
        if target.components.dst_gi_nahida_ice_box_data then
            target.components.dst_gi_nahida_ice_box_data:Peel(player,target)
        end
        -- 提取物品也要保存背包数据
        --OnSaveGlobalBackpackData(player,target)
        return true
    end

    if backpack_data[item.prefab] == nil then
        backpack_data[item.prefab] = { count = 0 }
    end
    if backpack_data[item.prefab].count >= self.backpack_init_data[item.prefab].max_count then
        return false
    end
    local difference_count = self.backpack_init_data[item.prefab].max_count - backpack_data[item.prefab].count
    local item_count = item.components.stackable and item.components.stackable:StackSize() or 1
    local removeCount = 1
    if item_count >= difference_count then
        removeCount = difference_count
    else
        removeCount = item_count
    end
    -- 移除消耗的物品
    if item.components.stackable then
        item.components.stackable:Get(removeCount):Remove()
    else
        item:Remove()
    end
    backpack_data[item.prefab].count = backpack_data[item.prefab].count + removeCount
    -- 初始化数据
    target.components.dst_gi_nahida_backpack_data:Init()
    -- 初始化数据
    self:net_data(backpack_data)
    return true
end

function dst_gi_nahida_backpack_data:net_data(backpack_data)
    self.inst.net_dst_gi_nahida_backpack_data_furtuft:set(backpack_data.furtuft.count)
    self.inst.net_dst_gi_nahida_backpack_data_purplegem:set(backpack_data.purplegem.count)
    self.inst.net_dst_gi_nahida_backpack_data_bluegem:set(backpack_data.bluegem.count)
    self.inst.net_dst_gi_nahida_backpack_data_redgem:set(backpack_data.redgem.count)
end

function dst_gi_nahida_backpack_data:OnSave()
    local new_backpack_data = {}
    for prefab, data in pairs(self.backpack_init_data) do
        if self.backpack_data[prefab] == nil then
            self.backpack_data[prefab] = { count = 0 }
        end
        new_backpack_data[prefab] = self.backpack_data[prefab]
    end
    return {
        backpack_data = new_backpack_data
    }
end

function dst_gi_nahida_backpack_data:getData()
    local new_backpack_data = {}
    for prefab, data in pairs(self.backpack_init_data) do
        if self.backpack_data[prefab] == nil then
            self.backpack_data[prefab] = { count = 0 }
        end
        new_backpack_data[prefab] = self.backpack_data[prefab]
    end
    return {
        backpack_data = new_backpack_data
    }
end

function dst_gi_nahida_backpack_data:OnLoad(data)
    if data.backpack_data == nil then
        data.backpack_data = {}
    end
    for prefab, _ in pairs(self.backpack_init_data) do
        if data.backpack_data[prefab] == nil then
            data.backpack_data[prefab] = { count = 0 }
        end
        self.backpack_data[prefab] = data.backpack_data[prefab]
    end
    -- 设置面板值
    -- 初始化数据
    self:net_data(self.backpack_data)
    self:Init()
end

function dst_gi_nahida_backpack_data:SaveData(data)
    if data.backpack_data == nil then
        data.backpack_data = {}
    end
    for prefab, _ in pairs(self.backpack_init_data) do
        if data.backpack_data[prefab] == nil then
            data.backpack_data[prefab] = { count = 0 }
        end
        self.backpack_data[prefab] = data.backpack_data[prefab]
    end
    -- 设置面板值
    -- 初始化数据
    self:net_data(self.backpack_data)
    self:Init()
end

return dst_gi_nahida_backpack_data