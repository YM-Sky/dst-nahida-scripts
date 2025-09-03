-- 功能(无需修改): alt写的修改攻速模块
-- 修改 `TUNING.MOD_dst_gi_nahida.ATK_SPEED_ALT` 的值,来改变攻速
-- 写自萌萌的新(alt) 其他模组如果像使用可以随意使用代码 但请标明出处

AddComponentPostInit("playervision", function(self)
    local player = self.inst
    local doer = player
    local orangeperiod
    local function isAttackingSG(inst, statename)
        return statename == "attack" or inst.sg and inst.sg:HasStateTag("attack")
            and inst.sg:HasStateTag("abouttoattack")
    end
    doer:ListenForEvent("newstate", function(inst, data)
        if not inst.sg then return end
        local statename = data and data.statename
        if inst.dst_gi_nahida_remove_sgtag_task then
            inst.dst_gi_nahida_remove_sgtag_task:Cancel()
            inst.AnimState:SetDeltaTimeMultiplier(1)
            if orangeperiod then
                local combat = inst.components.combat or inst.replica.combat
                combat.min_attack_period = orangeperiod
            end
        end
        if isAttackingSG(inst, statename) then
            local timeout = inst.sg.timeout or 0.5 --防止某些模组没写timeout
            local combat = inst.components.combat or inst.replica.combat
            orangeperiod = orangeperiod or combat.min_attack_period or TUNING.WILSON_ATTACK_PERIOD
            local orange_attackspeed = 1 / timeout -- 2.5
            local new_attackspeed = orange_attackspeed * TUNING.MOD_DST_GI_NAHIDA.ATK_SPEED_ALT
            local newperiod = 1 / new_attackspeed
            combat.min_attack_period = newperiod
            inst.AnimState:SetDeltaTimeMultiplier(math.min(2.5, (new_attackspeed / orange_attackspeed)))
            inst.dst_gi_nahida_remove_sgtag_task = inst:DoTaskInTime(newperiod,
                function()
                    inst.sg:RemoveStateTag("attack")
                    inst.sg:AddStateTag("idle")
                    if TheWorld.ismastersim then
                        inst:PerformBufferedAction()
                    end
                    inst.sg:RemoveStateTag("abouttoattack")
                end)
        end
    end)
end)