local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VoxelWorld = require(ReplicatedStorage.Shared.VoxelWorld)
local ChunkUpdateRemote = ReplicatedStorage.Shared.Event.ChunkUpdate

local world = VoxelWorld.new()

ChunkUpdateRemote.OnClientEvent:Connect(function(data)
    print(data)
end)