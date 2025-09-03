---@diagnostic disable: lowercase-global, undefined-global, trailing-space

local modid = 'dst_gi_nahida'

local data,change = _require('core_'..modid..'/data/componentactions')

API.CA:main(data,change)