---
--- dst_gi_nahida_actions_data.lua
--- Description: 动作数据
--- Author: 没有小钱钱
--- Date: 2025/4/10 22:47
---
-- 将 trinkets_loot 移到构造函数外，避免每个实例都创建
local TRINKETS_LOOT = {}
if NUM_TRINKETS and NUM_TRINKETS > 0 then
    for k = 1, NUM_TRINKETS do
        TRINKETS_LOOT[k] = "trinket_" .. k
    end
end
TRINKETS_LOOT[NUM_TRINKETS + 1] = "antliontrinket"
TRINKETS_LOOT[NUM_TRINKETS + 2] = "cotl_trinket"

local dst_gi_nahida_actions_data = Class(function(self, inst)
    self.inst = inst
    self.pick_up_cd = 0
    self.pick_up_cd_task = nil
    self.pick_up_prefab_data = nil

    self.trinkets_loot = TRINKETS_LOOT
end)

function dst_gi_nahida_actions_data:StartPickUpCdTask(pick_up_max_cd)
    if pick_up_max_cd == 0 then
        return
    end
    -- 重新设置cd
    self:RestPickUpCd(pick_up_max_cd)

    if self.pick_up_cd_task ~= nil then
        self.pick_up_cd_task:Cancel()
    end
    self.pick_up_cd_task = self.inst:DoPeriodicTask(1, function()
        if self.pick_up_cd > 0 then
            self.pick_up_cd = self.pick_up_cd - 1
            if self.pick_up_cd <= 0 then
                self.pick_up_cd = 0
                if self.pick_up_cd_task ~= nil then
                    self.pick_up_cd_task:Cancel()
                end
            end
            --self.inst.net_nahida_actions_cd:set(self.pick_up_cd)
        end
    end)
end

function dst_gi_nahida_actions_data:RestPickUpCd(pick_up_max_cd)
    self.pick_up_cd = pick_up_max_cd
end

function dst_gi_nahida_actions_data:GetPickUpCd()
    return self.pick_up_cd
end

function dst_gi_nahida_actions_data:SetPickUpPrefabData(pick_up_prefab_data)
    self.pick_up_prefab_data = pick_up_prefab_data
end

function dst_gi_nahida_actions_data:GetPickUpPrefabData()
    return self.pick_up_prefab_data
end
--  player 玩家
--  target 点击的物品或者预制体（龙蝇，猴子等等）
function dst_gi_nahida_actions_data:PickUp(player, target)
    if player:HasTag(TUNING.AVATAR_NAME) then
        local cd = self:GetPickUpCd()
        if cd > 0 then
            if player.components.talker then
                player.components.talker:Say(string.format(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_ANIMAL_GIVE_RESIDUE_CD, cd))
            end
            return true
        end

        -- 获取物品逻辑
        local prefab_data = self:GetPickUpPrefabData()
        if prefab_data then
            local stack_multiplier = 1
            -- 判断命座等级是否够
            if prefab_data.sanity and prefab_data.fateseat_level then
                if player.components.dst_gi_nahida_data then
                    local nahida_fateseat_level = player.components.dst_gi_nahida_data.nahida_fateseat_level
                    if nahida_fateseat_level < prefab_data.fateseat_level then
                        return false
                    end
                    if nahida_fateseat_level < 6 then
                        -- 消耗理智值
                        if player.components.staffsanity then
                            player.components.staffsanity:DoCastingDelta(-prefab_data.sanity)
                        elseif player.components.sanity ~= nil then
                            player.components.sanity:DoDelta(-prefab_data.sanity)
                        end
                    end
                end
            end
            -- 如果是消耗品，检查堆叠数量
            if prefab_data.consumables and target.components.stackable then
                stack_multiplier = target.components.stackable:StackSize()
            end
            -- 重置冷却时间
            self:StartPickUpCdTask(prefab_data.cd)

            -- 先检查是否有任何物品有概率限制，如果有，进行一次概率判断
            local has_probability = false
            local probability_check = true
            for _, product in ipairs(prefab_data.product) do
                if product.probability ~= nil then
                    has_probability = true
                    break
                end
            end

            -- 如果有概率限制，进行一次概率判断
            if has_probability then
                -- 使用第一个有概率的物品的概率进行判断
                for _, product in ipairs(prefab_data.product) do
                    if product.probability ~= nil then
                        probability_check = math.random() < product.probability
                        break
                    end
                end
            end

            -- 如果概率判断失败，显示失败消息
            if not probability_check then
                if player.components.dst_gi_nahida_data then
                    player.components.dst_gi_nahida_data:OnAttack(target)
                end
                if player.components.talker then
                    local msg = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_THANK_GIFT_MSG[target.prefab]
                    if msg == nil then
                        msg = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_THANK_GIFT_MSG.DEFAULT
                    end
                    player.components.talker:Say(msg)
                end
                return true
            end

            -- 概率判断成功，给予所有物品
            for _, product in ipairs(prefab_data.product) do
                local item = SpawnPrefab(product.name)
                if item then
                    -- 检查物品是否可以堆叠
                    local count = product.count
                    if type(count) == "table" then
                        -- 如果是表，随机取范围内的值
                        count = math.random(count[1], count[2])
                    end
                    if item.components.stackable then
                        item.components.stackable:SetStackSize(count * stack_multiplier)
                    end
                    if prefab_data.not_inventory then
                        local x, y, z = target.Transform:GetWorldPosition()
                        -- 容器满了，丢地上
                        item.Transform:SetPosition(x,y,z)
                    else
                        player.components.inventory:GiveItem(item)
                    end
                end
            end
            if prefab_data.consumables then
                -- 删除原来的物品
                target:Remove()
            else
                if player.components.talker then
                    player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_THANK_GIFT)
                end
            end
            return true
        end
    end
    return false
end

--  同等PICK_UP
--  player 玩家
--  target 点击的物品或者预制体（龙蝇，猴子等等）
function dst_gi_nahida_actions_data:Struck(player, target, equipped_item)
    local cd = self:GetPickUpCd()
    if cd > 0 then
        if player.components.talker then
            player.components.talker:Say(string.format(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_ANIMAL_GIVE_RESIDUE_CD, cd))
        end
        return true
    end

    -- 获取物品逻辑
    local prefab_data = self:GetPickUpPrefabData()
    if prefab_data then
        local stack_multiplier = 1
        -- 如果是消耗品，检查堆叠数量
        if prefab_data.consumables and target.components.stackable then
            stack_multiplier = target.components.stackable:StackSize()
        end
        -- 先检查是否有任何物品有概率限制，如果有，进行一次概率判断
        local has_probability = false
        local probability_check = true
        for _, product in ipairs(prefab_data.product) do
            if product.probability ~= nil then
                has_probability = true
                break
            end
        end

        -- 如果有概率限制，进行一次概率判断
        if has_probability then
            -- 使用第一个有概率的物品的概率进行判断
            for _, product in ipairs(prefab_data.product) do
                if product.probability ~= nil then
                    probability_check = math.random() < product.probability
                    break
                end
            end
        end

        -- 如果概率判断成功，给予所有物品
        if probability_check then
            for _, product in ipairs(prefab_data.product) do
                local item = SpawnPrefab(product.name)
                if item then
                    -- 处理count，可能是数字或表
                    local count = product.count
                    if type(count) == "table" then
                        -- 如果是表，随机取范围内的值
                        count = math.random(count[1], count[2])
                    end

                    -- 检查物品是否可以堆叠
                    if item.components.stackable then
                        item.components.stackable:SetStackSize(count * stack_multiplier)
                    end
                    player.components.inventory:GiveItem(item)
                end
            end
        end
        -- 重置冷却时间
        self:StartPickUpCdTask(prefab_data.cd)
        if prefab_data.consumables then
            -- 删除原来的物品
            target:Remove()
        else
            if player.components.talker then
                player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_THANK_GIFT)
            end
        end
        if equipped_item and equipped_item.prefab ~= "dst_gi_nahida_weapon_staff" and equipped_item.components.finiteuses then
            equipped_item.components.finiteuses:Use(stack_multiplier)
        end
        return true
    end
    return false
end
-- 定轨
function dst_gi_nahida_actions_data:EpitomizedPath(player, target)
    if target and target.prefab ~= "dst_gi_nahida_intertwined_fate" then
        return false
    end
    if player.components.dst_nahida_player_wish_data == nil then
        player:AddComponent("dst_nahida_player_wish_data")
    end
    -- 设置定轨值
    player.components.dst_nahida_player_wish_data:EpitomizedPath()
    return true
end

-- 抽卡
function dst_gi_nahida_actions_data:DrawCard(player, target, item)
    if not (target and target.prefab == "dst_gi_nahida_gacha_machine") then
        return false
    end
    if not (item and item:HasTag("dst_gi_nahida_fate")) then
        return false
    end
    if player.components.dst_nahida_player_wish_data == nil then
        player:AddComponent("dst_nahida_player_wish_data")
    end
    if target.sg ~= nil then
        target.sg:GoToState("dst_gi_nahida_gacha_machine_use")
    end
    local item_count = item.components.stackable and item.components.stackable:StackSize() or 1
    local draw_count = 1

    if item_count >= 10 then
        draw_count = 10
    end
    local container = target.components.container
    for i = 1, draw_count do
        -- 执行抽卡逻辑
        local prefab, count, rarity = player.components.dst_nahida_player_wish_data:DrawCard(item)
        -- 在 target 的范围3内随机偏移生成物品
        if prefab then
            local x, y, z = target.Transform:GetWorldPosition()
            local offset_x = math.random(-3, 3)
            local offset_z = math.random(-3, 3)
            local spawn_position = Vector3(x + offset_x, y, z + offset_z)
            local spawned_item = SpawnPrefab(prefab)
            if spawned_item then
                if container == nil then
                    spawned_item.Transform:SetPosition(spawn_position:Get())
                    -- 如果生成的物品有堆叠组件，设置其堆叠数量
                    if spawned_item.components.stackable and count > 1 then
                        spawned_item.components.stackable:SetStackSize(count)
                    end
                else
                    -- 放入容器
                    local success = container:GiveItem(spawned_item)
                    if not success then
                        -- 容器满了，丢地上
                        spawned_item.Transform:SetPosition(spawn_position:Get())
                    end
                end

            end
        end
    end
    TheNet:Announce(string.format(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_DRAW_MESSAGE,
            player.prefab,
            player.components.dst_nahida_player_wish_data.current_gold_probability,
            player.components.dst_nahida_player_wish_data.pity_counter,
            player.components.dst_nahida_player_wish_data.up_counter
    ))
    -- 移除消耗的物品
    if item.components.stackable then
        item.components.stackable:Get(item_count >= 10 and 10 or 1):Remove()
    else
        item:Remove()
    end
    return true
end

-- 恢复最大生命值
function dst_gi_nahida_actions_data:ResetMaxValues(player,item)
    if player.components.hunger and player.components.hunger.SetPenalty2hm then
        player.components.hunger:SetPenalty2hm(0)
    end
    -- 重置玩家的生命值上限到初始状态
    if player.components.health then
        player.components.health:SetPenalty(0)  -- 重置惩罚
        player.components.health:ForceUpdateHUD(true)  -- 更新 HUD
    end
    if item and item.components.finiteuses then
        item.components.finiteuses:Use(1)
    end
    return true
end

function dst_gi_nahida_actions_data:Exchange(player, target, item)
    if not (target and target.prefab == "dst_gi_nahida_gacha_machine") then
        return false
    end
    if item.prefab == "goldnugget" then
        local item_count = item.components.stackable and item.components.stackable:StackSize() or 1
        if item_count < 10 then
            if player.components.talker then
                player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_GOLD_IS_LESS_THAN_10)
            end
            return true
        end

        -- 计算可以兑换的组数
        local exchange_sets = math.floor(item_count / 10)
        local gold_to_remove = exchange_sets * 10
        -- 移除金块
        if item.components.stackable then
            item.components.stackable:Get(gold_to_remove):Remove()
        else
            item:Remove()
        end
        local fate = SpawnPrefab("dst_gi_nahida_intertwined_fate")
        if fate.components.stackable and exchange_sets > 1 then
            fate.components.stackable:SetStackSize(exchange_sets)
        end
        if player.components.inventory then
            player.components.inventory:GiveItem(fate)
        end
        -- 提示玩家兑换信息
        if player.components.talker then
            player.components.talker:Say(string.format(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_GOLD_EXCHANGED_COMPLETED_FATES, gold_to_remove, exchange_sets))
        end

        return true
    end
end

-- 训牛
-- @Param player 玩家
-- @Param target 牛
-- @Param item   牛铃
function dst_gi_nahida_actions_data:TameBeefalo(player, target, item)
    local beef_bell_data = {}
    if item == nil then
        return false
    end
    if target.components.dst_gi_nahida_bind_data and target.components.dst_gi_nahida_bind_data:GetUuid() then
        return false
    end
    local bind_prefab = nil
    if item.prefab == "dst_gi_nahida_beef_bell" then
        beef_bell_data.tendency = TENDENCY.DEFAULT -- 普牛
        bind_prefab = "dst_gi_nahida_beef_bell_bind"
    elseif item.prefab == "dst_gi_nahida_beef_bell2" then
        beef_bell_data.tendency = TENDENCY.ORNERY -- 战牛
        bind_prefab = "dst_gi_nahida_beef_bell_bind2"
    elseif item.prefab == "dst_gi_nahida_beef_bell3" then
        beef_bell_data.tendency = TENDENCY.RIDER -- 行牛
        bind_prefab = "dst_gi_nahida_beef_bell_bind3"
    end
    if target and target.components.hunger then
        beef_bell_data.hunger = target.components.hunger.max or 0
        beef_bell_data.hunger_rate = TUNING.WILSON_HUNGER_RATE * 0.8  -- 调整饥饿速度
    end

    local uuid = SpawnNhidaUuid()

    local bindItem = SpawnPrefab(bind_prefab)
    if bindItem == nil then
        return false
    end
    -- 设置同一个UUID，建立绑定关系
    if bindItem.components.dst_gi_nahida_bind_data == nil then
        bindItem:AddComponent("dst_gi_nahida_bind_data")
    end
    bindItem.components.dst_gi_nahida_bind_data:SetUuid(uuid)

    if bindItem.components.dst_gi_nahida_beef_bell_data == nil then
        bindItem:AddComponent("dst_gi_nahida_beef_bell_data")
    end
    bindItem.components.dst_gi_nahida_beef_bell_data:SaveBeefBellData(beef_bell_data)
    target:Remove()
    item:Remove()
    player.components.inventory:GiveItem(bindItem)
    return true
end

-- 小玩具制作
-- @Param player 玩家
-- @Param target 小玩具制作站
-- @Param item   金子或者小玩具
function dst_gi_nahida_actions_data:ToyMaking(player, target, item)
    if target == nil or target.prefab ~= "dst_gi_nahida_toy_desk" then
        return false
    end
    if TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.TOY_EXCHANGE_PERMISSION == "mod_character_only" and not player:HasTag(TUNING.AVATAR_NAME) then
        return false
    end
    if not (item.prefab == "goldnugget" or NahidaIsTrinket(item)) then
        return false
    end
    if player.components.dst_gi_nahida_toy_desk_data == nil then
        player:AddComponent("dst_gi_nahida_toy_desk_data")
    end
    local inventory = player.components.inventory
    if item.prefab == "goldnugget" then
        local toy_count = player.components.dst_gi_nahida_toy_desk_data:GetCurrentToyCount()
        local max_toy_count = player.components.dst_gi_nahida_toy_desk_data:GetMaxToyCount()
        if toy_count >= max_toy_count then
            -- 已经超过最大玩具制作
            return false
        end
        -- 还剩可制作玩具
        local difference_toy_count = max_toy_count - toy_count

        local gold_count = item.components.stackable and item.components.stackable:StackSize() or 1
        local trinkets_to_give = {}
        local draw_count = gold_count
        if gold_count >= 10 then
            draw_count = 10
        end
        if difference_toy_count <= draw_count then
            draw_count = difference_toy_count
        end
        -- 消耗金子
        if item.components.stackable then
            item.components.stackable:Get(draw_count):Remove()
        else
            item:Remove()
        end
        -- 随机生成小玩具
        for i = 1, draw_count do
            local trinket = self.trinkets_loot[math.random(#self.trinkets_loot)]
            trinkets_to_give[trinket] = (trinkets_to_give[trinket] or 0) + 1
        end

        -- 将所有随机到的小玩具给予玩家
        for trinket, count in pairs(trinkets_to_give) do
            local trinketItem = SpawnPrefab(trinket)
            if trinketItem ~= nil then
                -- 如果生成的物品有堆叠组件，设置其堆叠数量
                if trinketItem.components.stackable and count > 1 then
                    trinketItem.components.stackable:SetStackSize(count)
                end
                inventory:GiveItem(trinketItem)
            end
        end
        player.components.dst_gi_nahida_toy_desk_data:addToyCount(draw_count)
        return true
    end
    -- 如果是小玩具
    if NahidaIsTrinket(item) then
        local trinket_count = item.components.stackable and item.components.stackable:StackSize() or 1
        -- 生成弯曲的叉子
        local trinketItem = SpawnPrefab("trinket_17")
        if trinketItem ~= nil then
            -- 如果生成的物品有堆叠组件，设置其堆叠数量
            if trinketItem.components.stackable and trinket_count > 1 then
                trinketItem.components.stackable:SetStackSize(trinket_count)
            end
            inventory:GiveItem(trinketItem)
        end
        -- 消耗小玩具
        if item.components.stackable then
            item.components.stackable:Get(trinket_count):Remove()
        else
            item:Remove()
        end
        return true
    end
    return false
end

function dst_gi_nahida_actions_data:ThousandFloatingDreamsTrMode()
    if self.inst.whether_to_follow == nil then
        self.inst.whether_to_follow = true
    end
    if self.inst.whether_to_follow then
        self.inst.whether_to_follow = false
    else
        self.inst.whether_to_follow = true
    end
    self.inst.net_dst_gi_nahida_thousand_floating_dreams_whether_to_follow:set(self.inst.whether_to_follow)
    return true
end

-- 修改 OnSave 函数，只保存基础数据
function dst_gi_nahida_actions_data:OnSave()
    local data = {}
    -- 只保存简单的数值数据
    if self.pick_up_cd and self.pick_up_cd > 0 then
        data.pick_up_cd = self.pick_up_cd
    end
    -- 不要保存 pick_up_prefab_data，因为它可能包含函数
    -- 这个数据应该在运行时重新设置
    return next(data) ~= nil and data or nil
end

-- 修改 OnLoad 函数
function dst_gi_nahida_actions_data:OnLoad(data)
    if data and data.pick_up_cd then
        self.pick_up_cd = data.pick_up_cd
        -- 重启冷却任务
        if self.pick_up_cd > 0 then
            self:StartPickUpCdTask(self.pick_up_cd)
        end
    end
    -- pick_up_prefab_data 需要在运行时重新设置
    -- 不从存档加载
end

-- 添加清理函数
function dst_gi_nahida_actions_data:OnRemoveFromEntity()
    if self.pick_up_cd_task ~= nil then
        self.pick_up_cd_task:Cancel()
        self.pick_up_cd_task = nil
    end
end

return dst_gi_nahida_actions_data