---
--- cooking_hooks.lua
--- Description: 
--- Author: 没有小钱钱
--- Date: 2025/4/13 3:35
---
AddComponentPostInit("stewer", function(Stewer)
    -- 保存原始的 StartCooking 方法
    local _StartCooking = Stewer.StartCooking
    Stewer.StartCooking = function(self, doer, ...)
        local oldcooktimemult =  self.cooktimemult
        if doer ~= nil and doer:HasTag(TUNING.AVATAR_NAME) and doer.cooktimemult then
            -- 使用减少60%的烹饪时间
            self.cooktimemult = oldcooktimemult * doer.cooktimemult
        end
        local flag = _StartCooking(self,doer,...)
        self.cooktimemult = oldcooktimemult
        return flag
    end

    -- 保存原始的 Harvest 方法
    local _Harvest = Stewer.Harvest
    Stewer.Harvest = function(self, harvester, ...)
        local product = self.product -- 保存当前的 product
        local success = _Harvest(self, harvester, ...) -- 调用原始的 Harvest 方法
        if success and product ~= nil and harvester ~= nil and harvester:HasTag(TUNING.AVATAR_NAME) and harvester.cookDdditionalRandomChance then
            local  cook_additional_num = harvester.cookDdditionalRandomChance()
            if cook_additional_num > 0 then
                -- 暴击食物
                local crit_food = TUNING.NAHIDA_FOODS_CRIT_ITEM[product]
                if crit_food then
                    product = crit_food
                    cook_additional_num = 1
                end
                local loot = SpawnPrefab(product) -- 生成一个新的物品
                if loot ~= nil and harvester.components.inventory ~= nil then
                    -- 检查物品是否可堆叠，并设置数量为 cook_additional_num
                    if loot.components.stackable ~= nil then
                        loot.components.stackable:SetStackSize(cook_additional_num)
                    end
                    harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition()) -- 将物品给予玩家
                end
            end
        end
        return success
    end
end)
