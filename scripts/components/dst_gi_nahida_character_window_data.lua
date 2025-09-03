---
--- dst_gi_nahida_character_window_data.lua
--- Description: 人物栏
--- Author: 旅行者
--- Date: 2025/8/16 16:16
---

-- 获取物品在物品栏中的槽位
local function GetItemSlotPosition(player, item)
    if not player or not item or not player.components.inventory then
        return nil
    end
    local inventory = player.components.inventory
    for slot, slot_item in pairs(inventory.itemslots) do
        if slot_item == item then
            return slot
        end
    end
    return nil
end

local function OnCharacter1(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_character_window_data then
        self.inst.replica.dst_gi_nahida_character_window_data:SetCharacter1(value)
    end
end
local function OnCharacter2(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_character_window_data then
        self.inst.replica.dst_gi_nahida_character_window_data:SetCharacter2(value)
    end
end
local function OnCharacter3(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_character_window_data then
        self.inst.replica.dst_gi_nahida_character_window_data:SetCharacter3(value)
    end
end

local function OnCharacter1CD(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_character_window_data then
        self.inst.replica.dst_gi_nahida_character_window_data:SetCharacter1CD(value)
    end
end
local function OnCharacter2CD(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_character_window_data then
        self.inst.replica.dst_gi_nahida_character_window_data:SetCharacter2CD(value)
    end
end
local function OnCharacter3CD(self, value)
    if self.inst.replica and self.inst.replica.dst_gi_nahida_character_window_data then
        self.inst.replica.dst_gi_nahida_character_window_data:SetCharacter3CD(value)
    end
end

local dst_gi_nahida_character_window_data = Class(function(self, inst)
    self.inst = inst
    self.character1 = ""
    self.character2 = ""
    self.character3 = ""
    self.character1_cd = 0
    self.character2_cd = 0
    self.character3_cd = 0

    -- 启动组件的更新，以便在游戏循环中定期调用 OnUpdate 方法
    self.inst:StartUpdatingComponent(self)
end,nil,{
    character1 = OnCharacter1,
    character1_cd = OnCharacter1CD,
    character2 = OnCharacter2,
    character2_cd = OnCharacter2CD,
    character3 = OnCharacter3,
    character3_cd = OnCharacter3CD,
})

-- 更新方法，每帧调用一次，用于更新技能和爆发的冷却时间
function dst_gi_nahida_character_window_data:OnUpdate(dt)
    -- 角色栏1
    if self.character1_cd > 0 then
        self.character1_cd = self.character1_cd - dt
        if self.character1_cd < 0 then
            self.character1_cd = 0 -- 确保冷却时间不为负
        end
    end
    -- 角色栏2
    if self.character2_cd > 0 then
        self.character2_cd = self.character2_cd - dt
        if self.character2_cd < 0 then
            self.character2_cd = 0 -- 确保冷却时间不为负
        end
    end

    -- 角色栏3
    if self.character3_cd > 0 then
        self.character3_cd = self.character3_cd - dt
        if self.character3_cd < 0 then
            self.character3_cd = 0 -- 确保冷却时间不为负
        end
    end
end

function dst_gi_nahida_character_window_data:RemoveCharacter(player,index)
    local character_info = self["character"..index]
    if character_info == nil or character_info == "" or character_info == "nil" then
        return false
    end
    if player.components.dst_gi_nahida_character_window_data == nil then
        return false
    end

    -- 使用分号分割字符串
    local parts = {}
    for part in string.gmatch(character_info, "([^;]+)") do
        if not (part == nil or part == "" or part == "nil") then
            table.insert(parts, part)
        end
    end
    -- 检查是否有足够的部分
    if #parts < 2 then
        return false
    end

    local character_name = parts[1]  -- 角色名
    local prefab_name = parts[2]     -- 预制体名
    self["character"..index] = ""
    local character_card = SpawnPrefab(prefab_name)
    if character_card ~= nil then
        player.components.inventory:GiveItem(character_card)
    end
    return true
end

function dst_gi_nahida_character_window_data:StartSkill(player,index)
    local character_info = self["character"..index]
    if character_info == nil or character_info == "" or character_info == "nil" then
        return false
    end
    if player.components.dst_gi_nahida_character_window_data == nil then
        return false
    end

    -- 使用分号分割字符串
    local parts = {}
    for part in string.gmatch(character_info, "([^;]+)") do
        if not (part == nil or part == "" or part == "nil") then
            table.insert(parts, part)
        end
    end
    -- 检查是否有足够的部分
    if #parts < 2 then
        return false
    end

    local character_name = parts[1]  -- 角色名
    local prefab_name = parts[2]     -- 预制体名
    if TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER and TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER[character_name] then
        if TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER[character_name][prefab_name] then
            local genshin_character = TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER[character_name][prefab_name]
            local var = genshin_character.fn(player)
            if var == true then
                self["character"..index.."_cd"] = genshin_character.cd
            end
            return true
        end
    end
    return false
end

function dst_gi_nahida_character_window_data:setCharacter(player, card)
    if player and card and card:HasTag("character_card") and card.character then
        local slot_position = GetItemSlotPosition(player, card)
        if slot_position == nil or slot_position > 3 then
            --player:DoTaskInTime(0.5, function()
            --    if player.components.talker then
            --        player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_ITEM_SLOT_POSITION_MSG)
            --    end
            --end)
            return false, "NAHIDA_ITEM_SLOT_POSITION_MSG"
        end

        local new_character = card.character..";"..card.prefab
        local character_slots = {self.character1, self.character2, self.character3}

        -- 情况3：如果使用的卡的位置和角色栏对应的位置同名，则返回false
        if character_slots[slot_position] == new_character then
            return false
        end

        -- 查找是否已有同名角色
        local existing_slot = nil
        for i = 1, 3 do
            if character_slots[i] == new_character then
                existing_slot = i
                break
            end
        end
        -- 情况2：如果已装备同名角色，进行位置替换（完全交换，包括nil）
        if existing_slot then
            local temp = character_slots[slot_position]
            character_slots[slot_position] = character_slots[existing_slot]
            character_slots[existing_slot] = temp
        else
            -- 情况1：直接装备到对应角色栏
            character_slots[slot_position] = new_character
        end
        -- 更新角色栏数据
        self.character1 = character_slots[1]
        self.character2 = character_slots[2]
        self.character3 = character_slots[3]
        card:Remove()
        return true
    end
    return false
end

function dst_gi_nahida_character_window_data:OnSave()
    return {
        character1 = self.character1,
        character2 = self.character2,
        character3 = self.character3,
        character1_cd = self.character1_cd,
        character2_cd = self.character2_cd,
        character3_cd = self.character3_cd,
    }
end

function dst_gi_nahida_character_window_data:OnLoad(data)
    if data then
        self.character1     = data.character1 or ""
        self.character2     = data.character2 or ""
        self.character3     = data.character3 or ""
        self.character1_cd = data.character1_cd
        self.character2_cd = data.character2_cd
        self.character3_cd = data.character3_cd
    end
end

return dst_gi_nahida_character_window_data