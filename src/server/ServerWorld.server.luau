--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local VoxelPartRenderer = require(script.Parent.VoxelPartRenderer)
local VoxelWorld = require(ReplicatedStorage.Shared.VoxelWorld)

local GENERATION_DISTANCE = 12


local world : VoxelWorld.VoxelWorld = VoxelWorld.new()
world.WorldGen.Seed = math.random(-2147483647, 2147483647)
local partRenderer : VoxelPartRenderer.VoxelPartRenderer = VoxelPartRenderer.new()

world.OnUpdated:Connect(function(pos : Vector2int16)
    local chunk = world:GetChunk(pos)
    assert(chunk ~= nil)

    partRenderer:GenerateChunk(chunk)
end)

RunService.Heartbeat:Connect(function()
    local players = Players:GetPlayers()
    local genSize = Vector2int16.new(GENERATION_DISTANCE, GENERATION_DISTANCE)

    local activeChunks : {Vector2int16} = {}

    for i, plr in pairs(players) do
        local char = plr.Character

        if not char then
            continue
        end

        local playerChunkPos = world:GetChunkFromWorldPosition(char.PrimaryPart.CFrame.Position)
        local playerActiveChunks = world:GetChunks(playerChunkPos, genSize)

        for i,chunk in pairs(playerActiveChunks) do
            assert(chunk ~= nil)
            table.insert(activeChunks, chunk.Position)
        end

        world:GenerateChunks(playerChunkPos, genSize)
    end
end)



-- world:GenerateChunks(INITIAL_GENERATION_CENTER, INITIAL_GENERATION_SIZE)