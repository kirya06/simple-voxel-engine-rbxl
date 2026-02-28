--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local VoxelChunk = require(ReplicatedStorage.Shared.VoxelChunk)
local VoxelWorld = require(ReplicatedStorage.Shared.VoxelWorld)
local ChunkUpdateRemote = ReplicatedStorage.Shared.Event.ChunkUpdate

local world = VoxelWorld.new()

ChunkUpdateRemote.OnClientEvent:Connect(function(data : {[Vector2int16] : VoxelChunk.VoxelChunk})

    for pos, chunk in pairs(data) do
        world:SetChunk(pos, chunk)
    end

end)

RunService.Heartbeat:Connect(function(deltaTime)
    local char = game.Players.LocalPlayer.Character
    if char then
        print(world:GetChunkFromWorldPosition(char.PrimaryPart.CFrame.Position))
    end
end)