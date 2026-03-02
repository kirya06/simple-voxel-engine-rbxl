--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlockType = require(ReplicatedStorage.Shared.BlockType)
local VoxelChunk = require(ReplicatedStorage.Shared.VoxelChunk)
local VoxelWorld = require(ReplicatedStorage.Shared.VoxelWorld)

-- sorry!!! could not figure out how to use EditableMesh with those memory limits in place
local VoxelPartRenderer = {}
VoxelPartRenderer.__index = VoxelPartRenderer

type VoxelPartRendererData = {
    _models : {["string"] : Model?},
    _folder : Folder
}
export type VoxelPartRenderer = typeof(setmetatable({} :: VoxelPartRendererData, VoxelPartRenderer))


function VoxelPartRenderer.new() : VoxelPartRenderer
    local self = {}
    self._models = {}
    self._folder = Instance.new("Folder")
    self._folder.Name = "Voxel"
    self._folder.Parent = game:GetService("Workspace")

    return setmetatable(self, VoxelPartRenderer)
end


function VoxelPartRenderer.BuildChunk(self : VoxelPartRenderer, chunk : VoxelChunk.VoxelChunk)

    local model = Instance.new("Model")
    model.Name = tostring(chunk.Position)

    for x = 0, chunk.CHUNK_SIZE.X - 1, 1 do
        for y = 0, chunk.CHUNK_SIZE.Y - 1, 1 do
            for z = 0, chunk.CHUNK_SIZE.Z - 1, 1 do

                local block = chunk:GetBlock(Vector3int16.new(x, y, z))
                
                if block == BlockType.Air then
                    continue
                end

                local size = Vector3.one * VoxelWorld.BLOCK_SCALE
                local offset = Vector3.new(VoxelChunk.CHUNK_SIZE.X, 0, VoxelChunk.CHUNK_SIZE.Z) * Vector3.new(chunk.Position.X, 0, chunk.Position.Y)
                local pos = (Vector3.new(x, y, z) + offset) * size
                
                -- align properly or else it will be off-grid
                pos -= size / 2

                
                local part = Instance.new("Part")
                part.Name = "Block"
                part.Anchored = true

                part.Size = size
                part.Position = pos

                part.BrickColor = BrickColor.Green()
                part.Material = Enum.Material.SmoothPlastic
                part.TopSurface = Enum.SurfaceType.Smooth

                part.Parent = model

            end
        end
    end

    local oldModel = self._models[tostring(chunk.Position)]
    if oldModel ~= nil then
        oldModel:Destroy()
    end

    self._models[tostring(chunk.Position)] = model
    model.Parent = self._folder
end


return VoxelPartRenderer