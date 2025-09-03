---
--- SGDstGiNahidaDendroCore.lua
--- Description: 草原核SG
--- Author: 没有小钱钱
--- Date: 2025/5/5 18:58
---

require("stategraphs/commonstates")

local events=
{
    EventHandler("pop", function(inst) -- for instantaneous pops
        inst.sg:GoToState("pop")
    end),
    EventHandler("preparedpop", function(inst) -- for a delayed pop
        inst.sg:GoToState("pre_pop")
    end),
}

local function return_to_idle(inst)
    inst.sg:GoToState("idle")
end

local states=
{
    State{
        name = "pre_pop",
        tags = {"busy","nopredict"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("rumble", true)
            inst.sg:SetTimeout(2)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("pop")
        end,
    },

    State{
        name = "pop",
        tags = {"busy","nopredict"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("explode")
        end,

        timeline =
        {
            TimeEvent(4*FRAMES, function(inst)
                inst.Light:Enable(false)
                inst.DynamicShadow:Enable(false)
                inst:PushEvent("popped")
            end),
        },
        events =
        {
            EventHandler("animover", function(inst)
                if inst.light ~= nil then
                    inst.light:Remove()
                    inst.light = nil
                end
                inst:Remove()
            end),
        },
    },

    State{
        name = "idle", -- 状态2
        tags = {"idle", "canrotate","nopredict"},

        onenter = function(inst)
            if not inst.AnimState:IsCurrentAnimation("idle_flight_loop") then
                inst.AnimState:PlayAnimation("idle_flight_loop", true)
            end
            inst.sg:SetTimeout(3)
            if inst.light ~= nil then
                inst.light:Remove()
                inst.light = nil
            end
            inst.light = SpawnPrefab("dst_gi_nahida_dendro_core_light")
            inst.light.entity:SetParent(inst.entity)
        end,
        ontimeout = function(inst)
            inst.sg:GoToState("pre_pop")
        end,
        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("pre_pop")
            end),
        },
    },

    State{
        name = "takeoff", -- 状态1
        tags = {"busy","nopredict"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("cough_out")
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst)
                inst.Light:Enable(true)
                inst.DynamicShadow:Enable(true)
                inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_spore_land")
            end),
        },

        events =
        {
            EventHandler("animover", return_to_idle),
        },
    },
}

return StateGraph("dst_gi_nahida_dendro_core", states, events, "takeoff")
