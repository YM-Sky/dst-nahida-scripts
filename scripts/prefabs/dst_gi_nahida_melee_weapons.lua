---
--- dst_gi_nahida_melee_weapons.lua
--- Description: 近战元素武器
--- Author: 没有小钱钱
--- Date: 2025/5/25 17:41
---
require "prefabs/telebase"

-- 🔥 修正搜索条件
local OVERSIZED_CANT_TAGS = {"INLIMBO", "FX", "player"}
local OVERSIZED_MUST_TAGS = {"workable"}  -- 必须有workable组件
local OVERSIZED_ONEOF_TAGS = {"oversized_veggie", "oversized","farm_plant_immortal_fruit","farm_plant_medal_gift_fruit"}  -- 至少有其中一个巨型作物标签

local function DoHammer(inst, target, doer)
    -- 防止递归调用
    if doer._nahida_hammer_processing then
        return
    end
    doer._nahida_hammer_processing = true
    local doer_pos = doer:GetPosition()
    local x, y, z = doer_pos:Get()
    -- 🔥 正确的参数顺序：musttags, canttags, oneoftags
    local ents = TheSim:FindEntities(x, y, z, 8, nil, OVERSIZED_CANT_TAGS, OVERSIZED_ONEOF_TAGS)
    local hammer_count = 0
    for _, ent in pairs(ents) do
        if ent:IsValid() and ent ~= target and
                ent.prefab == target.prefab and -- 同种巨型作物
                ent.components.workable and ent.components.workable:CanBeWorked() and
                ent.components.workable:GetWorkAction() == ACTIONS.HAMMER then
            ent.components.workable:WorkedBy(doer, 1)
            hammer_count = hammer_count + 1
        end
    end

    doer._nahida_hammer_processing = nil
end

local function InitComponents(inst, target)
    if target.components.dst_gi_nahida_elemental_reaction == nil then
        target:AddComponent("dst_gi_nahida_elemental_reaction") -- 添加当前状态组件
    end
    if not target.components.debuffable then
        target:AddComponent("debuffable")
    end
end

local function HarvestPickable(inst, ent, doer)
    if ent.components.pickable.picksound ~= nil then
        doer.SoundEmitter:PlaySound(ent.components.pickable.picksound)
    end
    local success, loot = ent.components.pickable:Pick(doer)
    if loot ~= nil then
        for i, item in ipairs(loot) do
            Launch(item, doer, 1.5)
        end
    end
end


local HARVEST_MUSTTAGS  = {"pickable"}
local HARVEST_CANTTAGS  = {"INLIMBO", "FX"}
local HARVEST_ONEOFTAGS = {"plant", "lichen", "oceanvine", "kelp"}

local function DoScythe(inst, target, doer)
    if target.components.pickable ~= nil then
        local doer_pos = doer:GetPosition()
        local x, y, z = doer_pos:Get()

        local ents = TheSim:FindEntities(x, y, z, 15, HARVEST_MUSTTAGS, HARVEST_CANTTAGS, HARVEST_ONEOFTAGS)
        for _, ent in pairs(ents) do
            if ent:IsValid() and ent.components.pickable ~= nil and ent.prefab == target.prefab then
                HarvestPickable(inst, ent, doer)
            end
        end
    end
end

local function DstNahidaDeerCircle(circle_name,weapon,doer,duration,range)
    weapon.duration  = duration
    local circle = SpawnPrefab(circle_name)
    if circle then
        circle:SetDuration(duration)
        circle:SetRange(range)
        circle:SetOnAttack(function(target)
            if target.components.dst_gi_nahida_elemental_reaction then
                if doer.components.dst_gi_nahida_data then
                    doer.components.dst_gi_nahida_data:OnAttack(target)
                else
                    if target:IsValid() and target.components.combat.target == nil then
                        target.components.combat:SetTarget(doer)
                    end
                end
                -- 目标造成一次伤害
                local weapon_damage = 0
                if weapon and weapon.components.weapon then
                    weapon_damage = weapon.components.weapon:GetDamage(doer, target)
                else
                    weapon_damage = doer.components.combat.defaultdamage or 0
                end
                weapon_damage = weapon_damage * 0.5
                TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                        target, { weapon_damage = weapon_damage, additional_damage = 0,true_damage = true,is_skill = true })
            end
        end)
        return circle
    end
    return nil
end

local function DstNahidaDeerCircleWater(weapon,doer,pos,duration,range)
    for i = 1, duration do
        doer:DoTaskInTime(i,function()
            -- 检查doer和weapon是否仍然有效
            if not (doer and doer:IsValid() and weapon and weapon:IsValid()) then
                return
            end
            GetPrefab.SpawnAttackWaves(pos, {
                numWaves = math.random(12, 12), --每次浪花数量
                waveSpeed = 12, --狼花移动速度
                spawn_radius = 1, --半径
                spawnPrefabFn = function()
                    local wave = SpawnPrefab("dst_gi_nahida_wave_med")
                    return wave
                end,
                idleTime = 10 --存活时间
            })
            NahidaOnAttackFn(weapon,pos,range,function(target)
                if target.components.dst_gi_nahida_elemental_reaction then
                    if doer.components.dst_gi_nahida_data then
                        doer.components.dst_gi_nahida_data:OnAttack(target)
                    else
                        if target:IsValid() and target.components.combat.target == nil then
                            target.components.combat:SetTarget(doer)
                        end
                    end
                    -- 目标造成一次伤害
                    local weapon_damage = 0
                    if weapon and weapon.components.weapon then
                        weapon_damage = weapon.components.weapon:GetDamage(doer, target)
                    else
                        weapon_damage = doer.components.combat.defaultdamage or 0
                    end
                    weapon_damage = weapon_damage * 0.5
                    TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = weapon_damage, additional_damage = 0,true_damage = true,is_skill = true })
                end
            end)
            NahidaOnPlayerAttackFn(doer,pos,range,function(player)
                -- 恢复 5% 的最大血量
                local heal_amount = player.components.health.maxhealth * 0.02
                player.components.health:DoDelta(heal_amount)
            end)
        end)
    end
    return true
end

local function DstNahidaDeerCircleThunder(weapon,doer,pos,duration,range)
    local circle = SpawnPrefab("fx_dst_gi_nahida_round")
    if circle then
        circle:SetDuration(duration)
        circle:SetRange(range)
        circle:SetOnAttack(function(target)
            if target.components.dst_gi_nahida_elemental_reaction then
                if doer.components.dst_gi_nahida_data then
                    doer.components.dst_gi_nahida_data:OnAttack(target)
                else
                    if target:IsValid() and target.components.combat.target == nil then
                        target.components.combat:SetTarget(doer)
                    end
                end
                -- 目标造成一次伤害
                local weapon_damage = 0
                if weapon and weapon.components.weapon then
                    weapon_damage = weapon.components.weapon:GetDamage(doer, target)
                else
                    weapon_damage = doer.components.combat.defaultdamage or 0
                end
                weapon_damage = weapon_damage * 0.5
                TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                        target, { weapon_damage = weapon_damage, additional_damage = 0,true_damage = true,is_skill = true })
            end
        end)
        -- 使用你的法阵系统
        circle.Transform:SetPosition(pos.x, 0, pos.z)
        circle:InitTask(weapon.element_type)
        return true
    end
end

local function DstNahidaDeerCircleRock(weapon,doer,pos,duration,range)
    local circle = SpawnPrefab("fx_dst_gi_nahida_round")
    if circle then
        circle:SetDuration(duration)
        circle:SetRange(range)
        circle:SetOnAttack(function(target)
            if target.components.dst_gi_nahida_elemental_reaction then
                if doer.components.dst_gi_nahida_data then
                    doer.components.dst_gi_nahida_data:OnAttack(target)
                else
                    if target:IsValid() and target.components.combat.target == nil then
                        target.components.combat:SetTarget(doer)
                    end
                end
                -- 目标造成一次伤害
                local weapon_damage = 0
                if weapon and weapon.components.weapon then
                    weapon_damage = weapon.components.weapon:GetDamage(doer, target)
                else
                    weapon_damage = doer.components.combat.defaultdamage or 0
                end
                weapon_damage = weapon_damage * 0.5
                TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                        target, { weapon_damage = weapon_damage, additional_damage = 0,true_damage = true,is_skill = true })
            end
        end)
        -- local meteor = c_spawn("shadowmeteor") print("陨石已生成，GUID:", meteor.GUID, "大小:", meteor.size or "未设置", "撞击任务:", meteor.striketask ~= nil)
        -- 使用你的法阵系统
        circle.Transform:SetPosition(pos.x, 0, pos.z)
        circle:InitTask(weapon.element_type)
        return true
    end
end

local function DstNahidaDeerCircleWind(weapon,doer,pos,duration,range)
    local circle = SpawnPrefab("fx_dst_gi_nahida_round")
    if circle then
        circle:SetDuration(duration)
        circle:SetRange(range)
        circle:SetOnAttack(function(target)
            if target.components.dst_gi_nahida_elemental_reaction then
                if doer.components.dst_gi_nahida_data then
                    doer.components.dst_gi_nahida_data:OnAttack(target)
                else
                    if target:IsValid() and target.components.combat.target == nil then
                        target.components.combat:SetTarget(doer)
                    end
                end
                -- 目标造成一次伤害
                local weapon_damage = 0
                if weapon and weapon.components.weapon then
                    weapon_damage = weapon.components.weapon:GetDamage(doer, target)
                else
                    weapon_damage = doer.components.combat.defaultdamage or 0
                end
                weapon_damage = weapon_damage * 0.5
                TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                        target, { weapon_damage = weapon_damage, additional_damage = 0,true_damage = true,is_skill = true })
            end
        end)
        -- 使用你的法阵系统
        circle.Transform:SetPosition(pos.x, 0, pos.z)
        circle:InitTask(weapon.element_type)
        return true
    end
end

local function DstNahidaDeerCircleGrass(weapon,doer,pos,duration,range)
    local circle = SpawnPrefab("dst_gi_nahida_sporecloud")
    if circle then
        circle:SetDuration(duration)
        circle:SetRange(range)
        circle:SetOnAttack(function(target)
            if target.components.dst_gi_nahida_elemental_reaction then
                if doer.components.dst_gi_nahida_data then
                    doer.components.dst_gi_nahida_data:OnAttack(target)
                else
                    if target:IsValid() and target.components.combat.target == nil then
                        target.components.combat:SetTarget(doer)
                    end
                end
                -- 目标造成一次伤害
                local weapon_damage = 0
                if weapon and weapon.components.weapon then
                    weapon_damage = weapon.components.weapon:GetDamage(doer, target)
                else
                    weapon_damage = doer.components.combat.defaultdamage or 0
                end
                weapon_damage = weapon_damage * 0.5
                TUNING.ELEMENTAL_WEAPON[weapon.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                        target, { weapon_damage = weapon_damage, additional_damage = 0,true_damage = true,is_skill = true })
            end
        end)
        -- 使用你的法阵系统
        circle.Transform:SetPosition(pos.x, 0, pos.z)
        circle:InitTask(weapon.element_type)
        return true
    end
end

local function StartCircle(inst,doer,pos)
    if inst.element_type == nil then
        return false
    end
    if inst.element_type == TUNING.ELEMENTAL_TYPE.ICE then
        local circle = DstNahidaDeerCircle("dst_nahida_deer_ice_circle",inst,doer,10,8)
        if circle == nil then
            return false
        end
        circle:InitTask(circle)
        -- 使用你的法阵系统
        circle.Transform:SetPosition(pos.x, 0, pos.z)
        return true
    end

    if inst.element_type == TUNING.ELEMENTAL_TYPE.FIRE then
        local circle = DstNahidaDeerCircle("dst_nahida_deer_fire_circle",inst,doer,10,8)
        if circle == nil then
            return false
        end
        circle:InitTask(circle)
        -- 使用你的法阵系统
        circle.Transform:SetPosition(pos.x, 0, pos.z)
        return true
    end

    if inst.element_type == TUNING.ELEMENTAL_TYPE.WATER then
        return DstNahidaDeerCircleWater(inst,doer,pos,10,8)
    end
    if inst.element_type == TUNING.ELEMENTAL_TYPE.THUNDER then
        return DstNahidaDeerCircleThunder(inst,doer,pos,10,8)
    end
    if inst.element_type == TUNING.ELEMENTAL_TYPE.ROCK then
        return DstNahidaDeerCircleRock(inst,doer,pos,10,8)
    end
    if inst.element_type == TUNING.ELEMENTAL_TYPE.WIND then
        return DstNahidaDeerCircleWind(inst,doer,pos,10,8)
    end
    if inst.element_type == TUNING.ELEMENTAL_TYPE.GRASS then
        return DstNahidaDeerCircleGrass(inst,doer,pos,10,8)
    end
end

local function SpellFn(inst, doer, pos)
    if doer.components.timer == nil then
        doer:AddComponent("timer")
    end
    if doer.components.timer:TimerExists(inst.prefab) then
        if doer.components.talker then
            doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CURRENT_CD)
        end
        return false
    end

    if doer.components.sanity ~= nil and doer.components.sanity.current < 5  then
        if doer.components.talker then
            doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_NOT_SANITY)
        end
        return false
    end

    if not StartCircle(inst, doer, pos) then
        return false
    end
    -- 生成法阵
    --local circle_type = inst.magic_type or "ice"  -- 从物品属性获取法阵类型
    local projectile_name = "dst_gi_nahida_brilliance_projectile_fx_" .. inst.element_type
    if inst.components.weapon then
        inst.components.weapon:SetRange(8)
        inst.components.weapon:SetProjectile(projectile_name)
    end
    doer.components.timer:StartTimer(inst.prefab, inst.skill_cd)
    if doer.components.sanity ~= nil then
        doer.components.sanity:DoDelta(-5)
    end
    inst:DoTaskInTime(inst.remote_duration,function()
        if inst.components.weapon then
            inst.components.weapon:SetRange(1)
            inst.components.weapon:SetProjectile(nil)
        end
    end)
    return true  -- 返回true表示施法成功
end

local function initAoeTargeting(inst)
    inst:AddTag("dst_gi_nahida_weapons_skill") -- 武器技能标签
    inst.SpellFn = SpellFn  -- SpellFn(inst, doer, pos)
end

local meleeWeaponsList = {
    {
        name = "dst_gi_nahida_weapon_staff", -- 法杖武器-草
        bank = "dst_gi_nahida_weapon_staff",
        build = "dst_gi_nahida_weapon_staff",
        anim = "idle",
        atlasname = "dst_gi_nahida_weapon_staff",
        element_type = TUNING.ELEMENTAL_TYPE.GRASS,
        assert = {
            Asset("ANIM", "anim/dst_gi_nahida_swap_weapon_staff.zip"),
            Asset("ANIM", "anim/dst_gi_nahida_weapon_staff.zip"),
            Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_weapon_staff.xml"),
            Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_weapon_staff.tex"),
        },
        tags = {
            "dst_gi_nahida_weapons",
            "sharp",
        },
        weapon = {
            damage = 20,
            range = 1,
            --projectile = "dst_gi_nahida_brilliance_projectile_fx_grass", -- 🔥 添加亮茄魔杖弹幕
        },
        before_init = function(inst)
            inst.net_dst_gi_nahida_weapon_staff_current_model = net_string(inst.GUID, "net_dst_gi_nahida_weapon_staff_current_model")
            inst.net_dst_gi_nahida_weapon_staff_bounce_level = net_int(inst.GUID, "net_dst_gi_nahida_weapon_staff_bounce_level")
            inst.net_dst_gi_nahida_weapon_staff_opalpreciousgem_count = net_int(inst.GUID, "net_dst_gi_nahida_weapon_staff_opalpreciousgem_count")
            local old_GetDisplayName = inst.GetDisplayName
            inst.GetDisplayName = function(self,...)
                local desc = STRINGS.MOD_DST_GI_NAHIDA.WEAPON_STAFF_MODE[inst.net_dst_gi_nahida_weapon_staff_current_model:value() or "NORMAL"]
                local gem_count = inst.net_dst_gi_nahida_weapon_staff_opalpreciousgem_count:value() or 0
                local bounce_level = inst.net_dst_gi_nahida_weapon_staff_bounce_level:value() or 1
                local current_level_gems = gem_count % 10  -- 当前等级已有的宝石数
                local bounce_count = bounce_level - 1
                local desc2 = string.format(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_GOLD_WEAPON_BOUNCE_UPGRADE_LEVEL2, gem_count, bounce_level - 1,  bounce_count,bounce_level == 6 and 0 or (10 - current_level_gems))
                local str = ""
                str = str.."\r\n"..desc or "N/A"
                str = str.."\r\n"..desc2 or "N/A"
                return old_GetDisplayName(self,...)
                        ..str
            end
            -- 🔥 添加远程武器标签和投射物延迟
            --inst:AddTag("rangedweapon")
            --inst:AddTag("magicweapon")
            --inst.projectiledelay = FRAMES
        end,
        init = function(inst)
            inst:AddTag("lunarhailprotection") -- 有这个的手持物品,就可以防玻璃雨(月亮冰雹)
            inst:AddTag("farmtiller")
            -- 在你的自定义武器prefab中添加
            inst:AddTag("machete") -- 砍刀标签
            inst:AddTag("sharp") -- 锋利标签（通用）
            inst:AddComponent("dst_gi_nahida_actions_data")
            inst:AddComponent("dst_gi_nahida_weapon_action_data")
            inst:AddComponent("dst_gi_nahida_weapon_staff_data")
            inst:AddComponent("dst_gi_nahida_weapon_bounce_data")

            inst:AddComponent("finiteuses")
            inst:AddComponent("farmtiller")
            inst:AddComponent("tool")
            inst.components.tool:SetAction(ACTIONS.CHOP, 1)
            inst.components.tool:SetAction(ACTIONS.MINE, 1)
            inst.components.tool:SetAction(ACTIONS.NET)
            inst:AddInherentAction(ACTIONS.TILL)

            -- 添加池塘钓鱼功能
            inst:AddTag("fishingrod")
            inst:AddComponent("fishingrod")
            inst.components.fishingrod:SetWaitTimes(4, 20)
            inst.components.fishingrod:SetStrainTimes(0, 5)

            inst:AddComponent("container")
            inst.components.container:WidgetSetup("dst_gi_nahida_weapon_staff")
            --inst.components.container.canbeopened = true

            inst.components.finiteuses:SetMaxUses(256)
            inst.components.finiteuses:SetUses(256)
            inst.components.finiteuses:SetIgnoreCombatDurabilityLoss(true)
            -- 🔥 修复symbolswapdata错误：添加symbolswapdata组件
            --inst:AddComponent("symbolswapdata")
            --inst.components.symbolswapdata:SetData("dst_gi_nahida_swap_weapon_staff", "swap_wuqi")

            -- 🔥 添加范围锤击功能
            inst.DoHammer = DoHammer

            -- 🔥 添加弹射等级系统
            inst.nahida_bounce_level = 1  -- 默认等级1（不弹射）
            -- 🔥 添加升级弹射等级的函数
            inst.SetBounceLevel = function(inst, level)
                inst.nahida_bounce_level = math.max(1, math.min(level, 5))  -- 限制在1-5级
            end
            -- 🔥 添加升级弹射等级的函数
            inst.UpgradeBounceLevel = function(inst)
                local old_level = inst.nahida_bounce_level
                inst:SetBounceLevel(old_level + 1)
                return inst.nahida_bounce_level > old_level  -- 返回是否成功升级
            end
            -- 🔥 添加获取弹射等级的函数
            inst.GetBounceLevel = function(inst)
                return inst.nahida_bounce_level or 1
            end
            -- 在init函数中的事件监听
            inst._onworking = function(player, data)
                -- 如果正在处理锤击，跳过
                if player._nahida_hammer_processing then
                    return
                end
                -- 检查是否是使用这个武器
                local weapon = player.components.inventory and player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if weapon == inst and data.target then
                    -- 检查目标的工作动作是否是HAMMER
                    if data.target.components.workable and
                            data.target.components.workable:GetWorkAction() == ACTIONS.HAMMER then
                        local staff_data = inst.components.dst_gi_nahida_weapon_staff_data
                        if staff_data and (staff_data.current_model == "DESTROY" or staff_data.current_model == "TRANSMITTED") then
                            if inst.DoHammer then
                                inst.DoHammer(inst, data.target, player)
                            end
                        end
                    end
                end
            end

            --🔥 监听容器变化事件来动态更新投射物
            inst:ListenForEvent("itemget", function(inst, data)
                if data and data.item and data.item.element_type then
                    local projectile_name = "dst_gi_nahida_brilliance_projectile_fx_" .. data.item.element_type
                    if inst.components.weapon then
                        local staff_data = inst.components.dst_gi_nahida_weapon_staff_data
                        if staff_data and staff_data.active_data and staff_data.active_data.yellowstaff and staff_data.active_data.yellowstaff.active then
                            inst.components.weapon:SetProjectile(projectile_name)
                        else
                            inst.components.weapon:SetProjectile(nil)
                        end
                    end
                end
            end)

            inst:ListenForEvent("itemlose", function(inst, data)
                -- 容器为空时恢复默认草元素投射物
                if inst.components.container and inst.components.container:IsEmpty() then
                    if inst.components.weapon then
                        local staff_data = inst.components.dst_gi_nahida_weapon_staff_data
                        if staff_data and staff_data.active_data and staff_data.active_data.yellowstaff and staff_data.active_data.yellowstaff.active then
                            inst.components.weapon:SetProjectile("dst_gi_nahida_brilliance_projectile_fx_grass")
                        else
                            inst.components.weapon:SetProjectile(nil)
                        end
                    end
                end
            end)
        end,
        OnAttack = function(weapon, attacker, target)
            if not (attacker and attacker.components.health and target and target:IsValid()) then
                return
            end
            if not attacker:HasTag(TUNING.AVATAR_NAME) then
                InitComponents(attacker, target)
                --造成一次草伤
                local damage = (weapon ~= nil and weapon.components.weapon:GetDamage(attacker, target))
                        or attacker.components.combat.defaultdamage
                if target.components.dst_gi_nahida_elemental_reaction then
                    if weapon.components.container ~= nil then
                        local item = weapon.components.container.slots[1]
                        if item and TUNING.ELEMENTAL_WEAPON[item.prefab] then
                            -- 🔥 如果有投射物，设置投射物
                            TUNING.ELEMENTAL_WEAPON[item.prefab].fn(target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                    target, { weapon_damage = damage, additional_damage = 0 })
                        else
                            target.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                                    target, { weapon_damage = damage, additional_damage = 0 })
                        end
                    else
                        target.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                                target, { weapon_damage = damage, additional_damage = 0 })
                    end
                end
            end

            if target:IsValid() then
                -- 唤醒睡眠目标
                if target.components.sleeper ~= nil and target.components.sleeper:IsAsleep() then
                    target.components.sleeper:WakeUp()
                end
                -- 设置战斗目标
                if target.components.combat ~= nil then
                    target.components.combat:SuggestTarget(attacker)
                end
            end
        end,
        OnEquip = function(inst, owner)
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            owner.AnimState:OverrideSymbol("swap_object", "dst_gi_nahida_swap_weapon_staff", "swap_wuqi")
            if inst.components.dst_gi_nahida_weapon_staff_data then
                inst.components.dst_gi_nahida_weapon_staff_data:EquipFn(owner)
            end
            if inst.components.weapon and owner.components.dst_gi_nahida_data then
                inst.components.weapon:SetDamage(20 + owner.components.dst_gi_nahida_data:GetDamageData())  --设置伤害
            end

            -- 🔥 添加working事件监听（修正）
            if inst._onworking then
                owner:ListenForEvent("working", inst._onworking)
            end

            -- 🔥 学习火把的做法：创建特效数组
            if inst.weapon_effects == nil then
                inst.weapon_effects = {}
                if owner:HasTag(TUNING.AVATAR_NAME) then
                    -- 1. 创建拖尾特效（跟随武器）
                    local trail_fx = SpawnPrefab("fx_dst_gi_nahida_weapon_staff")
                    if trail_fx then
                        trail_fx.entity:SetParent(inst.entity)  -- 跟随武器
                        trail_fx.Transform:SetPosition(0, 0, 0)
                        trail_fx.trail_active = true
                        table.insert(inst.weapon_effects, trail_fx)
                    end
                end
                -- 2. 创建光源特效（学习火把torchfire的做法）
                local light_fx = SpawnPrefab("fx_nahida_weapon_light")
                if light_fx then
                    light_fx.entity:SetParent(owner.entity)    -- 🔥 关键：父实体设为玩家
                    light_fx.entity:AddFollower()
                    light_fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, 0, 0)  -- 跟随武器位置
                    light_fx:AttachLightTo(owner)             -- 🔥 关键：光源附加到玩家身上
                    table.insert(inst.weapon_effects, light_fx)
                end
            end
        end,

        OnUnequip = function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
            if inst.components.dst_gi_nahida_weapon_staff_data then
                inst.components.dst_gi_nahida_weapon_staff_data:UnEquipFn(owner)
            end
            if inst.components.weapon then
                inst.components.weapon:SetDamage(20)      --设置伤害
            end

            -- 🔥 移除working事件监听（修正）
            if inst._onworking then
                owner:RemoveEventCallback("working", inst._onworking)
            end

            -- 🔥 学习火把的做法：清理所有特效
            if inst.weapon_effects ~= nil then
                -- 先移除光源，再移除特效
                for i, fx in ipairs(inst.weapon_effects) do
                    if fx.RemoveLightFrom then
                        fx:RemoveLightFrom(owner)  -- 移除玩家身上的光源
                    end
                    fx:Remove()
                end
                inst.weapon_effects = nil
            end
        end
    },
    {
        name = "dst_gi_nahida_weapon_fire", -- 近战武器-火
        bank = "dst_gi_nahida_weapon_fire",
        build = "dst_gi_nahida_weapon_fire",
        anim = "idle",
        element_type = TUNING.ELEMENTAL_TYPE.FIRE,
        skill_cd = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.WEAPON_FIRE_CD,
        remote_duration = 10,
        atlasname = "dst_gi_nahida_weapon_fire",
        assert = {
            Asset("ANIM", "anim/dst_gi_nahida_swap_weapon_fire.zip"),
            Asset("ANIM", "anim/dst_gi_nahida_weapon_fire.zip"),
            Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_weapon_fire.xml"),
            Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_weapon_fire.tex"),
        },
        tags = {
            "dst_gi_nahida_weapons",
            "sharp",
        },
        weapon = {
            damage = 55,
            range = 1,
        },
        init = function(inst)
            initAoeTargeting(inst)
        end,
        OnAttack = function(weapon, attacker, target)
            if not (attacker and attacker.components.health and target and target:IsValid()) then
                return
            end
            if not attacker:HasTag(TUNING.AVATAR_NAME) then
                InitComponents(attacker, target)
                --造成一次火伤
                local damage = (weapon ~= nil and weapon.components.weapon:GetDamage(attacker, target))
                        or attacker.components.combat.defaultdamage
                if target.components.dst_gi_nahida_elemental_reaction then
                    target.components.dst_gi_nahida_elemental_reaction:FireAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = damage, additional_damage = 0 })
                end
            end
        end,
        OnEquip = function(inst, owner)
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            owner.AnimState:OverrideSymbol("swap_object", "dst_gi_nahida_swap_weapon_fire", "swap_wuqi")
        end,
        OnUnequip = function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
        end
    },
    {
        name = "dst_gi_nahida_weapon_grass", -- 近战武器-草
        bank = "dst_gi_nahida_weapon_grass",
        build = "dst_gi_nahida_weapon_grass",
        anim = "idle",
        skill_cd = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.WEAPON_GRASS_CD,
        remote_duration = 10,
        element_type = TUNING.ELEMENTAL_TYPE.GRASS,
        atlasname = "dst_gi_nahida_weapon_grass",
        assert = {
            Asset("ANIM", "anim/dst_gi_nahida_swap_weapon_grass.zip"),
            Asset("ANIM", "anim/dst_gi_nahida_weapon_grass.zip"),
            Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_weapon_grass.xml"),
            Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_weapon_grass.tex"),
        },
        tags = {
            "dst_gi_nahida_weapons",
            "sharp",
        },
        weapon = {
            damage = 55,
            range = 1,
        },
        init = function(inst)
            inst:AddComponent("dst_gi_nahida_actions_data")
            inst:AddComponent("dst_gi_nahida_weapon_action_data")
            inst:AddComponent("tool")
            inst.components.tool:SetAction(ACTIONS.SCYTHE)
            inst.DoScythe = DoScythe
            initAoeTargeting(inst)
        end,
        OnAttack = function(weapon, attacker, target)
            if not (attacker and attacker.components.health and target and target:IsValid()) then
                return
            end
            if not attacker:HasTag(TUNING.AVATAR_NAME) then
                InitComponents(attacker, target)
                --造成一次草伤
                local damage = (weapon ~= nil and weapon.components.weapon:GetDamage(attacker, target))
                        or attacker.components.combat.defaultdamage
                if target.components.dst_gi_nahida_elemental_reaction then
                    target.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = damage, additional_damage = 0 })
                end
            end
        end,
        OnEquip = function(inst, owner)
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            owner.AnimState:OverrideSymbol("swap_object", "dst_gi_nahida_swap_weapon_grass", "swap_wuqi")
        end,
        OnUnequip = function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
        end
    },
    {
        name = "dst_gi_nahida_weapon_ice", -- 近战武器-冰
        bank = "dst_gi_nahida_weapon_ice",
        build = "dst_gi_nahida_weapon_ice",
        anim = "idle",
        element_type = TUNING.ELEMENTAL_TYPE.ICE,
        skill_cd = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.WEAPON_ICE_CD,
        remote_duration = 10,
        atlasname = "dst_gi_nahida_weapon_ice",
        assert = {
            Asset("ANIM", "anim/dst_gi_nahida_swap_weapon_ice.zip"),
            Asset("ANIM", "anim/dst_gi_nahida_weapon_ice.zip"),
            Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_weapon_ice.xml"),
            Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_weapon_ice.tex"),
        },
        tags = {
            "dst_gi_nahida_weapons",
            "sharp",
        },
        weapon = {
            damage = 55,
            range = 1,
        },
        init = function(inst)
            initAoeTargeting(inst)
        end,
        OnAttack = function(weapon, attacker, target)
            if not (attacker and attacker.components.health and target and target:IsValid()) then
                return
            end
            if not attacker:HasTag(TUNING.AVATAR_NAME) then
                InitComponents(attacker, target)
                --造成一次火伤
                local damage = (weapon ~= nil and weapon.components.weapon:GetDamage(attacker, target))
                        or attacker.components.combat.defaultdamage
                if target.components.dst_gi_nahida_elemental_reaction then
                    target.components.dst_gi_nahida_elemental_reaction:IceAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = damage, additional_damage = 0 })
                end
            end
        end,
        OnEquip = function(inst, owner)
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            owner.AnimState:OverrideSymbol("swap_object", "dst_gi_nahida_swap_weapon_ice", "swap_wuqi")
        end,
        OnUnequip = function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
        end
    },
    {
        name = "dst_gi_nahida_weapon_rock", -- 近战武器-岩
        bank = "dst_gi_nahida_weapon_rock",
        build = "dst_gi_nahida_weapon_rock",
        anim = "idle",
        skill_cd = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.WEAPON_ROCK_CD,
        remote_duration = 10,
        element_type = TUNING.ELEMENTAL_TYPE.ROCK,
        atlasname = "dst_gi_nahida_weapon_rock",
        assert = {
            Asset("ANIM", "anim/dst_gi_nahida_swap_weapon_rock.zip"),
            Asset("ANIM", "anim/dst_gi_nahida_weapon_rock.zip"),
            Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_weapon_rock.xml"),
            Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_weapon_rock.tex"),
        },
        tags = {
            "dst_gi_nahida_weapons",
            "sharp",
        },
        weapon = {
            damage = 55,
            range = 1,
        },
        init = function(inst)
            initAoeTargeting(inst)
        end,
        OnAttack = function(weapon, attacker, target)
            if not (attacker and attacker.components.health and target and target:IsValid()) then
                return
            end
            if not attacker:HasTag(TUNING.AVATAR_NAME) then
                InitComponents(attacker, target)
                --造成一次岩伤
                local damage = (weapon ~= nil and weapon.components.weapon:GetDamage(attacker, target))
                        or attacker.components.combat.defaultdamage
                if target.components.dst_gi_nahida_elemental_reaction then
                    target.components.dst_gi_nahida_elemental_reaction:RockAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = damage, additional_damage = 0 })
                end
            end
        end,
        OnEquip = function(inst, owner)
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            owner.AnimState:OverrideSymbol("swap_object", "dst_gi_nahida_swap_weapon_rock", "swap_wuqi")
        end,
        OnUnequip = function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
        end
    },
    {
        name = "dst_gi_nahida_weapon_thunder", -- 近战武器-雷
        bank = "dst_gi_nahida_weapon_thunder",
        build = "dst_gi_nahida_weapon_thunder",
        anim = "idle",
        element_type = TUNING.ELEMENTAL_TYPE.THUNDER,
        skill_cd = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.WEAPON_THUNDER_CD,
        remote_duration = 10,
        atlasname = "dst_gi_nahida_weapon_thunder",
        assert = {
            Asset("ANIM", "anim/dst_gi_nahida_swap_weapon_thunder.zip"),
            Asset("ANIM", "anim/dst_gi_nahida_weapon_thunder.zip"),
            Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_weapon_thunder.xml"),
            Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_weapon_thunder.tex"),
        },
        tags = {
            "dst_gi_nahida_weapons",
            "sharp",
        },
        weapon = {
            damage = 55,
            range = 1,
        },
        init = function(inst)
            initAoeTargeting(inst)
        end,
        OnAttack = function(weapon, attacker, target)
            if not (attacker and attacker.components.health and target and target:IsValid()) then
                return
            end
            if not attacker:HasTag(TUNING.AVATAR_NAME) then
                InitComponents(attacker, target)
                --造成一次雷伤
                local damage = (weapon ~= nil and weapon.components.weapon:GetDamage(attacker, target))
                        or attacker.components.combat.defaultdamage
                if target.components.dst_gi_nahida_elemental_reaction then
                    target.components.dst_gi_nahida_elemental_reaction:ThunderAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = damage, additional_damage = 0 })
                end
            end
        end,
        OnEquip = function(inst, owner)
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            owner.AnimState:OverrideSymbol("swap_object", "dst_gi_nahida_swap_weapon_thunder", "swap_wuqi")
        end,
        OnUnequip = function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
        end
    },
    {
        name = "dst_gi_nahida_splendor_of_tranquil_waters", -- 近战武器-物理
        bank = "dst_gi_nahida_splendor_of_tranquil_waters",
        build = "dst_gi_nahida_splendor_of_tranquil_waters",
        anim = "idle",
        element_type = TUNING.ELEMENTAL_TYPE.PHYSICAL,
        atlasname = "dst_gi_nahida_splendor_of_tranquil_waters",
        assert = {
            Asset("ANIM", "anim/dst_gi_nahida_splendor_of_tranquil_waters_swap.zip"),
            Asset("ANIM", "anim/dst_gi_nahida_splendor_of_tranquil_waters.zip"),
            Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_splendor_of_tranquil_waters.xml"),
            Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_splendor_of_tranquil_waters.tex"),
        },
        tags = {
            "dst_gi_nahida_weapons",
            "sharp",
        },
        weapon = {
            damage = 55,
            range = 1,
        },
        OnAttack = function(weapon, attacker, target)
            if not (attacker and attacker.components.health and target and target:IsValid()) then
                return
            end
            if not attacker:HasTag(TUNING.AVATAR_NAME) then
                InitComponents(attacker, target)
                --造成一次水伤
                local damage = (weapon ~= nil and weapon.components.weapon:GetDamage(attacker, target))
                        or attacker.components.combat.defaultdamage
                if target.components.dst_gi_nahida_elemental_reaction then
                    target.components.dst_gi_nahida_elemental_reaction:WaterAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = damage, additional_damage = 0 })
                end
            end
        end,
        OnEquip = function(inst, owner)
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            owner.AnimState:OverrideSymbol("swap_object", "dst_gi_nahida_splendor_of_tranquil_waters_swap", "swap_wuqi")
        end,
        OnUnequip = function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
        end
    },
    {
        name = "dst_gi_nahida_weapon_water", -- 近战武器-水
        bank = "dst_gi_nahida_weapon_water",
        build = "dst_gi_nahida_weapon_water",
        anim = "idle",
        skill_cd = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.WEAPON_WATER_CD,
        remote_duration = 10,
        element_type = TUNING.ELEMENTAL_TYPE.WATER,
        atlasname = "dst_gi_nahida_weapon_water",
        assert = {
            Asset("ANIM", "anim/dst_gi_nahida_swap_weapon_water.zip"),
            Asset("ANIM", "anim/dst_gi_nahida_weapon_water.zip"),
            Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_weapon_water.xml"),
            Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_weapon_water.tex"),
        },
        tags = {
            "dst_gi_nahida_weapons",
            "sharp",
        },
        weapon = {
            damage = 55,
            range = 1,
        },
        init = function(inst)
            initAoeTargeting(inst)
        end,
        OnAttack = function(weapon, attacker, target)
            if not (attacker and attacker.components.health and target and target:IsValid()) then
                return
            end
            if not attacker:HasTag(TUNING.AVATAR_NAME) then
                InitComponents(attacker, target)
                --造成一次水伤
                local damage = (weapon ~= nil and weapon.components.weapon:GetDamage(attacker, target))
                        or attacker.components.combat.defaultdamage
                if target.components.dst_gi_nahida_elemental_reaction then
                    target.components.dst_gi_nahida_elemental_reaction:WaterAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = damage, additional_damage = 0 })
                end
            end
        end,
        OnEquip = function(inst, owner)
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            owner.AnimState:OverrideSymbol("swap_object", "dst_gi_nahida_swap_weapon_water", "swap_wuqi")
        end,
        OnUnequip = function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
        end
    },
    {
        name = "dst_gi_nahida_weapon_wind", -- 近战武器-风
        bank = "dst_gi_nahida_weapon_wind",
        build = "dst_gi_nahida_weapon_wind",
        anim = "idle",
        skill_cd = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.WEAPON_WIND_CD,
        remote_duration = 10,
        element_type = TUNING.ELEMENTAL_TYPE.WIND,
        atlasname = "dst_gi_nahida_weapon_wind",
        assert = {
            Asset("ANIM", "anim/dst_gi_nahida_swap_weapon_wind.zip"),
            Asset("ANIM", "anim/dst_gi_nahida_weapon_wind.zip"),
            Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_weapon_wind.xml"),
            Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_weapon_wind.tex"),
        },
        tags = {
            "dst_gi_nahida_weapons",
            "sharp",
        },
        weapon = {
            damage = 55,
            range = 1,
        },
        init = function(inst)
            initAoeTargeting(inst)
        end,
        OnAttack = function(weapon, attacker, target)
            if not (attacker and attacker.components.health and target and target:IsValid()) then
                return
            end
            if not attacker:HasTag(TUNING.AVATAR_NAME) then
                InitComponents(attacker, target)
                --造成一次风伤
                local damage = (weapon ~= nil and weapon.components.weapon:GetDamage(attacker, target))
                        or attacker.components.combat.defaultdamage
                if target.components.dst_gi_nahida_elemental_reaction then
                    target.components.dst_gi_nahida_elemental_reaction:WindAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                            target, { weapon_damage = damage, additional_damage = 0 })
                end
            end
        end,
        OnEquip = function(inst, owner)
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            owner.AnimState:OverrideSymbol("swap_object", "dst_gi_nahida_swap_weapon_wind", "swap_wuqi")
        end,
        OnUnequip = function(inst, owner)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
        end
    }
}

local function CreateMeleeWeapons(data)
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst)
        MakeInventoryFloatable(inst, "med", nil, 0.75)                   --漂浮
        inst.AnimState:SetBank(data.bank) --地上动画
        inst.AnimState:SetBuild(data.build)
        inst.AnimState:PlayAnimation(data.anim)
        inst.entity:SetPristine()

        inst:AddTag(TUNING.MOD_ID)
        inst:AddTag(data.name)
        inst:AddTag("meteor_protection") --防止被流星破坏
        inst:AddTag("nosteal")           --防止被火药猴偷走
        inst:AddTag("NORATCHECK")        --mod兼容：永不妥协。该道具不算鼠潮分
        inst:AddTag("shoreonsink")       --不掉深渊
        inst:AddTag("tornado_nosucky")   --mod兼容：永不妥协。不会被龙卷风刮走
        --inst:AddTag("hide_percentage")   -- 隐藏百分比
        inst:AddTag("weapon")
        if data.tags ~= nil then
            for i, v in pairs(data.tags) do
                inst:AddTag(v)
            end
        end
        if data.before_init then
            data.before_init(inst)
        end

        if not TheWorld.ismastersim then
            return inst
        end
        inst.element_type = data.element_type
        inst.skill_cd = data.skill_cd or 12
        inst.remote_duration = data.remote_duration or 10
        inst:AddComponent("weapon")          --增加武器组件 有了这个才可以打人
        inst.components.weapon:SetDamage(data.weapon and data.weapon.damage or 20) --设置伤害
        inst.components.weapon:SetRange(data.weapon and data.weapon.range or 3)
        inst.components.weapon:SetOnAttack(data.OnAttack)

        -- 🔥 如果有投射物，设置投射物
        if data.weapon and data.weapon.projectile then
            inst.components.weapon:SetProjectile(data.weapon.projectile)
        end

        inst:AddComponent("inspectable")                                                                              --可检查组件
        inst:AddComponent("inventoryitem")                                                                            --物品组件
        inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. data.atlasname .. ".xml" --物品贴图

        inst:AddComponent("equippable")                                                                               --可装备组件
        inst.components.equippable:SetOnEquip(data.OnEquip)
        inst.components.equippable:SetOnUnequip(data.OnUnequip)

        if data.init then
            data.init(inst)
        end

        MakeHauntableLaunchAndDropFirstItem(inst)

        return inst
    end
    return Prefab(data.name, fn, data.assert)
end

local weaponsPrefabs = {}

for _, data in ipairs(meleeWeaponsList) do
    table.insert(weaponsPrefabs, CreateMeleeWeapons(data))
end

return unpack(weaponsPrefabs)