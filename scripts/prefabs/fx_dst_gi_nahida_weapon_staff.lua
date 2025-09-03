---
--- fx_dst_gi_nahida_weapon_staff.lua
--- Description: 武器拖尾特效（仅粒子，不含光源）
--- Author: 没有小钱钱
--- Date: 2025/6/8 4:37
---
local ANIM_HEART_TEXTURE  = resolvefilepath("images/fx/weapon_trail.tex")
local REVEAL_SHADER = "shaders/vfx_particle_reveal.ksh"

local COLOUR_ENVELOPE_NAME = "heart_colourenvelope"
local SCALE_ENVELOPE_NAME = "heart_scaleenvelope"

local assets =
{
    Asset("IMAGE", ANIM_HEART_TEXTURE),
    Asset("SHADER", REVEAL_SHADER),
}

--------------------------------------------------------------------------

local function IntColour(r, g, b, a)
    return { r / 255, g / 255, b / 255, a / 255 }
end

local function InitEnvelope()
    EnvelopeManager:AddColourEnvelope(
            COLOUR_ENVELOPE_NAME,
            {
                { 0,    IntColour(144, 238, 144, 120) },
                { .19,  IntColour(152, 251, 152, 120) },
                { .35,  IntColour(119, 221, 119, 80) },
                { .51,  IntColour(85, 170, 85, 60) },
                { .75,  IntColour(60, 130, 60, 40) },
                { 1,    IntColour(34, 80, 34, 0) },
            }
    )

    local glow_max_scale = .8
    EnvelopeManager:AddVector2Envelope(
            SCALE_ENVELOPE_NAME,
            {
                { 0,    { glow_max_scale * 0.7, glow_max_scale * 0.7 } },
                { .55,  { glow_max_scale * 1.2, glow_max_scale * 1.2 } },
                { 1,    { glow_max_scale * 1.3, glow_max_scale * 1.3 } },
            }
    )

    InitEnvelope = nil
    IntColour = nil
end

--------------------------------------------------------------------------
local GLOW_MAX_LIFETIME = 0.8  -- 降低最大生命周期

local function emit_glow_fn(effect, emitter_fn, inst)
    local particle_count = math.random(2, 4)  -- 减少粒子数量

    for i = 1, particle_count do
        local px, py, pz = emitter_fn()
        local vx, vy, vz = 0, 0, 0

        if inst.last_pos and inst.move_direction then
            vx = -inst.move_direction.x * 0.08
            vy = -inst.move_direction.y * 0.08
            vz = -inst.move_direction.z * 0.08

            vx = vx + (math.random() - 0.5) * 0.02
            vy = vy + (math.random() - 0.5) * 0.02
            vz = vz + (math.random() - 0.5) * 0.02
        else
            vx, vy, vz = .005 * UnitRand(), 0, .005 * UnitRand()
        end

        -- 修复生命周期计算，确保不超过最大值
        local lifetime = GLOW_MAX_LIFETIME * (0.5 + math.random() * 0.5)  -- 0.4 到 0.8 秒
        lifetime = math.min(lifetime, GLOW_MAX_LIFETIME)  -- 确保不超过最大值

        px = px + math.random(-1,1) * .15
        py = py + 2.8 + (math.random() - 0.5) * 0.2
        pz = pz + math.random(-1,1) * .15

        local uv_offset = math.random(0, 3) * .25
        effect:AddRotatingParticle(
                0,
                lifetime,
                px, py, pz,
                vx, vy, vz,
                uv_offset,
                math.random() * 4 - 2
        )
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst.entity:SetPristine()
    inst.persists = false

    -- 移动追踪变量
    inst.last_pos = nil
    inst.move_direction = nil
    inst.move_speed = 0

    if TheNet:IsDedicated() then
        return inst
    elseif InitEnvelope ~= nil then
        InitEnvelope()
    end

    -- 保留粒子特效系统
    local effect = inst.entity:AddVFXEffect()
    effect:InitEmitters(1)
    effect:SetRenderResources(0, ANIM_HEART_TEXTURE, REVEAL_SHADER)
    effect:SetMaxNumParticles(0, 64)  -- 减少最大粒子数量
    effect:SetRotationStatus(0, true)
    effect:SetMaxLifetime(0, GLOW_MAX_LIFETIME)
    effect:SetColourEnvelope(0, COLOUR_ENVELOPE_NAME)
    effect:SetScaleEnvelope(0, SCALE_ENVELOPE_NAME)
    effect:SetBlendMode(0, BLENDMODE.AlphaBlended)
    effect:EnableBloomPass(0, true)
    effect:SetSortOrder(0, 0)
    effect:SetSortOffset(0, 0)
    effect:SetKillOnEntityDeath(0, true)
    effect:SetFollowEmitter(0, true)

    -- 粒子发射逻辑（优化）
    local tick_time = TheSim:GetTickTime()
    local glow_desired_pps = 6  -- 降低每秒粒子数
    local glow_particles_per_tick = glow_desired_pps * tick_time
    local glow_num_particles_to_emit = 0
    local sphere_emitter = CreateSphereEmitter(.08)

    EmitterManager:AddEmitter(inst, nil, function()
        local x, y, z = inst.Transform:GetWorldPosition()
        local current_pos = {x = x, y = y, z = z}

        if inst.last_pos then
            local dx = current_pos.x - inst.last_pos.x
            local dy = current_pos.y - inst.last_pos.y
            local dz = current_pos.z - inst.last_pos.z

            inst.move_speed = math.sqrt(dx*dx + dy*dy + dz*dz)

            if inst.move_speed > 0.01 then
                inst.move_direction = {
                    x = dx / tick_time,
                    y = dy / tick_time,
                    z = dz / tick_time
                }
            else
                inst.move_direction = nil
            end
        end

        -- 限制发射倍数，防止粒子过多
        local emission_multiplier = inst.move_speed and (inst.move_speed > 0.01 and math.min(inst.move_speed * 15, 3) or 0.2) or 0.2

        while glow_num_particles_to_emit > 1 do
            emit_glow_fn(effect, sphere_emitter, inst)
            glow_num_particles_to_emit = glow_num_particles_to_emit - 1
        end
        glow_num_particles_to_emit = glow_num_particles_to_emit + glow_particles_per_tick * emission_multiplier

        inst.last_pos = current_pos
    end)

    return inst
end

return Prefab("fx_dst_gi_nahida_weapon_staff", fn, assets)