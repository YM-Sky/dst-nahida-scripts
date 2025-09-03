local dst_gi_nahida_sunkenchest_item_data = Class(function(self, inst)
    self.inst = inst
    self.slots = {}  -- 存储物品数据：{slot_idx = {prefab="xxx", stacksize=1}}
end)

-- 保存沉底宝箱物品数据（仅存储prefab和数量）
function dst_gi_nahida_sunkenchest_item_data:SaveSunkenChest(sunkenchest)
    if sunkenchest and sunkenchest.components.container then
        self.slots = {}
        for slot_idx = 1, sunkenchest.components.container.numslots do
            local item = sunkenchest.components.container:GetItemInSlot(slot_idx)
            if item then
                self.slots[slot_idx] = {
                    prefab = item.prefab,
                    stacksize = item.components.stackable and item.components.stackable:StackSize() or 1
                }
            end
        end
    end
end

-- 加载数据到新宝箱
function dst_gi_nahida_sunkenchest_item_data:SunkenChestLoadItems(sunkenchest)
    if sunkenchest and sunkenchest.components.container then
        sunkenchest.components.container:RemoveAllItems()
        for slot_idx, item_data in pairs(self.slots) do
            if item_data then
                local item = SpawnPrefab(item_data.prefab)
                if item then
                    if item_data.stacksize > 1 and item.components.stackable then
                        item.components.stackable:SetStackSize(item_data.stacksize)
                    end
                    sunkenchest.components.container:GiveItem(item, slot_idx)
                end
            end
        end
    end
end

-- 持久化保存数据
function dst_gi_nahida_sunkenchest_item_data:OnSave()
    return {slots = self.slots}, nil  -- 第二个返回值是references，这里不需要
end

-- 从存档加载数据
function dst_gi_nahida_sunkenchest_item_data:OnLoad(data)
    if data and data.slots then
        self.slots = data.slots
    end
end

return dst_gi_nahida_sunkenchest_item_data
