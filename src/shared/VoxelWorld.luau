--!strict

local VoxelChunk = require(game:GetService("ReplicatedStorage").Shared.VoxelChunk)
type VoxelChunk = typeof(VoxelChunk)

local VoxelWorld = {}
VoxelWorld.__index = VoxelWorld


export type VoxelWorldData = {
    _chunks : {[Vector2int16]: VoxelChunk.VoxelChunk?}
}
export type VoxelWorld = typeof(setmetatable({} :: VoxelWorldData, VoxelWorld))


local BLOCK_STUD_SIZE = 3.5714285714


function VoxelWorld.new() : VoxelWorld
    local self = {}
    self._chunks = {}

    return setmetatable(self, VoxelWorld)
end


function VoxelWorld.IsChunkLoaded(self : VoxelWorld, pos : Vector2int16) : boolean
    return self._chunks[pos] ~= nil
end


function VoxelWorld.GenerateChunk(self : VoxelWorld, pos : Vector2int16)
    if self:IsChunkLoaded(pos) then
        return
    end
    
    self._chunks[pos] = VoxelChunk.new()

    -- TODO: have a generator class for creating worlds and stuff
end


function VoxelWorld.GetChunk(self : VoxelWorld, pos : Vector2int16) : VoxelChunk.VoxelChunk?
    local chunk = self._chunks[pos]
    return chunk
end


function VoxelWorld.GetChunks(self : VoxelWorld, point1 : Vector2int16, point2 : Vector2int16) : {[Vector2int16]: VoxelChunk.VoxelChunk?}
    -- TODO: remove it or change it or something, it's VERY hacky

    return table.clone(self._chunks)
end



function VoxelWorld.GetBlock(self : VoxelWorld, pos : Vector2int16)
    --TODO: implement
end


function VoxelWorld.SetBlock(self : VoxelWorld, Pos :Vector2int16, block : number)
    --TODO:implement
end


return VoxelWorld