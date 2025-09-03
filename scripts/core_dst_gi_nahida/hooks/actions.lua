---
--- actions.lua
--- Description: 动作
--- Author: 没有小钱钱
--- Date: 2025/4/12 11:53
---
local NORMAL_PICK = GLOBAL.ACTIONS.PICK
-- 获取当前 MOD 名称
local modname = TUNING.MOD_ID
-- 召唤类
local summonArray = {
    -- 独眼巨鹿雕塑
    chesspiece_deerclops = { prefab = "deerclops",sanity = TUNING.SANITY_3,fateseat_level = 3 },
    -- 熊獾雕塑
    chesspiece_bearger = { prefab = "bearger",sanity = TUNING.SANITY_3,fateseat_level = 3 },
    -- 麋鹿鹅雕塑
    chesspiece_moosegoose = { prefab = "moose",sanity = TUNING.SANITY_3,fateseat_level = 3 },
    -- 龙蝇雕塑
    chesspiece_dragonfly = { prefab = "dragonfly",sanity = TUNING.SANITY_3,fateseat_level = 3 },
    -- 远古守护者雕塑
    chesspiece_minotaur = { prefab = "minotaur",sanity = TUNING.SANITY_3,fateseat_level = 3 },
    -- 毒菌蟾蜍雕塑
    chesspiece_toadstool = { prefab = "toadstool",sanity = TUNING.SANITY_3,fateseat_level = 3 },
    -- 蜂王雕塑
    chesspiece_beequeen = { prefab = "beequeen",sanity = TUNING.SANITY_3,fateseat_level = 3 },
    -- 蚁狮雕塑
    chesspiece_antlion = { prefab = "antlion",sanity = TUNING.SANITY_3,fateseat_level = 3 },
    -- 邪天翁雕塑
    chesspiece_malbatross = { prefab = "malbatross",sanity = TUNING.SANITY_3,fateseat_level = 3 },
    -- 梦魇疯猪雕塑
    chesspiece_daywalker = { prefab = "daywalker",sanity = TUNING.SANITY_3,fateseat_level = 3 },
    -- 附身座狼雕塑
    chesspiece_warg_mutated = { prefab = "warg",sanity = TUNING.SANITY_3,fateseat_level = 3  },
    -- 常青树系列
    evergreen = { prefab = "leif",sanity = TUNING.SANITY_1,fateseat_level = 1  },
    evergreen_short = { prefab = "leif" ,sanity = TUNING.SANITY_1,fateseat_level = 1  },
    evergreen_normal = { prefab = "leif" ,sanity = TUNING.SANITY_1,fateseat_level = 1  },
    evergreen_tall = { prefab = "leif" ,sanity = TUNING.SANITY_1,fateseat_level = 1 },
    evergreen_sparse = { prefab = "leif_sparse" ,sanity = TUNING.SANITY_1,fateseat_level = 1 },
    evergreen_sparse_short = { prefab = "leif_sparse" ,sanity = TUNING.SANITY_1,fateseat_level = 1 },
    evergreen_sparse_normal = { prefab = "leif_sparse" ,sanity = TUNING.SANITY_1,fateseat_level = 1 },
    evergreen_sparse_tall = { prefab = "leif_sparse" ,sanity = TUNING.SANITY_1,fateseat_level = 1 },
}

local fish = {
    {
        prefab = "oceanfish_small_1", -- 小孔雀鱼：不常见的杂食性海鱼，分布于浅海和中层海。
    },
    {
        prefab = "oceanfish_small_2", -- 针鼻喷墨鱼：常见的杂食性海鱼，分布于浅海。
    },
    {
        prefab = "oceanfish_small_3", -- 小饵鱼：稀有的肉食性海鱼，分布于浅海、中层海和深海。
    },
    {
        prefab = "oceanfish_small_4", -- 三文鱼苗：非常常见的杂食性海鱼，分布于浅海。
    },
    {
        prefab = "oceanfish_small_5", -- 爆米花鱼：常见的素食性海鱼，分布于浅海。
    },
    {
        prefab = "oceanfish_small_6", -- 落叶比目鱼：常见的素食性海鱼，分布于中层海和水中木，仅秋季出现。
    },
    {
        prefab = "oceanfish_small_7", -- 花朵金枪鱼：常见的素食性海鱼，分布于浅海和水中木，仅春季出现。
    },
    {
        prefab = "oceanfish_small_8", -- 炽热太阳鱼：不常见的肉食性海鱼，分布于中层海，仅夏季出现。
    },
    {
        prefab = "oceanfish_small_9", -- 口水鱼：素食性海鱼，生成于海草附近。
    },
    {
        prefab = "oceanfish_medium_1", -- 泥鱼：常见的杂食性海鱼，分布于中层海。
    },
    {
        prefab = "oceanfish_medium_2", -- 斑鱼：常见于深海的海洋鱼类。
    },
    {
        prefab = "oceanfish_medium_3", -- 浮夸狮子鱼：常见于危险海域的肉食性海鱼。
    },
    {
        prefab = "oceanfish_medium_4", -- 黑鲶鱼：常见于深海的杂食性海鱼。
    },
    {
        prefab = "oceanfish_medium_5", -- 玉米鳕鱼：常见的素食性鱼类，分布于中层海。
    },
    {
        prefab = "oceanfish_medium_8", -- 冰鲷鱼：不常见的杂食性海鱼，分布于中层海，仅冬季出现。
    },
    {
        prefab = "oceanfish_medium_9", -- 甜味鱼：稀有的海鱼，分布于水中木生物群系。
    },
    {
        prefab = "oceanfish_medium_6", -- 花锦鲤：只在春节活动中出现的海鱼。
    },
    {
        prefab = "oceanfish_medium_7", -- 金锦鲤：只在春节活动中出现的海鱼。
    },
}

local function InitDstGiNahidaAnimalData(inst, data)
    if inst.components.dst_gi_nahida_actions_data then
        inst.components.dst_gi_nahida_actions_data:SetPickUpPrefabData(data)
    end
end

local dst_gi_nahida_actions = {
    NAHIDA_PICKUP_ANIMAL = {
        id = "NAHIDA_PICKUP_ANIMAL",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_PICKUP_ANIMAL,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target ~= nil and act.target.components.inventoryitem ~= nil then
                act.doer:PushEvent("onpickupitem", { item = act.target })
                if act.target.prefab and act.target.prefab:find("_planted$") then
                    local basePrefab = act.target.prefab:match("^(.-)_planted$") or act.target.prefab
                    -- 检查是否确实包含 _planted (可选)
                    local planted = SpawnPrefab(basePrefab)
                    if planted then
                        act.doer.components.inventory:GiveItem(planted)
                        act.target:Remove()
                        return true
                    end
                    return false
                end
                act.doer.components.inventory:GiveItem(act.target)
                return true
            end
            return false
        end
    },
    NAHIDA_THIEF = {
        id = "NAHIDA_THIEF",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_THIEF,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target ~= nil and act.target.components.inventory ~= nil then
                -- 遍历并获取火药猴身上的所有物品
                for i = 1, act.target.components.inventory.maxslots do
                    local item = act.target.components.inventory.itemslots[i]
                    if item then
                        -- 从火药猴的 inventory 中移除物品
                        item = act.target.components.inventory:RemoveItem(item, true) -- true 表示移除整个堆栈
                        if item then
                            -- 将物品添加到执行者的 inventory 中
                            if not act.doer.components.inventory:GiveItem(item) then
                                -- 如果添加失败，将物品掉落在地上
                                act.target.components.inventory:DropItem(item)
                            end
                        end
                    end
                end
                return true
            end
            return false
        end
    },
    NAHIDA_TRANSPLANTATION = {
        id = "NAHIDA_TRANSPLANTATION",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TRANSPLANTATION,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target ~= nil and act.target.components.dst_gi_nahida_actions_data ~= nil then
                return act.target.components.dst_gi_nahida_actions_data:PickUp(act.doer, act.target)
            end
            return false
        end
    },
    NAHIDA_ANIMAL_GIVE = {
        id = "NAHIDA_ANIMAL_GIVE",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_ANIMAL_GIVE,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target ~= nil and act.target.components.dst_gi_nahida_actions_data ~= nil then
                return act.target.components.dst_gi_nahida_actions_data:PickUp(act.doer, act.target)
            end
            return false
        end
    },
    NAHIDA_ANIMAL_SUMMON = {
        id = "NAHIDA_ANIMAL_SUMMON",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_ANIMAL_SUMMON,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.doer:HasTag(TUNING.AVATAR_NAME) and act.target ~= nil and act.target.components.dst_gi_nahida_actions_data ~= nil then
                if act.doer.components.dst_gi_nahida_data then
                    local nahida_fateseat_level = act.doer.components.dst_gi_nahida_data.nahida_fateseat_level
                    -- 执行召唤逻辑
                    local summon_prefab = summonArray[act.target.prefab]
                    if summon_prefab and (summon_prefab.fateseat_level == nil or nahida_fateseat_level >= summon_prefab.fateseat_level) then
                        local x, y, z = act.target.Transform:GetWorldPosition()
                        local summoned_entity = SpawnPrefab(summon_prefab.prefab)
                        if summoned_entity then
                            summoned_entity.Transform:SetPosition(x, y, z)
                            act.doer:PushEvent("summoned", { entity = summoned_entity })
                            -- 移除原来的物品
                            act.target:Remove()
                            if nahida_fateseat_level < 6 then
                                -- 消耗理智值
                                if act.doer.components.staffsanity then
                                    act.doer.components.staffsanity:DoCastingDelta(-summon_prefab.sanity)
                                elseif act.doer.components.sanity ~= nil then
                                    act.doer.components.sanity:DoDelta(-summon_prefab.sanity)
                                end
                            end
                            return true
                        end
                    end
                end
                return false
            end
            return false
        end
    },
    NAHIDA_TOUCH_A_FISH = {
        id = "NAHIDA_TOUCH_A_FISH",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TOUCH_A_FISH,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target ~= nil and act.target.components.dst_gi_nahida_actions_data ~= nil then
                return act.target.components.dst_gi_nahida_actions_data:PickUp(act.doer, act.target)
            end
            return false
        end
    },
    NAHIDA_TOUCH_A_MARINE_FISH = {
        id = "NAHIDA_TOUCH_A_MARINE_FISH",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TOUCH_A_MARINE_FISH,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target ~= nil then
                local newfish = SpawnPrefab(act.target.prefab .. "_inv")
                if newfish ~= nil then
                    if act.doer.components.inventory ~= nil then
                        act.doer.components.inventory:GiveItem(newfish)
                    end
                    act.target:Remove()
                    return true
                end
            end
            return false
        end
    },
    NAHIDA_FATESEAT_USE = {
        id = "NAHIDA_FATESEAT_USE",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_FATESEAT_USE,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.doer.components.dst_gi_nahida_data then
                if act.doer:HasTag(TUNING.AVATAR_NAME) and act.target ~= nil and act.target.components.dst_gi_nahida_actions_data ~= nil then
                    return act.doer.components.dst_gi_nahida_data:AddFateseatLevel(act.target)
                end
                if act.doer:HasTag(TUNING.AVATAR_NAME) and act.invobject ~= nil and act.invobject.components.dst_gi_nahida_actions_data ~= nil then
                    return act.doer.components.dst_gi_nahida_data:AddFateseatLevel(act.invobject)
                end
            end
            return false
        end
    },
    NAHIDA_ITEM_USE = {
        id = "NAHIDA_ITEM_USE",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_ITEM_USE,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.doer.components.dst_gi_nahida_data then
                if act.doer:HasTag(TUNING.AVATAR_NAME) and act.target ~= nil and act.target.components.dst_gi_nahida_actions_data ~= nil then
                    return act.doer.components.dst_gi_nahida_data:UseItem(act.doer,act.target)
                end
                if act.doer:HasTag(TUNING.AVATAR_NAME) and act.invobject ~= nil and act.invobject.components.dst_gi_nahida_actions_data ~= nil then
                    return act.doer.components.dst_gi_nahida_data:UseItem(act.doer,act.invobject)
                end
            end
            return false
        end
    },
    NAHIDA_STRUCK = {
        id = "NAHIDA_STRUCK",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_STRUCK,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target ~= nil and act.target.components.dst_gi_nahida_actions_data ~= nil then
                if act.doer.components.inventory then
                    local equipped_item = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                    if equipped_item and (equipped_item:HasTag("axe") or equipped_item:HasTag("sharp")) then
                        return act.target.components.dst_gi_nahida_actions_data:Struck(act.doer, act.target,equipped_item)
                    end
                end
                if act.doer.components.talker then
                    act.doer.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_STRUCK_FAILURE_TALKER_SAY)
                end
                return true
            end
            return false
        end
    },
    NAHIDA_EPITOMIZED_PATH = { -- 定轨
        id = "NAHIDA_EPITOMIZED_PATH",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_EPITOMIZED_PATH,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.invobject ~= nil and act.invobject.components.dst_gi_nahida_actions_data ~= nil then
                return act.invobject.components.dst_gi_nahida_actions_data:EpitomizedPath(act.doer, act.invobject)
            end
            return false
        end
    },
    NAHIDA_WISH = { -- 祈愿
        id = "NAHIDA_WISH",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_WISH,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target and act.invobject ~= nil and act.target.components.dst_gi_nahida_actions_data ~= nil then
                return act.target.components.dst_gi_nahida_actions_data:DrawCard(act.doer, act.target, act.invobject)
            end
            return true
        end
    },
    NAHIDA_RESURRECTION = { -- 复活
        id = "NAHIDA_RESURRECTION",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_RESURRECTION,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target ~= nil and act.invobject ~= nil then
                local mandrake_planted = SpawnPrefab("mandrake_planted")
                if mandrake_planted then
                    mandrake_planted.Transform:SetPosition(act.target.Transform:GetWorldPosition())
                    act.invobject:Remove()
                    --移除墓碑的子对象，防止墓碑被破坏时报错
                    local gravestone = act.target.entity:GetParent()
                    if gravestone and gravestone.mound then
                        gravestone.mound = nil
                    end
                    act.target:Remove()
                    return true
                end
            end
            return false
        end
    },
    NAHIDA_TAME = { -- 复活
        id = "NAHIDA_TAME",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TAME,
        priority = 12,
        fn = function(act)
            if act.doer ~= nil and act.target ~= nil and act.invobject ~= nil and act.invobject.components.dst_gi_nahida_actions_data then
                return act.invobject.components.dst_gi_nahida_actions_data:TameBeefalo(act.doer, act.target, act.invobject)
            end
            return false
        end
    },
    NAHIDA_TAKE_OUT = { -- 放出
        id = "NAHIDA_TAKE_OUT",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TAKE_OUT,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.invobject ~= nil
                    and act.invobject.components.dst_gi_nahida_actions_data ~= nil
                    and act.invobject.components.dst_gi_nahida_beef_bell_data ~= nil
            then
                return act.invobject.components.dst_gi_nahida_beef_bell_data:SpawnPrefabBeefalo(act.doer, act.invobject)
            end
            return false
        end
    },
    NAHIDA_PUT_AWAY = { -- 收起
        id = "NAHIDA_PUT_AWAY",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_PUT_AWAY,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target ~= nil and act.invobject ~= nil
                    and act.target.components.dst_gi_nahida_bind_data
                    and act.invobject.components.dst_gi_nahida_beef_bell_data
                    and act.invobject.components.dst_gi_nahida_beef_bell_data.is_save_beefalo == false
            then
                return act.invobject.components.dst_gi_nahida_beef_bell_data:PutAway(act.doer, act.target, act.invobject)
            end
            return false
        end
    },
    NAHIDA_TOY_MAKING = { -- 小玩具制作
        id = "NAHIDA_TOY_MAKING",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TOY_MAKING,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target and act.invobject ~= nil and act.target.prefab == "dst_gi_nahida_toy_desk"
                    and act.target.components.dst_gi_nahida_actions_data
            then
                return act.target.components.dst_gi_nahida_actions_data:ToyMaking(act.doer, act.target, act.invobject)
            end
            return true
        end
    },
    NAHIDA_MUSIC_SCORE_ACTIVATE = { -- 激活乐谱
        id = "NAHIDA_MUSIC_SCORE_ACTIVATE",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_MUSIC_SCORE_ACTIVATE,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target and act.invobject ~= nil and act.target.prefab == "dst_gi_nahida_windsong_lyre"
                    and act.target.components.dst_gi_nahida_windsong_lyre_data
            then
                return act.target.components.dst_gi_nahida_windsong_lyre_data:ActivateMusicScore(act.doer, act.target, act.invobject)
            end
            return true
        end
    },
    NAHIDA_PLAYPIANO = { -- 弹琴
        id = "NAHIDA_PLAYPIANO",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_PLAYPIANO,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab == "dst_gi_nahida_windsong_lyre"
                    and act.invobject.components.dst_gi_nahida_windsong_lyre_data
            then
                return act.invobject.components.dst_gi_nahida_windsong_lyre_data:Performance(act.doer, act.invobject)
            end
            return true
        end
    },
    NAHIDA_EXCHANGE = { -- 兑换
        id = "NAHIDA_EXCHANGE",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_EXCHANGE,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target and act.invobject ~= nil and act.target.components.dst_gi_nahida_actions_data ~= nil then
                return act.target.components.dst_gi_nahida_actions_data:Exchange(act.doer, act.target, act.invobject)
            end
            return true
        end
    },
    NAHIDA_TREATMENT = { -- 强心针治疗
        id = "NAHIDA_TREATMENT",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_TREATMENT,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.doer:IsValid() and act.doer.components.health and not act.doer.components.health:IsDead() then
                if act.invobject ~= nil and act.invobject.components.dst_gi_nahida_actions_data ~= nil then
                    return act.invobject.components.dst_gi_nahida_actions_data:ResetMaxValues(act.doer,act.invobject)
                end
            end
            return false
        end
    },
    NAHIDA_CHARACTER_CARD_USE = { -- 技能卡使用
        id = "NAHIDA_CHARACTER_CARD_USE",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CHARACTER_CARD_USE,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.doer:IsValid() and act.doer.components.health and not act.doer.components.health:IsDead() then
                if act.invobject ~= nil and act.invobject.components.dst_gi_nahida_actions_data ~= nil then
                    if act.doer.components.dst_gi_nahida_character_window_data then
                        return act.doer.components.dst_gi_nahida_character_window_data:setCharacter(act.doer, act.invobject)
                    end
                    return false
                end
            end
            return true
        end
    },
    NAHIDA_WEAPON_STAFF_TR_MODEL = { -- 纳西妲的法杖切换模式
        id = "NAHIDA_WEAPON_STAFF_TR_MODEL",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_WEAPON_STAFF_TR_MODEL,
        priority = 10,
        fn = function(act)
            local item = act.invobject
            if item and item.prefab == "dst_gi_nahida_weapon_staff" and item.components.dst_gi_nahida_weapon_staff_data then
                return item.components.dst_gi_nahida_weapon_staff_data:TrMode()
            end
            if item and item.prefab == "dst_gi_nahida_thousand_floating_dreams" and item.components.dst_gi_nahida_actions_data then
                return item.components.dst_gi_nahida_actions_data:ThousandFloatingDreamsTrMode()
            end
            return false
        end
    },
    NAHIDA_WEAPON_STAFF_GIVE = {
        id = "NAHIDA_WEAPON_STAFF_GIVE",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_WEAPON_STAFF_GIVE,
        priority = 10,
        fn = function(act)
            local item = act.invobject
            if act.target and act.invobject and act.target.components.dst_gi_nahida_weapon_staff_data then
                -- 如果是橙宝石 优先执行修复逻辑
                if item.prefab == "orangegem" then
                    return act.target.components.dst_gi_nahida_weapon_staff_data:DoSewing(item)
                end
                if act.target.components.dst_gi_nahida_weapon_staff_data:CanAcceptItem(item) then
                    return act.target.components.dst_gi_nahida_weapon_staff_data:UpdateData(item)
                end
            end
            return false
        end
    },
    NAHIDA_DRESS_GIVE = {
        id = "NAHIDA_DRESS_GIVE",
        str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_DRESS_GIVE,
        priority = 10,
        fn = function(act)
            if act.doer ~= nil and act.target and act.invobject ~= nil
                    and act.target.components.dst_gi_nahida_actions_data ~= nil
                    and act.target.components.dst_gi_nahida_backpack_data ~= nil
            then
                return act.target.components.dst_gi_nahida_backpack_data:Give(act.doer, act.target, act.invobject)
            end
            return false
        end
    },
}
local function TargetHasTag(target, tags)
    return target:HasTag("pickable")
            or target:HasTag("takeshelfitem")            --for lureplant
            or target:HasTag("harvestable")                --for beebox
end

do
    local NAHIDA_SCYTHE = Action({ rmb = false, distance = 3, invalid_hold_action = true })
    NAHIDA_SCYTHE.id = "NAHIDA_SCYTHE"
    NAHIDA_SCYTHE.str = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SCYTHE
    NAHIDA_SCYTHE.priority = 10            --slightly higher than pick
    NAHIDA_SCYTHE.canforce = true
    NAHIDA_SCYTHE.rangecheckfn = NORMAL_PICK.rangecheckfn
    NAHIDA_SCYTHE.extra_arrive_dist = NORMAL_PICK.extra_arrive_dist
    NAHIDA_SCYTHE.mount_valid = true
    NAHIDA_SCYTHE.fn = function(act)
        if act.invobject ~= nil and act.invobject.DoScythe then
            if act.invobject.components.itemmimic and act.invobject.components.itemmimic.fail_as_invobject then
                return false, "ITEMMIMIC"
            end
            act.invobject:DoScythe(act.target, act.doer)
            return true
        end
        return false
    end
    AddAction(NAHIDA_SCYTHE)
end

-- 🔥 自定义劈砍动作，专门用于砍竹子
--do
--    local NAHIDA_CHOP_BAMBOO = Action({ rmb = false, distance = 3, invalid_hold_action = true })
--    NAHIDA_CHOP_BAMBOO.id = "NAHIDA_CHOP_BAMBOO"
--    NAHIDA_CHOP_BAMBOO.str = "劈砍2"  -- 显示的动作名称
--    NAHIDA_CHOP_BAMBOO.priority = 15  -- 比普通砍伐优先级更高
--    NAHIDA_CHOP_BAMBOO.canforce = true
--    NAHIDA_CHOP_BAMBOO.mount_valid = true
--    NAHIDA_CHOP_BAMBOO.fn = function(act)
--        -- 检查基本参数
--        if not act.doer or not act.target then
--            return false
--        end
--
--        -- 检查目标是否有hackable组件（竹子的原有组件）
--        if not act.target.components.hackable then
--            return false
--        end
--
--        -- 检查是否可以被hack
--        if not act.target.components.hackable:CanBeHacked() then
--            return false
--        end
--
--        -- 如果有工具，检查工具类型
--        if act.invobject then
--            if not (act.invobject:HasTag("axe") or act.invobject:HasTag("machete") or act.invobject:HasTag("sharp")) then
--                return false
--            end
--        end
--
--        -- 获取工具效率
--        local effectiveness = 1
--        if act.invobject and act.invobject.components.tool then
--            effectiveness = act.invobject.components.tool:GetEffectiveness(ACTIONS.HACK) or 1
--        end
--        -- 直接调用hackable组件的Hack方法（代替ACTIONS.HACK）
--        return act.target.components.hackable:Hack(act.doer, effectiveness)
--    end
--    AddAction(NAHIDA_CHOP_BAMBOO)
--end



--------ComponentAction---------
-- 🔥 为竹子砍伐添加组件动作
--local function BambooChopActionFn(inst, doer, target, actions)
--    -- 检查工具是否有砍伐能力，目标是否有hackable组件
--    if (inst:HasTag("axe") or inst:HasTag("machete") or inst:HasTag("sharp")) and target.prefab == "bambootree" then
--        table.insert(actions, ACTIONS.NAHIDA_CHOP_BAMBOO)
--    end
--end


local function ComponentActionFn(inst, doer, target, actions)
    if inst.prefab == "dst_gi_nahida_weapon_grass" and (target:HasTag("plant") and target:HasTag("pickable") or TargetHasTag(target)) then
        table.insert(actions, ACTIONS.NAHIDA_SCYTHE)
    end
end

AddComponentAction("USEITEM", "dst_gi_nahida_weapon_action_data", ComponentActionFn,modname)
AddComponentAction("EQUIPPED", "dst_gi_nahida_weapon_action_data", ComponentActionFn,modname)
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.NAHIDA_SCYTHE, "scythe"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.NAHIDA_SCYTHE, "scythe"))

TUNING.NAHIDA_PREFAB_DATA = {
    ["SCENE"] = {
        {
            component = "dst_gi_nahida_actions_data",
            testfn = function(inst, doer, actions, right)
                if right and ((doer:HasTag(TUNING.AVATAR_NAME) and doer:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)) or inst.prefab == "dst_gi_nahida_coconut") then
                    return true
                end
                return false
            end,
            prefab_actions = {
                -----------------------------可以被捕捉和拾取----------------------------------
                {
                    prefab = "rabbit", -- 兔子：游戏中的小型生物，可以被捕捉和拾取。
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "crow", -- 乌鸦：一种常见的鸟类，通常在白天出现。
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "robin", -- 知更鸟：红色的鸟类，通常在春天和夏天出现。
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "robin_winter", -- 冬季知更鸟：蓝色的鸟类，通常在冬天出现。
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "canary", -- 金丝雀：一种黄色的鸟类，可能与洞穴相关。
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "puffin", -- 海鹦：一种海鸟，可能在海边或特定环境中出现。
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "butterfly", -- 蝴蝶：白天出现的昆虫，可以被捕捉。
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "fireflies", -- 萤火虫：夜间发光的昆虫，可以被捕捉。
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "moonbutterfly", -- 月亮蝴蝶：与月亮相关的特殊蝴蝶。
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "bee", -- 蜜蜂
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "killerbee", -- 杀人蜂
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                -----------------------------海滩内容----------------------------------------
                {
                    prefab = "parrot", -- 鹦鹉
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "parrot_pirate", -- 鹦鹉
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "cormorant", -- 鹦鹉
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "toucan", -- 鹦鹉
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "seagull", -- 鹦鹉
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "seagull_water", -- 鹦鹉
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "jellyfish_planted", -- 水母
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "rainbowjellyfish_planted", -- 彩虹水母
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "crab", -- 兔蟹
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                -------------------猪镇---------------------------
                {
                    prefab = "kingfisher", -- 鹦鹉
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "parrot_blue", -- 鹦鹉
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                {
                    prefab = "pigeon", -- 鹦鹉
                    action = dst_gi_nahida_actions.NAHIDA_PICKUP_ANIMAL.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data",
                        "inventoryitem",
                    },
                },
                ----------------------------------------------------------------------
                ----------------------------------------------------------------------
                {
                    prefab = "powder_monkey", -- 火药猴
                    action = dst_gi_nahida_actions.NAHIDA_THIEF.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                },
                {
                    prefab = "otter", -- 水獭
                    action = dst_gi_nahida_actions.NAHIDA_THIEF.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                },
                ----------------------------------------------------------------------
                -----------------------------召唤类-----------------------------------------
                {
                    prefab = "chesspiece_deerclops", -- 独眼巨鹿雕塑
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    priority = 10,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.STATUE_DEERCLOPS,
                },
                {
                    prefab = "chesspiece_bearger", -- 熊獾雕塑
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    priority = 10,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.STATUE_BEARGER,
                },
                {
                    prefab = "chesspiece_moosegoose", -- 麋鹿鹅雕塑
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    priority = 10,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.STATUE_MOOSE_GOOSE,
                },
                {
                    prefab = "chesspiece_dragonfly", -- 龙蝇雕塑
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    priority = 10,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.STATUE_DRAGONFLY,
                },
                {
                    prefab = "chesspiece_minotaur", -- 远古守护者雕塑
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    priority = 10,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.STATUE_ANCIENT_GUARDIAN,
                },
                {
                    prefab = "chesspiece_toadstool", -- 毒菌蟾蜍雕塑
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    priority = 10,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.STATUE_TOADSTOOL,
                },
                {
                    prefab = "chesspiece_beequeen", -- 蜂王雕塑
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    priority = 10,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.STATUE_BEE_QUEEN,
                },
                {
                    prefab = "chesspiece_antlion", -- 蚁狮雕塑
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    priority = 10,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.STATUE_ANTLION,
                },
                {
                    prefab = "chesspiece_malbatross", -- 邪天翁雕塑
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    priority = 10,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.STATUE_MALBATROSS,
                },
                {
                    prefab = "chesspiece_daywalker", -- 梦魇疯猪雕塑
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    priority = 10,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.STATUE_NIGHTMARE_WEREPIG,
                },
                {
                    prefab = "chesspiece_warg_mutated", -- 附身座狼雕塑
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    priority = 10,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.STATUE_HOUND,
                },
                {
                    prefab = "evergreen", -- 常青树
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.EVERGREEN_RIGHT_CLICK,
                },
                {
                    prefab = "evergreen_short", -- 常青树
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.EVERGREEN_RIGHT_CLICK,
                },
                {
                    prefab = "evergreen_normal", -- 常青树
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.EVERGREEN_RIGHT_CLICK,
                },
                {
                    prefab = "evergreen_tall", -- 常青树
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.EVERGREEN_RIGHT_CLICK,
                },
                {
                    prefab = "evergreen_sparse", -- 臃肿常青树
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_SUMMON.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.EVERGREEN_RIGHT_CLICK,
                },
                ----------------------------------------------------------------------
                {
                    prefab = "lightninggoat", -- 伏特羊
                    product = {
                        { name = "goatmilk", count = 1 }, -- 电羊奶
                    },
                    cd = TUNING.ONE_DAY_TIME * 2,
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CREATURE_VOLTGOAT,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "dragonfly", -- 龙蝇
                    product = {
                        { name = "dragon_scales", count = 1, probability = 0.3}, -- 鳞片
                    },
                    cd = TUNING.ONE_DAY_TIME * 3,
                    sanity = TUNING.SANITY_2,
                    fateseat_level = 2,
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BOSS_DRAGONFLY,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "bearger", -- 熊灌
                    product = {
                        { name = "furtuft", count = { 5,10 }, probability = 0.3 }, -- 毛丛
                    },
                    cd = TUNING.ONE_DAY_TIME * 3,
                    sanity = TUNING.SANITY_2,
                    fateseat_level = 2,
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BOSS_BEARGER,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "moose", -- 麋鹿鹅
                    product = {
                        { name = "goose_feather", count = { 3,5 }, probability = 0.3 }, -- 麋鹿鹅羽毛
                    },
                    cd = TUNING.ONE_DAY_TIME * 3,
                    sanity = TUNING.SANITY_2,
                    fateseat_level = 2,
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BOSS_MOOSE_GOOSE,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "malbatross", -- 邪天翁
                    product = {
                        { name = "malbatross_feather", count = { 10,20 }, probability = 0.3 }, -- 邪天翁羽毛
                    },
                    cd = TUNING.ONE_DAY_TIME * 3,
                    sanity = TUNING.SANITY_2,
                    fateseat_level = 2,
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BOSS_MALBATROSS,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "beequeenhivegrown", -- 蜂王巢
                    product = {
                        { name = "honey", count = 10 }, -- 蜂蜜
                        { name = "royal_jelly", count = {1,5}, probability = 0.3 }, -- 蜂王浆
                    },
                    cd = TUNING.ONE_DAY_TIME * 3,
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BOSS_BEE_QUEEN,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "minotaur", -- 远古犀牛
                    product = {
                        { name = "minotaurhorn", count = 1, probability = 0.3 } -- 远古犀牛角
                    },
                    sanity = TUNING.SANITY_2,
                    fateseat_level = 2,
                    cd = TUNING.ONE_DAY_TIME * 3,
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.BOSS_ANCIENT_GUARDIAN,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "beehive", -- 蜂窝
                    product = {
                        { name = "honey", count = 3,probability = 0.8  }, -- 蜂蜜
                        { name = "honeycomb", count = 1,probability = 0.02 }, -- 蜜脾
                    },
                    cd = TUNING.ONE_DAY_TIME,
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CREATURE_BEEHIVE,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "wasphive", -- 杀人蜂窝
                    product = {
                        { name = "honey", count = 3,probability = 0.8 }, -- 蜂蜜
                        { name = "honeycomb", count = 1,probability = 0.02 }, -- 蜜脾
                    },
                    cd = TUNING.ONE_DAY_TIME,
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CREATURE_WASPHIVE,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "monkey", -- 穴居猴
                    product = {
                        { name = "cave_banana", count = 5 }, -- 香蕉
                    },
                    cd = TUNING.ONE_DAY_TIME * 2,
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CREATURE_MONKEY,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "beefalo", -- 牛
                    product = {
                        { name = "horn", count = 1,probability = 0.3 }, -- 牛角
                    },
                    cd = TUNING.ONE_DAY_TIME * 2,
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CREATURE_BEEFALO,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "walrus_camp", -- 海象营地
                    product = {
                        { name = "walrus_tusk", count = 1 }, -- 海象牙
                        { name = "walrushat", count = 1,probability = 0.1 }, -- 贝雷帽
                    },
                    cd = TUNING.ONE_DAY_TIME * 5,
                    seasons = {
                        "winter"
                    },
                    action = dst_gi_nahida_actions.NAHIDA_ANIMAL_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CREATURE_WALRUS_CAMP,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "dst_gi_nahida_coconut", -- 枣椰
                    product = {
                        { name = "dst_gi_nahida_coconut_meat", count = 2 }, -- 半个枣椰
                    },
                    cd = 0,
                    action = dst_gi_nahida_actions.NAHIDA_STRUCK.id,
                    consumables = true, -- 是否是消耗品，如果是，获取新物品的时候，删除旧物品
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    init = InitDstGiNahidaAnimalData
                },
                ------------------------------------------------------------------------------------
                -------------------------------------可移植物品-----------------------------------------------
                {
                    prefab = "flower_cave", -- 荧光花1
                    product = {
                        { name = "dst_gi_nahida_flower_cave", count = 1 }, -- 荧光花1
                    },
                    cd = 0,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.FLOWER_CAVE_ENABLE,
                    action = dst_gi_nahida_actions.NAHIDA_TRANSPLANTATION.id,
                    consumables = true, -- 是否是消耗品，如果是，获取新物品的时候，删除旧物品
                    not_inventory = true,-- 不直接放入物品栏
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    init = InitDstGiNahidaAnimalData,
                    testfn = function(inst, doer, actions, right)
                        local weapon = doer.replica.inventory and doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                        if doer and doer:HasTag(TUNING.AVATAR_NAME) and inst and weapon and weapon:HasTag("dst_gi_nahida_weapon_staff") then
                            return true
                        end
                        return false
                    end
                },
                {
                    prefab = "flower_cave_double", -- 荧光花2
                    product = {
                        { name = "dst_gi_nahida_flower_cave_double", count = 1 }, -- 荧光花2
                    },
                    cd = 0,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.FLOWER_CAVE_ENABLE,
                    action = dst_gi_nahida_actions.NAHIDA_TRANSPLANTATION.id,
                    consumables = true, -- 是否是消耗品，如果是，获取新物品的时候，删除旧物品
                    not_inventory = true, -- 不直接放入物品栏
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    init = InitDstGiNahidaAnimalData,
                    testfn = function(inst, doer, actions, right)
                        local weapon = doer.replica.inventory and doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                        if doer and doer:HasTag(TUNING.AVATAR_NAME) and inst and weapon and weapon:HasTag("dst_gi_nahida_weapon_staff") then
                            return true
                        end
                        return false
                    end
                },
                {
                    prefab = "flower_cave_triple", -- 荧光花3
                    product = {
                        { name = "dst_gi_nahida_flower_cave_triple", count = 1 }, -- 荧光花3
                    },
                    cd = 0,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.FLOWER_CAVE_ENABLE,
                    action = dst_gi_nahida_actions.NAHIDA_TRANSPLANTATION.id,
                    consumables = true, -- 是否是消耗品，如果是，获取新物品的时候，删除旧物品
                    not_inventory = true,-- 不直接放入物品栏
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    init = InitDstGiNahidaAnimalData,
                    testfn = function(inst, doer, actions, right)
                        local weapon = doer.replica.inventory and doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                        if doer and doer:HasTag(TUNING.AVATAR_NAME) and inst and weapon and weapon:HasTag("dst_gi_nahida_weapon_staff") then
                            return true
                        end
                        return false
                    end
                },
                {
                    prefab = "reeds", -- 芦苇
                    product = {
                        { name = "dst_gi_nahida_reeds", count = 1 }, -- 芦苇
                    },
                    cd = 0,
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.REEDS_ENABLE,
                    action = dst_gi_nahida_actions.NAHIDA_TRANSPLANTATION.id,
                    consumables = true, -- 是否是消耗品，如果是，获取新物品的时候，删除旧物品
                    not_inventory = true,-- 不直接放入物品栏
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    init = InitDstGiNahidaAnimalData,
                    testfn = function(inst, doer, actions, right)
                        local weapon = doer.replica.inventory and doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                        if doer and doer:HasTag(TUNING.AVATAR_NAME) and inst and weapon and weapon:HasTag("dst_gi_nahida_weapon_staff") then
                            return true
                        end
                        return false
                    end
                },
                -------------------------------------------------------------------------------------
                -------------------------------------------------------------------------------------
                -----------------------------------池塘摸鱼--------------------------------------------------
                {
                    prefab = "pond", -- 池塘
                    product = {
                        { name = "pondfish", count = 1 }, -- 淡水鱼
                    },
                    cd = TUNING.ONE_DAY_TIME * 1,
                    action = dst_gi_nahida_actions.NAHIDA_TOUCH_A_FISH.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CREATURE_FISH,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "pond_mos", -- 沼泽池塘
                    product = {
                        { name = "pondfish", count = 1 }, -- 淡水鱼
                    },
                    cd = TUNING.ONE_DAY_TIME * 1,
                    action = dst_gi_nahida_actions.NAHIDA_TOUCH_A_FISH.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CREATURE_FISH,
                    init = InitDstGiNahidaAnimalData
                },
                {
                    prefab = "pond_cave", -- 苔藓池塘
                    product = {
                        { name = "pondeel", count = 1 }, -- 淡水鱼
                    },
                    cd = TUNING.ONE_DAY_TIME * 1,
                    action = dst_gi_nahida_actions.NAHIDA_TOUCH_A_FISH.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    enable = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CREATURE_FISH,
                    init = InitDstGiNahidaAnimalData
                }
            }
        }
    },
    ["INVENTORY"] = {
        {
            component = "dst_gi_nahida_actions_data",
            testfn = function(inst, doer, actions)
                if doer then
                    return true
                end
                return false
            end,
            prefab_actions = {
                {
                    prefab = "dst_gi_nahida_weapon_staff", -- 纳西妲的法杖
                    action = dst_gi_nahida_actions.NAHIDA_WEAPON_STAFF_TR_MODEL.id,
                    testfn = function(inst, doer, actions)
                        if doer and inst.replica.equippable and inst.replica.equippable:IsEquipped() then
                            return doer:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)
                        end
                        return false
                    end
                },
                {
                    prefab = "dst_gi_nahida_thousand_floating_dreams", -- 纳西妲的法杖
                    action = dst_gi_nahida_actions.NAHIDA_WEAPON_STAFF_TR_MODEL.id,
                    testfn = function(inst, doer, actions)
                        return doer and inst.replica.equippable and inst.replica.equippable:IsEquipped() or false
                    end
                },
                {
                    prefab = "dst_gi_nahida_fateseat", -- 命座
                    action = dst_gi_nahida_actions.NAHIDA_FATESEAT_USE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    testfn = function(inst, doer, actions)
                        return doer and doer:HasTag(TUNING.AVATAR_NAME) and inst and inst.prefab == "dst_gi_nahida_fateseat" or false
                    end
                },
                {
                    prefab = "dst_gi_nahida_growth_value", -- 成长值
                    action = dst_gi_nahida_actions.NAHIDA_ITEM_USE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    testfn = function(inst, doer, actions)
                        return doer and doer:HasTag(TUNING.AVATAR_NAME) and inst and inst.prefab == "dst_gi_nahida_growth_value" or false
                    end
                },
                {
                    prefab = "dst_gi_nahida_intertwined_fate", -- 纠缠之缘
                    action = dst_gi_nahida_actions.NAHIDA_EPITOMIZED_PATH.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    testfn = function(inst, doer, actions)
                        return inst and inst.prefab == "dst_gi_nahida_intertwined_fate" and doer or false
                    end
                },
                {
                    prefab = "dst_gi_nahida_beef_bell_bind", -- 普通牛铃
                    action = dst_gi_nahida_actions.NAHIDA_TAKE_OUT.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    testfn = function(inst, doer, actions)
                        return true
                    end
                },
                {
                    prefab = "dst_gi_nahida_beef_bell_bind2", -- 战牛牛铃
                    action = dst_gi_nahida_actions.NAHIDA_TAKE_OUT.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    testfn = function(inst, doer, actions)
                        return true
                    end
                },
                {
                    prefab = "dst_gi_nahida_beef_bell_bind3", -- 行牛牛铃
                    action = dst_gi_nahida_actions.NAHIDA_TAKE_OUT.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    testfn = function(inst, doer, actions)
                        return true
                    end
                },
                {
                    prefab = "dst_gi_nahida_windsong_lyre", -- 琴
                    action = dst_gi_nahida_actions.NAHIDA_PLAYPIANO.id,
                    testfn = function(inst, doer, actions)
                        if doer and inst.replica.equippable
                                and inst.replica.equippable:IsEquipped()
                        then
                            return true
                        end
                        return false
                    end
                },
                {
                    prefab = "dst_gi_nahida_lifepen", -- 强化强心针
                    action = dst_gi_nahida_actions.NAHIDA_TREATMENT.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    testfn = function(inst, doer, actions)
                        return true
                    end
                },
                {
                    prefab = nil, -- 技能卡使用 "dst_gi_nahida_keqing_burst_card"
                    action = dst_gi_nahida_actions.NAHIDA_CHARACTER_CARD_USE.id,
                    testfn = function(inst, doer, actions)
                        return inst:HasTag("character_card")
                    end
                },
            }
        }
    },
    ["USEITEM"] = {
        {
            component = "dst_gi_nahida_actions_data",
            testfn = function(inst, doer, target, actions, right)
                if doer then
                    return true
                end
                return false
            end,
            prefab_actions = {
                {
                    prefab = "dst_gi_nahida_gacha_machine", -- 抽卡机
                    action = dst_gi_nahida_actions.NAHIDA_WISH.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    testfn = function(inst, doer, target, actions, right)
                        if not (doer and right and target.prefab == "dst_gi_nahida_gacha_machine") then
                            return false
                        end
                        --dst_gi_nahida_fate 抽卡物品标签
                        return inst and inst:HasTag("dst_gi_nahida_fate") or false
                    end
                },
            },
        },
        {
            component = "inventoryitem",
            testfn = function(inst, doer, target, actions, right)
                if doer and target then
                    return true
                end
                return false
            end,
            prefab_actions = {
                {
                    prefab = "mandrake", -- 坟墓
                    action = dst_gi_nahida_actions.NAHIDA_RESURRECTION.id,
                    testfn = function(inst, doer, target, actions, right)
                        if not (right and doer:HasTag(TUNING.AVATAR_NAME) and doer:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)) then
                            return false
                        end
                        if (inst.prefab == "mandrake" or inst.prefab == "mandrake_seeds") and target.prefab == "mound" and not target:HasTag("DIG_workable") then
                            return true
                        end
                        return false
                    end
                },
                {
                    prefab = "mandrake_seeds", -- 坟墓
                    action = dst_gi_nahida_actions.NAHIDA_RESURRECTION.id,
                    testfn = function(inst, doer, target, actions, right)
                        if not (right and doer:HasTag(TUNING.AVATAR_NAME) and doer:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)) then
                            return false
                        end
                        if (inst.prefab == "mandrake" or inst.prefab == "mandrake_seeds") and target.prefab == "mound" and not target:HasTag("DIG_workable") then
                            return true
                        end
                        return false
                    end
                },
                {
                    prefab = "dst_gi_nahida_beef_bell", -- 普通牛铃
                    action = dst_gi_nahida_actions.NAHIDA_TAME.id,
                    testfn = function(inst, doer, target, actions, right)
                        if inst:HasTag("dst_gi_nahida_beef_bell") and target.prefab == "beefalo" and not target:HasTag("domesticated") then
                            return true
                        end
                        return false
                    end
                },
                {
                    prefab = "dst_gi_nahida_beef_bell2", -- 战牛牛铃
                    action = dst_gi_nahida_actions.NAHIDA_TAME.id,
                    testfn = function(inst, doer, target, actions, right)
                        if inst:HasTag("dst_gi_nahida_beef_bell") and target.prefab == "beefalo" and not target:HasTag("domesticated") then
                            return true
                        end
                        return false
                    end
                },
                {
                    prefab = "dst_gi_nahida_beef_bell3", -- 行牛牛铃
                    action = dst_gi_nahida_actions.NAHIDA_TAME.id,
                    testfn = function(inst, doer, target, actions, right)
                        if inst:HasTag("dst_gi_nahida_beef_bell") and target.prefab == "beefalo" and not target:HasTag("domesticated") then
                            return true
                        end
                        return false
                    end
                },
                {
                    prefab = "dst_gi_nahida_beef_bell_bind", -- 普通牛铃
                    action = dst_gi_nahida_actions.NAHIDA_PUT_AWAY.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    testfn = function(inst, doer, target, actions, right)
                        return target.prefab == "beefalo" and target:HasTag("domesticated")
                    end
                },
                {
                    prefab = "dst_gi_nahida_beef_bell_bind2", -- 战牛牛铃
                    action = dst_gi_nahida_actions.NAHIDA_PUT_AWAY.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    testfn = function(inst, doer, target, actions, right)
                        return target.prefab == "beefalo" and target:HasTag("domesticated")
                    end
                },
                {
                    prefab = "dst_gi_nahida_beef_bell_bind3", -- 行牛牛铃
                    action = dst_gi_nahida_actions.NAHIDA_PUT_AWAY.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    testfn = function(inst, doer, target, actions, right)
                        return target.prefab == "beefalo" and target:HasTag("domesticated")
                    end
                },
                {
                    prefab = "dst_gi_nahida_toy_desk", -- 小玩具制作站
                    action = dst_gi_nahida_actions.NAHIDA_TOY_MAKING.id,
                    testfn = function(inst, doer, target, actions, right)
                        if not (doer and right and target.prefab == "dst_gi_nahida_toy_desk") then
                            return false
                        end
                        -- 目标必须是小玩具制作站
                        -- 物品必须是小玩具或者金子
                        return (NahidaIsTrinket(inst) or inst.prefab == "goldnugget")
                    end
                },
                {
                    prefab = "dst_gi_nahida_windsong_lyre", -- 小玩具制作站
                    action = dst_gi_nahida_actions.NAHIDA_MUSIC_SCORE_ACTIVATE.id,
                    testfn = function(inst, doer, target, actions, right)
                        if not (doer and right and target.prefab == "dst_gi_nahida_windsong_lyre") then
                            return false
                        end
                        return inst:HasTag("dst_gi_nahida_music_score")
                    end
                },
                {
                    prefab = "goldnugget", -- 金子
                    --action = dst_gi_nahida_actions.NAHIDA_EXCHANGE.id,
                    actions = {
                        [dst_gi_nahida_actions.NAHIDA_EXCHANGE.id] = {
                            testfn = function(inst, doer, target, actions, right)
                                -- 金子和抽卡机交互动作
                                if inst.prefab == "goldnugget" and target.prefab == "dst_gi_nahida_gacha_machine" then
                                    return true
                                end
                                return false
                            end
                        },
                        [dst_gi_nahida_actions.NAHIDA_WEAPON_STAFF_GIVE.id] = {
                            testfn = function(inst, doer, target, actions, right)
                                -- 金子和抽卡机交互动作
                                if inst.prefab == "goldnugget" and target.prefab == "dst_gi_nahida_weapon_staff" then
                                    return true
                                end
                                return false
                            end
                        }
                    },
                    testfn = function(inst, doer, target, actions, right)
                        if not (right and doer:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)) then
                            return false
                        end
                        return true
                    end
                },
                {
                    prefab = "walrus_tusk", -- 海象牙
                    action = dst_gi_nahida_actions.NAHIDA_WEAPON_STAFF_GIVE.id,
                    testfn = function(inst, doer, target, actions, right)
                        if not (right and target and doer:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)) then
                            return false
                        end
                        if target.prefab == "dst_gi_nahida_weapon_staff" then
                            return true
                        end
                        return false
                    end
                },
                {
                    prefab = "orangegem", -- 橙宝石
                    action = dst_gi_nahida_actions.NAHIDA_WEAPON_STAFF_GIVE.id,
                    testfn = function(inst, doer, target, actions, right)
                        if not (right and target and doer:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)) then
                            return false
                        end
                        if target.prefab == "dst_gi_nahida_weapon_staff" then
                            return true
                        end
                        return false
                    end
                },
                {
                    prefab = "opalpreciousgem", -- 彩虹宝石
                    action = dst_gi_nahida_actions.NAHIDA_WEAPON_STAFF_GIVE.id,
                    testfn = function(inst, doer, target, actions, right)
                        if not (right and target and doer:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)) then
                            return false
                        end
                        if target.prefab == "dst_gi_nahida_weapon_staff" then
                            return true
                        end
                        return false
                    end
                },
                {
                    prefabs = {
                        "furtuft", -- 毛丛
                        "dst_gi_nahida_tool_knife", -- 纳西妲的工具刀
                        "purplegem", -- 紫宝石
                        "bluegem", -- 蓝宝石
                        "redgem", -- 红宝石
                    },
                    action = dst_gi_nahida_actions.NAHIDA_DRESS_GIVE.id,
                    testfn = function(inst, doer, target, actions, right)
                        if not (right and target and doer:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)) then
                            return false
                        end
                        if target.prefab == "dst_gi_nahida_dress" or target.prefab == "dst_gi_nahida_dress2" or target.prefab == "dst_gi_nahida_dress3" then
                            return true
                        end
                        return false
                    end
                },
            }
        },
        {
            component = "equippable",
            testfn = function(inst, doer, target, actions, right)
                if doer then
                    return true
                end
                return false
            end,
            prefab_actions = {
                {
                    prefab = "dst_gi_nahida_weapon_staff", -- 神明的权杖
                    action = dst_gi_nahida_actions.NAHIDA_WEAPON_STAFF_GIVE.id,
                    addComponents = {
                        "dst_gi_nahida_actions_data"
                    },
                    testfn = function(inst, doer, target, actions, right)
                        if not (doer and right and target.prefab == "dst_gi_nahida_weapon_staff") then
                            return false
                        end
                        --dst_gi_nahida_fate 抽卡物品标签
                        return inst and (inst.prefab == "multitool_axe_pickaxe"
                                or inst.prefab == "orangestaff"
                                or inst.prefab == "opalstaff"
                                or inst.prefab == "yellowstaff")
                    end
                }
            }
        },
    }
}

local DOLONGACTIONS_ACTIONS = --写下要写出采集动画的action
{
    ["NAHIDA_ANIMAL_GIVE"] = "dolongaction",
    ["NAHIDA_THIEF"] = "dolongaction",
    ["NAHIDA_TOUCH_A_FISH"] = "dolongaction",
    ["NAHIDA_TOUCH_A_MARINE_FISH"] = "dolongaction",
    ["NAHIDA_TOY_MAKING"] = "dolongaction",
    ["NAHIDA_STRUCK"] = "dolongaction",
    ["NAHIDA_TAME"] = "dolongaction",
    ["NAHIDA_TAKE_OUT"] = "dolongaction",
    ["NAHIDA_PUT_AWAY"] = "dolongaction",
    ["NAHIDA_TRANSPLANTATION"] = "dig_start",
}

local function dolongaction(actionId)
    for k, v in pairs(DOLONGACTIONS_ACTIONS) do
        if DOLONGACTIONS_ACTIONS[actionId] then
            return DOLONGACTIONS_ACTIONS[actionId]
        end
    end
    return false
    --return table.contains(DOLONGACTIONS_ACTIONS, actionId)
end

for k, v in pairs(dst_gi_nahida_actions) do
    local _priority = v.priority or 10
    local _action = Action()
    if v.data then
        _action = Action(v.data)
    end
    _action.id = v.id
    _action.priority = _priority
    _action.fn = v.fn
    _action.str = v.str
    if v.canforce ~= nil then
        _action.canforce = v.canforce
    end
    if v.rangecheckfn ~= nil then
        _action.rangecheckfn = v.rangecheckfn
    end
    if v.extra_arrive_dist ~= nil then
        _action.extra_arrive_dist = v.extra_arrive_dist
    end
    if v.mount_valid ~= nil then
        _action.mount_valid = v.mount_valid
    end
    AddAction(_action)

    AddStategraphActionHandler("wilson", ActionHandler(ACTIONS[string.upper(v.id)], function(action)
        if v.state then
            return v.state
        end
        return dolongaction(v.id) or "doshortaction"
    end))
    AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS[string.upper(v.id)], function(action)
        if v.state then
            return v.state
        end
        return dolongaction(v.id) or "doshortaction"
    end))

end

local function NahidaAddPrefabPostInit(entry)
    local prefab = entry.prefab
    -- 假设你要添加的组件是 "dst_gi_nahida_actions_data"
    if prefab then
        AddPrefabPostInit(prefab, function(inst)
            if not TheWorld.ismastersim then
                return
            end
            if entry.addComponents then
                for _, component in ipairs(entry.addComponents) do
                    if inst.components[component] == nil then
                        inst:AddComponent(component)
                    end
                end
            end
            -- 确保实体没有该组件，然后添加它
            if entry.init then
                entry.init(inst, entry)
            end
        end)
    end
end

local function AddComponentActionToActionTypeScene(actiontype, components)
    for i, data in ipairs(components) do
        -- 动作组件才有的
        if data.component == "dst_gi_nahida_actions_data" then
            for _, entry in ipairs(data.prefab_actions) do
                NahidaAddPrefabPostInit(entry)
            end
        end
        AddComponentAction(actiontype, data.component, function(inst, doer, actions, right)
            if data.testfn and data.testfn(inst, doer, actions, right) then
                for _, entry in ipairs(data.prefab_actions) do
                    local prefab = entry.prefab
                    if inst.prefab == prefab then
                        if entry.seasons then
                            local current_season = TheWorld.state.season
                            for _, season in ipairs(entry.seasons) do
                                if current_season == season then
                                    if entry.testfn then
                                        if entry.testfn(inst, doer, actions, right) then
                                            if entry.actions then
                                                for action, action_data in pairs(entry.actions) do
                                                    if  action_data.testfn and action_data.testfn(inst, doer, actions, right) then
                                                        table.insert(actions, ACTIONS[string.upper(action)])
                                                    end
                                                end
                                            else
                                                if entry.action then
                                                    table.insert(actions, ACTIONS[string.upper(entry.action)])
                                                end
                                            end
                                        end
                                    else
                                        table.insert(actions, ACTIONS[string.upper(entry.action)])
                                    end
                                end
                            end
                        else
                            if entry.testfn then
                                if entry.testfn(inst, doer, actions, right) then
                                    if entry.actions then
                                        for action, action_data in pairs(entry.actions) do
                                            if  action_data.testfn and action_data.testfn(inst, doer, actions, right) then
                                                if entry.enable == nil or entry.enable then
                                                    table.insert(actions, ACTIONS[string.upper(action)])
                                                end
                                            end
                                        end
                                    else
                                        if entry.action then
                                            if entry.enable == nil or entry.enable then
                                                table.insert(actions, ACTIONS[string.upper(entry.action)])
                                            end
                                        end
                                    end
                                end
                            else
                                if entry.enable == nil or entry.enable then
                                    table.insert(actions, ACTIONS[string.upper(entry.action)])
                                end
                            end
                        end
                        break
                    end
                end
            end
        end,modname)
    end
end

local function AddComponentActionToActionTypeInventory(actiontype, components)
    for i, data in ipairs(components) do
        if data.component == "dst_gi_nahida_actions_data" then
            for _, entry in ipairs(data.prefab_actions) do
                NahidaAddPrefabPostInit(entry)
            end
        end
        AddComponentAction(actiontype, data.component, function(inst, doer, actions)
            if data.testfn and data.testfn(inst, doer, actions) then
                for _, entry in ipairs(data.prefab_actions) do
                    local prefab = entry.prefab
                    local prefabs = entry.prefabs
                    if  (prefab == nil or (prefabs ~= nil and table.contains(prefabs, inst.prefab))) or
                            (inst.prefab == prefab) then
                        if entry.testfn then
                            if entry.testfn(inst, doer, actions) then
                                if entry.actions then
                                    for action, action_data in pairs(entry.actions) do
                                        if  action_data.testfn and action_data.testfn(inst, doer, actions) then
                                            table.insert(actions, ACTIONS[string.upper(action)])
                                        end
                                    end
                                else
                                    if entry.action then
                                        table.insert(actions, ACTIONS[string.upper(entry.action)])
                                    end
                                end
                            end
                        else
                            table.insert(actions, ACTIONS[string.upper(entry.action)])
                        end
                        break
                    end
                end
            end
        end,modname)
    end
end

local function AddComponentActionToActionTypeUseitem(actiontype, components)
    for i, data in ipairs(components) do
        if data.component == "dst_gi_nahida_actions_data" then
            for _, entry in ipairs(data.prefab_actions) do
                NahidaAddPrefabPostInit(entry)
            end
        end
        AddComponentAction(actiontype, data.component, function(inst, doer, target, actions, right)
            if data.testfn and data.testfn(inst, doer, target, actions, right) then
                for _, entry in ipairs(data.prefab_actions) do
                    local prefab = entry.prefab
                    local prefabs = entry.prefabs
                    if (prefabs ~= nil and table.contains(prefabs, inst.prefab) or table.contains(prefabs, target.prefab)) or
                            (inst.prefab == prefab or target.prefab == prefab) then
                        if entry.testfn then
                            if entry.testfn(inst, doer, target, actions, right) then
                                if entry.actions then
                                    for action, action_data in pairs(entry.actions) do
                                        if  action_data.testfn and action_data.testfn(inst, doer, target, actions, right) then
                                            table.insert(actions, ACTIONS[string.upper(action)])
                                        end
                                    end
                                else
                                    if entry.action then
                                        table.insert(actions, ACTIONS[string.upper(entry.action)])
                                    end
                                end
                            end
                        else
                            table.insert(actions, ACTIONS[string.upper(entry.action)])
                        end
                        break
                    end
                end
            end
        end,modname)
    end
end

for actiontype, components in pairs(TUNING.NAHIDA_PREFAB_DATA) do
    if actiontype == "SCENE" then
        AddComponentActionToActionTypeScene(actiontype, components)
    end
    if actiontype == "INVENTORY" then
        AddComponentActionToActionTypeInventory(actiontype, components)
    end
    if actiontype == "USEITEM" then
        AddComponentActionToActionTypeUseitem(actiontype, components)
    end
end

--AddComponentAction("USEITEM", "dst_gi_nahida_actions_data", function(inst, doer, target, actions, right)
--    if right and target.prefab == "dst_gi_nahida_gacha_machine" then
--        table.insert(actions, ACTIONS.NAHIDA_WISH)
--    end
--end)

AddComponentAction("SCENE", "oceanfishable", function(inst, doer, actions, right)

    if right and doer:HasTag(TUNING.AVATAR_NAME)
            and doer:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)
            and inst:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FISH_TAG)
            and TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.CREATURE_FISH then
        table.insert(actions, ACTIONS.NAHIDA_TOUCH_A_MARINE_FISH)
    end
end)

for _, entry in ipairs(fish) do
    local prefab = entry.prefab
    -- 假设你要添加的组件是 "dst_gi_nahida_actions_data"
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_FISH_TAG)
        inst:RemoveTag("NOCLICK")
    end)
end