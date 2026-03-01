--!strict

local VoxelChunk = require(script.Parent.VoxelChunk)

local VoxelGenerator = {}
VoxelGenerator.__index = VoxelGenerator

type VoxelGeneratorData = {
    Seed : number,
    Scale : number
}
export type VoxelGenerator = typeof(setmetatable({} :: VoxelGeneratorData, VoxelGenerator))

function VoxelGenerator.new(seed : number?) : VoxelGenerator
    if seed == nil then
        seed = 0
    end

    local self = {}
    self.Seed = seed :: number
    self.Scale = 32

    return setmetatable(self, VoxelGenerator)
end

function VoxelGenerator.Generate(self : VoxelGenerator, chunk : VoxelChunk.VoxelChunk)

    for x = 0, chunk.CHUNK_SIZE.X - 1, 1 do
        for z = 0, chunk.CHUNK_SIZE.Z - 1, 1 do
            local block = 
                Vector3.new(chunk.CHUNK_SIZE.X, chunk.CHUNK_SIZE.Y, chunk.CHUNK_SIZE.Z) * Vector3.new(chunk.Position.X, 0, chunk.Position.Y)  + Vector3.new(x, 16, z)
            
            local offset = math.noise(block.X / self.Scale, math.floor(self.Seed), block.Z / self.Scale)
            offset = math.max(offset, -0.3)
            offset = math.floor(offset / 0.1)

            chunk:SetBlock(Vector3int16.new(x , 16 + offset, z), 1)
        end
    end
    
end

return VoxelGenerator