---@diagnostic disable: inject-field
-- 皮肤API
GLOBAL.DST_GI_NAHIDA_API = env

local avatar_name = 'dst_gi_nahida'

local modid = 'dst_gi_nahida'

table.insert(PrefabFiles, 'avatar_'..avatar_name)

local assets_avatar = {
    Asset('ATLAS', 'images/saveslot_portraits/'..avatar_name..'.xml'),

	Asset('ATLAS', 'images/selectscreen_portraits/'..avatar_name..'.xml'),

	Asset('ATLAS', 'images/selectscreen_portraits/'..avatar_name..'_silho.xml'),

	Asset('ATLAS', 'bigportraits/'..avatar_name..'.xml'),

	Asset('ATLAS', 'images/map_icons/'..avatar_name..'.xml'),

	Asset('ATLAS', 'images/avatars/avatar_'..avatar_name..'.xml'),

	Asset('ATLAS', 'images/avatars/avatar_ghost_'..avatar_name..'.xml'),

	Asset('ATLAS', 'images/avatars/self_inspect_'..avatar_name..'.xml'),

	Asset('ATLAS', 'images/names_'..avatar_name..'.xml'),
	
    Asset( 'ATLAS', 'bigportraits/'..avatar_name..'_none.xml' ),
}

for _,v in pairs(assets_avatar) do
    table.insert(Assets, v)
end

--[[---注意事项
1. 目前官方自从熔炉之后人物的界面显示用的都是那个椭圆的图
2. 官方人物目前的图片跟名字是分开的 
3. 用打包工具生成好tex后
	bigportraits/xxx_none.xml 中 Element name 加上后缀 _oval
    images/names_xxx.xml 中 Element name 去掉前缀 names_
]]


modimport('scripts/api_skins/'..avatar_name..'_skins') -- 皮肤api
TUNING.MOD_ID = modid
TUNING.AVATAR_NAME = avatar_name
-- 初始物品
TUNING.DST_GI_NAHIDA_CUSTOM_START_INV = {
	 ['dst_gi_nahida_thousand_floating_dreams'] = {
	 	num = 1, -- 数量
	 	moditem = true, -- 是否为mod物品
	 	 --img = {atlas = 'images/inventoryimages/dst_gi_nahida_thousand_floating_dreams.xml', image = 'dst_gi_nahida_thousand_floating_dreams.tex'},
	 },
	 --['dst_gi_nahida_spellbook'] = {
		-- num = 1, -- 数量
		-- moditem = true, -- 是否为mod物品
	 --}
}

TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT[string.upper(avatar_name)] = {}
for k,v in pairs(TUNING.DST_GI_NAHIDA_CUSTOM_START_INV) do
	table.insert(TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT[string.upper(avatar_name)], k)
	if v.moditem then
		TUNING.STARTING_ITEM_IMAGE_OVERRIDE[k] = {
			atlas = v.img and v.img.atlas or "images/inventoryimages/"..k..".xml",
			image = v.img and v.img.image or k..".tex",
		}
	end
end


-- 角色注册
AddMinimapAtlas("images/map_icons/"..avatar_name..".xml")
-- 地图贴图
AddMinimapAtlas("images/map_icons/dst_gi_nahida_ice_box.xml")
AddMinimapAtlas("images/map_icons/dst_gi_nahida_coconut_tree.xml")
AddMinimapAtlas("images/map_icons/dst_gi_nahida_treasure_chest.xml")
AddMinimapAtlas("images/map_icons/dst_gi_nahida_toy_chest.xml")
AddMinimapAtlas("images/map_icons/dst_gi_nahida_gacha_machine.xml")
AddMinimapAtlas("images/map_icons/dst_gi_nahida_shipwrecked_boat.xml")

AddModCharacter(avatar_name, "FEMALE") 

-- 三维
TUNING[string.upper(avatar_name)..'_HEALTH'] = 150
TUNING[string.upper(avatar_name)..'_HUNGER'] = 150
TUNING[string.upper(avatar_name)..'_SANITY'] = 300


local avatar_info = {
	['cn'] = {
		-- 选人界面的描述
		titles = "小吉祥草王",
		names = "纳西妲",
		descriptions = "是一位温柔的神明",
		quotes = "*纳西妲\n*可爱*\n智慧的",
		survivability = "可爱",
		-- 描述
		myname = '纳西妲', -- 角色名
		others_desc_me = [[过于专注也好，过于溺爱也罢，行为虽有瑕疵，但我认可她。作为须弥神明的责任感。最年轻之神尚能如此，
反观某个歇斯底里的家伙...]], -- 其他人描述我
		me_desc_another_me = [[神明只送给人类填饱肚子的知识，人类却借此制作了工具，书写了文字，壮大了城邦，现在又放眼星辰与深渊.他们每时每刻都在创造全新
的「知识」，也令我再也无法移开双眼。]], -- 自己描述自己
	},
	['en'] = {
		-- 选人界面的描述
		titles = "小吉祥草王",
		names = "纳西妲",
		descriptions = "是一位温柔的神明",
		quotes = "\'纳西妲\'",
		survivability = "可爱",
		-- 描述
		myname = '纳西妲', -- 角色名
		others_desc_me = [[过于专注也好，过于溺爱也罢，行为虽有瑕疵，但我认可她。作为须弥神明的责任感。最年轻之神尚能如此，
反观某个歇斯底里的家伙...]], -- 其他人描述我
		me_desc_another_me = [[神明只送给人类填饱肚子的知识，人类却借此制作了工具，书写了文字，壮大了城邦，现在又放眼星辰与深渊.他们每时每刻都在创造全新
的「知识」，也令我再也无法移开双眼。]], -- 自己描述自己
	},
}

STRINGS.CHARACTER_TITLES[avatar_name] = avatar_info[TUNING[string.upper('CONFIG_'..modid..'_LANG')]].titles
STRINGS.CHARACTER_NAMES[avatar_name] = avatar_info[TUNING[string.upper('CONFIG_'..modid..'_LANG')]].names
STRINGS.CHARACTER_DESCRIPTIONS[avatar_name] = avatar_info[TUNING[string.upper('CONFIG_'..modid..'_LANG')]].descriptions
STRINGS.CHARACTER_QUOTES[avatar_name] = avatar_info[TUNING[string.upper('CONFIG_'..modid..'_LANG')]].quotes
STRINGS.CHARACTER_SURVIVABILITY[avatar_name] = avatar_info[TUNING[string.upper('CONFIG_'..modid..'_LANG')]].survivability

if STRINGS.CHARACTERS.DST_GI_NAHIDA == nil then
    STRINGS.CHARACTERS.DST_GI_NAHIDA = {}
end

if STRINGS.CHARACTERS.DST_GI_NAHIDA.DESCRIBE == nil then
    STRINGS.CHARACTERS.DST_GI_NAHIDA.DESCRIBE = {}
end

STRINGS.NAMES.DST_GI_NAHIDA = avatar_info[TUNING[string.upper('CONFIG_'..modid..'_LANG')]].myname
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DST_GI_NAHIDA = avatar_info[TUNING[string.upper('CONFIG_'..modid..'_LANG')]].others_desc_me
STRINGS.CHARACTERS.DST_GI_NAHIDA.DESCRIBE.DST_GI_NAHIDA = avatar_info[TUNING[string.upper('CONFIG_'..modid..'_LANG')]].me_desc_another_me