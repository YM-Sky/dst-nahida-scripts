---
--- player_hooks.lua
--- Description:
--- Author: 没有小钱钱
--- Date: 2025/3/29 0:11
---
local cooking = require("cooking")
local exclude_tags = { "INLIMBO", "companion", "wall", "abigail", "player", "chester", "zhijiang_hound" }

local function InitComponents(inst, target)
    if target.components.dst_gi_nahida_elemental_reaction == nil then
        target:AddComponent("dst_gi_nahida_elemental_reaction") -- 添加当前状态组件
    end
    if target.components.dst_gi_nahida_elemental_reaction then
        if inst.components.dst_gi_nahida_data then
            -- 赋予命座效果
            target.components.dst_gi_nahida_elemental_reaction:SetFateseatLevel(inst.components.dst_gi_nahida_data.nahida_fateseat_level)
        end
        -- 初始化组件默认方法
        target.components.dst_gi_nahida_elemental_reaction:InitComponents(target)
    end
end

-- 攻击时恢复1点能量
local function OnAttackOther(inst, data)
    if data and data.target and data.target.components and data.target.components.health and not data.target.components.health:IsDead() then
        -- 恢复1点能量
        if inst.components.dst_gi_nahida_skill then
            -- 检查并添加 debuffable 组件
            if not data.target.components.debuffable then
                data.target:AddComponent("debuffable")
            end
            inst.components.dst_gi_nahida_skill:DoDelta(1)
            -- 初始化元素反应组件
            InitComponents(inst, data.target)
            --造成一次草伤
            local damage = (data.weapon ~= nil and data.weapon.components.weapon:GetDamage(inst, data.target))
                    or inst.components.combat.defaultdamage
            local new_damage = 0
            --if inst:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF1) then
            --    new_damage = damage * TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT1.MULTIPLIERS
            --elseif inst:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF0) then
            --    new_damage = damage * TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT0.MULTIPLIERS
            --end
            --攻击时恢复仇恨
            if inst.components.dst_gi_nahida_data then
                inst.components.dst_gi_nahida_data:OnAttack(data.target)
                -- 获取4命加成伤害
                new_damage = new_damage + inst.components.dst_gi_nahida_data.nahida_illusory_heart_level4_buff_damage
                if inst.components.dst_gi_nahida_data.nahida_fateseat_level >= 6 then
                    -- 6命座生命值附加效果开关配置
                    if TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CONSTELLATION_6_HEALTH_BONUS then
                        local health_damage = math.max(data.target.components.health.maxhealth * 0.002, 1)
                        new_damage = new_damage + health_damage
                    end
                end
            end
            if data.target.components.dst_gi_nahida_elemental_reaction and damage >= 0 then
                if data.target:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_SEED_OF_SKANDHA_TAG)
                        and data.target.components.dst_gi_nahida_four_leaf_clover_data
                then
                    -- 6命效果
                    local IS_BUFF6 = false
                    if data.target.components.dst_gi_nahida_four_leaf_clover_data.seed_of_skandha_count > 0
                            and inst:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF6) then
                        IS_BUFF6 = true
                    end
                    if IS_BUFF6 then
                        -- 普攻提升为战技伤害,且是强化战技灭净三叶
                        data.target.components.dst_gi_nahida_four_leaf_clover_data:SeedOfSkandhaLevel2Attack(inst, data.weapon, true, data.target, damage, new_damage)
                    else
                        -- 普攻提升为战技伤害,且战技灭净三叶  2.5秒受到强化一次伤害
                        data.target.components.dst_gi_nahida_four_leaf_clover_data:SeedOfSkandhaLevel1Attack(inst, data.weapon, true, data.target, damage, new_damage)
                    end

                    -- 获取当前实体的位置
                    local x, y, z = data.target.Transform:GetWorldPosition()
                    local ents = TheSim:FindEntities(x, y, z, 30, { TUNING.MOD_DST_GI_NAHIDA.NAHIDA_SEED_OF_SKANDHA_TAG }, exclude_tags)
                    for i, ent in ipairs(ents) do
                        -- 灭净三叶*业障除
                        if ent ~= nil and ent:IsValid() and ent.components.health and not ent.components.health:IsDead() then
                            if ent.components.dst_gi_nahida_four_leaf_clover_data then
                                if IS_BUFF6 then
                                    -- 普攻提升为战技伤害,且是强化战技灭净三叶
                                    ent.components.dst_gi_nahida_four_leaf_clover_data:SeedOfSkandhaLevel2Attack(inst, data.weapon, false, ent, damage, new_damage)
                                else
                                    -- 普攻提升为战技伤害,且战技灭净三叶 2.5秒受到一次伤害
                                    ent.components.dst_gi_nahida_four_leaf_clover_data:SeedOfSkandhaLevel1Attack(inst, data.weapon, false, ent, damage, new_damage)
                                end

                            end
                        end
                    end
                else
                    if data.target.components.dst_gi_nahida_elemental_reaction then
                        -- 使用括号来确保优先级正确
                        if data.weapon and TUNING.ELEMENTAL_WEAPON[data.weapon.prefab] and (data.is_skill == nil or data.is_skill ~= nil and data.is_skill == false) then
                            if data.weapon.prefab == "dst_gi_nahida_weapon_staff" and data.weapon.components.container ~= nil then
                                local item = data.weapon.components.container.slots[1]
                                if item and TUNING.ELEMENTAL_WEAPON[item.prefab] then
                                    TUNING.ELEMENTAL_WEAPON[item.prefab].fn(data.target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                            data.target, { weapon_damage = damage, additional_damage = new_damage,true_damage = true, is_skill = data.is_skill ~= nil and data.is_skill or false })
                                else
                                    TUNING.ELEMENTAL_WEAPON[data.weapon.prefab].fn(data.target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                            data.target, { weapon_damage = damage, additional_damage = new_damage,true_damage = true, is_skill = data.is_skill ~= nil and data.is_skill or false })
                                end
                            else
                                TUNING.ELEMENTAL_WEAPON[data.weapon.prefab].fn(data.target,TUNING.ELEMENTAL_STRENGTH.STRONG,
                                        data.target, { weapon_damage = damage, additional_damage = new_damage,true_damage = true, is_skill = data.is_skill ~= nil and data.is_skill or false })
                            end
                        else
                            data.target.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG,
                                    data.target, { weapon_damage = damage, additional_damage = new_damage,true_damage = true, is_skill = data.is_skill ~= nil and data.is_skill or false })
                        end
                    end
                end
            end
        end
    end
end

local function picksomething(inst, data)
    if data and data.loot then
        --采摘的是农场作物
        if data.object and data.object:HasTag("farm_plant") and inst:HasTag(TUNING.AVATAR_NAME) and inst.components.dst_gi_nahida_data then
            local prefab = data.loot[1] and data.loot[1].prefab --获取采摘的预置物名
            if prefab then
                --从巨型作物列表里寻找对应作物，如果有则+1
                local flag = false
                for _, v in ipairs(TUNING.OVERSIZED_PICKLIST) do
                    if prefab == v then
                        flag = true
                        break
                    end
                end
                local harvestGrowthMode = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_harvest_growth_mode") or "MEDIUM"
                --local harvestGrowthMode = "EASY"
                local oversizedPickNumDelta = TUNING.HARVEST_GROWTH_DATA[harvestGrowthMode].OVERSIZED_PICK_NUM_DELTA
                local farmPlantNumDelta = TUNING.HARVEST_GROWTH_DATA[harvestGrowthMode].FARM_PLANT_NUM_DELTA
                if flag then
                    -- 采摘巨型+1点成长属性
                    inst.components.dst_gi_nahida_data:DoOversizedPickNumDelta(oversizedPickNumDelta)
                else
                    -- 采摘普通农作物+0.0点成长属性
                    if farmPlantNumDelta then
                        inst.components.dst_gi_nahida_data:DoFarmPlantNumDelta(farmPlantNumDelta)
                    end

                end
            end
        end
    end
end

local function cookDdditionalRandomChance()
    -- 20% 的概率双倍收锅，就是额外获得一个
    if math.random() < 0.2 then
        return 1
    else
        return 0
    end
end

-- 周围有玩家进行回san
local function UpdateSanityRegen(inst)
    -- 队友亲和回san
    local x, y, z = inst.Transform:GetWorldPosition()
    local teammates = TheSim:FindEntities(x, y, z, 15, { "player" }, { TUNING.AVATAR_NAME, "playerghost", "INLIMBO" })
    local num_teammates = #teammates
    -- 根据命座等级调整回san初始值
    local init_sanity_regen = 5
    local dst_gi_nahida_data = inst.components.dst_gi_nahida_data
    if dst_gi_nahida_data then
        if dst_gi_nahida_data.nahida_fateseat_level >= 2 then
            init_sanity_regen = 10
        elseif dst_gi_nahida_data.nahida_fateseat_level >= 3 then
            init_sanity_regen = 15
        elseif dst_gi_nahida_data.nahida_fateseat_level >= 4 then
            init_sanity_regen = 20
        end
    end
    local sanity_regen = init_sanity_regen + math.min(num_teammates, 4) * 10 -- 每多一个队友+10，上限60
    if inst.components.sanity then
        inst.components.sanity.dapperness = sanity_regen / 60
    end

end

-- 定义鱼类相关食物的常量列表
local FISH_FOODS = {
    "lobsterbisque", -- 龙虾汤
    "surfnturf", -- 海鲜牛排
    "frogfishbowl", -- 蓝带鱼排
    "barnaclestuffedfishhead", -- 酿鱼头
    "lobsterdinner", -- 龙虾正餐
    "unagi", -- 鳗鱼料理
    "ceviche", -- 酸橘汁腌鱼
    "fishmeat_small", -- 小鱼块
    "fishmeat_small_cooked", -- 熟小鱼块
    "fish_cooked", -- 熟鱼块
    "californiaroll", -- 加州卷
    "fishtacos", -- 鱼肉玉米卷
    "fish", -- 鱼肉
    "fishsticks", -- 炸鱼排
    "seafoodgumbo", -- 海鲜浓汤
    -- 添加其他鱼类相关食物
}

local function IsFishRelated(food)
    return food:HasTag("fish") or food:HasTag("fishmeat") or food.prefab == "fish_cooked" or food.prefab and table.contains(FISH_FOODS, food.prefab)
end

local function OnEat(inst, data)
    if data == nil then
        return
    end
    if data.food and data.food.components.edible then
        local sanity_delta = data.food.components.edible.sanityvalue
        local health_delta = data.food.components.edible.healthvalue
        -- 检查食物是否是鱼类相关
        if IsFishRelated(data.food) then
            -- 计算扣除的理智值
            if sanity_delta > 0 then
                local sanity_loss = sanity_delta < 10 and 10 or sanity_delta * 2
                inst.components.sanity:DoDelta(-sanity_loss)
            end
            -- 计算扣除的血量值
            if health_delta > 0 then
                inst.components.health:DoDelta(-health_delta)
            end
        end
    end
end

local function KillPet(pet)
    if pet.components.health:IsInvincible() then
        --reschedule
        pet._killtask = pet:DoTaskInTime(.5, KillPet)
    else
        pet.components.health:Kill()
    end
end

local function OnSpawnPet(inst, pet)
    local enable_shadowprotector = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_enable_shadowprotector")
    if pet:HasTag("shadowminion") then
        if not (inst.components.health:IsDead() or inst:HasTag("playerghost")) then
            --if not inst.components.builder.freebuildmode then
            if inst.components.petleash and inst.components.petleash:GetNumPets() > 6
                    or inst.components.sanity == nil
                    or inst.components.sanity and inst.components.sanity.current < 30
                    or (enable_shadowprotector and enable_shadowprotector == "disabled") and pet.prefab == "shadowprotector" -- 禁止召唤战斗仆人，感觉过于超模了
            then
                pet:Remove()
                return
            end
            inst.components.sanity:DoDelta(-30)
            --end
            inst:ListenForEvent("onremove", inst._onpetlost, pet)
            pet.components.skinner:CopySkinsFromPlayer(inst)
        elseif pet._killtask == nil then
            pet._killtask = pet:DoTaskInTime(math.random(), KillPet)
        end
    elseif inst._OnSpawnPet ~= nil then
        inst:_OnSpawnPet(pet)
    end
end

local function OnDespawnPet(inst, pet)
    if pet:HasTag("shadowminion") then
        if not inst.is_snapshot_user_session and pet.sg ~= nil then
            pet.sg:GoToState("quickdespawn")
        else
            pet:Remove()
        end
    elseif inst._OnDespawnPet ~= nil then
        inst:_OnDespawnPet(pet)
    end
end

local function NahidaOnSave(inst, data)
    --print("纳西妲保存数据"..inst.userid)
    -- 保存纳西妲本人数据 命座之类的
    --OnSaveGlobalNahidaData(inst,true)
    -- 保存法杖的数据
    --OnSaveGlobalWeaponStaffData(inst)
    -- 保存纳西妲的全局背包数据
    --OnSaveGlobalBackpackData(inst,nil)

end

-- 添加发光效果
local function AddGlowEffect(inst, color, range)
    -- 移除现有光源
    if inst.light ~= nil then
        inst.light:Remove()
        inst.light = nil
    end
    if TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.LIGHT_EMITTING then
        -- 生成新的光源
        inst.light = SpawnPrefab("minerhatlight")
        if inst.light then
            inst.light.entity:SetParent(inst.entity)
            inst.light.Light:SetFalloff(.8)
            inst.light.Light:SetIntensity(.55)
            -- 设置光源的颜色和范围
            if color and range then
                local r, g, b = unpack(color)
                inst.light.Light:SetRadius(range)
                inst.light.Light:SetColour(r, g, b)
            end
            -- 定义光源更新函数，根据时间变化启用或禁用光源
            local function UpdateLight()
                if inst.light ~= nil and inst.light:IsValid() then
                    if TheWorld.state.isnight then
                        inst.light.Light:Enable(true)
                    else
                        inst.light.Light:Enable(false)
                    end
                end
            end
            UpdateLight() -- 初始化时更新光源状态
            -- 监听世界时间变化事件
            inst:WatchWorldState("isnight", UpdateLight)
            inst:WatchWorldState("isdusk", UpdateLight)
            inst:WatchWorldState("isday", UpdateLight)
        end
    end
end

-- 确保在游戏中定义了远古科技栏
local function CharacterPostInit(inst)
    -- 监听玩家的攻击动作
    inst:ListenForEvent("onattackother", OnAttackOther)
    inst.cooktimemult = 0.4 -- 烹饪时间减少60%
    --inst.cook_additional_num = 1 -- 额外收锅数量
    inst.cookDdditionalRandomChance = cookDdditionalRandomChance
    inst:AddTag("reader")                                               -- 读书组件
    inst:AddTag("bookbuilder")                                          -- 书架制造
    inst:AddTag("stronggrip")                                           -- 武器工具不脱手
    inst:AddTag("plantkin")                                             -- 植物人能力
    inst:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NO_STEAL)           -- 不会被火药猴偷取
    inst:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG) -- 兼容富贵右键动作开关标签
    inst:AddTag('eyeplant_friend')                                      -- 眼球草友好
    inst:AddTag("shadowmagic")                                          -- 可以制造暗影秘典
    inst:AddTag("dappereffects")                                        -- 可以使用暗影秘典
    inst:AddTag("fastbuilder")                                        -- 快速制造能力
    inst:AddTag("polite")                                            -- 有此标签的角色雇佣（猪兔虾）生物的忠诚度会比正常角 色长，能跟随角色更长时间

    inst:DoTaskInTime(1, function()
        inst:RemoveTag("scarytoprey")                                   -- 不会惊吓小动物，鸟类除外（鸟类需要拦截起飞事件）
    end)
    if inst.components.petleash ~= nil then
        inst._OnSpawnPet = inst.components.petleash.onspawnfn
        inst._OnDespawnPet = inst.components.petleash.ondespawnfn
        inst.components.petleash:SetMaxPets(6)  -- 设置最大宠物数量为6
    else
        inst:AddComponent("petleash")
        inst.components.petleash:SetMaxPets(6)  -- 设置最大宠物数量为6
    end
    if inst.components.builder then
        inst.components.builder.science_bonus = 2   -- 二本科技
        inst.components.builder.seafaring_bonus  = 2   -- 航海科技 SEAFARING
        inst.components.builder.fishing_bonus  = 2   -- 钓鱼科技 FISHING
    end
    -- 生成小跟班
    inst.components.petleash:SetOnSpawnFn(OnSpawnPet)
    inst.components.petleash:SetOnDespawnFn(OnDespawnPet)
    -- 靠近队友回san
    inst:DoPeriodicTask(1, UpdateSanityRegen)
    -- 收获巨大植物
    inst.picksomething = picksomething
    inst:ListenForEvent("picksomething", inst.picksomething)

    -- 监听吃食物事件
    inst:ListenForEvent("oneat", OnEat)

    AddGlowEffect(inst,{144/255, 238/255, 144/255},4)

    --inst.OnSave = NahidaOnSave
end

-- 在角色的初始化中调用
AddPrefabPostInit(TUNING.MOD_ID, CharacterPostInit)
