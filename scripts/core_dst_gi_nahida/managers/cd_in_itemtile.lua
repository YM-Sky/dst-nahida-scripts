-- 功能(无需修改): 在物品栏以数字形式显示的cd
-- 给需要添加cd的物品 添加组件: `dst_gi_nahida_cd_in_itemtile`, 并调用 `Init` 方法进行设置, 调用 `ShowItemTile` 方法决定是否需要将cd显示在物品栏中

AddReplicableComponent('dst_gi_nahida_cd_in_itemtile')

local Text = require 'widgets/text'
AddClassPostConstruct("widgets/itemtile",
function(self, invitem)
    function self:Setdst_gi_nahidaItemtileCD(val)

        local prefab = self.item.prefab .. 'dst_gi_nahida'
        if not self[prefab] then
            self[prefab] = self:AddChild(Text(NUMBERFONT, 42))
            if JapaneseOnPS4() then
                self[prefab]:SetHorizontalSqueeze(0.7)
            end
            self[prefab]:SetPosition(5, -32 + 15, 0)
        end
        local val_to_show = val ~= 0 and val or ' '
        self[prefab]:SetString(tostring(val_to_show))
        if not self.dragging and self.item:HasTag("show_broken_ui") then
            if self[prefab] > 0 then
                self.bg:Hide()
                -- self.spoilage:Hide()
            else
                self.bg:Show()
                -- self:SetPerishPercent(0)
            end
        end
    end

    if self.item.replica.dst_gi_nahida_cd_in_itemtile and self.item.replica.dst_gi_nahida_cd_in_itemtile:ShouldShown() then
        self:Setdst_gi_nahidaItemtileCD(self.item.replica.dst_gi_nahida_cd_in_itemtile:GetCurCD())
    end

    self.inst:ListenForEvent("dst_gi_nahida_cd_in_itemtile_cur_cd_change",function()
        if self.item.replica.dst_gi_nahida_cd_in_itemtile and self.item.replica.dst_gi_nahida_cd_in_itemtile:ShouldShown() then
            self:Setdst_gi_nahidaItemtileCD(self.item.replica.dst_gi_nahida_cd_in_itemtile:GetCurCD())
        end
    end, invitem)
end)