---@diagnostic disable: unbalanced-assignments
---
--- , inject-fielddst_gi_nahida_thousand_floating_dreams.lua
--- , inject-fieldDescription, inject-field: 千叶浮梦
--- Author: 没有小钱钱
--- Date: 2025/3/26 2:32
---
local exclude_tags = { "INLIMBO", "companion", "wall", "abigail", "player", "chester", "zhijiang_hound" }
local assets = {
    Asset("ANIM", "anim/dst_gi_nahida_thousand_floating_dreams.zip"), --地上的动画
    Asset("ANIM", "anim/dst_gi_nahida_thousand_floating_dreams_swap.zip"), --手持动画
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_thousand_floating_dreams.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_thousand_floating_dreams.tex"),
}
-- 测试debug四个顶点用
local function SpawnDendroCoreAroundEntity(x, y, z)
    local dendro_core_fx = SpawnPrefab("dst_gi_nahida_dendro_core")
    if dendro_core_fx.components.dst_gi_nahida_dendro_core_data then
        dendro_core_fx.components.dst_gi_nahida_dendro_core_data:Init(20, 0)
    end
    -- 设置草原核生成位置
    dendro_core_fx.Transform:SetPosition(x, y, z)
end

--攻击特效
local function OnAttack(weapon, attacker, target)
    if not (attacker and attacker.components.health and target and target:IsValid()) then
        return
    end

    local attacker_pos = attacker:GetPosition()
    local attacker_angle = attacker.Transform:GetRotation()

    -- 创建攻击特效实体
    local effect = SpawnPrefab("dst_gi_nahida_attack_ground")
    if effect then
        effect.Transform:SetPosition(attacker_pos:Get())
        effect.Transform:SetRotation(attacker_angle - 90)
        effect.AnimState:PlayAnimation("idle")
        effect.flowers = {}  -- 新增：用于记录所有花花
        effect:ListenForEvent("animover", function()
            if effect.flowers then
                for _, flower in ipairs(effect.flowers) do
                    if flower and flower:IsValid() then
                        flower:Remove()
                    end
                end
                effect.flowers = nil
            end
            effect:Remove()
        end)
    end
    local new_attacker_angle = effect.Transform:GetRotation()
    -- 设置矩形攻击范围参数
    local RECT_LENGTH = 10
    local RECT_WIDTH = 4
    local DAMAGE = weapon.components.weapon.damage or 10

    -- 计算矩形的四个顶点
    local half_width = RECT_WIDTH / 2
    local polygon = {
        -- 左前点
        { attacker_pos.x - half_width, attacker_pos.z },
        -- 右前点
        { attacker_pos.x + half_width, attacker_pos.z },
        -- 右后点
        { attacker_pos.x + half_width, attacker_pos.z + RECT_LENGTH },
        -- 左后点
        { attacker_pos.x - half_width, attacker_pos.z + RECT_LENGTH }
    }

    -- 根据玩家角度旋转所有顶点
    local angle = (-new_attacker_angle + 180) * DEGREES  -- 添加180度偏移
    for _, point in ipairs(polygon) do
        local dx = point[1] - attacker_pos.x
        local dz = point[2] - attacker_pos.z
        point[1] = attacker_pos.x + dx * math.cos(angle) - dz * math.sin(angle)
        point[2] = attacker_pos.z + dx * math.sin(angle) + dz * math.cos(angle)
    end

    -- 判断点是否在多边形内的函数
    local function isPointInSide(x, z, pos)
        local inside = false
        local n = #pos
        for i = 1, n do
            local j = (i % n) + 1
            if ((pos[i][2] > z) ~= (pos[j][2] > z)) and (x < (pos[j][1] - pos[i][1]) * (z - pos[i][2]) / (pos[j][2] - pos[i][2]) + pos[i][1]) then
                inside = not inside
            end
        end
        return inside
    end

    -- 1. 生成矩形内的花花特效
    local function lerp(a, b, t)
        return a + (b - a) * t
    end

    local flower_count = 6  -- 你可以根据需要调整数量
    local min_offset = -0.5
    local max_offset = 0.5

    for i = 1, flower_count do
        -- 采用双线性插值，保证分布均匀
        local u = (i - 1) / (flower_count - 1)  -- [0,1] 线性分布
        local v = math.random()  -- [0,1] 随机分布，增加自然感

        -- 计算矩形内的点
        local x1 = lerp(polygon[1][1], polygon[2][1], u)
        local z1 = lerp(polygon[1][2], polygon[2][2], u)
        local x2 = lerp(polygon[4][1], polygon[3][1], u)
        local z2 = lerp(polygon[4][2], polygon[3][2], u)

        local x = lerp(x1, x2, v)
        local z = lerp(z1, z2, v)

        -- 加一点小的随机偏移
        local offset_x = math.random() * (max_offset - min_offset) + min_offset
        local offset_z = math.random() * (max_offset - min_offset) + min_offset
        x = x + offset_x
        z = z + offset_z

        -- 判断是否在多边形内
        if isPointInSide(x, z, polygon) then
            local flower = SpawnPrefab("dst_gi_nahida_wormwood_plant_fx")
            if flower then
                flower.Transform:SetPosition(x, attacker_pos.y, z)
                flower.Transform:SetScale(1.5, 1.5, 1.5)
                -- 可以随机设置花的样式
                if flower.SetVariation then
                    flower:SetVariation(math.random(1, 3)) -- 假设有3种样式
                end
                -- 关键：设置 parent，方便 effect 移除时自动清理
                --flower.entity:SetParent(effect.entity)
                -- 记录到表
                table.insert(effect.flowers, flower)
            end
        end
    end

    -- 获取范围内的实体
    local ents = TheSim:FindEntities(
            attacker_pos.x, attacker_pos.y, attacker_pos.z,
            RECT_LENGTH + 1,
            { "_combat" },
            exclude_tags
    )

    -- 检查每个实体
    for _, ent in pairs(ents) do
        if ent ~= attacker and ent ~= target  and ent.components.health
                and not ent.components.health:IsDead()
                and ent.components.combat then
            local target_pos = ent:GetPosition()
            if isPointInSide(target_pos.x, target_pos.z, polygon) then
                --ent.components.combat:GetAttacked(attacker, DAMAGE, weapon)
                attacker:PushEvent("onattackother",{target = ent, weapon = weapon, projectile = attacker,is_skill = true})
            end
        end
    end
end

local function onequip(inst, owner)
    if not owner:HasTag(TUNING.AVATAR_NAME) then
        owner:DoTaskInTime(0, function()
            owner.components.inventory:DropItem(inst)
            if inst.components.talker then
                inst.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_NOT_BELONGING)
            end
        end)
        return
    end
    if inst.components.weapon and owner.components.dst_gi_nahida_data then
        inst.components.weapon:SetDamage(20 + owner.components.dst_gi_nahida_data:GetDamageData())  --设置伤害
    end

    if inst.follower ~= nil then
        inst.follower:Remove()
        inst.follower = nil
    end
    -- 放个不存在的通道，隐藏手上的武器
    owner.AnimState:OverrideSymbol("swap_object", "swap_wuqi", "swap_wuqi")

    owner.xietong_follower = inst
    if inst.follower == nil and (inst.whether_to_follow ~= nil and not inst.whether_to_follow) then
        inst.follower = SpawnPrefab("dst_gi_nahida_thousand_floating_dreams_follower")
        inst.follower.tldl_owner = owner
        local radian = PI / 180
        local x, y, z = inst.Transform:GetWorldPosition()
        inst.follower.Transform:SetPosition(x - 2 * math.cos(math.random(0, 180) * radian), y,
                z + 2 * math.sin(math.random(-90, 90) * radian))
        inst.follower.trail_fx = SpawnPrefab("fx_dst_gi_nahida_weapon_staff")
        if inst.follower.trail_fx then
            inst.follower.trail_fx.entity:SetParent(inst.follower.entity)  -- 跟随武器
            inst.follower.trail_fx.Transform:SetPosition(0, -2.5, 0)
            inst.follower.trail_fx.trail_active = true
        end
    end

    -- 🔥 学习火把的做法：创建特效数组
    if inst.weapon_effects == nil then
        inst.weapon_effects = {}
        -- 2. 创建光源特效（学习火把torchfire的做法）
        local light_fx = SpawnPrefab("fx_nahida_weapon_light")
        if light_fx then
            light_fx.entity:SetParent(owner.entity)    -- 🔥 关键：父实体设为玩家
            light_fx.entity:AddFollower()
            light_fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, 0, 0)  -- 跟随武器位置
            light_fx:AttachLightTo(owner)             -- 🔥 关键：光源附加到玩家身上
            table.insert(inst.weapon_effects, light_fx)
        end
    end
end

local function onunequip(inst, owner)
    if inst.follower ~= nil then
        -- 先处理 trail_fx
        if inst.follower.trail_fx ~= nil then
            inst.follower.trail_fx:Remove()
            inst.follower.trail_fx = nil
        end
        -- 再移除 follower
        inst.follower:Remove()
        inst.follower = nil
    end
    if inst.components.weapon then
        inst.components.weapon:SetDamage(20)      --设置伤害
    end
    -- 🔥 学习火把的做法：清理所有特效
    if inst.weapon_effects ~= nil then
        -- 先移除光源，再移除特效
        for i, fx in ipairs(inst.weapon_effects) do
            if fx.RemoveLightFrom then
                fx:RemoveLightFrom(owner)  -- 移除玩家身上的光源
            end
            fx:Remove()
        end
        inst.weapon_effects = nil
    end
end

--保存数据
local function OnSave(inst, data)
    data.whether_to_follow = inst.whether_to_follow
end

--加载数据
local function OnLoad(inst, data)
    if data and data.whether_to_follow ~= nil then
        inst.whether_to_follow = data.whether_to_follow
        inst.net_dst_gi_nahida_thousand_floating_dreams_whether_to_follow:set(inst.whether_to_follow)
    end
end
-- 上面这俩装备函数是给实际的法器装备的
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.75)                   --漂浮

    inst.AnimState:SetBank("dst_gi_nahida_thousand_floating_dreams") --地上动画
    inst.AnimState:SetBuild("dst_gi_nahida_thousand_floating_dreams")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    inst:AddTag(TUNING.AVATAR_NAME)
    inst:AddTag(TUNING.AVATAR_NAME.."_normal_attack")
    inst:AddTag("meteor_protection") --防止被流星破坏
    inst:AddTag("nosteal")           --防止被火药猴偷走
    inst:AddTag("NORATCHECK")        --mod兼容：永不妥协。该道具不算鼠潮分
    inst:AddTag("shoreonsink")       --不掉深渊
    inst:AddTag("tornado_nosucky")   --mod兼容：永不妥协。不会被龙卷风刮走
    inst:AddTag("hide_percentage")   -- 隐藏百分比
    --inst:AddTag("truedamage")   -- 真实伤害
    inst:AddTag("rangedweapon")
    inst:AddTag("magicweapon")
    inst:AddTag("dst_gi_nahida_thousand_floating_dreams_follower")
    inst.projectiledelay = FRAMES

    inst.net_dst_gi_nahida_thousand_floating_dreams_whether_to_follow = net_bool(inst.GUID, "net_dst_gi_nahida_thousand_floating_dreams_whether_to_follow")
    local old_GetDisplayName = inst.GetDisplayName
    inst.GetDisplayName = function(self,...)
        local whether_to_follow = inst.net_dst_gi_nahida_thousand_floating_dreams_whether_to_follow:value()
        if whether_to_follow == nil or whether_to_follow == "" then
            whether_to_follow = false
        end
        local str = ""
        str = str.."\r\n"..STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_THOUSAND_FLOATING_DREAMS_WHETHER_TO_FOLLOW_MODE_DESC .. ":" ..
                STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_THOUSAND_FLOATING_DREAMS_WHETHER_TO_FOLLOW_MODE[tostring(whether_to_follow)]
                or "N/A"
        return old_GetDisplayName(self,...)
                ..str
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")          --增加武器组件 有了这个才可以打人
    inst.components.weapon:SetDamage(20) --设置伤害
    inst.components.weapon:SetRange(8)
    inst.components.weapon:SetOnAttack(OnAttack)
    --inst.components.weapon:SetProjectile("kokomi_danmu")

    inst:AddComponent("inspectable")                                                                              --可检查组件
    inst:AddComponent("dst_gi_nahida_actions_data")                                                                              --可检查组件

    inst:AddComponent("inventoryitem")                                                                            --物品组件
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dst_gi_nahida_thousand_floating_dreams.xml" --物品贴图

    inst:AddComponent("equippable")                                                                               --可装备组件
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.walkspeedmult =  1.25
    inst.components.equippable.restrictedtag = TUNING.AVATAR_NAME

    MakeHauntableLaunchAndDropFirstItem(inst)

    inst.whether_to_follow = false

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

-- 下面这个实体的代码是身后跟随的特效
local function tldlbookfollwer_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeFlyingCharacterPhysics(inst, 8, .75)

    inst.AnimState:SetBank("dst_gi_nahida_thousand_floating_dreams")
    inst.AnimState:SetBuild("dst_gi_nahida_thousand_floating_dreams")
    inst.AnimState:PlayAnimation("follower")
    inst.AnimState:SetScale(0.8, 0.8, 0.8)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("punch")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    local radian = PI / 180
    inst.followtask = inst:DoPeriodicTask(1 / 20, function()
        if inst.tldl_owner ~= nil then
            local x, _, z = inst.tldl_owner.Transform:GetWorldPosition()
            local angle = inst.tldl_owner.Transform:GetRotation()
            local x1 = x - math.cos(angle * radian) * 1.5
            local z1 = z + math.sin(angle * radian) * 1.5
            local x2, _, z2 = inst.Transform:GetWorldPosition()
            
            -- 检查距离是否超过4格，如果超过则直接传送到玩家旁边
            local distance = math.sqrt((x2 - x) * (x2 - x) + (z2 - z) * (z2 - z))
            if distance > 4 then
                inst.Physics:Stop()
                inst.Transform:SetPosition(x1, _, z1)
            else
                inst.Physics:SetMotorVel(inst.tldl_owner.components.locomotor:GetRunSpeed(), 0, 0)
                inst:FacePoint(Vector3(x1, 0, z1))

                if (x2 - x1) * (x2 - x1) + (z2 - z1) * (z2 - z1) <= 0.1 then
                    inst.Physics:Stop()
                    inst.Transform:SetPosition(x1, _, z1)
                end
            end
        else
            if inst.followtask ~= nil then
                inst.followtask:Cancel()
                inst.followtask = nil
            end
        end
    end)

    return inst
end

return Prefab("dst_gi_nahida_thousand_floating_dreams_follower", tldlbookfollwer_fn, assets),
Prefab("dst_gi_nahida_thousand_floating_dreams", fn, assets)
