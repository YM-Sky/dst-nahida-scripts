---@diagnostic disable: undefined-global, inject-field

local MakePlayerCharacter = require 'prefabs/player_common'

local avatar_name = 'dst_gi_nahida'
local assets = {
	Asset('SCRIPT', 'scripts/prefabs/player_common.lua'),
	Asset('ANIM', 'anim/'..avatar_name..'.zip'),
	Asset('ANIM', 'anim/'..avatar_name..'_none1.zip'),
	Asset('ANIM', 'anim/ghost_'..avatar_name..'_build.zip'),
}

local prefabs = {}

local start_inv = {
	"dst_gi_nahida_thousand_floating_dreams",
	--"dst_gi_nahida_spellbook",
}
-- for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
-- 	start_inv[string.lower(k)] = v[string.upper(avatar_name)]
-- end
start_inv['default'] = {}
for k,v in pairs(TUNING.DST_GI_NAHIDA_CUSTOM_START_INV) do
	for i = 1, v.num do 
		table.insert(start_inv['default'], k)
	end
end

prefabs = FlattenTree({ prefabs, start_inv }, true)
---------------------------------------------------------------------------
---------------------------------------------------------------------------
local function onbecamehuman(inst, data, isloading)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, avatar_name..'_speed_mod', 1)
end

local function onbecameghost(inst, data)
	inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, avatar_name..'_speed_mod')
end

local function h_cursable(Cursable)
	if not Cursable then return end
	local old1 = Cursable.IsCursable
	Cursable.IsCursable = function(self, item)
		if item and item.components.curseditem and item.components.curseditem.curse  == "MONKEY" then
			return false
		end
		return old1(self, item)
	end
	local old2 = Cursable.ApplyCurse
	Cursable.ApplyCurse = function(self, item)
		if item and item.components.curseditem and item.components.curseditem.curse  == "MONKEY" then
			item:RemoveTag("applied_curse")
			item.components.curseditem.cursed_target = nil
			return false
		end
		return old2(self, item)
	end
	local old3 = Cursable.ForceOntoOwner
	Cursable.ForceOntoOwner = function(self, item)
		if item and item.components.curseditem and item.components.curseditem.curse  == "MONKEY" then
			return false
		end
		return old3(self, item)
	end
end
---------------------------------------------------------------------------
---------------------------------------------------------------------------
local function onload(inst,data)
	inst:ListenForEvent('ms_respawnedfromghost', onbecamehuman)
	inst:ListenForEvent('ms_becameghost', onbecameghost)

	if inst:HasTag('playerghost') then
		onbecameghost(inst)
	else
		onbecamehuman(inst)
	end
end
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- 主/客机
local common_postinit = function(inst)
	inst:AddTag(avatar_name)
	inst.MiniMapEntity:SetIcon(avatar_name..'.tex')
end
-- 主机
local master_postinit = function(inst)	
	inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	inst.soundsname = 'wendy'
	
	inst.components.health:SetMaxHealth(TUNING[string.upper(avatar_name)..'_HEALTH'])
	inst.components.hunger:SetMax(TUNING[string.upper(avatar_name)..'_HUNGER'])
	inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 0.5) -- 调整饥饿速度
	inst.components.sanity:SetMax(TUNING[string.upper(avatar_name)..'_SANITY'])

	inst:AddComponent("dst_gi_nahida_skill") -- 添加技能组件
	inst:AddComponent("dst_gi_nahida_data") -- 添加核心数据组件
	inst:AddComponent("dst_nahida_player_wish_data") -- 抽卡数据包
	inst:AddComponent("reader") -- 添加阅读组件
	h_cursable(inst.components.cursable)-- 免疫猴子诅咒

	inst.OnLoad = onload
	inst.OnNewSpawn = onload
end
-- 人物皮肤
local function MakeDST_GI_NAHIDASkin(name, data, notemp, free)
	local d = {}
	d.rarity = '典藏'
	d.rarityorder = 2
	d.raritycorlor = { 0 / 255, 255 / 255, 249 / 255, 1 }
	d.release_group = -1001
	d.skin_tags = { 'BASE', avatar_name, 'CHARACTER' }
	d.skins = {
		normal_skin = name,
		ghost_skin = 'ghost_'..avatar_name..'_build'
	}
	if not free then
		d.checkfn = DST_GI_NAHIDA_API.DST_GI_NAHIDASkinCheckFn
		d.checkclientfn = DST_GI_NAHIDA_API.DST_GI_NAHIDASkinCheckFn
	end
	d.share_bigportrait_name = avatar_name
	d.FrameSymbol = 'Reward'
	for k, v in pairs(data) do
		d[k] = v
	end
	DST_GI_NAHIDA_API.MakeCharacterSkin(avatar_name, name, d)
	if not notemp then
		local d2 = shallowcopy(d)
		d2.rarity = '限时体验'
		d2.rarityorder = 80
		d2.raritycorlor = { 0.957, 0.769, 0.188, 1 }
		d2.FrameSymbol = 'heirloom'
		d2.name = data.name .. '(限时)'
		DST_GI_NAHIDA_API.MakeCharacterSkin(avatar_name, name .. '_tmp', d2)
	end
end
function MakeDST_GI_NAHIDAFreeSkin(name, data)
	MakeDST_GI_NAHIDASkin(name, data, true, true)
end

MakeDST_GI_NAHIDAFreeSkin(avatar_name..'_none', {
	name = '纳西妲', -- 皮肤的名称
	des = '绿色搭配粉粉的小花', -- 皮肤界面的描述
	quotes = '花开', -- 选人界面的描述
	rarity = '优雅', -- 珍惜度 官方不存在的珍惜度则直接覆盖字符串
	rarityorder = 1, -- 珍惜度的排序 用于按优先级排序 基本没啥用
	raritycorlor = { 189 / 255, 73 / 255, 73 / 255, 1 }, -- {R,G,B,A}
	skins = { normal_skin = avatar_name, ghost_skin = 'ghost_'..avatar_name..'_build' },
	build_name_override = avatar_name,
	share_bigportrait_name = avatar_name..'_none',
})

MakeDST_GI_NAHIDAFreeSkin(avatar_name..'_none1', {
	name = '纳西妲', -- 皮肤的名称
	des = '来源于小红书的大佬二创', -- 皮肤界面的描述
	quotes = '盛装', -- 选人界面的描述
	rarity = '夏半', -- 珍惜度 官方不存在的珍惜度则直接覆盖字符串
	rarityorder = 2, -- 珍惜度的排序 用于按优先级排序 基本没啥用
	raritycorlor = { 189 / 255, 73 / 255, 73 / 255, 1 }, -- {R,G,B,A}
	skins = { normal_skin = avatar_name..'_none1', ghost_skin = 'ghost_'..avatar_name..'_build' },
	build_name_override = avatar_name,
	share_bigportrait_name = avatar_name..'_none',
})

--MakeDST_GI_NAHIDAFreeSkin(avatar_name..'_none2', {
--	name = '纳西妲', -- 皮肤的名称
--	des = '来自QQ好友“念”提供的皮肤', -- 皮肤界面的描述
--	quotes = '原版', -- 选人界面的描述
--	rarity = '原版', -- 珍惜度 官方不存在的珍惜度则直接覆盖字符串
--	rarityorder = 3, -- 珍惜度的排序 用于按优先级排序 基本没啥用
--	raritycorlor = { 189 / 255, 73 / 255, 73 / 255, 1 }, -- {R,G,B,A}
--	skins = { normal_skin = avatar_name..'_none2', ghost_skin = 'ghost_'..avatar_name..'_build' },
--	build_name_override = avatar_name,
--	share_bigportrait_name = avatar_name..'_none',
--})
--
--MakeDST_GI_NAHIDAFreeSkin(avatar_name..'_furina_none1', {
--	name = '芙宁娜皮肤', -- 皮肤的名称
--	des = '', -- 皮肤界面的描述
--	quotes = '优雅', -- 选人界面的描述
--	rarity = '精致', -- 珍惜度 官方不存在的珍惜度则直接覆盖字符串
--	rarityorder = 4, -- 珍惜度的排序 用于按优先级排序 基本没啥用
--	raritycorlor = { 189 / 255, 73 / 255, 73 / 255, 1 }, -- {R,G,B,A}
--	skins = { normal_skin = avatar_name..'_furina_none1', ghost_skin = 'ghost_'..avatar_name..'_build' },
--	build_name_override = avatar_name,
--	share_bigportrait_name = avatar_name..'_none',
--})
--
--MakeDST_GI_NAHIDAFreeSkin(avatar_name..'_furina', {
--	name = '芙宁娜皮肤2', -- 皮肤的名称
--	des = '', -- 皮肤界面的描述
--	quotes = '优雅', -- 选人界面的描述
--	rarity = '精致', -- 珍惜度 官方不存在的珍惜度则直接覆盖字符串
--	rarityorder = 5, -- 珍惜度的排序 用于按优先级排序 基本没啥用
--	raritycorlor = { 189 / 255, 73 / 255, 73 / 255, 1 }, -- {R,G,B,A}
--	skins = { normal_skin = avatar_name..'_furina', ghost_skin = 'ghost_'..avatar_name..'_build' },
--	build_name_override = avatar_name,
--	share_bigportrait_name = avatar_name..'_none',
--})

--MakeDST_GI_NAHIDAFreeSkin(avatar_name..'_barbara', {
--	name = '芭芭拉皮肤', -- 皮肤的名称
--	des = '', -- 皮肤界面的描述
--	quotes = '优雅', -- 选人界面的描述
--	rarity = '精致', -- 珍惜度 官方不存在的珍惜度则直接覆盖字符串
--	rarityorder = 5, -- 珍惜度的排序 用于按优先级排序 基本没啥用
--	raritycorlor = { 189 / 255, 73 / 255, 73 / 255, 1 }, -- {R,G,B,A}
--	skins = { normal_skin = avatar_name..'_barbara', ghost_skin = 'ghost_'..avatar_name..'_build' },
--	build_name_override = avatar_name,
--	share_bigportrait_name = avatar_name..'_none',
--})



return MakePlayerCharacter(avatar_name, prefabs, assets, common_postinit, master_postinit, prefabs)