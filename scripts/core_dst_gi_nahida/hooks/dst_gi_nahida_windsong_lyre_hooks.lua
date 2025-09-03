---
--- dst_gi_nahida_windsong_lyre_hooks.lua
--- Description: 风物之诗琴
--- Author: 没有小钱钱
--- Date: 2025/5/24 22:42
---


local function ShouldRepeatCast(inst, doer)
    --doer是施法者
    return true
end

local function StartAOETargeting(inst)
    --照抄
    if ThePlayer.components.playercontroller then
        ThePlayer.components.playercontroller:StartAOETargetingUsing(inst)
    end
end

local function SpellFn(inst, doer, pos)
    --inst为可以呼出轮盘的物体。本来应该是老麦的书、威洛的余烬等，但此模板用按键呼出轮盘，因此inst为玩家自身。doer为施法者即玩家，pos为施法坐标
    --你需要执行的函数
    return true
end

local function ReticuleTargetFn()
    -- 添加更严格的安全检查
    if not ThePlayer or not ThePlayer.entity or not ThePlayer:IsValid() then
        print("ReticuleTargetFn: ThePlayer无效")
        return Vector3(0, 0, 0)
    end
    -- 确保Transform存在
    if not ThePlayer.Transform then
        print("ReticuleTargetFn: ThePlayer.Transform无效")
        return Vector3(0, 0, 0)
    end
    local x, y, z = ThePlayer.Transform:GetWorldPosition()
    if not x or not y or not z then
        print("ReticuleTargetFn: GetWorldPosition返回nil")
        return Vector3(0, 0, 0)
    end
    -- 使用Transform而不是entity:LocalToWorldSpace
    local forward_x = math.cos(ThePlayer.Transform:GetRotation() * DEGREES)
    local forward_z = -math.sin(ThePlayer.Transform:GetRotation() * DEGREES)

    return Vector3(x + forward_x * 6.5, 0, z + forward_z * 6.5)
end

local function ReticuleMouseTargetFn(inst, mousepos)
    -- 添加更严格的安全检查
    if not inst or not inst:IsValid() or not inst.Transform then
        print("ReticuleMouseTargetFn: inst无效")
        return Vector3(0, 0, 0)
    end

    if not mousepos then
        print("ReticuleMouseTargetFn: mousepos为nil")
        return Vector3(0, 0, 0)
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if not x or not y or not z then
        print("ReticuleMouseTargetFn: GetWorldPosition返回nil")
        return Vector3(0, 0, 0)
    end

    local dx = mousepos.x - x
    local dz = mousepos.z - z
    local l = dx * dx + dz * dz
    if l <= 0 then
        return inst.components.reticule and inst.components.reticule.targetpos or Vector3(x, 0, z)
    end
    l = 6.5 / math.sqrt(l)
    return Vector3(x + dx * l, 0, z + dz * l)
end

local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
    --（这个为线条指示器、女武神盾牌指示器）
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt ~= nil then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)
end

local SPELLS = {}

local SPELLS_NEW = {
    {
        id = STRINGS.NAMES.DST_GI_NAHIDA_MELODY_OF_THE_GREAT_DREAM,
        name = STRINGS.NAMES.DST_GI_NAHIDA_MELODY_OF_THE_GREAT_DREAM,
        spellFn = function(inst, doer, pos)
            if not doer:HasTag(TUNING.AVATAR_NAME) then
                if doer.components.talker then
                    doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_NOT_BELONGING)
                end
                return false
            end
            if inst.components.dst_gi_nahida_windsong_lyre_data then
                return inst.components.dst_gi_nahida_windsong_lyre_data:SelectMusicScore(doer,inst,"dst_gi_nahida_melody_of_the_great_dream")
            end
            return false
        end,
        atlas = "images/inventoryimages/dst_gi_nahida_melody_of_the_great_dream.xml",
        normal = "dst_gi_nahida_melody_of_the_great_dream.tex",
        widget_scale = 0.6
    },
    {
        id = STRINGS.NAMES.DST_GI_NAHIDA_HUANMO_CHANT,
        name = STRINGS.NAMES.DST_GI_NAHIDA_HUANMO_CHANT,
        spellFn = function(inst, doer, pos)
            if not doer:HasTag(TUNING.AVATAR_NAME) then
                if doer.components.talker then
                    doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_NOT_BELONGING)
                end
                return false
            end
            if inst.components.dst_gi_nahida_windsong_lyre_data then
                return inst.components.dst_gi_nahida_windsong_lyre_data:SelectMusicScore(doer,inst,"dst_gi_nahida_huanmo_chant")
            end
            return false
        end,
        atlas = "images/inventoryimages/dst_gi_nahida_huanmo_chant.xml",
        normal = "dst_gi_nahida_huanmo_chant.tex",
        widget_scale = 0.6
    },
    {
        id = STRINGS.NAMES.DST_GI_NAHIDA_PATH_OF_SHADOWS_TUNE,
        name = STRINGS.NAMES.DST_GI_NAHIDA_PATH_OF_SHADOWS_TUNE,
        spellFn = function(inst, doer, pos)
            if not doer:HasTag(TUNING.AVATAR_NAME) then
                if doer.components.talker then
                    doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_NOT_BELONGING)
                end
                return false
            end
            if inst.components.dst_gi_nahida_windsong_lyre_data then
                return inst.components.dst_gi_nahida_windsong_lyre_data:SelectMusicScore(doer,inst,"dst_gi_nahida_path_of_shadows_tune")
            end
            return false
        end,
        atlas = "images/inventoryimages/dst_gi_nahida_path_of_shadows_tune.xml",
        normal = "dst_gi_nahida_path_of_shadows_tune.tex",
        widget_scale = 0.6
    },
    {
        id = STRINGS.NAMES.DST_GI_NAHIDA_BEAST_TRAIL_MELODY,
        name = STRINGS.NAMES.DST_GI_NAHIDA_BEAST_TRAIL_MELODY,
        spellFn = function(inst, doer, pos)
            if not doer:HasTag(TUNING.AVATAR_NAME) then
                if doer.components.talker then
                    doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_NOT_BELONGING)
                end
                return false
            end
            if inst.components.dst_gi_nahida_windsong_lyre_data then
                return inst.components.dst_gi_nahida_windsong_lyre_data:SelectMusicScore(doer,inst,"dst_gi_nahida_beast_trail_melody")
            end
            return false
        end,
        atlas = "images/inventoryimages/dst_gi_nahida_beast_trail_melody.xml",
        normal = "dst_gi_nahida_beast_trail_melody.tex",
        widget_scale = 0.6
    },
    {
        id = STRINGS.NAMES.DST_GI_NAHIDA_SPROUT_SONG,
        name = STRINGS.NAMES.DST_GI_NAHIDA_SPROUT_SONG,
        spellFn = function(inst, doer, pos)
            if not doer:HasTag(TUNING.AVATAR_NAME) then
                if doer.components.talker then
                    doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_NOT_BELONGING)
                end
                return false
            end
            if inst.components.dst_gi_nahida_windsong_lyre_data then
                return inst.components.dst_gi_nahida_windsong_lyre_data:SelectMusicScore(doer,inst,"dst_gi_nahida_sprout_song")
            end
            return false
        end,
        atlas = "images/inventoryimages/dst_gi_nahida_sprout_song.xml",
        normal = "dst_gi_nahida_sprout_song.tex",
        widget_scale = 0.6
    },
    {
        id = STRINGS.NAMES.DST_GI_NAHIDA_SOURCEWATER_HYMN,
        name = STRINGS.NAMES.DST_GI_NAHIDA_SOURCEWATER_HYMN,
        spellFn = function(inst, doer, pos)
            if not doer:HasTag(TUNING.AVATAR_NAME) then
                if doer.components.talker then
                    doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_NOT_BELONGING)
                end
                return false
            end
            if inst.components.dst_gi_nahida_windsong_lyre_data then
                return inst.components.dst_gi_nahida_windsong_lyre_data:SelectMusicScore(doer,inst,"dst_gi_nahida_sourcewater_hymn")
            end
            return false
        end,
        atlas = "images/inventoryimages/dst_gi_nahida_sourcewater_hymn.xml",
        normal = "dst_gi_nahida_sourcewater_hymn.tex",
        widget_scale = 0.6
    },
    {
        id = STRINGS.NAMES.DST_GI_NAHIDA_REVIVAL_CHANT,
        name = STRINGS.NAMES.DST_GI_NAHIDA_REVIVAL_CHANT,
        spellFn = function(inst, doer, pos)
            if not doer:HasTag(TUNING.AVATAR_NAME) then
                if doer.components.talker then
                    doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_NOT_BELONGING)
                end
                return false
            end
            if inst.components.dst_gi_nahida_windsong_lyre_data then
                return inst.components.dst_gi_nahida_windsong_lyre_data:SelectMusicScore(doer,inst,"dst_gi_nahida_revival_chant")
            end
            return false
        end,
        atlas = "images/inventoryimages/dst_gi_nahida_revival_chant.xml",
        normal = "dst_gi_nahida_revival_chant.tex",
        widget_scale = 0.6
    }
}

local function ShouldOpenFn(inst, doer)
    -- 如果正在释放元素爆发，不打开界面
    if doer and doer.is_using_burst then
        return false
    end
    return true
end

local function InsertSpells(spells, new_spells)
    for _, new_spell in ipairs(new_spells) do
        table.insert(spells, {
            label = new_spell.id,
            onselect = function(inst)
                -- 移除手动启用代码，由 OnOpenFn 自动处理
                inst.components.spellbook:SetSpellName(new_spell.name)
                inst.components.spellbook:SetSpellAction(nil)
                inst.components.aoetargeting:SetDeployRadius(0)
                inst.components.aoetargeting:SetShouldRepeatCastFn(ShouldRepeatCast)

                inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoefiretarget_1"
                inst.components.aoetargeting.reticule.pingprefab = "reticuleaoefiretarget_1ping"

                inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
                inst.components.aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
                inst.components.aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
                inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
                inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
                inst.components.aoetargeting.reticule.ease = true
                inst.components.aoetargeting.reticule.mouseenabled = true

                if TheWorld.ismastersim then
                    inst.components.aoetargeting:SetTargetFX("reticuleaoehostiletarget_1d25")
                    inst.components.aoespell:SetSpellFn(new_spell.spellFn)
                    inst.components.spellbook:SetSpellFn(nil)
                end
            end,
            execute = StartAOETargeting,
            atlas = new_spell.atlas,
            normal = new_spell.normal,
            clicksound = "meta4/winona_UI/select",
            widget_scale = new_spell.widget_scale,
            checkenabled = function(user)
                return true
            end,
        })
    end
end

-- 将 SPELLS_NEW 插入到 SPELLS
InsertSpells(SPELLS, SPELLS_NEW)

AddPrefabPostInit("dst_gi_nahida_windsong_lyre", function(inst)
    inst:AddComponent("spellbook")
    inst.components.spellbook:SetRadius(120)
    inst.components.spellbook:SetFocusRadius(120)
    inst.components.spellbook:SetShouldOpenFn(ShouldOpenFn)
    inst.components.spellbook:SetItems(SPELLS)
    inst.components.spellbook.opensound = "meta5/woby/bigwoby_actionwheel_UI"

    -- 轮盘打开时启用 aoetargeting
    inst.components.spellbook:SetOnOpenFn(function(inst)
        if inst.components.aoetargeting then
            inst.components.aoetargeting:SetEnabled(true)
        end
    end)

    -- 轮盘关闭时禁用 aoetargeting
    inst.components.spellbook:SetOnCloseFn(function(inst)
        if inst.components.aoetargeting then
            inst.components.aoetargeting:SetEnabled(false)
        end
    end)

    -- 添加并完整配置 aoetargeting 组件
    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetAllowRiding(false)
    inst.components.aoetargeting:SetAlwaysValid(true) -- 确保位置总是有效
    inst.components.aoetargeting:SetRange(6.5) -- 设置瞄准范围

    -- 配置准星系统
    inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoefiretarget_1"
    inst.components.aoetargeting.reticule.pingprefab = "reticuleaoefiretarget_1ping"

    -- 设置目标函数 - 确保始终返回有效位置
    inst.components.aoetargeting.reticule.targetfn = function()
        if ThePlayer and ThePlayer:IsValid() and ThePlayer.Transform then
            local x, y, z = ThePlayer.Transform:GetWorldPosition()
            if x and y and z then
                local forward_x = math.cos(ThePlayer.Transform:GetRotation() * DEGREES)
                local forward_z = -math.sin(ThePlayer.Transform:GetRotation() * DEGREES)
                return Vector3(x + forward_x * 6.5, 0, z + forward_z * 6.5)
            end
        end
        return Vector3(0, 0, 0)
    end

    -- 设置鼠标目标函数
    inst.components.aoetargeting.reticule.mousetargetfn = function(inst, mousepos)
        if not inst or not inst:IsValid() or not inst.Transform then
            return Vector3(0, 0, 0)
        end

        if not mousepos then
            return Vector3(0, 0, 0)
        end

        local x, y, z = inst.Transform:GetWorldPosition()
        if not x or not y or not z then
            return Vector3(0, 0, 0)
        end

        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then
            return inst.components.reticule and inst.components.reticule.targetpos or Vector3(x, 0, z)
        end
        l = 6.5 / math.sqrt(l)
        return Vector3(x + dx * l, 0, z + dz * l)
    end

    -- 设置位置更新函数
    inst.components.aoetargeting.reticule.updatepositionfn = function(inst, pos, reticule, ease, smoothing, dt)
        if not inst or not inst.Transform or not pos or not reticule or not reticule.Transform then
            return
        end

        local x, y, z = inst.Transform:GetWorldPosition()
        reticule.Transform:SetPosition(x, 0, z)
        local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
        if ease and dt ~= nil then
            local rot0 = reticule.Transform:GetRotation()
            local drot = rot - rot0
            rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
        end
        reticule.Transform:SetRotation(rot)
    end

    -- 设置准星颜色和属性
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true
    inst.components.aoetargeting.reticule.mouseenabled = true

    if TheWorld.ismastersim then
        inst:AddComponent("aoespell")
        -- 设置目标特效
        inst.components.aoetargeting:SetTargetFX("reticuleaoehostiletarget_1d25")
    end
end)

-- 修复AOE瞄准系统的position计算
--AddComponentPostInit("playercontroller", function(self)
--    local old_GetAOETargetingPos = self.GetAOETargetingPos
--    function self:GetAOETargetingPos()
--        local pos = old_GetAOETargetingPos(self)
--        if not pos and self.reticule and self.reticule.targetpos then
--            -- 如果AOE瞄准位置为nil，使用reticule的目标位置
--            pos = self.reticule.targetpos
--        end
--        if not pos then
--            -- 最后的fallback，使用玩家位置
--            pos = self.inst:GetPosition()
--        end
--        return pos
--    end
--end)