---@diagnostic disable: lowercase-global, undefined-global, trailing-space

local modid = 'dst_gi_nahida'

local data = _require('core_'..modid..'/data/badges')

API.BADGE:main(data)