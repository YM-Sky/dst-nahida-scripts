---
--- dst_gi_nahida_music_score.lua
--- Description: 传送锚点，借鉴于 元素反应
--- Author: 没有小钱钱
--- Date: 2025/5/24 16:28
---

local assets =
{
    Asset("ANIM", "anim/teleport_waypoint.zip"),
}

---------------------------------------------------------------------------------

local function RegisterSelf(inst, playerid)
    local x, y, z = inst.Transform:GetWorldPosition()
    SendModRPCToClient(GetClientModRPC("dst_gi_nahida_tp_core", "registerwaypoint"), playerid, x, y, z, inst.GUID, inst.components.writeable:GetText())
end

local function UnRegisterSelf(inst, playerid)
    SendModRPCToClient(GetClientModRPC("dst_gi_nahida_tp_core", "unregisterwaypoint"), playerid, inst.GUID)
end

---------------------------------------------------------------------------------

local function CheckPosition(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 20, {"dst_gi_nahida_teleport_waypoint"})
    if #ents >= 2 then  --哎呦，除了我还有至少一个啊
        return false
    end
    return true
end

local function OnBuilt(inst)
    if not CheckPosition(inst) then
        inst.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TELEPORT_WAYPOINT_CRASH)
        inst.components.lootdropper:DropLoot()
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("metal")
        -- 销毁传送锚点
        --NahidaUnRegisterWaypoint(inst)
        inst:Remove()
        --注册取消事件
        --for i, player in ipairs(AllPlayers) do
        --    UnRegisterSelf(inst, player.userid)
        --end
        return
    end

    -- 检查是否在水面，如果是则生成地皮
    --local x, y, z = inst.Transform:GetWorldPosition()
    --if TheWorld.Map:IsOceanAtPoint(x, y, z) then
    --    -- 在水面生成一格地皮
    --    local tile_x, tile_y = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    --    if tile_x and tile_y then
    --        -- 直接设置地图瓦片为道路类型
    --        TheWorld.Map:SetTile(tile_x, tile_y, WORLD_TILES.ROAD)
    --        -- 重新生成地形网格
    --        TheWorld.Map:RebuildLayer(GROUND, tile_x, tile_y, 1)
    --        -- 播放放置音效
    --        inst.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone")
    --    end
    --end

    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
    if inst.light == nil then
        inst.light = SpawnPrefab("dst_gi_nahida_teleport_waypoint_light")
        inst.light.entity:SetParent(inst.entity)
    end
end


local function OnWritingEndedFn(inst)
    -- 服务端注册传送锚点
    --local x, y, z = inst.Transform:GetWorldPosition()
    --NahidaRegisterWaypoint(inst,x, y, z,inst.components.writeable:GetText())
end

local function OnSave(inst,data)
    if not inst.waypoint_id then
        inst.waypoint_id = SpawnNhidaUuid() -- 你的UUID生成函数
    end
    data.waypoint_id = inst.waypoint_id
end

local function OnLoad(inst,data)
    -- 服务端注册传送锚点
    local x, y, z = inst.Transform:GetWorldPosition()
    NahidaRegisterWaypoint(inst,x, y, z,inst.components.writeable:GetText())
    if inst.light == nil then
        inst.light = SpawnPrefab("dst_gi_nahida_teleport_waypoint_light")
        inst.light.entity:SetParent(inst.entity)
    end
    inst.waypoint_id = data.waypoint_id
end

local function OnHammered(inst, worker)
    -- 摧毁时向所有玩家推送取消注册事件
    --for i, player in ipairs(AllPlayers) do
    --    UnRegisterSelf(inst, player.userid)
    --end
    --拆除
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    if inst.light ~= nil then
        inst.light:Remove()
    end
    inst.components.maprevealer:Stop()
    if inst.icon ~= nil then
        inst.icon:Remove()
        inst.icon = nil
    end
    inst:Remove()
    -- 销毁传送锚点
    NahidaUnRegisterWaypoint(inst)
end

local function OnHit(inst, worker)
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
end

local function workmultiplierfn(inst, worker, numworks)
    if worker and worker:HasTag("player") then
        return 1
    end
    return 0
end

local function init(inst)
    if inst.icon == nil and not inst:HasTag("burnt") then
        inst.icon = SpawnPrefab("globalmapicon")
        inst.icon.MiniMapEntity:SetIsFogRevealer(true)
        inst.icon:AddTag("fogrevealer")
        inst.icon:TrackEntity(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    -- 移除碰撞体积，允许在有阻挡物品的地方放置
    -- MakeObstaclePhysics(inst, .5)  -- 注释掉原来的碰撞
    inst:SetDeploySmartRadius(0.25) -- 设置部署半径但不产生碰撞
    RemovePhysicsColliders(inst) -- 移除物理碰撞器

    inst.AnimState:SetBank("teleport_waypoint")
    inst.AnimState:SetBuild("teleport_waypoint")
    inst.AnimState:PlayAnimation("idle", true)

    inst.Transform:SetScale(0.8, 0.8, 0.8)

    inst:AddTag("structure")
    inst:AddTag("dst_gi_nahida_teleport_waypoint")
    --Sneak these into pristine state for optimization
    inst:AddTag("_writeable")
    inst:AddTag("maprevealer")

    inst:AddComponent("talker")

    inst.entity:SetPristine()
    inst.persists = true

    if not TheWorld.ismastersim then
        return inst
    end
    --Remove these tags so that they can be added properly when replicating components below
    inst:RemoveTag("_writeable")

    inst:AddComponent("inspectable")

    inst:AddComponent("writeable")
    inst.components.writeable:SetOnWritingEndedFn(OnWritingEndedFn)

    inst:AddComponent("lootdropper")
    inst:AddComponent("maprevealer")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)
    --inst.components.workable.workmultiplierfn = workmultiplierfn

    inst:ListenForEvent("onbuilt", OnBuilt)

    --inst:DoTaskInTime(0, init)
    if not inst.waypoint_id then
        inst.waypoint_id = SpawnNhidaUuid() -- 你的UUID生成函数
    end

    inst:ListenForEvent("onremove", function(_inst)
        if inst.scan_task ~= nil then
            inst.scan_task:Cancel()
            inst.scan_task = nil
        end
        -- 销毁传送锚点
        NahidaUnRegisterWaypoint(_inst)
    end)

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave

    inst.scan_task = inst:DoPeriodicTask(1,function(_inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        NahidaRegisterWaypoint(inst,x, y, z,inst.components.writeable:GetText())
    end)

    return inst
end

local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetRadius(4)
    inst.Light:SetFalloff(.75)
    inst.Light:SetIntensity(.65)
    inst.Light:SetColour(240 / 255, 240 / 255, 255 / 255)  -- 白光带一点点蓝光

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("dst_gi_nahida_teleport_waypoint", fn, assets),
MakePlacer("dst_gi_nahida_teleport_waypoint_placer", "teleport_waypoint", "teleport_waypoint", "build"),
Prefab("dst_gi_nahida_teleport_waypoint_light", lightfn)