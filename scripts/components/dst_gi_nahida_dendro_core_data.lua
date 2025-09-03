---
--- dst_gi_nahida_dendro_core_data.lua
--- Description: 草原核data
--- Author: 没有小钱钱
--- Date: 2025/5/5 21:33
---
local exclude_tags = { "INLIMBO", "companion", "wall", "abigail", "player", "chester", "zhijiang_hound" }
local function IsBurning(inst)
    if inst.components.burnable ~= nil then
        return inst.components.burnable:IsBurning()
    end
    return false
end

local dst_gi_nahida_dendro_core_data = Class(function(self, inst)
    self.inst = inst
    self.dendro_core_task = nil
    self.burn_decay_task = nil
    self.weapon_damage = 0
    self.nahida_fateseat_level = 0

end)

function dst_gi_nahida_dendro_core_data:Init(weapon_damage, nahida_fateseat_level)
    self.weapon_damage = weapon_damage
    self.nahida_fateseat_level = nahida_fateseat_level
    if self.burn_decay_task then
        self.burn_decay_task:Cancel()
    end
    self.burn_decay_task = self.inst:DoPeriodicTask(0.5, function()
        -- 判断是不是燃烧状态
        if IsBurning(self.inst) then
            if self.inst.sg ~= nil then
                -- 燃烧状态，直接爆炸,列绽放
                self.inst.sg:GoToState("pop")
                if self.burn_decay_task then
                    self.burn_decay_task:Cancel()
                    self.burn_decay_task = nil
                end
            end
        end
    end)
end

function dst_gi_nahida_dendro_core_data:InitComponents(target)
    if target.components.dst_gi_nahida_elemental_reaction == nil then
        target:AddComponent("dst_gi_nahida_elemental_reaction") -- 添加当前状态组件
    end
    if target.components.dst_gi_nahida_elemental_reaction then
        -- 初始化组件默认方法
        target.components.dst_gi_nahida_elemental_reaction:SetFateseatLevel(self.nahida_fateseat_level)
        target.components.dst_gi_nahida_elemental_reaction:InitComponents(target)
    end
end

function dst_gi_nahida_dendro_core_data:BalloonPop()
    -- 草原核爆炸
    -- 获取当前实体的位置
    if self.burn_decay_task then
        self.burn_decay_task:Cancel()
        self.burn_decay_task = nil
    end

    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 4, { "_combat" }, exclude_tags)
    for i, ent in ipairs(ents) do
        if ent ~= nil and ent:IsValid() and ent.components.health and not ent.components.health:IsDead() then
            -- 初始化元素反应组件
            self:InitComponents(ent)
            local weapon_damage = self.weapon_damage
            local additional_damage = 0
            if self.nahida_fateseat_level >= 2 then
                -- 如果纳西妲命座大于等于2 燃烧，草原核20%几率，造成2倍伤害
                -- 生成一个0到1之间的随机数
                local chance = math.random()
                -- 如果随机数小于0.2（即20%几率），则造成2倍伤害
                if chance < TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT2.PROBABILITY then
                    additional_damage = (weapon_damage * TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT2.MULTIPLIERS) - weapon_damage
                end
            end

            if ent.dst_gi_nahida_balloon_pop_cd == nil then
                ent.dst_gi_nahida_balloon_pop_cd = 0
            end
            if ent.dst_gi_nahida_balloon_pop_num == nil then
                ent.dst_gi_nahida_balloon_pop_num = 0
            end

            -- 0.5 秒最多受到2次爆炸伤害
            if ent.dst_gi_nahida_balloon_pop_cd > 0 and ent.dst_gi_nahida_balloon_pop_num >= 2 then
                return
            end
            -- 设置cd
            ent.dst_gi_nahida_balloon_pop_num = ent.dst_gi_nahida_balloon_pop_num + 1
            ent.dst_gi_nahida_balloon_pop_cd = 0.5
            ent:DoTaskInTime(0.5, function()
                ent.dst_gi_nahida_balloon_pop_cd = 0  -- 冷却结束，允许再次附着
                ent.dst_gi_nahida_balloon_pop_num = 0
            end)
            -- 触发一次草系攻击伤害
            ent.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG, ent, {
                weapon_damage = weapon_damage,
                additional_damage = additional_damage,
                is_skill = true,
                true_damage = true
            })
        end
    end
end

-- 保存当前能量和冷却时间的状态
function dst_gi_nahida_dendro_core_data:OnSave()
    local data = {
        weapon_damage = self.weapon_damage,
        nahida_fateseat_level = self.nahida_fateseat_level
    }

    return data
end

-- 加载能量和冷却时间的状态
function dst_gi_nahida_dendro_core_data:OnLoad(data)
    if data then
        if data.weapon_damage then
            self.weapon_damage = data.weapon_damage
        end
        if data.nahida_fateseat_level then
            self.nahida_fateseat_level = data.nahida_fateseat_level
        end
        self:Init(self.weapon_damage, self.nahida_fateseat_level)
    end
    if self.inst.sg ~= nil then
        -- 直接爆炸,列绽放
        self.inst.sg:GoToState("pop")
        if self.burn_decay_task then
            self.burn_decay_task:Cancel()
            self.burn_decay_task = nil
        end
    end
end

return dst_gi_nahida_dendro_core_data