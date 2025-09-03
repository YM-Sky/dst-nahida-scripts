---
--- SGDstGiNahidaGachaMachine.lua
--- Description: 抽卡机SG
--- Author: 没有小钱钱
--- Date: 2025/5/5 18:58
---

require("stategraphs/commonstates")

local events= {}

local function return_to_idle(inst)
    inst.sg:GoToState("idle")
end

local states=
{
    State{
        name = "dst_gi_nahida_gacha_machine_idle", -- 状态2
        tags = {"idle", "canrotate","nopredict"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("idle", true)
        end,
    },

    State{
        name = "dst_gi_nahida_gacha_machine_use", -- 状态1
        tags = {"busy","nopredict"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("use")
        end,
        events =
        {
            EventHandler("animover", return_to_idle),
        },
    },
}

return StateGraph("dst_gi_nahida_gacha_machine", states, events, "idle")
