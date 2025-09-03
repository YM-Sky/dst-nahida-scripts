---
--- dst_gi_nahida_elemental_reaction.lua
--- Description: 纳西妲的元素反应组件
--- Author: 没有小钱钱
--- Date: 2025/4/1 1:59
---
local exclude_tags = { "INLIMBO", "companion", "wall", "abigail", "player", "chester", "zhijiang_hound" }
-- 定义一个元素组件类
local dst_gi_nahida_elemental_reaction = Class(function(self, inst)
    self.inst = inst  -- 关联的实体实例
    self.weapon_damage = 0
    self.nahida_fateseat_level = 0
    -- 初始化元素属性，每种元素都有数量、衰减速率、持续时间
    self.elements = {
        water = { amount = 0, decay_rate = 0, duration = 0, cooldown = 0 }, -- 水元素
        fire = { amount = 0, decay_rate = 0, duration = 0, cooldown = 0 }, -- 火元素
        ice = { amount = 0, decay_rate = 0, duration = 0, cooldown = 0 }, -- 冰元素
        thunder = { amount = 0, decay_rate = 0, duration = 0, cooldown = 0 }, -- 雷元素
        grass = { amount = 0, decay_rate = 0, duration = 0, cooldown = 0 }, -- 草元素
        wind = { amount = 0, decay_rate = 0, duration = 0, cooldown = 0 }, -- 风元素
        rock = { amount = 0, decay_rate = 0, duration = 0, cooldown = 0 }, -- 岩元素
        excite = { amount = 0, decay_rate = 0, duration = 0, cooldown = 0 }, -- 激元素
        burn = { amount = 0, decay_rate = 0, duration = 0, cooldown = 0 }, -- 燃元素
        freeze = { amount = 0, decay_rate = 0.4, duration = 0, cooldown = 0 }, -- 冻元素
        physical = { amount = 0, decay_rate = 0, duration = 0, cooldown = 0 }, -- 物理，不算元素，用来计数
    }

    -- 定义元素强度
    self.strength = {
        weak = { amount = 1, duration = 9.5, decay_rate = 0.084 }, --弱元素
        medium = { amount = 1.5, duration = 10.75, decay_rate = 0.112 }, -- 中元素
        strong = { amount = 2, duration = 12, decay_rate = 0.133 }, -- 强元素
        very_strong = { amount = 4, duration = 17, decay_rate = 0.188 }, -- 强强元素
    }

    self.active_effects = {}

    self.reactions = {
        water = {  -- 水元素的反应
            ice = "FrozenReaction", -- 水与冰反应，触发冻结
            rock = "CrystallizeReaction", -- 水与岩反应，触发结晶
            fire = "EvaporateReaction", -- 水与火反应，触发蒸发
            grass = "BloomReaction", -- 水与草反应，触发绽放
            wind = "SwirlReaction", -- 水与风反应，触发扩散
            thunder = "ElectroChargedReaction"  -- 水与雷反应，触发感电
        },
        ice = {  -- 冰元素的反应
            water = "FrozenReaction", -- 冰与水反应，触发冻结
            fire = "MeltReaction", -- 冰与火反应，触发融化
            thunder = "SuperconductReaction", -- 冰与雷反应，触发超导
            rock = "CrystallizeReaction", -- 冰与岩反应，触发结晶
            wind = "SwirlReaction"  -- 冰与风反应，触发扩散
        },
        thunder = {  -- 雷元素的反应
            ice = "SuperconductReaction", -- 雷与冰反应，触发超导
            water = "ElectroChargedReaction", -- 雷与水反应，触发感电
            fire = "OverloadReaction", -- 雷与火反应，触发超载
            grass = "QuickenReaction", -- 雷与草反应，触发原激化
            rock = "CrystallizeReaction", -- 雷与岩反应，触发结晶
            wind = "SwirlReaction"  -- 雷与风反应，触发扩散
        },
        fire = {  -- 火元素的反应
            water = "EvaporateReaction", -- 火与水反应，触发蒸发
            ice = "MeltReaction", -- 火与冰反应，触发融化
            thunder = "OverloadReaction", -- 火与雷反应，触发超载
            grass = "BurnReaction", -- 火与草反应，触发燃烧
            rock = "CrystallizeReaction", -- 火与岩反应，触发结晶
            wind = "SwirlReaction"  -- 火与风反应，触发扩散
        },
        grass = {  -- 草元素的反应
            water = "BloomReaction", -- 草与水反应，触发绽放
            fire = "BurnReaction", -- 草与火反应，触发燃烧
            thunder = "QuickenReaction"  -- 草与雷反应，触发原激化
        },
        excite = {  -- 激元素的反应
            grass = "OvergrowReaction", -- 激元素与草反应，触发蔓激化
            thunder = "HyperbloomReaction"  -- 激元素与雷反应，触发超激化
        },
        wind = {  -- 风元素的反应
            water = "SwirlReaction", -- 风与水反应，触发扩散
            fire = "SwirlReaction", -- 风与火反应，触发扩散
            ice = "SwirlReaction", -- 风与冰反应，触发扩散
            thunder = "SwirlReaction"  -- 风与雷反应，触发扩散
        },
        rock = {  -- 岩元素的反应
            fire = "CrystallizeReaction", -- 岩与火反应，触发结晶
            ice = "CrystallizeReaction", -- 岩与冰反应，触发结晶
            thunder = "CrystallizeReaction",  -- 岩与雷反应，触发结晶
            freeze = "IceCrushingReaction"  -- 岩与冻元素反应，触发碎冰
        },
        freeze = {
            rock = "IceCrushingReaction", -- 岩与冻元素反应，触发碎冰
            physical = "IceCrushingReaction", -- 物理与冻元素反应，触发碎冰
        },
        physical = {
            freeze = "IceCrushingReaction" -- 物理与冻元素反应，触发碎冰
        }
    }

    -- 附着冷却时间
    self.cooldown_time = 1.5

    -- 公共附着队列
    self.attachment_queue = {}

    -- 启动组件的更新，以便在游戏循环中定期调用 OnUpdate 方法
    self.inst:StartUpdatingComponent(self)
    -- 启动元素衰减的定时任务
    self.start_decay_task = nil
    self.dendro_core_cd = 0
    self.dendro_core_max_cd = 0.2
end)

-- 在目标的 health 组件中添加死亡事件监听器
function dst_gi_nahida_elemental_reaction:InitDeathListener(target)
    if target.components.health then
        target:ListenForEvent("death", function()
            self:OnTargetDeath(target)
        end)
    end
end

function dst_gi_nahida_elemental_reaction:SetFateseatLevel(level)
    if level > self.nahida_fateseat_level then
        self.nahida_fateseat_level = level
    end
end

-- 目标死亡时的清理函数
function dst_gi_nahida_elemental_reaction:OnTargetDeath(target)
    -- 移除所有元素
    for type, element in pairs(self.elements) do
        element.amount = 0
        element.cooldown = 0
    end
    -- 取消所有定时任务
    if self.burn_decay_task then
        self.burn_decay_task:Cancel()
        self.burn_decay_task = nil
    end

    if self.excite_decay_task then
        self.excite_decay_task:Cancel()
        self.excite_decay_task = nil
    end
    -- 移除所有特效
    for type, fx in pairs(self.active_effects) do
        if fx then
            fx:Remove()
        end
    end
    self.active_effects = {}  -- 清空特效跟踪表
    -- 移除当前组件
    target:RemoveComponent("dst_gi_nahida_elemental_reaction")
end

-- 在初始化时调用 AddElementalAttackListener
function dst_gi_nahida_elemental_reaction:InitComponents(target)
    self:InitDeathListener(target)
    -- 其他初始化代码...
end

-- 设置武器面板伤害
function dst_gi_nahida_elemental_reaction:SetAttachDamage(weapon_damage)
    -- 每次更新取最高面板的武器作为当前状态
    if weapon_damage then
        if self.weapon_damage then
            if self.weapon_damage < weapon_damage then
                self.weapon_damage = weapon_damage
            end
            return
        else
            self.weapon_damage = weapon_damage
        end
    end
end

-- 获取武器面板伤害
function dst_gi_nahida_elemental_reaction:GetAttachDamage()
    return self.weapon_damage
end

-- 更新方法，每帧调用一次，用于更新技能和爆发的冷却时间
function dst_gi_nahida_elemental_reaction:OnUpdate(dt)
    self:StartDecayTask()
    local is_raining = TheWorld.state.israining
    local is_wet = self.inst.components.moisture and self.inst.components.moisture:GetMoisturePercent() > 0
    local is_burning = self.inst.components.burnable and self.inst.components.burnable:IsBurning()
    -- 如果下雨或潮湿，附加弱水元素
    if is_raining or is_wet then
        self:AttachElement(TUNING.ELEMENTAL_TYPE.WATER, TUNING.ELEMENTAL_STRENGTH.WEAK)
        self:ConsumeAndReactDoDelta(TUNING.ELEMENTAL_TYPE.WATER, self.inst, {
            weapon_damage = 0,
            additional_damage = 0,
            is_skill = true
        })
        -- 如果燃烧且没有下雨或潮湿，附加弱火元素
    elseif is_burning then
        self:AttachElement(TUNING.ELEMENTAL_TYPE.FIRE, TUNING.ELEMENTAL_STRENGTH.WEAK)
        self:ConsumeAndReactDoDelta(TUNING.ELEMENTAL_TYPE.FIRE, self.inst, {
            weapon_damage = self:GetAttachDamage(),
            additional_damage = 0,
            is_skill = true
        })
    end
end

-- 附着元素的方法
-- @param type: 元素类型（如 "water", "fire"）
-- @param strength: 元素强度（影响衰减速率和持续时间）
function dst_gi_nahida_elemental_reaction:AttachElement(type, strength)
    local element = self.elements[type]
    if element == nil or element.cooldown > 0 then
        return
    end  -- 如果元素类型无效或在冷却中，直接返回

    local strength_data = self.strength[strength]
    if not strength_data then
        return
    end  -- 如果强度数据无效，直接返回

    -- 处理同元素叠加逻辑
    if strength_data.amount > element.amount then
        element.amount = strength_data.amount * 0.8  -- 基础附着量为80%
        if type == "fire" or type == "excite" then
            -- 对于火元素和激元素，替换衰减速率
            element.decay_rate = strength_data.decay_rate
        else
            if element.decay_rate == 0 then
                element.decay_rate = strength_data.decay_rate  -- 设置衰减速率
            end
        end
        -- 对于其他元素，只替换元素量
    end

    -- 将附着信息添加到公共队列中
    table.insert(self.attachment_queue, { type = type, amount = element.amount, time = os.time() })

    -- 启动冷却
    element.cooldown = self.cooldown_time
    self.inst:DoTaskInTime(self.cooldown_time, function()
        element.cooldown = 0  -- 冷却结束，允许再次附着
    end)
end

-- 消耗元素并触发反应
-- @param type: 攻击者的元素类型
-- @param target: 目标实体
-- @param damage_data: 伤害数据
function dst_gi_nahida_elemental_reaction:ConsumeAndReactDoDelta(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    local weapon_damage = damage_data.weapon_damage or 0
    self:SetAttachDamage(weapon_damage) -- 设置一次面板值
    -- 定义元素反应映射表
    -- 定义元素反应映射表
    -- 这个表用于定义不同元素之间的反应类型
    local reaction_triggered = false  -- 标记是否触发了反应

    -- 遍历公共附着队列，检查是否可以触发反应
    for i = #self.attachment_queue, 1, -1 do
        local entry = self.attachment_queue[i]  -- 从队列中获取一个附着信息
        local type1 = entry.type
        local amount1 = entry.amount
        -- 检查是否有可以反应的元素
        if (self.reactions[type1] and self.reactions[type1][type]) then
            local reaction = self.reactions[type1][type]
            local element2 = self.elements[type]
            if (type == TUNING.ELEMENTAL_TYPE.PHYSICAL or element2.amount > 0) and self.elements[type1].amount > 0 then
                if type == TUNING.ELEMENTAL_TYPE.PHYSICAL then -- 物理攻击不消耗元素
                    self:ReduceElement(type1, 1)  -- 消耗冻元素1点 但是消耗反应元素的冻元素
                else
                    local amount2 = element2.amount
                    local consume_amount = math.min(amount1, amount2)  -- 计算消耗量
                    self:ReduceElement(type1, consume_amount)  -- 消耗元素1
                    self:ReduceElement(type, consume_amount)  -- 消耗元素2
                end
                if reaction == "BloomReaction" then
                    -- 绽放反应 生成草原核，不直接造成伤害
                    self[reaction](self, type, target, damage_data)
                    table.remove(self.attachment_queue, i)  -- 移除已处理的附着信息
                    reaction_triggered = false
                    break
                elseif reaction == "BurnReaction" then
                    -- 燃烧反应 生成燃元素，不直接造成伤害
                    self[reaction](self, type, target, damage_data)
                    table.remove(self.attachment_queue, i)  -- 移除已处理的附着信息
                    reaction_triggered = false
                    break
                elseif reaction == "QuickenReaction" then
                    -- 原激化反应 生成激元素，不直接造成伤害
                    self[reaction](self, type, target, damage_data)
                    table.remove(self.attachment_queue, i)  -- 移除已处理的附着信息
                    reaction_triggered = false
                    break
                else
                    self[reaction](self, type, target, damage_data)  -- 触发反应
                    reaction_triggered = true
                    table.remove(self.attachment_queue, i)  -- 移除已处理的附着信息
                    break
                end
            end
        end
    end

    return reaction_triggered
end

-- 燃元素衰减
function dst_gi_nahida_elemental_reaction:StartBurnDecay(damage_data)
    if self.burn_decay_task then
        self.burn_decay_task:Cancel()
    end

    self.burn_decay_task = self.inst:DoPeriodicTask(0.25, function()
        local burn = self.elements.burn
        if burn.amount > 0 then
            local consume_amount = math.min(burn.amount, 0.4)
            burn.amount = burn.amount - consume_amount
            if consume_amount > 0 then
                -- 对持有者造成火焰伤害
                if self.inst.components.health and not self.inst.components.health:IsDead() then
                    -- *  TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.Burn
                    local weapon_damage = damage_data.weapon_damage or 0
                    if self.nahida_fateseat_level >= 2 then
                        -- 如果纳西妲命座大于等于2 燃烧，草原核20%几率，造成2倍伤害
                        -- 生成一个0到1之间的随机数
                        local chance = math.random()
                        -- 如果随机数小于0.2（即20%几率），则造成2倍伤害
                        if chance < TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT2.PROBABILITY then
                            weapon_damage = weapon_damage * TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT2.MULTIPLIERS
                        end
                    end
                    self:FireAttack(TUNING.ELEMENTAL_STRENGTH.WEAK, self.inst, { weapon_damage = weapon_damage * TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.Burn, is_skill = true })  -- 对持有者造成火焰伤害
                    self:ConsumeAndReactDoDelta(TUNING.ELEMENTAL_TYPE.FIRE, self.inst, damage_data) --做一次元素消耗
                end
                -- 如果目标可以被点燃，应用火焰效果 持续点染
                if self.inst.components.burnable then
                    self.inst.components.burnable:Ignite()
                end
            end
        else
            self.burn_decay_task:Cancel()
            self.burn_decay_task = nil
        end
    end)
end

-- 激元素衰减
function dst_gi_nahida_elemental_reaction:StartExciteDecay()
    if self.excite_decay_task then
        self.excite_decay_task:Cancel()
    end

    self.excite_decay_task = self.inst:DoPeriodicTask(0.25, function()
        local excite = self.elements.excite
        if excite.amount > 0 then
            local consume_amount = math.min(excite.amount, 0.4)
            excite.amount = excite.amount - consume_amount
            -- 激元素不直接造成伤害
        else
            self.excite_decay_task:Cancel()
            self.excite_decay_task = nil
        end
    end)
end

-- 减少元素的方法
-- @param type: 元素类型
-- @param amount: 要减少的元素数量
function dst_gi_nahida_elemental_reaction:ReduceElement(type, amount)
    local element = self.elements[type]
    element.amount = math.max(element.amount - amount, 0)  -- 确保元素量不低于0
end

-- 启动元素衰减的定时任务
function dst_gi_nahida_elemental_reaction:StartDecayTask()
    if self.start_decay_task == nil then
        self.start_decay_task = self.inst:DoPeriodicTask(1, function()
            for type, element in pairs(self.elements) do
                if element.amount > 0 then
                    -- 如果特效不存在，则生成特效
                    --if not self.active_effects[type] then
                    --    self:SpawnElementEffect(type)
                    --end
                    element.amount = element.amount - element.decay_rate  -- 减少元素数量
                else
                    -- 如果特效存在且元素数量小于等于0，则移除特效
                    --if self.active_effects[type] then
                    --    self:RemoveElementEffect(type)
                    --end
                end
            end
            -- 更新所有特效的偏移
            --self:UpdateEffectOffsets()
        end)
    end
end

function dst_gi_nahida_elemental_reaction:SpawnElementEffect(type)
    local fx_prefab = "dst_gi_nahida_element_spear_" .. type
    local fx = SpawnPrefab(fx_prefab)
    -- 获取实体的位置
    local x, y, z = self.inst.Transform:GetWorldPosition()
    if fx then
        -- 设置特效的位置，应用高度偏移
        local height_offset = 4.0  -- 确保特效在头顶
        fx.Transform:SetPosition(x, y + height_offset, z)
        self.active_effects[type] = fx  -- 存储特效引用
    end
end

function dst_gi_nahida_elemental_reaction:UpdateEffectOffsets()
    local offset = 0
    local offset_step = 2  -- 每个特效的偏移量
    local x, y, z = self.inst.Transform:GetWorldPosition()
    for _, fx in pairs(self.active_effects) do
        if fx and fx:IsValid() then
            local height_offset = 4.0  -- 确保特效在头顶
            fx.Transform:SetPosition(x + offset, y + height_offset, z)  -- 使用 x 轴偏移
            offset = offset + offset_step
        end
    end
end

function dst_gi_nahida_elemental_reaction:RemoveElementEffect(type)
    if self.active_effects[type] then
        self.active_effects[type]:Remove()  -- 移除特效
        self.active_effects[type] = nil
    end
end

-- 造成伤害
-- @param element_type: 元素类型
-- @param target: 目标实体
-- @param damage_data: 伤害数据
-- @param damage_data.weapon_damage: 武器伤害
-- @param damage_data.additional_damage: 追加伤害
-- @param damage_data.is_skill: 是否是技能 true 技能 false 普攻
-- @param damage_data.true_damage: 是否真伤 true 真伤 false 普通伤害
-- @param multiplier: 伤害倍率
function dst_gi_nahida_elemental_reaction:ApplyDamage(element_type, target, damage_data, multiplier)
    local weapon_damage = damage_data.weapon_damage or 0
    local additional_damage = damage_data.additional_damage or 0
    local is_skill = damage_data.is_skill ~= nil and damage_data.is_skill or false
    local true_damage = damage_data.true_damage ~= nil and damage_data.true_damage or false

    local total_damage = weapon_damage + additional_damage
    local calculated_damage = 0
    if is_skill then
        -- 技能伤害：计算总伤害
        calculated_damage = total_damage * multiplier
    else
        -- 普攻伤害：只计算追加伤害的部分
        calculated_damage = total_damage * multiplier - weapon_damage
    end
    local final_damage = math.ceil(calculated_damage)  -- 计算最终伤害
    local display_damage = math.ceil(total_damage * multiplier * 10) / 10   -- 显示伤害

    if target ~= nil and target:IsValid() and target.components.health and not target.components.health:IsDead() then
        if display_damage and display_damage > 0 then
            SpawnNahidaTips(target, element_type, display_damage)
        end
        if final_damage > 0 then
            -- 真伤
            if true_damage then
                target.components.health:DoDelta(
                        -final_damage,           -- 伤害值
                        false,            -- 非持续伤害
                        "elemental_reaction", -- 伤害原因
                        true,             -- 无视无敌
                        nil,        -- 施法者
                        true              -- 无视护甲
                )
            else
                target.components.health:DoDelta(-final_damage, nil, nil)  -- 施加伤害
            end
        end
    end
end

-- 示例反应方法
-- 蒸发反应
function dst_gi_nahida_elemental_reaction:EvaporateReaction(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    local ratio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.Evaporate
    self:ApplyDamage(type, target, damage_data, ratio)

end

-- 冻结反应
function dst_gi_nahida_elemental_reaction:FrozenReaction(type, target, damage_data)
    local ratio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.Frozen
    self:ApplyDamage(type, target, damage_data, ratio)
    if TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.FREEZE_REACTION_ENABLE then
        if target.components.freezable ~= nil and target:IsValid() then
            target.components.freezable:AddColdness(10)
            target.components.freezable:SpawnShatterFX()
        end
    end
    -- 生成冻元素元素
    self:AttachElement(TUNING.ELEMENTAL_TYPE.FREEZE, TUNING.ELEMENTAL_STRENGTH.STRONG)
end

-- 感电反应
function dst_gi_nahida_elemental_reaction:ElectroChargedReaction(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    local ratio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.ElectroCharged
    self:ApplyDamage(type, target, damage_data, ratio)
end

-- 燃烧反应
function dst_gi_nahida_elemental_reaction:BurnReaction(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    -- 生成燃元素
    self:AttachElement(TUNING.ELEMENTAL_TYPE.BURN, TUNING.ELEMENTAL_STRENGTH.STRONG)
    -- 持续衰减燃元素任务
    self:StartBurnDecay(damage_data)
end

-- 融化反应
function dst_gi_nahida_elemental_reaction:MeltReaction(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    local ratio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.Melt
    self:ApplyDamage(type, target, damage_data, ratio)
end

-- 激化反应
function dst_gi_nahida_elemental_reaction:QuickenReaction(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    -- 生成激元素
    self:AttachElement(TUNING.ELEMENTAL_TYPE.EXCITE, TUNING.ELEMENTAL_STRENGTH.STRONG)
    -- 开启持续衰减激元素任务
    self:StartExciteDecay()
end

function dst_gi_nahida_elemental_reaction:SpawnDendroCoreAroundEntity(entity, prefab_name, weapon_damage, nahida_fateseat_level)
    local dendro_core_fx = SpawnPrefab(prefab_name)
    if dendro_core_fx.components.dst_gi_nahida_dendro_core_data then
        dendro_core_fx.components.dst_gi_nahida_dendro_core_data:Init(weapon_damage, nahida_fateseat_level)
    end
    -- 获取角色当前位置
    local x, y, z = entity.Transform:GetWorldPosition()

    -- 计算随机偏移量
    local range = 1
    local offset_x = math.random() * range * 2 - range
    local offset_z = math.random() * range * 2 - range
    -- 设置草原核生成位置
    dendro_core_fx.Transform:SetPosition(x + offset_x, y, z + offset_z)
    return dendro_core_fx
end

-- 绽放反应
function dst_gi_nahida_elemental_reaction:BloomReaction(type, target, damage_data)
    -- 这里可以添加绽放反应的具体逻辑
    -- 例如生成草原核或其他效果 0.2 秒最多生成一个草原核
    if self.dendro_core_cd > 0 then
        return
    end
    -- 生成草原核
    self:SpawnDendroCoreAroundEntity(self.inst, "dst_gi_nahida_dendro_core", damage_data and damage_data.weapon_damage or 0, self.nahida_fateseat_level)

    self.dendro_core_cd = self.dendro_core_max_cd
    self.inst:DoTaskInTime(self.dendro_core_max_cd, function()
        self.dendro_core_cd = 0  -- 冷却结束，允许再次附着
    end)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local dendro_core_array = TheSim:FindEntities(x, y, z, 8, { "dst_gi_nahida_dendro_core" }, exclude_tags)
    local dendro_core_num = #dendro_core_array
    if dendro_core_num > 5 then
        local more_dendro_core_num = dendro_core_num - 5
        for i, ent in ipairs(dendro_core_array) do
            if i > more_dendro_core_num then
                break
            end
            if ent.sg ~= nil then
                -- 超过5个，多余的直接爆炸
                ent.sg:GoToState("pop")
            end
        end
    end


end

-- 结晶反应
function dst_gi_nahida_elemental_reaction:CrystallizeReaction(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    local ratio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.Crystallize
    self:ApplyDamage(type, target, damage_data, ratio)
end

-- 扩散反应
function dst_gi_nahida_elemental_reaction:SwirlReaction(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    local ratio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.Swirl
    self:ApplyDamage(type, target, damage_data, 1)
    -- 获取当前实体的位置
    local x, y, z = target.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 4, { "_combat" }, exclude_tags)
    for i, ent in ipairs(ents) do
        if ent ~= nil and ent:IsValid() and ent.components.health and not ent.components.health:IsDead() then
            AddDstGiNahidaElementalReactionComponents(ent,ent)
            -- 初始化元素反应组件
            if ent.components.dst_gi_nahida_elemental_reaction == nil then
                ent:AddComponent("dst_gi_nahida_elemental_reaction") -- 添加当前状态组件
            end
            -- 初始化元素反应组件
            if target.components.dst_gi_nahida_elemental_reaction == nil then
                target:AddComponent("dst_gi_nahida_elemental_reaction") -- 添加当前状态组件
            end
            if ent.components.dst_gi_nahida_elemental_reaction and target.components.dst_gi_nahida_elemental_reaction then
                -- 初始化组件默认方法
                ent.components.dst_gi_nahida_elemental_reaction:InitComponents(ent)
                -- 赋予命座效果
                ent.components.dst_gi_nahida_elemental_reaction:SetFateseatLevel(target.components.dst_gi_nahida_elemental_reaction.nahida_fateseat_level)
            end
            -- 添加buff组件
            if not ent.components.debuffable then
                ent:AddComponent("debuffable")
            end
            -- 触发一次扩散伤害
            if ent.components.dst_gi_nahida_elemental_reaction then
                ent.components.dst_gi_nahida_elemental_reaction:ApplyDamage(type, ent, damage_data, ratio)
            end
        end
    end
end

-- 蔓激化反应
function dst_gi_nahida_elemental_reaction:OvergrowReaction(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    local ratio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.Overgrow
    self:ApplyDamage(type, target, damage_data, ratio)
end

-- 超激化反应
function dst_gi_nahida_elemental_reaction:HyperbloomReaction(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    local ratio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.Hyperbloom
    self:ApplyDamage(type, target, damage_data, ratio)
end

-- 超导反应
function dst_gi_nahida_elemental_reaction:SuperconductReaction(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    local ratio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.Superconduct  -- 超导反应倍率
    self:ApplyDamage(type, target, damage_data, ratio)
end

-- 碎冰反应
function dst_gi_nahida_elemental_reaction:IceCrushingReaction(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    local ratio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.Shatter  -- 碎冰反应倍率（物理）
    if type == TUNING.ELEMENTAL_TYPE.ROCK  then -- 如果是岩元素，则使用岩元素碎冰倍率
        ratio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.RockShatter -- 岩元素碎冰倍率
    end
    self:ApplyDamage(type, target, damage_data, ratio)
end

-- 超载反应
function dst_gi_nahida_elemental_reaction:OverloadReaction(type, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    local ratio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.Overload
    local overloadBoomRatio = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_REACTION_MULTIPLIERS.OverloadBoom
    self:ApplyDamage(type, target, damage_data, ratio)
    -- 获取当前实体的位置 超载造成范围火伤
    local x, y, z = target.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 2, { "_combat" }, exclude_tags)
    for i, ent in ipairs(ents) do
        if ent ~= nil and ent:IsValid() and ent.components.health and not ent.components.health:IsDead() then
            AddDstGiNahidaElementalReactionComponents(ent,ent)
            -- 初始化元素反应组件
            if ent.components.dst_gi_nahida_elemental_reaction == nil then
                ent:AddComponent("dst_gi_nahida_elemental_reaction") -- 添加当前状态组件
            end
            if target.components.dst_gi_nahida_elemental_reaction == nil then
                target:AddComponent("dst_gi_nahida_elemental_reaction") -- 添加当前状态组件
            end
            if ent.components.dst_gi_nahida_elemental_reaction and target.components.dst_gi_nahida_elemental_reaction then
                -- 初始化组件默认方法
                ent.components.dst_gi_nahida_elemental_reaction:InitComponents(ent)
                -- 赋予命座效果
                ent.components.dst_gi_nahida_elemental_reaction:SetFateseatLevel(target.components.dst_gi_nahida_elemental_reaction.nahida_fateseat_level)
            end
            -- 添加buff组件
            if not ent.components.debuffable then
                ent:AddComponent("debuffable")
            end
            if ent.components.dst_gi_nahida_elemental_reaction then
                -- 触发一次超载伤害
                ent.components.dst_gi_nahida_elemental_reaction:ApplyDamage(TUNING.ELEMENTAL_TYPE.FIRE, ent, damage_data, overloadBoomRatio)
            end
        end
    end
    -- 这里可以添加范围伤害的逻辑
end
-- 物理攻击方法
function dst_gi_nahida_elemental_reaction:PhysicalAttack(strength, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    --self:AttachElement(TUNING.ELEMENTAL_TYPE.PHYSICAL, TUNING.ELEMENTAL_STRENGTH.WEAK)
    local reaction_triggered = self:ConsumeAndReactDoDelta(TUNING.ELEMENTAL_TYPE.PHYSICAL, target, damage_data)
    if not reaction_triggered then
        self:ApplyDamage(TUNING.ELEMENTAL_TYPE.PHYSICAL, target, damage_data, 1)
    end
end

-- 水元素攻击方法
function dst_gi_nahida_elemental_reaction:WaterAttack(strength, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    self:AttachElement(TUNING.ELEMENTAL_TYPE.WATER, strength)
    local reaction_triggered = self:ConsumeAndReactDoDelta(TUNING.ELEMENTAL_TYPE.WATER, target, damage_data)
    if not reaction_triggered then
        self:ApplyDamage(TUNING.ELEMENTAL_TYPE.WATER, target, damage_data, 1)
    end
end

-- 火元素攻击方法
function dst_gi_nahida_elemental_reaction:FireAttack(strength, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    self:AttachElement(TUNING.ELEMENTAL_TYPE.FIRE, strength)
    local reaction_triggered = self:ConsumeAndReactDoDelta(TUNING.ELEMENTAL_TYPE.FIRE, target, damage_data)
    if not reaction_triggered then
        self:ApplyDamage(TUNING.ELEMENTAL_TYPE.FIRE, target, damage_data, 1)
    end
end

-- 冰元素攻击方法
function dst_gi_nahida_elemental_reaction:IceAttack(strength, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    self:AttachElement(TUNING.ELEMENTAL_TYPE.ICE, strength)
    local reaction_triggered = self:ConsumeAndReactDoDelta(TUNING.ELEMENTAL_TYPE.ICE, target, damage_data)
    if not reaction_triggered then
        self:ApplyDamage(TUNING.ELEMENTAL_TYPE.ICE, target, damage_data, 1)
    end
end

-- 雷元素攻击方法
function dst_gi_nahida_elemental_reaction:ThunderAttack(strength, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    self:AttachElement(TUNING.ELEMENTAL_TYPE.THUNDER, strength)
    local reaction_triggered = self:ConsumeAndReactDoDelta(TUNING.ELEMENTAL_TYPE.THUNDER, target, damage_data)
    if not reaction_triggered then
        if self.elements.excite.amount > 0 then
            -- 如果存在激元素，造成超激化伤害
            self:HyperbloomReaction(TUNING.ELEMENTAL_TYPE.THUNDER, target, damage_data)
        else
            self:ApplyDamage(TUNING.ELEMENTAL_TYPE.THUNDER, target, damage_data, 1)
        end
    end

    -- 获取当前实体的位置 直接引爆草原核
    local x, y, z = target.Transform:GetWorldPosition()
    local dendro_core_array = TheSim:FindEntities(x, y, z, 4, { "dst_gi_nahida_dendro_core" }, exclude_tags)
    local dendro_core_num = #dendro_core_array
    if dendro_core_num > 0 then
        for i, ent in ipairs(dendro_core_array) do
            if ent.sg ~= nil then
                ent.sg:GoToState("pop")
            end
        end
    end

end

-- 风元素攻击方法
function dst_gi_nahida_elemental_reaction:WindAttack(strength, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    self:AttachElement(TUNING.ELEMENTAL_TYPE.WIND, strength)
    local reaction_triggered = self:ConsumeAndReactDoDelta(TUNING.ELEMENTAL_TYPE.WIND, target, damage_data)
    if not reaction_triggered then
        self:ApplyDamage(TUNING.ELEMENTAL_TYPE.WIND, target, damage_data, 1)
    end
end

-- 岩元素攻击方法
function dst_gi_nahida_elemental_reaction:RockAttack(strength, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    self:AttachElement(TUNING.ELEMENTAL_TYPE.ROCK, strength)
    local reaction_triggered = self:ConsumeAndReactDoDelta(TUNING.ELEMENTAL_TYPE.ROCK, target, damage_data)
    if not reaction_triggered then
        self:ApplyDamage(TUNING.ELEMENTAL_TYPE.ROCK, target, damage_data, 1)
    end
end

-- 草元素攻击方法
function dst_gi_nahida_elemental_reaction:GrassAttack(strength, target, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    self:AttachElement(TUNING.ELEMENTAL_TYPE.GRASS, strength)
    local reaction_triggered = self:ConsumeAndReactDoDelta(TUNING.ELEMENTAL_TYPE.GRASS, target, damage_data)
    if not reaction_triggered then
        if self.elements.excite.amount > 0 then
            -- 如果存在激元素，造成蔓激化伤害
            self:OvergrowReaction(TUNING.ELEMENTAL_TYPE.GRASS, target, damage_data)
        else
            self:ApplyDamage(TUNING.ELEMENTAL_TYPE.GRASS, target, damage_data, 1)
        end
    end
end

-- 造成伤害
-- @param elemental_attack_type: 元素攻击类型
-- @param strength: 元素强度
-- @param attacker: 攻击者
-- @param target: 被攻击者
-- @param weapon: 武器
-- @param stimuli: 倍率
-- @param is_skill: 是否是技能
-- @param damage_data: 伤害数据
-- @param damage_data.weapon_damage: 武器伤害
-- @param damage_data.additional_damage: 追加伤害
-- @param damage_data.is_skill: 是否是技能 true 技能 false 普攻
function dst_gi_nahida_elemental_reaction:DoAttack(elemental_attack_type, strength,attacker, target, weapon, stimuli, is_skill, damage_data)
    AddDstGiNahidaElementalReactionComponents(target,target)
    if stimuli == nil then
        stimuli = 1
    end
    if is_skill == nil then
        is_skill = false
    end
    if damage_data then
        self[elemental_attack_type](self, strength, target, damage_data)
        return true
    else
        local weapon_damage = 0
        if weapon and weapon.components.weapon then
            weapon_damage = weapon.components.weapon:GetDamage(attacker, target)
        else
            weapon_damage = attacker.components.combat.defaultdamage or 0
        end
        local additional_damage = (weapon_damage * stimuli - weapon_damage)
        local _damage_data = {
            weapon_damage = weapon_damage,
            additional_damage = additional_damage,
            is_skill = is_skill,
            true_damage = true
        }
        self[elemental_attack_type](self, strength, target, _damage_data)
    end

end

-- 保存当前能量和冷却时间的状态
function dst_gi_nahida_elemental_reaction:OnSave()
    local data = {
        elements = {},
        active_effects = self.active_effects,
        weapon_damage = self.weapon_damage,
        attachment_queue = self.attachment_queue
    }

    for type, element in pairs(self.elements) do
        data.elements[type] = {
            amount = element.amount,
            decay_rate = element.decay_rate,
            duration = element.duration,
            cooldown = element.cooldown
        }
    end
    return data
end

-- 加载能量和冷却时间的状态
function dst_gi_nahida_elemental_reaction:OnLoad(data)
    if data then
        if data.weapon_damage then
            self.weapon_damage = data.weapon_damage
            self.attachment_queue = data.attachment_queue
        end

        if data.active_effects then
            self.active_effects = data.active_effects
        end

        if data.elements then
            for type, element_data in pairs(data.elements) do
                if self.elements[type] then
                    self.elements[type].amount = element_data.amount or 0
                    self.elements[type].decay_rate = element_data.decay_rate or 0
                    self.elements[type].duration = element_data.duration or 0
                    self.elements[type].cooldown = element_data.cooldown or 0
                end
            end
        end
    end
end

return dst_gi_nahida_elemental_reaction