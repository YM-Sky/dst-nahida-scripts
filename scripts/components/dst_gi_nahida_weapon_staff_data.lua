---
--- dst_gi_nahida_weapon_staff_data.lua
--- Description: 神明的法杖
--- Author: 没有小钱钱
--- Date: 2025/6/7 23:50
---

local function OnWeaponStaffCurrentModel(self, value)
    self.inst.net_dst_gi_nahida_weapon_staff_current_model:set(value)
end
local function OnOpalpreciousgemCount(self, value)
    self.inst.net_dst_gi_nahida_weapon_staff_opalpreciousgem_count:set(value)
end

local function NoHoles(pt)
    return not TheWorld.Map:IsGroundTargetBlocked(pt)  -- 确保不是洞穴/阻挡点
end

local function blinkstaff_reticuletargetfn()
    return ControllerReticle_Blink_GetPosition(ThePlayer, NoHoles)
end

local function onblink(staff, pos, caster)
    if caster then
        -- 消耗理智值
        if caster.components.staffsanity then
            caster.components.staffsanity:DoCastingDelta(-TUNING.SANITY_MED)
        elseif caster.components.sanity ~= nil then
            caster.components.sanity:DoDelta(-TUNING.SANITY_MED)
        end
    end
    ---- 消耗耐久
    staff.components.finiteuses:Use(1)
end

-- 🔥 字段配置：定义每个字段的处理方式
local FIELD_CONFIG = {
    active = "state", -- 状态数据，从存档恢复
    count = "state", -- 状态数据，从存档恢复
    max_count = "config", -- 配置数据，始终使用最新代码值
    -- 如果有其他字段，在这里添加配置
}

local dst_gi_nahida_weapon_staff_data = Class(function(self, inst)
    self.inst = inst
    self.owner = nil
    self.WEAPON_STAFF_MODE = {
        [1] = "NORMAL",
        [2] = "DESTROY",
        [3] = "TRANSMITTED",
    }
    self.active_data = self:GetDefaultActiveData()
    self.current_model = self.WEAPON_STAFF_MODE[1]
end, nil, {
    current_model = OnWeaponStaffCurrentModel,
})


-- 🔥 获取默认数据的函数
function dst_gi_nahida_weapon_staff_data:GetDefaultActiveData()
    return {
        goldnugget = {
            active = false,
            count = 0,
            max_count = 900,
        },
        opalpreciousgem = {
            active = false,
            count = 0,
            max_count = TUNING.MOD_DST_GI_NAHIDA_FATESEAT_CURRENT_CONFIG.DST_GI_NAHIDA_WEAPON_STAFF_EJECTION * 10,
        },
        walrus_tusk = {
            active = false,
            count = 0,
            max_count = 2,
        },
        opalstaff = {
            active = false,
            count = 0,
            max_count = 2,
        },
        multitool_axe_pickaxe = {
            active = false,
        },
        orangestaff = {
            active = false,
        },
        yellowstaff = {
            active = false,
        }
    }
end


-- 🔥 安全合并函数（更明确的版本）
function dst_gi_nahida_weapon_staff_data:MergeActiveData(loaded_data)
    local default_data = self:GetDefaultActiveData()

    if not loaded_data then
        return default_data
    end

    -- 逐个合并每个数据项
    for key, default_item in pairs(default_data) do
        if loaded_data[key] and type(default_item) == "table" then
            -- 如果加载数据中有这个key，根据字段配置合并
            for sub_key, default_value in pairs(default_item) do
                local field_type = FIELD_CONFIG[sub_key]
                -- 🔥 只有标记为"state"的字段才从存档恢复
                if loaded_data[key][sub_key] ~= nil and field_type == "state" then
                    default_item[sub_key] = loaded_data[key][sub_key]
                end
                -- 标记为"config"或未配置的字段保持使用最新默认值
            end
        elseif loaded_data[key] and type(default_item) ~= "table" then
            -- 对于非表类型的顶级字段，也可以根据需要处理
            default_item = loaded_data[key]
        end
    end

    return default_data
end

function dst_gi_nahida_weapon_staff_data:DoSewing(item)
    if self.inst.components.finiteuses then
        local item_count = item.components.stackable and item.components.stackable:StackSize() or 1
        local total = self.inst.components.finiteuses.total
        local current = self.inst.components.finiteuses.current
        -- 如果已经满耐久，不需要修复
        if current >= total then
            return false
        end
        -- 计算需要修复的耐久度
        local repair_needed = total - current
        -- 计算需要多少个item（每个item修复1点，向上取整）
        local items_needed = math.ceil(repair_needed / 5)
        -- 检查是否有足够的item
        if item_count < items_needed then
            -- 不够修复到满耐久，但可以部分修复
            local actual_repair = item_count * 5
            local new_current = math.min(total, current + actual_repair)
            -- 执行修复
            self.inst.components.finiteuses:SetUses(new_current)
            -- 消耗所有item
            if item.components.stackable then
                item.components.stackable:Get(item_count):Remove()
            else
                item:Remove()
            end
            return true
        else
            -- 有足够的item完全修复
            local new_current = total  -- 修复到满耐久
            -- 执行修复
            self.inst.components.finiteuses:SetUses(new_current)
            -- 消耗需要的item数量
            if item.components.stackable then
                item.components.stackable:Get(items_needed):Remove()
            else
                item:Remove()
            end
            return true
        end
    end
    return false
end

function dst_gi_nahida_weapon_staff_data:UpdateData(item)
    if item == nil or self.active_data[item.prefab] == nil then
        return false
    end
    if item and self.active_data[item.prefab] then
        if self.active_data[item.prefab].count == nil and self.active_data[item.prefab].active then
            return false
        end
        -- 月仗
        if item.prefab == "opalstaff" and self.active_data.yellowstaff and (self.active_data.yellowstaff.active == false or self.active_data.yellowstaff.active == nil) then
            return false
        end
        self.active_data[item.prefab].active = true
        local item_count = 1
        if self.active_data[item.prefab].count then
            item_count = item.components.stackable and item.components.stackable:StackSize() or 1
            if self.active_data[item.prefab].count >= self.active_data[item.prefab].max_count and item.prefab == "walrus_tusk" then
                return false
            end
            if self.active_data[item.prefab].count >= self.active_data[item.prefab].max_count and item.prefab == "goldnugget" then
                return false
            end
            -- 彩虹宝石
            if self.active_data[item.prefab].count >= self.active_data[item.prefab].max_count and item.prefab == "opalpreciousgem" then
                return false
            end
            -- 月仗
            if self.active_data[item.prefab].count >= self.active_data[item.prefab].max_count and item.prefab == "opalstaff" then
                if self.active_data.yellowstaff.active == false then
                    return false
                end
                return false
            end

            if item.prefab == "walrus_tusk" then
                local num = self.active_data[item.prefab].max_count - self.active_data[item.prefab].count
                if item_count >= num then
                    item_count = num
                end
            end
            if item.prefab == "opalstaff" then
                local num = self.active_data[item.prefab].max_count - self.active_data[item.prefab].count
                if item_count >= num then
                    item_count = num
                end
            end
            if item.prefab == "goldnugget" then
                local num = self.active_data[item.prefab].max_count - self.active_data[item.prefab].count
                if item_count >= num then
                    item_count = num
                end
            end
            if item.prefab == "opalpreciousgem" then
                if self.active_data.yellowstaff.active == nil or self.active_data.yellowstaff.active == false then
                    return false
                end
                local num = self.active_data[item.prefab].max_count - self.active_data[item.prefab].count
                if item_count >= num then
                    item_count = num
                end
            end
            self.active_data[item.prefab].count = self.active_data[item.prefab].count + item_count
        end
        if item.components.stackable then
            item.components.stackable:Get(item_count):Remove()
        else
            item:Remove()
        end
        self:InIt()
        return true
    end
    return false
end

function dst_gi_nahida_weapon_staff_data:CanAcceptItem(item)
    if item == nil or self.active_data[item.prefab] == nil then
        return false
    end
    return self.active_data[item.prefab] ~= nil or false
end

function dst_gi_nahida_weapon_staff_data:InIt()
    if self.current_model and self.current_model == "NORMAL" then
        if self.inst.components.tool then
            local efficiency = self.active_data.goldnugget.count * 0.01
            self.inst.components.tool:SetAction(ACTIONS.CHOP, 1 + efficiency)
            self.inst.components.tool:SetAction(ACTIONS.MINE, 1 + efficiency)
            self.inst.components.tool.actions[ACTIONS.HAMMER] = nil
            self.inst.components.tool.inst:RemoveTag(ACTIONS.HAMMER.id .. "_tool")
            self.inst.components.tool.actions[ACTIONS.DIG] = nil
            self.inst.components.tool.inst:RemoveTag(ACTIONS.DIG.id .. "_tool")
            self.inst:RemoveTag("dst_gi_nahida_weapons_till_destroy")
        end
    elseif self.current_model and (self.current_model == "DESTROY" or self.current_model == "TRANSMITTED") then
        if self.inst.components.tool then
            local efficiency = self.active_data.goldnugget.count * 0.01
            self.inst.components.tool:SetAction(ACTIONS.HAMMER, 1 + efficiency)
            self.inst.components.tool:SetAction(ACTIONS.DIG, 1 + efficiency)
            self.inst:AddTag("dst_gi_nahida_weapons_till_destroy")
        end
    end
    if self.active_data.walrus_tusk.active then
        if self.inst.components.equippable then
            self.inst.components.equippable.walkspeedmult = 1 + self.active_data.walrus_tusk.count * 0.2
        end
    end
    if self.active_data.multitool_axe_pickaxe.active then
        if self.inst.components.tool then
            self.inst.components.tool:EnableToughWork(true)
        end
    end
    local opalpreciousgem_count = 0
    if self.active_data.opalpreciousgem.active and self.inst.components.dst_gi_nahida_weapon_bounce_data then
        local gem_count = self.active_data.opalpreciousgem.count or 0
        opalpreciousgem_count = gem_count
        local calculated_level = 1 + math.floor(gem_count / 10)
        self.inst.components.dst_gi_nahida_weapon_bounce_data:SetLevel(calculated_level)
        OnOpalpreciousgemCount(self, gem_count)
    end
    if self.active_data.orangestaff.active then
        if self.current_model == "TRANSMITTED" then
            -- 添加瞄准圈组件
            self.inst:AddComponent("reticule")
            self.inst.components.reticule.targetfn = blinkstaff_reticuletargetfn  -- 目标选择函数
            self.inst.components.reticule.ease = true  -- 平滑移动
            -- 添加闪烁传送组件
            self.inst:AddComponent("blinkstaff")
            self.inst.components.blinkstaff:SetFX("sand_puff_large_front", "sand_puff_large_back")  -- 设置特效
            self.inst.components.blinkstaff.onblinkfn = onblink  -- 传送回调函数
            -- 重新传送方法
            local oldBlink = self.inst.components.blinkstaff.Blink
            self.inst.components.blinkstaff.Blink = function(...)
                if self.inst.components.finiteuses then
                    local current = self.inst.components.finiteuses.current
                    if current == 0 then
                        return false
                    end
                end
                return oldBlink(...)
            end
        else
            if self.inst.components.reticule then
                self.inst:RemoveComponent("reticule")
            end
            if self.inst.components.blinkstaff then
                self.inst:RemoveComponent("blinkstaff")
            end
        end
    end
    if self.active_data.yellowstaff.active then
        if self.inst.components.container then
            if self.inst.components.weapon then
                local range = 2
                if opalpreciousgem_count > 0 then
                    range = range + 2
                end
                if self.active_data.opalstaff.count > 0 then
                    range = range + self.active_data.opalstaff.count * 2
                end
                self.inst.components.weapon:SetRange(range)
                if self.inst.components.container:IsEmpty() then
                    self.inst.components.weapon:SetProjectile("dst_gi_nahida_brilliance_projectile_fx_grass")
                else
                    local item =  self.inst.components.container.slots[1]
                    if item and  item.element_type then
                        local projectile_name = "dst_gi_nahida_brilliance_projectile_fx_" .. item.element_type
                        self.inst.components.weapon:SetProjectile(projectile_name)
                    else
                        self.inst.components.weapon:SetProjectile("dst_gi_nahida_brilliance_projectile_fx_grass")
                    end
                end
            end
        end
    else
        if self.inst.components.weapon then
            self.inst.components.weapon:SetRange(1)
            self.inst.components.weapon:SetProjectile(nil)
        end
    end
end

function dst_gi_nahida_weapon_staff_data:EquipFn(owner)
    self.owner = owner
    self:InIt()
end

function dst_gi_nahida_weapon_staff_data:UnEquipFn(owner)
    self.owner = nil
    self:InIt()
end

function dst_gi_nahida_weapon_staff_data:TrMode()
    -- 获取当前模式在表中的索引
    local current_index = nil
    for index, mode in pairs(self.WEAPON_STAFF_MODE) do
        if mode == self.current_model then
            current_index = index
            break
        end
    end
    -- 如果找到当前索引，切换到下一个模式
    if current_index then
        -- 计算下一个索引（循环切换）
        local next_index = current_index + 1
        if next_index > #self.WEAPON_STAFF_MODE then
            next_index = 1  -- 回到第一个模式
        end
        -- 切换模式
        self.current_model = self.WEAPON_STAFF_MODE[next_index]
    end
    self.inst.net_dst_gi_nahida_weapon_staff_current_model:set(self.current_model)
    self:InIt()
    return true
end

function dst_gi_nahida_weapon_staff_data:OnSave()
    -- 保存当前的 current_model 状态
    return {
        current_model = self.current_model,
        active_data = self.active_data,
    }
end

function dst_gi_nahida_weapon_staff_data:OnLoad(data)
    -- 验证模式数据
    if data and data.current_model and type(data.current_model) == "string" then
        -- 验证模式是否在有效列表中
        local valid_mode = false
        for _, mode in pairs(self.WEAPON_STAFF_MODE) do
            if mode == data.current_model then
                valid_mode = true
                break
            end
        end
        if valid_mode then
            self.current_model = data.current_model
        else
            self.current_model = self.WEAPON_STAFF_MODE[1] -- 默认第一个模式
        end
    else
        self.current_model = self.WEAPON_STAFF_MODE[1]
    end

    -- 安全合并active_data
    local loaded_active_data = data and data.active_data or nil
    local success, merged_data = pcall(function()
        return self:MergeActiveData(loaded_active_data)
    end)

    if success then
        self.active_data = merged_data
    else
        print("Active data merge failed, using defaults")
        self.active_data = self:GetDefaultActiveData()
    end

    -- 安全初始化
    local init_success, init_err = pcall(function()
        self:InIt()
    end)

    if not init_success then
        print("Staff init failed:", init_err)
    end
end

function dst_gi_nahida_weapon_staff_data:getData()
    -- 保存当前的 current_model 状态
    return {
        current_model = self.current_model,
        active_data = self.active_data,
    }
end

function dst_gi_nahida_weapon_staff_data:SaveData(data)
    if data and data.current_model then
        self.current_model = data.current_model
    end
    -- 🔥 使用安全合并
    local loaded_active_data = data and data.active_data or nil
    self.active_data = self:MergeActiveData(loaded_active_data)
    self:InIt()
end

return dst_gi_nahida_weapon_staff_data