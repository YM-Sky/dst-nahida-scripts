---------------------------------------------------------------------------------------------------------------------
------------------这个文件出自风铃草大佬之手,在此基础上勋章做出了一定的修改,感谢风铃草大佬~--------------------------------
---------------------------------------------------------------------------------------------------------------------
--这种方式对FindEntity等地方的调用无效,仅适用于解锁配方、标签判断等比较常规的场景
local Tags = {}--强制覆盖原标签及对应方法
local Hash_To_Tags = {}--哈希对照表(把哈希值转化回对应的tag)
local key = "dst_gi_nahida_fixtag" -- 默认用modname 做key 防止冲突

if TUNING.MoreTagsReg == nil then
    TUNING.MoreTagsReg = {}
end
function RegTag(tag) -- 必须先注册 主客机一起注册 注册后的tag会被截留
    tag = string.lower(tag)
    if not TUNING.MoreTagsReg[tag] then--全局判断，如果别的mod注册过了就没必要继续了
        TUNING.MoreTagsReg[tag] = key
        Tags[tag] = true
        Hash_To_Tags[hash(tag)] = tag--存入哈希对照表
    end
end

-------------------草神特有标签-----------------
local dst_gi_nahida_unique_tags={
	"dst_gi_nahida", -- 角色标签
	"nahida_not_hatred", -- 无仇恨标签
	"dst_gi_nahida_no_steal", -- 不会被火药猴偷取
    "dst_gi_nahida_right_click_action", -- 兼容富贵右键动作开关标签
    "dst_gi_nahida_chesspiece", -- 雕像标签
    "dst_gi_nahida_fish", -- 鱼类标签
    "dst_gi_nahida_seed_of_skandha", -- 蕴种印标签
    "dst_gi_nahida_illusory_heart_buff0", -- 命座 0命标签
    "dst_gi_nahida_illusory_heart_buff1", -- 命座 1命标签
    "dst_gi_nahida_illusory_heart_buff2", -- 命座 2命标签
    "dst_gi_nahida_illusory_heart_buff3", -- 命座 3命标签
    "dst_gi_nahida_illusory_heart_buff4", -- 命座 4命标签
    "dst_gi_nahida_illusory_heart_buff5", -- 命座 5命标签
    "dst_gi_nahida_illusory_heart_buff6", -- 命座 6命标签
    "dst_gi_nahida_fateseat_level_1", -- 命座 1命标签
    "dst_gi_nahida_fateseat_level_2", -- 命座 2命标签
    "dst_gi_nahida_fateseat_level_3", -- 命座 3命标签
    "dst_gi_nahida_fateseat_level_4", -- 命座 4命标签
    "dst_gi_nahida_fateseat_level_5", -- 命座 5命标签
    "dst_gi_nahida_fateseat_level_6", -- 命座 6命标签
    "dst_gi_nahida_add_distance", -- 命座 6命标签
    -------------------------------原版标签----------------------------------
    "reader",  -- 读书组件
    "bookbuilder",  -- 书架制造
    "stronggrip",  -- 武器工具不脱手
    "plantkin",  -- 植物人能力
    "eyeplant_friend",  -- 眼球草友好
    "shadowmagic",  -- 可以制造暗影秘典
    "dappereffects",  -- 可以使用暗影秘典
    "fastbuilder",  -- 快速制造能力
    "polite",  -- 有此标签的角色雇佣
    "noattack",  -- 无法选中标签
    "heavyarmor",  -- 免疫控制标签
}
for _,v in ipairs(dst_gi_nahida_unique_tags) do
	RegTag(v)
end


-------------------------------------------------------相关方法-------------------------------------------------------
local function AddTag(inst, stag, ...)
    if not inst or not stag then return end
    local tag = type(stag)=="number" and Hash_To_Tags[stag] or string.lower(stag)--如果是哈希值则从哈希值转回字母tag
    if Tags[tag] then
        if inst[key].Tags and inst[key].Tags[tag] then
            inst[key].Tags[tag]:set_local(false)
            inst[key].Tags[tag]:set(true)
        end
    else
        return inst[key].AddTag(inst, stag, ...)
    end
end

local function RemoveTag(inst, stag, ...)
    if not inst or not stag then return end
    local tag = type(stag)=="number" and Hash_To_Tags[stag] or string.lower(stag)--如果是哈希值则从哈希值转回字母tag
    if Tags[tag] then
        if inst[key].Tags and inst[key].Tags[tag] then
            inst[key].Tags[tag]:set_local(true)
            inst[key].Tags[tag]:set(false)
        end
    else
        return inst[key].RemoveTag(inst, stag, ...)
    end
end

local function HasTag(inst, stag, ...)
    if not inst or not stag then return end
    local tag = type(stag)=="number" and Hash_To_Tags[stag] or string.lower(stag)--如果是哈希值则从哈希值转回字母tag
    if Tags[tag] and inst[key].Tags and inst[key].Tags[tag] then
        return inst[key].Tags[tag]:value()
    else
        return inst[key].HasTag(inst, stag, ...)
    end
end

local function HasTags(inst,...)
    local tags = select(1, ...)
    if type(tags) ~= "table" then
        tags = {...}
    end
    for _,v in ipairs(tags) do
        if not HasTag(inst, v) then return false end
    end
    return true
end

local function HasOneOfTags(inst,...)
    local tags = select(1, ...)
    if type(tags) ~= "table" then
        tags = {...}
    end
    for _,v in ipairs(tags) do
        if HasTag(inst, v) then return true end
    end
    return false
end

local function AddOrRemoveTag(inst,stag,condition,...)
    if not inst or not stag then return end
    local ltag = type(stag)=="number" and Hash_To_Tags[stag] or string.lower(stag)--如果是哈希值则从哈希值转回字母tag
    if Tags[ltag] then 
        if condition then 
            AddTag(inst,ltag,...)
        else
            RemoveTag(inst,ltag,...)
        end
    else
        return inst[key].AddOrRemoveTag(inst,stag,condition,...)
    end
end

function FixTag(inst) -- 传入实体 主客机一起调用
    inst[key] = {
        AddTag = inst.AddTag,
        HasTag = inst.HasTag,
        RemoveTag = inst.RemoveTag,
        HasTags = inst.HasTags,
        HasOneOfTags = inst.HasOneOfTags,
        AddOrRemoveTag = inst.AddOrRemoveTag,
        Tags = {}
    }
    inst.AddTag = AddTag
    inst.HasTag = HasTag
    inst.RemoveTag = RemoveTag
    inst.HasTags = HasTags
    inst.HasOneOfTags = HasOneOfTags
    inst.HasAllTags = HasTags
    inst.HasAnyTag = HasOneOfTags
    inst.AddOrRemoveTag = AddOrRemoveTag

    for k, _ in pairs(Tags) do
        inst[key].Tags[k] = net_bool(inst.GUID, key .. "." .. k, GUID, key .. "." .. k .. "dirty")
        if inst[key].HasTag(inst, k) then
            inst[key].RemoveTag(inst, k)
            inst[key].Tags[k]:set_local(false)
            inst[key].Tags[k]:set(true)
        else
            inst[key].Tags[k]:set(false)
        end
    end

end

AddPlayerPostInit(function(inst) -- 默认只扩展人物的
    FixTag(inst)
end)

-- return {
-- RegTag = RegTag, -- 用于注册tag   --需要主客机一起调用 注册后的tag会被截留
-- FixTag = FixTag -- 用来扩展实体的tag槽位
-- }