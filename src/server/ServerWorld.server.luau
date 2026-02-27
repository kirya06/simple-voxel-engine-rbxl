--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VoxelWorld = require(ReplicatedStorage.Shared.VoxelWorld)
local ChunkUpdateRemote = ReplicatedStorage.Shared.Event.ChunkUpdate

local INITIAL_GENERATION_RADIUS = 8

local world : VoxelWorld.VoxelWorld = VoxelWorld.new()
for x = -INITIAL_GENERATION_RADIUS - 1, INITIAL_GENERATION_RADIUS - 1, 1 do
    for y = -INITIAL_GENERATION_RADIUS - 1, INITIAL_GENERATION_RADIUS - 1, 1 do

        world:GenerateChunk(Vector2int16.new(x, y))

    end
end

task.wait(1.5)

ChunkUpdateRemote:FireAllClients(
        world:GetChunks(
            Vector2int16.new(-INITIAL_GENERATION_RADIUS, -INITIAL_GENERATION_RADIUS),
            Vector2int16.new(INITIAL_GENERATION_RADIUS, INITIAL_GENERATION_RADIUS))
);