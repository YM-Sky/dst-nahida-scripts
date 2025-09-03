---
--- fx_dst_gi_nahida_wormwood_plant.lua
--- Description: 纳西妲植物人开花效果
--- Author: 没有小钱钱
--- Date: 2025/4/25 2:44
---
local assets =
{
    Asset("ANIM", "anim/dst_gi_nahida_wormwood_plant_fx.zip"),
}

local function OnAnimOver(inst)
    if inst.AnimState:IsCurrentAnimation("ungrow_"..tostring(inst.variation)) then
        inst:Remove()
    else
        local x, y, z = inst.Transform:GetWorldPosition()
        for i, v in ipairs(AllPlayers) do
            if v.fullbloom and
                    v:HasTag("plantkin") and
                    not (v.components.health:IsDead() or v:HasTag("playerghost")) and
                    v.entity:IsVisible() and
                    v:GetDistanceSqToPoint(x, y, z) < 4 then
                inst.AnimState:PlayAnimation("idle_"..tostring(inst.variation))
                return
            end
        end
        inst.AnimState:PlayAnimation("ungrow_"..inst.variation)
    end
end

local function SetVariation(inst, variation)
    if inst.variation ~= variation then
        inst.variation = variation
        inst.AnimState:PlayAnimation("grow_"..tostring(variation))
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("wormwood_plant_fx")
    inst:AddTag("dst_gi_nahida_wormwood_plant_fx")

    inst.AnimState:SetBuild("dst_gi_nahida_wormwood_plant_fx")
    inst.AnimState:SetBank("dst_gi_nahida_wormwood_plant_fx")
    inst.AnimState:PlayAnimation("grow_1")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.variation = 1
    inst.SetVariation = SetVariation

    inst:ListenForEvent("animover", OnAnimOver)
    inst.persists = false

    return inst
end

return Prefab("dst_gi_nahida_wormwood_plant_fx", fn, assets)
