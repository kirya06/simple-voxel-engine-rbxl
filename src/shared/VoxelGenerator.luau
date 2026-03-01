--!strict

local VoxelChunk = require(script.Parent.VoxelChunk)

local VoxelGenerator = {}
VoxelGenerator.__index = VoxelGenerator

type VoxelGeneratorData = {
    Seed : number
}
export type VoxelGenerator = typeof(setmetatable({} :: VoxelGeneratorData, VoxelGenerator))

function VoxelGenerator.new(seed : number?) : VoxelGenerator
    if seed == nil then
        seed = 0
    end

    local self = {}
    self.Seed = seed :: number

    return setmetatable(self, VoxelGenerator)
end

function VoxelGenerator.Generate(chunk : VoxelChunk.VoxelChunk)

    for x = 0, chunk.CHUNK_SIZE.X - 1, 1 do
        for z = 0, chunk.CHUNK_SIZE.Z - 1, 1 do
            chunk:SetBlock(Vector3int16.new(x, 0, z), 1)
        end
    end
    
end

return VoxelGenerator