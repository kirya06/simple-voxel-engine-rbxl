--!strict

local VoxelChunk = require(game:GetService("ReplicatedStorage").Shared.VoxelChunk)
type VoxelChunk = typeof(VoxelChunk)

local VoxelWorld = {}
VoxelWorld.__index = VoxelWorld


export type VoxelWorldData = {
    Chunks : {[Vector2int16]: VoxelChunk.VoxelChunk}
}
export type VoxelWorld = typeof(setmetatable({} :: VoxelWorldData, VoxelWorld))
type Self = VoxelWorld



function VoxelWorld.new() : VoxelWorld
    local self = setmetatable({}, VoxelWorld)

    self.Chunks = {}

    return self
end


function VoxelWorld.GenerateChunk(self : Self, pos : Vector2int16)
    
    if not self.Chunks[pos] then
        return
    end

    self.Chunks[pos] = VoxelChunk.new()

    -- TODO: have a generator class for creating worlds and stuff
end

function VoxelWorld.GetBlock(self : Self, pos : Vector2int16)
    --TODO: implement
end

function VoxelWorld.SetBlock(self : Self, Pos :Vector2int16, block : number)
    --TODO:implement
end


return VoxelWorld