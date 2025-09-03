---@diagnostic disable: undefined-global
---
--- i26_widgetcreation.lua
--- Description: 容器
--- Author: 没有小钱钱
--- Date: 2025/3/1 11:36
---

GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})

local containers = require "containers"
local params = containers.params
local enable_slot_bg = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_enable_slot_bg")

local SLOT_BG = { image = "dst_gi_nahida_spore_slot.tex", atlas = "images/inventoryimages/dst_gi_nahida_spore_slot.xml" }
local SAVE_SLOT_BG = { image = "dst_gi_nahida_save_spore_slot.tex", atlas = "images/inventoryimages/dst_gi_nahida_save_spore_slot.xml" }
local DEL_SLOT_BG = { image = "dst_gi_nahida_del_spore_slot.tex", atlas = "images/inventoryimages/dst_gi_nahida_del_spore_slot.xml" }

params.dst_gi_nahida_dress3 = {
    widget = {
        slotpos = {},
        animbank = "dst_gi_nahida_dress_backpack3",
        animbuild = "dst_gi_nahida_dress_backpack3",
        slotbg = {},
        pos = Vector3(-160, -70, 0),
        buttoninfo = nil
    },
    issidewidget = true,
    type = "dst_gi_nahida_dress3",
    openlimit = 1,
}
-- -110 -428
-- -30 -348
for y = 0, 7 do
    for x = 0, 3 do
        table.insert(params.dst_gi_nahida_dress3.widget.slotpos, Vector3(75 * (x - 2) + 45, 75 * (y - 2) - 273, 0))
        if enable_slot_bg and enable_slot_bg == "enabled" then
            table.insert(params.dst_gi_nahida_dress3.widget.slotbg, SLOT_BG)
        end
    end
end

params.dst_gi_nahida_dress2 = {
    widget = {
        slotpos = {},
        animbank = "dst_gi_nahida_dress_backpack2",
        animbuild = "dst_gi_nahida_dress_backpack2",
        slotbg = {},
        pos = Vector3(-160, -70, 0),
        buttoninfo = nil
    },
    issidewidget = true,
    type = "dst_gi_nahida_dress2",
    openlimit = 1,
}
-- -110 -428
-- -30 -348
for y = 0, 5 do
    for x = 0, 3 do
        table.insert(params.dst_gi_nahida_dress2.widget.slotpos, Vector3(75 * (x - 2) + 45, 75 * (y - 2) - 273, 0))
        if enable_slot_bg and enable_slot_bg == "enabled" then
            table.insert(params.dst_gi_nahida_dress2.widget.slotbg, SLOT_BG)
        end
    end
end

params.dst_gi_nahida_dress = {
    widget = {
        slotpos = {},
        animbank = "dst_gi_nahida_dress_backpack",
        animbuild = "dst_gi_nahida_dress_backpack",
        slotbg = {},
        pos = Vector3(-160, -70, 0),
        buttoninfo = nil
    },
    issidewidget = true,
    type = "dst_gi_nahida_dress",
    openlimit = 1,
}
-- -110 -428
-- -30 -348
for y = 0, 3 do
    for x = 0, 3 do
        table.insert(params.dst_gi_nahida_dress.widget.slotpos, Vector3(75 * (x - 2) + 45, 75 * (y - 2) - 273, 0))
        if enable_slot_bg and enable_slot_bg == "enabled" then
            table.insert(params.dst_gi_nahida_dress.widget.slotbg, SLOT_BG)
        end
    end
end

params.dst_gi_nahida_treasure_chest = {
    widget = {
        slotpos = {},
        animbank = "dst_gi_nahida_chest_5x6",
        animbuild = "dst_gi_nahida_chest_5x6",
        slotbg = {},
        pos = Vector3(0, 150, 0),
    },
    type = "chest",
}

for y = 2.5, -2.5, -1 do
    for x = -2, 2 do
        table.insert(params.dst_gi_nahida_treasure_chest.widget.slotpos, Vector3(75 * x, 75 * y, 0))
        if enable_slot_bg and enable_slot_bg == "enabled" then
            table.insert(params.dst_gi_nahida_treasure_chest.widget.slotbg, SLOT_BG)
        end
    end
end

params.dst_gi_nahida_toy_chest = {
    widget = {
        slotpos = {},
        animbank = "dst_gi_nahida_chest_toy_5x6",
        animbuild = "dst_gi_nahida_chest_toy_5x6",
        slotbg = {},
        pos = Vector3(0, 150, 0),
    },
    type = "chest",
}

-- 冰箱可以放的物品
function params.dst_gi_nahida_toy_chest.itemtestfn(container, item, slot)
    -- antliontrinket 沙滩玩具 cotl_trinket 红眼冠
    if item:HasTag("trinket") or item:HasTag("cattoy") or item.prefab == "antliontrinket" or item.prefab == "cotl_trinket" then
        return true
    end
    return false
end

for y = 2.5, -2.5, -1 do
    for x = -2, 2 do
        table.insert(params.dst_gi_nahida_toy_chest.widget.slotpos, Vector3(75 * x, 75 * y, 0))
        if enable_slot_bg and enable_slot_bg == "enabled" then
            table.insert(params.dst_gi_nahida_toy_chest.widget.slotbg, SLOT_BG)
        end
    end
end

params.dst_gi_nahida_ice_box = {
    widget = {
        slotpos = {},
        animbank = "dst_gi_nahida_chest_ice_5x6",
        animbuild = "dst_gi_nahida_chest_ice_5x6",
        slotbg = {},
        pos = Vector3(0, 250, 0),
    },
    type = "chest",
}
-- 冰箱可以放的物品
function params.dst_gi_nahida_ice_box.itemtestfn(container, item, slot)
    if item:HasTag("icebox_valid") then
        return true
    end
    -- 支持注能月亮碎片
    if item.prefab == "moonglass_charged" then
        return true
    end
    --Perishable
    if not (item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled")) then
        return false
    end
    --Edible
    for k, v in pairs(FOODTYPE) do
        if item:HasTag("edible_" .. v) then
            return true
        end
    end
    return false
end

for y = 2.5, -2.5, -1 do
    for x = -2, 2 do
        table.insert(params.dst_gi_nahida_ice_box.widget.slotpos, Vector3(75 * x, 75 * y, 0))
        if enable_slot_bg and enable_slot_bg == "enabled" then
            table.insert(params.dst_gi_nahida_ice_box.widget.slotbg, SLOT_BG)
        end
    end
end

params.dst_gi_nahida_birthday_gift_box = {
    widget = {
        slotpos = {},
        animbank = "dst_gi_nahida_chest_birthday_gift_box_5x6",
        animbuild = "dst_gi_nahida_chest_birthday_gift_box_5x6",
        slotbg = {},
        pos = Vector3(0, 80, 0),
        buttoninfos = {
            { -- 这里就是给容器添加一个按钮,限制蛮多的,不熟悉的时候也不建议弄直接 删掉或者buttoninfo= nil就行
                action = "NAHIDA_ONE_CLICK_CONVERSION",
                text = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_ONE_CLICK_CONVERSION,
                position = Vector3(-70, -240, 0),
                fn = function(inst, doer)
                    if inst.components.container ~= nil then
                        inst:PushEvent("dst_gi_nahida_birthday_gift_box_one_click_conversion",{ doer = doer })
                    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                        SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
                    end
                end
            },
            { -- 这里就是给容器添加一个按钮,限制蛮多的,不熟悉的时候也不建议弄直接 删掉或者buttoninfo= nil就行
                action = "NAHIDA_GATHER",
                text = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_GATHER,
                position = Vector3(70, -240, 0),
                fn = function(inst, doer)
                    if inst.components.container ~= nil then
                        inst:PushEvent("dst_gi_nahida_birthday_gift_box_nahida_gather",{ doer = doer })
                    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                        SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
                    end
                end
            }
        },
    },
    type = "dst_gi_nahida_birthday_gift_box",
}

-- �� 添加物品测试函数，禁止装进礼盒本身
function params.dst_gi_nahida_birthday_gift_box.itemtestfn(container, item, slot)
    -- 禁止装进生日礼盒本身
    if item.prefab == "dst_gi_nahida_birthday_gift_box" then
        return false
    end
    -- 禁止装进任何有容器组件的物品，防止无限嵌套
    if item.components.container ~= nil then
        return false
    end
    return true
end

for y = 2.5, -2.5, -1 do
    for x = -2, 2 do
        table.insert(params.dst_gi_nahida_birthday_gift_box.widget.slotpos, Vector3(75 * x, 75 * y, 0))
        if enable_slot_bg and enable_slot_bg == "enabled" then
            table.insert(params.dst_gi_nahida_birthday_gift_box.widget.slotbg, SLOT_BG)
        end
    end
end

params.dst_gi_nahida_gacha_machine = {
    widget = {
        slotpos = {},
        animbank = "dst_gi_nahida_gacha_machine_8x9",
        animbuild = "dst_gi_nahida_gacha_machine_8x9",
        slotbg = {},
        pos = Vector3(0, 150, 0),
        buttoninfos = {
            { -- 这里就是给容器添加一个按钮,限制蛮多的,不熟悉的时候也不建议弄直接 删掉或者buttoninfo= nil就行
                action = "wish",
                text = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_WISH,
                position = Vector3(0, -350, 0),
                fn = function(inst, doer)
                    if inst.components.container ~= nil then
                        inst:PushEvent("dst_gi_nahida_gacha_machine_wish", { doer = doer })
                    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                        SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
                    end
                end
            },
            { -- 这里就是给容器添加一个按钮,限制蛮多的,不熟悉的时候也不建议弄直接 删掉或者buttoninfo= nil就行
                action = "clear",
                text = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_CONTAINERS_DROP,
                position = Vector3(-200, -350, 0),
                fn = function(inst, doer)
                    if inst.components.container ~= nil then
                        inst:PushEvent("dst_gi_nahida_gacha_machine_drop", { doer = doer })
                    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                        SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
                    end
                end
            }
        }
    },
    type = "chest",
}

params.dst_gi_nahida_shipwrecked_boat =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(params.dst_gi_nahida_shipwrecked_boat.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

params.dst_gi_nahida_shipwrecked_boat2 =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
        buttoninfos = {
            { -- 这里就是给容器添加一个按钮,限制蛮多的,不熟悉的时候也不建议弄直接 删掉或者buttoninfo= nil就行
                action = "SALVAGE",
                text = STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_SALVAGE,
                position = Vector3(0, -160, 0),
                fn = function(inst, doer)
                    if inst.components.container ~= nil then
                        inst:PushEvent("nahida_salvage",{ doer = doer })
                    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
                        SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
                    end
                end
            }
        },
    },
    type = "chest",
}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(params.dst_gi_nahida_shipwrecked_boat2.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end


params.dst_gi_nahida_weapon_staff = {
    widget = {
        slotpos = {
            Vector3(-2, 18, 0),
        },
        animbank = "ui_alterguardianhat_1x1",
        animbuild = "ui_alterguardianhat_1x1",
        slotbg = {
            { image = "spore_slot.tex", atlas = "images/hud2.xml" },
        },
        pos = Vector3(0, 160, 0),
        usespecificslotsforitems = true,
    },
    acceptsstacks = false,
    type = "chest",
}


function params.dst_gi_nahida_weapon_staff.itemtestfn(container, item, slot)
    return item:HasTag("dst_gi_nahida_weapons") and item.prefab ~= "dst_gi_nahida_weapon_staff"
end

-- 8x9格子
-- x从-4到4，共9列
--y从3.5到-3.5，共8行
--x==4时判断y，y>=0.5为上4行用SAVE_SLOT_BG，否则用DEL_SLOT_BG
--其余用SLOT_BG
for y = 3.5, -3.5, -1 do
    for x = -4, 4 do
        table.insert(params.dst_gi_nahida_gacha_machine.widget.slotpos, Vector3(75 * x, 75 * y, 0))
        -- 判断第9列
        if x == 4 then
            if y >= 0.5 then
                table.insert(params.dst_gi_nahida_gacha_machine.widget.slotbg, SAVE_SLOT_BG)
            else
                table.insert(params.dst_gi_nahida_gacha_machine.widget.slotbg, DEL_SLOT_BG)
            end
        else
            if enable_slot_bg and enable_slot_bg == "enabled" then
                table.insert(params.dst_gi_nahida_gacha_machine.widget.slotbg, SLOT_BG)
            else
                table.insert(params.dst_gi_nahida_gacha_machine.widget.slotbg, {})
            end
        end
    end
end

for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

for prefab, v in pairs(params) do
    if v.widget and v.widget.buttoninfos then
        TUNING.DST_GI_NAHIDA_CONTAINER_ACTIONS[prefab] = TUNING.DST_GI_NAHIDA_CONTAINER_ACTIONS[prefab] or {}
        for _, info in ipairs(v.widget.buttoninfos) do
            if info.action and info.fn then
                TUNING.DST_GI_NAHIDA_CONTAINER_ACTIONS[prefab][info.action] = info.fn
            end
        end
    end
end

AddClassPostConstruct("widgets/containerwidget", function(self)
    local old_Open = self.Open
    self.Open = function(self, container, doer, ...)
        old_Open(self, container, doer, ...)
        -- 清理旧按钮
        if self._custom_btns then
            for _, btn in ipairs(self._custom_btns) do
                btn:Kill()
            end
        end
        self._custom_btns = {}
        -- 动态查找当前容器的buttoninfos
        for prefab, v in pairs(params) do
            if container and container.prefab == prefab and v.widget and v.widget.buttoninfos then
                local buttoninfos = v.widget.buttoninfos
                local ImageButton = require "widgets/imagebutton"
                for _, info in ipairs(buttoninfos) do
                    local btn = self:AddChild(ImageButton("images/ui/button2.xml", "button2.tex"))
                    btn:SetPosition(info.position.x, info.position.y, info.position.z or 0)
                    btn:SetScale(1.0)
                    btn:SetText(info.text)
                    btn.text:SetSize(38)  -- 只改字体大小，不影响图片
                    btn:SetOnClick(function()
                        if info.action then
                            print("打印发送RPC", info.action)
                            SendModRPCToServer(
                                    GetModRPC("dst_gi_nahida_container", "dst_gi_nahida_container_fn"),
                                    info.action,
                                    container
                            )
                        end
                    end)
                    table.insert(self._custom_btns, btn)
                end
            end
        end
    end
end)




