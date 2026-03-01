--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VoxelPartRenderer = require(script.Parent.VoxelPartRenderer)
local VoxelWorld = require(ReplicatedStorage.Shared.VoxelWorld)
local ChunkUpdateRemote = ReplicatedStorage.Shared.Event.ChunkUpdate

local INITIAL_GENERATION_RADIUS = 8
local INITIAL_GENERATION_CENTER = Vector2int16.new(0, 0)
local INITIAL_GENERATION_SIZE = Vector2int16.new(1, 1) * INITIAL_GENERATION_RADIUS

local world : VoxelWorld.VoxelWorld = VoxelWorld.new()
local partRenderer : VoxelPartRenderer.VoxelPartRenderer = VoxelPartRenderer.new()

Players.PlayerAdded:Connect(function(player : Player)

    ChunkUpdateRemote:FireClient(
        player,
        world:GetChunks(INITIAL_GENERATION_CENTER, INITIAL_GENERATION_SIZE)
    );

end)

world.OnUpdated:Connect(function(pos : Vector2int16)
    -- TODO: maybe send only some clients chunk updates, and ignore others just cause they're too far, have no character etc.
    local players = Players:GetPlayers()
    local chunk = world:GetChunk(pos)
    assert(chunk ~= nil)

    for i, plr in pairs(players) do
        ChunkUpdateRemote:FireClient(plr, {[chunk] = chunk})
    end

    partRenderer:GenerateChunk(chunk)
end)

-- preload spawn chunks
world:GenerateChunks(INITIAL_GENERATION_CENTER, INITIAL_GENERATION_SIZE)