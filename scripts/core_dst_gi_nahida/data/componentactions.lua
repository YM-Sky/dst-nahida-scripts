---@type data_componentaction[]
local data = {
    -- 官方的三个组件的修理, finiteuses armor fueled, 给一堆物品时, 尽可能多的消耗物品来修理, 具体数据只需填进 `TUNING.MOD_DST_GI_NAHIDA.REPAIR_COMMON`, 此处逻辑不用动
    {
        id = 'ACTION_COMMON_REPAIR',
        str = STRINGS.MOD_DST_GI_NAHIDA.ACTIONS.ACTION_COMMON_REPAIR,
        fn = function (act)
            local doer,item,target = act.doer,act.invobject,act.target
            if doer and item and target and doer:IsValid() and item:IsValid() and target:IsValid() then
                local compo = TUNING.MOD_DST_GI_NAHIDA.REPAIR_COMMON[target.prefab].type
                local repair_percent = item.prefab and TUNING.MOD_DST_GI_NAHIDA.REPAIR_COMMON[target.prefab].repair_percent[item.prefab]
                local cur_percent = target.components[compo] and target.components[compo]:GetPercent()
                if repair_percent and cur_percent then
                    if doer and doer.SoundEmitter then
                        local prefab = item.prefab
                        local sound = (prefab == 'nightmarefuel' or prefab == 'horrorfuel') and 'dontstarve/common/nightmareAddFuel' or 'aqol/new_test/metal'
                        doer.SoundEmitter:PlaySound(sound)
                    end

                    local new_percent = math.min(1,cur_percent + repair_percent)
                    target.components[compo]:SetPercent(new_percent)
                    SUGAR_b1inkie:consumeOneItem(item)

                    while item and item:IsValid() and (target.components[compo]:GetPercent() + repair_percent) <= 1 do
                        local _cur_percent = target.components[compo]:GetPercent()
                        local _new_percent = math.min(1,_cur_percent + repair_percent)
                        target.components[compo]:SetPercent(_new_percent)
                        SUGAR_b1inkie:consumeOneItem(item)
                    end

                    if target:HasTag(target.prefab..'_nodurability') then
                        target:RemoveTag(target.prefab..'_nodurability')
                    end
                    return true
                end
            end
            return false
        end,
        state = 'give',
        actiondata = {
            mount_valid = true,
            priority = 5,
        },
        type = "USEITEM",
        component = 'inventoryitem',
        testfn_type_USEITEM = function (inst, doer, target, actions, right)
            if right and doer:HasTag("player") and target.prefab and TUNING.MOD_DST_GI_NAHIDA.REPAIR_COMMON[target.prefab] then
                local canrepair = inst and inst.prefab and TUNING.MOD_DST_GI_NAHIDA.REPAIR_COMMON[target.prefab].repair_percent[inst.prefab]
                if canrepair then
                    return true
                end
            end
            return false
        end
    }
}

---@type data_componentaction_change[]
local change = {

}

return data,change