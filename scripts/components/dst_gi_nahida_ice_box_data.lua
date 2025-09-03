---
--- dst_gi_nahida_ice_box_data.lua
--- Description: 冰箱核心数据
--- Author: 没有小钱钱
--- Date: 2025/5/4 23:38
---
local dst_gi_nahida_ice_box_data = Class(function(self, inst)
    self.inst = inst
    self.upgrade_preserver_item = TUNING.MOD_DST_GI_NAHIDA.UPGRADE_PRESERVER_ITEM
    self.preserver_upgrade = false
    self._chestupgrade_stacksize = false
end)

function dst_gi_nahida_ice_box_data:Upgrade(item)
    if not self:CanUpgrade(item) then
        return false
    end
    -- 弹性空间制造器升级
    if item.prefab == "chestupgrade_stacksize" then
        self._chestupgrade_stacksize = true
        self:Init()
        return true
    end
    -- 极寒之核升级
    if item.prefab == "dst_gi_nahida_everfrost_ice_crystal" then
        self.preserver_upgrade = true
        self:Init()
        return true
    end
    return false
end

function dst_gi_nahida_ice_box_data:Peel(player,inst)
    if inst.components.dst_gi_nahida_ice_box_data then
        if inst.components.dst_gi_nahida_ice_box_data._chestupgrade_stacksize then
            local give_item = SpawnPrefab("chestupgrade_stacksize")
            if player.components.inventory then
                player.components.inventory:GiveItem(give_item)
            end
            inst.components.dst_gi_nahida_ice_box_data._chestupgrade_stacksize = false
        end
        if inst.components.dst_gi_nahida_ice_box_data.preserver_upgrade then
            local give_item = SpawnPrefab("dst_gi_nahida_everfrost_ice_crystal")
            if player.components.inventory then
                player.components.inventory:GiveItem(give_item)
            end
            inst.components.dst_gi_nahida_ice_box_data.preserver_upgrade = false
        end
        self:Init()
    end
end

function dst_gi_nahida_ice_box_data:CanUpgrade(item)
    if self.preserver_upgrade and item.prefab == "dst_gi_nahida_everfrost_ice_crystal" then
        return false
    end
    if self._chestupgrade_stacksize and item.prefab == "chestupgrade_stacksize" then
        return false
    end
    return true
end

function dst_gi_nahida_ice_box_data:Init()
    if self.inst.components.preserver == nil then
        self.inst:AddComponent("preserver")
    end
    if self.preserver_upgrade then
        self.inst.components.preserver:SetPerishRateMultiplier(0) -- 设置为永鲜
    else
        if self.inst:HasTag("dst_gi_nahida_dress") then
            self.inst.components.preserver:SetPerishRateMultiplier(0.5) -- 设置为2倍保鲜
        else
            self.inst.components.preserver:SetPerishRateMultiplier(0.0625) -- 设置为16倍保鲜
        end

    end
    if self.inst.components.container ~= nil then
        -- NOTES(JBK): The container component goes away in the burnt load but we still want to apply builds.
        self.inst.components.container:Close()
        self.inst.components.container:EnableInfiniteStackSize(self._chestupgrade_stacksize)
    end
    self.inst.net_preserver_upgrade:set(tostring(self.preserver_upgrade))
    self.inst.net_chestupgrade_stacksize:set(tostring(self._chestupgrade_stacksize))
end

function dst_gi_nahida_ice_box_data:OnSave()
    return {
        preserver_upgrade = self.preserver_upgrade,
        _chestupgrade_stacksize = self._chestupgrade_stacksize
    }
end

function dst_gi_nahida_ice_box_data:getData()
    return {
        preserver_upgrade = self.preserver_upgrade,
        _chestupgrade_stacksize = self._chestupgrade_stacksize
    }
end

function dst_gi_nahida_ice_box_data:SaveData(data)
    if data.preserver_upgrade then
        self.preserver_upgrade = data.preserver_upgrade
    end
    if data._chestupgrade_stacksize then
        self._chestupgrade_stacksize = data._chestupgrade_stacksize
    end
    self:Init()
end

-- 加载能量和冷却时间的状态
function dst_gi_nahida_ice_box_data:OnLoad(data)
    if data.preserver_upgrade then
        self.preserver_upgrade = data.preserver_upgrade
    end
    if data._chestupgrade_stacksize then
        self._chestupgrade_stacksize = data._chestupgrade_stacksize
    end
    self:Init()
end

return dst_gi_nahida_ice_box_data