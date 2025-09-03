---
--- builder_hooks.lua
--- Description: 建造hook
--- Author: 没有小钱钱
--- Date: 2025/6/7 18:03
---
-- 勾客户端配方
-- 客户端显示内容
local builder_replica = require "components/builder_replica"

-- 保存原始的 IngredientMod 方法
local BuilderReplicaOldHasIngredients = builder_replica.HasIngredients

-- 保存原始的 IngredientMod 方法
local OldIngredientMod = builder_replica.IngredientMod
function builder_replica:IngredientMod()
    -- 尝试从UI结构获取当前配方信息
    local screen = TheFrontEnd:GetActiveScreen()
    if screen and screen.controls and screen.controls.craftingmenu then
        local craftingmenu = screen.controls.craftingmenu
        if craftingmenu.craftingmenu and craftingmenu.craftingmenu.details_root then
            local details_root = craftingmenu.craftingmenu.details_root
            -- 检查data.recipe中的配方信息
            if details_root.data and details_root.data.recipe and details_root.data.recipe.name then
                local recipe_name = details_root.data.recipe.name
                -- 检查是否有自定义ingredientmod
                if TUNING.NAHIDA_RECIPE_INGREDIENTMOD[recipe_name] then
                    return TUNING.NAHIDA_RECIPE_INGREDIENTMOD[recipe_name].ingredientmod
                end
            end
        end
    end
    -- 否则返回原始值
    return OldIngredientMod(self)
end

-- 重写 HasIngredients 方法
function builder_replica:HasIngredients(recipe)
    if self.inst.components.builder ~= nil then
        return self.inst.components.builder:HasIngredients(recipe)
    elseif self.classified ~= nil then
        if type(recipe) == "string" then
            recipe = GetValidRecipe(recipe)
        end
        if recipe ~= nil then
            if self.classified.isfreebuildmode:value() then
                return true
            end
            local ingredientmod = TUNING.NAHIDA_RECIPE_INGREDIENTMOD[recipe.name] and TUNING.NAHIDA_RECIPE_INGREDIENTMOD[recipe.name].ingredientmod or nil
            if ingredientmod then
                for i, v in ipairs(recipe.ingredients) do
                    if not self.inst.replica.inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount * ingredientmod)), true) then
                        return false
                    end
                end
                for i, v in ipairs(recipe.character_ingredients) do
                    if not self:HasCharacterIngredient(v) then
                        return false
                    end
                end
                for i, v in ipairs(recipe.tech_ingredients) do
                    if not self:HasTechIngredient(v) then
                        return false
                    end
                end
                return true
            else
                return BuilderReplicaOldHasIngredients(self,recipe)
            end
        end
    end
    return false
end


AddComponentPostInit("builder", function(builder)
    -- 保存原始的 GetIngredients 方法
    local OldGetIngredients = builder.GetIngredients
    -- 保存原始的 HasIngredients 方法
    local OldHasIngredients = builder.HasIngredients

    -- 重写 GetIngredients 方法
    function builder:GetIngredients(recname)
        local recipe = AllRecipes[recname]
        if recipe then
            local ingredients = {}
            local discounted = false
            local ingredientmod = TUNING.NAHIDA_RECIPE_INGREDIENTMOD[recname] and TUNING.NAHIDA_RECIPE_INGREDIENTMOD[recname].ingredientmod or nil
            if ingredientmod then
                -- 对于指定的配方，忽略 ingredientmod，直接使用原始数量
                for k, v in pairs(recipe.ingredients) do
                    if v.amount > 0 then
                        local amt = math.max(1, RoundBiasedUp(v.amount * ingredientmod))
                        local items = self.inst.components.inventory:GetCraftingIngredient(v.type, amt)
                        ingredients[v.type] = items
                    end
                end
            else
                -- 对于其他配方，调用原始方法
                return OldGetIngredients(self, recname)
            end
            return ingredients, discounted
        end
    end

    -- 重写 HasIngredients 方法
    function builder:HasIngredients(recipe)
        if type(recipe) == "string" then
            recipe = GetValidRecipe(recipe)
        end
        if recipe ~= nil then
            local ingredientmod = TUNING.NAHIDA_RECIPE_INGREDIENTMOD[recipe.name] and TUNING.NAHIDA_RECIPE_INGREDIENTMOD[recipe.name].ingredientmod or nil
            if ingredientmod then
                -- 使用自定义的 ingredientmod 进行材料检查
                for i, v in ipairs(recipe.ingredients) do
                    if not self.inst.components.inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount * ingredientmod)), true) then
                        return false
                    end
                end
                for i, v in ipairs(recipe.character_ingredients) do
                    if not self:HasCharacterIngredient(v) then
                        return false
                    end
                end
                for i, v in ipairs(recipe.tech_ingredients) do
                    if not self:HasTechIngredient(v) then
                        return false
                    end
                end
                return true
            else
                -- 对于其他配方，调用原始方法
                return OldHasIngredients(self, recipe)
            end
        end
        return false
    end
end)


