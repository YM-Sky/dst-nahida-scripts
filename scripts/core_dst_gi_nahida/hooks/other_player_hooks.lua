---
--- other_player_hooks.lua
--- Description: 其他玩家hooks
--- Author: 旅行者
--- Date: 2025/7/26 23:15
---
local OnSave = function(inst, data)
    data.nahida_survival_days = inst.nahida_survival_days or 0
    data.nahida_fateseat_count = inst.nahida_fateseat_count or 0
end

local OnLoad = function(inst, data)
    inst.nahida_survival_days = data.nahida_survival_days or 0
    inst.nahida_fateseat_count = data.nahida_fateseat_count or 0
end

local function CheckAndGiveFateseat(inst)
    local _fateseat_presented_enable = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_fateseat_presented_enable") == "enabled"
    if _fateseat_presented_enable then
        local _fateseat_presented_number = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_fateseat_presented_number") or 10
        if inst.components.nahida_fateseat_presented_record_data then
            -- 增加生存天数
            inst.components.nahida_fateseat_presented_record_data.nahida_survival_days = (inst.components.nahida_fateseat_presented_record_data.nahida_survival_days or 0) + 1
            -- 检查是否满足赠送条件
            if inst.components.nahida_fateseat_presented_record_data.nahida_survival_days % _fateseat_presented_number == 0 then
                inst.components.nahida_fateseat_presented_record_data.nahida_fateseat_count = (inst.components.nahida_fateseat_presented_record_data.nahida_fateseat_count or 0) + 1
                -- 这里可以添加赠送命座的具体逻辑，比如调用某个函数或触发事件
                print(string.format("%s玩家生存了 %d 天! 赠送命座数量: %d",
                        inst.userid,inst.components.nahida_fateseat_presented_record_data.nahida_survival_days, inst.components.nahida_fateseat_presented_record_data.nahida_fateseat_count))
                local fateseat = SpawnPrefab("dst_gi_nahida_fateseat")
                if fateseat ~= nil and inst.components.inventory then
                    inst.components.inventory:GiveItem(fateseat)
                end

            end
        end
    end
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)
    inst:AddComponent("dst_gi_nahida_character_window_data")
    inst:AddComponent("nahida_fateseat_presented_record_data")

    inst:ListenForEvent("cycleschanged", function(world, cycles)
        -- 重置玩具桌属性状态
        if inst.components.dst_gi_nahida_toy_desk_data then
            inst.components.dst_gi_nahida_toy_desk_data.toy_count = 0
        end
        if inst:HasTag(TUNING.AVATAR_NAME) then
            -- 检查并赠送命座
            CheckAndGiveFateseat(inst)
        end
    end, TheWorld)

    --TheInput:AddKeyDownHandler(KEY_V, function()
    --    print("快捷键V999999999999999999")
    --    if inst == ThePlayer  then
    --        print("快捷键V77777777777")
    --        if _G.ShowSpellWheel then
    --            print("快捷键V6666666666666666")
    --            _G.ShowSpellWheel()
    --        end
    --    end
    --end)
    --TheInput:AddKeyUpHandler(KEY_V, function()
    --    print("快捷键V888888888888888888")
    --    if inst == ThePlayer then
    --        print("快捷键V55555555555555")
    --        if _G.HideSpellWheel then
    --            print("快捷键V4444444444444444")
    --            _G.HideSpellWheel()
    --        end
    --    end
    --end)
end)
