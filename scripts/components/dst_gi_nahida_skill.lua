---
--- dst_gi_nahida_skill.lua
--- Description: 元素能量组件
--- Author: 没有小钱钱
--- Date: 2025/3/28 23:28
---

local exclude_tags = { "INLIMBO", "companion", "wall", "abigail", "player", "chester", "zhijiang_hound" }
local findList = { "stump", "_inventoryitem", "pickable", "harvestable", "readyforharvest", "donecooking", "dried", "takeshelfitem" }
local canttags = { "INLIMBO", "NOCLICK", "catchable", "fire", "notdevourable", "singingshell" } -- 不该检索的标签列表

local baits_list = {
    "powcake", --火药饼
    "winter_food4", --水果蛋糕
    "mandrake", --曼德拉草
}
-- 判断物品是否在墙内
local function isInsideWall(item)
    if not table.contains(baits_list, item.prefab) then
        return false
    end
    local x, y, z = item.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 2, { "wall" }, { "INLIMBO" })
    local wallNum = 0
    for i, v in ipairs(ents) do
        if v.components.health then
            wallNum = wallNum + 1
        end
    end
    return wallNum >= 5
end

-- 判断是否是蜂箱边上的花
local function isHoneyFlower(item)
    if item:HasTag("flower") then
        local x, y, z = item.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 15, { "beebox" }, { "INLIMBO" })
        if ents and #ents > 0 then
            return true
        end
    end
    return false
end

local function harvestFish(inst, radius)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ent0 = TheSim:FindEntities(x, y, z, radius, { TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FISH_TAG }, exclude_tags)
    for i, ent in ipairs(ent0) do
        if ent:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FISH_TAG) then
            local item = SpawnPrefab(ent.prefab .. "_inv")
            if item then
                inst.components.inventory:GiveItem(item)
                ent:Remove()
            end
        end
    end
end

local function OnCurrentEnergy(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_skill then
        self.inst.replica.dst_gi_nahida_skill:SetCurrentEnergy(value)
    end
end
local function OnSkillCurrentCd(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_skill then
        self.inst.replica.dst_gi_nahida_skill:SetSkillCurrentCd(value)
    end
end
local function OnBurstCurrentCd(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_skill then
        self.inst.replica.dst_gi_nahida_skill:SetBurstCurrentCd(value)
    end
end
local function OnCurrentSkillMode(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_skill then
        self.inst.replica.dst_gi_nahida_skill:SetCurrentSkillMode(value)
    end
end
-- 定义一个类，用于管理角色的元素能量和技能冷却时间
local dst_gi_nahida_skill = Class(function(self, inst)
    self.inst = inst
    self.max_energy = 50 -- 最大能量值
    self.nahida_skill_cd = 5 -- 元素战技的冷却时间（秒）
    self.nahida_skill_fight_cd = 8 -- 战斗 元素战技的冷却时间（秒）
    self.nahida_skill_stimuli = 1.82 -- 元素战技倍率 182%
    self.nahida_skill_attack_radius = 15 -- 元素战技选取攻击范围，同武器攻击范围
    self.nahida_burst_cd = 13.5 -- 元素爆发的冷却时间（秒）
    self.nahida_burst_duration = 15 -- 元素爆发的持续时间（秒）
    self.current_energy = self.max_energy -- 当前能量值，初始化为最大值
    self.nahida_skill_current_cd = 0 -- 元素战技的当前冷却时间
    self.nahida_burst_current_cd = 0 -- 元素爆发的当前冷却时间
    self.skill_mode = {
        [1] = "FIGHT",
        [2] = "HARVEST",
        [3] = "PICK_UP",
    }
    self.current_skill_mode = "FIGHT"

    -- 启动组件的更新，以便在游戏循环中定期调用 OnUpdate 方法
    self.inst:StartUpdatingComponent(self)
end, nil, {
    current_energy = OnCurrentEnergy,
    nahida_skill_current_cd = OnSkillCurrentCd,
    nahida_burst_current_cd = OnBurstCurrentCd,
    current_skill_mode = OnCurrentSkillMode
})

-- 更新方法，每帧调用一次，用于更新技能和爆发的冷却时间
function dst_gi_nahida_skill:OnUpdate(dt)
    -- 更新元素战技的冷却时间
    if self.nahida_skill_current_cd > 0 then
        self.nahida_skill_current_cd = self.nahida_skill_current_cd - dt
        if self.nahida_skill_current_cd < 0 then
            self.nahida_skill_current_cd = 0 -- 确保冷却时间不为负
        end
    end

    -- 更新元素爆发的冷却时间
    if self.nahida_burst_current_cd > 0 then
        self.nahida_burst_current_cd = self.nahida_burst_current_cd - dt
        if self.nahida_burst_current_cd < 0 then
            self.nahida_burst_current_cd = 0 -- 确保冷却时间不为负
        end
    end
end

-- 启动元素战技的冷却计时
function dst_gi_nahida_skill:StartSkillCd()
    self.nahida_skill_current_cd = self.nahida_skill_cd
    --if self.current_skill_mode == "FIGHT" then
    --    self.nahida_skill_current_cd = self.nahida_skill_fight_cd
    --else
    --    self.nahida_skill_current_cd = self.nahida_skill_cd
    --end
end

-- 启动元素爆发的冷却计时
function dst_gi_nahida_skill:StartBurstCd()
    self.nahida_burst_current_cd = self.nahida_burst_cd
end

-- 设置最大能量值，确保最小值为 1
function dst_gi_nahida_skill:SetMaxEnergy(value)
    self.max_energy = math.max(1, value)
end

-- 设置当前能量值，确保在 0 和最大能量值之间
function dst_gi_nahida_skill:SetCurrentEnergy(value)
    self.current_energy = math.clamp(value, 0, self.max_energy)
end

-- 增加或减少当前能量值
function dst_gi_nahida_skill:DoDelta(amount)
    self:SetCurrentEnergy(self.current_energy + amount)
end

-- 根据百分比设置当前能量值
function dst_gi_nahida_skill:SetPercent(percent)
    percent = math.clamp(percent, 0, 1)
    self.current_energy = self.max_energy * percent
end

-- 启动爆发技能
function dst_gi_nahida_skill:StartBurst(inst)
    if  not inst:HasTag(TUNING.AVATAR_NAME)
            or inst:HasTag("playerghost") or
            (inst.components.health and inst.components.health:IsDead())
    then
        return false
    end
    -- 检查是否正在骑行
    if inst.components.rider and inst.components.rider:IsRiding() then
        if inst.components.talker then
            inst.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_RIDING_SKILL_MESSAGE)
        end
        return false
    end
    if self.nahida_burst_current_cd > 0 then
        if inst.components.talker then
            inst.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CURRENT_CD)
        end
        return false
    end
    if self.current_energy < 50 then
        if inst.components.talker then
            inst.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_BURST_ELEMENTAL_ENERGY)
        end
        return false
    end

    self:StartBurstCd() -- 技能cd重置
    self:SetCurrentEnergy(0) -- 重置能量值
    if inst.sg ~= nil then
        inst.components.locomotor:Stop()
        inst.sg:GoToState("nahida_dst_gi_nahida_illusory_heart")
    end
    local illusory_heart_fx = SpawnPrefab("fx_dst_gi_nahida_illusory_heart_fx")
   -- 设置命座效果
    if illusory_heart_fx.components.dst_gi_nahida_illusory_heart_data and inst.components.dst_gi_nahida_data then
        illusory_heart_fx.components.dst_gi_nahida_illusory_heart_data:Init()
        illusory_heart_fx.components.dst_gi_nahida_illusory_heart_data:SetFateseatLevel(inst.components.dst_gi_nahida_data.nahida_fateseat_level)
    end
    -- 获取角色当前位置
    local x, y, z = inst.Transform:GetWorldPosition()
    -- 将特效位置设置为角色脚下
    illusory_heart_fx.Transform:SetPosition(x, 0, z)
    --illusory_heart_fx2.Transform:SetPosition(x, 0, z)
    inst.SoundEmitter:PlaySound("nahida_skill/nahida_skill_sound/nahida_burst_sound")
end

function dst_gi_nahida_skill:InitComponents(target)
    if target.components.dst_gi_nahida_elemental_reaction == nil then
        target:AddComponent("dst_gi_nahida_elemental_reaction") -- 添加当前状态组件
    end
    if target.components.dst_gi_nahida_elemental_reaction then
        -- 初始化组件默认方法
        if self.inst.components.dst_gi_nahida_data then -- 赋予命座效果
            target.components.dst_gi_nahida_elemental_reaction:SetFateseatLevel(self.inst.components.dst_gi_nahida_data.nahida_fateseat_level)
        end
        target.components.dst_gi_nahida_elemental_reaction:InitComponents(target)
    end
end

function dst_gi_nahida_skill:SetSkillMode(player,skill_mode)
    self.current_skill_mode = skill_mode
    if player.components.talker then
        player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE[string.upper(self.current_skill_mode)])
    end
end

-- 元素战技拾取
function dst_gi_nahida_skill:StartSkillPickUp(player,skill_attack_radius)
    -- 获取当前实体的位置
    local x, y, z = player.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, skill_attack_radius, nil, canttags, findList)
    for i, v in ipairs(ents) do
        self:PickItem(v, player, false)
    end
    --harvestFish(player, skill_attack_radius)
    return true
end

function dst_gi_nahida_skill:StartSkillFight(player, item,skill_attack_radius)
    -- 获取当前实体的位置
    local x, y, z = player.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, skill_attack_radius, { "_combat" }, exclude_tags)
    -- 4命效果
    if player.components.dst_gi_nahida_data and player.components.dst_gi_nahida_data.nahida_fateseat_level >= 4 then
        local damage = 0
        if #ents >= 4 then
            damage = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT4.NUM4
        elseif #ents == 3 then
            damage = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT4.NUM3
        elseif #ents == 2 then
            damage = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT4.NUM2
        elseif #ents == 1 then
            damage = TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT4.NUM1
        end
        player.components.dst_gi_nahida_data:SetNahidaIllusoryHeartLevel4BuffDamage(damage)
    end
    for i, ent in ipairs(ents) do
        -- 有follower组件且leader是玩家，视为友好 and ent.components.follower and ent.components.follower.leader == nil
        if ent ~= nil and ent:IsValid() and ent.components.health and not ent.components.health:IsDead() then
            if not (ent.components.follower and ent.components.follower.leader ~= nil
                    and ent.components.follower.leader:HasTag("player")
                and (ent.prefab == "pigman"
                    or ent:HasTag("merm_npc")
                    or ent:HasTag("spider")
            ))
                    and not (ent:HasTag("beehive"))  -- 蜂窝
                    and not (ent.prefab == "dl_dragon_pearl")  -- 墨玖的龙珠
            then
                -- 初始化元素反应组件
                player.components.dst_gi_nahida_skill:InitComponents(ent)
                -- 添加buff组件
                if ent.components.debuffable == nil then
                    ent:AddComponent("debuffable")
                end
                if ent.components.debuffable then
                    ent.components.debuffable:AddDebuff("buff_" .. TUNING.MOD_ID .. "_seed_of_skandha", "buff_" .. TUNING.MOD_ID .. "_seed_of_skandha")
                end
                -- 目标造成一次伤害
                local weapon_damage = 0
                if item and item.components.weapon then
                    weapon_damage = item.components.weapon:GetDamage(player, ent)
                else
                    weapon_damage = player.components.combat.defaultdamage or 0
                end
                local additional_damage = (weapon_damage * self.nahida_skill_stimuli - weapon_damage)
                local new_damage = 0
                if player:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF1) then -- 1命大招效果 BUFF1
                    new_damage = (weapon_damage + additional_damage) * TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT1.MULTIPLIERS
                elseif player:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF0) then -- 0命大招提升效果
                    new_damage = (weapon_damage + additional_damage) * TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT0.MULTIPLIERS
                end
                --攻击时恢复仇恨
                if player.components.dst_gi_nahida_data then
                    player.components.dst_gi_nahida_data:OnAttack(ent)
                    -- 获取4命加成伤害
                    new_damage = new_damage + player.components.dst_gi_nahida_data.nahida_illusory_heart_level4_buff_damage
                end
                -- 触发一次草系攻击伤害
                ent.components.dst_gi_nahida_elemental_reaction:GrassAttack(TUNING.ELEMENTAL_STRENGTH.STRONG, ent, {
                    true_damage = true,
                    weapon_damage = weapon_damage,
                    additional_damage = additional_damage + new_damage,
                    is_skill = true
                })
            end
        end
    end
    return true
end

-- 战技催熟生长模式
function dst_gi_nahida_skill:StartSkillTryGrowthForEntities(player,skill_attack_radius)
    local GARDENING_CANT_TAGS = { "INLIMBO", "stump" }
    local GARDENING_ONEOF_TAGS = { "plant", "crop", "growable", "barren", "perennialcrop", "perennialcrop2", "harvestable", "silviculture" }
    local x, y, z = player.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, skill_attack_radius * 2, nil, GARDENING_CANT_TAGS, GARDENING_ONEOF_TAGS)
    for _, ent in ipairs(ents) do
        if ent:IsValid() and not ent:IsInLimbo() then
            -- 处理树精
            if ent:HasTag("leif") then
                ent.components.sleeper:GoToSleep(3000)
            else
                -- 处理 growable 组件 更高级的作物催熟组件
                local growable = ent.components.growable
                if growable ~= nil and not ent:HasTag("stump") then
                    local stage = growable.stage
                    local max_stage = #growable.stages
                    local isTree = ent:HasTag("tree") or ent:HasTag("winter_tree") or ent:HasTag("siving_derivant")
                    local isSpecialPlant = ent:HasTag("farm_plant_immortal_fruit")
                            or ent:HasTag("farm_plant_medal_gift_fruit")
                            or ent.prefab == "farm_plant_randomseed" -- 种子也没有枯萎阶段
                    if ((isTree and not ent:HasTag("stump"))) then
                        if stage < max_stage or ent:HasTag("siving_derivant") then
                            if stage < max_stage then
                                ent.components.growable:SetStage(max_stage - 1)
                            end
                            if ent.components.simplemagicgrower ~= nil then
                                ent.components.simplemagicgrower:StartGrowing()
                            elseif growable.domagicgrowthfn ~= nil then
                                growable:DoMagicGrowth()
                            else
                                growable:DoGrowth()
                            end
                        end
                    elseif ent:HasTag("farm_plant") then
                        -- 把农锁在这
                        if (stage < (max_stage - 1) or (isSpecialPlant and stage < max_stage)) then
                            if isSpecialPlant then
                                ent.components.growable:SetStage(max_stage - 1)
                            else
                                ent.components.growable:SetStage(max_stage - 2)
                            end
                            growable:DoGrowth()
                        end
                    else
                        if ent.components.simplemagicgrower ~= nil then
                            ent.components.simplemagicgrower:StartGrowing()
                        elseif growable.domagicgrowthfn ~= nil then
                            growable:DoMagicGrowth()
                        else
                            growable:DoGrowth()
                        end
                    end
                elseif ent.components.pickable ~= nil then
                    if not (ent.components.pickable:CanBePicked() and ent.components.pickable.caninteractwith) then
                        if ent.components.pickable:FinishGrowing() then
                            ent.components.pickable:ConsumeCycles(1) -- magic grow is hard on plants
                        end
                    end
                elseif ent.components.crop ~= nil and (ent.components.crop.rate or 0) > 0 then
                    ent.components.crop:DoGrow(1 / ent.components.crop.rate, true)
                elseif ent.components.harvestable ~= nil and ent:HasTag("mushroom_farm") then
                    -- 蘑菇农场催熟逻辑
                    local harvestable = ent.components.harvestable
                    if harvestable:IsMagicGrowable() then
                        harvestable:DoMagicGrowth()
                    else
                        harvestable:Grow()
                    end
                end
            end
        end
    end
    return true
end

-- 启动元素战技
function dst_gi_nahida_skill:StartSkill(player)
    if player:HasTag("playerghost")
            or not player:HasTag(TUNING.AVATAR_NAME)
         or (player.components.health and player.components.health:IsDead())
    then
        return false
    end
    -- 检查是否正在骑行
    if player.components.rider and player.components.rider:IsRiding() then
        if player.components.talker then
            player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_RIDING_SKILL_MESSAGE)
        end
        return false
    end
    if self.nahida_skill_current_cd > 0 then
        if player.components.talker then
            player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CURRENT_CD)
        end
        return false
    end
    local item = nil
    if self.current_skill_mode == "FIGHT" then
        -- 战技伤害
        item = player.components.inventory.equipslots[EQUIPSLOTS.HANDS]
        if item == nil or not item.components.weapon then
            if player.components.talker then
                player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_NOT_EQUIP_WEAPON)
            end
            return false
        end
    end
    self:StartSkillCd() -- 技能cd重置
    player.SoundEmitter:PlaySound("nahida_skill/nahida_skill_sound/nahida_skill_sound")
    -- 元素战技范围
    local skill_attack_radius = self.nahida_skill_attack_radius
    -- 判断释放是催熟模式
    if self.current_skill_mode and self.current_skill_mode ~= TUNING.MOD_DST_GI_NAHIDA.SKILL_MODE.GROWTH then
        -- 战技语音
        local skillVoice = STRINGS.MOD_DST_GI_NAHIDA.SKILL_VOICE
        -- 获取语音个数
        local voiceCount = #skillVoice
        if voiceCount > 0 then
            local skillVoiceIndex = math.random(1, voiceCount)
            if player.components.talker then
                player.components.talker:Say(skillVoice[skillVoiceIndex])
            end
        end
        -- 战斗模式
        if self.current_skill_mode == "FIGHT" then
            if player.components.dst_gi_nahida_data and player.components.dst_gi_nahida_data.nahida_fateseat_level >= 3 then
                skill_attack_radius = skill_attack_radius + TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT3.SKILL_RADIUS
            end
            -- 战斗模式
            return self:StartSkillFight(player, item,skill_attack_radius)
        elseif self.current_skill_mode == "HARVEST" or self.current_skill_mode == "PICK_UP" then -- 拾取或者收货模式
            if player.components.dst_gi_nahida_data and player.components.dst_gi_nahida_data.nahida_fateseat_level >= 3 then
                skill_attack_radius = skill_attack_radius + TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT3.SKILL_RADIUS
            end
            -- 战技收获模式，拾取模式
            return self:StartSkillPickUp(player,skill_attack_radius)
        end
    end
    -- 催熟模式
    if self.current_skill_mode and self.current_skill_mode == TUNING.MOD_DST_GI_NAHIDA.SKILL_MODE.GROWTH then
        if player.components.talker then
            player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TRY_GROWTH)
        end
        if player.components.dst_gi_nahida_data and player.components.dst_gi_nahida_data.nahida_fateseat_level >= 3 then
            -- +2是因为催熟范围是*2，所以实际是+4
            skill_attack_radius = skill_attack_radius + TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_NUMERICAL.FATESEAT3.TRY_GROWTH_RADIUS
        end
        return self:StartSkillTryGrowthForEntities(player,self.nahida_skill_attack_radius)
    end
    return false

end

-- 拾取物品
function dst_gi_nahida_skill:PickItem(item, player, single)
    local nopick_list = { -- 白名单物品
        mandrake_planted = true, -- 曼德拉草
        medal_wormwood_flower = true, -- 虫木花
        terrarium = true,
        moonrockseed = true,
        glommerflower = true,
        chester_eyebone = true,
        fruitflyfruit = true,
        bookinfo_myth = true,
        myth_yylp = true,
        myth_plant_infant_fruit = true,
    }
    -- 如果是白名单物品，不捡
    if nopick_list[item.prefab] then
        return
    end
    -- 如果是围在墙内的诱饵就不捡
    if isInsideWall(item) then
        return
    end
    -- 如果是部署好的陷阱则不捡
    if item:HasTag("trap") and item.components.inventoryitem and item.components.inventoryitem.nobounce then
        return
    end
    -- 如果是布置类的陷阱，在布置好的情况下不捡
    if item.components.trap and item.components.trap.isset then
        return
    end

    if item.components.equippable then
        return
    end -- 装备不捡

    if item:HasTag("pickable") and item.components.pickable then
        -- 范围采集的时候不采集蜂箱边上的花
        if isHoneyFlower(item) and not single then
            return
        end
        item.components.pickable:Pick(player)
        return
    end

    -- 蘑菇农场、蜂箱等
    if item.components.harvestable then
        item.components.harvestable:Harvest(player)
        return
    end
    -- 农作物
    if item.components.crop then
        item.components.crop:Harvest(player)
        return
    end
    -- 锅
    if item.components.stewer then
        item.components.stewer:Harvest(player)
        return
    end
    -- 晒肉架
    if item.components.dryer then
        item.components.dryer:Harvest(player)
        return
    end
    -- 眼球草
    if item.components.shelf then
        item.components.shelf:TakeItem(player)
        return
    end

    if player ~= nil and player.components.inventory ~= nil then
        if item:HasTag("stump") then
            -- 树桩产物表
            local treelist = {
                livingtree_halloween = "livinglog", -- 万圣节活木树
                livingtree = "livinglog", -- 活木树
                driftwood_tall = "driftwood_log", -- 浮木树
                medal_fruit_tree_stump = "medaldug_fruit_tree_stump", -- 砧木桩
            }
            local logname = "log"
            -- 根据不同树桩给不同木头，桦木树比较特殊需要特殊判断
            if item.prefab == "deciduoustree" and item.monster then
                logname = "livinglog"
            elseif treelist[item.prefab] then
                logname = treelist[item.prefab]
            end

            local logitem = SpawnPrefab(logname)
            if (item.prefab == "moon_tree" or item.prefab == "palmconetree") and item.size ~= "short" then
                if logitem.components.stackable then
                    logitem.components.stackable:SetStackSize(2)
                end
            end
            player.components.inventory:GiveItem(logitem)
            item:Remove()
        end
    end

    -- 拾取道具
    if item.components.inventoryitem and item.components.inventoryitem.canbepickedup and item.components.inventoryitem.cangoincontainer and not item.components.inventoryitem:IsHeld() then
        local stacknum = item.components.stackable and item.components.stackable:StackSize() or 1 -- 堆叠数量
        if self.current_skill_mode == "PICK_UP" then
            -- 如果是触发后的陷阱则拾取
            if item.components.trap and item.components.trap:IsSprung() then
                item.components.trap:Harvest(player)
                return
            end
            -- 消耗计算
            player.components.inventory:GiveItem(item, nil, item:GetPosition())
        end
    end
end

-- 保存当前能量和冷却时间的状态
function dst_gi_nahida_skill:OnSave()
    return {
        current_energy = self.current_energy,
        nahida_skill_current_cd = self.nahida_skill_current_cd,
        nahida_burst_current_cd = self.nahida_burst_current_cd,
        current_skill_mode = self.current_skill_mode,
        nahida_skill_attack_radius = self.nahida_skill_attack_radius
    }
end

-- 加载能量和冷却时间的状态
function dst_gi_nahida_skill:OnLoad(data)
    if data.current_energy then
        self.current_energy = data.current_energy
    end
    if data.nahida_skill_current_cd then
        self.nahida_skill_current_cd = data.nahida_skill_current_cd
    end
    if data.nahida_burst_current_cd then
        self.nahida_burst_current_cd = data.nahida_burst_current_cd
    end
    if data.current_skill_mode then
        self.current_skill_mode = data.current_skill_mode
    end
    if data.nahida_skill_attack_radius then
        self.nahida_skill_attack_radius = data.nahida_skill_attack_radius
    end
end

-- 返回类定义
return dst_gi_nahida_skill