---
--- dst_gi_nahida_four_leaf_clover_data.lua
--- Description: 蕴种印核心数据
--- Author: 没有小钱钱
--- Date: 2025/4/20 13:11
---
local dst_gi_nahida_four_leaf_clover_data = Class(function(self, inst)
    self.inst = inst
    self.seed_of_skandha_count = 6 -- 冷却时间为180秒
    self.seed_of_skandha_level2_stimuli = 1.68 -- 灭净三叶*业障除(6命效果) 0.2秒内触发一次灭净三叶，对敌人造成300%伤害
    self.level2_cooldown_time = 0.2 -- 灭净三叶*业障除触发间隔
    self.current_level2_cooldown_time = 0 -- 冷却时间

    self.seed_of_skandha_level1_stimuli = 1.44 -- 灭净三叶 2.5秒内触发一次灭净三叶，对敌人造成300%伤害
    self.level1_cooldown_time = 2.5 -- 灭净三叶触发间隔
    self.current_level1_cooldown_time = 0 -- 冷却时间

    self.energy_max_cd = 10 -- 灭净三叶触发间隔
    self.current_energy_cd = 0 -- 冷却时间
end)

function dst_gi_nahida_four_leaf_clover_data:SetSeedOfSkandhaCount()
    -- 初始化定时任务表
    if self._seed_task ~= nil then
        self._seed_task:Cancel()
    end
    -- 设置种子数量
    self.seed_of_skandha_count = 6
    -- 设置新的定时任务，持续10秒
    self._seed_task = self.inst:DoTaskInTime(10, function(inst)
        self.seed_of_skandha_count = 0
        self._seed_task = nil
    end)
end

function dst_gi_nahida_four_leaf_clover_data:SeedOfSkandhaLevel2Attack(player,weapon,isMaster,target, weapon_damage, additional_damage)
    -- 如果没有这个组件，直接返回
    if target.components.dst_gi_nahida_four_leaf_clover_data == nil then
        if target.components.dst_gi_nahida_elemental_reaction then
            if weapon and TUNING.ELEMENTAL_WEAPON[weapon.prefab] then
                if weapon.prefab == "dst_gi_nahida_weapon_staff" and  weapon.components.container ~= nil then
                    local item = weapon.components.container.slots[1]
                    if item and TUNING.ELEMENTAL_WEAPON[item.prefab] then
                        TUNING.ELEMENTAL_WEAPON[item.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                    else
                        TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                    end
                else
                    TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                end
            else
                target.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                        target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
            end
        end
        return
    end
    local four_leaf_clover_data =  target.components.dst_gi_nahida_four_leaf_clover_data
    if additional_damage == nil then
        additional_damage = 0
    end
    if four_leaf_clover_data.current_level2_cooldown_time > 0 then
        if isMaster then -- 如果是主攻击对象，不受cd影响，则换位普攻伤害
            if target.components.dst_gi_nahida_elemental_reaction then
                if weapon and TUNING.ELEMENTAL_WEAPON[weapon.prefab] then
                    if weapon.prefab == "dst_gi_nahida_weapon_staff" and weapon.components.container ~= nil then
                        local item = weapon.components.container.slots[1]
                        if item and TUNING.ELEMENTAL_WEAPON[item.prefab] then
                            TUNING.ELEMENTAL_WEAPON[item.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                    target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                        else
                            TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                    target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                        end
                    else
                        TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                    end
                else
                    target.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                end
            end
        end
        return
    end
    if target.components.dst_gi_nahida_elemental_reaction and four_leaf_clover_data.seed_of_skandha_count > 0 then
        -- 当有6命效果时，普攻伤害升级为技能伤害,灭净三叶*业障除(6命效果) 0.2秒内触发一次灭净三叶，对敌人造成300%伤害
        local _additional_damage = (weapon_damage + additional_damage) * self.seed_of_skandha_level2_stimuli - weapon_damage
        target.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                target, { weapon_damage = weapon_damage, additional_damage = _additional_damage, is_skill = true,true_damage = true })

        four_leaf_clover_data.seed_of_skandha_count = four_leaf_clover_data.seed_of_skandha_count - 1
        -- 启动冷却
        four_leaf_clover_data.current_level2_cooldown_time = four_leaf_clover_data.level2_cooldown_time
        target:DoTaskInTime(self.level2_cooldown_time, function()
            four_leaf_clover_data.current_level2_cooldown_time = 0  -- 冷却结束，允许再次触发
        end)

        if four_leaf_clover_data.current_energy_cd > 0 then
            return
        end
        four_leaf_clover_data.current_energy_cd = self.energy_max_cd
        player:DoTaskInTime(self.energy_max_cd, function()
            four_leaf_clover_data.current_energy_cd = 0  -- 冷却结束，允许再次触发
        end)
        if player.components.dst_gi_nahida_skill then
            -- 恢复25点能量
            player.components.dst_gi_nahida_skill:DoDelta(20)
        end
    else
        if target.components.dst_gi_nahida_elemental_reaction then
            if target.components.dst_gi_nahida_elemental_reaction then
                if weapon and TUNING.ELEMENTAL_WEAPON[weapon.prefab] then
                    if weapon.prefab == "dst_gi_nahida_weapon_staff" and weapon.components.container ~= nil then
                        local item = weapon.components.container.slots[1]
                        if item and TUNING.ELEMENTAL_WEAPON[item.prefab] then
                            TUNING.ELEMENTAL_WEAPON[item.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                    target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                        else
                            TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                    target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                        end
                    else
                        TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                    end
                else
                    target.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                end
            end
        end
    end
end

function dst_gi_nahida_four_leaf_clover_data:SeedOfSkandhaLevel1Attack(player,weapon,isMaster,target, weapon_damage, additional_damage)
    if target.components.dst_gi_nahida_four_leaf_clover_data == nil then
        if target.components.dst_gi_nahida_elemental_reaction then
            if weapon and TUNING.ELEMENTAL_WEAPON[weapon.prefab] then
                if weapon.prefab == "dst_gi_nahida_weapon_staff" and weapon.components.container ~= nil then
                    local item = weapon.components.container.slots[1]
                    if item and TUNING.ELEMENTAL_WEAPON[item.prefab] then
                        TUNING.ELEMENTAL_WEAPON[item.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                    else
                        TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                    end
                else
                    TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                end
            else
                target.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                        target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
            end
        end
        return
    end
    local four_leaf_clover_data =  target.components.dst_gi_nahida_four_leaf_clover_data
    if additional_damage == nil then
        additional_damage = 0
    end
    if four_leaf_clover_data.current_level1_cooldown_time > 0 then
        if isMaster then -- 如果是主攻击对象，不受cd影响，则换位普攻伤害
            if target.components.dst_gi_nahida_elemental_reaction then
                if weapon and TUNING.ELEMENTAL_WEAPON[weapon.prefab] then
                    if weapon.prefab == "dst_gi_nahida_weapon_staff" and weapon.components.container ~= nil then
                        local item = weapon.components.container.slots[1]
                        if item and TUNING.ELEMENTAL_WEAPON[item.prefab] then
                            TUNING.ELEMENTAL_WEAPON[item.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                    target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                        else
                            TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                    target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                        end
                    else
                        TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                    end
                else
                    target.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = weapon_damage, additional_damage = additional_damage,true_damage = true })
                end
            end
        end
        return
    end
    if target.components.dst_gi_nahida_elemental_reaction then
        -- 反应时触发 灭净三叶 2.5秒内触发一次灭净三叶，对敌人造成144.5%伤害
        local _additional_damage = (weapon_damage + additional_damage) * self.seed_of_skandha_level1_stimuli - weapon_damage
        target.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                target, { weapon_damage = weapon_damage, additional_damage = _additional_damage,true_damage = true })
        -- 启动冷却
        four_leaf_clover_data.current_level1_cooldown_time = self.level1_cooldown_time
        target:DoTaskInTime(self.level1_cooldown_time, function()
            four_leaf_clover_data.current_level1_cooldown_time = 0  -- 冷却结束，允许再次触发
        end)

        if four_leaf_clover_data.current_energy_cd > 0 then
            return
        end
        four_leaf_clover_data.current_energy_cd = self.energy_max_cd
        player:DoTaskInTime(self.energy_max_cd, function()
            four_leaf_clover_data.current_energy_cd = 0  -- 冷却结束，允许再次触发
        end)
        if player.components.dst_gi_nahida_skill then
            -- 恢复25点能量
            player.components.dst_gi_nahida_skill:DoDelta(20)
        end
    end
end

return dst_gi_nahida_four_leaf_clover_data