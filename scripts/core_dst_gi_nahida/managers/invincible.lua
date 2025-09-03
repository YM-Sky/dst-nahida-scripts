-- 功能(无需修改): 设置无敌的
-- 方法都在health组件中
-- 设置无敌,但回血可以回,只是不能扣血,同时该无敌不能被无视掉

AddComponentPostInit('health',
---comment
---@param self component_health
function (self)

    self._dst_lan_invincible_num = 0

    ---添加无敌
    function self:PushInvincible()
        self._dst_lan_invincible_num = self._dst_lan_invincible_num + 1
    end

    ---移除无敌
    function self:PopInvincible()
        self._dst_lan_invincible_num = math.max(0,self._dst_lan_invincible_num - 1)
    end

    ---是否无敌
    ---@return boolean
    ---@nodiscard
    function self:CheckIsInvincible()
        return self._dst_lan_invincible_num > 0
    end

end)