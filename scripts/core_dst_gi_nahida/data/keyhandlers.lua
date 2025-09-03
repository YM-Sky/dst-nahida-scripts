---@diagnostic disable: lowercase-global, undefined-global, trailing-space

---@type data_keyhandler[]

local data = {
    {
        namespace = TUNING.MOD_ID .. "_skill", -- 命名空间，通常使用 mod ID
        skillid = "all_schemes_to_know", -- 技能 ID  所闻遍记
        type = "down", -- 按键类型，按下
        avatar = { TUNING.MOD_ID }, -- 角色列表，哪些角色可以使用该技能
        key = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_skill"), -- 绑定的按键
        skill_template_type = "none",
        -- 触发的函数，服务器端执行
        fn = function(player)
            if player.components.health and not player.components.health:IsDead() and player.components.dst_gi_nahida_skill then
                player.components.dst_gi_nahida_skill:StartSkill(player)
            end

        end,
    },
    {
        namespace = TUNING.MOD_ID .. "_skill", -- 命名空间，通常使用 mod ID
        skillid = "illusory_heart", -- 技能 ID 心景幻城
        type = "down", -- 按键类型，按下
        avatar = { TUNING.MOD_ID }, -- 角色列表，哪些角色可以使用该技能
        key = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_skill_burst"), -- 绑定的按键
        skill_template_type = "none",
        -- 触发的函数，服务器端执行
        fn = function(player)
            -- 技能触发时的服务器端逻辑
            if player.components.health and not player.components.health:IsDead() and player.components.dst_gi_nahida_skill then
                player.components.dst_gi_nahida_skill:StartBurst(player)
            end
        end,
    },
    {
        namespace = TUNING.MOD_ID .. "_skill", -- 命名空间，通常使用 mod ID
        skillid = "actions_ability", -- 技能书快捷键
        type = "down", -- 按键类型，按下
        avatar = { TUNING.MOD_ID }, -- 角色列表，哪些角色可以使用该技能
        key = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_actions_ability_enable"), -- 绑定的按键
        skill_template_type = "none",
        client_rpc_data = function(player)
            local toclose
            if TheInput:IsKeyDown(KEY_CTRL) then
                if player.replica.inventory:Has("dst_gi_nahida_spellbook",1, true) then
                    if player.HUD then
                        local target
                        local classified = player.replica.inventory.classified
                        for k, v in pairs(classified._items) do
                            if v:value() ~= nil and v:value().prefab == "dst_gi_nahida_spellbook" then
                                target = v:value()
                                break
                            end
                        end
                        if target and target.components.spellbook and target.components.spellbook:CanBeUsedBy(player) then
                            if player.HUD:IsSpellWheelOpen() then
                                toclose = true
                                player.HUD:CloseSpellWheel()
                            else
                                local inventory = player.replica.inventory
                                if inventory and inventory:GetActiveItem() ~= target then
                                    inventory:ReturnActiveItem()
                                end
                                if player.components.playercontroller and player.components.playercontroller:IsEnabled() then
                                    --V2C: ShouldOpen is useful for silently blocking it
                                    --     eg. when classified commands are in a busy preview state
                                    if target.components.spellbook:ShouldOpen(player) then
                                        target.components.spellbook:OpenSpellBook(player)
                                    end
                                    if player.sg and player.sg:HasStateTag("overridelocomote") then
                                        player.sg.currentstate:HandleEvent(player.sg, "locomote")
                                    end
                                end
                                toclose = false
                            end
                        end
                    end
                end
            end
            local data = { KEY_CTRL = TheInput:IsKeyDown(KEY_CTRL) or false, toclose = toclose }
            return json.encode(data)
        end,
        -- 触发的函数，服务器端执行
        fn = function(player, client_rpc_data_json)
            if client_rpc_data_json then
                local client_rpc_data = json.decode(client_rpc_data_json)
                if client_rpc_data.KEY_CTRL then
                    if client_rpc_data.toclose then
                        BufferedAction(player, nil, ACTIONS.CLOSESPELLBOOK):Do()
                    else
                        if player.components.health and not player.components.health:IsDead() and player:HasTag(TUNING.AVATAR_NAME) and player.components.inventory:Has("dst_gi_nahida_spellbook", 1, true) then
                            local dst_gi_nahida_spellbook = player.components.inventory:FindItem(function(item)
                                return item.prefab == "dst_gi_nahida_spellbook"
                            end)
                            if dst_gi_nahida_spellbook ~= nil then
                                BufferedAction(player, nil, ACTIONS.USESPELLBOOK, dst_gi_nahida_spellbook):Do()
                            end
                        end
                    end
                end
            end
        end,
    },
    {
        namespace = TUNING.MOD_ID .. "_skill", -- 命名空间，通常使用 mod ID
        skillid = "right_click_actions_enable", -- 右键动作开关按键
        type = "down", -- 按键类型，按下
        avatar = nil, -- 角色列表，哪些角色可以使用该技能
        key = TUNING.MOD_DST_GI_NAHIDA_CONFIG("_right_click_actions_enable"), -- 绑定的按键
        skill_template_type = "none",
        client_rpc_data = function(player)
            local data = { KEY_CTRL = TheInput:IsKeyDown(KEY_CTRL) or false}
            return json.encode(data)
        end,
        -- 触发的函数，服务器端执行
        fn = function(player, client_rpc_data_json)
            if client_rpc_data_json then
                local client_rpc_data = json.decode(client_rpc_data_json)
                if client_rpc_data.KEY_CTRL then
                    --if player:HasTag(TUNING.AVATAR_NAME) then
                    --
                    --end
                    if player:HasTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG) then
                        player:RemoveTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)
                        if player.components.talker then
                            player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_DISABLE_RIGHT_CLICK_ACTION)
                        end
                    else
                        player:AddTag(TUNING.MOD_DST_GI_NAHIDA.NAHIDA_RIGHT_CLICK_ACTION_TAG)
                        if player.components.talker then
                            player.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_ENABLED_RIGHT_CLICK_ACTION)
                        end
                    end
                end
            end
        end,
    },
    {
        namespace = TUNING.MOD_ID .. "_weapons_skill", -- 命名空间，通常使用 mod ID
        skillid = "weapons_skill", -- 右键动作开关按键
        type = "down", -- 按键类型，按下
        avatar = nil, -- 角色列表，哪些角色可以使用该技能
        key = MOUSEBUTTON_RIGHT, -- 绑定的按键
        skill_template_type = "none",
        input_type = "mouse",
        -- 客户端执行的函数，在发送RPC之前
        client_fn_before = function(player, x, y)
            if player:HasTag("playerghost")
                    or (player.components.health and player.components.health:IsDead())
            then
                return false
            end
            -- 检查是否装备了纳西妲武器（客户端方法）
            local weapon = player.replica.inventory and player.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if not weapon or not (weapon:HasTag("dst_gi_nahida_weapons") and weapon:HasTag("dst_gi_nahida_weapons_skill")) then
                return
            end
            -- 检查是否已经有活跃的指示器，如果有则关闭它
            if player._aoe_targeting_end_fn then
                print("关闭当前指示器")
                player._aoe_targeting_end_fn()
                player._aoe_targeting_end_fn = nil
                return
            end
            if TheInput:IsKeyDown(KEY_CTRL) and TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.FREEZE_WEAPON_ENABLE then
                -- 创建新的指示器
                local endFn = GetPrefab.CreateAoeTargeting(player, function(pos)
                    -- 在客户端创建指示器，点击后发送RPC到服务器
                    local namespace = TUNING.MOD_ID .. "_weapons_skill"
                    local skillid = "weapons_skill"
                    local full_id = string.upper(namespace) .. string.upper(skillid)
                    SendModRPCToServer(MOD_RPC[namespace][full_id], pos.x, pos.y, pos.z)
                    -- 清理指示器引用
                    player._aoe_targeting_end_fn = nil
                end, {
                    reticulePrefab = "reticule", --指示器
                    pingPrefab = "reticuleaoeping", --指示器
                    mouseEnabled = true, --鼠标控制
                    reticuleFollowMouse = true, --指示器跟随鼠标
                    spellMinDis = 8,
                })
                -- 保存结束函数的引用
                player._aoe_targeting_end_fn = endFn
            end
        end,
        client_rpc_data = function(player, x, y)
            -- 阻止默认的RPC发送，因为我们在client_fn_before中手动发送
            return nil
        end,
        -- 触发的函数，服务器端执行
        fn = function(player, x, y, z)
            if x and y and z then
                local pos = Vector3(x, y, z)
                local weapon = player.components.inventory and player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if not weapon or not (weapon:HasTag("dst_gi_nahida_weapons") and weapon:HasTag("dst_gi_nahida_weapons_skill")) then
                    return
                end
                if weapon.SpellFn then
                    weapon.SpellFn(weapon,player,pos)
                end

            end
        end,
    },
}

return data