----------------------------------------------------这一段为模板----------------------------------------------------

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

    local pos = Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
    if not pos then
        print("ReticuleTargetFn: LocalToWorldSpace返回nil")
        return Vector3(0, 0, 0)
    end

    return pos
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
        id = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.EXTRACTION_FATESEAT,
        name = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.EXTRACTION_FATESEAT,
        spellFn = function(inst, doer, pos)
            if doer:HasTag(TUNING.AVATAR_NAME) and doer.components.dst_gi_nahida_data then
                doer.components.dst_gi_nahida_data:ExtractionFateseat()
            end
            return true
        end,
        atlas = "images/inventoryimages/dst_gi_nahida_fateseat.xml",
        normal = "dst_gi_nahida_fateseat.tex",
        widget_scale = 0.6
    },
    {
        id = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.FIGHT,
        name = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.FIGHT,
        spellFn = function(inst, doer, pos)
            if doer:HasTag(TUNING.AVATAR_NAME) and doer.components.dst_gi_nahida_skill then
                doer.components.dst_gi_nahida_skill:SetSkillMode(doer, TUNING.MOD_DST_GI_NAHIDA.SKILL_MODE.FIGHT)
            end
            return true
        end,
        atlas = "images/spell_icons.xml",
        normal = "shadow_worker.tex",
        widget_scale = 0.6
    },
    {
        id = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.HARVEST,
        name = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.HARVEST,
        spellFn = function(inst, doer, pos)
            if doer:HasTag(TUNING.AVATAR_NAME) and doer.components.dst_gi_nahida_skill then
                doer.components.dst_gi_nahida_skill:SetSkillMode(doer, TUNING.MOD_DST_GI_NAHIDA.SKILL_MODE.HARVEST)
            end
            return true
        end,
        atlas = "images/spell_icons.xml",
        normal = "shadow_worker.tex",
        widget_scale = 0.6
    },
    {
        id = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.PICK_UP,
        name = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.PICK_UP,
        spellFn = function(inst, doer, pos)
            if doer:HasTag(TUNING.AVATAR_NAME) and doer.components.dst_gi_nahida_skill then
                doer.components.dst_gi_nahida_skill:SetSkillMode(doer, TUNING.MOD_DST_GI_NAHIDA.SKILL_MODE.PICK_UP)
            end
            return true
        end,
        atlas = "images/spell_icons.xml",
        normal = "shadow_worker.tex",
        widget_scale = 0.6
    },
    --{
    --    id = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.GROWTH,
    --    name = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SKILL_MODE.GROWTH,
    --    spellFn = function(inst, doer, pos)
    --        if doer:HasTag(TUNING.AVATAR_NAME) and doer.components.dst_gi_nahida_skill then
    --            doer.components.dst_gi_nahida_skill:SetSkillMode(doer, TUNING.MOD_DST_GI_NAHIDA.SKILL_MODE.GROWTH)
    --        end
    --        return true
    --    end,
    --    atlas = "images/spell_icons.xml",
    --    normal = "shadow_worker.tex",
    --    widget_scale = 0.6
    --},
    --{
    --    id = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION,
    --    name = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION,
    --    spellFn = function(inst, doer, pos)
    --        if doer:HasTag(TUNING.AVATAR_NAME) then
    --            if doer:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG) then
    --                doer:RemoveTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)
    --                if doer.components.talker then
    --                    doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_DISABLE_RIGHT_CLICK_ACTION)
    --                end
    --            else
    --                doer:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)
    --                if doer.components.talker then
    --                    doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_ENABLED_RIGHT_CLICK_ACTION)
    --                end
    --            end
    --        end
    --        return true
    --    end,
    --    atlas = "images/spell_icons.xml",
    --    normal = "shadow_worker.tex",
    --    widget_scale = 0.6
    --}
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
            label = new_spell.id, --标签，类似id，可以随意写但是不可以重复
            onselect = function(inst)
                inst.components.spellbook:SetSpellName(new_spell.name)--显示在轮盘上的名字
                inst.components.spellbook:SetSpellAction(nil)--照抄
                inst.components.aoetargeting:SetDeployRadius(0)
                inst.components.aoetargeting:SetShouldRepeatCastFn(ShouldRepeatCast)--是否可重复施法

                inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoefiretarget_1"
                inst.components.aoetargeting.reticule.pingprefab = "reticuleaoefiretarget_1ping"

                inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
                inst.components.aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
                inst.components.aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
                inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }--可以施法时指示器的颜色
                inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }--不能施法时指示器的颜色
                inst.components.aoetargeting.reticule.ease = true--线性，照抄就行
                inst.components.aoetargeting.reticule.mouseenabled = true--照抄就行

                if TheWorld.ismastersim then
                    inst.components.aoetargeting:SetTargetFX("reticuleaoehostiletarget_1d25")--施法目标点生成的特效
                    inst.components.aoespell:SetSpellFn(new_spell.spellFn)--执行的函数
                    inst.components.spellbook:SetSpellFn(nil)--照抄
                end
            end,
            execute = StartAOETargeting, --照抄
            atlas = new_spell.atlas, --如果轮盘图标是贴图，写上atlas
            normal = new_spell.normal, --如果轮盘图标是贴图，写上默认情况的tex
            clicksound = "meta4/winona_UI/select", --点击音效
            widget_scale = new_spell.widget_scale, --缩放
            checkenabled = function(user)
                return true
            end,
        })
    end
end

-- 将 SPELLS_NEW 插入到 SPELLS
InsertSpells(SPELLS, SPELLS_NEW)

AddPrefabPostInit("dst_gi_nahida_spellbook", function(inst)
    inst:AddComponent("spellbook")
    inst.components.spellbook:SetRadius(120)
    inst.components.spellbook:SetFocusRadius(120)
    inst.components.spellbook:SetShouldOpenFn(ShouldOpenFn)--设置什么情况下可以呼出轮盘
    inst.components.spellbook:SetItems(SPELLS)
    inst.components.spellbook.opensound = "meta5/woby/bigwoby_actionwheel_UI"

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetAllowRiding(false)--是否允许骑行时施法
    --inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoe"--指示器
    --inst.components.aoetargeting.reticule.pingprefab = "reticuleaoeping"--取消的指示器
    --inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
    --inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    --inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    --inst.components.aoetargeting.reticule.ease = true
    --inst.components.aoetargeting.reticule.mouseenabled = true

    if TheWorld.ismastersim then
        inst:AddComponent("aoespell")
    end
end)