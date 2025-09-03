---
--- dst_gi_nahida_foods.lua
--- Description: 纳西妲的食物
--- Author: 没有小钱钱
--- Date: 2025/5/2 12:02
---

-- 通用食物生成函数
local function CreateFoodPrefab(name, anim_bank, anim_build, atlas, image, foodtype, healthvalue, hungervalue, sanityvalue, perish_time, stack_size)
    -- 定义食物实体的生成函数
    local function foodFn()
        local inst = CreateEntity()

        -- 添加基本组件
        inst.entity:AddTransform() -- 位置和旋转
        inst.entity:AddAnimState() -- 动画
        inst.entity:AddNetwork() -- 网络同步

        -- 设置物理属性和漂浮效果
        MakeInventoryPhysics(inst)
        MakeInventoryFloatable(inst, "med", nil, 0.75)

        -- 设置动画资源
        inst.AnimState:SetBank(anim_bank) -- 动画银行
        inst.AnimState:SetBuild(anim_build) -- 动画构建
        inst.AnimState:PlayAnimation("idle") -- 播放初始动画
        inst.Transform:SetScale(0.8, 0.8, 0.8) -- 缩放
        -- 添加标签
        inst:AddTag("shoreonsink") -- 不掉深渊
        inst:AddTag("tornado_nosucky") -- 不会被龙卷风刮走
        inst:AddTag("hide_percentage") -- 隐藏百分比
        inst:AddTag("nosteal") -- 防偷取
        inst:AddTag("spicedfood")

        -- 设置实体为原始状态
        inst.entity:SetPristine()

        -- 如果不是主服务器，返回实体
        if not TheWorld.ismastersim then
            return inst
        end

        -- 添加可检查组件
        inst:AddComponent("inspectable")

        -- 添加物品栏组件
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = atlas -- 设置物品栏图标

        -- 添加堆叠组件
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = stack_size -- 设置堆叠大小

        -- 添加可食用组件
        inst:AddComponent("edible")
        inst.components.edible.healthvalue = healthvalue -- 恢复的生命值
        inst.components.edible.hungervalue = hungervalue -- 恢复的饥饿值
        inst.components.edible.sanityvalue = sanityvalue -- 恢复的理智值
        inst.components.edible.foodtype = foodtype -- 食物类型

        -- 添加可腐烂组件
        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(perish_time) -- 设置腐烂时间
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food" -- 腐烂后变成腐烂食物

        -- 设置可被鬼魂影响
        MakeHauntableLaunchAndDropFirstItem(inst)

        return inst
    end

    local assets = {
        Asset("ANIM", "anim/"..anim_build..".zip"), -- 动画资源
        Asset("ATLAS", atlas), -- 物品栏贴图
        Asset("IMAGE", image), -- 物品栏图像
    }
    -- 返回预制体
    return Prefab(name, foodFn, assets)
end

local foods = {
    CreateFoodPrefab(
            "dst_gi_nahida_coconut_meat",
            "dst_gi_nahida_coconut_meat",
            "dst_gi_nahida_coconut",
            "images/inventoryimages/dst_gi_nahida_coconut_meat.xml",
            "images/inventoryimages/dst_gi_nahida_coconut_meat.tex",
            FOODTYPE.VEGGIE,
            1, -- 恢复的生命值
            8, -- 恢复的饥饿值
            0, -- 恢复的理智值
            TUNING.PERISH_SLOW, -- 腐烂时间 15天
            TUNING.STACK_SIZE_TINYITEM -- 堆叠大小 60
    )
}
-- 返回椰子和椰子肉的预制体
return unpack(foods)