---
--- dst_gi_nahida_shipwrecked_boat.lua
--- Description: 海难小船
--- Author: 没有小钱钱
--- Date: 2025/8/29 15:57
---
local armouredboat_assets = {
    Asset("ANIM", "anim/rowboat_basic.zip"),
    Asset("ANIM", "anim/rowboat_armored_build.zip"),
    Asset("ANIM", "anim/swap_sail.zip"),
    Asset("ANIM", "anim/swap_lantern_boat.zip"),
    Asset("ANIM", "anim/boat_hud_row.zip"),

    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_shipwrecked_boat.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_shipwrecked_boat.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_shipwrecked_boat2.xml"),
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_shipwrecked_boat2.tex"),
}

local prefabs = {
    "shipwrecked_boat_player_collision"
}

local sounds = {
    place = "turnoftides/common/together/boat/place",
    creak = "turnoftides/common/together/boat/creak",
    damage = "turnoftides/common/together/boat/damage",
    sink = "turnoftides/common/together/boat/sink",
    hit = "turnoftides/common/together/boat/hit",
    thunk = "turnoftides/common/together/boat/thunk",
    movement = "turnoftides/common/together/boat/movement",
}

local BOAT_COLLISION_SEGMENT_COUNT = 20

local BOATBUMPER_MUST_TAGS = { "boatbumper" }

local RADIUS = 1.5 --太大会导致很容易拉着海带跑来跑去玩家还够不着，太小会导致玩家跳不上去
local COLLISION_RADIUS = 1 --太大会导致很容易拉着海带跑来跑去玩家还够不着，太小会导致玩家跳不上去
local exclude_tags = { "INLIMBO", "companion", "wall", "abigail", "player", "chester", "zhijiang_hound" }

local function ReticuleTargetFn(inst)
    local dir = Vector3(
            TheInput:GetAnalogControlValue(CONTROL_MOVE_RIGHT) - TheInput:GetAnalogControlValue(CONTROL_MOVE_LEFT),
            0,
            TheInput:GetAnalogControlValue(CONTROL_MOVE_UP) - TheInput:GetAnalogControlValue(CONTROL_MOVE_DOWN)
    )
    local deadzone = TUNING.CONTROLLER_DEADZONE_RADIUS

    if math.abs(dir.x) >= deadzone or math.abs(dir.z) >= deadzone then
        dir = dir:GetNormalized()

        inst.lastreticuleangle = dir
    elseif inst.lastreticuleangle ~= nil then
        dir = inst.lastreticuleangle
    else
        return nil
    end

    local Camangle = TheCamera:GetHeading() / 180
    local theta = -PI * (0.5 - Camangle)
    local sintheta, costheta = math.sin(theta), math.cos(theta)

    local newx = dir.x * costheta - dir.z * sintheta
    local newz = dir.x * sintheta + dir.z * costheta

    local range = 7
    local pos = inst:GetPosition()
    pos.x = pos.x - (newx * range)
    pos.z = pos.z - (newz * range)

    return pos
end

local function on_start_steering(inst, player)
    if inst.is_steering or inst.cooldown_timer ~= nil then
        -- 如果正在操作或冷却中，拒绝新的操作请求
        return
    end
    inst.current_steering_player = player
    inst.is_steering = true
    if ThePlayer and ThePlayer.components.playercontroller ~= nil and ThePlayer.components.playercontroller.isclientcontrollerattached then
        inst.components.reticule:CreateReticule()
    end
end

local function on_stop_steering(inst)
    if inst.is_steering then
        inst.is_steering = false
        inst.current_steering_player = nil
        if ThePlayer and ThePlayer.components.playercontroller ~= nil and ThePlayer.components.playercontroller.isclientcontrollerattached then
            inst.lastreticuleangle = nil
            inst.components.reticule:DestroyReticule()
        end
        -- 启动5秒冷却计时器
        inst.cooldown_timer = inst:DoTaskInTime(5, function()
            inst.cooldown_timer = nil
        end)
    end
end

local function OnEntityReplicated(inst)
    --Use this setting because we can rotate, and we are not billboarded with discreet anim facings
    --NOTE: this setting can only be applied after entity replicated
    inst.Transform:SetInterpolateRotation(true)
end

local function StopBoatPhysics(inst)
    --Boats currently need to not go to sleep because
    --constraints will cause a crash if either the target object or the source object is removed from the physics world
    inst.Physics:SetDontRemoveOnSleep(false)
end

local function StartBoatPhysics(inst)
    inst.Physics:SetDontRemoveOnSleep(true)
end

local function OnPhysicsWake(inst)
    if inst.stopupdatingtask then
        inst.stopupdatingtask:Cancel()
        inst.stopupdatingtask = nil
    else
        inst.components.walkableplatform:StartUpdating()
    end
    inst.components.boatphysics:StartUpdating()
end

local function physicssleep_stopupdating(inst)
    inst.components.walkableplatform:StopUpdating()
    inst.stopupdatingtask = nil
end

local function OnPhysicsSleep(inst)
    inst.stopupdatingtask = inst:DoTaskInTime(1, physicssleep_stopupdating)
    inst.components.boatphysics:StopUpdating()
end

local function empty_loot_function()
end

local function InstantlyBreakBoat(inst)
    -- This is not for SGboat but is for safety on physics.
    if inst.components.boatphysics then
        inst.components.boatphysics:SetHalting(true)
    end
    --Keep this in sync with SGboat.
    for entity_on_platform in pairs(inst.components.walkableplatform:GetEntitiesOnPlatform()) do
        entity_on_platform:PushEvent("abandon_ship")
    end
    for player_on_platform in pairs(inst.components.walkableplatform:GetPlayersOnPlatform()) do
        player_on_platform:PushEvent("onpresink")
    end
    inst:sinkloot()
    if inst.postsinkfn then
        inst:postsinkfn()
    end
    inst:Remove()
end

local function GetSafePhysicsRadius(inst)
    return RADIUS + 0.18 -- Add a small offset for item overhangs.
end

local function SpawnFragment(lp, prefix, offset_x, offset_y, offset_z, ignite)
    local fragment = SpawnPrefab(prefix)
    fragment.Transform:SetPosition(lp.x + offset_x, lp.y + offset_y, lp.z + offset_z)

    if offset_y > 0 and fragment.Physics then
        fragment.Physics:SetVel(0, -0.25, 0)
    end

    if ignite and fragment.components.burnable then
        fragment.components.burnable:Ignite()
    end

    return fragment
end

local function IsBoatEdgeOverLand(inst, override_position_pt)
    local map = TheWorld.Map
    local radius = inst:GetSafePhysicsRadius()
    local segment_count = BOAT_COLLISION_SEGMENT_COUNT * 2
    local segment_span = TWOPI / segment_count
    local x, y, z
    if override_position_pt then
        x, y, z = override_position_pt:Get()
    else
        x, y, z = inst.Transform:GetWorldPosition()
    end
    for segement_idx = 0, segment_count do
        local angle = segement_idx * segment_span

        local angle0 = angle - segment_span / 2
        local x0 = math.cos(angle0) * radius
        local z0 = math.sin(angle0) * radius
        if not map:IsOceanTileAtPoint(x + x0, 0, z + z0) or map:IsVisualGroundAtPoint(x + x0, 0, z + z0) then
            return true
        end

        local angle1 = angle + segment_span / 2
        local x1 = math.cos(angle1) * radius
        local z1 = math.sin(angle1) * radius
        if not map:IsOceanTileAtPoint(x + x1, 0, z + z1) or map:IsVisualGroundAtPoint(x + x1, 0, z + z1) then
            return true
        end
    end

    return false
end

local function OnLoadPostPass(inst)
    local boatring = inst.components.boatring
    if not boatring then
        return
    end

    -- If cannons and bumpers are on a boat, we need to rotate them to account for the boat's rotation
    local x, y, z = inst.Transform:GetWorldPosition()

    -- Bumpers
    local bumpers = TheSim:FindEntities(x, y, z, boatring:GetRadius(), BOATBUMPER_MUST_TAGS)
    for _, bumper in ipairs(bumpers) do
        -- Add to boat bumper list for future reference
        table.insert(boatring.boatbumpers, bumper)

        local bumperpos = bumper:GetPosition()
        local angle = GetAngleFromBoat(inst, bumperpos.x, bumperpos.z) / DEGREES

        -- Need to further rotate the bumpers to account for the boat's rotation
        bumper.Transform:SetRotation(-angle + 90)
    end
end

local function OnPhysicsCollision(inst, other)
    if other and other:IsValid() then
        -- 安全反弹逻辑
        if inst.Physics and inst.Physics:IsActive() then
            local vel_x, vel_y, vel_z = inst.Physics:GetVelocity()
            if vel_x and vel_z then
                inst.Physics:SetVel(-vel_x * 0.3, 0, -vel_z * 0.3) -- 减弱反弹力度
            end
        end
        -- 替换无效的音效路径
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/ground_break")
        SendModRPCToServer(GetModRPC("dst_gi_nahida_worked_by", "worked_by"), other)
    end
end

local function onopen(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function onclose(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end

local function BoatSalvage(inst, data)
    if inst.BoatSalvageCd and inst.BoatSalvageCd > 0 then
        if data and data.doer then
            if data.doer.components.talker then
                data.doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SALVAGE_ING)
            end
        end
        return
    end
    inst.BoatSalvageCd = 10
    inst.SoundEmitter:PlaySound("hookline_2/common/boat_winch/lower_LP", "mooring")
    inst:DoTaskInTime(3, function()
        inst.BoatSalvageCd = 0
        inst.SoundEmitter:KillSound("mooring")
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 2, nil, nil, { "dst_gi_nahida_sunkenchest", "nahida_salvage_item", "dst_gi_nahida_oceantreenut" })
        if #ents > 0 then
            local ent = ents[1]
            if ent then
                TheWorld:PushEvent("CHEVO_heavyobject_winched", { target = ent, doer = data and data.doer or nil })
                if ent:HasTag("dst_gi_nahida_sunkenchest") then
                    local sunkenchest_item = SpawnPrefab("dst_gi_nahida_sunkenchest_item")  -- 暂时使用原版的树作为种植后的物品
                    if sunkenchest_item ~= nil then
                        if sunkenchest_item.components.dst_gi_nahida_sunkenchest_item_data then
                            sunkenchest_item.components.dst_gi_nahida_sunkenchest_item_data:SaveSunkenChest(ent)
                        end
                        if inst.components.container then
                            inst.components.container:GiveItem(sunkenchest_item)
                            ent:Remove()  -- 移除树苗物品
                        end
                    end
                elseif ent:HasTag("nahida_salvage_item") then
                    local item = SpawnPrefab(ent.prefab)
                    if data.doer and item then
                        if ent.components.container and item.components.container then
                            local items = ent.components.container:GetAllItems()
                            if #items > 0 then
                                for _, _item in ipairs(items) do
                                    item.components.container:GiveItem(_item)
                                end
                            end
                        end
                        local x1, y1, z1 = data.doer.Transform:GetWorldPosition()
                        item.Transform:SetPosition(x1 + 1, y1, z1 + 1)  -- 使用 x 轴偏移
                        ent:Remove()  -- 移除树苗物品
                    end
                elseif ent:HasTag("dst_gi_nahida_oceantreenut") then
                    local oceantreenut_item = SpawnPrefab("dst_nahida_oceantreenut_item")  -- 暂时使用原版的树作为种植后的物品
                    if oceantreenut_item ~= nil then
                        if inst.components.container then
                            inst.components.container:GiveItem(oceantreenut_item)
                            ent:Remove()  -- 移除树苗物品
                        end
                    end
                end
            end
        end
    end)
end

local function MakeBoat(name, bank, build, data)
    return function()
        data = data or {}

        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()

        inst.Transform:SetFourFaced()

        --if data.minimap then
        --    inst.entity:AddMiniMapEntity()
        --    inst.MiniMapEntity:SetIcon(data.minimap)
        --    inst.MiniMapEntity:SetPriority(-1)
        --end
        inst.entity:AddNetwork()

        inst:AddTag("shipwrecked_boat") --小船专属标签
        inst:AddTag("dst_gi_nahida_shipwrecked_boat") --小船专属标签
        inst:AddTag("ignorewalkableplatforms")
        inst:AddTag("antlion_sinkhole_blocker")
        inst:AddTag("boat")
        inst:AddTag("wood")

        -- 物理设置（关键修改）
        -- 物理设置
        local phys = inst.entity:AddPhysics()
        phys:SetMass(TUNING.BOAT.MASS)
        phys:SetFriction(0)
        phys:SetDamping(2)  -- 降低阻尼
        phys:SetCollisionGroup(COLLISION.OBSTACLES)
        phys:ClearCollisionMask()
        phys:CollidesWith(COLLISION.WORLD)
        phys:CollidesWith(COLLISION.OBSTACLES)
        phys:CollidesWith(COLLISION.SMALLOBSTACLES)
        phys:SetCylinder(RADIUS, 1.0)
        phys:SetCollisionCallback(OnPhysicsCollision)  -- 绑定碰撞回调

        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("run_loop", true)
        inst.AnimState:SetSortOrder(ANIM_SORT_ORDER.OCEAN_BOAT)
        inst.AnimState:SetFinalOffset(1)
        -- inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)

        inst:AddComponent("walkableplatform")
        inst.components.walkableplatform.platform_radius = RADIUS
        --生成一圈碰撞墙，防止玩家上船的时候跳过头直接跳海里了
        inst.components.walkableplatform.player_collision_prefab = "shipwrecked_boat_player_collision"

        inst:AddComponent("healthsyncer")
        inst.components.healthsyncer.max_health = data.health or TUNING.BOAT.HEALTH

        inst:AddComponent("waterphysics")
        inst.components.waterphysics.restitution = 0.75

        local reticule = inst:AddComponent("reticule")
        reticule.targetfn = ReticuleTargetFn
        reticule.ispassableatallpoints = true

        local boatringdata = inst:AddComponent("boatringdata")
        boatringdata:SetRadius(RADIUS)
        boatringdata:SetNumSegments(RADIUS * 2)

        inst.current_steering_player = nil  -- 当前操作者
        inst.is_steering = false            -- 是否正在操作
        inst.cooldown_timer = nil           -- 冷却计时器
        inst.on_start_steering = on_start_steering
        inst.on_stop_steering = on_stop_steering

        inst.walksound = "wood"
        inst.doplatformcamerazoom = net_bool(inst.GUID, "doplatformcamerazoom", "doplatformcamerazoomdirty")

        if not TheNet:IsDedicated() then
            inst:ListenForEvent("endsteeringreticule", function(inst2, event_data)
                if ThePlayer and ThePlayer == event_data.player then
                    inst2:on_stop_steering()
                end
            end)
            inst:ListenForEvent("starsteeringreticule", function(inst2, event_data)
                if ThePlayer and ThePlayer == event_data.player then
                    inst2:on_start_steering(inst2, event_data.player)
                end
            end)

            inst:AddComponent("boattrail")
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            inst.OnEntityReplicated = OnEntityReplicated
            return inst
        end

        inst.Physics:SetDontRemoveOnSleep(true)
        -- inst.item_collision_prefab = "boat_item_collision" --船是跟随玩家的，不需要墙

        inst.entity:AddPhysicsWaker() --server only component
        inst.PhysicsWaker:SetTimeBetweenWakeTests(TUNING.BOAT.WAKE_TEST_TIME)

        local repairable = inst:AddComponent("repairable")
        repairable.repairmaterial = MATERIALS.WOOD

        inst:AddComponent("boatring") --旋转
        inst:AddComponent("hullhealth")
        inst.components.hullhealth.leakproof = true
        inst:AddComponent("boatdrifter")
        inst:AddComponent("savedrotation")
        -- 船物理组件
        inst:AddComponent("boatphysics")
        inst.components.boatphysics.max_velocity = 10      -- 最大速度（默认约6）
        inst.components.boatphysics.throttle_increment = 0.5 -- 加速灵敏度（默认约0.25）
        inst.components.boatphysics.drag = 0.2            -- 阻力（值越小速度衰减越慢）


        inst:AddComponent("inspectable")
        inst:AddComponent("container")
        inst.components.container:WidgetSetup(name)
        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true
        -- 防止永不妥协老鼠偷东西，必须带有容器的实体
        NhidaDropOneItemWithTag(inst)

        local health = inst:AddComponent("health")
        health:SetMaxHealth(data.health or TUNING.BOAT.HEALTH)
        health.nofadeout = true

        -- 添加 hull 组件（关键修复）
        local hull = inst:AddComponent("hull")
        hull:SetRadius(RADIUS)

        inst:ListenForEvent("nahida_salvage", BoatSalvage)

        -- inst:SetStateGraph(data.stategraph or "SGboat")

        inst.StopBoatPhysics = StopBoatPhysics
        inst.StartBoatPhysics = StartBoatPhysics

        inst.OnPhysicsWake = OnPhysicsWake
        inst.OnPhysicsSleep = OnPhysicsSleep

        inst.sinkloot = empty_loot_function
        inst.InstantlyBreakBoat = InstantlyBreakBoat
        inst.GetSafePhysicsRadius = GetSafePhysicsRadius
        inst.IsBoatEdgeOverLand = IsBoatEdgeOverLand

        inst.OnLoadPostPass = OnLoadPostPass

        inst.sounds = sounds

        inst.sinkloot = function()
            local ignitefragments = inst.activefires > 0
            local locus_point = inst:GetPosition()
            local num_loot = 3
            local loot_angle = PI2 / num_loot
            for i = 1, num_loot do
                local r = math.sqrt(math.random()) * (-0.5) + 1.5
                local t = (i + 2 * math.random()) * loot_angle
                SpawnFragment(locus_point, "boards", math.cos(t) * r, 0, math.sin(t) * r, ignitefragments)
            end
        end

        inst.postsinkfn = function()
            inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage, { intensity = 1 })
            inst.SoundEmitter:PlaySoundWithParams(inst.sounds.sink)
        end

        return inst
    end
end

local function onDeployCoconut(inst, pt, deployer)
    local tree = SpawnPrefab(inst.transplantation_item)  -- 暂时使用原版的树作为种植后的物品
    if tree ~= nil then
        tree.Transform:SetPosition(pt:Get())
        inst:Remove()  -- 移除树苗物品
    end
end

local function CreateCustomPrefab(name, transplantation_item, build, bank, atlasname, scale, tags, item_fn)
    local assets = {
        Asset("ANIM", "anim/" .. build .. ".zip"),
        Asset("ATLAS", "images/inventoryimages/" .. atlasname .. ".xml"),
        Asset("IMAGE", "images/inventoryimages/" .. atlasname .. ".tex"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddLight()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("shoreonsink")
        inst:AddTag("tornado_nosucky")
        inst:AddTag("hide_percentage")
        inst:AddTag("nosteal")
        inst:AddTag(name)
        inst:AddTag("dst_gi_nahida_item")

        if tags ~= nil then
            for i, v in ipairs(tags) do
                inst:AddTag(v)
            end
        end

        inst.AnimState:SetBuild(build)
        inst.AnimState:SetBank(bank)
        inst.AnimState:PlayAnimation("idle")

        if scale then
            inst.Transform:SetScale(scale.x, scale.y, scale.z)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("dst_gi_nahida_actions_data")
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. atlasname .. ".xml"

        inst.transplantation_item = transplantation_item

        if item_fn then
            item_fn(inst)
        end

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = onDeployCoconut
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
        inst.components.deployable:SetDeployMode(DEPLOYMODE.WATER)

        MakeHauntableLaunchAndDropFirstItem(inst)
        MakeLargeBurnable(inst)
        MakeLargePropagator(inst)
        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(name, fn, assets)
end

local function build_boat_collision_mesh(radius, height)
    local segment_count = BOAT_COLLISION_SEGMENT_COUNT
    local segment_span = TWOPI / segment_count

    local triangles = {}
    local y0 = 0
    local y1 = height

    for segement_idx = 0, segment_count do
        local angle = segement_idx * segment_span
        local angle0 = angle - segment_span / 2
        local angle1 = angle + segment_span / 2

        local x0 = math.cos(angle0) * radius
        local z0 = math.sin(angle0) * radius

        local x1 = math.cos(angle1) * radius
        local z1 = math.sin(angle1) * radius

        table.insert(triangles, x0)
        table.insert(triangles, y0)
        table.insert(triangles, z0)

        table.insert(triangles, x0)
        table.insert(triangles, y1)
        table.insert(triangles, z0)

        table.insert(triangles, x1)
        table.insert(triangles, y0)
        table.insert(triangles, z1)

        table.insert(triangles, x1)
        table.insert(triangles, y0)
        table.insert(triangles, z1)

        table.insert(triangles, x0)
        table.insert(triangles, y1)
        table.insert(triangles, z0)

        table.insert(triangles, x1)
        table.insert(triangles, y1)
        table.insert(triangles, z1)
    end

    return triangles
end

local function boat_player_collision_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    inst:AddTag("CLASSIFIED")

    local phys = inst.entity:AddPhysics()
    phys:SetMass(0)
    phys:SetFriction(0)
    phys:SetDamping(5)
    phys:SetRestitution(0)
    phys:SetCollisionGroup(COLLISION.BOAT_LIMITS)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.WORLD)

    -- 注意：这里不与其他障碍物碰撞，避免干扰船的物理行为

    phys:SetTriangleMesh(build_boat_collision_mesh(RADIUS + 0.1, 3))

    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("dst_gi_nahida_shipwrecked_boat",
        MakeBoat("dst_gi_nahida_shipwrecked_boat", "rowboat", "rowboat_armored_build", { minimap = "dst_gi_nahida_shipwrecked_boat.png", health = 150 }), armouredboat_assets,
        prefabs),
CreateCustomPrefab(
        "dst_gi_nahida_shipwrecked_boat_item", -- name -- 船
        "dst_gi_nahida_shipwrecked_boat", -- name -- 船
        "dst_gi_nahida_shipwrecked_boat_item", -- build
        "dst_gi_nahida_shipwrecked_boat_item", -- bank
        "dst_gi_nahida_shipwrecked_boat_item", -- atlasname
        nil,
        { "dst_gi_nahida_shipwrecked_boat_item" },
        nil
),
MakePlacer("dst_gi_nahida_shipwrecked_boat_item_placer", "rowboat", "rowboat_armored_build", "run_loop"),
Prefab("dst_gi_nahida_shipwrecked_boat2",
        MakeBoat("dst_gi_nahida_shipwrecked_boat2", "rowboat", "rowboat_armored_build", { minimap = "dst_gi_nahida_shipwrecked_boat.png", health = 150 }), armouredboat_assets,
        prefabs),
CreateCustomPrefab(
        "dst_gi_nahida_shipwrecked_boat2_item", -- name -- 船
        "dst_gi_nahida_shipwrecked_boat2", -- name -- 船
        "dst_gi_nahida_shipwrecked_boat2_item", -- build
        "dst_gi_nahida_shipwrecked_boat2_item", -- bank
        "dst_gi_nahida_shipwrecked_boat2_item", -- atlasname
        nil,
        { "dst_gi_nahida_shipwrecked_boat_item" },
        nil
),
MakePlacer("dst_gi_nahida_shipwrecked_boat2_item_placer", "rowboat", "rowboat_armored_build", "run_loop"),
Prefab("shipwrecked_boat_player_collision", boat_player_collision_fn)
