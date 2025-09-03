-- 功能(无需修改): 判断某个mod有没有开启 的前置

-- 其实是为了模糊搜索才写的这个,如果只是通过文件夹名字判断的话 ModIndex:IsModEnabledAny 即可
-- 调用 SUGAR_dst_gi_nahida:checkMODEnabledByFolderName 来判断即可

if TUNING.MOD_DST_GI_NAHIDA.MOD_LIST == nil then
    TUNING.MOD_DST_GI_NAHIDA.MOD_LIST = {}
end
TUNING.MOD_DST_GI_NAHIDA.MOD_LIST.map_dirname = {}
TUNING.MOD_DST_GI_NAHIDA.MOD_LIST.map_modinfoname = {}
if TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD_LIST == nil then
    TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD_LIST = {}
end
if TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD == nil then
    TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD = {}
end

local moddir = KnownModIndex:GetModsToLoad()
for _, dir in pairs(moddir) do
    TUNING.MOD_DST_GI_NAHIDA.MOD_LIST.map_dirname[dir] = true
    local info = KnownModIndex:GetModInfo(dir)
    local name = info and info.name or "unknow"
    table.insert(TUNING.MOD_DST_GI_NAHIDA.MOD_LIST.map_modinfoname,name)
end

local moddir_v2 = KnownModIndex:GetModsToLoad(true)
local enablemods = {}
TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD_LIST = {
    FUNCTIONAL_MEDAL = "1909182187", -- 勋章
    UNCOMPROMISING_MODE = "2039181790", -- 妥协
    SHADOW_WORLD = "2886753796", -- 为爽而虐
    KEQING = "3199945184", -- 刻晴
    SHIPWRECKED = "1467214795", -- 海滩
}
TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD = {
    FUNCTIONAL_MEDAL = false, -- 勋章
    UNCOMPROMISING_MODE = false, -- 妥协
    SHADOW_WORLD = false, -- 为爽而虐
    KEQING = false, -- 刻晴
    SHIPWRECKED = false, -- 海滩
}

for k, dir in pairs(moddir_v2) do
    local info = KnownModIndex:GetModInfo(dir)
    local name = info and info.name or "unknow"
    enablemods[dir] = name
end

-- 检查并更新启用状态
for mod_name, mod_id in pairs(TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD_LIST) do
    for dir, name in pairs(enablemods) do
        if dir:match(mod_id) or name:match(mod_id) then
            TUNING.MOD_DST_GI_NAHIDA.ENABLED_MOD[mod_name] = true
            break
        end
    end
end