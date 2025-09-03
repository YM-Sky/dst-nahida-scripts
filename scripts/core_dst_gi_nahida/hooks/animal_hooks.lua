---
--- animal_hooks.lua
--- Description: 
--- Author: 没有小钱钱
--- Date: 2025/4/11 0:07
---
---------------------------------------阻止鸟类起飞事件-----------------------------------------------
local CANT_TAGS = { "notarget", "INLIMBO" }
local ONEOF_TAGS = { "player", "monster", "scarytoprey" }
--local function ShouldFlyAway(inst)
--    -- 先检查是否有纳西妲在附近
--    local x, y, z = inst.Transform:GetWorldPosition()
--    local nahida_nearby = TheSim:FindEntities(x, y, z, inst.flyawaydistance, { TUNING.AVATAR_NAME })
--    if nahida_nearby and #nahida_nearby > 0 then
--        return false  -- 纳西妲在附近，不应该起飞
--    end
--    -- 原来的起飞逻辑
--    return not (inst.sg:HasStateTag("sleeping") or
--            inst.sg:HasStateTag("busy") or
--            inst.sg:HasStateTag("flight"))
--            and (TheWorld.state.isnight or
--            (inst.components.health ~= nil and inst.components.health.takingfiredamage and not (inst.components.burnable and inst.components.burnable:IsBurning())) or
--            FindEntity(inst, inst.flyawaydistance, nil, nil, CANT_TAGS, ONEOF_TAGS) ~= nil)
--end

AddStategraphPostInit('bird', function(sg)
    local old_flyaway = sg.events["flyaway"].fn
    sg.events["flyaway"].fn = function(inst, data, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local nahida_nearby = TheSim:FindEntities(x, y, z, 6, { TUNING.AVATAR_NAME })
        if nahida_nearby and #nahida_nearby > 0 then
            -- 纳西妲在附近，阻止起飞
            return
        end
        -- 否则执行原来的起飞逻辑
        return old_flyaway(inst, data, ...)
    end
end)
--------------------------------------------------------------------------------------
-----------------------------------在任何时候都可以刮牛毛，且不会被打---------------------------------------------------
AddPrefabPostInit("beefalo", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    -- 确保牛有可刮毛的组件
    if inst.components.beard then
        -- 修改刮毛的条件
        local original_can_shave = inst.components.beard.canshavetest
        inst.components.beard.canshavetest = function(inst, shaver, ...)
            -- 允许在白天刮毛，但只有具有特定标签的角色可以
            return shaver and shaver:HasTag(TUNING.AVATAR_NAME) or original_can_shave(inst, shaver, ...)
        end
    end
end)
-- 修改毛发组件
AddComponentPostInit("beard", function(self)
    local original_shave = self.Shave
    self.Shave = function(self, who, withwhat, ...)
        -- 如果玩家有特定标签，完全跳过所有检查
        if who and who:HasTag(TUNING.AVATAR_NAME) then
            if self.bits == 0 then
                return false, "NOBITS"
            end
            -- 完全重写刮毛逻辑，不调用原版方法
            local oldbits = self.bits
            local currentflag = true
            local daysback = 0
            -- 计算应该回退到哪一天
            for k = self.daysgrowth, 0, -1 do
                local cb = self.callbacks[k]
                if cb ~= nil then
                    if currentflag == true then
                        currentflag = false
                    else
                        cb(self.inst, self.skinname)
                        break
                    end
                end
                daysback = daysback + 1
            end
            self.daysgrowth = self.daysgrowth - daysback
            if self.daysgrowth <= 0 then
                self:Reset()
            end
            local dropbits = oldbits - self.bits
            -- 生成牛毛
            if self.prize ~= nil then
                for k = 1, dropbits do
                    local bit = SpawnPrefab(self.prize)
                    local x, y, z = self.inst.Transform:GetWorldPosition()
                    bit.Transform:SetPosition(x, y + 2, z)
                    local speed = 1 + math.random()
                    local angle = math.random() * TWOPI
                    bit.Physics:SetVel(speed * math.cos(angle), 2 + math.random() * 3, speed * math.sin(angle))
                end
            end
            if who == self.inst and who.components.sanity ~= nil then
                who.components.sanity:DoDelta(TUNING.SANITY_SMALL)
            end
            self:UpdateBeardInventory()
            self.inst:PushEvent("shaved")
            return true
        end
        -- 对于其他玩家，走原版逻辑（会调用 canshavetest）
        return original_shave(self, who, withwhat, ...)
    end
end)


--------------------------------------------------------------------------------------
-- 使用 AddComponentPostInit 来修改 thief 组件
AddComponentPostInit("thief", function(Thief)
    -- 保存原始的 StealItem 方法
    local oldStealItem = Thief.StealItem
    -- 重写 StealItem 方法
    function Thief:StealItem(victim, itemtosteal, attack)
        -- 检查受害者是否有 "no_steal" 标签
        if itemtosteal and itemtosteal:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NO_STEAL) then
            return false -- 如果物品有该标签，则不进行偷窃
        end
        if victim:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NO_STEAL) then
            return false -- 如果有该标签，则不进行偷窃
        end
        -- 否则调用原始的 StealItem 方法
        return oldStealItem(self, victim, itemtosteal, attack)
    end
end)
-------------------------------------------------------------------------------------------
for prefab, entry in pairs(TUNING.CHESSPIECE_ARRAY) do
    -- 添加雕塑标签
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_CHESSPIECE_TAG)
    end)
end

-----------------------------------------------------------------------------------------------------------------------------
------电羊靠近不逃跑
--判断是否该逃跑
local function ShouldRunAway(guy)
    return guy:HasTag("character") and (not guy:HasTag("notarget") and not guy:HasTag(TUNING.AVATAR_NAME))
end

local function MakeLightninggoatClosePlayer(brain)
    local sequenceGroup=nil
    for i,node in ipairs(brain.bt.root.children) do
        -- print("\t"..node.name.." > "..(node.children and node.children[1].name or ""))
        if node.name == "Sequence" and node.children[1].name == "FaceEntity" then
            if node.children[2].name == "RunAway" then
                sequenceGroup=node
            end
            break
        end
    end
    if not sequenceGroup then
        -- print("没拿到逃跑函数")
        return
    end
    sequenceGroup.children[2].hunterfn=ShouldRunAway
end

-- 电羊
AddBrainPostInit("lightninggoatbrain", MakeLightninggoatClosePlayer)

local BossLoot = {
    -- 巨鹿增加掉落物
    deerclops = {
        { prefab = "dst_gi_nahida_everfrost_ice_crystal", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 晶体独眼巨鹿
    mutateddeerclops = {
        { prefab = "dst_gi_nahida_everfrost_ice_crystal", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 附身座狼
    mutatedwarg = {
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 龙蝇
    dragonfly = {
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 熊獾
    bearger = {
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 熊獾
    mutatedbearger = {
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 麋鹿鹅
    moose = {
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 邪天翁
    malbatross = {
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 远古犀牛
    minotaur = {
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 梦魇疯猪
    daywalker = {
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 蜂王
    beequeen = {
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 蜂王
    antlion = {
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 天体英雄
    alterguardian_phase2 = {
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 织影者
    stalker_atrium = {
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
    -- 天体后裔
    alterguardian_phase4_lunarrift = {
        { prefab = "security_pulse_cage_blueprint", }, -- 火花炬蓝图
        { prefab = "moonstorm_static_item_blueprint", }, -- 约束静电蓝图
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
        { prefab = "dst_gi_nahida_growth_value", },
    },
}

for prefab, loots in pairs(BossLoot) do
    AddPrefabPostInit(prefab, function (inst)
        if inst.components.lootdropper then
            for _, loot in ipairs(loots) do
                inst.components.lootdropper:AddChanceLoot(loot.prefab, loot.chance or 1.0)
            end
        end
    end)
end
