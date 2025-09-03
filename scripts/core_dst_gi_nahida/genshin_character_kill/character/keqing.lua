---
--- keqing.lua
--- Description: 刻晴技能
--- Author: 旅行者
--- Date: 2025/8/3 18:29
---

local exclude_tags = {"INLIMBO", "companion", "wall", "abigail", "player", "chester", "zhijiang_hound"}

--local function fryfish(inst, radius)
--    if TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.KEQING then
--        local x, y, z = inst.Transform:GetWorldPosition()
--        local ent0 = TheSim:FindEntities(x, y, z, radius)
--        for i, ent in ipairs(ent0) do
--            if ent:HasTag("fish") or ent:HasTag("fishmeat") or ent.prefab == "fish_cooked" or ent.prefab == "fish" then
--                if not ent:HasTag("INLIMBO") then
--                    local fishpos = ent:GetPosition()
--                    local kq_specialfish = SpawnPrefab("kq_specialfish")
--                    if kq_specialfish then
--                        kq_specialfish.Transform:SetPosition(fishpos:Get())
--                        if kq_specialfish.components.stackable then
--                            local item_count = ent.components.stackable and ent.components.stackable:StackSize() or 1
--                            kq_specialfish.components.stackable:SetStackSize(item_count)
--                        end
--                    end
--                    ent:Remove()
--                end
--            end
--        end
--    end
--end
local function fryfish(inst, radius)
    if TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.KEQING then
        local x, y, z = inst.Transform:GetWorldPosition()
        local ent0 = TheSim:FindEntities(x, y, z, radius)
        local total_fish_count = 0
        local fish_positions = {}
        -- 先统计所有鱼的数量和位置
        for i, ent in ipairs(ent0) do
            if ent:HasTag("fish") or ent:HasTag("fishmeat") or ent.prefab == "fish_cooked" or ent.prefab == "fish" then
                if not ent:HasTag("INLIMBO") then
                    local item_count = ent.components.stackable and ent.components.stackable:StackSize() or 1
                    total_fish_count = total_fish_count + item_count
                    table.insert(fish_positions, ent:GetPosition())
                    ent:Remove()
                end
            end
        end

        -- 如果有鱼被转换，生成一个堆叠的特殊鱼
        if total_fish_count > 0 then
            local spawn_pos = fish_positions[1] or Vector3(x, y, z) -- 使用第一条鱼的位置或玩家位置
            local kq_specialfish = SpawnPrefab("kq_specialfish")
            if kq_specialfish then
                kq_specialfish.Transform:SetPosition(spawn_pos:Get())
                if kq_specialfish.components.stackable and total_fish_count > 1 then
                    kq_specialfish.components.stackable:SetStackSize(total_fish_count)
                end
            end
        end
    end
end

local burst_cd = 12

local keqing = {
    dst_gi_nahida_keqing_burst_card = {
        title = STRINGS.DST_GI_CHARACTER_LIST.KEQING.BURST,
        enable = TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.KEQING,
        atlas = "images/inventoryimages/dst_gi_nahida_keqing_burst_card.xml",
        image = "dst_gi_nahida_keqing_burst_card.tex",
        cd = burst_cd,
        -- 长按技能
        long_press_fn = nil,
        -- 点按技能
        fn = function(inst)
            if inst.components.timer:TimerExists("KEQING_BURST") then
                if inst.components.talker then
                    inst.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CURRENT_CD)
                end
                return false
            end
            if inst ~= nil and inst:IsValid() and inst.components.health and not inst.components.health:IsDead() then
                if not inst.sg:HasStateTag("busy") and not (inst.components.rider ~= nil and inst.components.rider:IsRiding()) then
                    local weapon = inst.components.inventory.equipslots[EQUIPSLOTS.HANDS]
                    if weapon == nil or not weapon.components.weapon then
                        if inst.components.talker then
                            inst.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_NOT_EQUIP_WEAPON)
                        end
                        return false
                    end
                    if inst.kq_tjxytask == nil then
                        if inst.components.talker then
                            if math.random() <= 0.5 then
                                inst.components.talker:Say("剑光如我，斩尽芜杂！")
                            else
                                inst.components.talker:Say("剑出，影随！")
                            end
                        end
                        inst.components.timer:StartTimer("KEQING_BURST", burst_cd)
                        inst:AddTag("heavyarmor")
                        inst.components.health:SetInvincible(true)
                        -- 记录原始位置
                        local origin_x, origin_y, origin_z = inst.Transform:GetWorldPosition()

                        -- 五角星顶点计算（半径6）
                        local radius = 8
                        local star_points = {}
                        for i = 1, 5 do
                            local angle = (i - 1) * 72 * DEGREES -- 五角星每个角72度
                            local px = origin_x + radius * math.cos(angle)
                            local pz = origin_z + radius * math.sin(angle)
                            table.insert(star_points, {x = px, y = origin_y, z = pz})
                        end

                        -- 五角星连线顺序：1->3->5->2->4->1（画出五角星）
                        local star_sequence = {1, 3, 5, 2, 4, 1}

                        -- 生成初始特效
                        SpawnPrefab("lightning").Transform:SetPosition(origin_x, origin_y, origin_z)
                        SpawnPrefab("dst_gi_nahida_kq_burst_fx").Transform:SetPosition(origin_x, origin_y, origin_z)

                        local attack_count = 0
                        inst.kq_tjxytask = inst:DoPeriodicTask(0.2, function(inst)
                            attack_count = attack_count + 1
                            -- 前6段：按五角星连线顺序移动 1->3->5->2->4->1
                            if attack_count <= 6 then
                                local point_index = star_sequence[attack_count]
                                local point = star_points[point_index]
                                inst.Transform:SetPosition(point.x, point.y, point.z)
                                --SpawnPrefab("lightning").Transform:SetPosition(point.x, point.y, point.z)
                                -- 第7段：回到原点
                            elseif attack_count == 7 then
                                inst.Transform:SetPosition(origin_x, origin_y, origin_z)
                                --SpawnPrefab("lightning").Transform:SetPosition(origin_x, origin_y, origin_z)
                                -- 第8-10段：在原点附近随机攻击
                            elseif attack_count <= 10 then
                                local random_angle = math.random() * 360 * DEGREES
                                local random_radius = math.random() * 2 -- 小范围随机
                                local px = origin_x + random_radius * math.cos(random_angle)
                                local pz = origin_z + random_radius * math.sin(random_angle)
                                inst.Transform:SetPosition(px, origin_y, pz)
                                --SpawnPrefab("lightning").Transform:SetPosition(px, origin_y, pz)
                            end

                            -- 结束技能
                            if attack_count > 10 then
                                if inst.kq_tjxytask ~= nil then
                                    inst.kq_tjxytask:Cancel()
                                    inst.kq_tjxytask = nil
                                end
                                inst:RemoveTag("heavyarmor")
                                inst.components.health:SetInvincible(false)
                                fryfish(inst, 10)
                                return true
                            end
                            -- 计算倍率
                            local mult = 0.51
                            if attack_count == 1 then
                                mult = 1.87
                            elseif attack_count == 10 then
                                mult = 4.01
                            end
                            -- 当前位置攻击
                            local curr_x, curr_y, curr_z = inst.Transform:GetWorldPosition()
                            local ents = TheSim:FindEntities(curr_x, curr_y, curr_z, 10, {"_combat"}, exclude_tags)
                            for i, ent in ipairs(ents) do
                                if ent ~= nil and ent:IsValid() and ent.components.health and not ent.components.health:IsDead()
                                and not (ent.components.follower and ent.components.follower.leader ~= nil
                                        and ent.components.follower.leader:HasTag("player")
                                        and (ent.prefab == "pigman"
                                        or ent:HasTag("merm_npc")
                                        or ent:HasTag("spider")
                                ))
                                    and not (ent:HasTag("beehive")  -- 蜂窝
                                )
                                then
                                    AddDstGiNahidaElementalReactionComponents(inst,ent)
                                    local current_weapon = inst.components.inventory and inst.components.inventory.equipslots[EQUIPSLOTS.HANDS] or nil
                                    if ent.components.dst_gi_nahida_elemental_reaction then
                                        ent.components.dst_gi_nahida_elemental_reaction:DoAttack("ThunderAttack","strong",inst,ent,current_weapon,mult,true)
                                    else
                                        inst.components.combat:DoAttack(ent, current_weapon, nil, nil, mult)
                                    end
                                end
                            end
                        end)
                        return true
                    end
                end

            end
            return false
        end
    }
}

return keqing