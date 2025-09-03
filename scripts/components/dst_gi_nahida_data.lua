---
--- dst_gi_nahida_data.lua
--- Description: 纳西妲核心数据
--- Author: 没有小钱钱
--- Date: 2025/4/10 22:47
---

local  function InitData(inst)
    if inst and inst.components.dst_gi_nahida_data then
        local nahida_data = inst.components.dst_gi_nahida_data
        local nahida_fateseat_level = nahida_data.nahida_fateseat_level
        if inst.components.builder then
            inst.components.builder.ancient_bonus = 0   -- 远古科技
            inst.components.builder.magic_bonus = 0     -- 魔法二本
            inst.components.builder.ingredientmod = 1 -- 制造减半
            if nahida_fateseat_level >= 1 then
                inst.components.builder.ingredientmod = 0.5 -- 制造减半
            end
            if nahida_fateseat_level >= 2 then
                inst.components.builder.magic_bonus = 3     -- 魔法二本
            end
            if nahida_fateseat_level >= 3 then
                inst.components.builder.ancient_bonus = 4   -- 远古科技
            end
        end
        if nahida_fateseat_level and nahida_fateseat_level > 0 then
            for i = 1, nahida_fateseat_level do
                if inst:HasTag(TUNING.MOD_ID.."_fateseat_level_"..i) then
                    inst:RemoveTag(TUNING.MOD_ID.."_fateseat_level_"..i)
                end
                inst:AddTag(TUNING.MOD_ID.."_fateseat_level_"..i)
            end
        else
            for i = 1, 6 do
                if inst:HasTag(TUNING.MOD_ID.."_fateseat_level_"..i) then
                    inst:RemoveTag(TUNING.MOD_ID.."_fateseat_level_"..i)
                end
            end
        end
    end
end

local function OnNahidaFateseatLevel(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_skill then
        self.inst.replica.dst_gi_nahida_skill:SetCurrentFateseatLevel(value)
    end
    if self.inst then
        InitData(self.inst)
    end
end

local function OnOversizedPickNum(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_skill and self.inst.components.dst_gi_nahida_data then
        self.inst.replica.dst_gi_nahida_skill:SetGrowthValue(self.inst.components.dst_gi_nahida_data:GetDamageData())
    end
end

local function OnFarmPlantPickNum(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_skill and self.inst.components.dst_gi_nahida_data then
        self.inst.replica.dst_gi_nahida_skill:SetGrowthValue(self.inst.components.dst_gi_nahida_data:GetDamageData())
    end
end

local dst_gi_nahida_data = Class(function(self, inst)
    self.inst = inst
    self.aggro_cooldown = 60 -- 冷却时间为60秒
    self.check_and_lose_aggro_task = nil
    self.oversized_pick_max_num = 99999999999
    self.farm_plant_pick_max_num = 99999999999
    self.oversized_pick_num = 0
    self.farm_plant_pick_num = 0
    self.nahida_fateseat_level = 0
    self.nahida_illusory_heart_level4_buff_damage = 0

    -- 每五秒回复2点能量，前提是角色未死亡
    self.inst:DoPeriodicTask(5, function()
        if self.inst.components.health and not self.inst.components.health:IsDead() and self.inst.components.dst_gi_nahida_skill then
            self.inst.components.dst_gi_nahida_skill:DoDelta(2)
        end
    end)

    self.inst:DoPeriodicTask(0.25, function()
        if self.inst:HasTag(TUNING.AVATAR_NAME) and self.inst:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_ILLUSORY_HEART_TAG_LEVEL.BUFF0) then
            self:PlantTick(self.inst)
        end
    end)
    self.inst:DoPeriodicTask(0.5, function()
        -- 自动对话作物
        local x, y, z = self.inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 8, { "farm_plant" })
        for _, v in ipairs(ents) do
            if v.components.farmplanttendable ~= nil then
                v.components.farmplanttendable:TendTo(self.inst)
            end
        end
    end)


    -- 启动检查和丢失仇恨的任务
    self:StartCheckAndLoseAggroTask()
end,nil, {
    nahida_fateseat_level = OnNahidaFateseatLevel,
    oversized_pick_num = OnOversizedPickNum,
    farm_plant_pick_num = OnFarmPlantPickNum,
})

function dst_gi_nahida_data:UseItem(player,item)
    -- 纳西妲的成长值
    if item == nil then
        return false
    end
    local item_count = item.components.stackable and item.components.stackable:StackSize() or 1
    if item.prefab == "dst_gi_nahida_growth_value" then
        self:DoOversizedPickNumDelta(item_count)
        -- 消耗成长值
        if item.components.stackable then
            item.components.stackable:Get(item_count):Remove()
        else
            item:Remove()
        end
        return true
    end
    return false
end

-- 命座等级提升
function dst_gi_nahida_data:AddFateseatLevel(item)
    if self.nahida_fateseat_level >= 6 then
        self.nahida_fateseat_level = 6
        if self.inst.components.talker then
            self.inst.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CURRENT_FATE_LEVEL .. tostring(self.nahida_fateseat_level))
        end
        return true
    end
    if self.nahida_fateseat_level < 6 then
        self.nahida_fateseat_level = self.nahida_fateseat_level + 1
        if self.inst.components.talker then
            self.inst.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CURRENT_FATE_LEVEL .. tostring(self.nahida_fateseat_level))
        end
        -- 检查物品是否是堆叠的
        if item.components.stackable and item.components.stackable:IsStack() then
            item.components.stackable:Get():Remove()  -- 只移除一个
        else
            item:Remove()  -- 如果不是堆叠的，移除整个物品
        end
    end
    return true
end

function dst_gi_nahida_data:SetNahidaIllusoryHeartLevel4BuffDamage(damage)
    self.nahida_illusory_heart_level4_buff_damage = damage
    -- 4命提升效果
    self.inst:DoTaskInTime(25, function(inst)
        self.nahida_illusory_heart_level4_buff_damage = 0
    end)
end

function dst_gi_nahida_data:DoOversizedPickNumDelta(num)
    if self.oversized_pick_num <= self.oversized_pick_max_num then
        self.oversized_pick_num = self.oversized_pick_num + num
    end
end

function dst_gi_nahida_data:DoFarmPlantNumDelta(num)
    if self.farm_plant_pick_num <= self.farm_plant_pick_max_num then
        self.farm_plant_pick_num = self.farm_plant_pick_num + num
    end
end

function dst_gi_nahida_data:GetDamageData()
    local max_limit = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_growth_value_limit")
    local harvest_growth_mode = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_harvest_growth_mode")
    if harvest_growth_mode ~= nil and harvest_growth_mode == "DISABLED" then
        return 0
    end
    local total_pick_num = self.farm_plant_pick_num + self.oversized_pick_num
    local num = math.floor(total_pick_num * 100) / 100
    if num >= max_limit then
        num = max_limit
    end
    return num
end

-- 启动或重置检查和丢失仇恨的任务
function dst_gi_nahida_data:StartCheckAndLoseAggroTask()
    if not self.inst:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NOT_HATRED) then
        self.inst:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NOT_HATRED)
    end
end

-- 在玩家攻击时调用此方法，以重置冷却时间
function dst_gi_nahida_data:OnAttack(target)
    if self.inst:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NOT_HATRED) then
        self.inst:RemoveTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NOT_HATRED)
    end
    if target and target.components.combat then
        if target:IsValid() and target.components.combat.target == nil then
            target.components.combat:SetTarget(self.inst)
            target:DoTaskInTime(self.aggro_cooldown, function()
                if target:IsValid()
                        and target.components.combat.target
                        and target.components.combat.target:HasTag("player")
                        and target.components.combat.target.userid == self.inst.userid
                then
                    target.components.combat:SetTarget(nil)
                end
            end)
        end
    end
    ---- 在冷却时间后重新启动检查和丢失仇恨的任务
    self.inst:DoTaskInTime(self.aggro_cooldown, function()
        self:StartCheckAndLoseAggroTask()
    end)
end

-- 植物人的开花特
function dst_gi_nahida_data:PlantTick(inst)
    if inst:HasTag("playerghost") then
        return
    end
    inst.plantpool = { 1, 2, 3, 4 }
    for i = #inst.plantpool, 1, -1 do
        table.insert(inst.plantpool, table.remove(inst.plantpool, math.random(i)))
    end
    local PLANTS_RANGE = 1 -- 可以适当减小这个值来增加密集度
    local MAX_PLANTS = 18

    -- 用于查找植物效果实体的标签
    local PLANTFX_TAGS = { "dst_gi_nahida_wormwood_plant_fx" }
    if inst.sg:HasStateTag("ghostbuild") or inst.components.health:IsDead() or not inst.entity:IsVisible() then
        return
    end
    if inst:GetCurrentPlatform() then
        return
    end

    -- 获取角色当前位置
    local x, y, z = inst.Transform:GetWorldPosition()
    if #TheSim:FindEntities(x, y, z, PLANTS_RANGE, PLANTFX_TAGS) < MAX_PLANTS then
        local map = TheWorld.Map
        local pt = Vector3(0, 0, 0)

        -- 增加生成数量
        local num_to_spawn = math.random(3, 4) -- 随机生成3到4个植物
        for _ = 1, num_to_spawn do
            local offset = FindValidPositionByFan(
                    math.random() * TWOPI, -- 随机角度
                    math.random() * PLANTS_RANGE, -- 随机距离
                    3, -- 尝试次数
                    function(offset)
                        pt.x = x + offset.x
                        pt.z = z + offset.z
                        return map:CanPlantAtPoint(pt.x, 0, pt.z)
                                and #TheSim:FindEntities(pt.x, 0, pt.z, .5, PLANTFX_TAGS) < 3
                                and map:IsDeployPointClear(pt, nil, .5)
                                and not map:IsPointNearHole(pt, .4)
                    end
            )
            if offset then
                local plant = SpawnPrefab("dst_gi_nahida_wormwood_plant_fx")
                plant.Transform:SetPosition(x + offset.x, 0, z + offset.z)
                local rnd = math.random()
                rnd = table.remove(inst.plantpool, math.clamp(math.ceil(rnd * rnd * #inst.plantpool), 1, #inst.plantpool))
                table.insert(inst.plantpool, rnd)
                plant:SetVariation(rnd)
            end
        end
    end
end


-- 提取命座
function dst_gi_nahida_data:ExtractionFateseat()
    if self.inst then
        local inst = self.inst
        local damageData =  math.floor(inst.components.dst_gi_nahida_data:GetDamageData() or 0)
        if damageData > 0 then
            local growth_value = SpawnPrefab("dst_gi_nahida_growth_value")
            if growth_value ~= nil then
                -- 如果生成的物品有堆叠组件，设置其堆叠数量
                if growth_value.components.stackable then
                    growth_value.components.stackable:SetStackSize(damageData)
                end
                inst.components.inventory:GiveItem(growth_value)
                -- 提取成功，设置0
                inst.components.dst_gi_nahida_data.oversized_pick_num = 0
                inst.components.dst_gi_nahida_data.farm_plant_pick_num = 0
            end
        end
        if inst.components.dst_gi_nahida_data.nahida_fateseat_level == 0 then
            if inst.components.talker then
                inst.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_EXTRACTION_FATESEAT)
            end
            return false
        else
            local level = inst.components.dst_gi_nahida_data.nahida_fateseat_level
            local fateseat = SpawnPrefab("dst_gi_nahida_fateseat")
            if fateseat ~= nil then
                -- 如果生成的物品有堆叠组件，设置其堆叠数量
                if fateseat.components.stackable and level > 1 then
                    fateseat.components.stackable:SetStackSize(level)
                end
                inst.components.inventory:GiveItem(fateseat)
                -- 提取成功，设置0
                inst.components.dst_gi_nahida_data.nahida_fateseat_level = 0
            end
            InitData(self.inst)
            -- 提取命座也要保存全局数据，避免刷命座
            OnSaveGlobalNahidaData(self.inst,false)
            return true
        end
    end
    return false
end

function dst_gi_nahida_data:OnSave()
    return {
        nahida_fateseat_level = self.nahida_fateseat_level,
        oversized_pick_num = self.oversized_pick_num,
        farm_plant_pick_num = self.farm_plant_pick_num
    }
end

-- 加载能量和冷却时间的状态
function dst_gi_nahida_data:OnLoad(data)
    if data.oversized_pick_num then
        self.oversized_pick_num = data.oversized_pick_num
    end
    if data.farm_plant_pick_num then
        self.farm_plant_pick_num = data.farm_plant_pick_num
    end
    if data.nahida_fateseat_level then
        self.nahida_fateseat_level = data.nahida_fateseat_level
    end
end

function dst_gi_nahida_data:getData()
    return {
        oversized_pick_num = self.oversized_pick_num,
        farm_plant_pick_num = self.farm_plant_pick_num,
        nahida_fateseat_level = self.nahida_fateseat_level,
    }
end

function dst_gi_nahida_data:SaveData(data)
    if data.oversized_pick_num then
        self.oversized_pick_num = data.oversized_pick_num
    end
    if data.farm_plant_pick_num then
        self.farm_plant_pick_num = data.farm_plant_pick_num
    end
    if data.nahida_fateseat_level then
        self.nahida_fateseat_level = data.nahida_fateseat_level
    end
end

return dst_gi_nahida_data
