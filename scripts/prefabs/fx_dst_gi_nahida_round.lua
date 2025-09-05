---
--- fx_dst_gi_nahida_round.lua
--- Description: 
--- Author: 旅行者
--- Date: 2025/8/24 2:54
---
-- 定义动画和资源
local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_round.zip")
}

local SMASHABLE_WORK_ACTIONS =
{
    CHOP = true,
    DIG = true,
    HAMMER = true,
    MINE = true,
}


local function SetDuration(inst,duration)
    inst.duration = duration
end
local function SetRange(inst,radius)
    inst.radius = radius
end

local function SetOnAttack(inst,onattack)
    inst.onattack = onattack
end

local function rockAttack(inst,point,x, y, z)
    local meteor = SpawnPrefab("dst_gi_nahida_shadowmeteor")  -- 改为 SpawnPrefab
    if meteor then
        meteor.Transform:SetPosition(point.x, 0, point.z)
        inst:DoTaskInTime(0.5,function()
            NahidaOnFindRocksFn(inst,Vector3(x, y, z),inst.radius,function(rock)
                if rock.components.workable and rock.components.workable:CanBeWorked() and not (rock.sg ~= nil and rock.sg:HasStateTag("busy")) then
                    local work_action = rock.components.workable:GetWorkAction()
                    if ((work_action == nil and rock:HasTag("NPC_workable")) or
                            (work_action ~= nil and SMASHABLE_WORK_ACTIONS[work_action.id]) ) and
                            (work_action ~= ACTIONS.DIG
                                    or (rock.components.spawner == nil and
                                    rock.components.childspawner == nil)) then

                        if rock.components.lootdropper == nil then
                            -- 添加lootdropper组件
                            rock:AddComponent("lootdropper")
                        end
                        local loots = {
                            {prefab = "goldnugget", chance = 1}, -- 金子
                            {prefab = "goldnugget", chance = 1}, -- 金子
                            {prefab = "redgem", chance = 0.05, is_gem = true}, -- 红宝石
                            {prefab = "bluegem", chance = 0.05, is_gem = true}, -- 蓝宝石
                            {prefab = "purplegem", chance = 0.05, is_gem = true}, -- 紫宝石
                            {prefab = "thulecite", chance = 0.05}, -- 铥矿
                            {prefab = "greengem", chance = 0.01, is_gem = true}, -- 绿宝石
                            {prefab = "orangegem", chance = 0.01, is_gem = true}, -- 橙宝石
                            {prefab = "yellowgem", chance = 0.01, is_gem = true}, -- 黄宝石
                            {prefab = "opalpreciousgem", chance = 0.01, is_gem = true}, -- 彩虹宝石
                        }
                        -- 分离宝石和非宝石
                        local gem_loots = {}
                        local other_loots = {}

                        for k, loot in ipairs(loots) do
                            if loot.is_gem then
                                table.insert(gem_loots, loot)
                            else
                                table.insert(other_loots, loot)
                            end
                        end
                        -- 随机选择2个宝石
                        local selected_gems = {}
                        if #gem_loots >= 2 then
                            local indices = {}
                            for i = 1, #gem_loots do
                                table.insert(indices, i)
                            end
                            -- 随机打乱索引
                            for i = #indices, 2, -1 do
                                local j = math.random(i)
                                indices[i], indices[j] = indices[j], indices[i]
                            end
                            -- 选择前2个
                            for i = 1, 2 do
                                table.insert(selected_gems, gem_loots[indices[i]])
                            end
                        else
                            -- 如果宝石不足2个，则全部选择
                            selected_gems = gem_loots
                        end
                        if rock.prefab ~= "rock_avocado_fruit" then
                            if rock.addLoot == nil or rock.addLoot == false then
                                -- 添加非宝石战利品
                                for k, loot in ipairs(other_loots) do
                                    rock.components.lootdropper:AddChanceLoot(loot.prefab, loot.chance)
                                end
                                -- 添加随机选择的宝石
                                for k, loot in ipairs(selected_gems) do
                                    rock.components.lootdropper:AddChanceLoot(loot.prefab, loot.chance)
                                end
                                rock.addLoot = true
                            end
                        end
                        rock.components.workable:WorkedBy(inst, 20)
                    end
                end
            end)
        end)
    end
end

local function windAttack(inst,x, y, z)
    inst:DoTaskInTime(0.5,function()
        NahidaOnFindTreeFn(inst,Vector3(x, y, z),inst.radius,function(tree)
            if tree:HasTag("tree") and tree.components.workable ~= nil and
                    tree.components.workable:CanBeWorked() and
                    tree.components.workable:GetWorkAction() and
                    SMASHABLE_WORK_ACTIONS[tree.components.workable:GetWorkAction().id] then
                SpawnPrefab("collapse_small").Transform:SetPosition(tree.Transform:GetWorldPosition())
                tree.components.workable:WorkedBy(inst, 20)
                --tree.components.workable:Destroy(inst)
            end
        end)
    end)
end

local function InitTask(inst,element_type)
    print("element_type:"..tostring(element_type))
    if inst.duration and inst.duration > 0 then
        inst:DoTaskInTime(inst.duration,function()
            inst:PushEvent("remove")
            if inst.task ~= nil then
                inst.task:Cancel()
                inst.task = nil
            end
            inst:Remove()
        end)
    end
    local newDuration = inst.duration
    if inst.onattack then
        inst.task = inst:DoPeriodicTask(1,function()
            newDuration = newDuration - 1
            local x, y, z = inst.Transform:GetWorldPosition()
            local count = 15
            if element_type == TUNING.ELEMENTAL_TYPE.ROCK then
                count = 8
            elseif element_type == TUNING.ELEMENTAL_TYPE.WIND then
                count = 2
                windAttack(inst,x, y, z)
            end
            local points = Shapes.GetRandomCircleLocations(Vector3(x, y, z), inst.radius, count, 4)
            -- 在每个点位置做些什么
            for _, point in ipairs(points) do
                if element_type == TUNING.ELEMENTAL_TYPE.THUNDER then
                    local fx = SpawnPrefab("lightning")
                    fx.Transform:SetPosition(point.x, 0, point.z)
                elseif element_type == TUNING.ELEMENTAL_TYPE.ROCK then
                    rockAttack(inst,point,x,y,z)
                elseif element_type == TUNING.ELEMENTAL_TYPE.WIND then
                    local tornado = SpawnPrefab("tornado")  -- 改为 SpawnPrefab
                    tornado:SetStateGraph("SGDstGiNahidaTornado")
                    tornado.Transform:SetPosition(x, y, z)
                    Shapes.MakeCircle(inst,tornado,{radius = 2})
                    tornado:DoTaskInTime(newDuration,function()
                        tornado:Remove()
                    end)
                end
            end
            NahidaOnAttackFn(inst, Vector3(x, y, z),inst.radius or 8,inst.onattack)
        end)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag('NOCLICK')
    inst:AddTag('NOBLOCK')

    -- 设置第一个动画
    inst.AnimState:SetBuild("dst_gi_nahida_round")
    inst.AnimState:SetBank("dst_gi_nahida_round")
    inst.AnimState:PlayAnimation("idle",true)
    inst.Transform:SetScale(1.6, 1.6, 1.6)
    -- 设置固定朝向
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    -- 设置渲染层和排序顺序
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(0)  -- 数字越小，越靠近地面
    -- 设置实体为原始状态
    inst.entity:SetPristine()

    -- 如果不是主服务器，直接返回实体
    if not TheWorld.ismastersim then
        return inst
    end
    inst.SetDuration = SetDuration
    inst.SetRange = SetRange
    inst.SetOnAttack = SetOnAttack
    inst.InitTask = InitTask

    inst.OnLoad = function(data)
        if inst.task == nil then
            inst:Remove()
        end
    end

    return inst
end

return Prefab("fx_dst_gi_nahida_round", fn, assets)