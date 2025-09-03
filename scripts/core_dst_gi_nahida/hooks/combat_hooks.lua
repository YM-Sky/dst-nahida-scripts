---
--- combat_hooks.lua
--- Description: 敌对生物不会主动攻击角色重写事件
--- Author: 没有小钱钱
--- Date: 2025/4/11 22:44
---
--local Combat = require "components/combat"
-- 定义一个假的 SetTarget 函数，用于拦截目标设置

-- 直接修改核心函数，不使用临时替换
AddComponentPostInit("combat", function(combat)
    local oldSetTarget = combat.SetTarget
    function combat:SetTarget(target, ...)
        if target and target:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NOT_HATRED) then
            return
        end
        return oldSetTarget(self, target, ...)
    end

    -- 修改 IsValidTarget 更安全
    local oldIsValidTarget = combat.IsValidTarget
    function combat:IsValidTarget(target, ...)
        if target and target:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NOT_HATRED) then
            return false
        end
        return oldIsValidTarget(self, target, ...)
    end

    -- 新增：真实伤害hook
    local oldGetAttacked = combat.GetAttacked
    function combat:GetAttacked(attacker, damage, weapon, stimuli, spdamage)
        -- 检查武器是否有真实伤害标签
        if weapon ~= nil and weapon:HasTag("truedamage") and damage ~= nil and damage > 0 then
            if self.inst.components.health ~= nil and not self.inst.components.health:IsDead() then
                self.lastwasattackedtime = GetTime()
                self.lastattacker = attacker
                -- 直接扣血，绕过所有护甲计算
                local damageresolved = self.inst.components.health:DoDelta(-damage, nil,
                        attacker and (attacker.nameoverride or attacker.prefab) or "NIL", true, attacker,true)
                damageresolved = damageresolved ~= nil and -damageresolved or damage
                -- 触发attacked事件
                self.inst:PushEvent("attacked", {
                    attacker = attacker,
                    damage = damage,
                    damageresolved = damageresolved,
                    original_damage = damage,
                    weapon = weapon,
                    stimuli = stimuli,
                    spdamage = spdamage
                })

                -- 检查死亡
                if self.inst.components.health:IsDead() then
                    if attacker ~= nil then
                        attacker:PushEvent("killed", { victim = self.inst, attacker = attacker })
                    end
                    if self.onkilledbyother ~= nil then
                        self.onkilledbyother(self.inst, attacker)
                    end
                end
                return true -- 攻击成功
            end
        end

        -- 否则调用原方法
        return oldGetAttacked(self, attacker, damage, weapon, stimuli, spdamage)
    end
end)

-- childspawner 修改生成时的目标设置
AddComponentPostInit("childspawner", function(childspawner)
    local oldTakeOwnership = childspawner.TakeOwnership
    function childspawner:TakeOwnership(child, ...)
        local result = oldTakeOwnership(self, child, ...)
        -- 生成后立即清除对受保护玩家的仇恨
        if child and child.components.combat then
            local target = child.components.combat.target
            if target and target:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_NOT_HATRED) then
                child.components.combat:SetTarget(nil)
            end
        end
        return result
    end
end)