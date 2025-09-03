-- 独立的冰火法阵预制体
-- 基于克劳斯红蓝鹿的法阵系统改造

local ICE_COLOUR = { 60/255, 120/255, 255/255 }
local FIRE_COLOUR = { 220/255, 100/255, 0/255 }

local exclude_tags = { "INLIMBO", "companion", "wall", "abigail", "player", "chester", "zhijiang_hound" }
--------------------------------------------------------------------------
-- 通用法阵功能函数
local function OnUpdateFade(inst)
    local k
    if inst._fade:value() <= inst._fadeframes then
        inst._fade:set_local(math.min(inst._fade:value() + inst._fadeinspeed, inst._fadeframes))
        k = inst._fade:value() / inst._fadeframes
    else
        inst._fade:set_local(math.min(inst._fade:value() + inst._fadeoutspeed, inst._fadeframes * 2 + 1))
        k = (inst._fadeframes * 2 + 1 - inst._fade:value()) / inst._fadeframes
    end

    inst.Light:SetIntensity(inst._fadeintensity * k)
    inst.Light:SetRadius(inst._faderadius * k)
    inst.Light:SetFalloff(1 - (1 - inst._fadefalloff) * k)

    if TheWorld.ismastersim then
        inst.Light:Enable(inst._fade:value() > 0 and inst._fade:value() <= inst._fadeframes * 2)
    end

    if inst._fade:value() == inst._fadeframes or inst._fade:value() > inst._fadeframes * 2 then
        inst._fadetask:Cancel()
        inst._fadetask = nil
    end
end

local function OnFadeDirty(inst)
    if inst._fadetask == nil then
        inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)
    end
    OnUpdateFade(inst)
end

local function OnFXKilled(inst)
    if inst.fxcount > 0 then
        inst.fxcount = inst.fxcount - 1
    else
        inst:Remove()
    end
end

local function TriggerFX(inst)
    if not inst.killed and inst.fx ~= nil then
        return
    end
    inst.fx = {}
    inst.fxcount = 0
    local function onremovefx(fx)
        OnFXKilled(inst)
    end
    for i, v in ipairs(inst.fxprefabs) do
        local fx = SpawnPrefab(v)
        fx.entity:SetParent(inst.entity)
        inst.fxcount = inst.fxcount + 1
        inst:ListenForEvent("onremove", onremovefx, fx)
        table.insert(inst.fx, fx)
    end
end

local function FadeOut(inst)
    inst._fade:set(inst._fadeframes + 1)
    if inst._fadetask == nil then
        inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)
    end
end

local function KillFX(inst, anim)
    if not inst.killed then
        if inst.OnKillFX ~= nil then
            inst:OnKillFX(anim)
        end
        inst.killed = true
        inst.AnimState:PlayAnimation(anim or "pst")
        inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + .25, inst.fx ~= nil and OnFXKilled or inst.Remove)
        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
        end
        if inst._fade ~= nil then
            FadeOut(inst)
        end
        if inst.fx ~= nil then
            for i, v in ipairs(inst.fx) do
                v:KillFX()
            end
        end
    end
end
------------------------火魔法函数--------------------------------------------------
local function deer_fire_circle_common_postinit(inst)
    inst:AddTag("deer_fire_circle")
end
local function OnKillFireCircle(inst)
    inst.SoundEmitter:KillSound("loop")
end

local function deer_fire_circle_master_postinit(inst)
    inst:AddComponent("propagator")
    inst.components.propagator.damages = true
    inst.components.propagator.propagaterange = .25
    inst.components.propagator.damagerange = .25
    inst.components.propagator:StartSpreading()
end

local function deer_fire_circle_onkillfx(inst, anim)
    inst.components.propagator:StopSpreading()
    inst:RemoveTag("deer_fire_circle")
    inst:ListenForEvent("animover", OnKillFireCircle)
end
-----------------------------------------------------------------
-------------------------冰魔法函数----------------------------------------

local function OnAnimOverIceCircle(inst)
    inst.SoundEmitter:KillSound("loop")
end

local function deer_ice_circle_common_postinit(inst)
    inst:AddTag("deer_ice_circle")

    inst._rad = net_float(inst.GUID, "deer_ice_circle._rad")
end

local function deer_ice_circle_master_postinit(inst)
    inst:ListenForEvent("animover", OnAnimOverIceCircle)
end

local function deer_ice_circle_onkillfx(inst, anim)
    inst:RemoveTag("deer_ice_circle")
    inst._rad:set(0)
end

--------------------------------------------------------------------------

local function deer_ice_fx_onkillfx(inst, anim)
    inst.SoundEmitter:KillSound("loop")
end

local function SetDuration(inst,duration)
    inst.duration = duration
end
local function SetRange(inst,radius)
    inst.radius = radius
end

local function SetOnAttack(inst,onattack)
    inst.onattack = onattack
end
local function InitTask(inst)
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
    if inst.onattack then
        inst.task = inst:DoPeriodicTask(1,function()
            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, inst.radius or 15, { "_combat" }, exclude_tags)
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
                    then
                        AddDstGiNahidaElementalReactionComponents(inst,ent)
                        inst.onattack(ent)
                    end
                end
            end
        end)
    end
end

---------------------------------------------------------------


local function MakeFX(name,original_name, data)
    local assets =
    {
        Asset("ANIM", "anim/"..original_name..".zip"),
    }

    local prefabs = {}
    if data.burstprefab ~= nil then
        table.insert(prefabs, data.burstprefab)
    end
    if data.fxprefabs ~= nil then
        for i, v in ipairs(data.fxprefabs) do
            table.insert(prefabs, v)
        end
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        if data.sound ~= nil or data.soundloop ~= nil then
            inst.entity:AddSoundEmitter()
        end
        inst.entity:AddNetwork()

        inst.AnimState:SetBank(original_name)
        inst.AnimState:SetBuild(original_name)
        inst.AnimState:PlayAnimation(data.oneshotanim or "pre")
        if data.scale and #data.scale == 3 then
            inst.Transform:SetScale(data.scale[1], data.scale[2], data.scale[3])
        end

        inst.AnimState:SetLightOverride(1)
        inst.AnimState:SetFinalOffset(1)

        if data.bloom then
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end

        if data.onground then
            inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.AnimState:SetSortOrder(3)
        end

        if data.soundloop ~= nil then
            inst.SoundEmitter:PlaySound(data.soundloop, "loop")
        end

        if data.light then
            if data.onground then
                inst._fadeframes = 30
                inst._fadeintensity = .8
                inst._faderadius = 3
                inst._fadefalloff = .9
                inst._fadeinspeed = 1
                inst._fadeoutspeed = 2
            else
                inst._fadeframes = 15
                inst._fadeintensity = .8
                inst._faderadius = 2
                inst._fadefalloff = .7
                inst._fadeinspeed = 3
                inst._fadeoutspeed = 1
            end

            inst.entity:AddLight()
            inst.Light:SetColour(unpack(data.light))
            inst.Light:SetRadius(inst._faderadius)
            inst.Light:SetFalloff(inst._fadefalloff)
            inst.Light:SetIntensity(inst._fadeintensity)
            inst.Light:Enable(false)
            inst.Light:EnableClientModulation(true)

            inst._fade = net_smallbyte(inst.GUID, "deer_fx._fade", "fadedirty")

            inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)
        end

        inst:AddTag("FX")

        if data.common_postinit ~= nil then
            data.common_postinit(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            if data.light then
                inst:ListenForEvent("fadedirty", OnFadeDirty)
            end

            return inst
        end

        inst.persists = false

        if data.sound ~= nil then
            inst.SoundEmitter:PlaySound(data.sound)
        end

        if data.oneshotanim ~= nil then
            inst.killed = true
            inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + .25, inst.Remove)
        else
            inst.burstprefab = data.burstprefab

            if data.fxprefabs ~= nil then
                inst.fxprefabs = data.fxprefabs
                inst.TriggerFX = TriggerFX
            end

            if data.looping then
                inst.AnimState:PushAnimation("loop")
            end
        end

        inst.SetDuration = SetDuration
        inst.SetRange = SetRange
        inst.SetOnAttack = SetOnAttack
        inst.InitTask = InitTask
        inst.KillFX = KillFX
        inst.OnKillFX = data.onkillfx

        if data.master_postinit ~= nil then
            data.master_postinit(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets, #prefabs > 0 and prefabs or nil)
end

return MakeFX("dst_nahida_deer_ice_circle","deer_ice_circle", {
    light = ICE_COLOUR,
    onground = true,
    scale = {1.8,1.8,1.8},
    soundloop = "dontstarve/creatures/together/deer/fx/ice_circle_LP",
    fxprefabs = { "deer_ice_fx", "deer_ice_flakes" },
    burstprefab = "deer_ice_burst",
    common_postinit = deer_ice_circle_common_postinit,
    master_postinit = deer_ice_circle_master_postinit,
    onkillfx = deer_ice_circle_onkillfx,
}),MakeFX("dst_nahida_deer_fire_circle","deer_fire_circle", {
    light = FIRE_COLOUR,
    bloom = true,
    onground = true,
    scale = {1.7,1.7,1.7},
    soundloop = "dontstarve/creatures/together/deer/fx/fire_circle_LP",
    fxprefabs = { "deer_fire_flakes" },
    burstprefab = "deer_fire_burst",
    common_postinit = deer_fire_circle_common_postinit,
    master_postinit = deer_fire_circle_master_postinit,
    onkillfx = deer_fire_circle_onkillfx,
})