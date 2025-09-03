---
--- medal_hooks.lua
--- Description: 勋章hooks
--- Author: 没有小钱钱
--- Date: 2025/6/9 2:39
---

local addStackableComponentList = {
    "blank_certificate"
}

--if TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.FUNCTIONAL_MEDAL then
--    for _, v in ipairs(addStackableComponentList) do
--        AddPrefabPostInit(v,function(inst)
--            if inst.components.stackable == nil then
--                -- 添加堆叠组件
--                inst:AddComponent("stackable")
--                inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM -- 设置堆叠大小
--            end
--        end)
--    end
--end

local oversizedList = {
    "immortal_fruit_oversized",
    "medal_gift_fruit_oversized",
}
if TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD.FUNCTIONAL_MEDAL then
    for _, v in ipairs(oversizedList) do
        AddPrefabPostInit(v,function(inst)
            if not inst:HasTag("oversized_veggie") then
                inst:AddTag("oversized_veggie")
            end
            if not inst:HasTag("oversized") then
                inst:AddTag("oversized")
            end
        end)
    end
end