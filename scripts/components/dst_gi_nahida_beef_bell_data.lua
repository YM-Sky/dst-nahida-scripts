---
--- dst_gi_nahida_beef_bell_data.lua
--- Description: 牛铃data
--- Author: 没有小钱钱
--- Date: 2025/5/12 0:12
---
local dst_gi_nahida_beef_bell_data = Class(function(self, inst)
    self.inst = inst
    self.beef_bell_data = {
        hunger = 375,
        hunger_rate = TUNING.WILSON_HUNGER_RATE * 0.8,
        tendency = TENDENCY.DEFAULT,
    }
    -- 是否保存牛的数据
    self.is_save_beefalo = false
end)

function dst_gi_nahida_beef_bell_data:SaveBeefBellData(data)
    self.beef_bell_data.hunger = data.hunger
    self.beef_bell_data.hunger_rate = data.hunger_rate
    self.beef_bell_data.tendency = data.tendency
    -- 🔥 保存CD相关数据
    if data.pick_up_cd then
        self.beef_bell_data.pick_up_cd = data.pick_up_cd
    end
    if data.pick_up_prefab_data then
        self.beef_bell_data.pick_up_prefab_data = data.pick_up_prefab_data
    end
    -- 🔥 保存鞍具相关数据
    if data.saddle then
        self.beef_bell_data.saddle = data.saddle
    end
    if data.saddle_skin then
        self.beef_bell_data.saddle_skin = data.saddle_skin
    end
    -- 保存牛的数据了
    self.is_save_beefalo = true
end

-- 收起牛
function dst_gi_nahida_beef_bell_data:PutAway(player, beef, item)
    -- 没有绑定组件无法收起此牛
    if beef.components.dst_gi_nahida_bind_data == nil then
        return false
    end
    if item.components.dst_gi_nahida_beef_bell_data == nil then
        return false
    end
    if item.components.dst_gi_nahida_bind_data == nil then
        item:AddComponent("dst_gi_nahida_bind_data")
        item.components.dst_gi_nahida_bind_data:SetUuid(beef.components.dst_gi_nahida_bind_data:GetUuid())
    end
    local itemUuid = item.components.dst_gi_nahida_bind_data:GetUuid()
    local beefUuid = beef.components.dst_gi_nahida_bind_data:GetUuid()
    if itemUuid ~= beefUuid then
        return false
    end
    local old_beef_bell_data = item.components.dst_gi_nahida_beef_bell_data.beef_bell_data
    local beef_bell_data = {}
    beef_bell_data.hunger_rate = old_beef_bell_data.hunger_rate
    beef_bell_data.tendency = old_beef_bell_data.tendency
    if beef and beef.components.hunger then
        beef_bell_data.hunger = beef.components.hunger.current or 0
    end

    -- 🔥 保存牛的CD状态
    if beef.components.dst_gi_nahida_actions_data then
        local current_cd = beef.components.dst_gi_nahida_actions_data:GetPickUpCd()
        local current_prefab_data = beef.components.dst_gi_nahida_actions_data:GetPickUpPrefabData()
        beef_bell_data.pick_up_cd = current_cd
        beef_bell_data.pick_up_prefab_data = current_prefab_data
    end

    -- �� 保存牛的鞍具状态 - 修正：保存鞍具的prefab名称
    if beef.components.rideable and beef.components.rideable:IsSaddled() then
        local saddle = beef.components.rideable.saddle
        if saddle then
            beef_bell_data.saddle_prefab = saddle.prefab
            beef_bell_data.saddle_skin = saddle.skinname
        end
    end

    item.components.dst_gi_nahida_beef_bell_data:SaveBeefBellData(beef_bell_data)
    beef:Remove()
    item.components.dst_gi_nahida_beef_bell_data.is_save_beefalo = true
    return true
end

-- 释放牛
function dst_gi_nahida_beef_bell_data:SpawnPrefabBeefalo(player, item)
    if item.components.dst_gi_nahida_beef_bell_data == nil or item.components.dst_gi_nahida_beef_bell_data.is_save_beefalo == false then
        return false
    end
    if item.components.dst_gi_nahida_bind_data == nil then
        return false
    end
    local beef = SpawnPrefab("beefalo")
    -- 设置满信任度和驯化值
    if beef and beef.components.domesticatable then
        -- 设置牛的驯化状态
        beef.components.domesticatable:DeltaDomestication(1)
        beef.components.domesticatable:DeltaObedience(1)
        beef.components.domesticatable:DeltaTendency(item.components.dst_gi_nahida_beef_bell_data.beef_bell_data.tendency, 1) -- 牛类型
        beef:SetTendency()
        beef.components.domesticatable:BecomeDomesticated()
        -- 给牛加上UUID
        beef:AddTag("domesticated")
        beef:AddComponent("dst_gi_nahida_bind_data")
        beef.components.dst_gi_nahida_bind_data:SetUuid(item.components.dst_gi_nahida_bind_data:GetUuid())

        beef:DoPeriodicTask(10, function()
            beef.components.domesticatable:DeltaObedience(1.0 - beef.components.domesticatable:GetObedience())
        end)
        -- 设置初始满饥饿值
        if beef and beef.components.hunger then
            beef.components.hunger.current = item.components.dst_gi_nahida_beef_bell_data.beef_bell_data.hunger  -- 设置饥饿值
            beef.components.hunger:SetRate(item.components.dst_gi_nahida_beef_bell_data.beef_bell_data.hunger_rate) -- 调整饥饿速度
        end

        -- 🔥 延迟恢复牛的CD状态，确保在组件初始化之后执行
        local saved_cd = item.components.dst_gi_nahida_beef_bell_data.beef_bell_data.pick_up_cd
        local saved_prefab_data = item.components.dst_gi_nahida_beef_bell_data.beef_bell_data.pick_up_prefab_data
        beef:DoTaskInTime(0.1, function()
            if beef.components.dst_gi_nahida_actions_data then
                if saved_cd and saved_cd > 0 then
                    beef.components.dst_gi_nahida_actions_data:RestPickUpCd(saved_cd)
                    beef.components.dst_gi_nahida_actions_data:StartPickUpCdTask(saved_cd)
                end
                if saved_prefab_data then
                    beef.components.dst_gi_nahida_actions_data:SetPickUpPrefabData(saved_prefab_data)
                end
            end
        end)

        -- �� 延迟恢复牛的鞍具状态 - 修正：使用正确的SetSaddle方法
        local saved_saddle_prefab = item.components.dst_gi_nahida_beef_bell_data.beef_bell_data.saddle_prefab
        local saved_saddle_skin = item.components.dst_gi_nahida_beef_bell_data.beef_bell_data.saddle_skin
        beef:DoTaskInTime(0.2, function()
            if beef.components.rideable and saved_saddle_prefab then
                -- 使用正确的方法：SetSaddle(nil, SpawnPrefab(prefab))
                beef.components.rideable:SetSaddle(nil, SpawnPrefab(saved_saddle_prefab))
            end
        end)

        -- 将牛设置为当前玩家的专属牛
        if beef and beef.components.follower then
            beef.components.follower:SetLeader(player)
        end
        local x, y, z = player.Transform:GetWorldPosition()
        -- 设置牛的位置
        beef.Transform:SetPosition(x + 1, y, z + 1)
        item.components.dst_gi_nahida_beef_bell_data.is_save_beefalo = false
        return true
    end
    return false
end

function dst_gi_nahida_beef_bell_data:SaveBeefBellData(data)
    self.beef_bell_data.hunger = data.hunger
    self.beef_bell_data.hunger_rate = data.hunger_rate
    self.beef_bell_data.tendency = data.tendency
    -- 🔥 保存CD相关数据
    if data.pick_up_cd then
        self.beef_bell_data.pick_up_cd = data.pick_up_cd
    end
    if data.pick_up_prefab_data then
        self.beef_bell_data.pick_up_prefab_data = data.pick_up_prefab_data
    end
    -- 🔥 保存鞍具相关数据 - 修正：保存prefab名称
    if data.saddle_prefab then
        self.beef_bell_data.saddle_prefab = data.saddle_prefab
    end
    if data.saddle_skin then
        self.beef_bell_data.saddle_skin = data.saddle_skin
    end
    -- 保存牛的数据了
    self.is_save_beefalo = true
end

function dst_gi_nahida_beef_bell_data:OnSave()
    return {
        is_save_beefalo = self.is_save_beefalo,
        beef_bell_data = {
            hunger = self.beef_bell_data.hunger,
            hunger_rate = self.beef_bell_data.hunger_rate,
            tendency = self.beef_bell_data.tendency,
            -- 🔥 保存CD相关数据
            pick_up_cd = self.beef_bell_data.pick_up_cd,
            pick_up_prefab_data = self.beef_bell_data.pick_up_prefab_data,
            -- 🔥 保存鞍具相关数据 - 修正：保存prefab名称
            saddle_prefab = self.beef_bell_data.saddle_prefab,
            saddle_skin = self.beef_bell_data.saddle_skin
        }
    }
end

-- 保存UUID
function dst_gi_nahida_beef_bell_data:OnLoad(data)
    if data.beef_bell_data and data.beef_bell_data.hunger then
        self.beef_bell_data.hunger = data.beef_bell_data.hunger
    end
    if data.beef_bell_data and data.beef_bell_data.hunger_rate then
        self.beef_bell_data.hunger_rate = data.beef_bell_data.hunger_rate
    end
    if data.beef_bell_data and data.beef_bell_data.tendency then
        self.beef_bell_data.tendency = data.beef_bell_data.tendency
    end
    -- 🔥 加载CD相关数据
    if data.beef_bell_data and data.beef_bell_data.pick_up_cd then
        self.beef_bell_data.pick_up_cd = data.beef_bell_data.pick_up_cd
    end
    if data.beef_bell_data and data.beef_bell_data.pick_up_prefab_data then
        self.beef_bell_data.pick_up_prefab_data = data.beef_bell_data.pick_up_prefab_data
    end
    -- 🔥 加载鞍具相关数据 - 修正：加载prefab名称
    if data.beef_bell_data and data.beef_bell_data.saddle_prefab then
        self.beef_bell_data.saddle_prefab = data.beef_bell_data.saddle_prefab
    end
    if data.beef_bell_data and data.beef_bell_data.saddle_skin then
        self.beef_bell_data.saddle_skin = data.beef_bell_data.saddle_skin
    end
    if data.is_save_beefalo ~= nil then
        self.is_save_beefalo = data.is_save_beefalo
    end
end

return dst_gi_nahida_beef_bell_data