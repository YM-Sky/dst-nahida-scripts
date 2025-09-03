---
--- fx_nahida_weapon_light.lua
--- Description: 纳西妲武器光源特效（类似torchfire）
--- Author: 没有小钱钱
---

local assets = {}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst.entity:SetPristine()
    inst.persists = false

    if not TheWorld.ismastersim then
        return inst
    end

    -- 光源组件
    inst.entity:AddLight()
    inst.Light:SetRadius(4)
    inst.Light:SetFalloff(.8)
    inst.Light:SetIntensity(.55)
    inst.Light:SetColour(144/255, 238/255, 144/255)

    -- 关键：AttachLightTo函数（修复版）
    inst.AttachLightTo = function(_inst, target)
        if target ~= nil then
            -- 🔥 关键修复：确保目标有Light组件
            if target.Light == nil then
                target.entity:AddLight()
            end
            -- 直接设置目标的光源参数（不使用lighttweener）
            target.Light:SetRadius(4)
            target.Light:SetFalloff(.8)
            target.Light:SetIntensity(.55)
            target.Light:SetColour(144/255, 238/255, 144/255)
            target.Light:Enable(true)  -- 确保光源开启
        end
    end

    -- 移除光源的函数
    inst.RemoveLightFrom = function(_inst, target)
        if target ~= nil and target.Light ~= nil then
            target.Light:Enable(false)  -- 关闭光源
        end
    end

    -- 设置光源亮度（技能系统调用）
    inst.SetLightRange = function(inst, range_multiplier)
        if inst.Light then
            local base_radius = 4
            inst.Light:SetRadius(base_radius * range_multiplier)
        end
    end
    return inst
end

return Prefab("fx_nahida_weapon_light", fn, assets)