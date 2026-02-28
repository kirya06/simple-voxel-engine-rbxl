--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VoxelWorld = require(ReplicatedStorage.Shared.VoxelWorld)
local ChunkUpdateRemote = ReplicatedStorage.Shared.Event.ChunkUpdate

local INITIAL_GENERATION_RADIUS = 8
local INITIAL_GENERATION_CENTER = Vector2int16.new(0, 0)
local INITIAL_GENERATION_SIZE = Vector2int16.new(1, 1) * INITIAL_GENERATION_RADIUS

local world : VoxelWorld.VoxelWorld = VoxelWorld.new()
world:GenerateChunks(INITIAL_GENERATION_CENTER, INITIAL_GENERATION_SIZE)

task.wait(1.5)

ChunkUpdateRemote:FireAllClients(
    world:GetChunks(INITIAL_GENERATION_CENTER, INITIAL_GENERATION_SIZE)
);