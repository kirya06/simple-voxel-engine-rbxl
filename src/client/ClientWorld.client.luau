--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VoxelChunk = require(ReplicatedStorage.Shared.VoxelChunk)
local VoxelWorld = require(ReplicatedStorage.Shared.VoxelWorld)

local ChunkUpdateRemote = ReplicatedStorage.Shared.Event.ChunkUpdate

local world = VoxelWorld.new()

world.OnUpdated:Connect(function(pos : Vector2int16)
    local chunk = world:GetChunk(pos)
    assert(chunk ~= nil)
end)


ChunkUpdateRemote.OnClientEvent:Connect(function(data : {[Vector2int16] : VoxelChunk.VoxelChunk})

    for pos, chunk in pairs(data) do
        world:SetChunk(pos, chunk)
        -- print(pos)
    end
end)