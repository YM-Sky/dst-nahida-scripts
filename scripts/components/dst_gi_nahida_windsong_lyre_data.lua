---
--- dst_gi_nahida_windsong_lyre_data.lua
--- Description: 风物之诗琴data
--- Author: 没有小钱钱
--- Date: 2025/5/24 22:58
---

-- 大梦的曲调
local function melodyOfTheGreatDreamFn(player,target)

end
-- 大梦的曲调
local function melodyOfTheGreatDreamCallback(player,target)

end

-- 桓摩的曲调
local function dstGiNahidaHuanmoChantFn(player,target)

end

-- 桓摩的曲调
local function dstGiNahidaHuanmoChantCallback(player,target)

end

-- 黯道的曲调
local function dstGiNahidaPathOfShadowsTuneFn(player,target)

end

-- 黯道的曲调
local function dstGiNahidaPathOfShadowsTuneCallback(player,target)

end

-- 兽径的曲调
local function dstGiNahidaBeastTrailMelodyFn(player,target)

end

-- 兽径的曲调
local function dstGiNahidaBeastTrailMelodyCallback(player,target)

end

-- 新芽的曲调
local function dstGiNahidaSproutSongFn(player,target)

end

-- 新芽的曲调
local function dstGiNahidaSproutSongCallback(player,target)

end

-- 源水的曲调
local function dstGiNahidaSourcewaterHymnFn(player,target)

end

-- 源水的曲调 callback
local function dstGiNahidaSourcewaterHymnCallback(player,target)

end

-- 苏生的曲调 fn
local function dstGiNahidaRevivalChantFn(player,target)
    if player == nil  then
        return
    end
    -- 6秒执行一次任务
    player.try_growth_for_entities_task = player:DoPeriodicTask(6,function()
        if player.components.sanity and player.components.sanity.current < 10  then
            -- 终止催熟任务
            if player.try_growth_for_entities_task ~= nil then
                player.try_growth_for_entities_task:Cancel()
                player.try_growth_for_entities_task = nil
            end
            return
        end

        if target.components.finiteuses and target.components.finiteuses.current <= 0  then
            -- 终止催熟任务
            if player.try_growth_for_entities_task ~= nil then
                player.try_growth_for_entities_task:Cancel()
                player.try_growth_for_entities_task = nil
            end
            if player.components.talker then
                player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_MUSIC_SCORE_NUM_NOT_ENOUGH)
            end
            return
        end
        -- 消耗理智值
        if player.components.staffsanity then
            player.components.staffsanity:DoCastingDelta(-10)
        elseif player.components.sanity ~= nil then
            player.components.sanity:DoDelta(-10)
        end
        NahidaTryGrowthForEntities(player,30)
        if target.components.finiteuses then
            target.components.finiteuses:Use(1)
            if target.components.dst_gi_nahida_windsong_lyre_data.active_music_score_count and target.components.dst_gi_nahida_windsong_lyre_data.active_music_score_count.dst_gi_nahida_revival_chant then
                target.components.dst_gi_nahida_windsong_lyre_data.active_music_score_count.dst_gi_nahida_revival_chant = target.components.finiteuses.current
            end
        end

    end)

    player:ListenForEvent("locomote", function(inst)
        -- 终止催熟任务
        if player.try_growth_for_entities_task ~= nil then
            player.try_growth_for_entities_task:Cancel()
            player.try_growth_for_entities_task = nil
        end
    end)
end

-- 苏生的曲调 callback
local function dstGiNahidaRevivalChantCallback(player,target)
    -- 终止催熟任务
    if player.try_growth_for_entities_task ~= nil then
        player.try_growth_for_entities_task:Cancel()
        player.try_growth_for_entities_task = nil
    end
end

local function OnActive(self,value)
    self.inst.net_nahida_active_music_score:set(tostring(value))
end

local dst_gi_nahida_windsong_lyre_data = Class(function(self, inst)
    self.inst = inst
    self.active_music_score = {}
    self.active_music_score_count = {}
    self.max_count = 100
    self.active = nil
    self.active_music_score_fn = {
        -- 大梦的曲调
        dst_gi_nahida_melody_of_the_great_dream = {
            fn = melodyOfTheGreatDreamFn,
            callback = melodyOfTheGreatDreamCallback,
        },
        -- 桓摩的曲调
        dst_gi_nahida_huanmo_chant = {
            fn = dstGiNahidaHuanmoChantFn,
            callback = dstGiNahidaHuanmoChantCallback,
        },
        -- 黯道的曲调
        dst_gi_nahida_path_of_shadows_tune = {
            fn = dstGiNahidaPathOfShadowsTuneFn,
            callback = dstGiNahidaPathOfShadowsTuneCallback,
        },
        -- 兽径的曲调
        dst_gi_nahida_beast_trail_melody = {
            fn = dstGiNahidaBeastTrailMelodyFn,
            callback = dstGiNahidaBeastTrailMelodyCallback,
        },
        -- 新芽的曲调
        dst_gi_nahida_sprout_song = {
            fn = dstGiNahidaSproutSongFn,
            callback = dstGiNahidaSproutSongCallback,
        },
        -- 源水的曲调
        dst_gi_nahida_sourcewater_hymn = {
            fn = dstGiNahidaSourcewaterHymnFn,
            callback = dstGiNahidaSourcewaterHymnCallback,
        },
        -- 苏生的曲调
        dst_gi_nahida_revival_chant = {
            fn = dstGiNahidaRevivalChantFn,
            callback = dstGiNahidaRevivalChantCallback,
        },
    }
end,nil,{
    active = OnActive
})

function dst_gi_nahida_windsong_lyre_data:ActivateMusicScore(player,target,item)
    if item == nil or not item:HasTag("dst_gi_nahida_music_score") then
        return false
    end
    if target.components.dst_gi_nahida_windsong_lyre_data == nil then
        return false
    end
    local count = target.components.dst_gi_nahida_windsong_lyre_data.active_music_score_count[item.prefab]
    if count ~= nil and count >= 100 then
        return false
    end
    if count == nil then
        count = 0
    end
    local new_current = math.min(count + 10, self.max_count)
    target.components.dst_gi_nahida_windsong_lyre_data.active_music_score_count[item.prefab] = new_current
    target.components.dst_gi_nahida_windsong_lyre_data.active_music_score[item.prefab] = true
    target.components.dst_gi_nahida_windsong_lyre_data.active = item.prefab
    -- 更新finiteuses到新激活的琴谱数量
    if target.components.finiteuses then
        target.components.finiteuses:SetUses(new_current)
    end
    item:Remove()
    return true
end

function dst_gi_nahida_windsong_lyre_data:SelectMusicScore(player,target,prefab)
    print("SelectMusicScore 选择曲子："..tostring(prefab))
    if target.components.dst_gi_nahida_windsong_lyre_data == nil then
        return false
    end
    local itemActivate = target.components.dst_gi_nahida_windsong_lyre_data.active_music_score[prefab]
    if itemActivate == nil or itemActivate == false then
        if player.components.talker then
            player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_MUSIC_SCORE_NOT_ACTIVATE)
        end
        return true
    end
    if itemActivate then
        target.components.dst_gi_nahida_windsong_lyre_data.active = prefab
        if player.components.talker then
            player.components.talker:Say(string.format(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_MUSIC_SCORE_CURRENT_ACTIVATE, STRINGS.NAMES[string.upper(prefab)]))
        end
        if target.components.finiteuses then
            local count = target.components.dst_gi_nahida_windsong_lyre_data.active_music_score_count[prefab]
            if count == nil then
                count = 0
            end
            target.components.finiteuses:SetUses(count)
        end
        return true
    end
    return false
end

function dst_gi_nahida_windsong_lyre_data:Performance(player,target)
    if target.components.dst_gi_nahida_windsong_lyre_data == nil then
        return false
    end
    local itemActivate = target.components.dst_gi_nahida_windsong_lyre_data.active
    if itemActivate == nil then
        if player.components.talker then
            player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_MUSIC_SCORE_SELECT)
        end
        return true
    end
    if itemActivate then
        self:implementationFn(player,target,itemActivate)
        return true
    end
    return false
end

function dst_gi_nahida_windsong_lyre_data:implementationFn(player,target,active)
    if active == nil then
        return false
    end
    -- 查
    local active_music_score_table = self.active_music_score_fn[active]
    local count = target.components.dst_gi_nahida_windsong_lyre_data.active_music_score_count[active]
    if count == nil or count == 0 then
        if player.components.talker then
            player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_MUSIC_SCORE_NUM_NOT_ENOUGH)
        end
        return false
    end
    -- 执行弹琴动作
    player.sg:GoToState("dst_gi_nahida_playguitar_start")
    local nahida_music = {
        [1] = "nahida_music_sound/nahida_music_sound/melody_of_sprouting_flowers",
        [2] = "nahida_music_sound/nahida_music_sound/melody_of_hidden_seeds",
        [3] = "nahida_music_sound/nahida_music_sound/melody_of_fresh_dewdrops",
        [4] = "nahida_music_sound/nahida_music_sound/melody_of_dream_home",
        [5] = "nahida_music_sound/nahida_music_sound/melody_of_distant_green_fields",
        [6] = "nahida_music_sound/nahida_music_sound/melody_of_bright_new_buds",
        [7] = "nahida_music_sound/nahida_music_sound/melody_of_young_leaves",
    }
    local idx = math.random(1, #nahida_music)
    local music_name = nahida_music[idx]
    if music_name then
        -- 播放
        player.SoundEmitter:PlaySound(music_name,"dst_gi_nahida_playguitar_music")
        --player.SoundEmitter:SetVolume("dst_gi_nahida_playguitar_music",1)
    end
    --player.SoundEmitter:PlaySound("nahida_music_sound/nahida_music_sound/melody_of_bright_new_buds","dst_gi_nahida_playguitar_music")

    -- 执行方法
    if active_music_score_table.fn then
        active_music_score_table.fn(player,target)
    end
    player:ListenForEvent("dst_gi_nahida_playguitar_end", function(inst)
        -- 执行回调
        if active_music_score_table.callback then
            active_music_score_table.callback(player,target)
        end
        player.SoundEmitter:KillSound("dst_gi_nahida_playguitar_music")
        -- 放个不存在的通道，隐藏手上的武器
        player.AnimState:OverrideSymbol("swap_object", "swap_wuqi", "swap_wuqi")
    end)
end

function dst_gi_nahida_windsong_lyre_data:OnSave()
    -- 保存当前的 active_music_score 状态
    local active_music_score = {}
    for key, value in pairs(self.active_music_score) do
        active_music_score[key] = value
    end
    local active_music_score_count = {}
    for key, value in pairs(self.active_music_score_count) do
        active_music_score_count[key] = value
    end
    return {
        active_music_score_count = active_music_score_count,
        active_music_score = active_music_score,
        active = self.active
    }
end

function dst_gi_nahida_windsong_lyre_data:OnLoad(data)
    if data and data.active_music_score then
        -- 确保加载时正确更新 active_music_score
        for key, value in pairs(data.active_music_score) do
            self.active_music_score[key] = value
        end
    end
    if data and data.active_music_score_count then
        -- 确保加载时正确更新 active_music_score
        for key, value in pairs(data.active_music_score_count) do
            self.active_music_score_count[key] = value
        end
    end
    if data then
        self.active = data.active
    end
end

return dst_gi_nahida_windsong_lyre_data