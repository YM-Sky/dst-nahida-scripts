-- 功能(需要填写): 制作物品过程涉及数据传输

---@class data_builder_transfer
---@field prod string # 成品的prefab id
---@field fetch_fn fun(source:ent):table<string,any> # 获取数据, 并返回一张包含该数据的表
---@field apply_fn fun(prod:ent,data:table<string,any>) # 应用数据

local modid = 'dst_gi_nahida'

---@type table<PrefabID,data_builder_transfer>
local map = { -- 键为原材料prefab id, 一般都是不可堆叠物品
    -- my_weapon = {
    --     prod = 'my_lvled_weapon',
    --     fetch_fn = function(source)
    --         local level = 0
    --         if source.level then
    --             num = source.level
    --         end
    --         return {lv = level}
    --     end,
    --     apply_fn = function(prod,data)
    --         local lv = data and data.lv
    --         if lv then
    --             prod.level = lv
    --         end
    --     end
    -- },
}

AddComponentPostInit('builder',
---comment
---@param self component_builder
function (self)
    local old_RemoveIngredients = self.RemoveIngredients
    function self:RemoveIngredients(ingredients,recname,discounted,...)
        local player = self.inst
        for _,ents in pairs(ingredients or {}) do
            for v,_ in pairs(ents) do
                local prefab = v.prefab
                if prefab and map[prefab] and player and map[prefab].fetch_fn then
                    local prod = map[prefab].prod
                    player[modid..'_data_transfer_source'..prefab] = map[prefab].fetch_fn(v)
                    player[modid..'_data_transfer_prod'..prod] = prefab
                end
            end
        end
        return old_RemoveIngredients(self,ingredients,recname,discounted,...)
    end
end)


AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent('builditem',function (_,data)
        ---@type ent|nil
        local prod = data and data.item
        local ingredient_prefab = prod ~= nil and prod.prefab ~= nil and inst[modid..'_data_transfer_prod'..prod.prefab]
        if prod and ingredient_prefab then
            local fn = map[ingredient_prefab] and map[ingredient_prefab].apply_fn
            local fetch_data = inst[modid..'_data_transfer_source'..ingredient_prefab]
            if fn and fetch_data then
                fn(prod,fetch_data)
                inst[modid..'_data_transfer_prod'..prod.prefab] = nil
                inst[modid..'_data_transfer_source'..ingredient_prefab] = nil
            end
        end
    end)

end)