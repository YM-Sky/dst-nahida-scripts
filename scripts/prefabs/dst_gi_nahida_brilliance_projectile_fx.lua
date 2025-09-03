---
--- dst_gi_nahida_brilliance_projectile_fx.lua
--- Description: 弹幕特效
--- Author: 没有小钱钱
--- Date: 2025/6/8 14:22
---
---
--- nahida_brilliance_projectile_fx.lua
--- Description: 纳西妲专用弹幕特效（禁用弹射）
---

local assets =
{
    Asset("ANIM", "anim/brilliance_projectile_fx.zip"),
}

-- 元素颜色配置
local ELEMENT_COLORS = {
    water = {r = 0.0, g = 0.75, b = 1.0},     -- 深蓝色
    fire = {r = 1.0, g = 0.41, b = 0.0},      -- 橙红色
    ice = {r = 0.53, g = 0.81, b = 0.92},     -- 浅蓝色
    thunder = {r = 0.60, g = 0.20, b = 0.80}, -- 紫色
    grass = {r = 0.20, g = 0.80, b = 0.20},   -- 鲜绿色
    wind = {r = 0.25, g = 0.88, b = 0.82},    -- 青绿色
    rock = {r = 1.0, g = 0.84, b = 0.0},      -- 金黄色
    physical = {r = 0.75, g = 0.75, b = 0.75} -- 银白色
}

local SPEED = 15
local BOUNCE_RANGE = 12
local BOUNCE_SPEED = 10

local function PlayAnimAndRemove(inst, anim)
    inst.AnimState:PlayAnimation(anim)
    if not inst.removing then
        inst.removing = true
        inst:ListenForEvent("animover", inst.Remove)
    end
end

local function OnThrown(inst, owner, target, attacker)
    inst.owner = owner
    if inst.bounces == nil then
        -- 🔥 从武器上读取弹射等级，如果没有则默认为1（不弹射）
        local weapon = attacker and attacker.components.combat and attacker.components.combat:GetWeapon()
        local bounce_level = 1  -- 默认等级1（不弹射）
        if weapon and weapon.nahida_bounce_level then
            bounce_level = weapon.nahida_bounce_level
        end
        -- 🔥 根据等级设置弹射次数
        -- 等级1 = 0次弹射（只命中初始目标）
        -- 等级2 = 1次弹射（命中2个敌人）
        -- 等级3 = 2次弹射（命中3个敌人）
        inst.bounces = math.max(0, bounce_level)
        inst.initial_hostile = target ~= nil and target:IsValid() and target:HasTag("hostile")
    end
end

local BOUNCE_MUST_TAGS = { "_combat" }
local BOUNCE_NO_TAGS = { "INLIMBO", "wall", "notarget", "player", "companion", "flight", "invisible", "noattack", "hiding" }

local function TryBounce(inst, x, z, attacker, target)
    if attacker.components.combat == nil or not attacker:IsValid() then
        inst:Remove()
        return
    end
    local newtarget, newrecentindex, newhostile
    for i, v in ipairs(TheSim:FindEntities(x, 0, z, BOUNCE_RANGE, BOUNCE_MUST_TAGS, BOUNCE_NO_TAGS)) do
        if v ~= target and v.entity:IsVisible() and
                not (v.components.health ~= nil and v.components.health:IsDead()) and
                attacker.components.combat:CanTarget(v) and not attacker.components.combat:IsAlly(v)
        then
            local vhostile = v:HasTag("hostile")
            local vrecentindex
            if inst.recenttargets ~= nil then
                for i1, v1 in ipairs(inst.recenttargets) do
                    if v == v1 then
                        vrecentindex = i1
                        break
                    end
                end
            end
            if inst.initial_hostile and not vhostile and vrecentindex == nil and v.components.locomotor == nil then
                --attack was initiated against a hostile target
                --skip if non-hostile, can't move, and has never been targeted
            elseif newtarget == nil then
                newtarget = v
                newrecentindex = vrecentindex
                newhostile = vhostile
            elseif vhostile and not newhostile then
                newtarget = v
                newrecentindex = vrecentindex
                newhostile = vhostile
            elseif vhostile or not newhostile then
                if vrecentindex == nil then
                    if newrecentindex ~= nil or (newtarget.prefab ~= target.prefab and v.prefab == target.prefab) then
                        newtarget = v
                        newrecentindex = vrecentindex
                        newhostile = vhostile
                    end
                elseif newrecentindex ~= nil and vrecentindex < newrecentindex then
                    newtarget = v
                    newrecentindex = vrecentindex
                    newhostile = vhostile
                end
            end
        end
    end

    if newtarget ~= nil then
        inst.Physics:Teleport(x, 0, z)
        inst:Show()
        inst.components.projectile:SetSpeed(BOUNCE_SPEED)
        if inst.recenttargets ~= nil then
            if newrecentindex ~= nil then
                table.remove(inst.recenttargets, newrecentindex)
            end
            table.insert(inst.recenttargets, target)
        else
            inst.recenttargets = { target }
        end
        inst.components.projectile:SetBounced(true)
        inst.components.projectile.overridestartpos = Vector3(x, 0, z)
        inst.components.projectile:Throw(inst.owner, newtarget, attacker)
    else
        inst:Remove()
    end
end

local function OnHit(inst, attacker, target)
    -- 获取元素类型
    local element = inst.element or "grass"
    local blast = SpawnPrefab("dst_gi_nahida_brilliance_projectile_blast_fx_" .. element)
    local x, y, z
    if target:IsValid() then
        local radius = target:GetPhysicsRadius(0) + .2
        local angle = (inst.Transform:GetRotation() + 180) * DEGREES
        x, y, z = target.Transform:GetWorldPosition()
        x = x + math.cos(angle) * radius + GetRandomMinMax(-.2, .2)
        y = GetRandomMinMax(.1, .3)
        z = z - math.sin(angle) * radius + GetRandomMinMax(-.2, .2)
        blast:PushFlash(target)
    else
        x, y, z = inst.Transform:GetWorldPosition()
    end
    blast.Transform:SetPosition(x, y, z)

    if inst.bounces ~= nil and inst.bounces > 1 and attacker ~= nil and attacker.components.combat ~= nil and attacker:IsValid() then
        inst.bounces = inst.bounces - 1
        inst.Physics:Stop()
        inst:Hide()
        inst:DoTaskInTime(.1, TryBounce, x, z, attacker, target)
    else
        inst:Remove()
    end
end

local function OnMiss(inst, attacker, target)
    if not inst.AnimState:IsCurrentAnimation("disappear") then
        PlayAnimAndRemove(inst, "disappear")
    end
end

local function PushColour(inst, r, g, b)
    if inst.target:IsValid() then
        if inst.target.components.colouradder == nil then
            inst.target:AddComponent("colouradder")
        end
        inst.target.components.colouradder:PushColour(inst, r, g, b, 0)
    end
end

local function PopColour(inst)
    inst.OnRemoveEntity = nil
    if inst.target.components.colouradder ~= nil and inst.target:IsValid() then
        inst.target.components.colouradder:PopColour(inst)
    end
end

local function CreateProjectileFn(element)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddPhysics()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
        RemovePhysicsColliders(inst)

        inst:AddTag("FX")
        inst:AddTag("NOCLICK")

        inst.AnimState:SetBank("brilliance_projectile_fx")
        inst.AnimState:SetBuild("brilliance_projectile_fx")
        inst.AnimState:PlayAnimation("idle_loop", true)

        -- 应用元素颜色
        local color = ELEMENT_COLORS[element] or ELEMENT_COLORS.grass
        inst.AnimState:SetMultColour(color.r * 0.7 + 0.3, color.g * 0.7 + 0.3, color.b * 0.7 + 0.3, 1)
        inst.AnimState:SetSymbolMultColour("light_bar", color.r * 0.5 + 0.5, color.g * 0.5 + 0.5, color.b * 0.5 + 0.5, .5)
        inst.AnimState:SetSymbolBloom("light_bar")
        inst.AnimState:SetSymbolBloom("glow")
        inst.AnimState:SetLightOverride(.5)

        inst:AddTag("projectile")
        inst.element = element  -- 存储元素类型
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("projectile")
        inst.components.projectile:SetSpeed(SPEED)
        inst.components.projectile:SetRange(25)
        inst.components.projectile:SetOnThrownFn(OnThrown)
        inst.components.projectile:SetOnHitFn(OnHit)
        inst.components.projectile:SetOnMissFn(OnMiss)

        inst.persists = false
        return inst
    end
end

local function CreateBlastFn(element)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("FX")
        inst:AddTag("NOCLICK")

        inst.AnimState:SetBank("brilliance_projectile_fx")
        inst.AnimState:SetBuild("brilliance_projectile_fx")
        inst.AnimState:PlayAnimation("blast1")

        -- 应用元素颜色
        local color = ELEMENT_COLORS[element] or ELEMENT_COLORS.grass
        inst.AnimState:SetMultColour(color.r * 0.9 + 0.1, color.g * 0.9 + 0.1, color.b * 0.9 + 0.1, 1)
        inst.AnimState:SetSymbolMultColour("light_bar", color.r * 0.85 + 0.15, color.g * 0.85 + 0.15, color.b * 0.85 + 0.15, .5)
        inst.AnimState:SetSymbolBloom("light_bar")
        inst.AnimState:SetSymbolBloom("glow")
        inst.AnimState:SetLightOverride(.5)

        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        if math.random() < 0.5 then
            inst.AnimState:PlayAnimation("blast2")
        end

        inst:ListenForEvent("animover", inst.Remove)
        inst.persists = false

        inst.PushFlash = function(inst, target)
            inst.target = target
            local color = ELEMENT_COLORS[element] or ELEMENT_COLORS.grass
            PushColour(inst, color.r * 0.05, color.g * 0.15, color.b * 0.05)
            inst:DoTaskInTime(4 * FRAMES, PushColour, color.r * 0.04, color.g * 0.12, color.b * 0.04)
            inst:DoTaskInTime(7 * FRAMES, PushColour, color.r * 0.03, color.g * 0.08, color.b * 0.03)
            inst:DoTaskInTime(9 * FRAMES, PushColour, color.r * 0.01, color.g * 0.04, color.b * 0.01)
            inst:DoTaskInTime(10 * FRAMES, PopColour)
            inst.OnRemoveEntity = PopColour
        end

        return inst
    end
end

-- 生成所有元素的预制件
local prefabs = {}
for element, _ in pairs(ELEMENT_COLORS) do
    table.insert(prefabs, Prefab("dst_gi_nahida_brilliance_projectile_fx_" .. element, CreateProjectileFn(element), assets, {"dst_gi_nahida_brilliance_projectile_blast_fx_" .. element}))
    table.insert(prefabs, Prefab("dst_gi_nahida_brilliance_projectile_blast_fx_" .. element, CreateBlastFn(element), assets))
end

return unpack(prefabs)