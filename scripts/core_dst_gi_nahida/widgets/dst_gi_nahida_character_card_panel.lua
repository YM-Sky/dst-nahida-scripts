---
--- dst_gi_nahida_character_card_panel.lua
--- Description: 角色技能栏
--- Author: 旅行者
--- Date: 2025/8/3 19:50
---
local Widget = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NihidaGwidget')
local Text = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NihidaGText')
local Image = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NahidaGimage')
local ImageButton = require('core_'..TUNING.MOD_ID..'/widgets/genshin_widgets/NahidaGimagebutton')

local P2 = {1, 1, 1, 1}

local dst_gi_nahida_character_card_panel = Class(Widget, function(self, owner)
    Widget._ctor(self, "dst_gi_nahida_character_card_panel")

    self.owner = owner
    self.container = self:AddChild(Widget("container"))


    self.bg = self:AddChild(Image("images/ui/dst_gi_nahida_character_card_panel.xml", "dst_gi_nahida_character_card_panel.tex"))
    self.bg:SetPosition(0,0,0)
    self.bg:SetScale(0.8,0.8,0.8)
    --self.bg:ForceImageSize(PANEL_W, PANEL_H)
    self.bg:MoveToBack()

    self.dst_gi_nahida_card_one = self.container:AddChild(ImageButton("images/ui/dst_gi_nahida_character_bg.xml", "dst_gi_nahida_character_bg.tex"))
    self.dst_gi_nahida_card_one:SetPosition(-65,0,0)
    self.dst_gi_nahida_card_one:SetScale(0.8,0.8,0.8)
    --self.dst_gi_nahida_card_one:SetOnClick(function()
    --end)
    self.dst_gi_nahida_card_one_cd = self.container:AddChild(Text(HEADERFONT, 38, "", P2))
    self.dst_gi_nahida_card_one_cd:SetPosition(-65,50,0)

    self.dst_gi_nahida_card_two = self.container:AddChild(ImageButton("images/ui/dst_gi_nahida_character_bg.xml", "dst_gi_nahida_character_bg.tex"))
    self.dst_gi_nahida_card_two:SetPosition(0,0,0)
    self.dst_gi_nahida_card_two:SetScale(0.8,0.8,0.8)
    --self.dst_gi_nahida_card_one:SetOnClick(function()
    --end)

    self.dst_gi_nahida_card_two_cd = self.container:AddChild(Text(HEADERFONT, 38, "", P2))
    self.dst_gi_nahida_card_two_cd:SetPosition(0,50,0)


    self.dst_gi_nahida_card_three = self.container:AddChild(ImageButton("images/ui/dst_gi_nahida_character_bg.xml", "dst_gi_nahida_character_bg.tex"))
    self.dst_gi_nahida_card_three:SetPosition(60,0,0)
    self.dst_gi_nahida_card_three:SetScale(0.8,0.8,0.8)
    --self.dst_gi_nahida_card_one:SetOnClick(function()
    --end)
    self.dst_gi_nahida_card_three_cd = self.container:AddChild(Text(HEADERFONT, 38, "", P2))
    self.dst_gi_nahida_card_three_cd:SetPosition(60,50,0)

    self.owner:ListenForEvent(TUNING.MOD_ID.."_character1_change_event", function(_owner, data)
        if not data or not data.character1 then return end
        self:UpdateCardImages1(data.character1)
    end)
    self.owner:ListenForEvent(TUNING.MOD_ID.."_character2_change_event", function(_owner, data)
        if not data or not data.character2 then return end
        self:UpdateCardImages2(data.character2)
    end)
    self.owner:ListenForEvent(TUNING.MOD_ID.."_character3_change_event", function(_owner, data)
        if not data or not data.character3 then return end
        self:UpdateCardImages3(data.character3)
    end)
    self.owner:ListenForEvent(TUNING.MOD_ID.."_character1_cd_change_event", function(_owner, data)
        if not data or not data.character1_cd then return end
        local formatted_cd = string.format("%.2f", data.character1_cd)
        if data.character1_cd == 0 or formatted_cd == "0.00" then
            self.dst_gi_nahida_card_one_cd:SetString("")
        else
            self.dst_gi_nahida_card_one_cd:SetString(formatted_cd)
        end
    end)

    self.owner:ListenForEvent(TUNING.MOD_ID.."_character2_cd_change_event", function(_owner, data)
        if not data or not data.character2_cd then return end
        local formatted_cd = string.format("%.2f", data.character2_cd)
        if data.character2_cd == 0 or formatted_cd == "0.00" then
            self.dst_gi_nahida_card_two_cd:SetString("")
        else
            self.dst_gi_nahida_card_two_cd:SetString(formatted_cd)
        end
    end)

    self.owner:ListenForEvent(TUNING.MOD_ID.."_character3_cd_change_event", function(_owner, data)
        if not data or not data.character3_cd then return end
        local formatted_cd = string.format("%.2f", data.character3_cd)
        if data.character3_cd == 0 or formatted_cd == "0.00" then
            self.dst_gi_nahida_card_three_cd:SetString("")
        else
            self.dst_gi_nahida_card_three_cd:SetString(formatted_cd)
        end
    end)

end)

function dst_gi_nahida_character_card_panel:InitSetOnClick(button,index)
    if button then
        button:SetTooltip(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CHARACTER_CARD_PANEL_BUTTON_TIPS)
        button:SetOnClick(function()
            SendModRPCToServer(GetModRPC("dst_gi_nahida_character_window", "character_window_kill"),index)
        end)
        -- 保存原始的 OnControl 方法
        local original_OnControl = button.OnControl
        -- 重写 OnControl 方法添加右键支持
        button.OnControl = function(self, control, down)
            -- 处理右键点击
            if control == CONTROL_SECONDARY and down and self:IsEnabled() and self.focus then
                SendModRPCToServer(GetModRPC("dst_gi_nahida_character_window", "character_window_right_click"), index)
                return true
            end
            -- 调用原始的 OnControl 处理左键等其他控制
            return original_OnControl(self, control, down)
        end
    end
end

-- 添加更新卡片图片的方法
function dst_gi_nahida_character_card_panel:UpdateCardImages1(character)
    self.dst_gi_nahida_card_one = nil
    self.dst_gi_nahida_card_one = self.container:AddChild(ImageButton("images/ui/dst_gi_nahida_character_bg.xml", "dst_gi_nahida_character_bg.tex"))
    self.dst_gi_nahida_card_one:SetPosition(-65,0,0)
    self.dst_gi_nahida_card_one:SetScale(0.8,0.8,0.8)
    if character == nil or character == "" or character == "nil" then return end

    -- 使用分号分割字符串
    local parts = {}
    for part in string.gmatch(character, "([^;]+)") do
        if not (part == nil or part == "" or part == "nil") then
            table.insert(parts, part)
        end
    end
    -- 检查是否有足够的部分
    if #parts < 2 then
        return
    end
    local character_name = parts[1]  -- 角色名
    local prefab_name = parts[2]     -- 预制体名
    if TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER and TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER[character_name] then
        if TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER[character_name][prefab_name] then
            local genshin_character = TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER[character_name][prefab_name]
            self.dst_gi_nahida_card_one = nil
            self.dst_gi_nahida_card_one = self.container:AddChild(ImageButton(genshin_character.atlas, genshin_character.image))
            self.dst_gi_nahida_card_one:SetPosition(-65,0,0)
            self.dst_gi_nahida_card_one:SetScale(0.8,0.8,0.8)
            self:InitSetOnClick(self.dst_gi_nahida_card_one,1)
        end
    end
end

function dst_gi_nahida_character_card_panel:UpdateCardImages2(character)

    self.dst_gi_nahida_card_two = nil
    self.dst_gi_nahida_card_two = self.container:AddChild(ImageButton("images/ui/dst_gi_nahida_character_bg.xml", "dst_gi_nahida_character_bg.tex"))
    self.dst_gi_nahida_card_two:SetPosition(0,0,0)
    self.dst_gi_nahida_card_two:SetScale(0.8,0.8,0.8)

    if character == nil or character == "" or character == "nil" then return end
    -- 使用分号分割字符串
    local parts = {}
    for part in string.gmatch(character, "([^;]+)") do
        if not (part == nil or part == "" or part == "nil") then
            table.insert(parts, part)
        end
    end

    -- 检查是否有足够的部分
    if #parts < 2 then
        return
    end
    local character_name = parts[1]  -- 角色名
    local prefab_name = parts[2]     -- 预制体名
    if TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER and TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER[character_name] then
        if TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER[character_name][prefab_name] then
            local genshin_character = TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER[character_name][prefab_name]
            self.dst_gi_nahida_card_two = nil
            self.dst_gi_nahida_card_two = self.container:AddChild(ImageButton(genshin_character.atlas, genshin_character.image))
            self.dst_gi_nahida_card_two:SetPosition(0,0,0)
            self.dst_gi_nahida_card_two:SetScale(0.8,0.8,0.8)
            self:InitSetOnClick(self.dst_gi_nahida_card_two,2)
        end
    end
end

function dst_gi_nahida_character_card_panel:UpdateCardImages3(character)

    self.dst_gi_nahida_card_three = nil
    self.dst_gi_nahida_card_three = self.container:AddChild(ImageButton("images/ui/dst_gi_nahida_character_bg.xml", "dst_gi_nahida_character_bg.tex"))
    self.dst_gi_nahida_card_three:SetPosition(60,0,0)
    self.dst_gi_nahida_card_three:SetScale(0.8,0.8,0.8)

    if character == nil or character == "" or character == "nil" then return end
    -- 使用分号分割字符串
    local parts = {}
    for part in string.gmatch(character, "([^;]+)") do
        if not (part == nil or part == "" or part == "nil") then
            table.insert(parts, part)
        end
    end

    -- 检查是否有足够的部分
    if #parts < 2 then
        return
    end
    local character_name = parts[1]  -- 角色名
    local prefab_name = parts[2]     -- 预制体名
    if TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER and TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER[character_name] then
        if TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER[character_name][prefab_name] then
            local genshin_character = TUNING.MOD_DST_GI_NAHIDA.GENSHIN_CHARACTER[character_name][prefab_name]
            self.dst_gi_nahida_card_three = nil
            self.dst_gi_nahida_card_three = self.container:AddChild(ImageButton(genshin_character.atlas, genshin_character.image))
            self.dst_gi_nahida_card_three:SetPosition(60,0,0)
            self.dst_gi_nahida_card_three:SetScale(0.8,0.8,0.8)
            self:InitSetOnClick(self.dst_gi_nahida_card_three,3)
        end
    end
end


return dst_gi_nahida_character_card_panel