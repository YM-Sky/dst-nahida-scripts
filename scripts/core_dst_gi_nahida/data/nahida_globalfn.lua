---
--- nahida_globalfn.lua
--- Description: 全局函数
--- Author: 没有小钱钱
--- Date: 2025/4/23 0:12
---
local exclude_tags = { "INLIMBO", "companion", "wall", "abigail", "player", "chester", "zhijiang_hound" }
--生成弹幕提示(玩家,提示类型,数值)
function SpawnNahidaTips(target, type, text)
    if text and target then
        local tips = SpawnPrefab("dst_gi_nahida_tips")
        local x, y, z = target.Transform:GetWorldPosition()

        -- 检查附近是否有其他tips，计算偏移
        local nearby_tips = TheSim:FindEntities(x, y, z, 3, {"dst_gi_nahida_tips"})
        local offset_y = 0
        local offset_x = 0

        -- 为每个tips添加偏移，避免重叠
        for i, existing_tip in ipairs(nearby_tips) do
            if existing_tip ~= tips and existing_tip:IsValid() then
                offset_y = offset_y + 1.5  -- 垂直偏移
                offset_x = offset_x + (math.random() - 0.5) * 2  -- 随机水平偏移
            end
        end

        tips.Transform:SetPosition(x + offset_x, y, z)
        tips:AddTag("dst_gi_nahida_tips")  -- 添加标签用于查找

        if tips.guid_tips_value then
            tips.guid_tips_value:set(json.encode({ type = type, text = text, offset_y = offset_y }))
        end
    end
end

function SpawnNhidaUuid()
    local seed = {'e','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'}
    local tb = {}
    for i = 1, 32 do
        table.insert(tb,seed[math.random(1,16)])
    end
    local sid = table.concat(tb)
    return string.format('%s-%s-%s-%s-%s',
            string.sub(sid,1,8),
            string.sub(sid,9,12),
            string.sub(sid,13,16),
            string.sub(sid,17,20),
            string.sub(sid,21,32)
    )
end

----是否是玩具
function NahidaIsTrinket(item)
    return item:HasTag("trinket") or item:HasTag("cattoy")
            or item.prefab == "antliontrinket" or item.prefab == "cotl_trinket"
end

local function GetEntityTags(ent)
    if ent and ent.entity then
        local str = ent.entity:GetDebugString()
        local tags_str = str:match("Tags: (.+)\nPrefab:")
        if tags_str then
            local tags = string.split(tags_str, " ")
            return tags
        end
    end
    return {}
end

function NahidaTryGrowthForEntities(entity,range)
    local GARDENING_CANT_TAGS = { "INLIMBO", "stump" }
    local GARDENING_ONEOF_TAGS = { "plant", "crop", "growable","barren","perennialcrop","perennialcrop2", "harvestable", "silviculture", "ancienttree" }
    local x, y, z = entity.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, range, nil, GARDENING_CANT_TAGS, GARDENING_ONEOF_TAGS)
    for _, ent in ipairs(ents) do
        if ent:IsValid() and not ent:IsInLimbo() then
            -- 处理惊喜种子的特殊催熟逻辑
            if ent:HasTag("leif") then
                ent.components.sleeper:GoToSleep(3000)
            elseif ent.prefab:find("ancienttree_") and ent.prefab:find("_sapling") then
                print(">>> 发现惊喜种子树苗:", ent.prefab)
                local growable = ent.components.growable
                if growable then
                    print("当前阶段:", growable.stage, "最大阶段:", #growable.stages)
                    -- 强制解除所有暂停原因
                    if growable.pausereasons then
                        for reason, _ in pairs(growable.pausereasons) do
                            growable:Resume(reason)
                            print("解除暂停原因:", reason)
                        end
                    end
                    -- 直接跳过魔法催熟，使用普通催熟
                    growable:DoGrowth()
                    print("使用普通催熟，催熟后阶段:", growable.stage)

                    -- 如果还是被暂停，再次强制解除并催熟
                    if growable.pausereasons and next(growable.pausereasons) then
                        print("检测到仍有暂停原因，再次强制解除")
                        for reason, _ in pairs(growable.pausereasons) do
                            growable:Resume(reason)
                        end
                        growable:DoGrowth()
                        print("二次催熟后阶段:", growable.stage)
                    end
                else
                    print("警告：惊喜种子树苗没有 growable 组件")
                end
            elseif ent.prefab:find("ancienttree_") and ent.components.pickable then
                print(">>> 发现成熟惊喜树:", ent.prefab)
                -- 处理成熟的惊喜种子树，让果实立即成熟
                if not ent.components.pickable:CanBePicked() then
                    -- 临时覆盖 CanRegenFruits 函数，强制允许结果
                    local old_CanRegenFruits = ent.CanRegenFruits
                    if old_CanRegenFruits then
                        ent.CanRegenFruits = function() return true end
                    end

                    -- 直接让果实成熟，跳过重生计时
                    ent.components.pickable:Regen()

                    -- 强制显示果实（针对夜视果实等特殊类型）
                    if ent.components.pickable.caninteractwith == false then
                        ent.components.pickable.caninteractwith = true
                        ent.AnimState:Show("fruit")
                        if ent.type == "nightvision" then
                            ent.AnimState:SetLightOverride(0.1)
                        end
                        ent._showing_fruits = true
                    end

                    -- 恢复原函数
                    if old_CanRegenFruits then
                        ent.CanRegenFruits = old_CanRegenFruits
                    end
                    print("惊喜树果实催熟完成")
                else
                    print("惊喜树果实已经成熟")
                end
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
    print("=== 催熟结束 ===")
end

function NhidaDropOneItemWithTag(inst)
    if inst.components.container then
        -- 要开启永不妥协
        if TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.UNCOMPROMISING_MODE then
            -- 重写DropOneItemWithTag函数来防止老鼠偷取
            local old_DropOneItemWithTag = inst.components.container.DropOneItemWithTag
            if old_DropOneItemWithTag then
                inst.components.container.DropOneItemWithTag = function(self, tag, drop_pos)
                    if self.inst:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NO_STEAL) then
                        -- 如果是老鼠在尝试偷取，就不让物品掉落
                        local x, y, z = inst:GetPosition():Get()
                        local rats = TheSim:FindEntities(x, y, z, 1, nil,nil,{"raidrat"})
                        if #rats > 0 then
                            -- 可以选择性地伤害或者驱赶老鼠
                            for _, rat in ipairs(rats) do
                                if rat.components.health then
                                    rat.components.health:Kill()  -- 伤害老鼠  -- 掉落物无用，就不击杀了
                                end
                            end
                            return
                        end
                    end
                    -- 如果不是老鼠，就使用原来的函数
                    return old_DropOneItemWithTag(self, tag, drop_pos)
                end
            end
        end
    end
end

---获取两点间的距离
---@param x1 number # A点x坐标
---@param z1 number # A点z坐标
---@param x2 number # B点x坐标
---@param z2 number # B点z坐标
---@param do_sqrt boolean|nil # 是否开平方
---@return number # 距离
---@nodiscard
local function calcDist(x1,z1,x2,z2,do_sqrt)
    -- @param: do_sqrt 是否开平方
    local dist = (x1-x2)^2+(z1-z2)^2
    if do_sqrt then dist = math.sqrt(dist) end
    return dist
end

---获取直线上的某个点P(向量AB 长度dist , 以A为起点)
---@param x1 number # 起点A的x坐标
---@param z1 number # 起点A的z坐标
---@param x2 number # 终点B的x坐标
---@param z2 number # 终点B的z坐标
---@param dist number # AB距离
---@param n number # 起点A到点P的距离
---@return number # 点P的x坐标
---@return number # 点P的z坐标
---@nodiscard
local function findPointOnLine(x1, z1, x2, z2, dist, n)
    -- 计算AB方向向量
    local dx = x2 - x1
    local dz = z2 - z1
    -- 标准化方向向量
    local norm_dx = dx / dist
    local norm_dz = dz / dist
    -- 计算点P的坐标
    local xp = x1 + n * norm_dx
    local zp = z1 + n * norm_dz
    return xp, zp
end

---comment
---@param missile ent # 导弹
---@param fn_when_hit fun(missile:ent,victim:ent) # 命中函数
function NahidaMissileLaunch(missile, fn_when_hit)
    local x, y, z = missile:GetPosition():Get()
    local best_target = nil
    local best_score = -99999  -- 分数越高越好

    local ents = TheSim:FindEntities(x, y or 0, z, 30, {'_combat','_health'}, exclude_tags)

    for _, v in pairs(ents) do
        if not v.components.health:IsDead() then
            local v_x, _, v_z = v:GetPosition():Get()
            local dist = calcDist(x, v_x, z, v_z, true)

            -- 获取目标生命值信息
            local current_health = v.components.health:GetPercent()  -- 生命值百分比
            local max_health = v.components.health.maxhealth or 100

            -- 计算综合评分 (距离越近分数越高，生命值越高分数越高)
            local distance_score = math.max(0, 30 - dist)  -- 距离分数：30分满分，距离越近分数越高
            local health_score = current_health * 0.7  -- 生命值分数：70分满分

            local total_score = distance_score + health_score

            if total_score > best_score then
                best_target = v
                best_score = total_score
            end
        end
    end

    if best_target then
        missile.task_period_missile_launch_to_enemy = missile:DoPeriodicTask(0, function()
            -- 目标消失
            if best_target == nil or (best_target ~= nil and not best_target:IsValid()) then
                if missile then
                    if missile.task_period_missile_launch_to_enemy ~= nil then
                        missile.task_period_missile_launch_to_enemy:Cancel()
                        missile.task_period_missile_launch_to_enemy = nil
                    end
                end
            end

            if missile then
                local tar_x, _, tar_z = best_target:GetPosition():Get()
                local m_x, _, m_z = missile:GetPosition():Get()
                missile:ForceFacePoint(tar_x, 0, tar_z)
                local dist = calcDist(tar_x, tar_z, m_x, m_z, true)

                -- 碰撞
                if dist <= 2 then
                    if fn_when_hit ~= nil then
                        fn_when_hit(missile, best_target)
                    end
                else
                    local des_x, des_z = findPointOnLine(m_x, m_z, tar_x, tar_z, dist, dist + 1)
                    missile.Transform:SetPosition(des_x, 0, des_z)
                end
            end
        end)
    end
end

-- 同步锚点数据的函数
function NahidaSyncWaypointsForPlayer(player)
    --if not player or not player.userid then
    --    return
    --end
    --local sync_waypoints_cd = player.sync_waypoints_cd
    --if sync_waypoints_cd == nil then
    --    sync_waypoints_cd = 0
    --end
    --if sync_waypoints_cd > 0 then
    --    if player.components.talker then
    --        player.components.talker:Say(string.format(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_ANIMAL_COOLING_TIME_CD, sync_waypoints_cd))
    --    end
    --    return
    --end
    --player.sync_waypoints_cd = 5
    --player.sync_waypoints_task_cd = player:DoPeriodicTask(1,function()
    --    player.sync_waypoints_cd =   player.sync_waypoints_cd - 1
    --    if player.sync_waypoints_cd <= 0 then
    --        player.sync_waypoints_task_cd:Cancel()
    --        player.sync_waypoints_task_cd = nil
    --    end
    --end)
    ---- 延迟确保玩家和HUD完全加载
    --player:DoTaskInTime(0.5, function()
    --    if not player:IsValid() then
    --        return
    --    end
    --    -- 重新同步所有锚点
    --    local waypoints = TheSim:FindEntities(0, 0, 0, 50000, {"dst_gi_nahida_teleport_waypoint"})
    --    print("找到锚点数量:", #waypoints)
    --    for i, waypoint in ipairs(waypoints) do
    --        if waypoint:IsValid() and waypoint.components.writeable then
    --            local x, y, z = waypoint.Transform:GetWorldPosition()
    --            local custom_info = waypoint.components.writeable:GetText()
    --            SendModRPCToClient(
    --                    GetClientModRPC("dst_gi_nahida_tp_core", "registerwaypoint"),
    --                    player.userid,
    --                    x, y, z,
    --                    waypoint.GUID,
    --                    custom_info
    --            )
    --            print("同步锚点:", waypoint.GUID, custom_info)
    --        end
    --    end
    --
    --    -- 触发地图刷新
    --    if player.HUD and player.HUD.minimap then
    --        player:DoTaskInTime(0.1, function()
    --            if player.HUD and player.HUD.minimap and player.HUD.minimap.MiniMap then
    --                player.HUD.minimap.MiniMap:RefreshMap()
    --                print("地图刷新完成")
    --            end
    --        end)
    --    end
    --end)
end
-- 保存纳西妲的全局数据
function OnSaveGlobalNahidaData(inst,isInit)
    --if inst.prefab ~= TUNING.MOD_ID then return end
    --if inst.userid and inst.components.dst_gi_nahida_data then
    --    local nahida_data = inst.components.dst_gi_nahida_data:getData()
    --    if GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_PLAYER[inst.userid] == nil then
    --        GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_PLAYER[inst.userid] = {}
    --    end
    --    if isInit and (nahida_data.nahida_fateseat_level > 0 or nahida_data.oversized_pick_num > 0 or nahida_data.farm_plant_pick_num > 0) then
    --        GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_PLAYER[inst.userid].nahida_data = nahida_data
    --    elseif isInit == false then
    --        GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_PLAYER[inst.userid].nahida_data = nahida_data
    --    end
    --end
end
-- 恢复纳西妲全局数据
function OnLoadGlobalNahidaData(inst)
    --if inst.prefab ~= TUNING.MOD_ID then return end
    --print("纳西妲加载数据"..inst.userid)
    --if inst.userid and inst.components.dst_gi_nahida_data then
    --    local user_data = GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_PLAYER[inst.userid]
    --    if user_data then
    --        --print("纳西妲加载数据"..inst.userid.."，加载完成："..json.encode(user_data))
    --        local nahida_data = user_data.nahida_data
    --        if nahida_data then
    --            inst.components.dst_gi_nahida_data:SaveData(nahida_data)
    --        end
    --    end
    --end
end

-- 保存法杖数据 dst_gi_nahida_weapon_staff_data.lua
function OnSaveGlobalWeaponStaffData(inst)
    --if inst.prefab ~= TUNING.MOD_ID then return end
    --if not inst.userid then return end
    --local staff = nil
    --if inst.components.inventory then
    --    -- 1. 优先查装备栏
    --    for k, v in pairs(EQUIPSLOTS) do
    --        local equip = inst.components.inventory:GetEquippedItem(v)
    --        if equip and equip.prefab == "dst_gi_nahida_weapon_staff" then
    --            staff = equip
    --            break
    --        end
    --    end
    --    -- 2. 如果装备栏没有，再查物品栏第一个
    --    if not staff then
    --        local items = inst.components.inventory:FindItems(function(item)
    --            return item.prefab == "dst_gi_nahida_weapon_staff"
    --        end)
    --        if #items > 0 then
    --            staff = items[1]
    --        end
    --    end
    --end
    --if staff and staff.components.dst_gi_nahida_weapon_staff_data then
    --    if GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_SEFF[inst.userid] == nil then
    --        GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_SEFF[inst.userid] = {}
    --    end
    --    GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_SEFF[inst.userid].nahida_weapon_staff_data = staff.components.dst_gi_nahida_weapon_staff_data:OnSave()
    --end
end
-- 恢复纳西妲全局法杖数据
function OnLoadGlobalWeaponStaffData(inst)
    --if inst.prefab ~= TUNING.MOD_ID then return end
    --if not inst.userid then return end
    --
    --local user_data = GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_SEFF[inst.userid]
    --if not user_data then return end
    --local saved_data = user_data.nahida_weapon_staff_data
    --if not saved_data then return end
    --
    --local staff = nil
    --if inst.components.inventory then
    --    -- 1. 优先查装备栏
    --    for k, v in pairs(EQUIPSLOTS) do
    --        local equip = inst.components.inventory:GetEquippedItem(v)
    --        if equip and equip.prefab == "dst_gi_nahida_weapon_staff" then
    --            staff = equip
    --            break
    --        end
    --    end
    --    -- 2. 如果装备栏没有，再查物品栏第一个
    --    if not staff then
    --        local items = inst.components.inventory:FindItems(function(item)
    --            return item.prefab == "dst_gi_nahida_weapon_staff"
    --        end)
    --        if #items > 0 then
    --            staff = items[1]
    --        end
    --    end
    --end
    --
    --if staff and staff.components.dst_gi_nahida_weapon_staff_data then
    --    staff.components.dst_gi_nahida_weapon_staff_data:SaveData(saved_data)
    --end
end

-- 保存纳西妲的全局背包数据
function OnSaveGlobalBackpackData(inst,target)
    --if inst.prefab ~= TUNING.MOD_ID then return end
    --if not inst.userid then return end
    --
    --local backpack = nil
    --local highest_level = 0
    --
    --if inst.components.inventory and (target == nil or not target:HasTag("dst_gi_nahida_dress")) then
    --    -- 1. 优先查装备栏
    --    local equipped = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK or EQUIPSLOTS.BODY)
    --    if equipped and (equipped.prefab == "dst_gi_nahida_dress" or
    --            equipped.prefab == "dst_gi_nahida_dress2" or
    --            equipped.prefab == "dst_gi_nahida_dress3") then
    --        backpack = equipped
    --    end
    --
    --    -- 2. 如果装备栏没有，再查物品栏等级最高的
    --    if not backpack then
    --        local items = inst.components.inventory:FindItems(function(item)
    --            return item.prefab == "dst_gi_nahida_dress" or
    --                    item.prefab == "dst_gi_nahida_dress2" or
    --                    item.prefab == "dst_gi_nahida_dress3"
    --        end)
    --
    --        for _, item in ipairs(items) do
    --            local level = 1
    --            if item.prefab == "dst_gi_nahida_dress2" then
    --                level = 2
    --            elseif item.prefab == "dst_gi_nahida_dress3" then
    --                level = 3
    --            end
    --
    --            if level > highest_level then
    --                highest_level = level
    --                backpack = item
    --            end
    --        end
    --    end
    --else
    --    backpack = target
    --end
    --
    ---- 初始化表结构
    --if GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_BACKPACK[inst.userid] == nil then
    --    GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_BACKPACK[inst.userid] = {}
    --end
    --
    ---- 保存背包数据
    --if backpack and backpack.components.dst_gi_nahida_backpack_data and
    --        backpack.components.dst_gi_nahida_ice_box_data then
    --    GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_BACKPACK[inst.userid].backpack_data = backpack.components.dst_gi_nahida_backpack_data:getData()
    --    GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_BACKPACK[inst.userid].ice_box_data = backpack.components.dst_gi_nahida_ice_box_data:getData()
    --    GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_BACKPACK[inst.userid].backpack_prefab = backpack.prefab
    --end
end
-- 恢复纳西妲全局背包数据
function OnLoadGlobalBackpackData(inst)
    --if inst.prefab ~= TUNING.MOD_ID then return end
    --if not inst.userid then return end
    --
    --local user_data = GLOBAL.MOD_DST_GI_NAHIDA.NAHIDA_BACKPACK[inst.userid]
    --if not user_data or not user_data.backpack_data or not user_data.ice_box_data then return end
    --
    --local backpack = nil
    --local highest_level = 0
    --
    --if inst.components.inventory then
    --    -- 1. 优先查装备栏
    --    local equipped = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK or EQUIPSLOTS.BODY)
    --    if equipped and (equipped.prefab == "dst_gi_nahida_dress" or
    --            equipped.prefab == "dst_gi_nahida_dress2" or
    --            equipped.prefab == "dst_gi_nahida_dress3") then
    --        backpack = equipped
    --    end
    --
    --    -- 2. 如果装备栏没有，再查物品栏等级最高的
    --    if not backpack then
    --        local items = inst.components.inventory:FindItems(function(item)
    --            return item.prefab == "dst_gi_nahida_dress" or
    --                    item.prefab == "dst_gi_nahida_dress2" or
    --                    item.prefab == "dst_gi_nahida_dress3"
    --        end)
    --
    --        for _, item in ipairs(items) do
    --            local level = 1
    --            if item.prefab == "dst_gi_nahida_dress2" then
    --                level = 2
    --            elseif item.prefab == "dst_gi_nahida_dress3" then
    --                level = 3
    --            end
    --
    --            if level > highest_level then
    --                highest_level = level
    --                backpack = item
    --            end
    --        end
    --    end
    --end
    --
    ---- 恢复背包数据
    --if backpack and backpack.components.dst_gi_nahida_backpack_data and
    --        backpack.components.dst_gi_nahida_ice_box_data then
    --    backpack.components.dst_gi_nahida_backpack_data:SaveData(user_data.backpack_data)
    --    backpack.components.dst_gi_nahida_ice_box_data:SaveData(user_data.ice_box_data)
    --end
end

-- 注册传送锚点到服务端
function NahidaRegisterWaypoint(inst,x,y,z,info)
    if TheWorld.net and TheWorld.net.components and TheWorld.net.components.dst_gi_nahida_registered_waypoint then
        TheWorld.net.components.dst_gi_nahida_registered_waypoint:registered(inst,x,y,z,info)
        --print("999检查TheWorld.net.replica.dst_gi_nahida_registered_waypoint 是否存在"..tostring(   TheWorld.net.replica.dst_gi_nahida_registered_waypoint ~= nil))
    else
        print("错误：找不到dst_gi_nahida_registered_waypoint组件")
    end
end

-- 销毁传送锚点
function NahidaUnRegisterWaypoint(inst)
    if TheWorld.net and TheWorld.net.components and TheWorld.net.components.dst_gi_nahida_registered_waypoint then
        TheWorld.net.components.dst_gi_nahida_registered_waypoint:UnRegisterWaypoint(inst)
    else
        print("错误：找不到dst_gi_nahida_registered_waypoint组件")
    end
end

function AddDstGiNahidaElementalReactionComponents(inst, target)
    if target.components.dst_gi_nahida_elemental_reaction == nil then
        target:AddComponent("dst_gi_nahida_elemental_reaction") -- 添加当前状态组件
    end
    if target.components.dst_gi_nahida_elemental_reaction then
        -- 初始化组件默认方法
        target.components.dst_gi_nahida_elemental_reaction:InitComponents(target)
    end
end

-- 获取物品在物品栏中的槽位
function GetItemSlotPosition(player, item)
    if not player or not item or not player.components.inventory then
        return nil
    end
    local inventory = player.components.inventory
    for slot, slot_item in pairs(inventory.itemslots) do
        if slot_item == item then
            return slot
        end
    end
    return nil
end

function PrintContainerItems(inst)
    print("==== 开始检查容器 ====")
    print("inst:", tostring(inst))
    print("inst.prefab:", inst and inst.prefab or "nil")

    if inst == nil then
        print("错误：inst 为 nil")
        return
    end

    if inst.components == nil then
        print("错误：inst.components 为 nil")
        return
    end

    if inst.components.container == nil then
        print("错误：inst.components.container 为 nil")
        return
    end

    local container = inst.components.container
    print("容器槽位数:", container.numslots)
    print("容器slots:", tostring(container.slots))

    if container.slots == nil then
        print("错误：container.slots 为 nil")
        return
    end

    print("==== 容器物品分布 ====")
    for idx = 1, container.numslots do
        local item = container.slots[idx]
        if item then
            print(string.format("格子%d: %s x%d", idx, item.prefab, item.components.stackable and item.components.stackable:StackSize() or 1))
        else
            print(string.format("格子%d: 空", idx))
        end
    end
    print("==== 结束 ====")
end

function NahidaOnAttackFn(inst,pos,radius,fn)
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, radius or 15, { "_combat" }, exclude_tags)
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
                AddDstGiNahidaElementalReactionComponents(inst,ent)
                if fn then
                    fn(ent)
                end
            end
        end
    end
end

function NahidaOnPlayerAttackFn(inst,pos,radius,fn)
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, radius or 15, { "player" }, nil)
    for i, ent in ipairs(ents) do
        -- 有follower组件且leader是玩家，视为友好 and ent.components.follower and ent.components.follower.leader == nil
        if ent ~= nil and ent:IsValid() and ent.components.health and not ent.components.health:IsDead() then
            if fn then
                fn(ent)
            end
        end
    end
end

local rock_table = {
    "rock1",
    "rock2",
    "rock_flintless",
    "rock_flintless_med",
    "rock_flintless_low",
    "rock_moon",
    "rock_moon_shell",
    "moonglass_rock",
    "rock_petrified_tree",
    "rock_petrified_tree_med",
    "rock_petrified_tree_tall",
    "rock_petrified_tree_short",
    "rock_petrified_tree_old",
    "ruins_statue_mage",
    "ruins_statue_mage_nogem",
    "ruins_statue_head",
    "ruins_statue_head_nogem",
    "cave_entrance",
    "saltstack",
    "spiderhole",
    "spiderhole_rock",
    "stalagmite",
    "stalagmite_full",
    "stalagmite_med",
    "stalagmite_low",
    "stalagmite_tall",
    "stalagmite_tall_full",
    "stalagmite_tall_med",
    "stalagmite_tall_low",
    "archive_moon_statue",
    "seastack",
    "rock_avocado_fruit",
}

-- 将数组转换为哈希表，提高查找效率
local rock_set = {}
for _, rock_name in ipairs(rock_table) do
    rock_set[rock_name] = true
end

function NahidaOnFindRocksFn(inst, pos, radius, fn)
    -- 使用 "boulder" 标签直接查找所有石头类物品
    local rocks = TheSim:FindEntities(pos.x, pos.y, pos.z, radius or 15, {"dst_gi_nahida_rocks"})
    for i, rock in ipairs(rocks) do
        if rock ~= nil and rock:IsValid() then
            -- 双重保险：既要有 boulder 标签，又要在白名单中
            if rock_set[rock.prefab] then
                if fn then
                    fn(rock)
                end
            end
        end
    end
end

local WORK_ACTIONS =
{
    CHOP = true,
    DIG = true,
    HAMMER = true,
    MINE = true,
}
local TARGET_TAGS = {}
for k, v in pairs(WORK_ACTIONS) do
    table.insert(TARGET_TAGS, k.."_workable")
end
function NahidaOnFindTreeFn(inst, pos, radius, fn)
    -- 使用 "tree" 标签直接查找所有石头类物品
    local trees = TheSim:FindEntities(pos.x, pos.y, pos.z, radius, {"tree"}, nil, TARGET_TAGS)
    for i, tree in ipairs(trees) do
        if tree ~= nil and tree:IsValid() then
            if fn then
                fn(tree)
            end
        end
    end
end

GLOBAL.SpawnNahidaTips = SpawnNahidaTips --生成弹幕提示(玩家,提示类型,数值)
GLOBAL.SpawnNhidaUuid = SpawnNhidaUuid --生成UUID
GLOBAL.NahidaIsTrinket = NahidaIsTrinket --是否是玩具
GLOBAL.NahidaTryGrowthForEntities = NahidaTryGrowthForEntities --催熟方法
GLOBAL.NhidaDropOneItemWithTag = NhidaDropOneItemWithTag --防止永不妥协老鼠偷东西
GLOBAL.NahidaMissileLaunch = NahidaMissileLaunch -- 导弹追踪
GLOBAL.NahidaSyncWaypointsForPlayer = NahidaSyncWaypointsForPlayer -- 同步玩家传啥锚点
GLOBAL.OnSaveGlobalNahidaData = OnSaveGlobalNahidaData -- 全局保存纳西妲数据
GLOBAL.OnLoadGlobalNahidaData = OnLoadGlobalNahidaData -- 全局加载纳西妲数据
GLOBAL.OnSaveGlobalWeaponStaffData = OnSaveGlobalWeaponStaffData -- 保存法杖数据
GLOBAL.OnLoadGlobalWeaponStaffData = OnLoadGlobalWeaponStaffData -- 恢复纳西妲全局法杖数据
GLOBAL.OnSaveGlobalBackpackData = OnSaveGlobalBackpackData -- 保存纳西妲的全局背包数据
GLOBAL.OnLoadGlobalBackpackData = OnLoadGlobalBackpackData -- 恢复纳西妲全局背包数据
GLOBAL.NahidaUnRegisterWaypoint = NahidaUnRegisterWaypoint -- 销毁传送锚点
GLOBAL.NahidaRegisterWaypoint = NahidaRegisterWaypoint -- 注册传送锚点到全局
GLOBAL.AddDstGiNahidaElementalReactionComponents = AddDstGiNahidaElementalReactionComponents -- 添加元素组件
GLOBAL.GetItemSlotPosition = GetItemSlotPosition -- 技能结束时恢复视角
GLOBAL.PrintContainerItems = PrintContainerItems -- 打印容器物品
GLOBAL.NahidaOnAttackFn = NahidaOnAttackFn -- 范围攻击方法
GLOBAL.NahidaOnPlayerAttackFn = NahidaOnPlayerAttackFn -- 范围攻击玩家方法
GLOBAL.NahidaOnFindRocksFn = NahidaOnFindRocksFn -- 寻找岩石相关的方法
GLOBAL.NahidaOnFindTreeFn = NahidaOnFindTreeFn -- 寻找树石相关的方法