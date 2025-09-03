---
--- dst_gi_nahida_books.lua
--- Description: 纳西妲的书
--- Author: 没有小钱钱
--- Date: 2025/4/13 14:34
---
local assets =
{
    Asset("ANIM", "anim/dst_gi_nahida_books.zip"),  --地上的动画
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_book_fullmoon.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_book_fullmoon.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_book_newmoon.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_book_newmoon.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_book_fish.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_book_fish.tex"),
    Asset("ATLAS", "images/inventoryimages/dst_gi_nahida_spellbook.xml"), --加载物品栏贴图
    Asset("IMAGE", "images/inventoryimages/dst_gi_nahida_spellbook.tex"),
}
local function MakeMoonBook(name,atlasname, moonphase)
    return {
        name = name,
        uses = TUNING.BOOK_USES_SMALL,
        read_sanity = -TUNING.SANITY_HUGE,
        peruse_sanity = -TUNING.SANITY_LARGE,
        atlasname = "images/inventoryimages/"..atlasname..".xml",
        fx = "fx_book_moon",
        fxmount = "fx_book_moon_mount",
        fn = function(inst, reader)
            if TheWorld:HasTag("cave") then
                reader.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_READER_MOON_BOOK_CAVE)
                return false, "NOMOONINCAVES"
            elseif TheWorld.state.moonphase == moonphase then
                reader.components.talker:Say(STRINGS.MOD_DST_GI_NAHIDA.NAHIDA_READER_MOON_BOOK_CAVE)
                return false, "ALREADY"..string.upper(moonphase).."MOON"
            end
            local iswaxing = true
            if moonphase == "full" then
                iswaxing = nil
            end
            TheWorld:PushEvent("ms_setmoonphase", {moonphase = moonphase,iswaxing = iswaxing})
            if not TheWorld.state.isnight then
                reader.components.talker:Say(GetString(reader, "ANNOUNCE_BOOK_MOON_DAYTIME"))
            end

            return true
        end,
        perusefn = function(inst, reader)
            return true
        end,
    }
end

local function MakeFishBook(name,atlasname)
    return {
        name = name,
        uses = TUNING.BOOK_USES_SMALL,
        read_sanity = -TUNING.SANITY_LARGE,
        peruse_sanity = TUNING.SANITY_HUGE,
        atlasname = "images/inventoryimages/"..atlasname..".xml",
        fx = "fx_book_fish",
        fx_under = "fish",
        fn = function(inst, reader)
            local schoolspawner = TheWorld.components.schoolspawner
            if schoolspawner == nil then
                return false, "NOWATERNEARBY"
            end

            local FISH_SPAWN_OFFSET = 10
            local x, y, z = reader.Transform:GetWorldPosition()
            local delta_theta = PI2 / 18
            local failed_spawn = 0

            -- 召唤2个随机鱼群
            for i = 1, 2 do
                local theta = math.random() * TWOPI
                local failed_attempts = 0
                local max_failed_attempts = 36

                while failed_attempts < max_failed_attempts do
                    local spawn_offset = Vector3(math.random(1, 3), 0, math.random(1, 3))
                    local spawn_point = Vector3(x + math.cos(theta) * FISH_SPAWN_OFFSET, 0, z + math.sin(theta) * FISH_SPAWN_OFFSET)

                    -- 检查生成点是否在水域中
                    if TheWorld.Map:IsOceanAtPoint(spawn_point:Get()) then
                        local num_fish_spawned = schoolspawner:SpawnSchool(spawn_point, nil, spawn_offset)

                        if num_fish_spawned == nil or num_fish_spawned == 0 then
                            theta = theta + delta_theta
                            failed_attempts = failed_attempts + 1

                            if failed_attempts >= max_failed_attempts then
                                failed_spawn = failed_spawn + 1
                            end
                        else -- Success
                            break
                        end
                    else
                        theta = theta + delta_theta
                        failed_attempts = failed_attempts + 1
                    end
                end
            end

            -- 额外召唤2个当前季节的鱼群
            local season_fish_prefab
            local current_season = TheWorld.state.season
            if current_season == "summer" then
                season_fish_prefab = "oceanfish_small_8" -- 替换为炽热太阳鱼的 prefab 名称
            elseif current_season == "spring" then
                season_fish_prefab = "oceanfish_small_7" -- 替换为花朵金枪鱼的 prefab 名称
            elseif current_season == "autumn" then
                season_fish_prefab = "oceanfish_small_6" -- 替换为落叶比目鱼的 prefab 名称
            elseif current_season == "winter" then
                season_fish_prefab = "oceanfish_medium_8" -- 替换为冰鲷鱼的 prefab 名称
            end

            if season_fish_prefab then
                for i = 1, 2 do
                    local theta = math.random() * TWOPI
                    local failed_attempts = 0
                    local max_failed_attempts = 36
                    local season_fish_spawned = false

                    while not season_fish_spawned and failed_attempts < max_failed_attempts do
                        local spawn_offset = Vector3(math.random(1, 3), 0, math.random(1, 3))
                        local spawn_point = Vector3(x + math.cos(theta) * FISH_SPAWN_OFFSET, 0, z + math.sin(theta) * FISH_SPAWN_OFFSET)

                        -- 检查生成点是否在水域中
                        if TheWorld.Map:IsOceanAtPoint(spawn_point:Get()) then
                            if i == 2 then
                                -- 固定刷新1条季节鱼，1条斑鱼，20%概率斑鱼替换季节鱼
                                local old_season_fish_prefab = season_fish_prefab
                                season_fish_prefab = "oceanfish_medium_2" -- 斑鱼
                                local chance = math.random()
                                if chance <= 0.2 then
                                    season_fish_prefab = old_season_fish_prefab
                                end
                            end
                            local fish = SpawnPrefab(season_fish_prefab)

                            if fish then
                                fish.Transform:SetPosition(spawn_point:Get())
                                season_fish_spawned = true
                            else
                                theta = theta + delta_theta
                                failed_attempts = failed_attempts + 1
                            end
                        else
                            theta = theta + delta_theta
                            failed_attempts = failed_attempts + 1
                        end
                    end

                    if not season_fish_spawned then
                        return false, "NOWATERNEARBY"
                    end
                end
            end

            if failed_spawn >= 2 then
                return false, "NOWATERNEARBY"
            end

            return true
        end,
        perusefn = function(inst, reader)
            return true
        end,
    }
end

local book_defs = {
    MakeMoonBook("dst_gi_nahida_book_fullmoon", "dst_gi_nahida_book_fullmoon","full"),
    MakeMoonBook("dst_gi_nahida_book_newmoon", "dst_gi_nahida_book_newmoon","new"),
    MakeFishBook("dst_gi_nahida_book_fish", "dst_gi_nahida_book_fish"),
}

local function MakeBook(def)
    local prefabs
    if def.deps ~= nil then
        prefabs = {}
        for i, v in ipairs(def.deps) do
            table.insert(prefabs, v)
        end
    end
    if def.fx ~= nil then
        prefabs = prefabs or {}
        table.insert(prefabs, def.fx)
    end
    if def.fxmount ~= nil then
        prefabs = prefabs or {}
        table.insert(prefabs, def.fxmount)
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("dst_gi_nahida_books")
        inst.AnimState:SetBuild("dst_gi_nahida_books")
        inst.AnimState:PlayAnimation(def.name)
        inst.scrapbook_anim = "book_moon"

        MakeInventoryFloatable(inst, "med", nil, 0.75)

        inst:AddTag("book")
        inst:AddTag("bookcabinet_item")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -----------------------------------

        inst.def = def
        --inst.swap_build = "swap_books"
        --inst.swap_prefix = def.name

        inst:AddComponent("inspectable")
        inst:AddComponent("book")
        inst.components.book:SetOnRead(def.fn)
        inst.components.book:SetOnPeruse(def.perusefn)
        inst.components.book:SetReadSanity(def.read_sanity)
        inst.components.book:SetPeruseSanity(def.peruse_sanity)
        --inst.components.book:SetFx(def.fx, def.fxmount)

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = def.atlasname --物品贴图

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(def.uses)
        inst.components.finiteuses:SetUses(def.uses)
        inst.components.finiteuses:SetOnFinished(inst.Remove)

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL

        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(def.name, fn, assets, prefabs)
end

local ret = {}
for i, v in ipairs(book_defs) do
    table.insert(ret, MakeBook(v))
end

local function MakeSpellBookfn()
    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        MakeInventoryPhysics(inst)
        inst.AnimState:SetBank("dst_gi_nahida_books")
        inst.AnimState:SetBuild("dst_gi_nahida_books")
        inst.AnimState:PlayAnimation("dst_gi_nahida_spellbook")
        inst.scrapbook_anim = "book_moon"

        MakeInventoryFloatable(inst, "med", nil, 0.75)

        inst:AddTag("book")
        inst:AddTag("bookcabinet_item")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("aoespell")
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/dst_gi_nahida_spellbook.xml"
        inst.components.inventoryitem.imagename = "dst_gi_nahida_spellbook"

        return inst
    end
    return Prefab("dst_gi_nahida_spellbook", fn)
end

table.insert(ret, MakeSpellBookfn())

return unpack(ret)