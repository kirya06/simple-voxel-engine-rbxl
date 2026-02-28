local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local VoxelWorld = require(ReplicatedStorage.Shared.VoxelWorld)
local ChunkUpdateRemote = ReplicatedStorage.Shared.Event.ChunkUpdate

local world = VoxelWorld.new()

ChunkUpdateRemote.OnClientEvent:Connect(function(data)
    print(data)
end)

RunService.Heartbeat:Connect(function(deltaTime)
    local char = game.Players.LocalPlayer.Character
    if char then
        print(world:GetChunkFromWorldPosition(char.PrimaryPart.CFrame.Position))
    end
end)