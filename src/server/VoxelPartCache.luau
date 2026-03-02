--!strict

local Workspace = game:GetService("Workspace")

-- class that allows creating, removing and reusing parts for later purposes
local VoxelPartCache = {}
VoxelPartCache.__index = VoxelPartCache

type VoxelPartCacheData = {
    _cache : {Part},
    _template : Part,
    _cacheParent : Folder
}

export type VoxelPartCache = typeof(setmetatable({} :: VoxelPartCacheData, VoxelPartCache))

function VoxelPartCache.new(initialSize : number) : VoxelPartCache

    local self = {}
    self._cache = {}

    self._template = Instance.new("Part")
    self._template.Name = "Block"
    self._template.Anchored = true
    self._template.CanCollide = false
    self._template.Transparency = 1

    self._cacheParent = Instance.new("Folder")
    self._cacheParent.Name = "PartCache"
    self._cacheParent.Parent = Workspace

    
    local metatable = setmetatable(self, VoxelPartCache)
    metatable:_addToCache(initialSize)

    return metatable
end


function VoxelPartCache._addToCache(self : VoxelPartCache, amount : number)
    for i = 1, amount, 1 do
        local clone = self._template:Clone()
        clone.Parent = self._cacheParent
        table.insert(self._cache, clone)
    end
end


function VoxelPartCache.Pull(self : VoxelPartCache) : Part
    if (#self._cache) <= 0 then
        self:_addToCache(1)
    end

    assert(#self._cache > 0)

    local part = self._cache[#self._cache]
    table.remove(self._cache, #self._cache)

    return part
end

function VoxelPartCache.Push(self : VoxelPartCache, part : Part)
    part.CanCollide = false
    part.Anchored = true
    part.Transparency = 1
    part.CFrame = CFrame.new()
    part.Parent = self._cacheParent

    table.insert(self._cache, part)
end



return VoxelPartCache