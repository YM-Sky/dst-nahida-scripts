---@diagnostic disable: lowercase-global, undefined-global, trailing-space

local modid = 'dst_gi_nahida'

local data,data2 = _require('core_'..modid..'/data/recipes')

API.RECIPE:addRecipeFilter(string.upper(modid),"images/inventoryimages/dst_gi_nahida.xml","dst_gi_nahida.tex","[Nahida]纳西妲")
API.RECIPE:main(data,data2)
